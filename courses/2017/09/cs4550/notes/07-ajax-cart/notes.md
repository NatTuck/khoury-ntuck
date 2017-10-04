---
layout: default
---

# NuMart Git Repo

https://github.com/NatTuck/nu_mart

Branches:

 - oct1-before - State from last class
 - oct1-after  - After some updates
 - prep-1002   - Prep for this class

# Some changes to nu\_mart

I did some changes over the weekend that I
don't want to live-code. Let's review those.

 * Github diff from oct1-before to oct1-after

# Adding Reviews

```
$ mix phx.gen.json Feedback Review reviews stars:integer comment:text \
    product_id:references:products user_id:references:users
# add to router.ex, in API scope
#   resources "/reviews", ReviewController, except: [:new, :edit]
```

Edit the migration to add null: false to stuff.

Update API scope to get session and stuff (browser-only API).

```
# in router.ex
  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :fetch_user
  end
```

Fix the schema (review.ex)

```
  belongs_to :product, NuMart.Store.Product
  belongs_to :user, NuMart.Accounts.User

  def changeset(%Review{} = review, attrs) do
    review
    |> cast(attrs, [:stars, :comment, :user_id, :product_id])
    |> validate_required([:stars, :comment, :user_id, :product_id])
  end
```

Add a clause to controller to list reviews for one product (review_controller.ex)

```
  # This goes first.
  def index(conn, %{"product_id" => product_id}) do
    reviews = Feedback.list_product_reviews(product_id)
    render(conn, "index.json", reviews: reviews)
  end
```

Create that helper function (feedback.ex)

```
  def list_reviews do
    Repo.all(Review)
    |> Repo.preload(:user)
  end

  def list_product_reviews(product_id) do
    Repo.all(from r in Review, where: r.product_id == ^product_id)
    |> Repo.preload(:user)
  end
  
  def get_review!(id) do
    Repo.get!(Review, id)
    |> Repo.preload(:user)
  end
```

Fix the view (review_view.ex)

```
  def render("review.json", %{review: review}) do
    data = %{
      id: review.id,
      stars: review.stars,
      comment: review.comment,
      product_id: review.product_id,
    }

    if Ecto.assoc_loaded?(review.user) do
      Map.put(data, :user_email, review.user.email)
    else
      data
    end
  end
```

Add handlebars to deps.

```
$ (cd assets && npm install --save handlebars)
```

Update the products/show page:

```
<div id="product-reviews"
     data-path="<%= review_path(@conn, :index) %>"
     data-product_id="<%= @product.id %>">
  &nbsp;
</div>

<script id="reviews-template" type="text/x-handlebars-template">
  <div class="m-2">
    <h2>Reviews</h2>

    { {#each data}}
    <div class="card w-75 m-2">
      <div class="card-body">
        <h6 class="">{{user_email}}</h6>
        <div class="card-text">
          <p>Stars: {{stars}}</p>
          <p>{{comment}}</p>
        </div>
      </div>
    </div>
    {{else}}
    <p>No reviews yet.</p>
    { {/each}}
  </div>
</script>

<%= if @current_user do %>
<div class="m-2">
  <h2>Add Review</h2>
  <textarea id="review-comment" class="form-control"></textarea>
  <button id="review-add-button" class="btn btn-primary"
          data-user-id="<%= @current_user.id %>">Add Review</button>
</div>
<% end %>
```


assets/js/app.js

```
let handlebars = require("handlebars");

$(function() {
  if (!$("#reviews-template").length > 0) {
    // Wrong page.
    return;
  }

  let tt = $($("#reviews-template")[0]);
  let code = tt.html();
  let tmpl = handlebars.compile(code);

  let dd = $($("#product-reviews")[0]);
  let path = dd.data('path');
  let p_id = dd.data('product_id');

  let bb = $($("#review-add-button")[0]);
  let u_id = bb.data('user-id');

  function fetch_reviews() {
    function got_reviews(data) {
      console.log(data);
      let html = tmpl(data);
      dd.html(html);
    }

    $.ajax({
      url: path,
      data: {product_id: p_id},
      contentType: "application/json",
      dataType: "json",
      method: "GET",
      success: got_reviews,
    });
  }

  function add_review() {
    let comment = $("#review-comment").val();

    let data = {review: {product_id: p_id, user_id: u_id, stars: 3, comment: comment}};

    $.ajax({
      url: path,
      data: JSON.stringify(data),
      contentType: "application/json",
      dataType: "json",
      method: "POST",
      success: fetch_reviews,
    });

    $("#review-comment").val("");
  }

  bb.click(add_review);

  fetch_reviews();
});
```


