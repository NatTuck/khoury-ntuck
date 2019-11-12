---
layout: default
---

## First Thing

Project questions?

# Testing Web Applications

Automated testing is an important tool for making sure that your app does what
you want it to do.

Generally, automated tests provide value in two cases:

 - When you're adding functionality to your app, tests can help make sure that
   functionality is implmented correctly.
 - When you're making changes, tests can help avoid breaking existing
   functionality.

That second part is the really important thing. Especially when you're working
on a team, tests are a way to make sure that when you write a feature that
feature surives through other people modifying the code.

Tests are generally written as functions in separate files from you main
application code that cause your main code to be run and check that it behaved
as expected.

For our Elixir/Phoenix + JavaScript setup, we need to worry about two seperate
sets of tests: One for our Elixir code, another for our JavaScript code. We also
want to make sure our Elixir and JS code are tested together.

As examples, we'll be looking at two different applications:

 * Inkfish
 * The SPA version of Lens

## Testing Elixir Code

These examples are looking concretely at Elixir with Phoenix, but the same
testing structure is common across many different languages and frameworks.

First, let's clone the Inkfish repository:

```
$ git clone https://github.com/NatTuck/inkfish
```

Then let's run the tests:

```
$ cd inkfish
$ mix test
```

This runs about 220 tests in about three seconds.

Inkfish is a little different from the apps we've been writing in that it's
structured as an Elixir "umbrella" application. That means it's seperated into
multiple OTP "applications" - the tests for "inkfish" and "inkfish_web" run
seperately. This allows the core Inkfish to run (and be built into a release)
without the Web UI at the cost of some added complexity.

In this application we have three different kinds of tests:

### Simple Unit Tests:

 * Show apps/sandbox/lib/sandbox/shell.ex
 * Show apps/sandbox/test/sandbox_test.exs
 * We have one test for this function, there are two possible
   kinds of result due to the if expression.
 * We should have another test.

```
  test "run a script that fails" do
    assert Sandbox.Shell.run_script("false") == {:error, "false"}
  end
```

When we run "mix test", we'll see a test failure in the sandbox app.

If we want to run just that one file of tests, we can do:

```
mix test apps/sandbox/test/sandbox_test.exs
```

Once we've fixed the test, we can rerun our tests and see it succeed.

Unit tests are especially easy when we're testing a pure function. All we care
about in that case is that for a given input we get the right output.

In the case of this Shell test, it's not really a pure function - we're
executing a shell command - but we can make it effectively pure by running
commands without side effects.

But for this particular function, side effects are the main purpose. We're
running shell commands to *do stuff*. So we should probably have a test that
makes sure that works.

```
  test "create a file with a script" do
    nn = 999 + :rand.uniform(1000)
    file = "/tmp/file.#{nn}"

    assert !File.exists?(file)
    assert Sandbox.Shell.run_script("touch #{file}") == :ok
    assert File.exists?(file)
    File.rm(file)
    assert !File.exists?(file)
  end
```

### Context Module Unit Tests

In our Phoenix apps, we generally manipulate the database using functions in
context modules. We'd like to be able to unit tests these functions.

Conceptually this is slightly complicated because we don't really want to modify
our database every time we run our tests.

Luckily, the test setup Phoenix gives us avoids most of that problem, as
follows:

 * We have a dedicated test database to run tests in.
 * Tests, by default, run inside DB transactions. After the test has completed,
   the transaction is rolled back, resulting in no persistent change to the DB.
 * This allows multiple tests to run concurrently - since transactions are
   isolated, different tests won't see each other's changes.

There's one more complicaton: Fixtures

Some functionality can be tested in isolation. To test inserting a User, you can
construct a User, insert it, and then verify that it was inserted correctly.

But other functionality requires existing data. To update a User, there first
must be a User in the DB. 

A common approach is to seed the database with a bunch of test data. This works
well, but as your database structure gets more complicated you can end up
needing to maintain a *lot* of test data. 

If one test requires a user who is an admin, registered in December, and made
exactly three submissions to two courses, that user must appear in the seed
data. Worse, as the tests change it's hard to keep track of which tests depend
on that particular set of records.

An alternative is to programatically generate records that are needed for tests
using a "factory" module. Inkfish uses a combination of these techniques, with
some pre-seeded data and the rest created using a factory module.

 * Show apps/inkfish/test/support/factory.ex

Let's look specifically at "assignments":

 - We construct an assignment object with default fields. These
   can be overridden by the consumer.
 - Assignments belong to buckets and teamsets, which both belong to the
   same course, so we need to explicitly construct this subgraph.

Another example is "team_member":

 - This constructs a new team and reg.
 - This implies a structure
   - team -> teamset -> course
   - reg -> course
 - Since the code doesn't explicitly specify, this probably ends up being
   two seperate newly created courses. Hopefully that doesn't break any
   tests that construct a team_member.

Now that we've seen how we're going to build test data, let's look at a context
module. Specifically, let's look at .../assignments.ex:

 - We've got some stuff in here with complex logic, let's skip it.
 - Moving down to "update\_assignment", this is the default scaffolding
   code from phx.gen.html.
   
Looking at .../assignments\_test.exs:

 - assigment_fixture calls our factory helper to insert an arbitrary
   assignment into the DB
 - Then we generate a params map with exactly one changed attribute
 - Then we call the update function we're testing
 - Then we verify that the values returned by the update function are correct.

