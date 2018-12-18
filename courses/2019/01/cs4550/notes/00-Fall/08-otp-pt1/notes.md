---
layout: default
---

# First: Homework Questions

 - Memory Game with Server-Side State is due Thursday
 - Make sure you've talked to your partner for HW05,
   any partner swaps want to happen before Thursday.

## OTP: Processes & State

```
# Can compile / recompile from iex
> c("stack.ex")
```

The problem:

 - Stack of integers: push, pop, print
 - More than one stack at a time.
 - Every five seconds, If the top integer is odd, add 2.
 
## Supervisors and Supervision Trees

**stack0.ex**

 - Manual state process.
 
**stack1.ex**

 - Use the built-in GenServer behavior.

**stack2.ex**

 - Add a Registry
 - What do we do when we want a bunch of processes?
 - We can register by arbitrary term with the Registry module.
   
**stack3.ex**

 - Add a Supervisor
 - Supervisor: Start & Monitor processes, potentially restart them when they crash.
 - In this case, DynamicSupervisor

## Supervisor Concepts

**Supervision Tree**

 - Supervisor module takes a static list of children and keeps them running.
 - DynamicSupervisor handles workers spawned at runtime.
 - Spin up hangman & show tree in observer.

**Links?**

If a child is linked to a parent, the parent gets an exit message when the
parent dies. 

**Trapping exit?**

A process that gets an exit message will exit itself unless it's configured to
trap exits. Trapping exits is what lets supervisors work.

## Alternate Plans

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


