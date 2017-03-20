---
layout: default
---

# CS3650: IPC with Shared Memory

## First Thing

 - Homework Questions?

## Look at HW09

 - Same task as HW08
 - Difference: Processes instead of threads.
 - Same queue purpose as HW08.
   - Except fixed size to fit in fixed shared memory.
   - Fixed size means array / ring buffer makes more sense.
 - Semaphores and atomics instead of mutexes and cond vars.
 - Idea: replace the HW08 queues with shared-queue.

Problems:

 - HW08 uses dynamic arrays. These require a resize operation.
 - We're custom allocating the shared space for the queue, so 
   we can't just realloc to get more space.
 - mremap doesn't save us - there's no way to sync up the
   remapped range between the separate processes.
 - So all the memory must be allocated up front.
 
 - Solution - fixed size queue with fixed size jobs stored
   directly in the queue.
 - HW09x - Solve it the hard way.


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

### Transform sem-queue.c into shared-queue.c
   
 - Point out mmap, mmap flags.
 - Point out semaphore init "shared" flag.


