---
layout: default
---

# Computer Systems

## Homework

 - HW07 Questions?
 
## Free List: Quick Review

 - In a simple free-list based memory allocator, "malloc" finds blocks of memory
   to allocate by looking on a global linked list of free chunks.
 - If the found chunk is too big, we split it and put the rest back on the
   free list.
 - If no chunk is big enough, we mmap up a new block of memory.
 - To free a block, we add the block to the free list and then coalesce adjacent
   free chunks to avoid fragmentation.
 - Maybe we special-case large allocations to skip the freelist entirely.

Simple version:

 - malloc is O(n)
 - free is O(n)
 - minimum allocation size is 16 (size, next ptr)

Doubly linked list:

 - malloc is O(n)
 - free is O(1)
 - minimum allocation size is 32 (size, next, prev, footer)

### Use a Tree?

Linked lists are slow - they tend to O(n) time for operations. We can do better
with a different data structure.

Plan A: TreeMap ordered by address

 - malloc is O(n)
 - free is O(log n)
 - minimum allocation size is 24 (size, left, right)

Plan B: TreeMap ordered by size

 - malloc is O(log n)
 - free is O(n)
 - minimum allocation size is 24 (size, left, right)

Plan C: Double TreeMap ordered by both

 - malloc is O(log n)
 - free is O(log n)
 - minimum allocation size is 40 (size, szl, szr, adl, adr)

### Buddy System

 - Start with an aligned chunk of memory.
   - e.g. 1MB of memory, aligned at 1MB
 - Have an array of doubly linked free lists, one for each power of two
   less than the chunk size.
 - Minimum allocation size is 32: size + left + right + used = 25, round up to 32.
 - So that's 15 buckets for 2^5..2^20 sizes, and we start with one entry in the
   2^20 bucket. Probably we just allocate an array of 20 for easy indexing and
   ignore buckets #1..4
 - To allocate a smaller bucket, we split a block from a bigger bucket,
   recursively. So if we just have our 1MB block and need to allocate 64k we'll
   split 4 times (1M -> 512k -> 128k -> 64k).
 - When we split a block, the two smaller blocks split from the bigger one are
   called buddies.
 - Allocation takes log(1M) time. If the chunk size is variable then that's
   O(log(n)), if it's a constant then it's O(20) = O(1).
 - Freeing takes the same time, with the following process:
   - First, we find our buddy. We can do this by arithmetic on the address.
     Since we're a power of 2 size, our address will differ from our buddy's by
     one bit: if we're 2^k big, the kth bit will differ.
   - Buddy Addr = (Our Addr) XOR (1 << k), if our size is 2^k
   - If buddy isn't free, this entry is inserted into the appropriate free list.
   - If buddy is free, we remove it from the list (in constant time - doubly
     linked list), merge the buddies, and recursively check if we can merge with
     our next buddy up.

Further optimizations:

 - We can drop minimum size to 8 bytes:
   - 1 byte for size (2^k)
   - 1 byte for used flag (boolean)
   - 3 bytes for next ptr (offset)
   - 3 bytes for prev ptr (offset)
 - Max size of an arena becomes 2^24 = 16 MB.
 - Probably should switch to direct mmap allocations at around 8mb.
 - Alignment is tricky: you probably don't want a header under 8 bytes.

### Advanced Buckets

The array-of-freelists that the buddy system uses is great for allocations. It
can return a result in constant time.

In a "bucket" allocator, we shoot for that O(1) allocation performance by
completely separating our free lists. When an allocation request of a given size
comes in we allocate a new block of memory specifically to put on that
size-specific free list (or "bucket").

If we allowed any arbitrary size allocation, then this could result in up to
4096 free lists just for sizes up to one page. That's feasible, but it wouldn't
have great performance. Instead, a bucket allocator only handles a set list of
sizes - commonly powers of two and the half points between powers of two. So for
sizes up to a page, the list might be:

```
4, 8, 12, 16, 24, 32, 48, 64, 96, 128, 192, 256, 
384, 512, 768, 1024, 1536, 2048, 3192, 4096
```

That's 20 sizes, so allocating a page for each size might cost 80k.

Problem: Where can we put the size field to avoid having power-of-two allocations
overflow to the next bucket up?

