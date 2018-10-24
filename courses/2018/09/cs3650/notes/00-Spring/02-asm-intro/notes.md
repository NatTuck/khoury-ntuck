---
layout: default
---

# Computer Systems

## Getting Started with ASM

 - Show MIPS ASM for add1
   - Talk about basic ASM instruction format
     - name dest, arg1, arg2
   - Show memory for .text
   - Show register values on left.
   - Show breakpoints / register values at breakpoints (incl $pc).

 - Show C code for area.

 - Show MIPS ASM for area
  - Talk about function calls.
   - jal saves "next pc" as return address in $ra
   - jr jumps to address in register - conveniently $ra, for now

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

## Homework

 - Pull up HW1a/HW01b on Bottlenose
 - Show Putty, WinSCP web page
 - Show ssh and scp on Linux
 - Show Cyberduck page
 - It's time to "figure it out yourself"

## Recursion

 - Try to write factorial.
 - Talk about the stack.
 - Write factorial.
 - Show strlen.


