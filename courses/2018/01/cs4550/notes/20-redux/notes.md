---
layout: default
---

# First: Questions

 - HW08 Questions?
 - Project 2 Questions?

# Client-Side State

Managing state is a key part of what we've been doing all semester. It seems
like a simple problem - you just stick values in variables - but there always
end up being complications like concurrency or just complexity.

Specifically for client-side state with React, we've been following a pattern
where we put all our state in one root component. 

Let's add a form to create new posts. It should go at the top of the main feed.

post-form.jsx:

```
import React from 'react';
import { Button, FormGroup, Label, Input } from 'reactstrap';

export default function PostForm(params) {
  let users = _.map(params.users, (uu) => <option key={uu.id} value={uu.id}>{uu.name}</option>);
  return <div style={{padding: "4ex"}}>
    <h2>New Post</h2>
    <FormGroup>
      <Label for="user_id">User</Label>
      <Input type="select" name="user_id">
        { users }
      </Input>
    </FormGroup>
    <FormGroup>
      <Label for="body">Body</Label>
      <Input type="textarea" name="body" />
    </FormGroup>
    <Button onClick={() => alert("TODO") }>Post</Button>
  </div>;
}
```

Now we've got a couple problems:

 - What do we do when the user hits the button?
   - Send an AJAX request? With what data?
   - Update our state with the new post?
 - What happens when we enter text, navigate to another route,
   and then navigate back?
   - We lose our data. Should we?

Our solution before was:

 - We should have onChange events on each field that update the
   our state (back in the root component).
 - Submission should call a method on the root component to send 
   a post request based on the state.

This plan doesn't scale well to a larger app. We end up with too much stuff on
the root component. Worse, it doesn't give us any real plan for managing updates
to the state as it gets realy complex.

Our overkill solution: Redux

 - A simple library.
 - Takes the single application state out of the root component.
 - Provides a bunch of patterns for propagating and updating state
   in our application.
 - Redux is 20% code, 80% pattern.

Install some libraries:

```
assets$ npm install redux react-redux deep-freeze
```

Here's how Redux works:

 - Redux lets us create an object called the store that
   creates and manages our application state.
 - Our state is a single - potentially deeply nested -
   immutable JavaScript object.
 - To change our state, we create simple JavaScript value
   objects called actions, which describe the thing that
   happened which will change our state.
 - We write a single function, called the root reducer,
   which goes (old state, an action) => new state.

Doing things this way gives us a couple of things:

 - Some assistance with code structure, as we'll see.
 - Debugging tools that let us time travel, apparently.

assets/js/store.js:

```
import { createStore, combineReducers } from 'redux';
import deepFreeze from 'deep-freeze';

/*
 *  state layout:
 *  {
 *   posts: [... Posts ...],
 *   users: [... Users ...],
 *   form: {
 *     user_id: null,
 *     body: "",
 *   }
 * }
 *
 * */

function posts(state = [], action) {
  return state;
}

function users(state = [], action) {
  return state;
}

let empty_form = {
  user_id: "",
  body: "",
};

function form(state = empty_form, action) {
  switch (action.type) {
    case 'UPDATE_FORM':
      return Object.assign({}, state, action.data);
    default:
      return state;
  }
}

function root_reducer(state0, action) {
  console.log("reducer", action);
  // {posts, users, form} is ES6 shorthand for
  // {posts: posts, users: users, form: form}
  let reducer = combineReducers({posts, users, form});
  let state1 = reducer(state0, action);
  console.log("state1", state1);
  return deepFreeze(state1);
};

let store = createStore(root_reducer);
export default store;
```

update app.js:

```
import store from './store';

import microblog_init from "./cs/microblog";
$(function() {
  microblog_init(store);
});
```

Integrating Redux with React:

 - We've got a library called 'react-redux'
 - It gives you two things:
   - A React component called Provider. This should wrap
     your root react component.
   - A function called 'connect', which lets you get at
     your state from deep in a nested tree of React components.

update cs/microblog.jsx:

```
import { Provider } from 'react-redux';

...

export default function microblog_init(store) {
  ReactDOM.render(
    <Provider store={store}>
      <Microblog />
    </Provider>,
    document.getElementById('root'),
  );
}
```

