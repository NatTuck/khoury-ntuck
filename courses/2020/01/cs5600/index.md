---
layout: default
---

# CS 5600 - Computer Systems

Spring 2020

The course catalog says:

Studies the structure, components, design, implementation, and internal
operation of computer systems, focusing mainly on the operating system level.
Covers current operating system components and construction techniques system
calls, I/O, memory management, and file system structures. Discusses issues
arising from concurrency and distribution, such as scheduling of concurrent
processes, interprocess communication and synchronization, resource sharing and
allocation, and deadlock management and resolution. Includes examples from real
operating systems. Exposes students to the system concepts through programming
exercises. Requires admission to MS program or completion of all transition
courses.

This course will explore operating system implementation through programming
assignments. This is a programming heavy course; students are expected to be
proficient at programming.

## Essential Resources

 - [Inkfish](https://inkfish.ccs.neu.edu) - View and submit homework assignments.
 - [Piazza](piazza.com/northeastern/spring2020/cs5600) - Class discussion & announcements.
 - [scratch](https://github.com/NatTuck/scratch-2020-01) - A git repo of stuff
   that may have happened in lecture.
 - [Nat's Notes](./notes) - Probably confusing, but includes most code shown in
   class.

## References

 - [x86-64 SysV ABI](https://github.com/hjl-tools/x86-psABI/wiki/X86-psABI)
 - [i386 SysV ABI](https://refspecs.linuxfoundation.org/elf/abi386-4.pdf)
 - [AMD Programmer's Manual, Volume 3](https://support.amd.com/TechDocs/24594.pdf)
 - [AMD64 Linux
   Syscalls](https://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/)
 - [i386 Linux Syscalls](https://syscalls.kernelgrok.com/)
 - [AMD64 ASM Cheat Sheet](./amd64_asm.html)
 - [xv6 source code](https://github.com/NatTuck/xv6-public)

## Sections

{: .table .table-striped }
| Section | Location | Time               |
|---------|----------|--------------------|
|      01 | CH 103   | 2:50pm-4:30 Mo/We  |

This page is about the section offered in-person on the Boston campus. There are
other sections of the course offered at other campuses and/or online.

## Staff & Office Hours

{: .table .table-striped }
| Name           | Location | Hours                          | Email                   |
|----------------|----------|--------------------------------|-------------------------|
| Nat Tuck       | NI 132 E | We 1:30-2:30pm; Fr 5:30-6:30pm | ntuck ⚓ ccs.neu.edu     |
|----------------|----------|--------------------------------|-------------------------|
| Kashif Bagdadi | RY 159   | We 4:50-6:50pm                 | bagdadi.k ⚓ husky.neu.edu |
| Harman Singh   | HS 101   | Th 3-5pm                    | singh.harm ⚓ husky.neu.edu |
| Meesam Syed    | HS 103   | Tu 9-11am                     | meesam.s ⚓ husky.neu.edu |
| Jaison Titus   | RY 207   | Th 9-11am                     | titus.ja ⚓ husky.neu.edu |

 * Office hours run from January 8 to April 14
 * Cancellations and changes may be posted to Piazza.

## Course Topics

This is an initial topic list, subject to revision as the semester progresses.

Assignments will frequently be due at 11:59pm on Thursday.

Course Topics:

 * Dev Env
 * Assembly
 * Making Syscalls
 * Implementing Syscalls
 * Processes
 * Virtual Memory
 * Memory Allocation
 * Threads
 * Interprocess Communication
 * Deadlock Detection
 * Concurrency vs. Parallellism
 
There will be about 10 homework assignments related to to the above topics.
Homework will be posted to Inkfish.

Holidays and Breaks:

 * Jan 20: MLK Day
 * Feb 17: President's Day
 * Week of March 2: Spring Break

## Textbook

The textbook for this course is online:

 - [Operating Systems, Three Easy Pieces](http://ostep.org)

## Grading

 * Homework:         95%
 * Participation:    4%
 * Grade Challenges: 1%
 
### Letter Grades

The number to letter mapping will be as follows:

95+ = A, 90+ = A-, 85+ = B+, 80+ = B, 75+ = B-, 70+ = C+, 65+ = C, 60+ = C-, 
50+ = D, else = F

There may be a curve or scale applied to any assignment or the final grades, in
either direction.

### Homework

There's a homework due most weeks. Assignments in this class is difficult and
you are *expected* to get stuck. Start early so you have time to get unstuck.

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

### Participation

Participation on Piazza gives you points if you ask good questions, give good
answers, or post interesting notes related to the course topics.

Participation in in class activities earns points for being there and
participating.

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
 * There may be exceptions to this, which will be listed in the assignemnt
   description.

**Penalty for Plagarism or Providing Solution Code**

First offense:

 - You get an F in the course.
 - You will be reported to OSCCR and CCIS.

Avoid copying code if you can. If you're looking at an example, understand what
it does, type something similar that is appropriate to your program, and provide
attribution. If you must copy code, put in the attribution immediately, every
time or you will fail the course over what feels like a minor mistake.

