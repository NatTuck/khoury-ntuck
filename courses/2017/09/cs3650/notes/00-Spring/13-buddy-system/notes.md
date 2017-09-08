---
layout: default
---

# Computer Systems

## First Thing

 - Questions on the Homework?

## Solution Review - Memory Allocation HW

Code won't be posted.

Review the test cases:

 - list sum ints: constant size allocation
 - array sum ints: variable size allocation
 - random sizes: random size allocation

Basic plan:

 - Linked list of free memory blocks
 - head: global pointer
 - blocks *are* the list elements
 - Blocks must fit node struct - smaller allocs rounded up
 - Allocations include size - actual block is req + sizeof(int64)

Allocation:

 - Calculate real allocation size (min, add size field)
 - Is it > 64k? Allocate it with mmap.
 - Is there a big enough block on the free list?
   - If so, take it.
   - Is the rest big enough to allocate? If so, put it back on the list.
 - No big enough block?
   - Allocate a new 64k chunk. Put it on the free list.
   - [[ increase malloc-chunks ]]
   - Allocate from that block.
   - Is the rest big enough to allocate? If so, put it back on the list.
 - Stick the size at the beginning of the allocation.
 - [[ increase malloc-count, malloc-bytes ]]
 - Return a pointer to *after* the size.

Deallocation:

 - Read allocation size (right *before* the pointer).
 - Is it > 64k? Return it with munmap.
   - [[ increase free-chunks ]]
 - Cast to a node pointer. Stick on free list.
 - [[ increase free-count, free-bytes ]]
 - Check to see if you can coalece.

Coallecing:

 - If there are two adjacent nodes on the free list, join them together
   into one bigger one.
 - This is easier if nodes are in sorted order.
 - This is easier if you use a doubly linked list (next &amp; prev ptrs).

Returning chunks:

 - If you end up with a 64k chunk, you *could* return it with munmap.
 - Should you?
   - Pro: The OS gets the memory back to allocate to other programs.
   - Con: System calls are moderately expensive, and you're likely to
          want that memory later.
 - Compromise: Wait for many (> 10 maybe) full chunks free, and return
     half of them.

## Buddy System

The standard freelist solution works pretty well, but it has some performance
issues. Both malloc and free are O(n) in the size of the freelist.

We can get that down to a much lower cost:

 - malloc: O(1)
 - free: O(1)

We saw the basics in the slides, but I'm going to go through it in a bit
more detail. This scheme is generally called the "buddy system".

Instead of tracking allocations of any size, we instead only allow allocations
of even power of two sizes (less two bytes).

Instead of one free list, we have a global *array* of free lists, each holding
free blocks of a specific size. This array is some constant size (maybe 30 long).

Specifically, free\_list[i] holds blocks of size 2^i. We call these blocks
"rank i" blocks.

To allocate:

 - Calculate which rank the allocation is, with ceil(log2(size)).
 - If there's a block on the list, use it.
 - Otherwise, split a block of rank (i+1), recursively.
 - There's some max rank where we just mmap a new block rather than splitting,
   and we use mmap directly for blocks bigger than that.
 - Set up the metadata (at the start of the block).
 - Return a pointer to after the metadata.

The metadata is:

 - 8 bits: The rank of this allocation.
 - 8 bits: Flags, including an "allocated" flag.

To free:

 - Check if this block's buddy is allocated.
   - The buddy is the other half of of the chunk at rank (i+1).
   - The buddy's address can be calculated by doing arithmetic on
     this chunk's address.
 - If the buddy is allocated, then stick this back on the appropriate
   free list.
 - If the buddy is not allocated, join them together and check for *that*
   chunk's buddy, recursively. Stick the resulting block on the correct
   free list.

In order to make this deallocation work in constant time, the free lists
*must* be doubly linked lists with this sort of structure:

 - 8 bits: Rank
 - 8 bits: Flags
 - 64 bits: prev ptr
 - 64 bits: next ptr

This allows us to remove a block from a free list using a calculated
block pointer without traversing the free list at all.

 - Example:
 - Start with a block of 16 free (0,0000 .. 1,0000)
 - Allocate a = 1, rank 0
 - Allocate b = 8, rank 3
 - Allocate c = 4, rank 2
 - Free c
 - Free a

Note that we can find a buddy by toggling the "rank" bit.
( addr ^ (1 << rank) ), ^ is xor, << is left shift

Downside 1:

 - Awful at power-of-two allocations. The metadata forces the allocation
   up to the next power of two.
 - This can be solved with external metadata, but that's kind of tricky
   too.

External metadata in n * log(n) bits of space:

 - Allocate a free\_list[M] array for free lists.
 - Allocate a free\_bits[M] array for metadata.
 - Each slot in the free\_bits array is a bit-array of "allocated" flags.
 - When freeing a block:
   - Scan for the smallest allocated block this could be based on its address.
   - The array index is the rank.

Downside 2:

 - Internal fragmentation. You waste the space from rounding up to the next
   power of two. With random allocation sizes, this'll end up being about
   25% of your memory.





