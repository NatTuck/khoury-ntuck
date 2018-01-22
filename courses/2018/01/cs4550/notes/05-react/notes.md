---
layout: default
---

 - Mo/Th:  	EL 312 	 11:45am - 1:25pm
 - Tu/Fr:   WVG 102	  3:25pm - 5:05pm

## The HW: Memory Game

 - Show game running.

## HW Questions?

 - Today we'll talk about React, and build Hangman.

## Starting a Phoenix Project

 - We're starting out today with full-complexity client-side web development.
 - For that we need two pieces:
   - A local web server.
   - A build tool.
 - The code we write - especially for React - is not JavaScript that can
   run directly in the browser.
 - So we need a build step to compile our code before it can run, using "babel".

 - In order to provide all this stuff, we're going to start using our
   server-side framework: Phoenix. It provides good tooling for client side
   development through babel and Phoenix's live reload feature.
 
### Phoenix Prereqs

Erlang / Elixir:

 - elixir-lang.org / install
 - Erlang Solutions package repository

NodeJS:

 - Need a current version of NodeJS
 - Use nodesource package repository: 
 - https://github.com/nodesource/distributions

Phoenix:

 - https://hexdocs.pm/phoenix/installation.html
 - We want to install the phx.new tool.

### Starting Our Game

```
$ mix phx.new hangman --no-ecto
$ cd hangman
```

 - This creates a new Phoenix app.
 - "--no-ecto" tells it that we won't need a server-side database

What we just got:

 - assets - Browser-side code and data.
 - _build, deps - Build artifacts we can ignore
 - config, lib, priv - Server-side code and data.
 - test - Tests for the server-side code.

```
hangman$ mix phx.server
```

We can visit http://localhost:4000/ to see the default page for
a new Phoenix project.

We don't want this default page. Let's get rid of it.

```
hangman$ rm assets/static/images/phoenix.png
hangman$ rm assets/css/phoenix.css
hangman$ vim lib/hangman_web/templates/layout/app.html.eex # remove the header
hangman$ vim lib/hangman_web/templates/page/index.html.eex # replace with below
```

Replace contents of templates/page/index with:

```
<div class="row">
  <div class="col">
    <h1>Hangman Game</h1>
    <div id="root">
      <p>React app not loaded...</p>
    </div>
  </div>
</div>
```

## Brunch & Babel

Phoenix provides us with a browser-side development toolchain in our "assets"
directory. Here's what it gave us:

 - brunch-config.js - Configuration for the "brunch" build tool.
 - css, js, static - Places to put our css, javascript code, and stuff like images.
 - package.json - A list of JS package dependencies for "npm".
 - node_modules - Where our dependencies will be downloaded.
 - package-lock.json, vendor - stuff we can ignore for now

Look at package.json - Phoenix has pre-seeded some dependencies. We should pull
in some more:

```
assets$ npm install --save jquery bootstrap@4.0.0 popper.js react react-dom reactstrap@5.0.0-alpha.4 underscore
assets$ npm install --save-dev babel-preset-env babel-preset-react sass-brunch
```

Runtime packages: (These are sent to the user's browser.)

 - jQuery - Library of utility methods for DOM operations.
 - Bootstrap - Provides some reasonably good looking styles and widgets, including a grid system.
 - Underscore - Provides some utility functions, including functional collection functions.
 - React / React-DOM - Our display framework.
 - Reactstrap - React + Bootstrap helpers.
 - popper.js - Bootstrap dependency.

Development packages: (These are available only at build-time, not in the browser.)

 - babel-preset-env - Babel will target modern browsers (configurable).
 - babel-preset-react - Babel will handle modern JS and React's JS sytax extension: JSX.
 - sass-brunch - We can use the Sassy CSS extension to CSS syntax (required for Bootstrap).

**Configure Brunch**

In assets/brunch-config.js:

```
  plugins: {
    babel: {
      // Do not use ES6 compiler in vendor code
      ignore: [/vendor/],
      presets: ['env', 'react'],
    },
    sass: {
      options: {
        includePaths: ["node_modules/bootstrap/scss"],
        precision: 8,
      }
    }
  },
```

```
  npm: {
    enabled: true,
    globals: {
      _: 'underscore',
      $: 'jquery'
    }
  }
```

**Enable Bootstrap 4**

Add the following to assets/css/app.scss:

```
@import "bootstrap";

body { font-size: 20pt; }

```

Clean up flash message display.

In lib/hangman_web/templates/layout/app.html.eex:

```
  <%= if get_flash(@conn, :info) do %>
    <p class="alert alert-info" role="alert"><%= get_flash(@conn, :info) %></p>
  <% end %>
  <%= if get_flash(@conn, :error) do %>
    <p class="alert alert-danger" role="alert"><%= get_flash(@conn, :error) %></p>
  <% end %>
```

## React

Core ideas in React:

An application consists of:

 - A data defintion for the state of the application.
 - A pure function that renders a state into a display.
   - render(state) => displayed page
 - Event handlers that update the state and trigger a re-render.

This is just like "big-bang" from Fundies 1 / PDP.

React is primarily a tool for building "render functions" that allow us to
transform application state (a single JS value) to an application display (a
tree of DOM elements to be rendered into a web page).

**Write todo.jsx**

Add the following to app.js:

```
import todo_init from "./todo";

function start() {
  let root = document.getElementById('root');
  todo_init(root);
}

$(start);
```

## Game

### Bootstrap Grid System

```
.container
  .row
    .col
    .col
  .row
    .col
    .col
    .col
```

### Hangman

**Write hangman.jsx**


## Deployment

**Deploy to Server**











