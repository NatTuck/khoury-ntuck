---
layout: default
---

# First Thing
 
 - Homework Questions

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

# open vs fopen

 - open, close, read, write
 - fopen, fclose, fread, fwrite, printf, etc.
 - File handles (integers) vs. FILE "objects".

# fork / exec

 - draw a picture
 - man fork
 - man execl
 - fork - copy the current process
 - exec - replace program in the current process with a new one

# Fork Examples

 - show fork1, fork2, etc.

# Pipe

 - man 2 pipe
 - pipe
 - pipe with exec, replacing stdin
 - pipe with fork, doing IPC

