---
layout: default
---

# Computer Systems

## Next HW:

 - Next homework is up: Your choice, bubble sort or stooge sort.

## HW Questions?

## Memory Segments in a Process

 - Stack
 - Code
 - Global / Static Data
 - Heap

## Static data

 .data
 .space X (reserve X bytes)
 .align X (start the next thing on a 2^X boundry).

We use labels to reference things.

## Alloca and the Stack

 - We can allocate variable sized data on the stack.
 - This should be done carefully
   - Dedicate an $sX register to store the size.
   - Dedicate an $sX register to store the pointer.
   - Allocate stack chunk at end of function setup
   - Deallocate stack chunk at beginning of function cleanup
 - In C, this is a non-standard "function" called "alloca".

## The Heap

 - Sometimes you don't know how big your data will be.
 - Sometimes structures outlast the function that makes them.

For these circumstances, we can allocate heap memory.

sbrk syscall:
 
 - syscall #9
 - size in bytes -> $a0
 - $v0 <- address of new allocation

Once we allocate memory, it's ours. We can do whatever we want with it.

We can allocate infinite memory. Except we can't.

With sbrk, there's no way to give the memory back. If we want to limit
our total amount of memory allocation, it's our responsibility to reuse
memory when we're done with it.

In C, we get a standard function called "malloc". More on this later.

## Examples

 - Assembly linked list.
 - Sum-array-stack
 - Sum array heap


