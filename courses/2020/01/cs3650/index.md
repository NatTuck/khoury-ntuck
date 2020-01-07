---
layout: default
---

# CS 3650 - Computer Systems

Spring 2020

Introduces the basic design of computing systems, computer operating systems,
and assembly language using a RISC architecture. Describes caches and virtual
memory. Covers the interface between assembly language and high-level
languages, including call frames and pointers. Covers the use of system calls
and systems programming to show the interaction with the operating system.
Covers the basic structures of an operating system, including application
interfaces, processes, threads, synchronization, interprocess communication,
deadlock, memory management, file systems, and input/output control.

## Essential Resources

 - [Inkfish](https://inkfish.ccs.neu.edu) - View and submit homework assignments.
 - [Piazza](piazza.com/northeastern/spring2020/cs365002) - Class discussion & announcements.
 - [Linux / Unix Help](http://www.ccs.neu.edu/course/cs3650/parent/help/)
 - [scratch](https://github.com/NatTuck/scratch-2020-01) - A git repo of stuff
   that may have happened in lecture.
 - [Nat's Notes](./notes) - Probably confusing, but includes most code shown in
   class.

## AMD64 ASM resources

 - [x86-64 SysV API](https://github.com/hjl-tools/x86-psABI/wiki/X86-psABI)
 - [AMD Programmer's Manual, Volume 3](https://support.amd.com/TechDocs/24594.pdf)
 - [AMD64 Linux
   Syscalls](https://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/)
   
## Sections

{: .table .table-striped }
| Section | Location | Time                |
|---------|----------|---------------------|
|      02 | SH 105   | 1:35pm-3:15pm Tu/Fr |
|      03 | INV 019  | 3:25pm-5:05pm Tu/Fr |

[Prof Alden Jackson](https://course.ccs.neu.edu/cs3650sp20/) is also offering a
section of the course. His section will vary somewhat in assignments and topics.

## Staff & Office Hours

{: .table .table-striped }
| Name            | Location | Hours                    | Email                           |
|-----------------|----------|--------------------------|---------------------------------|
| Nat Tuck        | NI 132 E | We 1:30-2:30pm; Fr 5:30-6:30pm | ntuck ⚓ ccs.neu.edu             |
|-----------------|----------|--------------------------|---------------------------------|
| Kaylin Devchand | HS 118   | Mo 6-8pm                 | devchand.k ⚓ husky.neu.edu |
| Alec Ge         | RY 153   | Su 10am-noon             | ge.a ⚓ husky.neu.edu |
| Sneh Gurdasani  | SL 009*  | Mo 11am-1pm              | gurdasani.s ⚓ husky.neu.edu |
| Madhur Jain**   | RY 154*  | Sa 10am-noon             | jain.madh ⚓ husky.neu.edu |

 * (*) Rooms not confirmed as of January 6th.
 * (**) Madhur Jain's office hours don't start until January 18.
 * Office hours run from January 6 to April 14.
 * Cancellations and changes may be posted to Piazza.

## Schedule

This is an initial schedule, subject to revision as the semester progresses.

Assignments will frequently be due at 11:59pm on Tuesday.

{: .table .table-striped }
|Week| Starts   | Topics                                                 | Work Due                         |
|----| -------- | --------                                               | ---------+                       |
|  1 | Jan 6    | Intro: Systems; Intro: Assembly                        | -                                |
|  2 | Jan 13   | ASM: "Design Recipe"; Large ASM Example;               | HW01: Linux Setup & Hello Worlds |
|  3 | Jan 20   | ASM: Syscalls, I/O, the heap; Processes & Memory       | HW02: ASM, Pointers, Funs        |
|  4 | Jan 27   | C: Arrays & Pointers; C: Data Structures;              | HW03: ASM Sort                   |
|  5 | Feb 3    | A Simple Tokenizer; Syscalls: fork, exec, waitpid;     | HW04: C Data Structures          |
|  6 | Feb 10   | Building a Shell & pipe; read, write, proc table, vmem;| HW05: Shell Tokenizer            |
|  7 | Feb 17   | shared mem & data races; semaphore locks & deadlock;   | CH1: Unix Shell                  |
|  8 | Feb 24   | threads and mutexes; cond vars and atomics             | HW06: Parallel Sort (Processes)  |
|  - | Mar 2    | Spring Break                                           | -                                |
|  9 | Mar 9    | malloc: free lists;  malloc: optimizations & threads;  | HW07: Parallel Sort (Threads)    |
| 10 | Mar 16   | Garbage Collection; OS Kernels                         | HW08: Simple Memory Allocator  |
| 11 | Mar 23   | Looking at xv6; Disk Hardware                          | CH2: Advanced Memory Allocator   |
| 12 | Mar 30   | File Systems: FAT; File Systems: ext                   | HW09: Examining xv6              |
| 13 | Apr 6    | The FUSE API;  Concurrency solutions                   | HW10: Simple FS                  |
| 14 | Apr 13   | Wrap Up; Last class Tuesday                            | CH3: Advanced FS                 |

## Textbook

The textbook for this course is online:

 - [Operating Systems, Three Easy Pieces](http://ostep.org)

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
at any point you have three unexcused zero grades for assignments that have been
graded you will fail the course.

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

Homework and project grades will be posted on Inkfish. If you think your work
was graded incorrectly, you can challenge your grade through the following
process:

First, go to the office hours of the course staff member who graded your work.
If you can convince them that they made a concrete error in grading, they will
fix it for you.

If the grader doesn't agree that the grade was wrong, you can formally contest
your grade with the professor. This follows a variant of the "coaches challenge"
procedure used in the NFL.

Here's the formal challenge procedure: 

 - You start with two tokens.
 - You can spend a token to contest your grade on any assignment.
 - If you have no tokens left, you can't formally contest grades.
 - When you contest a grade, the instructor will regrade your assignment from
   scratch.
 - The new grade is applied to your assignment.
 - If your new score is higher than the old score, you get your token back.
 - Scores must be contested within two weeks of the grade being posted to
   Inkfish, and no later than Wednesday of finals week.
 - Leftover tokens give you a small bonus to your final grade.

### Special Accomodations

Students needing disability accommodations should visit the [Disability Resource
Center](http://www.northeastern.edu/drc/about-the-drc/) (DRC).

If you have been granted special accomodations either through the DRC or as a
student athlete, let me know as soon as possible.

### Code Copying &amp; Collabaration Policy

Copying code and submitting it without proper attribution is strictly prohibited
in this class. This is plagiarism, which is a serious violation of academic
integrity.

Providing solution code to other students is also strictly prohibited.

**Details**

 - For solo assignments, you should personally write your code either from
   scratch or using only the starter code provided in the assignment.
 - For team assignments, your team should do the same.

**Lecture Notes**

Lecture notes are *not* starter code, and should not be copied without
attribution. As long as attribution is provided, there is no penalty for using
code from the lecture notes.

**Collaboration and Attribution**

Since it's not plagiarism if you provide attribution, as a special exception
to these rules, any code sharing with attribution will not be treated as a
major offense.

There is no penalty for copying small snippets of code (a couple of lines) with
attribution as long as this code doesn't significantly impact the intended
challenge of the assignment. This should be in a comment above these lines
clearly indicating the source (including author name and URL, if any).

If you copy a large amount of code with attribution, you won't recieve credit
for having completed that portion of the assignment, but there will be no further
penalty. The attribution must be obvious and clearly indicate both which code it
applies to and where it came from.

**Posting Code on the Web**

 * You may not post solutions to Homework assignments on the public internet.
   This will be treated as "Providing Solution Code".
 * Solutions to Challenge assignments in this class can be interesting enough
   that there's a benefit to posting them publicly (e.g. on Github). You *may*
   post solutions to the Challenge assignments on the public internet after
   your solution has been graded.
 * Some Challenge assignments are also solutions to earlier Homework
   assignments. Posting solutions to those challenges is OK as long as your code
   implements a significant portion of the challenge functionality.

**Penalty for Plagarism or Providing Solution Code**

First offense:

 - You get an F in the course.
 - You will be reported to OSCCR and CCIS.

Avoid copying code if you can. If you're looking at an example, understand what
it does, type something similar that is appropriate to your program, and provide
attribution. If you must copy code, put in the attribution immediately, every
time or you will fail the course over what feels like a minor mistake.

