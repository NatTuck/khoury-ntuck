---
layout: default
---

# First: Assignment Schedule

## Project 1

 - Due date extended to Tuesday
 - Last minute questions?

## HW08

 - Rewrite your Task Tracker as an SPA
 - We'll be covering SPAs this week

## Project 2

 - As part of a team of up to four people, write a non-trivial web app.
 - Core requirements: 
   - Your app must be an Elixir / Phoenix app that uses a Postgres database.
   - Your Elixir code must access an external web API (server -> server API use).
 - Team selection is due this Sunday, before HW08.

# Single Page Apps

We're going to rewrite the Microblog to be a SPA.

Core properties of SPAs:

 - There's only one full page load. Apparent page loads are
   simulated in JavaScript.
 - All client <-> server communication after that first page
   load is (tradionally) by AJAX reqs or (sometimes now) over
   a websocket.

Why?

 - SPA style provides better control over the details of the user
   experience rather than leaving it to the browser.
 - SPAs can feel faster, especially due to applicion-aware caching
   of data.

Why not?

 - SPAs are generally slower on first load than normal webpages.
 - SPA frameworks exist, but the culture of SPA development tends to
   favor flexibility, so you frequently have to do a bunch of stuff by hand:
 - It's easy to break the back button and other stock browser UI - some tools
   don't give correct behavior by default.
 - There tends not to be Phoenix-style scaffolding that gives you error handling
   for free.

## Start with Sample App

github repo: https://github.com/NatTuck/microblog-spa

 - lecture starts at: lec19-start
   - This is a basic Phoenix app with React & Bootstrap installed
   - [react setup notes](../05-react/notes.html)
 - lecture ends at: lec19-end

Create DB: See config/dev.exs

Remember mix deps.get / npm install

## Add Our Resources

For our SPA we won't be using any HTML scaffolds at all, so we'll generate
our resources with JSON scaffolds:

```
$ mix phx.gen.json Users User users name:string
$ mix phx.gen.json Posts Post posts user_id:references:users body:text
```

Add these items to the api scope - make sure it's "/api/v1".

Seed the DB: In priv/repo/seeds.exs:

```
defmodule Seeds do
  alias Microblog.Repo
  alias Microblog.Users.User
  alias Microblog.Posts.Post

  def run do
    Repo.delete_all(User)
    a = Repo.insert!(%User{ name: "alice" })
    b = Repo.insert!(%User{ name: "bob" })
    c = Repo.insert!(%User{ name: "carol" })
    d = Repo.insert!(%User{ name: "dave" })

    Repo.delete_all(Post)
    Repo.insert!(%Post{ user_id: a.id, body: "Hi, I'm Alice" })
    Repo.insert!(%Post{ user_id: b.id, body: "Hi, I'm Bob" })
    Repo.insert!(%Post{ user_id: b.id, body: "Hi, I'm Bob Again" })
    Repo.insert!(%Post{ user_id: c.id, body: "Hi, I'm Carol" })
    Repo.insert!(%Post{ user_id: d.id, body: "Hi, I'm Dave" })
  end
end

Seeds.run
```

```
$ mix run priv/repo/seeds.exs
```

## Make Everything React

```
assets$ npm install react-router-dom
```

Here's all of page/index.html.eex:

```
<div id="root">
  <p>React app loading</p>
</div>
```

Add this to app.js:

```
import microblog_init from "./cs/microblog";
$(microblog_init);
```

Add user to post query:

 - in Post.ex: belongs\_to :user, Microblog.Users.User
 - in Posts.ex: list\_posts: |> Repo.preload(:user)
 - in posts\_view.ex: 
   - alias MicroblogWeb.UserView
   - render: user: render\_one(post.user, UserView, "user.json")}

## Fix the Server-Side Routes

React-router, by default, changes the path in your browser.

In addition to live-reload during development, users may bookmark
these paths. 

```
    get "/users", PageController, :index
    get "/posts", PageController, :index
    get "/users/:id", PageController, :index
```

## Really Make Everything React

... All the components

