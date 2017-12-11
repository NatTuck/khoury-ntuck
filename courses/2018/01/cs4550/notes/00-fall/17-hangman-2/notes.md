---
layout: default
---

## First Thing

 - Project questions?

## Hangman: Crash on Z?

The bug:

 - Get a game state.
 - Input "Z"
 - Show mix phx.server output.
   - Last message.
   - State on crash.

Show process tree again:

 - iex -S mix phx.server
 - :observer.start()

## Design Change: Add a state process

 - Build lib/hangman/game_agent.ex
 - Add it to lib/hangman/application.ex as a worker
 - Update player_channel (will require restart).
 - Show observer again.
   - Crash the channel process, state survives.
   - The process tree shows supervisors. When a process
     crashes, it's parent is responsible for figuring out
     what to do next.
 - Note the race conditon of get + set.
   - What's the failure case?
   - Do we care?
   - Solution: a real Agent where we send the operation
     to the process to execute.
   - Disadvantage: Can crash the agent with bad operation.

## Generalization: GenServer

 - The model of a process that has state and handles messages
   kind of like async methods is a pretty common model.
 - There's a built in abstraction: GenServer
 - Let's translate GameAgent into a GenServer.

## Tradeoffs in Process Layout

 - Processes are pretty fast, but we still don't want drastically more of
   them than we need.
 - Processes are the error isolation boundary. If we want two pieces of state
   to be separate in the event of a crash, they need to be in separate processes.
 - Hangman could be one process per game, then even a state-effecting crash wouldn't
   effect other games.
 - Processes can run in parallel on separate processor cores.
 - Processes can be distributed across several different machines.

## Tools in Erlang/OTP

The primitives:

 - spawn
 - send
 - receive

The general process:

 - GenServer
 
The specific processes types:

 - Agent
 - Task

Supervision:

 - Supervisor
 - Application (a "library" is a kind of application in Erlang-land)

Including a library in your mix.exs file does two things:

 - Makes it possible to refer to modules from that library.
 - Starts the library's Application when our program starts up.


## OtpDemo

### GenServer Stack

```
$ mix new otp_demo
$ cd otp_demo && vim lib/otp_demo/stack.ex
$ iex -S mix
iex> {:ok, pid} = OtpDemo.Stack.start_link([1,2,3,4])
iex> OtpDemo.Stack.pop(pid)
```

### Agent Stack

Show stack2.ex

```
iex(1)> OtpDemo.Stack2.start_registry
{:ok, #PID<0.134.0>}
iex(2)> OtpDemo.Stack2.start_link(:goat)
{:ok, #PID<0.137.0>}
iex(3)> OtpDemo.Stack2.inc(:goat)       
:ok
iex(4)> OtpDemo.Stack2.inc(:goat)
:ok
iex(5)> OtpDemo.Stack2.get(:goat)
2
```


### Parallel Map with Tasks

Show pmap.ex

```
iex> :timer.tc(&OtpDemo.Pmap.seq_demo/0)
iex> :timer.tc(&OtpDemo.Pmap.par_demo/0)
```


