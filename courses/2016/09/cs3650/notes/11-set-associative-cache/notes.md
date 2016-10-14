---
layout: default
---

# CS3650: Concrete Cache Examples - With Set Associativity

## First Thing
 
 - Homework Questions

## Numbers

The metric prefixes "k", "M", and "G" usually mean 10^3, 10^6, and 10^9.

Specifically when talking about memory addresses stored as bits, they
almost always take on the alternate "binary" meanings:

 - k means 2^10 = 1024
 - M means 2^20 = 1024k
 - G means 2^30 = 1024M

This is why a 16GB RAM module has a different number of bytes than a 16GB hard
disk.

## How does cache work?

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

"Ways" = How many places can a given cache line be stored? These
places will all have the same index.

"Sets" = How many distinct indexes are there to determine
where to put a cache line?

Direct-mapped = 1 way

Fully-associative = 1 set 


## Let's switch it up

### Example 1

 - 16 bit addresses
   - 64k address space
 - 128 byte cache lines
 - 1k cache size
 - 4-way set associative

What other stuff can we calculate?

 - Number of slots in cache for cache lines? 1k/128 = 8 
 - Number of sets? 8/4 = 2
 - Number of cache lines in address space? 64k/128 = 512
 - Number of possible lines in address space that
   could be cached in each set? 512 / 2 = 256

How we split up the address for the cache:

 - lowest 7 bits ignored (in the cache line)
 - index: 1 bit (selects set)
 - tag: 8 bits (the rest of the bits)

### Example 2: The Core i7

Core i7 5775C

Cache Basics:
 - 64-bit addresses, but...
 - only uses lower 48 bits
 - 64-byte cache line

L1 Data Cache: 
 - 32KB size
 - 8-way set associative
 - write back

Stuff we can calculate:

 - Number of slots for cache lines in cache? 32k / 64 = 512
 - Number of sets? 512 / 8 = 64
 - Number of cache lines in address space? 2^48 / 2^6 = 2^42
 - Number of address space lines per set? 2^42 / 2^6 = 2^36

How we split up the address for the cache:
 
 - Lowest 6 bits: Ignored, in cache line.
 - index: 6 bits
 - tag: 36 bits
 - Upper 16 bits: Ignored, not used in current hardware.


### Web Simulator

http://www.ecs.umass.edu/ece/koren/architecture/Cache/default.htm

 - Memory size sets total bits.
 - Block size sets ignored "byte select bits".
 - The rest are index.
 - Increasing "set size" (ways) moves index bits to tag bits:
   - There are less sets to distinguish.
   - There are more possible lines that can be stored in each slot.

http://www.ecs.umass.edu/ece/koren/architecture/Cache/page3.htm

 - Give me an address that will map to slot 4 for...
 - 128B, 2B, Direct
 - 128B, 4B, 2-way

## Write back?

How do we handle writes?

We have two standard choices:
 - Write-through: Write to memory; mark cache line invalid.
 - Write-back: Write to cache
   - What do we do when we evict a cache line?
   - Either always write it to memory, or add a "dirty" bit.

## Replacement Policy

In a direct mapped cache, when we put something new into a cache
line we kick out whatever was there before.

For a set-associative cache, it's more complicated. For a 4-way
cache, when we need to kick a line out, we have to chose one of
4 lines already in cache to evict.

Here are some possible schemes:
 - First In First Out  - Kick out the one that was loaded least recently.
 - Least Recently Used - Kick out the one that was accessed least recently.
 - Random - Select a line to kick out at random.

The whole idea of having a cache is based on the idea that recently used stuff
is most likely to get used again, so we expect LRU to be best.

## Cache Performance Testing

The Opteron:

 - L1d cache:             16K
 - L1i cache:             64K
 - L2 cache:              2048K
 - L3 cache:              6144K