Solution: At the beginning of the page. All the allocations are the same size,
and we can find the beginning of the page with pointer arithmetic, so no need
for multiple size fields. This means that our free list becomes a list of blocks
(pages) with at least one free slot.

Problem: How do we coalesce?

Solution: Since a 64-byte block is always a 64-byte block, we only need to worry
about the case where an entire page is free so we can unmap it. We can store
"free" bits as a bitmap at the beginning of the page. Even for 4 byte allocations
the bitmap only needs to be 128 bytes = 16 words = 2 cache lines long.

Problem: How do we handle sizes allocations >= 1 page? Rounding down the pointer
no longer gets you to the beginning of the block if there are multiple
allocations per block?

Solution: Each allocation needs its own block. Then it's fine. Maybe it's more
efficient to use a block size > 1 page.

Bucket allocator advantages:

 - O(1) malloc and free
 - Great locality of reference for fast allocation of fixed-size objects.

Bucket allocator disadvantages:

 - Stuck with some of both internal and external fragmentation.
 - Startup allocation is pretty big (each initial allocation from a bucket
   allocates at least a page)
 - No locality of reference between different sized objects.

## Problem 2: Multiple Threads

Any allocator that's based on a shared global data structure (a freelist or
array of freelists) will cause trouble with multiple threads. That global
structure is shared data, and if we protect it with a lock then we can't malloc
or free in multiple threads in parallel.

### Plan A: A Per-Thread Cache

This story makes the most sense if we start from a single global traditional
freelist.

 - each thread gets its own "cache" freelist.
 - malloc tries the local cache first, and goes to the global free list only
   when that fails
 - frees go to the local freelist
 - Occasionally, when the local free list gets too big, either the whole thing
   or a big chunk of it gets moved to the global free list and coalescing
   happens.

Advantages:

 - Lock contention on the global freelist is significantly reduced.
 - Threads get good locality of reference since they reuse the same memory blocks
   several times.

Disadvantages:

 - The global freelist lock is still a single bottleneck.
 - Fragementation is increased since we can't coalesce across threads.
 - This doesn't extend well to buddy system, since buddies may be stuck in
   different caches.
 - This doesn't extend well to buckets - we'd need to worry about data races on
   chunk metadata.

### Plan B: Multiple Arenas

The word "arena" in memory allocators is used to refer to the data structure
associated with a complete self-sufficient allocator: the free list or array of
free lists.

By having several arenas, we can allow each arena to have its own mutex. With
enough arenas (e.g. 1 per thread), this can avoid lock contention entirely
except on objects that are allocated in one thread and freed in another.

This mechanism works pretty well with buckets. The block metadata mechanism
allows freeing to work independent of which arena the block is associated with,
as long as the block metadata includes a mutex.

## Real-World Allocators

ptmalloc: The GNU libc allocator

 - Loosely based on the traditional free-list design
 - Uses per-thread arenas
 - Tons of special case optimizations
 - Design goal seems to be to prevent the worst case from being too bad.
 
tmalloc: Google's Thread Caching Malloc

 - A bucket allocator
 - Each thread has a cache with an array of the smaller buckets
 - A garbage collector runs periodically to move items from thread caches
   back to the global buckets.

jemalloc: Facebook's Multi-Arena Allocator

 - A bucket allocator with multiple arenas
 - Arenas = 4 * CPU cores
 - Uses 2MB (rather than 4k) chunks
 - Most of the optimization is in chunk management
 - Widely considered to be the fastest current general purpose allocator, but
   the win over ptmalloc isn't huge.

## madvise

One the key tricks that makes jemalloc good is the madvise syscall with the
MADV_DONTNEED flag. This tells the kernel that for one or more pages of memory
the program wants to keep the virtual pages but doesn't need the data anymore.
Future access to these pages may allocate new physical pages of zeros.

Another neat tool is MADV_HUGEPAGE. This requests that the kernel use 2MB pages
rather than 4k pages. This means each TLB entry handles 2MB rather than 4k,
which can speed things up significantly.

There is also support for 1GB pages, but those are too big for most use cases
currently. Maybe for machines with TB of RAM...

Unfortunatly, MADV_DONTNEED doesn't work with huge pages.



