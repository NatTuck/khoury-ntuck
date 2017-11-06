---
layout: default
---

## First Thing

 - Project part 2/3 due tonight.
 - Project questions?

## Hangman: Client-Server

We'd like to make Hangman multiplayer.

But first, let's move the single-player game logic to the server.

This requires splitting the game state into two parts:

 - Client state - What's needed to render the page.
 - Server state - Full game state.

Two main considerations for splitting state:

 - Secrets: Don't want to share too much with client. (Shouldn't send the full word)
 - Performance: Want to consider size and frequency of messages - might not send full
   state. (Not really relevent to Hangman
   
New server state:

 - word: The correct word to guess
 - guesses: List of letters guessed so far

New client state

 - skeleton: The word with guessed letters filled in.
 - goods: Guessed letters that appear in the word.
 - bads: Guessed letters that don't appear in the word.

This is less fields than before. All the other values can be
calculated either from these fields or from known constants (like
max guesses).

Need client-server communication: Websockets.

```
mix phx.gen.channel Player
```

Add to channels/user_socket.ex

```
channel "player:lobby", HangmanWeb.PlayerChannel
```

Add token to router:

```
  # Add this to the pipeline.

  def set_user(conn, _params) do
    user  = "jake"
    token = Phoenix.Token.sign(HangmanWeb.Endpoint, "username", user)
    conn
    |> assign(:user_name,  user)
    |> assign(:user_token, token)
  end
```

Add token to layout.

```
<%= if @user_token do %>
<script>
  window.user_name  = "<%= @user_name %>";
  window.user_token = "<%= @user_token %>";
</script>
<% end %>
```

Clean up socket.js:

 - Add semicolons
 - Use window.user_socket in socket connect
 - Move channel join code to app.js

```
  let channel = socket.channel("player:" + window.user_name, {});
```

Verify token in user_socket:

```
  def connect(%{"token" => token}, socket) do
    case Phoenix.Token.verify(socket, "username", token, max_age: 86400) do
      {:ok, name} ->
        socket = assign(socket, :username, name)
        {:ok, socket}
      {:error, _} ->
        :error
    end
  end
```

Fix up player_socket:

```
defmodule HangmanWeb.PlayerChannel do
  use HangmanWeb, :channel
  alias Hangman.Game

  def join("player:" <> name, _payload, socket) do
    if authorized?(socket, name) do
      game = Game.new()
      socket = socket
      |> assign(:game, game)
      |> assign(:name, name)
      {:ok, Game.client_view(game), socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("guess", %{"letter" => ll}, socket) do
    game = Game.guess(socket.assigns[:game], ll)
    socket = assign(socket, :game, game)
    {:reply, {:ok, Game.client_view(game)}, socket}
  end

  defp authorized?(socket, name) do
    socket.assigns[:username] == name
  end
end
```

Additional notes:

 - game.ex
 - game.js
 - letters.js

## New Feature: Crash on Z

 - Add crash on Z input to player_channel.ex
 - Game crashes.
 - Quickly recovers.
 - Game state lost.




