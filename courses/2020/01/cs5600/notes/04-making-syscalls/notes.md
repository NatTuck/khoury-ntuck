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
  
    mov $4, %eax   // syscall 1: write
    mov $1, %ebx   // fd 1: stdout
    mov $hello, %ecx
    mov $6, %edx   // strlen("Hello\n") == 6
    int $0x80

    leave
    ret

    .data
hello: .string "Hello\n"
```




