---
layout: default
---

# CS3650: POSIX Threads

## Firster Thing

 - Honor Students interested in undergrad research opportunities: Cooperman has
   an open slot for his checkpoint research. If you're an honor student you got
   an email about this - check for Cooperman's project.

## First Thing

 - Homework Questions?

## Summing numbers.

 - Go over seq-sum101
 - Time the execution

## Adding threads.

 - thread-sum101
 - Time the execution
 - Wrong answer?
 - Data race!

 - We have threads. We can now assume our program is wrong.
 - It'll stay wrong until we can explicitly demonstrate that there are no data races.

## Fix it with a mutex.

 - mutex-sum101
 - Time the execution
 - Slower than without the mutex
 - Correct answer though
 - Lock contention!
 - Only 1% of loop iterations need lock, so still get some speedup.
 - Locking mutex isn't free even without contention.
 - Good for concurrency.
 - Need to be careful to get parallel speedup.

 - Basic rules: 
    - Any write to shared data is a data race.
    - Any read of shared data that someone else writes to is a data race.
    - The data race can be avoided by protecting all accesses (read or write) with a mutex.
    - Unless you're sure no writing occurs, assume it does. A data structure may write even on read.
    - If we have threads and all access to shared data is protected by mutexes, we're safe from
      data races. But we can still assume our program is wrong.

## Deadlock

 - awesome.c
 - Walk through code and then run it.
 - It froze.
 - Deadlock.

Any program with mutexes is succeptable to deadlock unless:

 - No thread ever locks more than one mutex at a time.
 - Mutexes are only ever locked in a fixed, global order.
 - You can otherwise prove no cycle of blocking will occur.

## Fast parallel version.

 - par-sum101
 - Time the execution
 - As fast as the broken version - but gives the right answer.
 - No shared data, so no mutex needed.
 - This is optimal for parallel speedup, but not always possible.


