---
layout: default
---

# CS3650: IPC with Shared Memory

## First Thing

 - Homework Status?
 - Homework Questions?

## Looking at HW8

 - Quickly walk through program.
 - Show where changes are needed.
 - Discuss the thread termination problem.
   - Null job solution (need enough of them).
   - "closed" flag solution.
 
## Multi-process queue.

Threads vs. processes:

 - Threads share memory by default.
 - Processes can share memory if you set it up explicitly.
 
So we can build a queue to communicate between processes using
shared memory just like with threads.

Unfortunately, we need to use slightly different tools.

Threads give us mutexes and condition variables.

 - We can use mutexes and condition variables across
   multiple processes by setting an apprpriate "shared" attribute
   on initialization.
   
But we have one other issue: If we do shared memory the easy way - before fork() -
then we can't dynamically resize that memory later. This makes it easiest to use
a fixed-size queue.

And if we're going to use a fixed-size queue, we might as well use semaphores.

## Semaphores

### Look at sem-queue.c

Why is this OK?

We have threads sharing data so we need to worry about race conditions.

Another rule: Reading / writing from shared data is OK if we can guarantee
that:

 - No two threads will ever write to the same spot at the same time.
 - No thread will read from somewhere that isn't ready to read.
 
Semaphores give us the following behavior:

 - They store a number, which we can't look at.
 - We can decrement the number. If that would bring it below 0, we block instead.
 - We can increment the number. If that would bring it above 0, blocked threads
   get another opportunity to perform their decrement.

So in sem-queue.c, we have some relevent properties.

 - isem stores the number of free slots in the queue.
 - osem stores the number of full slots in the queue.
 - qii stores the number of items inserted so far
 - qjj stores the number of items removed so far

If we treat all of these as invariants, we can prove that
sem-queue.c has no race conditions.

  

### Transform sem-queue.c into shared-queue.c
   
 - Point out mmap, mmap flags.
 - Point out semaphore init "shared" flag.

## Forward to HW9

