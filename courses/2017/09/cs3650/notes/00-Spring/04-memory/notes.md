---
layout: default
---

# Computer Systems

## HW Extension

## Memory Segments in a Process

 - Stack
 - Code
 - Static Data
 - Heap

## Static data

 .data
 .space X (reserve X bytes)
 .align X (start the next thing on a 2^X boundry).

We use labels to reference things.

## The Heap

 - Sometimes you don't know how big your data will be.
 - Sometimes structures outlast the function that makes them.

For these circumstances, we can allocate heap memory.

sbrk syscall:
 
 - syscall #9
 - size in bytes -> $a0
 - $v0 <- address of new accloation

Once we allocate memory, it's ours. We can do whatever we want with it.

We can allocate infinite memory. Except we can't.

With sbrk, there's no way to give the memory back. If we want to limit
our total amount of memory allocation, it's our responsibility to reuse
memory when we're done with it.

## Example

Not assembly linked list.

Sum-array-stack
Sum array heap


