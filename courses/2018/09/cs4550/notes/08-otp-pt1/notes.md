---
layout: default
---

# First: Homework Questions

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

**stack2.ex**

 - Registry
 - What do we do when we want a bunch of processes?
 - We can register by arbitrary term with the Registry module.
   
**stack3.ex**

 - Supervisor
   - Start & Monitor processes, potentially restart them when they crash.
 - Strategies: :simple\_one\_for\_one is the weird one.
   - Will use a separate DynamicSupervisor module in Elxir 1.6

## Supervisor Concepts

Links? 

If a child is linked to a parent, the parent gets an exit message when the
parent dies. 

Trapping exit?

A process that gets an exit message will exit itself unless it's configured to
trap exits. Trapping exits is what lets supervisors work.

