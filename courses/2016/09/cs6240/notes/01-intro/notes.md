---
layout: default
---

# Parallel Data Processing w/ Map Reduce

## Overview of Topics

 - Main topic: Processing Big Data in the Cloud
   - Hadoop Map-Reduce
   - Spark
 - Associated topics
   - Parallel Processing in General - e.g. Threads
   - Working with the Amazon Cloud - Amazon EMR

## Syllabus

 - Grading
   - Big Final Exam
   - Homework ; Bottlenose
   - Participation
     - Piazza
     - Random questions in class
     - In-Class Coding
   - Blackboard
     - It's NUOnline Blackboard
     - Learning modules are due the week *before* class.
     - Learning modules may be out of order. See the syllabus.

## Big Picture, Parallel Computing

How to bake a cake:
 - Put batter in cake pans.
 - Stick it in the oven for half an hour.
 - Pull out your cake.

How to bake 10 cakes:
 - Sequential:
   - Repeat the above process 10 times.
   - This takes 5 hours.

 - Parallel:
   - Get 10 ovens.
   - Do the above process using each oven at the same time.
   - This takes half an hour.

Can we bake one cake faster in parallel?

### The End of Sequential Speedups

Back in the bad old days - maybe the 1970’s - computing was a sequential sort
of thing. If you wanted to do 10 tasks, you’d do task 1, then task 2, then task
3, etc.

Parallel computing started to get popular in the 80’s, but until 2005 or so the
\#1 way to make a computation go faster was to use a computer that completed
tasks faster. That meant more operations per second. Operations per second is
hard to measure, so everyone measured the vaguely related clock cycles per
second, measured in MHz or GHz.

Around 2003, Intel released the Pentium 4. The first models ran at 1.8 GHz or
so, but the roadmap said 5 GHz in 2006.

The 5Ghz P4 never arrived. Reason: P = F^3; If a 1 GHz P4 was 100W, then a 5
GHz P4 would be 2.5 KW. Ignoring cooling, that won’t even run off a household
electrical outlet.

So if you double the speed by doubling the clock, it costs 2^3 = 8x power.
If you double the speed by adding another core, it costs 2x power.

So now we have multi-core processors. Today it’s not too hard to get a 32-core
workstation. My multi-core experiments box in my office is 24 cores.

Unfortunately, the programming community has spent the last 50 years figuring
out how to program sequential machines. Parallel machines require some new
tricks.

### Parallel Programming Techniques

 - Multiple processes - A modern OS can run two different programs on different cores at the same time.
 - Multiple threads -A single process can have multiple threads of execution, which run in parallel.
 - Clusters - Can’t fit enough processors in one computer? Get 30.
 - SPMD / Data Parallelism 
   - CPU Instructions
   - GPUs / Accelerators
   - As a programming style (clusters, threads, etc)

MPI vs. MapReduce

 - MPI - Low level message passing.
 - MapReduce - Clever idea from Google for big data processing

### Threading Example

We'll start with threads.

MillionSum example.

