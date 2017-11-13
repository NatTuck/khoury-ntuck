---
layout: default
---

## First Thing

 - Project questions?

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
iex(3)> OtpDemo.Stack2.push(:goat, 1)       
:ok
iex(4)> OtpDemo.Stack2.push(:goat, 2)
:ok
iex(5)> OtpDemo.Stack2.pop(:goat)
2
iex(5)> OtpDemo.Stack2.pop(:goat)
1
iex(5)> OtpDemo.Stack2.pop(:goat)
<crash>
```

 - The registry module lets register global identifiers
   for things more complex than simple atoms. 
 - e.g. {:stack, 1} lets us name an infinite number of stacks
 - Unfortunately, popping from an empty stack crashes *everything*,
   including other stacks and the registry.

Process Tree:

 - iex
   - Registry
   - Stack 1
   - Stack 2

 - When stack 1 crashes, the crash propagates up the tree, crashing IEx.
 - When IEx crashes, it shuts down its children.
 - This continues up the tree until we hit a process that traps exceptions.
 
### Supervised Stack

Show stack3.ex

Process tree:

 - iex
   - Registry
   - Supervisor
     - Stack 1
     - Stack 2
     
Supervisors are processes that do three things:

 - Spawn children
 - Trap exits so crashes don't take down the whole app
 - Monitor children and restart them when needed

Strategies - when to restart processes?

 - one for one: If a process dies, restart it.
 - one for all: If a process dies, restart all children.
 
simple one for one: Special case restart strategy

 - We'll be passing arguments into start_child
 - Otherwise one for one
 
### Supervision Trees

An Elixir program is just a tree of supervisors with worker leaves.

 - "Root" App
   - Your app
     - Sup 1
       - Worker 1
       - Worker 2
   - Dependency App 1
     - ...
   - Dependency App 2
   - ...

## Parallel Map with Tasks

Show pmap.ex

```
iex> :timer.tc(&OtpDemo.Pmap.seq_demo/0)
iex> :timer.tc(&OtpDemo.Pmap.par_demo/0)
```

Task in map could be anything: HTTP request, whatever.

