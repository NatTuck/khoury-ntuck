---
layout: default
---

# Computer Systems

## First Thing

 - Questions on the Homework?

## Challenge 02

The assignment:

 * Write an optimized, thread-safe allocator.
 * With a partner.
 * Like HW07, but with new test cases and a report.
 
Two core optimizations:

 * Binning allocations by size to allow O(1) allocation / free.
 * Something like multiple arenas and/or thread caches to
   reduce contention.

## Useful Concept: Thread Local Storage

 * Thread local storage allows us to have per-thread globals.
 * Show two examples.

## Malloc in the Real Worlds

### ptmalloc2 (GNU libc)

The GNU libc csouce code says:

> This is a version (aka ptmalloc2) of malloc/free/realloc written by
> Doug Lea and adapted to multiple threads/arenas by Wolfram Gloger.
>
> There have been substantial changesmade after the integration into
> glibc in all parts of the code.  Do not look for much commonality
> with the ptmalloc2 version.
>
> This is not the fastest, most space-conserving, most portable, or
> most tunable malloc ever written. However it is among the fastest
> while also being among the most space-conserving, portable and tunable.
> Consistent balance across these factors results in a good general-purpose
> allocator for malloc-intensive programs.
>
>  The main properties of the algorithms are:
>
>  * For large (>= 512 bytes) requests, it is a pure best-fit allocator,
>     with ties normally decided via FIFO (i.e. least recently used).
>  * For small (<= 64 bytes by default) requests, it is a caching
>    allocator, that maintains pools of quickly recycled chunks.
>  * In between, and for combinations of large and small requests, it does
>    the best it can trying to meet both goals at once.
>  * For very large requests (>= 128KB by default), it relies on system
>    memory mapping facilities, if supported.

* Multiple threads are handled by multiple arenas.
* A bunch of different technqiues get used for different size allocations
* There are doubly linked lists, singly linked lists, queues,
  bins of non-constant size chunks, and stacks.

### tcmalloc (Google)

http://goog-perftools.sourceforge.net/doc/tcmalloc.html

https://github.com/gperftools/gperftools

> TCMalloc assigns each thread a thread-local cache. Small allocations are
> satisfied from the thread-local cache. Objects are moved from central data
> structures into a thread-local cache as needed, and periodic garbage
> collections are used to migrate memory back from a thread-local cache into the
> central data structures.
>
> Each small object size maps to one of approximately 170 allocatable
> size-classes. For example, all allocations in the range 961 to 1024 bytes are
> rounded up to 1024. The size-classes are spaced so that small sizes are
> separated by 8 bytes, larger sizes by 16 bytes, even larger sizes by 32 bytes,
> and so forth. The maximal spacing (for sizes >= ~2K) is 256 bytes.
>
> A large object size (> 32K) is rounded up to a page size (4K) and is handled
> by a central page heap. The central page heap is again an array of free lists.

Extensive use of size-specific bins:

  * Threads each have bins for sizes up to 32k
  * There's one global set of bins for 1..255 pages.
  * Per-thread bins are garbage collected back to the global page bins.
  * Memory is never unmapped.

## jemalloc (Facebook / FreeBSD)

http://jemalloc.net/

https://www.youtube.com/watch?v=RcWp5vwGlYU

Key idea is fragmentation avoidance. Want to be able to use all the RAM
in the machine even for long-running processes.

All in with size specific bins:

 * Small is up to 4K
 * Medium is up to 4M
 * Large is 16KB - 7 EB

Multiple partially-shared arenas:

 * Arenas are allocated to threads using next-fit.
 * Memory is always freed to the source arena.
 * Red-Black tree per size class.
 * Dirty and clean pages are kept seperate
   * Clean pages take up zero space
   * Free dirty pages must be purged

No async GC implemented as of Summer 2015.

Each thread has a local cache per size up to 32K. This cache is used
to avoid hitting an arena at all.

Really neat stuff:

 * Allows explicit mmaping of files on disk as source locations for
   arenas.
 * This allows malloc-to-SSD, or malloc-to-NVRAM, taking full advantage
   of the kernel page cache and allowing datasets in the several TB
   range on "cheap" servers.
 * Allocates in 4MB chunks aligned to 4MB.

Neat goal:

 * One Arena per CPU core.
 * This is actually what you want for both performance and contention.

