---
layout: default
---

# Computer Systems

## HW Questions?

## Spectre & Meltdown

### CPU Caches

 - Draw the CPU <=> Memory Diagram
 - 70 ns to main memory (~ 16 GB)
 - 2 ns to L1 cache (~ 16kB)
 - Every load or store first loads a 64-byte cache line into L1 cache.
 - Caches are approximately least-recently-used, so an old cache line is evicted
   once you've loaded enough new lines to fill the cache.

### Branch Prediction & Speculative Execution

 - CPUs have pipelines.
 - Fetch => Decode => Execute => Retire
 - Branches are expensive - you don't know what to fetch next.
 - So CPUs guess.
 - Simplest solution: Backwards taken, forwards not.
   - If conditions are false.
   - Loops always loop.

```
loop:
   subi $s0, $s0, 1
   beq $s0, $zero, done
   subi $s1, $s1, 1
   beq $s1, $zero, loop
done:
```

### Spectre Variant 1: Bounds Check Bypass

Example: JavaScript code steals passwords in web browser.

```
var ys = [1,2,...,64*256];
var xs = [];
// speculation is on array bounds check
//  if ii < 0: throw "Array OOB"
var ii = 64 * (xs[-10000] & 255); 
ys[ii]++;

var t0 = time();
ys[0]++;
var t1 = time();
if (t1 - t0 > 20ns) {
  print "Value was 1
}
// repeat for ys[2], [3], ...
```

This means we can read all of the current application's memory, one bit at a
time. Each byte basically costs two memory loads, so all of memory can be
scanned in a few minutes.

This is a "side channel attack". You can't read the memory, but you can still
figure out the value.

### Processes, Virtual Memory, and Page Tables

Every time we start a program, it gets its own address space.

 - Draw picture of 32-bit machine virtual address space; leave half for kernel memory.
 - Draw 8 GB of physical memory.
 - Draw a second 4 GB virtual address space.
 - CPU register points to page table, mapping physical pages to virtual pages.
 - Each table entry has a "kernel" flag in it.
 - There's a "are we the kernel?" CPU register.
 - If we're not the kernel, we can't access kernel memory.
 - System calls set the flag and jump to kernel code in kernel memory.

### Indirect Jump Cache

```
    lw $t0, 0($s0)
    jr $t0 // Where does this go?
foo:
    ...
bar:
    ...
baz:
   ...
```

Modern processors try to predict these jumps / branches by caching the last branch target.

So there's a table with

 - Address of the branch instruction
 - Previous branch target

And the prediction for a branch is just the last value.

### Spectre Variant 2: Branch Target Injection

Modern Intel processors have only one indirect branch target cache. If two
processes happen to have indirect branches at the same virtual address, then the
second one to run will use the cached branch target for the first.

This potentially allows one process running on a machine to cause arbitrary code
in other processes to be speculatively executed, and when combined with Variant
1 can potentially be used to read arbitrary code in memory. This can even cause
a process on one virtual machine to influence processes running on another
virtual machine on the same host.

Fix in Linux: A "retpoline". On amd64 processors, "ret" pops a return address
from the stack and jumps to it in one step. And there's a separate cache for
returns from the cache for indirect jumps. So rather than doing an indirect
jump, they do a stack push and return. The return address cache doesn't have the
problem.

### Meltdown: Rogue Data Cache Load

Intel CPUs don't check the kernel flag first in speculative execution. Instead,
they check after.

This means that the cache trick above can access data in *kernel* memory. This
includes I/O buffers - so you can get all kinds of good stuff.

Solution: KPTI. Don't put kernel memory in the top half of the address space for every
process, instead have a separate page table for the kernel.

### Summary

 - Meltdown and Spectre II are largely Intel-only.
 - Meltdown can be fixed with a kernel patch which causes a large-ish performance hit.
 - Spectre II might be fixable with a microcode patch to the CPU, but if not requires
   recompiling every program with a patched compiler and will cause a measurable 
   performance hit especially for interpreted programming languages.
 - Spectre I applies to *every* modern CPU.
 - Spectre I requires recompiling every binary with a patched compiler, but shouldn't
   produce a large performance hit.

## ASM to C

**show test program 1**

(reverse an array of strings)

**translate it to ASM**

