---
layout: default
---

# First: HW Stuff

 - HW Questions?
 - Cheating:
   - We have had our first cheating cases of the semester.
   - They submitted code written by other students as their
     own work - no attribution notice was included.
   - The students involved will recieve an F in the course and
     have been reported to the university and the college.
 
# More Work on Microblog

What we have:

 - Two resources: User, Post
 - Scaffolding: Templates, Controllers
 - Context modules: Functions for DB CRUD operations

What we don't have: A Microblog App

## User Accounts

Some Actions:

 - Register
 - Log in
 - Log out

Register we have: it's the user/new path.

 - Create alice@example.com as a test user.

Log in and log out are new. They don't really manipulate users, instead, they
manipulate "user sessions". 

Let's create a partial "session" resource, manually.
Two CRUD actions: create and delete.

in router.ex:

```
    post "/session", SessionController, :create
    delete "/session", SessionController, :delete
```

create session_controller.ex

```
defmodule MicroblogWeb.SessionController do
  use MicroblogWeb, :controller

  alias Microblog.Accounts
  alias Microblog.Accounts.User

  def create(conn, %{"email" => email}) do
    user = Accounts.get_user_by_email(email)
    if user do
      conn
      |> put_session(:user_id, user.id)
      |> put_flash(:info, "Welcome back #{user.name}")
      |> redirect(to: page_path(conn, :index))
    else
      conn
      |> put_flash(:error, "Can't create session")
      |> redirect(to: page_path(conn, :index))
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> put_flash(:info, "Logged out")
    |> redirect(to: page_path(conn, :index))
  end
end
```

In accounts.ex context module:

```
  # We want a non-bang variant
  def get_user(id), do: Repo.get(User, id)
 
  # And we want by-email lookup
  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end
```

Log in screen:

page/index:

```
    <h1>Log In</h1>
    <!-- session_path(@conn, :create) -->
    <%= form_tag("/session", method: :post) do %>
      <div class="form-group">
        Email
        <input type="email" name="email" placeholder="user@example.com" >
      </div>
      <!-- passwords come later -->
      <div class="form-group">
        <button class="btn btn-primary">Log in</button>
        <%= link "Register", to: user_path(@conn, :new) %>
      </div>
    <% end %>
```

Add a heading:

in the layout:

```
      <div class="row">
        <div class="col-3 offset-9">
          <%= if @current_user do %>
            <p>
              Logged in as: <%= @current_user.name %> |
              <%= link "Log Out", to: "/session", method: :delete %>
            </p>
          <% else %>
            <p>Not logged in.</p>
          <% end %>
        </div>
      </div>
```

That broke everything. Now we need a plug.

In the router:

```
  # After fetch_session in the browser pipeline:
  plug :get_current_user
  
  # Below the pipeline
  def get_current_user(conn, _params) do
    # TODO: Move this function out of the router module.
    user_id = get_session(conn, :user_id)
    user = Microblog.Accounts.get_user(user_id || -1)
    assign(conn, :current_user, user)
  end
```

## The Feed

Add a new route:


```
    get "/feed", PageController, :feed
```

Make sure we're preloading user on posts.

```
  # social.ex context module
  def list_posts do
    Repo.all(Post)
    |> Repo.preload(:user)
  end
```

Add the new controller action (page_controller):

```
  def feed(conn, _params) do
    posts = Microblog.Social.list_posts()
    changeset = Microblog.Social.change_post(%Microblog.Social.Post{})
    render conn, "feed.html", posts: posts, changeset: changeset
  end
```

Add the new template (page/feed.html.eex):

```
<%= if @current_user do %>
  <div class="row">
    <div class="col">
      <%= render MicroblogWeb.PostView, "form.html",
          Map.put(assigns, :action, post_path(@conn, :create)) %>
    </div>
  </div>
<% end %>

<h1>Your Feed</h1>

<%= Enum.map @posts, fn post -> %>
<div class="row">
  <div class="col">
    <div class="card">
      <div class="card-body">
        <h6 class="card-title"><%= post.user.name %></h6>
        <p><%= post.body %></p>
      </div>
    </div>
  </div>
</div>
<% end %>
```

More steps:

 - Include user_id in post.
 - Get redirections pointing to the right places.


# Deploying

 - The script for HW03 won't work.
 - Same steps needed, except:
 - No need to worry about websockets.
 - Create DB user, same as for dev machine.
 - Must create production DB and run migrations:

```
microblog@vps:~/src/microblog$ MIX_ENV=prod mix ecto.create
microblog@vps:~/src/microblog$ MIX_ENV=prod mix ecto.migrate
```


