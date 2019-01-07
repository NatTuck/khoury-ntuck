---
layout: default
---

# CS 3650 - Computer Systems

Spring 2019

Introduces the basic design of computing systems, computer operating systems,
and assembly language using a RISC architecture. Describes caches and virtual
memory. Covers the interface between assembly language and high-level
languages, including call frames and pointers. Covers the use of system calls
and systems programming to show the interaction with the operating system.
Covers the basic structures of an operating system, including application
interfaces, processes, threads, synchronization, interprocess communication,
deadlock, memory management, file systems, and input/output control.

## Essential Resources

 - [Bottlenose](https://bottlenose.ccs.neu.edu) - View and submit homework assignments.
 - [Piazza](https://piazza.com/northeastern/spring2019/cs3650) - Class discussion & announcements.
 - [Undergrad Tutoring](http://www.ccis.northeastern.edu/current-students/undergraduate/resources/)
 - [Linux / Unix Help](http://www.ccs.neu.edu/course/cs3650/parent/help/)
 - [Nat's Notes](./notes) - Probably confusing, but includes most code shown in class.

## AMD64 ASM resources
 
 - [AMD64 Assembly Notes](./amd64_asm.html) - ASM vocab
 - [Assembly Recipie](./asm_recipe.html) - ASM programming strategy
 - [x86-64 SysV API](https://github.com/hjl-tools/x86-psABI/wiki/X86-psABI)
 - [AMD Programmer's Manual, Volume 3](https://support.amd.com/TechDocs/24594.pdf)
 - [AMD64 Linux Syscalls](https://filippo.io/linux-syscall-table/)

## Sections

{: .table .table-striped }
| Section | Location | Time                |
|---------|----------|---------------------|
|      01 | BK 310   | 1:35pm-3:15pm Tu/Fr |
|      02 | BK 310   | 3:25pm-5:05pm Tu/Fr |

## Staff & Office Hours

{: .table .table-striped }
| Name           | Location | Hours                    | Email                           |
|----------------|----------|--------------------------|---------------------------------|
| Nat Tuck       | NI 132 E | Tu 5:30-6:30pm; Th 2-3pm | ntuck ⚓ ccs.neu.edu            |
|----------------|----------|--------------------------|---------------------------------|
| Ankita Ankita  | SH 415   | Mo 6-8pm                 | ankita.a ⚓ husky.neu.edu       |
| Julian Hirn    | RY 285   | We 3:05-3:50pm; Th 3-4pm | hirn.j ⚓ husky.neu.edu         |
| Indranil Jana  | SH 415   | Mo 5:30-8:30pm           | jana.i ⚓ husky.neu.edu         |
| Samarth Parikh | WVF 114  | Fr 12:05-2:05pm          | parikh.sam ⚓ husky.neu.edu	 |
| Charmik Sheth  | INV 014  | We 3:40-5:50pm (+)       | sheth.c ⚓ husky.neu.edu        |
| Ian Smith      | RI 168   | Mo 12-2pm                | smith.ian ⚓ husky.neu.edu	  |
| Brian Vullo    | KA 102   | Fr 6-8pm                 | vullo.b ⚓ husky.neu.edu        |

 * Office hours start January 10th. (+) Charmik's office hours start Jan 23.
 * Office hours end April 17th.
 * Single instance changes may be posted to Piazza.

## Schedule

This is an initial schedule, subject to revision as the semester progresses.

Assignments will frequently be due at 11:59pm on Monday.

{: .table .table-striped }
|   Week | Starts   | Topics                                                 | Work Due                                    |
| +----- | -------- | --------                                               | ---------+                                  |
|      1 | Jan 7    | Intro: Systems; C and ASM                              | -                                           |
|      2 | Jan 14   | AMD64 Assembly;  ASM: "Design Recipe"                  | HW01: Linux Setup & Hello Worlds            |
|      3 | Jan 21   | Large ASM Example; Debugging ASM;                      | HW02: ASM, Pointers, Fun                    |
|      4 | Jan 28   | Processes & Memory; ASM: Syscalls, I/O, the heap       | HW03: Extra ASM                             |
|      5 | Feb 4    | C: Basics, Arrays, Pointers; A Simple Tokenizer        | HW04: ASM: Merge Sort w/ Dynamic Allocation |
|      6 | Feb 11   | Syscalls: fork, exec, waitpid; Building a Shell & pipe | HW05: Shell Tokenizer                       |
|      7 | Feb 18   | read, write, proc table, vmem; shared mem & data races | CH1: Unix Shell                             |
|      8 | Feb 25   | semaphore locks & deadlock; threads and mutexes        | HW06: Parallel Sort (Processes)             |
|      - | Mar 4    | spring break                                           | -                                           |
|      9 | Mar 11   | cond vars and atomics; malloc: free lists              | HW07: Parallel Sort (Threads)               |
|     10 | Mar 18   | malloc: optimizations & threads; modern allocators     | HW08: Simple Memory Allocator               |
|     11 | Mar 25   | OS Kernels; Looking at xv6                             | CH2: Advanced Memory Allocator              |
|     12 | Apr 1    | File Systems: FAT; File Systems: ext                   | HW09: Examining xv6                         |
|     13 | Apr 7    | The FUSE API; Solutions for Concurrency                | HW10: Simple FS                             |
|     14 | Apr 14   | Wrap Up                                                | CH3: Advanced FS                            |

(+) One Lecture Weeks: Start, Thanksgiving, End

Recommended Readings by Week:

 1. [Linux Command Line Tutorial](http://linuxcommand.org/)
 2. OSTEP 4
 3. OSTEP 13
 4. OSTEP 13
 5. OSTEP 14
 6. OSTEP 5
 7. OSTEP 15, 16, 18, 31
 8. OSTEP 26, 27
 9. OSTEP 28, 30
10. OSTEP 17
11. OSTEP 37, 44
12. OSTEP 39, 40, 41
13. OSTEP 43
14. OSTEP 46, 32, 33

## Textbook

The textbook for this course is online:

 - [Operating Systems, Three Easy Pieces](http://ostep.org)

We will also be referring to:

 - [The Xv6 Unix Source code](https://pdos.csail.mit.edu/6.828/2017/xv6.html)

## Grading

 * Homework:   70% (about 7% each)
 * Challenges: 27% (about 9% each)
 * Misc:        3% (participation, grade challenges, rounding errors, etc)
 
Percentages are approximate.

### Letter Grades

The number to letter mapping will be as follows:

95+ = A, 90+ = A-, 85+ = B+, 80+ = B, 75+ = B-, 70+ = C+, 65+ = C, 60+ = C-, 
50+ = D, else = F

There may be a curve or scale applied to any assignment or the final grades, in
either direction.

### Homework and Challenges

There's a homework or challenge assignment due nearly every week. Assignments in
this class is difficult and you are *expected* to get stuck. Start early so you
have time to get unstuck.

Challenges are just like homework, except they're harder, worth more points, and
they are graded more harshly. You'll want to start early and plan to spend a
*lot* of time on them.

In order to learn the material in this class you must submit the assignments. If
at any point you have three unexcused zero grades for past-due assignments you
will fail the course.

If you fall behind on the course work for any reason, please come to the
professor's office hours to discuss how you can catch up.

### Late Work

For all assignments except the last challenge, late submissions will be
penalized by 1% for each hour late.

For the final assignment, late submissions will not be accepted after the sun
comes up and the TAs start grading.

**Late Registration**

If you register for the course late, you will have three days to complete each
assignment until you are caught up with the rest of the class.

## Policies

### Contesting Grades

Homework and project grades will be posted on Bottlenose. If you think your work
was graded incorrectly, you can challenge your grade through the following
procedure:

First, go to the office hours of the course staff member who graded your work.
If you can convince them that they made a concrete error in grading, they will
fix it for you.

If the grader doesn't agree that the grade was wrong, you can issue a formal
grade challenge. This follows a variant of the "coaches challenge" procedure
used in the NFL. 

Here's the procedure: 

 - You start with two contest tokens.
 - You can spend a token to contest your grade on any assignment.
 - If you have no tokens left, you can't formally contest grades.
 - When you contest a grade, the instructor will regrade your assignment from
   scratch.
 - The new grade is applied to your assignment.
 - If your new score is higher than the old score, you get your token back.
 - Scores must be contested within two weeks of the grade being posted to
   Bottlenose, and no later than Tuesday of finals week.
 - Leftover contest tokens give you a small bonus to your final grade.

### Special Accomodations

Students needing disability accommodations should visit the [Disability Resource
Center](http://www.northeastern.edu/drc/about-the-drc/) (DRC).

If you have been granted special accomodations either through the DRC or as a
student athlete, let me know as soon as possible.

### Code Copying &amp; Collabaration Policy

Copying code and submitting it without proper attribution is strictly prohibited
in this class. This is plagiarism, which is a serious violation of academic
integrity.

**Details:**

 - For solo assignments, you should personally write your code either from
   scratch or using only the starter code provided in the assignment.
 - For team assignments, your team should do the same.

**Lecture Notes**

Lecture notes are *not* starter code, and should not be copied without
attribution. As long as attribution is provided, there is no penalty for using
code from the lecture notes.

**Collaboration and Attribution:**

Since it's not plagiarism if you provide attribution, as a special exception
to these rules, any code sharing with attribution will not be treated as a
major offense.

There is no penalty for copying small snippets of code (a couple of lines) with
attribution as long as this code doesn't significantly remove the intended
challenge of the assignment. This should be in a comment above these lines
clearly indicating the source (including author name and URL, if any).

If you copy a large amount of code with attribution, you won't recieve credit
for having completed that portion of the assignment, but there will be no further
penalty. The attribution must be obvious and clearly indicate both which code it
applies to and where it came from.

**Penalty for Plagarism**

First offense:

 - You get an F in the course.
 - You will be reported to OSCCR and CCIS.

Avoid copying code if you can. If you're looking at an example, understand what
it does, type something similar that is appropriate to your program, and provide
attribution. If you must copy code, put in the attribution immediately, every
time or you will fail the course over what feels like a minor mistake.

