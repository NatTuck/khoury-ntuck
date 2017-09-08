---
layout: default
---

# CS3650: Allocator with Threads

## First Thing

 - Homework Questions?

## Collatz Sample

 - odd:  3*n+1
 - even: n/2
 
Question: Where do we end up given various starting
   values for n?
 
Examples:

 - 8 -> 4 -> 2 -> 1 -> 4 -> 2 -> 1 -> 4 ...

If we get to 1, we're going to loop 4->2->1 forever.

Conjecture: Every positive integer starting value ends up at 1.
 
 - 12, 6, 3, 10, 5, 16, 8, 4, 2, 1
 
## HW11 program

The HW11 program assumes the conjecture is true and counts how many steps it
takes to get to 1 from each starting value 1 up to some user input max value.

It does this by making a list / vector of the entire path from the starting
value down to one, and then taking the length of the path.

Four threads do the work, and threads take a break after a certain number of
iterations on a single starting value. When another thread comes back to finish
the path, it'll start by allocating a copy of the current path and freeing the
old one.

This gives us a lot of allocations in different threads, and means that memory
allocated in one thread is likely to be freed in a different thread.

## The HW06 allocator

 - One global free list.
 - Two functions manipulate this list:
   - malloc
   - free
 - This is mostly an optimization compared to
   calling mmap / munmap directly:
   - Allows allocations smaller than 4k.
   - Reduces the number of system calls.
   - Removes the requirement to pass size to free.

## Adding Threads

 - The free list becomes shared data.
   - Data race!
 - We can add a mutex to protect the free list.
   - Make sure we hold this whenever we read or write to
     the free list.
   - Data race solved.

## Improving Performance

Simple solution has two problems:

 - Mutex contention.
 - Cache line contention.

Both are caused by having multiple threads share
the same free list with frequent allocation.

Idea: Add more free lists.

Idea: One per thread.

gcc provides thread-local variables. Declare them like a global with the
__thread prefix, and each thread gets its own version of the variable. This
*almost* solve the problem.

What if we alloc in one thread and free in another? Fine, except we can't
coalesce and eventually die to fragmentation.

Idea: Give each free list an ID, and tag each allocation with its source
free list ID. All free lists are accessible by all threads, but free lists
tend to be used by the same thread for allocation.

## Real-World Implementations
   
Everyone does fixed allocation sizes. Like buddy system, but more granular 
(e.g. has 24B allocations).

jemalloc example: http://jemalloc.net/jemalloc.3.html

(scroll down for table)

 * ptmalloc (gnu libc)
   * One arena per thread up to max = #cores.
   * Fixed allocation sizes.
 * jemalloc (facebook)
   * There are several arenas. Threads tend to use the same
     one, but sometimes switch.
 * tcmalloc (google) 
   * Every thread has a local cache. 
   * Frees go to local cache.
   * Allocations prefer local cache, but may go to global free list.
   * Occasionally local caches are "garbage collected" back out to the
     global free list.

## Last Thing

 - Start the file system slides.
 
## Links

jemalloc: http://jemalloc.net/jemalloc.3.html
old ptmalloc: http://gee.cs.oswego.edu/dl/html/malloc.html
current ptmalloc: https://sploitfun.wordpress.com/2015/02/10/understanding-glibc-malloc/


