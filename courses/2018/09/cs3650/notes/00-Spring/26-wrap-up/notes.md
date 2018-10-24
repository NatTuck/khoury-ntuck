---
layout: default
---

# Computer Systems

 - Last class
 - TRACE Evals - Do them.
 - Challenge questions?

## What happened this semester?

 - MIPS Assembly
   - CPUs execute instructions
   - Picture: CPU, bus, RAM
   - kinds: arithmetic, con br, load/store, jal/jr
 - How C and ASM are different views of the same logic.
   - Function structure; the stack.
 - Processes, Process Address Space
   - Modern OSes and Processes conspire to make running programs feel
     like they've got the machine to themselves.
   - An instance of a running program is a process.
   - Each has its own separate (virtual) address space.
   - Draw the picture.
 - Syscalls from ASM
   - I/O
   - Memory Allocation: sbrk
 - Basics of C
   - A C program is basically a collection of functions.
   - Execution starts at "main".
   - Execution stops when main returns, or on exit.
 - Syscalls from C: I/O, Memory Allocation
   - POSIX I/O: open, close, read, write, lseek, etc.
   - C Mem Alloc: malloc, free
     - Wait, those aren't syscalls.
     - We'll fix this later.
 - Tokenizer
   - This looks easy.
   - Turns out you want regular expressions or (equivilently)
     state machines to do this well.
 - Parser
   - This looks harder.
   - Requires an output data structure.
 - Unix Processes: fork, exec, waitpid
   - Windows has CreateProcess("file.exe")
   - POSIX splits this to fork / exec.
     - This is weird.
     - This is useful.
 - File Descriptor Table
   - Element of process state.
   - First few slots are special:
   - 0: stdin
   - 1: stdout
   - 2: stderr
   - Inherited across fork
 - Building a Shell: Pipes and Redirects
   - Pipe: can create a pair of file descriptors that are linked
   - Using fork and process table inheritance, this is
     good enough for shell pipe and redirect operators.
 - Virtual Memory
   - The process address space is virtualized.
   - Broken up into 4k pages.
   - Pages can be mapped to physical memory.
   - Or to files on disk.
   - Or maybe to other stuff.
   - We control mappings with mmap.
 - Shared Memory (mmap) => Data Races
   - If you mmap and fork, it does copy on write.
   - If you mmap and set it explicitly shared, it's shared.
   - And now we have shared memory and concurrent execution.
   - So... data race.
 - Semaphores => Deadlocks
   - We can fix data races by building locks (from semaphores).
   - So... deadlock.
 - Threads & Mutexes
   - Threads let us have concurrent execution in the same process.
     - Address space, FD table are shared.
     - Registers are not shared, including program counter.
   - Mutexes are provided.
 - Cond Vars
   - Sometimes we want to block on stuff other than a lock.
   - For example, waiting on a condition.
   - Cond Vars allow this.
 - Atomics
   - Languages offer atomic instructions for primitive types.
   - With very careful reasoning, this can allow "lock-free algorithms".
   - This is the sort of situation where formally proving pieces of a
     program correct might be a good idea.
 - malloc: Free List
   - You built an allocator.
   - Improvements: Sized bins; thread-local caches.
 - OS Kernels - The other side of syscalls
   - xv6
 - Storage Hardware: HDs, SSDs, Optane
   - HDDs seek really slowly
   - SSDs can't overwrite, must read, modify, write to new spot, GC later
   - Optane is closer to ideal NVRAM - can write a single byte.
 - File Systems: FAT, ext
   - In FAT, a file is a linked list of blocks.
   - ext is more complicated
 - Modern Filesystems: journaling, COW
   - journaling allows replays on crash
   - COW allows snapshots
   - modern systems also build in RAID-like features and store checksums
 - Building a FS
   - You've got a pretty fancy one by now.
 - Solutions for concurrency
   - data races -> locks -> deadlock
   - transactional memory
   - message passing
 - Transactional FS
   - Is apparently possible
 - Wrap-Up

## Wrap Up

 - TRACE Evals - Do them.
 - Last chance for grade issues is my office hours next Monday.
 - I hope you had fun with segfaults.
 - Have a good summer.

