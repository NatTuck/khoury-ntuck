---
layout: default
---

# First: HW Stuff

 - HW Questions?
 - Project 1 has started: Your game is due on March 25th - about a month from now.

## Basic Canvas

Show canvas.html example

 - Core idea is this shape and fill / shape and stroke model.
 - Actively related to SVG.
 - Does allow raster images (e.g. PNG)

## Shapes

Today we're going to build another example application. This one uses most of
the pieces we've seen so far.

This app will allow us to build pictures made out of shapes.

```
postgres$ pwgen 12 1
postgres$ createuser -d -P shapes
$ mix phx.new shapes
$ vim config/dev.exs
$ mix ecto.create
$ mix phx.gen.html Pics Picture pictures name:string
$ vim ...create_pictures
$ vim lib/shapes_web/router.ex
$ mix phx.gen.json Pics Circ circs x:integer y:integer rad:integer color:string
$ vim ...create_circs
$ vim lib/shapes_web/router.ex
$ mix phx.gen.json Pics Rect rects x:integer y:integer w:integer h:integer color:string
$ vim ...create_rects
$ vim lib/shapes_web/router.ex
$ mix ecto.migrate
```

Clean out the Phoenix defaults:

 * Clean up the layout (no header, if around flash).
 * Replace page#index with a link to /pictures
 * In assets:
 * rm css/phoenix.css static/images/phoenix.png

Add our JS prereqs:

```
assets$ npm install --save react react-dom underscore react-konva konva
assets$ npm install --save-dev babel-preset-env babel-preset-react
```

brunch-config.js:

```
  plugins: {
    babel: {
      // Do not use ES6 compiler in vendor code
      ignore: [/vendor/],
      presets: ['env', 'react'],
    }
  },
```

app.css:

```
.container { max-width: 60%; margin-left: auto; margin-right: auto; }
```

templates / pictures / show:

```
<p> 
<span><%= link "Edit Name", to: picture_path(@conn, :edit, @picture) %></span>
<span><%= link "Back", to: picture_path(@conn, :index) %></span>
</p>

<h2>Picture: <%= @picture.name %></h2>

<script>
  window.picture_id = <%= @picture.id %>;
</script>

<div id="root">
  <p>Pic loading...</p>
</div>
```

app.js:

```
import init_shapes from "./shapes";
window.addEventListener('load', init_shapes);
```

Fill in the rest of the JS:

 - shapes.js
 - components/{picture.jsx, toolbox.js}

