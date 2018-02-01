---
layout: default
---

# First: Homework Questions

## Proccesses 

Tick example

 - Processes
 - IO (side effects)
 - Send / Receive
 - Pattern matching for control flow
 - Maps
 - Process with state pattern

## Parallel Map with Tasks

Show pmap.ex

```
iex> :timer.tc(&OtpDemo.Pmap.seq_demo/0)
iex> :timer.tc(&OtpDemo.Pmap.par_demo/0)
```

## Shared State with Procs

**shared_state.ex**


## Tour of Phoenix App

```
mix phx.new demo --no-ecto
```

In lib

 - demo - The app
   - applicaiton.ex - "main"
 - demo_web - The web app
   - Plug: Pure functions from request -> response
     - Made up of pure functions from conn -> conn
   - Request starts in router.ex
   - Routed to a controller
   - If a controller "renders":
     - Routed to a view.
     - View generally renders template.

Add a form and a post path:

```
 post "/form", PageController, :form
```

Watch the log, use that to fill in the rest.


