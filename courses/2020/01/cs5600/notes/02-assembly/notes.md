---
layout: default
---

## First: HW Questions

 - Homework questions?

## Course Resources

 - In case you missed it: http://khoury.neu.edu/~ntuck/

## AMD64: ISA and ASM

Last time we compiled a simple program and the assembly didn't make much sense.
To explain what's going on, we need some history:

Intel released the 8086 processor in 1978. It was based on the earlier 8008
processor from 1972, which was based on the 4004.

At some point there must have been an 8 bit microprocessor.

 - It had a 8-bit data bus connecting it to memory and maybe other stuff.
   - That means a processor and RAM connected by 8 wires. (10 wires?)
   - ++++++ DRAW PICTURE ++++++
 - How much RAM can we address with 8 bits?
 - In addtion to RAM, this system gives us another place to put stuff called
   registers. For an 8-bit processor, each register is 8 bits.
   * CPU instructions can operate directly on registers without needing to
     load anything from RAM.
   * Registers are *not* part of RAM. This means, for example, that they don't
     have memory addresses.
 - This processor had 5-ish registers:
   - general: a, b, c, d 
   - special: ip ("instruction pointer")
 - What processors do is execute instructions. Kinds of instructions:
   - Arithmetic: Example: add \$5, %c
     - Actually probably "add \$5", implicitly operating on %a.
   - Test: cmp $5, %c
   - Conditional branch: jge bigger_label
   - Movement instruction: mov %b, %d; mov (%b), %d
   - A bunch of other stuff. You'll want to have a reference sheet.
 - Instructions tend to operate on at least one register.
 - Instructions can operate on memory addresses. If they do, the CPU needs
   to stop and read or write from RAM.

The 8086 was a 16-bit microproessor. That means:

 - It had a 16-bit data bus connecting it to memory and stuff.
 - How much RAM can we address with 16 bits?
 - The 8086 had 9-ish registers:
   - "general purpose": ax, cx, dx, bx, si, di, bp, sp
     - x is for extended; new registers are "indexes" and "pointers". 
   - "special purpose": ip, (segment registers, status register)
   - Can access low half of %ax with %al, high half with %ah.

The 80386 or i386 was a 32-bit microprocessor, backwards compatible with
the 8086. This was the first "Intel x86" processor:

 - It had a 32-bit data bus.
   - How much RAM can we address with 32-bits?
 - It had 32-bit registers.
   - If you used the old (16-bit) names (eg. %ax), you got the least significant
     16-bits of the register.
   - Each register got a new name with an "e" at the front to refer to
     the full 32 bit "extended" register:
     - eax, ecx, edx, ...

```
# double.s
# compile with: gcc -m32 -o dub double.s
  .global main

  .text
# long double(long x)
#   - the argument comes in on the stack at 8(%ebp)
#   - there's some other stuff below it we'll talk about later
#   - we return the result by putting it in %eax
dub:
  enter $0, $0

  # long y = x;
  mov 8(%ebp), %eax

  # y = y + y;
  add %eax, %eax

  # return y;
  leave
  ret

main:
  enter $0, $0

  # long x = 5;
  mov $5, %edi

  # y = double(x)
  push %edi
  call dub
  # result in %eax

  # printf("%ld\n", y)
  # arguments are pushed to the stack in reverse order
  mov $long_fmt, %edi
  push %eax
  push %edi
  call printf

  leave
  ret

  .data
long_fmt: .string "%ld\n"
```

The AMD Athlon 64 was a 64-bit microprocessor, backwards compatible with the
Intel 8086 and i386. This was the first "AMD64" (x86\_64, x64, Intel 64; not
ia64 even though x86 is sometimes called ia32) processor:

 - It had a 48-bit data bus, designed to be extended up to 64-bit later.
   - How much RAM can we address with 64 bits?
   - How about 48 bits?
 - It had 64-bit registers.
   - If you used the old names (e.g. %ax, %rax), you got the least significant
     16 or 32 bits of the register.
   - Each register got a new name with an "r" at the front to refer to
     the full 64 bit register.
     - rax, rcx, rdx, ...
   - 8 new general purpose registers were added: %r9, %r10, ..., %r15

