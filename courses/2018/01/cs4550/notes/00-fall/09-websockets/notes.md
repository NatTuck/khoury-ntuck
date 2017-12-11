---
layout: default
---

4550 is 11:45 to 1:25

3650 staff meeting in WVH 166 at 1:45

# Websockets

## Schedule and Catch-Up

 - The goal of the Microblog app is to get everyone up to speed on the basics of
   web dev with Elixir / Phoenix / JavaScript before the project.
 - We have two more Microblog assignments:
   - Live feed updates.
   - Password security & general polish.
 - As I posted on Piazza, some students are behind on the material.
 - The material is complex - and the course style hasn't worked well for everyone.
 - Pre-project objectives:
   - Local development environment
     - Ubuntu VM or alternative
     - Good editor configured for syntax highlighting and auto-indent.
     - Dev tools installed, app up and running in dev mode.
   - Comfortable with basic HTML / CSS.
   - Comfortable with Elixir language.
   - Comfortable with Phoenix framework and libs (Ecto, Plug, etc), at least enough
     that the documentation is helpful.
   - Comfortable with JavaScript
   - Comfortable with jQuery
   - Able to find other JS libraries and use them from their docs.
   - Able to get both AJAX and Websockets working, both on the Phoenix and JS sides.
   - Have a VPS up and running.
   - Comfortable with Phoenix app deployment behind Nginx on VPS.
 - If you're behind, there's still time to catch up. Let me know if you need help.

## Draw App

The git repo is at https://github.com/NatTuck/draw

 - Pull up deployed app.
 - Get everyone to connect.
 - Play a couple rounds (until repeat words get lame).

Go over the app:

 - Landing page requests player name and game name.
 - That hits game_controller#join
 - That calls Game.join
 - Game has an Agent
   - An agent is separate concurrent process with state.
   - In this case, the agent holds a map[Game Name]=>[Game]
   - There's one Agent process, started at app boot.
 - Show lib/draw/application.ex
   - Endpoint controlls the web server.
   - Specifying worker(Draw.Game, ...) calls start_link on the module to
     start the process.
   - Back in game.ex - start_link starts the Agent process and registers
     it with a global name (Draw.Game)
 - So the Game module stores global application state in memory, accessible
   to all other parts of the app.
 - The Draw app has no database. Game has the only shared state.
 - In game.ex:
   - First player to join becomes host (person who draws).
   - Later players start as guessers.
   - We store state { name, host (draw-er), word } for each active game.
 - Back in game_controller:
   - In join, once we have the game info, we redirect to show
   - Show gets the game again (new request, new process) and renders the template.
 - In the game/show template:
   - We have controls for draw-er and guesser.
   - We have a canvas to draw on.
   - We have some initial game state config as a JS var.
 - The real magic happens in draw.js
 - Pull in create.js, a JS graphics lib.
 - Join a "channel".
   - Phoenix gives us a websocket library stock.
   - We can connect to websocket "channels", allowing us to send and recieve
     messages with the server.
   - We connect to a channel called "game:{game name}"
   - We hook up some handlers for incoming messages. Each incoming message
     has a tag, and we hook up separate handlers for separate tags.
   - We have draw, clear, and guess events.
 - If the user is drawing, they can:
   - Click the clear button.
     - This clears the canvas.
     - This sends a "clear" message down the channel to the server.
   - Draw on the canvas.
     - This is triggered by a "pressmove" (mouse drag) event.
     - This sends a "draw" message down the channel to the server,
       containing line segments to draw.
 - The server end of the channel is in channels/game.ex
   - When a user joins, the join function is called.
     - This happens through a "socket", which a persistent connection
       from the client to the server.
     - The socket will stick around until the user disconnects.
     - Just like a "conn", we can stick data in an assigns map.
   - When a message is recieved, handle_in is called.
     - We pattern match on the message tag, the first argument.
     - For draw and clear messages, we just broadcast them back
       out to any clients connected to the channel.
 - Back in draw.js, when these messages are recieved:
   - "draw" draws line segments on the screen.
   - "clear" clears the canvas.
 - Guessers can guess the word being drawn.
   - This sends a "guess" message to the server.
   - So we get handle_in("guess", ...)
   - If they're right, we make them the next draw-er.

## Setting up Phoenix Channels

Create the channel module:

```
$ mix phx.gen.channel Foo
```

Set up the socket.js correctly:

 - Uncomment it in app.js
 - Pass an authentication token to prevent spoofing.
 - Verify that in the join function in your channel.
 - Write JS and Elixir to implement the app logic.

## Project Teams

 - Check who has teams.


