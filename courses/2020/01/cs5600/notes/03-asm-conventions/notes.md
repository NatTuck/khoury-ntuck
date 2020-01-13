---
layout: default
---

## First: HW Questions

 - Homework questions?

## Course Resources

 - In case you missed it: http://khoury.neu.edu/~ntuck/

## Calling Conventions Review

amd64

 - Pass args in: %rdi, %rsi, %rdx, %rcx, %r8, %r9, ...stack
 - Return value in %rax
 - Safe registers: %rbx, %r12..r15
 - Temporary registers: %rax, %rcx, %rdx, %rsi, %rdi, %r9..$r11

i386

 - Pass args on the stack
   - After enter, these come in at 8(%ebp), 12(%ebp), ...
 - Return value in %eax
 - Safe registers: %ebp, %esi, %edi

## Recursive Factorial

 - Start with i386
 - Redo the amd64 version
 - Make sure to do variable mapping comments

## Fives

 * fives.S
 * Explain prototype for "main".
 * Draw the array of strings memory layout.
 * Explain strings; null termination.
 * Point out movb to guarantee single-byte moves.

Memory access syntax:

 * (%rax)  - get the value at the memory address in %rax
 * 8(%rax) - get the value at the memory address (%rax + 8)
 * (%rax, %rcx, 2) - get the value at the memory address (%rax + %rcx * 2)

## Being a compiler

 * Each statement in C translates basically 1:1 to assembler.
 * Here's patterns for:
   - variable assignment
   - if
   - while
   - for
   - function call
   - etc

