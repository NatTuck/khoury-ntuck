---
layout: default
---

# Computer Systems

## Challenge Questions?

## Last Class

 - You don't have to come to this class anymore after today.
 - TA office hours end tomorrow
 - I'll have office hours as usual next week.
 - Grading issues must be resolved by next Wednesday.
 - Do your TRACE evals:
   - Helps both me and the college improve the course.
   - Helps other students understand what to expect.
   - High response rate helps me.

## Extra Credit

I normally don't do extra credit, but I came up with a good concept, so there's
an extra credit assignment: redoing the hash table task from HW04 with a BTree.

This is purely extra credit. If you don't do it that can't hurt your grade.

Don't start this until you've completed CH03. 

The material to complete the assignment is included in the assignment. There
won't be much for office hours, so plan enough time to understand and debug it
yourself.
 
## Garbage Collector Slides

Normally I'd do a review of the semester today, but there's one thing we missed
that I really like to cover: Garbage Collection

http://ccs.neu.edu/home/ntuck/courses/2015/01/cs5600/slides/8_Free_Space_and_GC.pptx

Start @ slide 40

## Semester Review

This semester we covered systems programming: how an application programmer
interfaces with the system they're working on.

 - The system is OS + ISA
 - Our concrete platform was Linux on AMD64
 - A natively compiled program is a sequence of machine instructions. Our
   interface to the platform is those instructions.
 - One key instruction is syscall: That allows us request that the OS do stuff
   for us that we can't do directly.

Assembly programming:

 - Assembly allows us to program with single instructions.
 - The instructions and patterns we used in ASM are what our C programs are
   doing as well.
 - We saw how C maps to assembly.

C programming:

 - We did an assignment building two common data structures: Vectors and
   Hashmaps
 - A key idea in system programming is that our program executes in an address
   space. Data is stored in memory, and memory can be referenced by numeric
   memory address - in C, these addresses are pointers.
 - A structure is just different types of items next to each other in memory.
 - An array is just a bunch of the same type of item next to each other in memory.

Processes and File Descriptors:

 - We created processes with fork
 - We executed programs with exec
 - Each process has a table of file descriptors. We can manipulate these file
   descriptors to redirect standard streams like stdin.
 - With these tools, we built a shell.

Virtual Memory and Memory Mapping:

 - Each program has its own memory address space.
 - This happens because the OS and CPU conspire to lie to the process about
   memory addresses using a page table.
 - We can manipulate the page table with mmap.
 - This lets us do a couple of neat things:
   - Share memory between processes.
   - Map files into memory, allowing us to do I/O by doing loads and stores
     to memory.

Memory allocation:

 - All the memory for the process comes from mmap.
 - The heap is an abstraction around mmap.
   - Users allocate memory with malloc
   - Free memory with free
 - We built these functions ourselves.
 - We looked into the tradeoffs of how to build this functionality.
 - Key idea: Memory allocation isn't free, but it can be made pretty
   cheap in the common case.

OS kernel:

 - There's one piece of code that's always running when the machine is
   running: the OS kernel.
 - This manages resources and enforces contraints on user processes for
   reliability and security.
 - All of these system calls we've been using are implemented by code
   in the kernel.
 - We looked at what kernels do, and specifically at the process for
   executing system calls.

Filesystems:

 - We want some of our data to stick around even when our program ends or our
   machine reboots.
 - We want to be able to find stuff, so we put it in a heirarchy of files,
   directories, and stuff.
 - We store this data in persistent storage: hard drives, ssds, etc.
 - We looked at what properties these devices have and how we can structure our
   data to store it.
 - You're finishing up your filesystem now.


