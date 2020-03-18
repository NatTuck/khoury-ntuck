---
layout: default
---

## Solutions for Concurrency and Parallelism

The problem (parallelism):

 - Modern computer have multiple cores.
 - To take advantage, we need to write parallel programs.
   - Parallelism is non-optional for programs where performance matters.
 - By default, that means threads => shared memory => data races.
 - So by default, all parallel programs are wrong.

The problem (concurrency):

 - Some problems are logically concurrent even though there may not
   need parallelism for performance.
 - Example: Network chat server.
 - Alice and Bob connect to the server. The server doesn't know which
   user will send a message first, so it needs to listen to both.
 - Having a thread for each connection allows the program to be written
   in a straightforward way, but threads => shared memory => data races.
 - And when we have a *lot* of connections, performance matters again,
   and it seems reasonable that a concurrent program can get a parallel
   speedup.

## Primitives & Abstractions

How do we write correct concurrent & parallel programs?

 - The hardware gives us atomic instructions.
 - Those let us build mutexes & condvars or semaphores.
 - But even with those, our programs are probably wrong and slow.

The primitives are nice because they make it possible to write any program that
the hardware allows. But to make our programs correct, we need to add
constraints - either by convention, or in the tools we use.

Some modern languages pick impose specific constraints and concurrency patterns
that help.

Conditions for a data race:

 - Concurrency + premption or parallelism. 
 - Shared data.
 - Mutable data.
 
Conditions for a deadlock:

  - Hold and wait
  - Circular dependency
  - mutual exclusion with no pre-emption

If we eliminate any of those conditions, we can avoid the problems.


