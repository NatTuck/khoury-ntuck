---
layout: default
---

# First: Homework Questions

## OTP: Processes & State

**Build to GenServer, Agent**

```
# Can recompile from iex
> c("bank_proc.ex")
```

**bank_proc.ex**

```
> bank = BankProc.start
> send(bank, {:deposit, "alice", 100})
> send(bank, {:get_bal, "alice", self()})
> flush()
```

 - Fill in API functions with PID parameter.
 - Move API functions to use registered name.
 - show :observer.start()
 
**bank_gens.ex**

 - GenServer provides a standard implementation of a process with state.
 - A bit boilerplate-ish, but this is the core building block of pretty
   much everything in Erlang / Elixir.
 - better introspection, show :observer.start()
 - look up the "handle\_info" callback for aribtrary message handling,
   e.g. for :timer.send\_after
 
**stack.ex**

 - Ok, bank is a little complicated.
 - Let's just build a stack.
 - Agent
 - The special case of a genserver where you really just want to hold data.
 - Doesn't handle custom messages, just provides get and update operations.
 - Update is run in the agent process - atomic but not parallel.
   

## Hangman Code

 - Github: https://github.com/NatTuck/hangman2
 - Before: server-state branch
 - After: proc-state branch

### GameBackup

 - Last time we stored our game state in the channel's "socket".
 - This has some advantages:
   - The data survives exactly as long as the connection.
   - Each game gets a separate process for updates, so it's
     nicely parallelizable. 
   - Games are entirely independent. 
 - And some disadvantages:
   - We lose the data if we lose the connection.
   - We lose the data for a game if processing crashes.
   - No way to access data from another channel connection,
     so no multi-user apps.

Plan B: GenServer with put and get ops, change game in channel process.

 - No data loss on disconnect.
 - No data loss on crashes.
 - One shared map - doesn't scale well.
 - Calculating new state is in channel process, so scaling may be fine.
 - Race condition: Updates (get, change, put) aren't atomic.
 - Resource leak: Game data never cleaned up.
 
Plan C: One Global Agent with a Map

 - No data loss on disconnect.
 - Updates are atomic, so no data race.
 - All updates occur in single agent process: worst scaling
 - A crash in an update crashes the agent process, losing everything.
 - Resource leak: Game data never cleaned up.
 
Plan D: One Agent Per Game

 - No data loss on disconnect.
 - Scales well.
 - Lose one game on crash.
 - Updates are atomic.
 - Resource leak: Game data & process never cleaned up

Plan E: One global agent with map, put/get ops, treat as backups.

 - Like B, except data race only occurs on disconnect / crash.
 - Like A, except previous game state recoverable on disconnect / crash.

There isn't really a right answer in general. Processes with state are a tool,
and figuring out how to use them is a key software design question in Elixir
apps.

But... we'll use plan E for Hangman.

Steps: 

 - Write **game\_backup.ex**
 - Add a new child to the main app supervisor

in lib/hangman/application.ex:

```
  worker(Hangman.GameBackup, []),
``` 


in games_channel.ex:

```
# Get initial game on join
game = Hangman.GameBackup.load(name) || Game.new()

# Save game after generating new state.
Hangman.GameBackup.save(socket.assigns[:name], game)
```

## Supervisors and Supervision Trees

**stack2.ex**

 - Registry
 - What do we do when we want a bunch of processes?
 - We can register by arbitrary term with the Registry module.
   
**stack3.ex**

 - Supervisor
   - Start & Monitor processes, potentially restart them when they crash.
 - Strategies: :simple\_one\_for\_one is the weird one.
   - Will use a separate DynamicSupervisor module in Elxiir 1.6

Links? 

If a child is linked to a parent, the parent gets an exit message when the
parent dies. 

Trapping exit?

A process that gets an exit message will exit itself unless it's configured to
trap exits. Trapping exits is what lets supervisors work.

