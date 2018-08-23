---
layout: default
---

# First: Homework

 - New homework: Add some features to Task Tracker
 - Complications: Self-relation, JSON API / AJAX

# New Microblog Feature: Follows

 - Git Repo: https://github.com/NatTuck/microblog.git
 - Branch: part-three-done

Feature Description:

 - A user can select other users to follow or not follow.
 - You only see posts in your feed from users that you follow.


**Add a Navbar**


In the layout:

```
  <!-- TODO: style with bootstrap -->
  <div class="row">
    <%= if @current_user do %>
      <div class="col-9">
        <p class="p-4">
          <a href="/feed">Feed</a> |
          <a href="/users">All Users</a>
        </p>
      </div>
      <div class="col-3">
        <p class="p-4">
          Logged in as: <%= @current_user.name %> |
          <%= link "Log Out", to: "/session", method: :delete %>
        </p>
      </div>
    <% else %>
      <div class="col-3 offset-9">
        <p>Not logged in.</p>
      </div>
    <% end %>
  </div>
```

## Create Follows resource

```
$ mix phx.gen.json Social Follow follows follower_id:references:users followee_id:references:users
```

Add this to our API scope:

```
  scope "/api/v1", MicroblogWeb do
    pipe_through :api
    resources "/follows", FollowController, except: [:new, :edit]
  end
```

 - API path should be versioned

Edit migration:

 - on\_delete: :delete\_all), null: false

Migrate.

Edit follow schema:

```
  alias Microblog.Accounts.User

  schema "follows" do
    belongs_to :follower, User
    belongs_to :followee, User
  
  # ...
    
  def changeset(%Follow{} = follow, attrs) do
    follow
    |> cast(attrs, [:follower_id, :followee_id])
    |> validate_required([:follower_id, :followee_id])
  end
```

Edit User Schema:

```
  alias Microblog.Social.Follow

  schema "users" do
    field :email, :string
    field :name, :string
    has_many :follower_follows, Follow, foreign_key: :follower_id
    has_many :followee_follows, Follow, foreign_key: :followee_id
    has_many :followers, through: [:followee_follows, :follower]
    has_many :followees, through: [:follower_follows, :followee]

    # ...
```

## Add A Follows UI

In the users controller:

```
  def index(conn, _params) do
    current_user = conn.assigns[:current_user]
    users = Accounts.list_users()
    follows = Microblog.Social.follows_map_for(current_user.id)
    render(conn, "index.html", users: users, follows: follows)
  end
```

In the social context module:

```
  def follows_map_for(user_id) do
    Repo.all(from f in Follow,
      where: f.follower_id == ^user_id)
    |> Enum.map(&({&1.followee_id, &1.id}))
    |> Enum.into(%{})
  end
```

In the user/show template:

```
<script>
 window.follow_path = "<%= follow_path(@conn, :index) %>";
 window.current_user_id = "<%= @current_user.id %>";
</script>

...

    <!-- add header column -->
    <!-- body column: -->
    <td>
      <button class="follow-button btn btn-default"
              data-user-id="<%= user.id %>"
              data-follow="<%= @follows[user.id] %>">
        Follow
      </button>
    </td>
```

Write some javascript in app.js:

```
import $ from "jquery";

// ...

function update_buttons() {
  $('.follow-button').each( (_, bb) => {
    let user_id = $(bb).data('user-id');
    let follow = $(bb).data('follow');
    if (follow != "") {
      $(bb).text("Unfollow");
    }
    else {
      $(bb).text("Follow");
    }
  });
}

function set_button(user_id, value) {
  $('.follow-button').each( (_, bb) => {
    if (user_id == $(bb).data('user-id')) {
      $(bb).data('follow', value);
    }
  });
  update_buttons();
}

function follow(user_id) {
  let text = JSON.stringify({
    follow: {
        follower_id: current_user_id,
        followee_id: user_id
      },
  });

  $.ajax(follow_path, {
    method: "post",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: text,
    success: (resp) => { set_button(user_id, resp.data.id); },
  });
}

function unfollow(user_id, follow_id) {
  $.ajax(follow_path + "/" + follow_id, {
    method: "delete",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: "",
    success: () => { set_button(user_id, ""); },
  });
}

function follow_click(ev) {
  let btn = $(ev.target);
  let follow_id = btn.data('follow');
  let user_id = btn.data('user-id');

  if (follow_id != "") {
    unfollow(user_id, follow_id);
  }
  else {
    follow(user_id);
  }
}

function init_follow() {
  if (!$('.follow-button')) {
    return;
  }

  $(".follow-button").click(follow_click);

  update_buttons();
}

$(init_follow);
```

Finally, fix the feed to only show post from followed users.


posts/controller:

```
  posts = Enum.reverse(Microblog.Social.feed_posts_for(conn.assigns[:current_user]))
```

social context:

```
  def feed_posts_for(user) do
    user = Repo.preload(user, :followees)
    followed_ids = Enum.map(user.followees, &(&1.id))

    Repo.all(Post)
    |> Enum.filter(&(Enum.member?(followed_ids, &1.user_id)))
    |> Repo.preload(:user)
  end
```

That function could be optimized into a join in the DB - loading all posts every
time would be terrible on Twitter - but it's OK for this demo.
