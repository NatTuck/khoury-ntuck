---
layout: default
---

# Computer Systems

## Overview of Topics

## Function Calls

 - Show MIPS ASM for area
  - Talk about function calls.
   - jal saves "next pc" as return address in $ra
   - jr jumps to address in register - conveniently $ra, for now

## Branches

 - Show MIPS ASM for cond-br
   - Talk about conditional branches.
   - Talk about unconditional jumps.

 - Instruction formats:
   - R - inst $dest, $arg1, $arg2; e.g. add
   - I - inst $dest, $arg1, number; e.g. addi
   - J - inst addr, ; e.g. j, jal
   - Show bit layouts (on green card)
     - There are only 26 bytes for an address in J format. How can jump work?
     - There are only 16 bytes for an address in I format (e.g. beq). How can this work?

## Recursion

 - Try to write factorial.
 - Talk about the stack.
 - Write factorial.
 - Show strlen.


