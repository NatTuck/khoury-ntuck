--
layout: default
---

# First Thing

 - HW08 Questions?
 - Project Questions?

## Add items to cart

 * start: lecture-10-30
 * end: 6-cart-items

### User List

 - When fetch? On click!
 - Problem: Content renders twice.
 - Solution: UI indication for loading, separate state

**user_list.jsx**:

```
import React from 'react';

export default function UserList(props) {
  let rows = _.map(props.users, (uu) => <User key={uu.id} user={uu} />);
  return <div className="row">
    <div className="col-12">
      <table className="table table-striped">
        <thead>
          <tr>
            <th>email</th>
            <th>admin?</th>
          </tr>
        </thead>
        <tbody>
          {rows}
        </tbody>
      </table>
    </div>
  </div>;
}

function User(props) {
  let {user} = props;
  return <tr>
    <td>{user.email}</td>
    <td>{user.admin ? "yes" : "no"}</td>
  </tr>;
}
```

back in the root:

```
import UserList from './user_list';
...
  // in Root#render
  <Route path="/users" exact={true} render={() =>
    <UserList users={this.state.users} />
  } />
  
```


Add ```users: []``` to the state.

Add a fetch_users method to the root component:

```
  fetch_users() {
    $.ajax("/api/v1/users", {
      method: "get",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      data: "",
      success: (resp) => {
        let state1 = _.assign({}, this.state, { users: resp.data });
        this.setState(state1);
      }
    });
  }
```

Call the fetch_users method when "users" link clicked:

```
function Header(props) {
    // Need to pass this in from the Root#render
    let {root} = props;
    ...
    <div className="col-4">
      <h1><Link to={"/"} onClick={root.fetch_products.bind(root)}>Husky Shop</Link></h1>
    </div>
    <div className="col-2">
      <p><Link to={"/users"} onClick={root.fetch_users.bind(root)}>Users</Link></p>
    </div>
```

Problem: Directly loading /users leads to no users shown.

Solutions:

 - Load all resources in Phoenix template.
 - Have separate Phoenix pages to preload different resources.
 - Just call fetch_users in the root constructor. The JS code is probably
   cached anyway since this isn't the root path, and the extra fetch when
   loading other paths is acceptable.
 - Fetch from JS conditionally based on router path.

### Shopping Cart (no auth)

Let's create our shopping cart.

In root.jsx:

 * ```import Cart from './cart'```
 * Add ```cart: []``` to state
 * In Root#render, split below the header into col-8 main and col-4 cart.

```
 <div className="row">
   <div className="col-8">
     // routes
   </div>
   <div className="col-4">
      <Cart root={this} cart={this.state.cart} />
   </div>
 </div>
```

**cart.jsx:**

```
import React from 'react';
import _ from 'lodash';

export default function Cart(props) {
  let {root, cart} = props;
  let items = _.map(cart, (item) => <CartItem key={item.id} item={item} root={root} />);
  return <div>
    <h2>Shopping Cart</h2>
    <ul>
      {items}
    </ul>
    <button className="btn btn-primary">Check Out</button>
  </div>;
}

function CartItem(props) {
  let {root, item} = props;
  return <li>
    {item.count} - {item.product.name} (
    <button className="btn btn-default"
             onClick={() => root.remove_cart_item(item.id)}>remove</button>)
  </li>;
}
```

Add to cart button

```
  // root, Product:
  // need to thread through root
      <p className="form-inline">
        <input className="form-control" style={{width: "8ex"}}
               type="number" defaultValue="1" id={"item-count-" + product.id} />
        <button className="btn btn-primary"
                onClick={() => root.add_to_cart(product.id)}>
          Add to Cart
        </button>
      </p>
```

Add to cart method in Root

```
  send_post(path, req, on_success) {
    $.ajax(path, {
      method: "post",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      data: JSON.stringify(req),
      success: on_success,
    });
  }

  add_to_cart(product_id) {
    let user_id = this.state.session.user_id;
    let count = $('#item-count-' + product_id).val();
    this.send_post(
      "/api/v1/cart_items",
      {product_id, user_id, count},
      (resp) => {
        let cart1 = _.concat(this.state.cart, [resp.data]);
        let state1 = _.assign({}, this.state, { cart: cart1 });
        this.setState(state1);
      }
    );
  }
```

Need to fix changeset function in cart_item schema:

```
  def changeset(cart_item, attrs) do
    cart_item
    |> cast(attrs, [:count, :user_id, :product_id])
    |> unique_constraint(:user_id, name: :cart_items_user_id_product_id_index)
    |> validate_required([:count, :user_id, :product_id])
  end
```

Need to fetch updated cart items:

 * Create by default returns the item created.
 * We're missing some fields, let's add them.

cart\_item\_view.ex:

```
  def render("cart_item.json", %{cart_item: cart_item}) do
    product = HuskyShopWeb.ProductView.render(
      "product.json", %{product: cart_item.product})
    %{
      id: cart_item.id,
      count: cart_item.count,
      product: product,
      user_id: cart_item.user_id,
    }
  end
```

We need to preload the products field.

In the cart\_items context:

```
  def get_cart_item!(id) do
    Repo.one! from ci in CartItem,
      where: ci.id == ^id,
      preload: [:product]
  end
```

Fetch the full item in cart\_item\_controller / create:

```
  def create(conn, %{"cart_item" => cart_item_params}) do
  ...
      cart_item = CartItems.get_cart_item!(cart_item.id)
```

Problem: Don't see initial cart items.

Solution: Fetch on initial load.

```
  fetch_path(path, on_success) {
    $.ajax(path, {
      method: "get",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      data: "",
      success: on_success,
    });
  }

  fetch_cart() {
    this.fetch_path(
      "/api/v1/cart_items",
      (resp) => {
        let state1 = _.assign({}, this.state, { cart: resp.data });
        this.setState(state1);
      }
    );
  }
```

We need to preload for list_cart\_items().

```
  def list_cart_items do
    Repo.all from ci in CartItem,
      preload: [:product]
  end
```

Remove cart item method in root:

```
  remove_cart_item(id) {
    $.ajax("/api/v1/cart_items/" + id, {
      method: "delete",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      data: "",
      success: (_resp) => {
        let cart1 = _.filter(this.state.cart, (item) => item.id != id);
        let state1 = _.assign({}, this.state, { cart: cart1 });
        this.setState(state1);
      }
    });
  }
```

Problem: If we enter a count for an item in the add to cart form, change pages,
and change back, we lose the state.

Solution: Explicitly add the value of all forms to the React state.

...

 * Finish login
   - Form, which is part of state.
   - If there's a session, show user's email (add to resp).
   - Require session token for add to cart.

Overflow features:

 * Show single item.

## Next Time: Redux

