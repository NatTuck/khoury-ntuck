---
layout: default
---

# CS3650: Introducing xv6

## First Thing

 - Go over HW6.
 - Homework Questions?

## Introducing xv6

 - [xv6 site](https://pdos.csail.mit.edu/6.828/2014/xv6.html)
 - Pull down xv6 source, build, run.

## A bit of intro

 - [mit intro slides](./mit-x86-slides.pdf)

## Quick look at boot process

 - Pull up bootasm.S
 - BIOS starts us in 16-bit, real mode.
   - 16 bit = 16 bit offset, but +4 bits in segment register (how much RAM?)
   - real mode = no memory translation
 - Need to switch to 32-bit protected mode with page tables.
   - There are instructions for that.

## Interrupts

### Hardware Interrupts

 - How does a keypress get to a program?
 - The keyboard's probably connected by USB.
 - When you press a key, the USB controller on your motherboard gets an electrical signal
   indicating which key was pressed.
 - It sends an electrical signal to the processor down an interrupt line.
 - The processor stops what it's doing to handle the interrupt.
 - The interrupt lines into the processor are numbered. Maybe the interrupt came down line #10. 
 - The kernel has set up an interrupt table in memory.
 - The processor looks in row 10 of the interrupt table, and finds a function pointer to an
   interrupt handler. It runs that function (passing in the interrupt # and maybe other stuff).
 - That function is the USB driver handler. It works one of two ways:
   - It can execute I/O instructions, which have the CPU go ask the USB controller for data
     over the I/O bus. The answer will go into a register.
   - It can used MMAPed I/O. In that case, the USB controller has memory on it that's mapped 
     into the address space. This way the kernel uses a load instruction to get the data into
     a register.
 - Once the data's in a register, the driver can stick it in the input buffer for the program
   that should get the keypress. Probably a terminal driver.

 - MMAPed IO:
   - Side effects (read a byte to turn on a LED)
   - Problems if cached (the LED doesn't turn on), so the CPU doesn't cache these addresses.
   - Problems if optimized away (the LED doesn't turn on)
   - The C volatile keyword prevents problematic optimizations for this case.
     - Different from the Java volatile keyword.

### Software Interrupts

 - Interrupts can also be triggered by software, with an interrupt CPU instructions.
 - The argument to the syscall is the interrupt number.
 - The kernel runs the interrupt handler the same way as with hardware interrupts.
 - "int 0x80" was the syscall instruction for Linux on 32-bit x86.
 - Now amd64 has an actual syscall instruction, which might be slightly faster than the interrupt
   solution since it can skip the interrupt handler table lookup and go straight to the syscall table.

## Process table

There's an array of struct proc somewhere.

    struct proc {
      uint sz;                     // Size of process memory (bytes)
      pde_t* pgdir;                // Page table
      // ...
      int pid;                     // Process ID
      struct proc *parent;         // Parent process
      // ...
      struct file *ofile[MAX_FILES];  // Open files
      struct inode *cwd;           // Current directory
      // ...
    };

Process state:

 * pid (not an index into the process table)
 * parent link (forming tree in table)
 * Current working directory
 * The file table
 * ... more stuff I've left out

The file table has this stuff in it:

    struct file {
      enum { FD_NONE, FD_PIPE, FD_INODE } type;
      int ref; // reference count
      char readable;
      char writable;
      struct pipe *pipe;
      struct inode *ip;
      uint off;
    };

File state:
 
  * What kind of file?
  * A reference count.
    * Can this structure be shared between processes? 
    * Appear multiple times in the table?

## Program & Process Slides

