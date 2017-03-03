---
layout: default
---

# CS3650: POSIX Threads

## First Thing

 - Homework Questions?

## Concurrent + Shared Mutable Data = Wrong

 - Wrong answer w/o mutex.
 - Fix: mutex invariant
 - Fix: barrier invariant

## TODO

 - Fill in more here.

## A fixed-size stack

 - An array to hold data.
 - Push and pop functions.

## A parallel stack

 - One thread adds numbers to a stack.
 - Another thread removes and prints them.

Complications:

 - Data race for stack and index variable. (Mutex!)
 - What do we do when stack gets full / empty? (Block!)
 - How do we know when there's space / items to unblock? (Cond Var)

## A parallel queue

 - Ring buffer.
 - Insert pointer, extract pointer.

Tricky bits:

 - Want to modify pointers atomically. (atomic\_add)
 - Don't want to run off the end of the queue. (take index modulo size)
 - Don't want to run off the end of the integer type.
   - Unsigned int - wrapping is well defined, wraps back to 0.
   - Integer range must be evenly divisible by queue size.
 - Don't want to extract when no items available.
   - Can use semaphore. Will block when empty.
 - Don't want to insert when queue is full.
   - Can use semaphore. Will block when full. 

Our program is parallel, so it's probably wrong. We need to demonstrate
that there are no data races and no deadlocks.

This is tricky. The analysis gets complicated. Until we actually do it,
we can assume our program is broken.