```
# double.s
# compile with: gcc -no-pie -o dub64 double.s

  .global main
  
  .text
# long dub(long x)
#   - the argument comes in in %rdi
#   - we return the result by putting it in %rax
dub:
  enter $0, $0
 
  # long y = x;
  mov %rdi, %rax
  
  # y = y + y;
  add %rax, %rax

  # return y;
  leave
  ret

main:
  enter $0, $0

  # long x = 5;
  mov $5, %rdi
  
  # y = dub(x)
  call dub
  # result in %rax

# printf("%ld\n", y)
#  - first arg goes in %rdi
#  - second arg goes in %rsi
#  - for a variable arg function, we need to zero %al
#    - %al is the bottom 8 bits of %ax/%eax/%rax
  mov $long_fmt, %rdi
  mov %rax, %rsi
  mov $0, %al
  call printf

  leave
  ret
  
  .data
long_fmt: .string "%ld\n"
```


### Different Assembly Languages

Each ISA has its own assembly language.

Assembly for i386 and AMD64 share a syntax - unlike assembly languages for other
processors which look slightly different.

But there are differences between the two:

 * AMD64 has more registers.
   * Wider R registers.
   * Extra numbered registers.
 * They have different calling conventions.

For i386, function arguments are pushed to the stack in reverse order. For
amd64, the first six function arguments go in registers: %rdi, %rsi, %rdx, %rcx,
%r8, %r9 and then overflow is pushed onto the stack.

In both cases the return value of a function goes in the "A" register, although
that's %eax for i386 and %rax for amd64.

For extra complexity, there are two different assembly syntaxes for Intel-type
assembly languages:

 * Intel syntax
 * AT&T syntax

We're going to be using AT&T syntax in this course, but it's useful to know
about Intel syntax because the docs are in Intel syntax.

Here are the main differences:

 * In Intel syntax, there are no "%" characters before register names.
 * Argument order is different. In Intel syntax, the destination register comes
   first.
 * The expression format for calculating memory addresses is different.

## Another Assembly Example

First, Scan through the AMD64 instruction list on course site.

ASM Example: cond_br

```
.global main
.text

main:
  enter $0, $0

  # print prompt
  mov $prompt, %rdi
  call puts

  mov $long_fmt, %rdi
  mov $num, %rsi
  mov $0, %al
  call scanf

  # copy value at address
  # with dollar sign, copy literal address
  mov num, %rax

  # if (%rax <= 10)
  cmp $10, %rax
  jle smaller_than_ten

bigger_than_ten:
  mov $bigger, %rdi
  jmp main_done

smaller_than_ten:
  mov $smaller, %rdi

main_done:
  call puts

  leave
  ret

.data
num: .string "12345678" # 8 bytes, to fit a long
prompt: .string "enter a number"
long_fmt: .string "%ld"
eol: .string "\n"
bigger: .string "bigger than ten"
smaller: .string "smaller than ten"
```

```
$ gcc -no-pie -o cond_br cond_br.s
```

## idiv example

```
.global main
.text
main:
  enter $0, $0
  
  mov $40, %rax
  mov $30, %rbx
  mov $20, %rcx
  mov $10, %rdx
  
  # cqo 
  idiv %rdx
 
  # mov %rdx, %rdi
  # cqo 
  # idiv  %rdi
  
  mov $longfmt, %rdi
  mov %rax, %rsi
  mov $0, %al
  call printf
 
  leave
  ret
.data
longfmt: .string "%ld\n"
```

More Examples:

 - fact (iter)
 - fact (recursive)
 - strlen

 - fact hits the recursion problem, talk about register conventions
 - Talk about the ABI: https://github.com/hjl-tools/x86-psABI/wiki/X86-psABI
 - Programmer Manual: https://support.amd.com/TechDocs/24594.pdf
 


