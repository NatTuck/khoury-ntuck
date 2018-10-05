---
layout: default
---

# First: Homework Questions

 - Two player game is next week.
 - I've only gotten one team request. I'll still accept requests today.
 - How many people have contacted their assigned partner?

## Multi-player Hangman: Design

### The rules

 - There are multiple, named games.
 - Each game has multiple, named players.
 - Anyone can guess a letter.
 - Guessing a letter gives that player a 10 second cooldown.
 - You get a point for each correctly guessed letter during a won game.

### Design

App state:

 - word: String
 - guesses: Set of LetterString
 - players: Map of Name to PlayerInfo

A PlayerInfo contains:

 - Score: Int # surives across games
 - Guesses: set of LetterString # guesses this game
 - Cooldown: Either[nil or time when cooldown expires]

Time: :os.system\_time(:milli\_seconds)

Player View:

 - skel
 - goods
 - bads
 - max
 - players: %{ name => guesses }
 - cooldown: nil or milliseconds left

## Hangman: App Code

 - https://github.com/NatTuck/hangman
 - start branch: backup-agent
 - end branch: multiplayer

### Join Form and Authenticated Socket

First, let's add the form to log in.

.../templates/page/index.html.eex

```
<div class="row">
  <div class="column">
    <h1>Join a Game</h1>
    <%= form_for @conn, "/join", [as: :join], fn f -> %>
      <p>Your Name: <%= text_input f, :user %></p>
      <p>Game Name: <%= text_input f, :game %></p>
      <p><%= submit "Join" %>
    <% end %>
  </div>
</div>
```

lib/hangman_web/router.ex

```
scope "/", HangmanWeb do
  ...
  post "/join", PageController, :join
```

.../controllers/page_controller.ex

```
  def join(conn, %{"join" => %{"user" => user, "game" => game}}) do
    conn
    |> put_session(:user, user)
    |> redirect(to: "/game/#{game}")
  end

  def game(conn, params) do
    user = get_session(conn, :user)
    if user do
      render conn, "game.html", game: params["game"], user: user
    else
      conn
      |> put_flash(:error, "Must pick a username")
      |> redirect(to: "/")
    end
  end
```

lib/hangman_web/router.ex

```
pipeline :browser do
  ...
  plug HangmanWeb.Plugs.PutUserToken
end
```

lib/hangman_web/plugs/put\_user\_token.ex

```
# Hints in comments in generated socket.js
defmodule HangmanWeb.Plugs.PutUserToken do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    if user = get_session(conn, :user) do
      token = Phoenix.Token.sign(conn, "user socket", user)
      assign(conn, :user_token, token)
    else
      assign(conn, :user_token, "")
    end
  end
end
```

lib/hangman\_web/channels/user\_socket.ex

```
  def connect(%{"token" => token}, socket, _connect_info) do
    # max_age: 1209600 is equivalent to two weeks in seconds
    case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
      {:ok, user} ->
        IO.puts("socket connect from user = #{user}")
        {:ok, assign(socket, :user, user)}
      {:error, reason} ->
        :error
    end
  end
```

.../templates/layout/app.html.eex

```
<script>
  window.userToken = "<%= @user_token %>";
</script>
```

 * move the socket.connect() call from socket.ex to app.js to be run only
   on the game page.
 * restart the server - now we have authenticated sockets.


### Managing Game State

 - We can't store state in channel processes - there are multiple users
   connected to multiple different channels for each game.

Simple solution: One GenServer manages state for all active games.

 - Problem: Any crash breaks everything.

```
$ rm lib/hangman/backup_agent.ex
```

lib/hangman/application.ex

 * in supervisor children, replace BackupAgent with Hangman.GameServer


More updates to:

 * games channel
 * game
 * game server



