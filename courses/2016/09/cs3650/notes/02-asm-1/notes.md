---
layout: default
---

# Computer Systems

## First Thing

 - Questions on the Homework?
 - ssh &amp; scp from Windows
 - (Afternoon: No Cheating)

## Instruction Formats

 - R, I, J
 - j vs. beq (26 vs. 16 bits for address)
 - jr exists

## The Stack

 - Draw memory.
 - Stack goes down.
   - This means we can use stack at 0($sp), 4($sp), etc.
 - lw, sw, 4-byte alignment restriction

## Sub calls

 - Show area.asm
 - jal / jr $ra
 - Save and restore $ra

## Iteration

 - Show byte-sum-iter.
 - Show little endian display of strings in memory.

## Nested Calls / The Stack / Recursion

 - Show .text, .data, .stack segments in RAM 
 - Idea: Dump register content to stack, this gives us unique storage
     per function call.
 - Show byte-sum-rec

