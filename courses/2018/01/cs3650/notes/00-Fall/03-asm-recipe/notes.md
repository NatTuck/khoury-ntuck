---
layout: default
---

# Computer Systems

## HW Questions?

## The Stack

 - Draw the stack.
 - Walk through calculating fact(3), with the stack.
 - Talk about spilling registers when you run out.

## C -> ASM

 - Show the slides.

## ASM Recipe

 - Show the slides.

## strlen

 - Mention the data segment. Show it in MARS.
 - Code it up.
 - Mention lb and how it differs from lw.

## Syscalls

 - Stop your program, call out to the BIOS, err, Operating System.
 - Operating system does some stuff you can't do yourself.
 - Resumes your program afterwards.
 - Syscalls identified by number, looked up in a table (array) of
   function pointers (labels) that the OS keeps.
 - The lookup and dispatch is done by the processor hardware.

## Static Data

 - .space X (reserve X bytes)
 - .align X (the next thing will be at an even 2^X byte address)

Show this in MARS, print out the addresses of some labels.
