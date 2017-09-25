---
layout: default
---

# NuMart Git Repo

https://github.com/NatTuck/nu_mart

# Carts & Sessions

When you visit the site, you get a shopping cart. Shopping carts are stored in the DB
as collections of cart items, which are basically (product_id, 


```
$ mix phx.gen.html Shop Cart carts cart_type:string
$ mix phx.gen.html Shop CartItem cart_items cart_id:references:carts product_id:references:products count:integer
```

Talk about contexts:

 - "Shop" is pretty generic.
 - We want more than one context per app.
 - 


Edit the cart migration. Set type to default: "active", null: false.

Edit the cart items migration, set on-delete: :delete\_all for both references. If a product or
cart ceases to exist, we can safely just remove all associate cart items. Set everything to not null.

```
$ mix ecto.migrate
```

## Our data model:

We've got a SQL database with three tables, containing the following fields:

 * products
   * id
   * name
   * desc
   * price
   * (timestamps)
 * carts
   * id
   * cart_type = "active"
   * (timestamps)
 * cart\_items
   * id
   * cart_id
   * product_id
   * count
   * (timestamps)

Comments:

 * Each table has an id field, an integer uniquely identifying each row of the table.
 * Tables can reference other tables by id. The DB guarantees that these references are
   valid (or null).
 * We said cart id and product id in cart items can't be null
 * So every cart item refers to an existing cart and product.
 * Careful use of database features can provide some guarantees about data integrity.


## Seeding the Database

We can use priv/repo/seeds.exs to pre-load some data into the database.

```
alias NuMart.Repo
alias NuMart.Shop.Product
alias Decimal, as: D

Repo.delete_all(Product)

Repo.insert!(%Product{name: "Fidget Spinner", price: D.new("3000"), desc: "A waste of a ball bearing." })
Repo.insert!(%Product{name: "Hoverboard", price: D.new("120"), desc: "Free battery fire." })
Repo.insert!(%Product{name: "Pet Rock", price: D.new("49.99"), desc: "It's a rock." })
Repo.insert!(%Product{name: "Furby", price: D.new("89.99"), desc: "A terrifying monster."})
Repo.insert!(%Product{name: "Yo-Yo", price: D.new("3.49"), desc: "Some sort of weapon?" })
Repo.insert!(%Product{name: "Slinky", price: D.new("5.75"), desc: "Warn-out spring." })
```

## Tying things together.

Default page: product list

Update .../controllers/page_controller.ex

```
  def index(conn, _params) do
    redirect conn, to: product_path(conn, :index)
  end
```

We need a better page template. Let's update to Bootstrap 4 and pull
in our earlier design ideas.

## Boostrap 4

Reference: https://gist.github.com/eproxus/545618f91983ff302a0a734888e7d01c

In assets directory:

```
$ rm css/phoenix.css
$ rm static/images/phoenix.png
$ npm install --save-dev sass-brunch
$ npm install --save jquery
$ npm install --save bootstrap@4.0.0-beta
```

Edit brunch-config.js

In plugins, add after the babel block:

```
  sass: {
    options: {
      includePaths: ["node_modules/bootstrap/scss"],
      precision: 8
    }
  }
```

In npm, after enabled: true,

```
    globals: {
      $: 'jquery',
      jQuery: 'jquery',
      bootstrap: 'bootstrap'
    }
```
 
Fix the notices, edit lib/nu\_mart\_web/templates/layout/app.html.eex :

```
  <%= if get_flash(@conn, :info) do %>
    <p class="alert alert-info" role="alert"><%= get_flash(@conn, :info) %></p>
  <% end %>
  <%= if get_flash(@conn, :error) do %>
    <p class="alert alert-danger" role="alert"><%= get_flash(@conn, :error) %></p>
  <% end %>
```

Update the app layout for Boostrap 4, using the already made page layouts:

http://www.ccs.neu.edu/home/ntuck/courses/2017/09/cs4550/notes/02-pages/pages/

```
<%= link "Products", to: product_path(@conn, :index), class: "nav-link" %>
```


## Add Item to Cart

First, copy the contents of templates/cart\_item/form.html.eex into templates/product/show.html.eex

Update to be ```<%= form_for @cart_item, cart_item_path(@conn, :create) ... %>```

Update show in Product controller:

```
  def show(conn, %{"id" => id}) do
    product   = Shop.get_product!(id)
    cart_id   = get_session(conn, :cart_id)
    cart_item = Shop.change_cart_item(%NuMart.Shop.CartItem{product_id: id, count: 1, cart_id: cart_id})
    render(conn, "show.html", product: product, cart_item: cart_item)
  end
```

Add hidden fields (hidden_input f, ...) to form for product id and cart id.

Problem: No cart in session. Must always have a cart.

Solution: Add a plug.

## There Must Always Be a Cart

```
# nu_mart_web/plugs.ex
defmodule NuMartWeb.Plugs do
  import Plug.Conn

  # Should move to shop.ex
  def get_or_create_cart(nil) do
    NuMart.Repo.insert!(%NuMart.Shop.Cart{})
  end

  def get_or_create_cart(cart_id) do
    cart = NuMart.Repo.get(NuMart.Shop.Cart, cart_id)
    if cart do
      cart
    else
      NuMart.Repo.insert!(%NuMart.Shop.Cart{})
    end
  end

  def fetch_cart(conn, _opts) do
    cart_id = get_session(conn, :cart_id)
    cart = get_or_create_cart(cart_id)
    conn
    |> put_session(:cart_id, cart.id)
    |> assign(:cart, cart)
  end
end
```

Now make the add to cart button work.

Make sure form, cart_item.ex, etc are all correct.

## Show Shopping Cart

```
  <!-- back in layouts/app.html.exs -->
  <div class="row my-2">
    <div class="col-md-8">
      <%= render @view_module, @view_template, assigns %>
    </div>
    <div class="col-md-4">
      <%= render NuMartWeb.CartView, "show.html", conn: @conn, cart: @cart %>
    </div>
  </div>
```

Relations: 
 * A cart item belongs to a cart.
 * A cart item belongs to a product.
 * A cart has many cart items.

Tell the schema about the relation, in .../shop/cart.ex

```
  alias NuMart.Shop.Cart
  alias NuMart.Shop.CartItem

  schema "carts" do
    field :cart_type, :string
    has_many :cart_items, CartItem

    timestamps()
  end
```

And in cart item.ex:

```
  schema "cart_items" do
    field :count, :integer
    belongs_to :cart, NuMart.Shop.Cart
    belongs_to :product, NuMart.Shop.Product

    timestamps()
  end
```

Update plugs.ex

```
  def fetch_cart(conn, _opts) do
    cart_id = get_session(conn, :cart_id)
    cart = get_or_create_cart(cart_id)
      |> NuMart.Repo.preload([cart_items: :product])
    conn
    |> put_session(:cart_id, cart.id)
    |> assign(:cart, cart)
  end
```