Update our form (post-form.jxs) to use the Redux store:

```
import React from 'react';
import { connect } from 'react-redux';
import { Button, FormGroup, Label, Input } from 'reactstrap';

function PostForm(params) {
  function update(ev) {
    let tgt = $(ev.target);

    let data = {};
    data[tgt.attr('name')] = tgt.val();
    let action = {
      type: 'UPDATE_FORM',
      data: data,
    };
    console.log(action);
    params.dispatch(action);
  }

  function submit(ev) {
    console.log("Should create post.");
    console.log(params.form);
  }

  let users = _.map(params.users, (uu) => <option key={uu.id} value={uu.id}>{uu.name}</option>);
  return <div style={{padding: "4ex"}}>
    <h2>New Post</h2>
    <FormGroup>
      <Label for="user_id">User</Label>
      <Input type="select" name="user_id" value={params.form.user_id} onChange={update}>
        { users }
      </Input>
    </FormGroup>
    <FormGroup>
      <Label for="body">Body</Label>
      <Input type="textarea" name="body" value={params.form.body} onChange={update} />
    </FormGroup>
    <Button onClick={submit} color="primary">Post</Button>
  </div>;
}

function state2props(state) {
  console.log("rerender", state);
  return { form: state.form };
}

// Export the result of a curried function call.
export default connect(state2props)(PostForm);
```

Next, let's refactor our AJAX requests out of our
React component. After moving the methods out of
microblog.jsx, we end up with a new file:

api.js:

```
import store from './store';

class TheServer {
  request_posts() {
    $.ajax("/api/v1/posts", {
      method: "get",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      success: (resp) => {
        store.dispatch({
          type: 'POSTS_LIST',
          posts: resp.data,
        });
      },
    });
  }

  request_users() {
    $.ajax("/api/v1/users", {
      method: "get",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      success: (resp) => {
        store.dispatch({
          type: 'USERS_LIST',
          users: resp.data,
        });
      },
    });
  }

  submit_post(data) {
    $.ajax("/api/v1/posts", {
      method: "post",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      data: JSON.stringify({ post: data }),
      success: (resp) => {
        store.dispatch({
          type: 'ADD_POST',
          post: resp.data,
        });
      },
    });
  }
}

export default new TheServer();
```

update the Post schema to allow user_id:

```
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:body, :user_id])
    |> validate_required([:body, :user_id])
  end
```

make sure user is preloaded in Posts.ex:

```
  def get_post!(id) do
    Repo.get!(Post, id)
    |> Repo.preload(:user)
  end

  def create_post(attrs \\ %{}) do
    {:ok, post} = %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
    {:ok, Repo.preload(post, :user)}
  end
```


do the initial requests before we even render, in app.js

```
import store from './store';
import api from './api';

import microblog_init from "./cs/microblog";
$(function() {
  api.request_posts();
  api.request_users();
  microblog_init(store);
});
```

Update the store module to handle the new actions:

```
function posts(state = [], action) {
  switch (action.type) {
  case 'POSTS_LIST':
    return [...action.posts];
  case 'ADD_POST':
    return [action.post, ...state];
  default:
    return state;
  }
}

function users(state = [], action) {
  switch (action.type) {
  case 'USERS_LIST':
    return [...action.users];
  default:
    return state;
  }
}
```


update microblog.jsx:

```
import { Provider, connect } from 'react-redux';

...

let Microblog = connect((state) => state)((props) => {
  return (
    <Router>
      <div>
        <Nav />
        <Route path="/" exact={true} render={() =>
          <div>
            <PostForm users={props.state.users} root={this} />
            <Feed posts={props.state.posts} />
          </div>
        } />
        <Route path="/users" exact={true} render={() =>
          <Users users={props.state.users} />
        } />
        <Route path="/users/:user_id" render={({match}) =>
          <Feed posts={_.filter(props.state.posts, (pp) =>
            match.params.user_id == pp.user.id )
          } />
        } />
      </div>
    </Router>
  );
});
```

Let's add a clear button for the post form. Steps:

 - Add a button.
 - Dispatch the action.
 - Update the reducer

## Secure Login & AJAX Security




