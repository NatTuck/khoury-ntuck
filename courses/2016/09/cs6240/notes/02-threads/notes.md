---
layout: default
---

# Threads

## Homework is Up

Two parts:

 - Write a threaded program.
   - More on threads today.
 - Run WordCount on AWS
   - Where to get WordCount? It's in the Hadoop jar.

## MillionSum Example

 - We covered three cases:
   - Sequential
   - Parallel but Wrong (race condition)
   - Parallel but Slow  (one lock causing sequential execution)

 - Another case to consider:
   - Seperate partial sums (faster, but depends on properties of problem)

## More on Parallel Programming

 - Locks, Barriers, and Monitors
   - synch method - current object
   - sync static method - current class
   - synchronized (obj) block - that object
   - .wait method - must hold lock, release lock and block
   - .notify method - must hold lock, wake up waiter after lock is released
   - barrier - everyone must reach barrier before anyone proceeds beyond it
     - can build with lock, wait, notifyAll, and a counter
     - or, implicitly with something like .join

 - Three basic problems
   - Data races
   - Deadlock
   - Unexpected sequential execution

 - Message passing
   - Deadlock requires a cycle of messages.
   - Sequentialization requires a series of messages.
   - Data races require simulation of shared data.

 - A parallel program is wrong by default. You need justification to claim
   that it might be correct.

 - Conditions for deadlock:
   - A dependency cycle in locks, message passing pattern, or similar. No
     cycles, no deadlock.
   - To deadlock, you must block on a resource. No blocking, no deadlock.

 - Conditions for a race condition:
   - Modification of shared data.
     - Immutable data = no data race.
     - No sharing = no data race.




