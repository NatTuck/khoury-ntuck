---
layout: default
---

 - Mo/Th:  	EL 312 	 11:45am - 1:25pm
 - Tu/Fr:   WVG 102	  3:25pm - 5:05pm

## The HW: Memory Game

 - Show game running.

## HW Questions?

 - Today we'll talk more about React, and actually build Hangman.

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

## Game

### Show Hangman

Layout for Hangman:

 - Detour to Bootstrap

### Bootstrap

http://getbootstrap.com/

Docs:

 - Layout / Grid
   - Mobile First
   - Device Sizes
 - Components
   - Alerts
   - Breadcrumb
   - Card
   - Forms
 - Utilities
   - Sizing
   
You should scan through all of this and be aware of what's available.

### Grid System

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

Start layout as 4 "col-6" in a row, mark with
headers.

### Hangman

Data for Hangman:

 - Secret Word: String
 - Guessed Letters: String

Four quadrants:

 - Secret word letters guessed and to-be-guessed.
 - Guesses left.
 - Letters guessed that don't appear in word.
 - Input Box

**Finish hangman.jsx**

## Deployment

Create new user account.

```
$ sudo su -
# pwgen 12 1
# adduser hangmanX
# sudo su - hangmanX
```

Check out hangman.

```
$ git clone https://github.com/NatTuck/hangman2.git 
```

Install the nginx config:
 
 - Make sure to pick a new port (5101 / 5102).
 - Hostname
 - Enable
 - Restart
 
Add distillery to mix.exs:

```
{:distillery, "~> 1.5", runtime: false}
```

 - mix release.init
 - rel/config.exs defaults are fine for now

Walk through the deploy steps:

 - see deploy.sh
 - Start at mix deps.get
 - Need to recompile libsass.
 - server: true

```
#import_config "prod.secret.exs"

config :hangman, HangmanWeb.Endpoint,
    secret_key_base: "THIS+IS+NOT+SECURE+DONT+USE+SESSION+COOKIES+WITHOUT+FIXING"
```

After running mix release, skip straight to:

```
PORT=5101 _build/prod/rel/hangman/bin/hangman foreground
```

 - Point out this: 
 - _build/prod/rel/hangman/releases/0.0.1/hangman.tar.gz
 - This can conceptually be copied to a machine with the same OS as the build machine
   but no erlang / elixir / nodejs for deployment.
 - I'm suggesting on-server builds for ease of debugging.

```
PORT=5101 _build/prod/rel/hangman/bin/hangman start
```

 - @reboot crontab rule

**upgrades**

 - Git pull
 - Redeploy

