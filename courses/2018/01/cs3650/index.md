---
layout: default
---

# CS 3650 - Computer Systems

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

## Essential Resources

 - [Bottlenose](https://bottlenose.ccs.neu.edu) - View and submit homework assignments.
 - [Piazza](https://piazza.com/northeastern/spring2018/cs3650) - Class discussion & announcements.
 - [Undergrad Tutoring](http://www.ccis.northeastern.edu/current-students/undergraduate/resources/)
 - [MIPS Reference Card](https://inst.eecs.berkeley.edu/~cs61c/resources/MIPS_help.html)
 - [MARS Simulator JAR](./Mars4_5.jar)
 - [MARS System Calls](http://courses.missouristate.edu/KenVollmar/MARS/Help/SyscallHelp.html)
 - [Linux / Unix Help](http://www.ccs.neu.edu/course/cs3650/parent/help/)
 - [Nat's Notes](./notes) - Probably confusing, but includes most code shown in class.

## Sections

{: .table .table-striped }
 Section | Location | Time
+--------|----------|--------+
02 | BK  310 | 1:35pm-3:15pm Tu/Fr

Note: Prof. Gene Cooperman is running Section 01, which is structured differently. 
See his course page here: [https://course.ccs.neu.edu/cs3650/](https://course.ccs.neu.edu/cs3650/)

## Staff & Office Hours

{: .table .table-striped }
 Name | Location | Hours | Email
+-----|----------|-------|------+
Nat Tuck | NI 132 E | 2pm-3pm Mo/Th | ntuck ⚓ ccs.neu.edu
+-----|----------|-------|------+
Anirudh Katipally | WVH 462 | 3-4pm Mo | katipally.a ⚓ husky.neu.edu
Jack Elliott | WVH 462 | 11-noon Fr | elliott.jame ⚓ husky.neu.edu
+-----|----------|-------|------+
Savan Patel | WVH 462 | 10-11am We | patel.sav ⚓ husky.neu.edu
Nakul Camasamudram | none | none | camasamudram.n ⚓ husky.neu.edu
Rashmi Dwaraka | none | none | dwarakarashmi ⚓ ccs.neu.edu
Akshay Tandel | BK 210 | 3-4pm Th | akshaytandel09 ⚓ ccs.neu.edu


## Schedule

This is an initial schedule, subject to revision as the semester progresses.

Assignments will frequently be due at 11:59pm on Wednesday.

{: .table .table-striped }
 Week | Starts | Topics | Work Due
+-----|--------|--------|---------+
 1 | Jan 8  | Intro; ASM: Basics | -
 2 | Jan 15 | ASM: "Design Recipe"; Processes & Memory | HW01: Linux Setup & ASM Basics
 3 | Jan 22 | ASM: Syscalls, I/O, Memory Allocation; C: Basics | HW02: More ASM
 4 | Jan 29 | A Simple Tokenizer; C: The Heap & Simple Parser | HW03: Shell Command Tokens
 5 | Feb 5  | Syscalls: fork, exec, waitpid; Building a Shell & pipe | HW04: s-exp shell parser
 6 | Feb 12 | read, write, process table, vmem; shared mem & semaphore locks | CH1: s-exp shell
 7 | Feb 19 | data races & deadlock; threads and mutexes | HW05: inter-process comms
 8 | Feb 26 | cond vars and atomics; malloc: free lists | HW06: inter-thread comms
 - | Mar 5  | Spring Break | - | -
 9 | Mar 12 | malloc: optimizations & threads; OS Kernels | HW07: memory allocator
10 | Mar 19 | Looking at xv6; Storage Hardware | HW08: examining xv6
11 | Mar 26 | File Systems: FAT; File Systems: ext | HW09: bonus topic
12 | Apr 2  | The FUSE API; Modern File Systems | HW10: simple FS
13 | Apr 9  | Transactional FS; Solutions for Concurrency | -
14 | Apr 16 | Wrap-Up | CH2: Transactional FS

Recommended Readings by Week:

 1. P&H Ch 1, 2, Appendix A6, A9, A10, Green Card
 2. OSTEP ch 4, 13; P&H ch 2
 3. P&H 2.14
 4. OSTEP ch 14
 5. OSTEP ch 5
 6. OSTEP 15, 16, 18, 31; P&H 5.6, 5.7
 7. OSTEP 26, 27
 8. OSTEP 28, 30
 9. P&H ch 5.1 - 6.4
10. OSTEP 37, 44
11. OSTEP 39, 40, 41
12. OSTEP 43
13. OSTEP 46, 32, 33
14. OSTEP 11, 24, 34, 51

## Textbook

There is no required textbook for this course.

Recommended reading:

    Computer Organization and Design: The Hardware/Software Interface
    Patterson & Hennessy
    Fifth Edition

We'll also be using these online resources:

 - [Operating Systems, Three Easy Pieces](http://ostep.org)
 - [The Xv6 Unix Source code](https://pdos.csail.mit.edu/6.828/2017/xv6.html)

## Grading

 * Homework: 70%
 * Challenge 1: 15%
 * Challenge 2: 15%
 
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

### Grade Challenges

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

 - There's a virtual "challenges" homework worth 1% of your final grade. 
 - When you issue a challenge, you lose 50% of your score on that assignemnt.
 - If you have no points left, you can't issue a challenge.
 - When a challenge is issued, the instructor will regrade your assignment from
   scratch.
 - If your new score is higher than the old score, you get your points back.
 - Challenges must be issued within two weeks of the grade being posted to
   Bottlenose, and before finals week starts.

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

