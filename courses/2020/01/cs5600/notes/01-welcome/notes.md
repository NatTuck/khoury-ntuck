---
layout: default
---

## Welcome to 5600

 - Instructor: Nat Tuck
 - Course: CS5600 - Computer Systems

Where does this course fit in?

 - You're probably a CS masters student.
 - You can write computer programs.
 - You know programs run on top of an operating system and specific
   hardware, but you may not know all the details.
 - In this course, we're going to explore some of those details in
   a certain amount of depth.

The plot:

 - To do things, programs need to use hardware resources.
 - Normally they do this by executing CPU instructions:
   - We're going to look at that a bit.
 - 1980 personal computer: one program at a time.
 - Two programs at a time means conflicts (who gets input from
   keyboard? don't want to mix output to line printer!)
 - Add a dedicated program to talk the the hardware: the OS. Other
   programs ask the OS to access shared resources for them.
 - To ask the OS to do stuff for you, you make a system call.
 - This class is largely about system calls:
   - How to write programs that use them.
   - How they are implemented in the OS kernel.
 - System calls are different on different operating systems,
   so we need to pick a specific one to use.
 - We're using Linux. More specifically, Debian 10.
 - Even with an OS, programs are still written to target a specific
   hardware archetecture.
 - Compiled programs are binary data - machine code - and different
   kinds of processors have different machine codes.
 - We'll be primarally using the normal archetecture for desktop / laptop
   computers, the AMD64 archetecture.
 - Secondarily, we'll be using the old 32 bit version of that archetecture,
   i386.
 - A platform is the combination of processor archetecture and OS,
   for us that's AMD64 Linux.

## Course Resources

 - My site: http://khoury.neu.edu/~ntuck
 - Course Site / Syllabus
 - Piazza
   - If you get stuck, you can ask questions here.
   - You shouldn't generally post code.
   - Not for direct messages to course staff: use email for email.
 - Inkfish (wait until covered below)
 - Office Hours start Wednesday.

## Syllabus

 - There's a topic list. It may resemble what happens.
 - There should be a schedule. There isn't yet.
 - Grades: Homework, Participation, Grade Challenges
 - Homework: These are difficult programming assignments.
 - Participation: Three parts:
   * Good questions and answers on Piazza.
   * Persistent good questions and answers both in class and/or at
     office hours.
   * Possible in-class activities.

Grade Challenges

 - When you recieve a grade on Inkfish, you have two weeks to challenge that
   grade or until Wednesday of finals week, whichever is earlier.
 - The first step is an informal challenge to the grader. Visit their office
   hours. If they think the grade is wrong, they'll fix it.
 - If it's the autograder, that's my office hours.
 - If the informal challenge didn't work, submit a formal grade challenge by
   sending me an email.
 - You start with two challenge tokens. Submitting a formal challenge costs one
   token.
 - I will regrade the assignment from scratch.
   - If that gets you a higher grade, you get your token back.
   - If not, you don't get the token back.
 - If you run out of tokens, you can't submit more formal challenges.
 - Each remaining token at the end of the semester is worth half a percent
   of your final grade.

Cheating

 - Copying code without clear, written attribution is plagarism.
 - If you submit plagarized work, you fail the course.
 - You're not allowed to share solution code with other students either.
 - If you cheat, you get reported to the college, which is bad.
 - You are given starter code for assignments, you can use that.
 
 - There is code shown in lecture. It's not starter code, so using
   it without attribution is plagarism. This is the one case where I
   might be lenient on the policy, but I also may just give you an
   F for the semester on the first offense.

The best way to avoid cheating (and the best way to learn the content
in this course), is to personally type your own code. Don't download
other people's solutions, don't copy and paste other people's code, etc.

## Inkfish

 - Show HW01

## HW01 - Part 1

A local Linux VM:

 - The easiest way to do programming work is to have the development
   environment installed locally on your personal computer.
 - For Linux systems programming, Linux *is* our development environment.
 - Having it installed as your main OS is probably best.
 - But, for consistentency, the assignment is for everyone to install
   exactly Debian 10 64-bit in a VirtualBox virtual machine.
 - If you aren't developing on the VM and you run into weird problems later in
   the semester, use this VM to rule out configuration issues.

The CCIS server:

 - ssh ntuck@login.ccs.neu.edu
 - This is a shared Linux server.
 - This is a generally useful tool, and it will be possible
   to do some of your homework on this server.
 - Working directly on a remote server is a good reason to learn
   a command line editor like vim.
   
 - Show Putty, WinSCP web page
 - Show ssh and scp on Linux

## HW01 - Part 2

Part 2 of HW01 primarily serves to verify that you have your development
environment set up, but in the process were going to write three functions:

 * square in C
 * cube in AMD64 assembly
 * add1 in i386 assembly

C and Assembly can share functions - the functions just go in separate files. So
for this assignment you'll be creating a new file for each function and building
the test programs with the provided Makefile.

Once you've done this, you'll submit your homework on Inkfish and the
autograding script will verify that your program is correct.

# Intro to Assembly

We're not going to cover the basics of C in this course. It's similar enough to
other languages that you've already used that even if it's new to you you should
be able to pick it up pretty quick from examples.

I'll say: "It's kind of like Java with one class and all methods are static".

Assembly is a pretty big change from most other languages, so we will cover that
in a bit more depth.

## C -> ASM

 - "Programming" means "writing C code".
 - On Linux-like (UNIX, *nix, POSIX) systems, the operating system
   API is primarily exposed to C programs through the system C library.
 - The hardware doesn't run C though - it runs amd64 machine code (on your
   laptop) or ARM machine code (on your phone) or maybe some other machine
   code.
 - Machine code is for machines, not humans, so it's hard to read.
 - Machine code is a series of instructions. If you write the instructions
   down as text, you get assembly language.
 - To run a C program, you need to translate to machine code (or "binary").
 - Conceptually, and historically, you first translate C -> ASM, then 
   ASM -> binary.
 - You can still do this if you explicitly ask for it.

