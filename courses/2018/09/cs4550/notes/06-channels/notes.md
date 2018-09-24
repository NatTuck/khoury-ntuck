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
# Go ahead and put line in user_socket.ex
```
  
Add to .../user_socket.ex:

```
  channel "games:*", HangmanWeb.GamesChannel
```

Open .../js/socket.js - scan through.

 - userToken for transferring session from cookie -> websocket.
 - Move the channel join stuff over to app.js

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
  <div class="col">
    <h1>Join a Game</h1>
    <p><input type="text" id="game-input"></p>
    <p><button id="game-button"></button></p>
    <p id="game-output"></p>
  </div>
</div>
```

Edit app.js:


```
import socket from "./socket";

function form_init() {
  let channel = socket.channel("games:demo", {});
  channel.join()
         .receive("ok", resp => { console.log("Joined successfully", resp) })
         .receive("error", resp => { console.log("Unable to join", resp) });

  $('#game-button').click(() => {
    let xx = $('#game-input').val();
    channel.push("double", { xx: xx }).receive("doubled", msg => {
      $('#game-output').text(msg.yy);
    });
  });
}

import game_init from "./hangman";

function start() {
  let root = document.getElementById('root');
  if (root) {
    game_init(root);
  }

  if (document.getElementById('index-page')) {
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
  <div class="col">
    <h1 id="index-page">Join a Game</h1>
    <p><a href="/game/demo">Join</a></p>
  </div>
</div>
```

game.html.eex:

```
<div class="row">
  <div class="col">
    <h1>Hangman Game: <%= @game %></h1>
    <script>
      window.gameName = "<%= @game %>";
    </script>
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
    channel.join()
           .receive("ok", resp => { console.log("Joined successfully", resp) })
           .receive("error", resp => { console.log("Unable to join", resp) });

    game_init(root, channel);
  }

  if (document.getElementById('index-page')) {
    form_init();
  }
}

$(start);
```

Write attached code:

 - Hangman.Game (games.ex)
 - GamesChannel 
 - hangman.jsx


