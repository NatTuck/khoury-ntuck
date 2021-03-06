---
layout: default
---

# Core Course Concepts

 * Learning how to figure out an API is more important than learning an API.
 * Linux has man pages and it's possible to use them to figure out how
   the POSIX API works.

Homework vs. Challenges:

 * A student who doesn't complete a homework 100% should have done better.
 * A student who doesn't complete a challenge 100%, especially if they fail
   the "challenge goal", is still on track.

# Homework Schedule

## HW01: Linux Setup & ASM Hello World

Goal: Get students set up with Linux dev environments.

 * Connect to CCIS login server.
 * Install a local Ubuntu VM.
 * Compile and Run a C Hello World.
 * Compile and Run an ASM Hello World.

## HW02: ASM: Calculator, Fib

Goal: Write ASM code following the "ASM Design Recipe", including recursion.

 * Write a four function calculator.
 * Write a Fibonacci number generator.

## HW03: ASM: Merge Sort w/ dynamic memory allocation

Goal: Write a more complex ASM program, using syscalls either directly
      or through libc.

 * Write an ASM program that does out-of-place merge sort.
 * TODO: Figure out if students should use libc malloc or use mmap
   to pre-allocate working space.
 * Students definitely need to write "syscall" for this one.

## HW04: Shell tokenizer

Goal: Write a C program that does string manipulation. This should
      exercise knowledge of arrays, pointers, and malloc.

Goal 2: Get started on a UNIX shell. Start thinking about tokens and
      what they mean.

 * Write a program that takes shell commands as input and outputs
   a series of tokens.
 * Producing the output should require an intermediate data structure
   by, e.g., outputting the number of tokens first.
 * The output should probably also include token classification,
   e.g. command, argument, operator.

## CH01: Unix Shell

Goal: Use POSIX syscalls: fork, exec, pipe. Manipulate the file descriptor
      table of POSIX processes.

 * Write a UNIX shell that can execute commands interactively and run scripts.
 * This should support simple commands with arguments.
 * This should support basic shell operators: && || > < | & ;
 * Challenge goal: Parens and nested operations. Order of operations.

Note: Order of operations shouldn't be explicitly specified. Students can
figure it out by playing with bash and thinking about the tests.

## HW05: Parallel sample sort (processes, mmap, semaphores)

Goal: Write a program that needs to deal with the problems of concurrency and
      that can get a parallel speedup, using Linux processes.

 * Students are given starter code including a basic program structure and
   a "barrier" primitive.
 * Students need to do file I/O with mmap.
 * Students need to allocate shared memory with mmap for IPC.
 * Students need to implement a working sample sort.
 * Students need to use the barrier primitive to avoid data races.

## HW06: Parallel sample sort (pthreads, mutexes, condvars)

Goal: Play with threads, mutexes, condvars, etc.

 * Students mostly port their HW05 to the new API.
 * Students need to write their own barrier using cond vars.

## HW07: Memory Allocator: Simple Free List

Goal: Build a minimally functional malloc / free using mmap.

 * Students are expected to use a singly linked free list mainained
   in sorted order since that's the simplest case.
 * Students are given minimal starter code to ensure interoperability
   with the test cases (which include some counters for validation).

## CH02: Multi-threaded, optimized allocator

Goal: Deal with runtime optimization in the presence of real multi-core
      processors.

Goal: Deal with a hard, open-ended problem.

 * Students are given a couple of concrete test cases and asked to write
   an allocator that beats the system allocator.
 * This requires the use of techniques like thread-local caches, sized
   allocation buckets, etc.
 * Everyone should be measurably faster than the HW07 allocator with a global lock.
 * Challenge goal: Concretely beat the system allocator.

## HW08: Exploring xv6

Goal: Explore the structure of a complete, functioning OS kernel.

 * Read the xv6 source and answer a bunch of questions.

## HW09: Simple Filesystem

Goal: Build a minimal file system.

 * Build a FUSE filesystem that mounts a fixed-size 1MB disk image.
 * Handle a single root directory.
 * Handle files that fit in a single (4k) data block.
 * Basic operations: create, read, write, delete, dir list, rename
 
## CH03: Advanced Filesystem

Goal: Build a more complex FS.

 * Handle nested subdirectories.
 * Handle multi-block files.
 * Create and remove directories.
 * Symbolic and hard links.
 * Set metadata (permissions, timestamps)
 * Challenge goal: Get everything working

 
