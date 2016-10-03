---
layout: default
---

# First Thing
 
 - Homework Questions

# Function Pointers

 - Show map example.

# Malloc and Free

 - p = malloc(nn) allocates a block of nn bytes from the heap.
 - free(p) gives that memory back
 - let's make map actually work correctly
 - Print address of something malloc'd compared to &main and something on the stack.

# Structs

 - Passing nn around is silly. Let's extend map with fat pointers.
 - In C we need to say "struct foo" whenever we use a foo.

# Typedefs

 - Function pointers and structs are obnoxious.
 - Let's rename our types to something reasonable.

# Macros

 - Constants
 - "Function-style" macros. 
    - Always paren your arguments.
    - Show DOUBLE(a) (a + a)
    - DOUBLE(x++)

# Unix Shell

 - Type a command, it runs.
 - Redirect to / from files.
 - Pipe to other commands.
 - Background jobs. &amp;
    - Ctrl+Z
    - ps
    - fg
    - bg
 - Subshells.

# Unix APIs

 - POSIX (UNIX / Linux) operating systems provide their interface to
   programs at the C language level.
 - The interface comes in the form of two piles of functions.
   - The C library (man section 3).
   - System calls  (man section 2).
     - These are C wrappers around the same sort of system calls
       we saw in MARS.

# stdio
 
 - man stdio
 - printf, fgets, 

# fork / exec

 - draw a picture
 - man fork
 - man execl
 - fork - copy the current process
 - exec - replace program in the current process with a new one

# open vs fopen

 - open, close, read, write
 - fopen, fclose, fread, fwrite, printf, etc.
