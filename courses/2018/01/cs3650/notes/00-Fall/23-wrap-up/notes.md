---
layout: default
---

# Computer Systems

 - 09:50 – 11:30
 - 13:35 – 15:15

## Today's Plan

 - Semester Review First
 - Challenge 3 Questions / "Workshop"

## Semester Review

### Assembly (MIPS)

First, we admited that software runs on concrete hardware.

 - Starting point: Sequential RAM
   - Programs both live and store data in memory.
   - Each byte of memory has an integer address.
 - CPUs work as follows:
   - Read an instruction from RAM
   - Execute it
   - Move to the next address
   - Repeat
 - CPU has registers
 - Kinds of instructions:
   - Arithmetic
   - Jump
   - Conditional branch
   - Load / Store
   - Call / Return

We don't want to write binary machine code by hand, so we use assembly, where we can
call instructions by name using a textual format.

Even at this level, we have a key tool for abstraction: functions.

 - Functions accept arguments and return a value.
 - By using the stack and following the calling conventions, we can pretend that
   functions are isolated and each have their own registers.

Program layout in memory:

 - Text
 - Static Data
 - Stack
 - Heap
 
Problem layout on disk:

 - Text
 - Static Data

That's enough to implement pretty much any algorithm. Unfortunately, we can't
write "Hello, World".

Another instruction type: Syscalls

There's an operating system, and it forces us to share.

 - We have to share I/O devices, so I/O takes syscalls.
 - We have to share RAM, so we need a memory allocation syscall.

### C Programming

We started with the idea that C was just a nicer way of writing assembly.

 - Higher level logic:
   - Infix arithmetic
   - Loops
   - Array syntax
   - Functions
   - Local variables in functions
 - We can still see how it all maps back to assembly.
 - But we don't care *which* assembly. It could be MIPS, or x86, or ARM.

It turns out that this lets us program in a reasonbly high level style, although
generics and standard data structures would be nice.

### Linux Syscalls from C

 - In C, access to syscalls just means calling wrapper functions from
   the standard library.
 - We call write(2), which is a function that does the actual sycall instruction.

### Virtual Memory and mmap

So far our model for memory is that we can refer to locations with byte addresses.

It turns out that it's useful to virtualize these addresses. That way each program
can pretend it has the whole address space to itself.

Concretely, this means:

 - Every program can be loaded and run at the same start address.
 - Processes can't overwrite each other's memory, since they can't even express
   the memory address of data in another process.

Doing this efficiently requires a complex conspiracy between the CPU and the OS, but
the result is that programs work with an address space made up of virtualied 4k pages.

Neat benefits:

 - We can swap unused memory to disk to make space for more stuff in RAM.
 - We can map things like files into memory so they can be accessed directly with
   instructions like load and store.

### Processes

POSIX provides an interesting way to create new processes:

 - fork() - A system call that duplicates the current process, resulting in two
      processes both running the same program.
 - exec() - A system call that runs a new program in the current process, replacing
      the old program and creating a clean virtual address space.

We explored this API in the first challenge, writing a Unix-style shell.

To complicate things further, significant process state is maintained across fork(),
such as the file descriptor table. This allowed us to manipulate the standard file
descriptors for newly spawned programs - redirecting stdin / stdout to refer to files
pipes.

We saw how to communicate between processes with explicitly mapped shared memory, and
how concurrent execution + shared memory got us into the mess of data races, locks,
and deadlock.

### Threads

Processes allowed us to express concurrency in program execution and to execute in
parallel across multiple CPU cores, but it made sharing memory tricky.

Our next mechanism for concurrency / parallelism was threads - a more direct way to
get us into the data races / locks / deadlock mess.

We did two homeworks with IPC: One with processes, one with threads.

### Memory Allocators

Next up we took a look at memory allocators. The OS provides us a mechanism to
request chunks of address space (mmap), but there are opportunities to be more
efficient and provide a nicer API.

We discussed the simple solution - free lists - as well as more complex real-world
allocators like jemalloc.

We did two assignemnts with allocators. One to create a simple free list allocator,
and a challenge to make an optimized, thread safe allocator.

### Kernels and Syscall Implementation

After looking at system calls from the userspace side, we took a look at an OS
kernel in xv6. This gave us a look at the other side of system calls.

### File Systems

Finally, we've spent the last couple weeks on file systems. Storing data on
persistent storage seems pretty simple - it should just be a memory allocator
with object names - but it ends up being surprisingly complicated.

We saw FAT, ext1-4, the Log Structured FS, and modern CoW systems.

And Challenge 3 is due tonight.

## Challenge 3 Questions

 - Any questions on Challenge 3?
 
