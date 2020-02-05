---
layout: default
---

## First: HW questions

## Today 

Today we're continuing with threads and associated topics.

## Continuing Threads

Slides: [Synch and
Deadlock](http://ccs.neu.edu/home/ntuck/courses/2015/01/cs5600/slides/5_Synchronization.pptx)

(Start @ Slide 32, with "Types of Locks and Deadlock")

Threads: Quick Summary

 - Modern computers are multicore. Parallelism is mandatory for performance.
 - Parallelism with threads or processes implies concurrency.
 - Concurrency creates a mess: Data races.

You have a data race - which means your program should be assumed broken unless
demonstrated otherwise - if you have all three of the following:

 - Concurrent execution
 - Shared data between threads / processes.
 - Any thread writes to that shared data.

One way to solve data races is locks.

The lock rule:

 - Each piece of shared data has an associated lock.
 - All access (read or write) to the shared data is protected by the lock.

That's fine with one lock. But that leads to bad performance, and as soon as you
have two locks you risk deadlock.

Avoiding deadlock requires imposing program-wide programming rules like lock
ordering. These can be hard to enforce - they look like style rules, but they
must be followed perfectly across the entire program prevent breakage.

We'll see some code examples for threads next week or so. For now, let's move
on to some more slides.

## Scheduling

 - Slides:
   [Scheduling](http://ccs.neu.edu/home/ntuck/courses/2015/01/cs5600/slides/6_Scheduling.pptx)

