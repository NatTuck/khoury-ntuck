---
layout: default
---

# Computer Systems

## Homework

 - HW08 Questions?
 
## HW08 starter code

Collatz Conjecture

 - Consider this procedure: "Start with any positive integer x and repeat the
   following procedure until you find a loop: If x is even, divide by two. If x is
   odd, take 3*x+1".
 - The conjecture is that for all starting values this will terminate in a loop
   including the number 1. This is true for, e.g., all non-negative integers
   representable with 32 bits.
 - This leaves the question: How many steps does it take for a given input to
   reach 1? 
 - This is the question that the test programs answer, inefficiently, by
   building a list or array of the sequence and then taking its length.


XV6 Allocator

 - This is a simple free-list based allocator.
 - There's one structure: Header, used both for allocated blocks and the linked
   list structure for blocks on the free list.
 - It's a union to force some alignment property that I'm not sure actually
   matters on x86 or amd64.

free:

 - Takes a void ptr
 - Header is 1 header size before the pointer
 - Insert item into list in order by address and merge
 - No mechanism to return memory to OS

morecore:

 - Request more RAM from OS
 - Works in units of sizeof(Header) = 16
 - Minimum allocation is 16 pages, but can request an uneven number of pages,
   which could matter with actual sbrk
 - This logic will work great with mmap. Not optimal, but still entirely
   reasonable
 - It just sticks stuff on the list with free

xmalloc

 - We're working in units of sizeof(Header) = 16
 - One header is a minimum (0-byte) allocation, and we track
   free blocks in sizeof(Header) units
 - Looks like a circular list. The static Header "base" is just used
   to avoid the empty list edge case

the assignment

 - Replace sbrk with mmap(PRIVATE | ANONYMOUS)
 - Add a mutex to protect the shared global data

## Optimizing an Allocator

For the major portion of this assignment you need to build an optimized,
multi-threaded allocator.

Step 1: Make something that works and that you can easily enhance.

 - This could be a simple cleanup of the xv6 allocator to be a bit more
   readable.
 - Maybe you want to start with a slightly more complex design, like
   distinguishing between headers and free list cells.

Step 2: Optimize

 - There are probably two basic issues for optimization:
   - Allocator design (e.g. free list, buddy, buckets, etc)
   - Avoiding lock contention (e.g. multiple arenas, per-thread caches, etc)
 - You will need to consider both of those issues to pass all of the tests.
 - I recommend doing the simplest thing first.
 - You're optimizing for specific test programs, so it's worth looking at what
   allocation patterns those programs produce.

Imagine you do some investigation and find out that 90% of the allocations are
of exactly 200 and 300 bytes. I'd suggest starting with the following design:

 - An arena is primarily a simple free list.
 - There are statically 10 arenas. Threads allocate from a random arena, and
   free back to the arena that a block was allocated from.
 - Allocations of size between 200 and 300 inclusive are handled by a bucket
   allocator that always allocates size 300 blocks. This is 10 more arenas
   with their own arena numbers.
 - Fixed size blocks are allocated from a free-list arena in groups of 12, and
   are coalesced and returned to the free list if all 12 in the block are free.
   This can be checked in constant time with pointer arithmetic given a used
   flag.
 - That means that a header is {size, arena #, used}

This design isn't optimal, but it addresses both performance problems and
provides a good example of how some complexity can be added to improve performance
without going crazy with it.

## Start GC slides

[Slides, start @ GC](http://ccs.neu.edu/home/ntuck/courses/2015/01/cs5600/slides/8_Free_Space_and_GC.pptx)
   


