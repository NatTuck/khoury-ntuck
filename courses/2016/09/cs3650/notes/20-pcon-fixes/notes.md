---
layout: default
---

# CS3650: POSIX Threads - Examples

## First Thing

 - Homework Questions?

## Problems with Concurrency

 - Shared data causes data races.
 - Locks solve data races, cause deadlock.
 - Careful analysis solves deadlock, causes unmaintainability.

## Problems with Parallelism

 - Everything from Concurrency
 - Want speedup
 - Sequentialized execution becomes a failure case.

## JavaScript: Non-Parallel Events

 - Browser JavaScript needs to handle a couple types of concurrency:
   - User actions (clicks) could happen at any time.
   - Responses to network requests could happen at any time.
   - setTimeout(func, when) will run a function after a delay.
   - Some code runs either during or after a page is loaded.
 - These are events. Code to handle them needs to run, but we can't
   specify the order for "simultaneious" events.
 - So JavaScript has an event loop. Events go on a queue, and the handler
   code is run. When one handler is done, the next event on the queue is 
   handled. 

This has some interesting properties:

 - No pre-emption. The next event handler can't start until the previous
   one has finished. This means there usually aren't data races.
 - No parallelism. Only one event is handled at a time.

This concurrency can still cause issues. You generally don't know what order
handlers will be called in, so you need to make sure this order doesn't matter.

## Erlang

 - Immutable data
 - Message passing
 - Parallel processes

## Clojure

 - Immutable data
 - Transactional memory

## OpenCL: Data Parallelism





