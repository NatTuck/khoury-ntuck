---
layout: default
---

## First Thing

Project questions?

## Virtual DOM Libraries

 - Another approach to client-side rendering.
   - Ember: Model <=> DOM
   - React: Model => Virtual DOM => DOM
     - Optimized from render(Model) => Display

https://www.youtube.com/playlist?list=PLoYCgNOIyGABj2GQSlDRjgvXtqfDxKm5b

## JSX

An XML style syntax that can be embedded in JavaScript.

Makes simple templates easy to use from code.

```
function green_header(x) {
    // Curly braces are embedded JS.
    // Capitalized tag names are vars.
    // var X = 'h1';
    // return <X ...></X>;
    return <h1 style="color: green">{ x }</h1>;
}

// Transpiles to:

function green_header(x) {
    return h('h1', { style: "color: green" }, x);
}

// "h" is the virtual DOM node constructor.
```

Like with Handebars, the templates are really functions that
produce HTML.

Unlike Handlebars, rather than producing HTML directly, we
produce the HTML tree as a data structure - structured the
same way that the browser structures it. The JS API to
HTML in the browser is called the DOM.

The structure produced by JSX for React is the virtual DOM.

This lets updates be clean and efficient:

 - The entire virtual DOM is regenerated when changes occur.
   - Like a game engine or Fundies 1 Big Bang program, we
     never miss anything by mistake.
 - Only things that are *different* between the virtual DOM
   and the real DOM are changed in real DOM, and so only the
   minimum change needs to be rendered by the browser.

## Setting up React with Babel on Phoenix

https://github.com/NatTuck/react-demo

``` 
$ mix phx.new react_demo --no-ecto
$ cd react_demo
```

```
$ cd assets
npm install --save react react-dom
npm install --save-dev babel-preset-react babel-preset-env
npm install --save babel-plugin-syntax-jsx
```

Setup for react:

```
  // brunch-config.js
  plugins: {
    babel: {
      ignore: [/vendor/],
      presets: ['env', 'react'],
    }
  },
```

Some standard libs.

```
npm install --save jquery
npm install --save popper.js@^1.12.3
npm install --save bootstrap@4.0.0-beta.2
```

Standard lib setup:

```
  // brunch-config.js
  npm: {
    enabled: true,
    globals: {
      $: 'jquery',
      jQuery: 'jquery',
      Popper: 'popper.js',
      bootstrap: 'bootstrap'
    }
  }
```

## Rendering JSX with React-DOM

```
<!-- lib/react_demo_web/templates/page/index.html.eex -->
<!-- replace contents: -->

<div id="header">
  <p>Header</p>
</div>

<div id="main">
  <p>Main</p>
</div>
```

```
// insert into app.js
import React from 'react';
import ReactDOM from 'react-dom';

function start() {
  let html = <h1>Hello, World</h1>;
  let main = document.getElementById('main');

  ReactDOM.render(html, main);
}

$(start);
```

## Adding a React component

```
$ mkdir assets/js/components
```

```
// assets/js/components/header.js
import React from "react";

// class!? JavaScript does't have classes
// Apparently ES2015 does though. And we can extend them.
export default class Header extends React.Component {
  render() {
    return (
      <h1>This is the header.</h1>
    );
  }
};
```


```
// app.js
...
import Header from './components/header';

function renderHeader() {
  let div = document.getElementById('header');
  ReactDOM.render(<Header />, div);
}

function start() {
  renderHeader();
  ...
```


## Hangman

https://github.com/NatTuck/hangman

 - lib/hangman_web/templates/page/index.html.eex
 - assets/js/app.js
 - assets/js/game.js

We have a model, and we want to render it to the page.

Standard plan in React is to have the model be a single
JS object. This object is the *state* of the top level
React component.

Here that component is Game, and gets an initial state
in its constructor.

 - Component constructor *must* call super(), first thing.
 - We can set an initial state in the constructor, but we
   can't mutate the state.
 - We can just set a whole new state with setState().

To render the page, React calls render():

This references four more components, and we pass each component
a part of the state.

Components other than the top level one tend to live in a "components"
directory, but there are a couple different ways to split them up.

 - assets/js/cs/word.js

"Attributes" we pass in to a component from JSX show up in the
"this.props" object.

Word is simple, just a template with a little bit of pure JS logic.

 - assets/js/cs/person.js
 - assses/js/cs/guesses.js

These are simple too.

 - assets/js/cs/input.js

This does a new thing - it passes a function for the onChange event of
an input box. The function is a prop, so we passed it in from the
parent component.

 - assets/js/game.js

onInput=[this.onInput.bind(this)]

We pass the onInput method of the current object (component), but we
also do "bind(this)". That means that when called as a function it
will act like a method on the current component.

 - So that calls the onInput method.
 - Which calls updateGuesses.
 - Which build a new state object and calls this.setState(...)
 - Which triggers a new render pass.

In React, one way binding from Model => Page is normal. Any change
to the model (e.g. setState) updates the page.

Two way binding can be simulated with callbacks like onChange - that's
what we have here. We also could have done one way binding the other
direction.

## Server-side Model

This react style setup gets even more amusing if we communicate with
the server to update our model.

Making this a multi-player game would be pretty straightforward.