This assumes that the update function correctly returns the new value. If we're
a little less trusting, we might want to refetch the item and check it.

### Controller Tests

Unit tests verify that single functions are correct, but we also want to make
sure that larger pieces of our application work as expected.

With Phoenix apps, the externally visible interface we're exposing is the
ability to make HTTP requests to paths in our application.

Controller tests test our application at this scale. We simulate an incoming
request, causing our pipeline plugs and controller action to be called, and then
verify that the response is correct.

Controller actions may modify the database, so these tests are again performed
in a transaction so the changes can be reverted when they're done.

Let's look at .../assignment_controller.ex:

 - One action: show
 - This is for normal users, that's the only available action.
 - To show a user an assignment, we first need to get:
   - The assignment
   - The user's submissions
   - The user's team
 - Then we can render the template.

To test this, let's look at .../assignment\_controller_test.ex:

 - First we create an assignment.
 - Then we login as a user (by faking a sesison)
 - Then we GET the assignment's path.
 - This tests the router, plugs, controller, referenced contexts, and templates.

Do we need context module unit tests if we have controller tests?

 - It depends.
 - Controller tests can potentially test the paths through the code
   that can currently be exercised.
 - Context unit tests can test the internal interface, possibly including
   code that isn't yet accessible.
 - Context unit tests can be easier to debug, and allow us to quickly test
   more cases for things like changeset validations.
 - If you need to pick only one, I'd go with controller tests. That's what's
   going on in a bunch of cases with Inkfish.

### Integration Tests

 - Controller tests test a single path, but that's not how users will actually
   use your application. They'll use several paths in a sequence, each one of
   which may change the application state in a way that the next path depends
   on.
 - This can be tested with integration tests.

With Elixir + Phoenix, we have two approaches for integration tests. Depending
on our application, we may want to use either or both.

#### Simulated Integration Tests

 - These are basically the same as controller tests, except:
 - They allow us to simulate user actions on the rendered pages, such as
   clicking links.
 - They maintain state for several steps.

Properties:

 - Similarly fast to controller tests.
 - No need for external tools.
 - Everything is still being simulated inside the Erlang VM. There's still no
   real web server or browser involved.
 - It won't execute JavaScript. That restricts it to standard page loading, link
   following, and form submissions.

Phoenix apps don't come with this test type built in, but it's provided by the
"phoenix_integration" library.

Example in .../integration/request\_reg\_test.exs:

 - Bob is the instructor; Gail isn't registered. 
 - First we log in as gail and make the request.
 - Then we log in as bob and approve it.
 - Then we log in as gail to confirm we have access to the course.

 - We provide test instructions as if we were users interacting with the site,
   using functions like "follow link". 
 - We're able to test an entire workflow, make sure we go through the right
   sequence of pages, and confirm that changes to the DB have the expected effect. 

#### Full Integration tests

Testing our Elixir code is great, but at a certain point we want to be able to
verify that:

 - The site works in a real browser.
 - We can do workflows that involve JavaScript code.

Again, this isn't provided by default in Phoenix apps. But we have two choices
for libraries to do this kind of testing:

 - wallaby
 - hound

Wallaby is focused on fast testing using a windowless browser called phantomjs.
This is a good idea. It also has a more "batteries-included" API than Hound.

We're using Hound. It exposes the flavor of Selenium a bit more directly, and I
found documentation to get it working with Firefox faster.

Before we can run this kind of test, we need to set up the mechanism that
actually automates the browser. A common tool for that is Selenium.

Let's take a look at .../test/selenium.sh:

 - This script downloads two files.
 - Selenium-server is the program that handles automating a browser.
 - Gecko-Driver is the connector that hooks it specifically to Firefox.
 - Selenium-server needs to be running when we run our Hound tests.

Let's take a look at .../integration/submit_test.exs:

 - This test logs in and submits a Git repo to an assignment.
 - It does this by popping up a Firefox window.
 - We need a JS-executing browser here, because the mechanism for creating
   a new upload and associating it with a submission is handled in JS.

Looking through the test code, there's a bunch going on:

 - Ecto's testing sandbox allows tests to run concurrently by tying database
   handles to a specific Erlang process. This doesn't work here - the process
   that clones the git repo and creates the upload runs seperately. This means
   that in order to maintain the transaction behavior, this test can't run
   concurrently with any other test.
 - Another option would be to ditch the sandbox, which might let us do tests
   concurrently, but would mean we'd actually be mutating the DB during the test run.
 - We need to start and then end the Hound session - that's what pops up the
   Firefox window.
 - Hound provides a somewhat minimal, procedural API, so we need some helper
   functions for this test.
 - Specifically, we want to be able to perform actions - especially initiating
   the git clone - and then wait for them to complete. We do this by polling the
   page text to see if we have what we want yet.
 - With all that set up, the test itself looks a lot like the previous
   integration test - we navigate through the site like a user until we get to
   the point where we've demonstrated that the workflow seems to work.



## Resources

 - https://github.com/elixir-wallaby/wallaby
 - https://github.com/HashNuke/hound
 - https://github.com/boydm/phoenix_integration
 - https://jestjs.io/





