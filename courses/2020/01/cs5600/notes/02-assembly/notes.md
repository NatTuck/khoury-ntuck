---
layout: default
---

## First: HW Questions

 - Homework questions?

## Course Resources

 - In case you missed it: http://khoury.neu.edu/~ntuck/

## AMD64: ISA and ASM

Intel released the 8086 processor in 1978. It was based on the earlier 8008
processor from 1972, which was based on the 4004.

At some point there must have been an 8 bit microprocessor.

 - It had a 8-bit data bus connecting it to memory and maybe other stuff.
   - That means a processor and RAM connected by 8 wires. (10 wires?)
   - ++++++ DRAW PICTURE ++++++
 - With an 8 bit memory address, you can have up to 256 bytes of RAM.
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

(it's in .../amd64_asm.html)

Note specific groups of instructions:

 * Arithmetic
 * Flow control
 * Stack
 * Memory access
 * Function calls

Intel assembly has some weirdness.

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
 
  # Calling convention:
  #  - Args go in %rdi, %rsi, %rdx, ...
  #  - For variable argument functions, we put 0 in %al
  mov $longfmt, %rdi
  mov %rax, %rsi
  mov $0, %al
  call printf
 
  leave
  ret
.data
longfmt: .string "%ld\n"
```


## Register usage conventions and the stack

 * Our #1 place to put stuff is registers.
 * They're the easiest and fastest place to store numbers.
 * Two problems:
   * Not everything is a number. e.g. Strings don't fit in registers.
   * We only have one set of registers.
 * In C (and most languages) we have local variables that are only availble
   in a single function and don't interfere with our code in other functions.
 * We don't have those in assembly - so we follow some conventions to let
   us pretend that we do.

Register conventions:

 * Temporary registers: %rax, %rcx, %rdx, %rsi, %rdi, %r8..%r11 
 * Any function call is assumed to overwrite temporaries.
 * If you want to keep them through a function call, it's your resposibility
   to "caller save" them before the function call and restore them after.
 * Safe registers: %rbx, %r12..%r15
 * These registers won't be overwritten if you call a function.
 * That means if you want to use them, you need to "caller save" them at
   the start of your function and restore them at the end.

The stack:

 * Aside from registers, our other place to store data is memory.
 * For each function call there's some data we'd like to store that's
   specific to that function call.
 * We get a special region of memory - the stack - for storing that stuff.
 * When the program starts up, our %rsp register points to the top of the
   stack.
 * The stack grows down.
 * This is going to need some examples and pictures.

## More Examples

 - fact (iter)
   - Draw a memory diagram: stack, text, data
   - Variable mapping. No register needs to surivive a function call.
   - Enter instruction. The stack grows.
     - %rsp starts at the top
     - We call "enter \$0, \$0"
     - Base pointer at top of frame, stack pointer at bottom.
   - We don't have loops - they translate to branches with labels.
 - fact (recursive)
   - Stack alignment. Need to be on a 16 byte boundary when you issue "call".
   - Type it ignoring conventions. It fails.
 - fact 32-bit (recursive)
   - The alignment requirement is still technically 16 bytes, but nothing
     should break if you're not passing vector values.
   - 32-bit safe registers: %ebx, %edi, %esi (and the stack stuff)
   - Temporaries are: %eax, %ecx, %edx
 - Talk about the ABI: https://github.com/hjl-tools/x86-psABI/wiki/X86-psABI
 - Talk about the 32-bit ABI: https://www.uclibc.org/docs/psABI-i386.pdf
 - Programmer Manual: https://support.amd.com/TechDocs/24594.pdf
 
## Bonus example

 - fives.S
 - This is how we get command line args.

