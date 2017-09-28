---
layout: default
---

# NuMart Git Repo

https://github.com/NatTuck/nu_mart

Branches:

 - class-0925 - After last class
 - prep-0928 - Prep for this class

## Adding an Item to the Cart

 * Start on products/show
 * Click "add to cart"
 * Form is for a cart\_item, including {product\_id, cart\_id, count}
 * Form hits cart\_items/create
 * Now the record is in the database.

So, from last time, we always have a cart. We can add stuff to our cart. We just can't
see the stuff we've added.

## Show Shopping Cart

Fix the app layout (templates/layout/app.html.eex)

```
<!-- after the nav stuff -->
<div class="container">

  <div class="row">
    <!-- leave the flash stuff -->
  </div>

  <div class="row">
    <div class="col-sm-8">
      <%= render @view_module, @view_template, assigns %>
    </div>
    <div class="col-sm-4">
      <!-- render last argument is an alist -->
      <!-- can either be key: val pairs or pass on the current @vars with "assigns" -->
      <%= render NuMartWeb.CartView, "show.html", assigns %>
    </div>
  </div>

</div> <!-- container -->
```

Show shopping cart contents (templates/cart/show.html.eex)

```
<table class="table table-striped">
  <%= Enum.map @cart.cart_items, fn item -> %>
  <tr>
    <td><%= item.product.name %></td>
    <td><%= item.count %></td>
  </tr>
  <% end %>
</table>
```

## Delete Cart Items

Deletes are broken.

Load page, open dev tools, check console tab.

popper.js is missing - we need to install that.


```
assets$ npm install --save popper.js
```

```
      # npm globals in brunch config
      Popper: 'popper.js',
```

At this point, the existing delete links should work.

Shopping cart delete button (templates/cart/show.html.eex)

Browsers only do two HTTP methods (link = get, form = post)
by default. Other methods exist, but have to be explicitly handled
through JS.

Phoenix provides helper to generate link that will generate
a delete effect.

Note: A regular (GET) link would be bad. GET is supposed to be
safe, so we wouldn't want to delete on GET. 

```
    <td><%=
        link(
          raw("&times;"),
          to: cart_item_path(@conn, :delete, item),
          method: :delete,
          class: "btn btn-danger btn-xs"
        )
    %></td>
``` 

# Add User Accounts

User resource:

```
$ mix phx.gen.html Accounts User users email:string
```

Session "resource":

```
# In ...web/router.ex browser scope
    post "/sessions", SessionController, :login
    delete "/sessions", SessionController, :logout
```

In lib/nu_mart/accounts/accounts.ex

```
  def get_user_by_email!(email) do
    Repo.get_by(User, email: email)
  end
```

Whole new file in ...web/controllers/session_controller

```
defmodule NuMartWeb.SessionController do
  use NuMartWeb, :controller

  alias NuMart.Accounts

  def login(conn, %{"email" => email}) do
    user = Accounts.get_user_by_email(email)

    if user do
      conn
      |> put_session(:user_id, user.id)
      |> put_flash(:info, "Logged in as #{user.email}")
      |> redirect(to: product_path(conn, :index))
    else
      conn
      |> put_session(:user_id, nil)
      |> put_flash(:error, "No such user")
      |> redirect(to: product_path(conn, :index))
    end
  end

  def logout(conn, _params) do
    conn
    |> put_session(:user_id, nil)
    |> put_flash(:info, "Logged out")
    |> redirect(to: product_path(conn, :index))
  end
end
```

```
  # Add this to plugs module, use it in pipeline in router
  def fetch_user(conn, _opts) do
    user_id = get_session(conn, :user_id)
    if user_id do
      user = NuMart.Accounts.get!(user_id)
      assign(conn, :user, user)
    else
      assign(conn, :user, nil)
    end
  end
```

Update form in app layout to hit login.

```
    <%= if @user do %>
      <span class="text-light">
        <%= @user.email %> |
        <%= link("logout", to: session_path(@conn, :logout), method: :delete) %>
      </span>
    <% else %>
      <%= form_for @conn, session_path(@conn, :login), [as: "user", class: "form-inline w-75"], fn f -> %>
        <%= text_input f, :email,  placeholder: "email", class: "form-control" %>
        <%= submit "Log in", class: "btn btn-primary" %>
      <% end %>
    <% end %>
``` 


## Assorted Stuff

Add some more features / fix some more graphical stuff.

## Deployment

Add distillery to mix.exs

```
{:distillery, "~> 1.5", runtime: false}
```

Setup for release

```
$ mix deps.get
$ mix release.init
```

Copy source to server

```
$ tar czvf nu_mart-v2.tar.gz nu_mart
$ scp ...
$ ... unpack ...
```

On the server, generate a release

```
$ bash
$ export MIX_ENV=prod
$ cd assets
$ npm install
$ ./node_modules/brunch/bin/brunch b -p
$ cd ..
$ mix phx.digest
$ mix release --env=prod
$ exit
```

Copy to server

```
$ scp _build/prod/rel/nu_mart/releases/0.0.1/nu_mart.tar.gz numart@ironbeard.com:/home/numart/nu_mart-0.0.1.tar.gz
```

Unpack

```
$ ssh numart@ironbeard.com
$ mkdir -p numart && cd numart
$ tar xzvf ../nu_mart-0.0.1.tar.gz
```

Migrate

```
./bin/nu_mart command Elixir.NuMart.ReleaseTasks migrate
```

