---
layout: default
---

# NuMart Git Repo

https://github.com/NatTuck/nu_mart

Branches:

 - prep-1005   - Prep for this class

## JSON API + AJAX

 - Look at /api/v1/reviews
 - Look at /api/v1/reviews?product_id=2
 - Walk through the app.js code in detail.

## Deploy Script

 - Deploy app to server.
 - Current nu\_mart deploy process:
   - Push working code to github.
   - Pull code on server.
   - Run deploy script.
 - Walk through deploy script.

## Continuous Integration
 - Several options, including self hosted.
 - travis-ci.org is easy for public repos.
 - Login with github auth and flip the switch.
 - Push add a .travis.yml config file to repo.

## Testing with Elixir / Phoenix

 - First, verify that config/test.exs is reasonable.
 - Then, "mix test" runs the project tests.
 - It's useful to think of tests as being in three
   categories:
  - DB tests test context modules.
  - Controller test test single controller actions.
  - Integration tests test "user story" sized pieces,
    and aren't auto-generated. They require some sort
    of automated web browser.
- Controller tests are really simple. You just run the
  pipeline, controller, and view on a simulated conn
  structure and verify that they produce a conn structure
  with the expected properties.

## Test Data

A web app mutates a database. That means we need test data to
start from.

Two solutions:

 - Fixtures: Constant test data.
 - Factories: Functions that procedurally generate test data.

Factories are nicer. https://github.com/thoughtbot/ex_machina

We get fixtures by default because they're simpler.

## Fixing nu\_mart tests

Elixir test library: https://hexdocs.pm/ex_unit/ExUnit.html

Phoenix test helpers: https://hexdocs.pm/phoenix/Phoenix.ConnTest.html

 - Running the tests gives 33 failures.
 - We've got to fix them one test at a time.
 - Can run single test file with
 
 ```
 $ mix test test/nu_mart_web/controllers/page_controller_test.exs
 ```

Can run a single *test* by specfiying the line number.

```
$ mix test test/nu_mart_web/controllers/page_controller_test.exs:6
```

Fix the tests so they pass.
 
 
 


