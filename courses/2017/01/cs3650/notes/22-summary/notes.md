---
layout: default
---

# CS3650: POSIX Threads - Examples

## Today's Plan

 - Most of class today will be a "homework workshop", where we
   try to get as many people unstuck on the homework as possible.
 - But first, let's review the semester.
 
## Review of the Semester

We covered a lot of stuff:

 * Computers have processors that execute instructions.
   * Arithmetic
   * Jumps / Branches
   * Loads / Stores
 * Computers have memory and memory addresses.
 * We can program computers one instruction at a time with
   assembly code.
 * We don't want to write assembly, so we can step up one
   layer of abstraction to C. 
 * C code is compiled to assembly, and the transformation
   is mostly direct and predictable.
 * We still need to worry about memory addresses: pointers.
 * C introduces data types. Primarily:
   * Primitive types: integers, floats
   * Structures: Data with multiple parts.
   * Pointers: Memory addresses, but we know what type of
     thing is at that address.
 * Programs have standard layouts, both on disk and in
   memory.
    * On disk: text, data
    * In memory: text, data, stack, heap
 * Programs can access services provided by the OS or hardware through
   system calls.
 * Making a system call is a CPU instruction, but the call is implemented
   by code in the OS kernel.
 * If you want to know how a system call is implemented, you can generally
   read the code. This is true on Linux, BSD Unix (including Mac OS), and
   many embedded systems. Windows is the main exception - hopefully their
   documentation is really good.
 * Programs run in processes. 
   * Processes are created by cloning existing processes with fork().
   * Programs are loaded into processes with exec().
 * Multiple processes can run on the computer at the same time. This
   can get complicated.
 * Each process has some state, including a table of open files. File
   I/O is performed with system calls.
 * A shell is a program that runs other programs, either due to human
   interaction or a script. We wrote a shell.
 * Virtual memory: every program gets its own address space,
   kernel and hardware conspire to translate virtual <-> physical
   addresses.
 * Virtual memory is organized in 4k pages. We can set up our own
   page mappings with mmap (to create the "heap", or for other reasons).
 * A process can have multiple threads executing concurrently and sharing
   the same address space.
 * Concurrent programs are incorrect by default.
 * Concurrency allows data races, which mess up everything.
 * Data races can be fixed with mutexes, but mutexes allow deadlock.
 * Concurrent execution + shared data requires some sort of programming
   constraint be applied - either globally for the whole program, or for
   each instance of shared data.
 * Possible constraints:
   * Any access to shared data must be protected by a mutex. Multiple
     mutexes must be locked in a global fixed order.
   * No shared data may be mutated.
   * All data sharing must be by message passing through carefully built
     thread-safe queues.
   * ... others
 * Once a constraint has been chosen, it must be strictly followed for
   the program to be correct.
 * We can share memory between processes with mmap. This adds shared data
   to the existing inter-process concurrency, and must be handled as with
   threads.
 * Files are stored on disks in a file system. There are a variety of
   on-disk layouts used to provide efficent access and various features.

## Homework Workshop

 * First, global homework questions.
 * Then, open peer help.
 * Our goal: 0 stuck students at the end of class.

Rules:

 * You can discuss issues.
 * You can look at parts of other student's code to help support
   discussion - either to find bugs or describe how to solve 
   specfic issues.
 * Don't copy code from other students.


