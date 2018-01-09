---
layout: default
---

# Computer Systems

## Overview of Topics

- Computer Archetecture
- Programming: C -> ASM -> Machine Code
- Operating Systems: What do they give you? How do they work?
- Working on Linux.

## Syllabus

- Web Site
  - Mention Spectre / Meltdown
  - Security patches should be out today.
  - CPUs are broken, and it impacts software. I'll probably 
    talk about this more later.
- Grading
- Schedule: Reading
- Don't cheat
  - For reals
- Homeworks
  - Late policy: 1% off per hour after deadline
- Challenges
  - Like Homeworks, but harder. Start early. Really.
- Textbook ; Readings
- My notes.

## What We've Seen

- Fundies 1: High Level Programming
- Fundies 2: Slightly lower level
- Discrete: Bits; Binary Arithmetic; Logic Gates

- Here we're talking about things between logic gates and Fundies 2.

## What's this computer thing?

 - Simplest Model: CPU, RAM
   - Made out of logic gates.
 - What is RAM?
    - A big array of bytes.
    - Basic operations: Load a byte, store a byte
    - Address lines, data lines
 - What's a CPU?
   - Connected to memory.
   - Can store some data internally, in registers.
     - Registers are all the same size.
     - General purpose registers store whatever you want.
     - There are also special purpose registers.
       - Program Counter.
   - Draw 4-bit CPU, address lines, draw mem bus to IO
   - Reads instructions from RAM and executes them.
     - Reads at the address stored in the program counter.
     - "32-bit CPU" -> 32-bit registers (our simulator)
     - "64-bit CPU" -> 64-bit registers (your laptop)
   - What instructions?
     - load, store, arithmetic, branch
 - More complex model: Interrupts, mmapped IO
   - We'll see more of this later.

## How do we program a computer?

 - "Standard" answer: Write a C program.
 - Show C -> ASM -> x86 bytes (check Makefile)

 - Show MIPS ASM for add1
   - Talk about basic ASM instruction format
     - name dest, arg1, arg2
   - Show memory for .text
   - Show register values on left.
   - Show breakpoints / register values at breakpoints (incl $pc).

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

 - Next class: recursion

## Homework

 - Pull up HW1 on Bottlenose
 - Show Putty, WinSCP web page
 - Show ssh and scp on Linux
 - Show Cyberduck page
 - It's time to "figure it out yourself"

