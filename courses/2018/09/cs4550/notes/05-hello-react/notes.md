---
layout: default
---

## Homework questions?

 - Starter code for HW03 is posted.

## TODO App

TODO state:

 - The state of the TODO app is a list of tasks.
 - Each task has a description and a "done?" flag.

TODO rendering:

 - Bulleted list
 - toggle buttons 
 - new item form.

 - Write todo.jsx

### Hangman

Create assets/js/hangman.jsx:

```
import React from 'react';
import ReactDOM from 'react-dom';

export default function hangman_init(root) {
  ReactDOM.render(<Hangman />, root);
}

class Hangman extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return <div>
      <h2>Hangman loaded.</h2>
    </div>;
  }
}
```

Call your new component from assets/js/app.js:

```
// Add to bottom of app.js
import hangman_init from "./hangman";

window.addEventListener("load", (_ev) => {
  let root = document.getElementById('root');
  if (root) {
    hangman_init(root);
  }
});
```

### Design for Hangman

The game:

 - There's a secret word.
 - The player trys to guess the letters in the word.
 - The letters in the word are shown, initially as blanks and
   then as letters once correctly guessed.
 - The player has a fixed number of bad guesses available, they
   lose if they run out.

The game state:

 - The word
 - The guesses so far
 - Max guesses allowed

### Hangman Code

 - hangman.jsx

### Setup for Deployment

 - Add elixir module: distillery.

Update config/prod.exs

```
config :hangman, PhoenixDistilleryWeb.Endpoint,
  http: [port: {:system, "PORT"}],
  # This is critical for ensuring web-sockets properly authorize.
  url: [host: "localhost", port: {:system, "PORT"}], 
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true,  # <=== THIS IS WHAT YOU MISSED
  root: ".",
  version: Application.spec(:phoenix_distillery, :vsn)
```
 
 - mix release.init
 - edit rel/config.exs

Worry about secrets:

 - config/prod.secret.exs - Copy manually from dev machine.
 - rel/config.exs - Random cookie code; will break if we try to run in a cluster.

```
cookie = String.to_atom(Base.encode16(:crypto.strong_rand_bytes(32)))
```
 - There should *never* be secrets in your git repo.

### Deploy Hangman

 - Work from deployment script for memory.

