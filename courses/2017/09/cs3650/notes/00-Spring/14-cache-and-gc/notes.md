---
layout: default
---

# Computer Systems

## First Thing

 - Questions on the Homework?

## Evaluating Performance

 - Which memory allocator is faster?
 - Which sort algorithm is faster?
 - Which matrix multiplication algorithm is faster?

What does "faster" mean?

 - Throughput? 

How many X's can we do per second.

 - Latency?

How many microseconds does it take to do one X?

Average case? Same as throughput.

Worst case? This may be more important for real-time applications 
(e.g. anti-lock break system, video games)

95th percentile? This is sometimes fine for things like web apps.

### Big-O

Asymptotic complexity is a good first consideration. For any N that isn't tiny, a
O(2^n) algorithm is going to be *much* slower tahn a O(n^2) algorithm.

But once we're talking about "reasonable" computational complexities - e.g. at most
O(n^3) - that constant that the big-O notation is hiding starts to matter.

In some cases, a O(n^2) algorithm can be *faster* than a O(n) algorithm for n
as high as 10,000. The most likely cause for this is hardware properties.

### How Fast is the Hardware

#### Core i7 5775C

 - 4 Cores / 8 Threads
   - 8 Threads?
 - Core base frequency: 3.3 GHz
   - 3 billion clock cycles per second
   - 3 clock cycles per nanosecond
 - 3 basic ALUs
   - add, sub, bitwise, etc
 - 1 multiplier, 1 divider
 - So for in-register arithmetic operations, this CPU could 
   potentially do 10 billion ops / second.
 - for (;;) { a += 5; } // 3 billion per second
 - for (;;) { a += 5; b += 5; c += 5; } // 10 billion per second

#### addzs.c

 - This processor runs at 2GHz, otherwise loosely similar to the i7.
 - Adding 300 million ints should take about 1/3 of a second.
 - Nope, took 5 seconds.

 - On the Core i7, adding a billion takes 10 seconds.
 - I'm going to talk about that, since I have stats for the i7.
 - Why did it do that?

 - How big is the data:
 - sizeof(int) = 4 bytes
 - 2 arrays of a billion ints = 8 GB

#### What happens when data isn't in a register.

 - Fetch from L1 cache.
 - Not in L1 cache? Fetch from L2 to L1.
 - Not in L2? Fetch from L3 to L2.
 - Not in any cache? Fetch from memory to L3.

 - Show caches / latencies from below.

 - Fetches are in "Cache Lines". On amd64, usually 64 bytes. 
 - 8GB = 125M cache lines

 - Run addzs

 - Does that help?
 - Each miss to main memory costs 63ns - there are 125M of them.
 - That's about 8 seconds in memory fetches.
 - That's about right.

 - We got a factor of ~200 slowdown due memory access. If we had
   missed cache less, it would have been better.

 - That's the worst case for cache. Usually, computer programs
   exhibit spacial and temporal locality: If you accessed something
   recently, you're likely to access it again soon.

 - But that's with compiler optimizations disabled. What if we
   turn them back on?

 - Run addop 

 - Now it's 1.6 seconds.
 - That's 0.7 seconds on the i7.
 - But how?

 - Answer: The CPU is clever, if we let it be. It can *prefetch*
   data. We have a nice consistent linear access pattern, so if
   it requests *two* cache lines at a time then they'll both be
   useful.
 - Each level of the RAM hierarchy also has a throughput.
 - The RAM could do it in 0.5 seconds. Probably the extra 0.2 is
   writing the result of the adds back out to RAM.
 - That's still a 5x slowdown. But the prefetcher is amazing when
   it kicks in.
 - This example is the *best case* for the prefetcher. Random access
   would kill the prefetcher dead.

## Core i7 5775C Cache

Registers:
 - 1 clock = 0.3 ns
 - ~14 64-bit (8-byte) general purpose registers always accessible
 - That's 112 bytes of stuff available immediately

Cache:
 - 64B Cache Lines

 - 32KB L1 Instruction Cache per core
   - 8-way set associative, write back

 - 32KB L1 Data Cache per core
   - 8 way associative, write back
   - 1.1 ns = 4 cycle latency 
   - 900 GB/s read throughput, half for write

 - 256KB L2 Cache per core
   - 8 way set associative, write back
   - 3.3 ns = 11 cycle latency
   - 350 GB/s throughput, half for write

 - 6MB L3 Cache, shared between cores
   - 16 way set associative, write back
   - ~13 ns = ~40 cycle latency
   - 180 GB/s throughput, same for write

 - 128MB L4 eDRAM Cache, shared between cores and iGPU
   - fully associative, L3 victims
   - 42 ns = ~140 cycle latency
   - 50 GB/s thoroughput, same for write

Main Memory:
 - Something like 16 GB
 - 63 ns = ~210 cycle latency
 - 30 GB/s throughput, same for write

SSD:
 - Think in terms of 4KB blocks.
 - 100 us = ~300k cycle latency
 - 700 MB/s throughput

### So which allocator is better?

Free List:

 - Requires O(n) traversals of a linked list.
 - Every time we follow a pointer, it could be a cache miss.
 - Linked list = random access, no help from prefetcher.
 - Linked list nodes can span multiple 64k blocks.
 - Nodes each fit in a 64-byte cache line, but you'll
   rarely get two nodes in a line.
 - With a lot of pressure on the allocator, we're likely to
   have much of the free list in L1 cache.
 - No wasted space to fill up cache.
 - First-fit + unsorted list with deferred coalescing might
   improve cache behavior.

Buddy System:

 - Requires 0(1) array traversal, maybe 20.
 - Multiple array entries fit in cache line.
 - Prefetcher can help with array.
 - Wasted space between power of two blocks.
   Does this waste cache space?
 - Still have to follow arbitrary pointers to get to blocks,
   potential cache misses.

Considering cache leaves buddy system better than free list, but can
we do better?

Fixed size allocator:

 - Free list for each size allocation
 - Alloc is one operation: take first item on list.
 - Free is one operation: stick item on head of list.
 - Great if there's only a few sizes.
 - Size lookup / cache pressure gets to be an issue for many different sizes.

Bump Pointer Allocator:

 - Have a pointer to next free space.
 - Allocation is basically one operation, not O(1), actually one:
   - mem = ptr
   - ptr += alloc\_size
   - return mem
 - Linear access to memory, perfect for prefetcher.
 - How do we free memory?
 - Garbage collector!

### Garbage Collector Slides




