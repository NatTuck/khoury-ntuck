---
layout: default
---

# Computer Systems

## Homework

 - HW08 Questions?
 
## Online Teaching

Apparently we're moving online starting tomorrow.

Full details will be posted to piazza, but the general idea
is:

 - Lectures will be videos and/or livestreams.
 - Office hours and some lecture discussion will occur - at
   least initially - using Microsoft Teams.

## Updated Schedule

 - After this week, there are five weeks left in the semester.
 - The updated schedule is posted on the course site.
 - After HW09, there are three more assignments. Currently the planned
   assignments are:
   - Rewrite the parallel sort program from HW06 in Rust.
   - Redo some previous assignment. This will give you the opportunity to
     resubmit an assignment of your choice to be regraded. To get full credit on
     HW09, you'll need to enhance your resubmission in a significant way beyond
     the origional requirements.
   - The final topic and two-week assignment will be building a file system with
     libfuse.
 - The last lecture will be April 15th.
 - The last assignment will be due April 16th.

## Walkthrough of HW09 starter code.

Tests:

 - test1: Init the GC, allocate memory, don't crash.
 - test2: Init the GC, allocate memory, run a collection, print stats.
 - test3: Some linked list ops; incomplete collection.
 - test4: Mixed workload.
 - test5: Calculates fibonacci numbers using string-based arbitary precision
   integers. Needs to allocate more than the 1MB stack total to finish.
   - Walk through the logic here and why it allocates a lot.
 - test6: Just allocate a bunch of fixed size objects to stress the gc.

The allocator / collector design:

 - We allocate memory from a fixed 1MB heap.
 - Within that heap, we work with 16 byte units.
 - That means we have 65536 availble 16 byte units.
   - Both size and location of an allocation can be tracked with a 16-bit (2
     byte) integer.
   - We reserve the 0th allocation unit unused so that we can use a location
     of zero as a null value.
 - Every block of memory, allocated or not, is tracked using the "cell"
   structure. There's no distinction between a free list cell and an allocated
   memory header.
 - The cell structure takes 8 bytes total and has 5 fields:
   - size - size of block in 16 byte units
   - next - offset to next block in list
   - used - a boolean indicating whether this block is allocated or free
   - mark - this is where we mark in the mark phase of gc
   - conf - should always store the value (size * 7) % (2^16); this can help
     detect bugs and memory corruption

Global data:

 - Each cell is always on one of two lists:
   - free\_list - A normal free list, tracking free memory blocks. Blocks should
     be ordered by memory address for fast coalescing.
   - used\_list - A list of all allocated memory blocks. Used in the sweep phase
     of gc to traverse all allocated objects.
 - We store the bottom of the 1MB heap for two important reasons:
   - It lets us translate 16-bit heap offsets to and from pointer values.
   - It allows us to look at a candidate pointer and see if it points to a
     location on the heap.
 - We store the top of the stack. Our stack is our GC root, so we need to scan
   it for pointers during GC.
 - We track some stats as globals.

Functions:
 
 - o2p / pto translate between 16-bit heap offsets in 16-byte units and 64-bit
   memory addresses.
 - print\_cell and gc\_print\_info are for debugging.
 - list\_length, list\_total, and gc\_print\_stats are to print stats for the
   tests
 - insert\_free should insert an item into the free list in sorted order and
   perform coalescing as needed; the provided signature makes sense if the
   function is implemented recursively
 - insert\_used inserts an item onto the head of the used list
 - gc\_init takes a pointer to a local variable on the stack of the main
   function - it should be called using the GC_INIT macro. It saves the stack
   top, allocates the 1MB heap, and sets up the initial free list.
 - gc\_malloc1 should do an allocation as usual for a free list allocator,
   making sure to put the newly allocated block on the used list
 - gc\_malloc tries to allocate, runs a GC colletion if that fails, and then
   tries once more
 - mark\_range should take the top and bottom of a memory region and scans that
   region for pointers to the heap. If it finds any pointers it:
    - Assumes they point to an allocated block 
    - Sets the associated "mark" field for that chunk.
    - Recursively calls itself on the data portion of that block to find
      pointers to nested parts of the data structure.
 - mark starts mark\_range on the stack
 - sweep scans the used\_list for unmarked objects and frees them
 - gc\_collect does mark and then sweep

# Garbage Collection in Various Languages

## Perl

Perl uses simple reference counting to manage memory. 

 - Each object has a refs field
 - refs = 1 on allocation
 - A new reference to an object increments the ref count
 - When a reference becomes invalid, the ref count is decremented
 - When refs = 0, the object is freed

This works nicely... except that reference cycles will leak memory if not
manually broken before the references are invalidated.

Perl supports threads, but doesn't share variables between threads by default.
You can explicitly mark a variable as shared, in which case the refcount for the
associated object is modified using atomic instructions.

Using reference counts allows Perl to provide a feature that most garbage
collected languages can't provide: Deterministic destructors. When an object
(e.g. a file handle) goes out of scope, Perl can run any custom cleanup code
associated with that object immediately (e.g. close the file descriptor).

In contrast, languages like Java with mark-and-sweep GC don't have reliable
"destructors" for objects. Instead, they have "finalizers", which generally
won't run immediately when the object goes out of scope and aren't technically
guaranteed to run ever.

