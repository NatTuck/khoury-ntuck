+++
title = "Adding React to Phoenix"
+++

This guide describes the steps to install React and configure the build tools to
support it starting with a fresh Phoenix 1.5.7 app.

## Initial state

We just did ```mix phx.new --no-ecto demo_app```

## Installing React and build deps

In the assets directory:

```
$ npm install react react-dom 
$ npm install --save-dev @babel/preset-env @babel/preset-react
```

Now we need to edit ```webpack.config.js``` to use the babel presets
we just installed.

In the module / rules section, modify the rule for JavaScript files to add the
"jsx" extension to the test and the presets, something like this:

```
 module: {
    rules: [
      {
        test: /\.(js|jsx)$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader',
          options: {
            presets: ['@babel/preset-env', '@babel/preset-react'],
          },
        }
      },
      ...
```

## Add a test React component

First we need a target where we can render our test component.

In ```lib/demo_app_web/templates/page/index.html.eex```, add this
somewhere near the top:

```
    <div id="root">
      React component loading...
    </div>
```

Next, we can add the component itself.

At the bottom of ```assets/js/app.js```, add something like this:

```
import React, { useState } from 'react';
import ReactDOM from 'react-dom';

function Demo(_) {
    const [count, setCount] = useState(0);

    return (
        <div>
          <p>Count: {count}</p>
          <p><button onClick={() => setCount(count + 1)}>+1</button></p>
        </div>
    )
}

ReactDOM.render(
  <React.StrictMode>
    <Demo />
  </React.StrictMode>,
  document.getElementById('root')
);
```

## Test it

Run your app with ```mix phx.server``` and visit http://localhost:4000

You should have a working counter with an increment button.

