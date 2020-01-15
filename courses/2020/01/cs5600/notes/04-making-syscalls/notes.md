---
layout: default
---

## First: HW Questions

 - Homework questions?

## Today: System Calls

During the first lecture, I talked about what the operating system does. One key
element is controlling access to shared resources by:

 - Preventing user programs from directly accessing shared resources.
 - Providing an interface to safely manipulate those resources.

That interface is system calls.

System calls are kind of like function calls, except instead of executing normal
code inside your program, making a system call causes a chunk of kernel code to
execute with unrestricted access to the machine.

## What syscalls do we have?

 - [AMD64 Linux
   Syscalls](https://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/)
 - [i386 Linux Syscalls](https://syscalls.kernelgrok.com/)

Note the following:

 - General: exit, getcwd, chdir, getpid, getuid
 - File I/O: open, read, write, close
 - Memory management: mmap - more on this later
 - Timers: setitimer
 - Networking: socket, connect, accept, send, recv

## Syscall Example

Standard file descriptors:

 - 0: stdin
 - 1: stdout
 - 2: stderr

## Example 1: Hello

To make a system call on amd64 Linux:

 - Put the syscall # in %rax
 - Fill in (%rdi, %rsi, %rdx, %r10, %r8, %r9) with args.
 - run the "syscall" instruction

This will stop your running program. The processor will switch to kernel mode,
use the syscall number you specified to index into the syscall table provided by
the kernel, and will jump to that address. When the sycall is completed, the
syscall code can return to your code running in usermode with "sysret".


```
// hello64.S
    .global main
    .text
main:
    enter $0, $0
  
    mov $1, %rax   // syscall 1: write
    mov $1, %rdi   // fd 1: stdout
    mov $hello, %rsi
    mov $6, %rdx   // strlen("Hello\n") == 6
    syscall

    leave
    ret

    .data
hello: .string "Hello\n"
```


To make a system call on i386 Linux:

 - Put the syscall # in %eax
 - Fill in (%ebx, %ecx, %edx, %esi, %edi) with args.
 - run the "int $0x80" instruction

This triggers a software interrupt, specifically interrupt 0x80. This will stop
your running program. The processor will switch into kernel mode, look up 0x80
in the interrupt handler table provided by the kernel, and jump to that address.
That address is the syscall handler, which will use the value in %eax to look up
the syscall handler in the syscall table, and then jump to that code. When the
syscall is completed, the syscall code can return to your code running in user
mode using the "iret" instruction.

```
// hello32.S
    .global main
    .text
main:
    enter $0, $0
  
    mov $4, %eax   // syscall 4: write
    mov $1, %ebx   // fd 1: stdout
    mov $hello, %ecx
    mov $6, %edx   // strlen("Hello\n") == 6
    int $0x80

    leave
    ret

    .data
hello: .string "Hello\n"
```

## Example 2: lines

We're going to write a program which:

 - Opens a file called "msg.txt"
 - Reads it.
 - Counts the number of lines in it, and prints that out.

We're going to use system calls for the file access, but we'll fall back to
printf for the output because string formatting takes work.

### First, in C

 - To make a system call from C, you use a wrapper function provided by the
   standard C library.
 - These wrappers are implemented in assembly, and mostly do what you'd expect:
   - Move the arguments to the right registers.
   - Do the syscall.
 - System calls are documented in section 2 of the manual.
   - manpage references are frequently written as, e.g., open(2) or printf(3)
 - For this program, we need three system calls:
   - man 2 open
   - man 2 read
   - man 2 close

 - Show lines.c

### Then in assembly

 - Show lines.S

## Arrays and Pointers

 - Arrays in C are just like arrays in ASM. They're a contigous sequence of
   memory starting at some address.
 - Array variables store the address of the start of the array.
 - C knows how big the type stored in array is.
 - For arrays in ASM, we had to manually calculate the byte offsets.
 - An array of words in C would be xs[0], xs[1], etc.
 - Pointers are variables that store memory addresses with an associated type
   so "int\*" (int pointer) is the address of an int.
 - C lets you do arthmetic with pointers.
   - If you add one to an int pointer, it steps to the next int-sized chunk of memory.
     So if p is a pointer to a 4 byte int, then (p + 1) is the address increased by
     4 bytes.
   - Show sizeof: char, short, int, long, float, double, char\*, long\*
 - Array varibles and pointers are the same thing with different notation.
 - If pp is a pointer and aa is an array, both of the same type pointing to the same
   address, then pp[3] and \*(pp + 3) are the same thing.
 - Strangely, pp[ii] and ii[pp] are the same thing too.
   - Why?

Stuff:

 - Show prime example.
 - If extra time, rewrite prime in i386 asm


