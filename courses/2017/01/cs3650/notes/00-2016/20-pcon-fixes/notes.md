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
   one has finished. Handler functions are atomic. This means there usually 
   aren't data races.
 - No parallelism. Only one event is handled at a time.

This concurrency can still cause issues. You generally don't know what order
handlers will be called in, so you need to make sure this order doesn't matter.

This is the same model that Big Bang used in Fundies 1. Ticks and key events can
happen at any time. Handlers run in some order.

## Go: Message Passing

The Go language allows for multiple parallel threads of execution. Mutexes and such
are provided, but their use is discouraged. Instead, Go programmers are encouraged to
communicate between threads by passing messages over channels.

Messages usually work one of two ways:

 - The message is a *copy* of the object. Since every thread gets its own copy, nothing
   is shared and there are no data races.
 - The message is the *only pointer* to the object. Since the sending thread doesn't keep
   a copy of the pointer, nothing is shared and there are no data races.

Channels are objects shared by threads - queues of messages. Threads can generally send a
message on a channel without blocking. Trying to recieve a message on an empty channel will
block the recieving thread. This means that deadlock is still possible if a cycle of threads
block on recieve, each waiting for the others to send a message.

Channels are a very effective primitive for concurrency, and they can also be used to enable
parallelism, although reading to or writing from a channel can only happen sequentially. 

## Erlang (aka Elixir): Immutable Message Passing

Go tries to eliminate problems by reducing the amount of shared data.

Erlang removes the other condition for data races: It makes all data immutable. If no thread
can write to shared state, then data races are impossible.

Erlang is also where the Go developers got the idea of message passing. If you
can't write to shared state, you can't implement your own communication at all.
So every "process" (like a thread) in an Erlang program has a mailbox, and
processes can send messages to each other. Since the data is immutable, it
doesn't matter semantically if the messages are copies or pointers - you can't
tell the difference.

This model is great for concurrency, and great for executing concurrently
structured programs in parallel for a speedup. It's not the greatest for
parallel speedup though - Erlang runs in an interpreter, and mutation tends to
be pretty good for fast computation.

Message passing also works well in distributed systems. It doesn't change
anything if processes are running on multiple machines. Erlang uses this for
reliability - you can build systems that keep working even if you smash one
computer with a hammer.

## Clojure: Transactional Memory

Clojure is a LISP on the JVM.

Like Erlang, it takes the immutability path to deal with concurrency, but
instead of message passing it has a concept of "refs", which are mutable
references to immutable data.

Refs can be updated transactionally. Rather than avoiding data races,
transactions detect them and roll back / replay any transaction that ran on old
data.

Transaction Advantages: 

 - No data corruption from data races
 - No deadlock
 - No mutual exclusion needed for values that aren't written to during a transaction.

Transaction Disadvantages:

 - Need to handle rollbacks / replays. If transactions have side effects, those
   side effects may happen multiple times.
 - Slow transactions can be delayed pretty much forever by faster transactions
   that invalidate their inputs.

Transactions are the same strategy that databases use for concurrent updates.

See example here:

http://clojure.org/reference/refs

## Concurrency vs Parallelism

The above systems give you great concurrency. When your application
conceptually does many different things at a time, and you want to avoid data
races and deadlocks while maintaining some sort of consistent shared state,
they're exactly what you need.

But some applications don't look like that at all. Instead, they want to do
some sequence of computationally intensive operations as quickly as possible,
and they want to take advantage of parallel hardware in the process.

## OpenCL: Data Parallelism

OpenCL is a programming system for building programs that run on graphics
cards. Graphics cards, or GPUs, are a bit different from regular CPUs. Rather
than having one processor with a couple cores, they have a bunch of
"processors", each with hundreds of "shader units". A shader unit is basically
 a single vector ALU - something that can execute arithmetic instructions on
4 or so values in parallel.

On a GPU, it's perfectly reasonable to plan to execute 2000 additions in
parallel in one clock cycle.

The trick is that GPUs really like to perform the *same operation* in parallel.
In fact, each individual processor can generally only load one program to run
on its hundreds of shader units.

So instead of the basic addition operation adding together two numbers, on a
GPU it adds together two arrays. The arrays generally represent mathematical
vectors or matrices, but that's just a mental model. Anything where you want
to operate on entire arrays at once will work great on a GPU.

This programming model of performing the same operation in parallel on many
different values (elements of the array) is called data parallelism. It's
required on GPUs, but it's common on supercomputers too. When you have a
cluster of 1000 PCs, it's easier to think about them working together on one
array calculation than to reason about them individually.


