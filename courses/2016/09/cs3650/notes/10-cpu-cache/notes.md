---
layout: default
---

# First Thing
 
 - Homework Questions

# Fork / Wait

 - Show manyecho.c
 - Fix it to wait for echos.

# Core i7 5775C

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

## addzs.c

 - This processor runs at 2GHz, otherwise loosely similar to the i7.
 - Adding 300 million ints should take about 1/3 of a second.
 - Nope, took 5 seconds.

 - On the Core i7, adding a billion takes 10 seconds.
 - I'm going to talk about that, since I have stats for the i7.
 - Why did it do that?

 - How big is the data:
 - sizeof(int) = 4 bytes
 - 2 arrays of a billion ints = 8 GB

## What happens when data isn't in a register.

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

# How does cache work?

 - Cache is a table.
 - We split the address into pieces to figure out
   where to put cache lines (blocks).

 - Consider cache with 64-byte lines and of size
   64k (so it holds 1k lines).
 - Assume a 32-bit memory address.

Direct mapped cache:

 - The place to put the line in the cache is based
   on it's address. Each line in memory can only live
   in one spot in the cache.
 - A line is 64B, so we ignore the lowest 6 bits of the
   address.
 - We have 1k slots, so we need 10 bits to identify slot
   this is the index into the cache.
 - That leaves us 16 upper bits. We need to keep these in
   the table as a "tag" to identify which actual line from
   memory is stored in cache.
 - What about empty cache slots? We need a "valid" bit.

 - So our cache rows look like this:
   - index (16 bits, implicit)
   - valid? (1 bit)
   - tag (16 bit)
   - data (64 bytes)
 - Our index into the cache is 10 bits. If we number from
   0 = least signficant bit, these are bits 6 - 15 of the
   address.

N-Way Set Associative Caches:

 - Direct-mapped caches are simple to build, but they suffer
   from collisons.
 - If two lines map to the same index, and you want to use both,
   they'll keep bumping each other out of cache.

 - A set-associative cache solves this by providing more than
   one slot where each cache line from memory can go.
 - All the slots where a given line can go are called a set.
 - A cache that allows a given line to go in N slots is called
   a N-Way cache.
 - We handle this by having each index refer to multiple rows.

So if we want to make our 16k cache 2-Way set associative, we'll
organize our 1k slots into 512 sets.

Our address is now:
 - 6 bits ignored for our 64b cache line.
 - 9 bits of index to select set.
 - 17 bits of tag to determine which cache lines we have.

"Way" = How many places can a cache line be stored?
Direct-mapped = 1 way

# Write back?

How do we handle writes?

We have two standard choices:
 - Write-through: Write to memory; mark cache line invalid.
 - Write-back: Write to cache
   - What do we do when we evict a cache line?
   - Either always write it to memory, or add a "dirty" bit.

