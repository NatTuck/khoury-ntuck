---
layout: default
---

# CS 3650 - Computer Systems

Fall 2018

Introduces the basic design of computing systems, computer operating systems,
and assembly language using a RISC architecture. Describes caches and virtual
memory. Covers the interface between assembly language and high-level
languages, including call frames and pointers. Covers the use of system calls
and systems programming to show the interaction with the operating system.
Covers the basic structures of an operating system, including application
interfaces, processes, threads, synchronization, interprocess communication,
deadlock, memory management, file systems, and input/output control.

## Interesting Stuff

 - [Spectre & Meltdown](https://ds9a.nl/articles/posts/spectre-meltdown/)
 - [Spectre 1.1 and 1.2](https://www.bleepingcomputer.com/news/security/new-spectre-11-and-spectre-12-cpu-flaws-disclosed/)

## Essential Resources

 - [Bottlenose](https://bottlenose.ccs.neu.edu) - View and submit homework assignments.
 - [Piazza](https://piazza.com/northeastern/fall2018/cs365003) - Class discussion & announcements.
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
|      03 | BK  310  | 1:35pm-3:15pm Tu/Fr |

Note: Profs. Michael Shah and Alden Jackson are running other sections of the
course, which may be structured slightly differently: See their course pages
for details:

 * [Prof Shah's sections](http://www.mshah.io/comp/Fall18/Systems/index.html)
 * [Prof Jackson's section](http://www.ccs.neu.edu/home/awjacks/cs3650f18/)

## Staff & Office Hours

{: .table .table-striped }
| Name                  | Location     | Hours                      | Email                              |   |
|-----------------------|--------------|----------------------------|------------------------------------|---|
| Nat Tuck              | NI 132 E     | We 3-4pm; Fr noon-1pm      | ntuck ⚓ ccs.neu.edu               |   |
|-----------------------|--------------|----------------------------|------------------------------------|---|
| Charmik Sheth(+)      | WVH 102 (++) | We 10am-2pm                | sheth.c ⚓ husky.neu.edu           |   |
| Shraddha S. Mhatre(+) | WVH 102 (++) | Mo 10:30am-12:30; Mo 2-4pm | mhatre.shr ⚓ husky.neu.edu        |   |
|-----------------------|--------------|----------------------------|------------------------------------|---|
| Durwasa Chakraborty   | (+++)        | (+++)                      | chakraborty.d ⚓ husky.neu.edu     | ) |
| James Elliott         | (+++)        | (+++)                      | elliott.jame ⚓ husky.neu.edu      |   |
| Akash Parikh          | (+++)        | (+++)                      | parikh.ak ⚓ husky.neu.edu         |   |
| Savan Patel           | (+++)        | (+++)                      | patel.sav ⚓ husky.neu.edu         |   |
| A. Trihatmaja         | (+++)        | (+++)                      | trihatmaja.a ⚓ husky.neu.edu      |   |
| Nakul Ramesh          | (+++)        | (+++)                      | vankadariramesh.n ⚓ husky.neu.edu |   |

(+) Will be grading for this section.

(++) Single instance location changes may be posted to Piazza.

(+++) See the course page for the other sections for these office hours. Tell
the TA you're in Tuck's section and show them your assignment for minimum
confusion.

## Schedule

This is an initial schedule, subject to revision as the semester progresses.

Assignments will frequently be due at 11:59pm on Wednesday.

{: .table .table-striped }
|   Week | Starts   | Topics                                                 | Work Due                                    |
| +----- | -------- | --------                                               | ---------+                                  |
|     1+ | Sep 3    | Intro: Systems, C, and ASM                             | -                                           |
|      2 | Sep 10   | AMD64 Assembly; ASM: "Design Recipe"                   | HW01: Linux Setup & Hello Worlds            |
|      3 | Sep 17   | Processes & Memory; ASM: Syscalls, I/O, the heap       | HW02: ASM Calculator, Fib                   |
|      4 | Sep 24   | C: Basics, Arrays, Pointers; A Simple Tokenizer        | HW03: ASM: Merge Sort w/ Dynamic Allocation |
|      5 | Oct 1    | Syscalls: fork, exec, waitpid; Building a Shell & pipe | HW04: Shell Tokenizer                       |
|      6 | Oct 8    | read, write, proc table, vmem; shared mem & data races | CH1: Unix Shell                             |
|      7 | Oct 15   | semaphore locks & deadlock; threads and mutexes        | HW05: Parallel Sort (Processes)             |
|      8 | Oct 22   | cond vars and atomics; malloc: free lists              | HW06: Parallel Sort (Threads)               |
|      9 | Oct 29   | malloc: optimizations & threads; modern allocators     | HW07: Simple Memory Allocator               |
|     10 | Nov 5    | OS Kernels; Looking at xv6                             | CH2: Advanced Memory Allocator              |
|     11 | Nov 12   | File Systems: FAT; File Systems: ext                   | HW08: Examining xv6                         |
|    12+ | Nov 19   | The FUSE API                                           | HW09: Simple FS                             |
|     13 | Nov 26   | Modern File Systems; Solutions for Concurrency         | -                                           |
|    14+ | Dec 3    | Wrap-Up + A Transactional Filesystem                   | CH3: Advanced FS                            |

(+) One Lecture Weeks: Start, Thanksgiving, End

Recommended Readings by Week:

 1. CS:APP 1
 2. CS:APP 3.1 - 3.7; OSTEP 4 
 3. CS:APP 9.1, 9.2; OSTEP 13
 4. CS:APP 3.8; OSTEP 14
 5. OSTEP 5
 6. OSTEP 15, 16, 18, 31
 7. CS:APP 12; OSTEP 26, 27
 8. OSTEP 28, 30
 9. CS:APP 9; OSTEP 17
10. OSTEP 37, 44
11. OSTEP 39, 40, 41
12. OSTEP 43
13. OSTEP 46, 32, 33
14. OSTEP 11, 24, 34, 51

## Textbook

There is no required textbook for this course.

Recommended reading:

    Computer Systems: A Programmer's Perspective
    Randal E. Bryant and David R. O'Hallaron
    Third Edition

[Book Website](http://csapp.cs.cmu.edu/3e/students.html)
  
We'll also be using these online resources:

 - [Operating Systems, Three Easy Pieces](http://ostep.org)
 - [The Xv6 Unix Source code](https://pdos.csail.mit.edu/6.828/2017/xv6.html)

## Grading

 * Homework:   63% (about 7% each)
 * Challenges: 36% (about 12% each)
 
Percentages are approximate.

### Letter Grades

The number to letter mapping will be as follows:

95+ = A, 90+ = A-, 85+ = B+, 80+ = B, 75+ = B-, 70+ = C+, 65+ = C, 60+ = C-, 50+ = D, else = F

There may be a curve or scale applied to any assignment or the final grades, in either direction.

### Homework

There's a homework assignment due nearly every week.

The homework portion of your grade will include some "virtual" assignments which
you'll get a grade for but don't require assignment submissions:

 - Participation - For example, Piazza posts and good Piazza answers.
 - Grade Challenges - See the grade challenge policy below.

### Challenges

Challenges are just like homework, except they're harder, worth more points, and
they are graded more harshly. You'll want to start early and plan to spend a
*lot* of time on them.

### Late Work

For all assignments except the last challenge, late submissions will be
penalized by 1% for each hour late.

For the final assignment, late submissions will not be accepted.

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

 - There's a virtual "contested grades" homework worth 1% of your final grade. 
 - When you issue a challenge, you lose 50% of your score on that assignemnt.
 - If you have no points left, you can't issue a challenge.
 - When a challenge is issued, the instructor will regrade your assignment from
   scratch.
 - If your new score is higher than the old score, you get your points back.
 - Challenges must be issued within two weeks of the grade being posted to
   Bottlenose, and no later than Tuesday of finals week.

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

