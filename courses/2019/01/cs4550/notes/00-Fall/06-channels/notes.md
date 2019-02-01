---
layout: default
---

# First: New Homework

 - Expand on Memory Game
 - Move state and game logic to the server
 - Use websockets to communicate
 - Use Elixir processes to maintain state

## Websockets

 - We've seen HTTP
   - GET downloads something (e.g. a page)
   - POST sends data to the server (e.g. a form)
 - With JS, basic HTTP methods can do a *lot*.
 - But- basic HTTP requires that the client initiate all requests.
 
Websockets simulate TCP over HTTP.

 - HTTP is already over TCP, but... firewalls are dumb.
 - This lets us send messages in either direction.
 
## Server-Side Hangman

 - Code: https://github.com/NatTuck/hangman
 - Before code: The "browser-only" branch.
 - After code: The "server-state" branch.

```
$ mix phx.gen.channel games
```
  
Add to .../channels/user_socket.ex:

```
  channel "games:*", HangmanWeb.GamesChannel
```

Open .../js/socket.js - scan through.

 - userToken for transferring session from cookie -> websocket.
 - Move the channel join stuff over to app.js
 - Set the channel to join as "games:default"

Add to head in .../layout/app.html.eex

```
    <script>
      window.userToken = "TODO";
    </script>
```

Add a route, to .../hangman_web/router.ex

```
    get "/game/:game", PageController, :game
```

Add a function to page_controller.ex

```
  def game(conn, params) do
    render conn, "game.html", game: params["game"]
  end
```

Copy the index.html.eex page to game.html.eex

Edit index.html.eex to this:

```
<div class="row">
  <div class="column">
    <h1>Join a Game</h1>
    <p><input type="text" id="game-input"></p>
    <p><button id="game-button">Double</button></p>
    <p id="game-output"></p>
  </div>
</div>
```

Let's look at this socket thing. First, install jQuery and lodash.

```
assets$ npm install --save jquery lodash
```

Edit app.js:


```
import $ from 'jquery';

//...

import socket from "./socket";
import game_init from "./hangman";

let channel = socket.channel("games:demo", {});
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) });
  
function form_init() {
  $('#game-button').click(() => {
    let xx = $('#game-input').val();
    console.log("double", xx);
    channel.push("double", { xx: xx }).receive("doubled", msg => {
      console.log("doubled", msg);
      $('#game-output').text(msg.yy);
    });
  });
}

function start() {
  let root = document.getElementById('root');
  if (root) {
    game_init(root);
  }

  if (document.getElementById('game-input')) {
    form_init();
  }
}

$(start);
```

Edit games_channel.ex

```
  def join("games:" <> name, payload, socket) do
    if authorized?(payload) do
      {:ok, %{"join" => name}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # ...

  def handle_in("double", payload, socket) do
    xx = String.to_integer(payload["xx"])
    resp = %{  "xx" => xx, "yy" => 2 * xx }
    {:reply, {:doubled, resp}, socket}
  end
end
```

## Now lets serverize Hangman

Update index.html.eex:

```
<div class="row">
  <div class="column">
    <h1 id="index-page">Join a Game</h1>
    <p><a href="/game/demo">Join "demo"</a></p>
  </div>
</div>
```

game.html.eex:

```
<script>
 window.gameName = "<%= @game %>";
</script>

<div class="row">
  <div class="column">
    <h1>Hangman Game: <%= @game %></h1>
    <div id="root">
      <p>React app not loaded...</p>
    </div>
  </div>
</div>
```

app.js

```
import socket from "./socket";
import game_init from "./hangman";

function start() {
  let root = document.getElementById('root');
  if (root) {
    let channel = socket.channel("games:" + window.gameName, {});
    // We want to join in the react component.
    game_init(root, channel);
  }
}

$(start);
```

Write attached code:

 - First, the abstract game: Hangman.Game (games.ex)
 - Communicate with browser: GamesChannel 
 - JSX code becomes pure UI: hangman.jsx