## Python

Python (the standard implementation) uses reference counting as the default
mechanism to manage shared memory.

In order to avoid memory leaks in case of circular references, Python includes a
mechanism called the cycle collector, which is a simple mark and sweep garbage
collector that supplements the reference counter.

Python doesn't support parallel execution of threads. It has a single lock, the
"global interpreter lock", which prevents data races by only letting one thread
run Python code at once.

## Ruby

Ruby uses a simple mark-and-sweep garbage collector to manage memory. 

The old design was the obvious one. It worked kind of like the HW09 starter
code, with a mark field associated with each allocated object. This created a
pretty serious problem scaling when running Ruby on Rails web apps.

Here's the problem:

 - When a Rails app starts up, it runs a bunch of Ruby code to build up an in
   memory initial state for the app. This might be 100MB.
 - The Ruby webserver then forks several times to produce worker processes to
   handle incoming requests.
 - Fork should be super effcient - copy on write means that each process should
   only take a few KB of extra memory plus whatever actual changes there are.
 - But then the garage collector runs and sets the mark flag on every object.
   This is a write to every object, so now every process takes 100MB even if the
   application data is all still the same.

In order to make better use of copy on write, the Ruby allocator was changed to
store the mark flags in a seperate (bit) array from the actual objects. This means
that mark and sweep can run by copying one bit per object per process rather
than copying every object into every process.

Ruby could probably handle incoming concurrent web requests even more
efficiently with threads, but like Python it's got a GIL so it can only execute
one thread at a time.

## Java

As of 2018 (Java 7 / Java 8), according to a random blog post, the standard Java
VM had 4 user selectable garbage collectors:

 - Serial
 - Parallel
 - Concurrent Mark and Sweep
 - G1

*Serial* is what it says: To GC, all threads are stopped and one thread does
sequential garbage collection.

 - This can actually be the fastest for some applications, if they're heavily
   sequential and rely on a small working set that fits in L2 cache.
   
```
java -XX:+UseSerialGC -jar Application.java
```

*Parallel* stops the world and then uses multiple threads for garbage
collection.

 - This is the default GC.
 - This has excellent throughput at the cost of large GC pauses.

```
java -XX:+UseParallelGC -jar Application.java
```

*Concurrent Mark and Sweep* does garbage collection concurrently with
application threads.

 - This optimizes for minimum pause time at the cost of throughput.

```
java -XX:+UseParNewGC -jar Application.java
```

*G1GC*, or the Garbage First collector, does something moderately clever:

 - The heap is split up into a bunch of seperate regions, kind of like the
   multiple spaces in a copying collector.
 - The mark phase happens concurrently with other threads, and the collector
   tracks the total size of live objects in each region.
 - It then stops the world for the sweep phase, which operates by copying the
   live data out of the regions with the most garbage. This maximizes space
   reclaimed while minimizing pauses.

## Erlang GC

Erlang does a couple of really neat things with memory
management.

The language and it's programs have a couple of interesting
properties that matter here:

 - It's a functional language, so data can't be modified
   after it's created.
 - That lack of mutability means there's no way to
   distinguish between a reference to an object and a copy
   of an object.
 - Erlang programs are made up of many small "processes".
   These are lighter weight than threads, execute logically
   concurrently, and logically don't share memory.
 - Communication in Erlang is done by message passing, and
   logically messages are copied from the sending process to
   the recieving process.

Since memory for each process is separate, Erlang gives each
process its own garbage collected heap. This garbage
collector is a reasonably simple copying / generational
collector. There are three spaces: From, To, and Old.

Erlang does it's garbage collection sequentially within each
process. Concurrency and parallelism comes from having many
processes.

Garbage collection in Erlang is really fast and tends to
have small pauses. This is for two reasons:

 - Since each process has a separate stack, stacks tend to
   be small. This makes the GC process fast and means that
   GC in one process doesn't need to delay work in another
   process.
 - Some processes are very short lived. They may never need
   to garbage collect at all - instead the whole heap can be
   freed when the process terminates.

More memory management optimizations:

 - Copying large objects between heaps sounds expensive, so
   Erlang doesn't actually do it.
 - Large objects are allocated to a separate global heap,
   are shared between processes, and are tracked using
   refcounting.
 - That does require some extra work to decrement refcounts
   when dropping a whole heap, but they do that.

We'll talk a bit more about Erlang later. They built an
archetecture in the late 80's that happens to solve a lot of
today's problems 

## C/C++ - Boehm-Demers-Weiser collector

As we're exploring in HW09, you can write C and C++ with a
garbage collector.

The common library for this is called "libgc", and provides
a conservative, parallel, incremental collector for C++.

The idea of incremental collection is to only run the GC for
a little while until you have freed enough memory to keep
going with the hope of minimizing GC pauses.


# Overflow

http://ccs.neu.edu/home/ntuck/courses/2015/01/cs5600/slides/12_Auth_and_Access.pptx


## Links

 - Ruby and COW:
   https://medium.com/@rcdexta/whats-the-deal-with-ruby-gc-and-copy-on-write-f5eddef21485
 - Erlang GC:
   https://www.erlang-solutions.com/blog/erlang-garbage-collector.html
 - Java GCs: https://www.baeldung.com/jvm-garbage-collectors
