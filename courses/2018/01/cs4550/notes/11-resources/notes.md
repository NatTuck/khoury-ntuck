---
layout: default
---

# First: Assignments

 - Pushed back HW due date: Tuesday for now.
   - Pro: More time after Friday lecture to finish assignment.
   - Con: Lecture before due date will be on new, unrelated material.
 - New Homework: Make an Time Tracker app
 - Project Prep: Swap / Confirm Partner, Select game to build

# Building an App

## What we're building

 - A Microblog
 - Kind of like twitter, without the character limit.

## How we're building it

 - A conventional server-side web app
 - Stock Phoenix framework stuff
 - PostgreSQL database

## Creating the App

```
$    # New app
$ mix phx.new microblog
$    # Create DB user
$ sudo su - postgres
postgres$ pwgen 12 1
...
postgres$ createuser -d -P microblog
password: <paste>
$ exit
```

How to change DB password if we mess stuff up:

```
postgres$ psql
postgres=# alter user microblog with password '...';
```

Config database: config/dev.exs

```
config :microblog, Microblog.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "microblog",
  password: "...",
  database: "microblog_dev",
  hostname: "localhost",
  pool_size: 10
```

Install Bootstrap 4 again:

```
$ cd assets
$ npm install --save bootstrap popper.js jquery
$ npm install --save-dev sass-brunch
$ rm css/phoenix.css
```

Add ```@import "bootstrap";``` to scss file.


Fix the brunch config:

```
  plugins: {
   // ...
    sass: {
      options: {
        includePaths: ["node_modules/bootstrap/scss"],
        precision: 8,
      }
    }
  },
  // ...
  npm: {
    globals: {
      $: 'jquery'
    } 
  }
```


Go fix layouts/app.html.eex:

 - Remove header.
 - Fix flash.
 
Go fix page/index.html.eex:

```
<div class="row">
  <div class="col">
    <h1>page/index</h1>
    <p>TODO: App</p>
  </div>
</div>
```

## Adding Resources

We have two initial resources: Users and Posts

A User has the following fields:

 - email (short string)
 - name (short string)
 
We can create our User resource as follows:

```
$ mix phx.gen.html Accounts User users email:string name:string
```

Add resources line to router; wait on migration.

This generation command makes a bunch of stuff for us (show each):

 - A schema, defining a User datatype for our application that can be
   stored in the database.
 - A scaffold for this resource:
   - A controller, with the standard CRUD/REST operations.
   - A template for each page.
 - A migration, to create the DB table.
 - A context module, containing functions for database operations on our
   resource.
   - Can have multiple resources per context.
   - That makes sense for very closely related resources.
 - Initial tests for everything.

Migration (in priv/repo/migration):

 - Creates a DB table with the listed fields.
 - A relational database table stores what we can think of as
   a "set of structs".
 - In addition to the listed fields, each table will also have
   three more:
    - id - an automatically assigned unique integer.
    - created\_at, updated\_at - timestamps

Add ", null: false" to both fields in the migration. We want the database to
enforce the rule that these fields are required for all users.

```
$ mix ecto.create
$ mix ecto.migrate
```
   
Standard CRUD/REST operations (for User):

 - GET index - list all users
 - GET show - show one user
 - GET new - form to create a user
 - POST create - submit the new form
 - GET edit - form to edit a user
 - POST update - submit the edit form
 - POST delete - delete a user

That means we need, effectively, three pages for each resource:

 - index
 - show
 - form (shared between new and edit)

### Post

A Post has the following fields:

 - user_id (reference to users)
 - body (long string)

```
$ mix phx.gen.html Social Post posts user_id:references:users body:text
```

Edit the router

Edit the migration:

```
  add :body, :text, null: false
  add :user_id, references(:users, on_delete: :delete_all), null: false
```

 - Fields are required.
 - If a user is deleted, all their posts should go too.

Run the migration

## What did we get?

Visit /users

 - index: List is empty
 - new: Create a user
 - show: We have a show page
 - index: List shows all users
 - delete: Removing a user works.
 - Create a user, note their ID.

Visit /posts

 - Create a post.
 - Should crash due to violating user_id not null.
 - Look at schema, make some edits:
 
```
  schema "posts" do
    field :body, :string
    belongs_to :user, Microblog.Accounts.User

    # ...
    
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:body, :user_id])
    |> validate_required([:body, :user_id])
  end
```

 - Try again, now we have a flash error.
 - Add user_id to the form (templates/post/form.html.eex)

```
  <div class="form-group">
    <%= label f, :user_id, class: "control-label" %>
    <%= text_input f, :user_id, class: "form-control" %>
    <%= error_tag f, :user_id %>
  </div>
```

 - Try again, now we get "can't be blank" for the user field.
 - Fill in the user id, try again.
 - That works.
 
Show the username on the posts page:

First, we need to preload the "user" association into the post object when
we fetch it from the DB. Normally we only load data from one table, but we
can load associated objects from other tables with preload.

In the Social context module (microblog/social/social.ex):

```
  def get_post!(id) do
    Repo.get!(Post, id)
    |> Repo.preload(:user)
  end
```

Second, we need to show username in the post/show template:

```
  <li>
    <strong>User:</strong>
    <%= @post.user.name %>
  </li>
```