Note: For the first few homeworks you will be writing ASM programs. You
should *not* have a compiler do this for you. Submitting compiler output
for an assembly assignment is worth zero points.

Let's write a simple C program with two functions:

```
// double.c
long
dub(long x)
{
    return x + x;
}

int
main(int _ac, char* _av[])
  // initial _ marks args as not used
{
    long x = dub(5);
    printf("%ld\n", x);
    return 0;
}
```

```
# C => asm
$ gcc -S -o double.s double.c
# take a look at double.s
```

 - Two functions: double, main
   - each starts at label, ends at "ret"
 - In main, the value 5 is moved to "%rdi"
   - That must be where the function's first argument goes.
   - No, that's "%edi"
   - I said "%rdi", wait a second...
 - Then add1 is called
 - In add1, the value from %rdi goes to some places.
 - Eventually, "addq $1, ..." happens to it.
 - Back in main, %rax is moved to %rsi, and printf is called.

This almost makes sense, but it's a bit of a mess. Let's figure it out.

## AMD64: ISA and ASM

Intel released the 8086 processor in 1978. It was based on the earlier 8008
processor from 1972, but...

The 8086 was a 16-bit microproessor. That means:

 - It had a 16-bit data bus connecting it to memory and maybe other stuff.
   - That means a processor and RAM connected by 16 wires.
 - How much RAM can we address with 16 bits?
 - In addtion to RAM, this system gives us another place to put stuff called
   registers. For a 16-bit processor, each register is 16 bits.
 - The 8086 had 9-ish registers:
   - "general purpose": ax, cx, dx, bx, si, di, bp, sp,
   - "special purpose": ip, (segment registers, status register)
 - What processors do is execute instructions. Kinds of instructions:
   - Arithmetic: Example: add $5, %cx
   - Test: cmp $5, %cx
   - Conditional branch: jge bigger_label
   - Movement instruction: mov (%sp), %dx
   - A bunch of other stuff. You'll want to have a reference sheet.
 - Instructions tend to operate on at least one register.
 - Instructions can operate on memory addresses. If they do, the CPU needs
   to stop and read or write from RAM.

The 80386 or i386 was a 32-bit microprocessor, backwards compatible with
the 8086. This was the first "Intel x86" processor:

 - It had a 32-bit data bus.
   - How much RAM can we address with 32-bits?
 - It had 32-bit registers.
   - If you used the old names (eg. %ax), you got the least significant
     16-bits of the register.
   - Each register got a new name with an "e" at the front to refer to
     the full 32 bit "extended" register:
     - eax, ecx, edx, ...

Here's how we write an assembly program for i386:

```
# double.s
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

Compile this with:

```
$ gcc -m32 -o double32 double32.s
```

The AMD Athlon 64 was a 64-bit microprocessor, backwards compatible with the Intel
8086 and i386. This was the first "AMD64" processor:

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

And that's where we are today. Let's write a double program in amd64 assembly:

```
# double.s

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

To compile this simple hand-written assembly, we use:

```
$ gcc -no-pie -o add2 add2.s
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

We'll talk a bit more about the details of assembly over the next few classes.
These examples should be sufficient for you to complete HW01.


