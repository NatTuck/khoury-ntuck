---
layout: default
---

# Computer Systems

## First: Homework Questions

# Shell Concepts

## Pipes

A pipe is a pair of file discriptors. What goes in the input end comes out the
output end. These can be in different processes if you've forked.

 - pipe0
 - pipe1
 - sort-pipe

## Implementing Stuff

**Executing a Single Command**

 - Fork
 - Exec in Child
 - Wait in Parent

**Redirect Input/Output**

 - Need to replace stdin/stdout with a file in the FD table.
 - That needs to happen *after* forking so we don't bork our main shell process.
 - Forking again for the command is optional.

**And / Or**

 - We need to fork/exec the first process and get the exit code before
   we decide what to do with the second process.
 - If we run the second command, we want to fork and exec for it.

**Pipe**

 - This requires at least three forks:
   - Fork first before creating the pipe.
   - Fork for the first command to set up its output FD.
   - Fork for the second command to set up its input FD.
 - Forking again for the commands is optional.

**Background**

 - Two cases:
 - One arg: Fork and don't wait on child.
 - Two args: Fork and don't wait on first child, then run second command.

**Semicolon**

 - Need to fork for the commands on both sides.
 - May not want to fork for the opreator.

**Built-in: cd**

 - Don't want to fork or exec.
 - If we did, we'd fail to change the state of the origional shell process.

**Built-in: exit**

 - We don't want to fork or exec.
 - IF we did, we'd fail to exit the original process.

## Virtual Memory

 - Draw the simple address space diagram.
 - Discuss swapping
   - Everything is backed by something on disk.
   - For text and rodata, that's the binary.
   - For stack and heap, that's swap.
   - For rodata, that's the binary COW to swap.
 - Granularity: 4k pages
 - On fork, we COW
   - Not true without MMU - then we have to copy.
   - Discuss fork vs. vfork
 - We can cram other stuff in here.
 - Stalker on 32-bit Windows story.
   - Stalker used about 1.6 GB of RAM
   - By default, windows assigns 2gb to user, 2gb to kernel
   - 512 meg video card, mapped into userspace
   - 3gb flag
   - Draw a diagram.
 - Mmmaped files
   - Map a file into memory, backed by itself.
   - Can do I/O directly with memory accesses.
   - Kernel handles reading.
   - Can be more efficient than normal read/write, sometimes.
   - Definitely easier for manipulating structs on disk, as long as you don't care 
     about files being portable across systems.

## Mmap I/O Examples

 - show save-array
 - show print-array


