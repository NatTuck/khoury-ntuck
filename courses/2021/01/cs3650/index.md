+++
title = "CS3650 - Computer Systems"
weight = 10
+++

Spring 2021

**This is draft. Information subject to change.**

Introduces the basic design of computing systems, computer operating systems,
and assembly language using a RISC architecture. Describes caches and virtual
memory. Covers the interface between assembly language and high-level
languages, including call frames and pointers. Covers the use of system calls
and systems programming to show the interaction with the operating system.
Covers the basic structures of an operating system, including application
interfaces, processes, threads, synchronization, interprocess communication,
deadlock, memory management, file systems, and input/output control.

## Essential Resources

 - [Inkfish](https://inkfish.ntuck-neu.site/) - View and submit homework
   assignments.
 - [Piazza](https://piazza.com/northeastern/spring2021/cs3650) - Q&A
 - [Linux / Unix Help](http://www.ccs.neu.edu/course/cs3650/parent/help/)
 - [Nat's Scratch Repo](https://github.com/NatTuck/scratch-2021-01) - A git repo
   of stuff that may have happened in lecture.
 - [Ferd's Scratch Repo](https://github.ccs.neu.edu/fvesely/cs3650-class) - use
   your Khoury account to log in
 - Previous Semesters:
   [Notes](./notes), 
   [Online Lectures](https://ntuck-neu.site/2020-09/cs3650/lectures/)
 - Zoom links for lectures are available on Canvas.

## AMD64 ASM resources

 - [x86-64 SysV ABI](https://github.com/hjl-tools/x86-psABI/wiki/X86-psABI) 
   ([pdf](./asm/x86-64-sysv-abi.pdf))
 - [AMD Programmer's Manual, Volume 3](https://support.amd.com/TechDocs/24594.pdf)
 - [AMD64 Linux
   Syscalls](https://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/)
 - [AMD64 ASM Cheat Sheet](./asm/cheatsheet)
 - [AMD64 ASM Recipe](./asm/recipe)
   
## Sections

{% striped() %}
| Section | Instructor | Location | Time                 |
|---------|------------|----------|----------------------|
|      01 | Vesely     | SH 305   | 11:45am-1:25pm Mo/Th |
|      02 | Tuck       | SH 305   | 1:35pm-3:15pm Tu/Fr  |
|      03 | Tuck       | SH 305   | 3:25pm-5:05pm Tu/Fr  |
{% end %}

## Office Hours

Office hours will be held online using Khoury Office Hours and Microsoft Teams.

Check the office hours calendar when you're planning your work. Use early office
hours and don't rely on being able to get extensive help right before the due
date.

 - [Khoury Office Hours](https://officehours.khoury.northeastern.edu)
 - [3650 Office Hours Calendar](https://outlook.office365.com/owa/calendar/77326df9a3cc4e3c804ae34923a24da6@northeastern.edu/0dbbbf1b9e064f4c893aa765aaa18f1e12908199066381895072/calendar.html)

## Course Staff

{% striped() %}
| Name                       | Email                           |
|----------------------------|---------------------------------|
| Nat Tuck                   | ntuck ⚓ ccs.neu.edu            |
| Ferd Vesely                | f.vesely ⚓ northeastern.edu    |
|----------------------------|---------------------------------|
| Grace Ding                 | ding.g ⚓ husky.neu.edu         |
| Ethan Leba                 | leba.e ⚓ husky.neu.edu         |
| Allison Lisciandro         | lisciandro.a ⚓ husky.neu.edu   |
| Naveen Muralidhar          | muralidhar.na ⚓ husky.neu.edu  |
| Jennifer Ribeiro           | ribeiro.je ⚓ husky.neu.edu     |
| Akshat Mansukhlal Savaliya | savaliya.a ⚓ husky.neu.edu     |
| Maxwell Sebso              | sebso.m ⚓ northeastern.edu     |
| Vincent Zhao               | zhao.v ⚓ husky.neu.edu         |
| Zach Lieberman             | lieberman.z ⚓ northeastern.edu |
{% end %}


 * Office hours run from January 25th to April 21st.

## Pandemic Adaptations / Policies

Due to the ongoing pandemic, we'll be using an altered course structure this
semester as well as following the Northeastern policies.

Course structure changes:

 * Primary lecture content will be delivered in synchronous class meetings at
   scheduled lecture times, available both in-person and remotely by video
   conference. See Canvas for Zoom links.
 * There will not be scheduled in-person office hours. Instead there will be
   online office hours only.

Make sure you are familiar with the [university
policies](https://news.northeastern.edu/coronavirus/) for being on campus and
attending classes during the COVID-19 pandemic. Specifically, you must [wear a
mask and maintain social
distancing](https://news.northeastern.edu/coronavirus/reopening/policies-and-protocols/)
in the classroom while those policies remain in effect.

## Schedule

This is an initial schedule, subject to revision as the semester progresses.

Assignments will frequently be due at 11:59pm on Tuesday.

Information about assignments and due dates appear here and on Inkfish. **Only
the assignments and due dates listed on Inkfish matter.**

{% striped() %}
|Week| Starts     | Topics                                                 | Work Due  |
|----| --------   | --------                                               | -----     |
|  1 | Jan 18 (α) | Intro: Systems & Assembly; {History}                   | -         |
|  2 | Jan 25     | ASM: "Design Recipe"; Large ASM Example;               | HW01: Linux Setup & Hello Worlds |
|  3 | Feb 01     | ASM: Syscalls, I/O, the heap; Processes & Memory       | HW02: ASM, Pointers, Funs    |
|  4 | Feb 08     | C: Arrays & Pointers; C: Data Structures;              | HW03: ASM Sort              |
|  5 | Feb 15 (β) | {C: Trees}; Syscalls: fork, exec, waitpid;             | HW04: C Data Structures        |
|  6 | Feb 22     | Building a Shell & pipe; read, write, proc table, vmem;| HW05: Shell Tokenizer         |
|  7 | Mar 01     | shared mem & data races; semaphore locks & deadlock;   | CH1: Unix Shell             |
|  8 | Mar 08     | threads and mutexes; cond vars and atomics             | HW06: Parallel Sort (Processes)  |
|  9 | Mar 15     | malloc: free lists;  malloc: optimizations & threads;  | HW07: Parallel Sort (Threads)    |
| 10 | Mar 22     | Bonus Topic; OS Kernels                                | HW08: Simple Memory Allocator  |
| 11 | Mar 29     | Looking at xv6; Disk Hardware                          | CH2: Advanced Memory Allocator  |
| 12 | Apr 05     | File Systems: FAT; File Systems: ext                   | HW09: Examining xv6     |
| 13 | Apr 12     | The FUSE API;  Wrap-Up                   | HW10: Simple FS                |
| 14 | Apr 19 (γ) | {Bonus Topic}                            | CH3: Advanced FS                |
{% end %}

The following weeks have no Monday lecture for Section 01. Lectures which are
planned only for sections 02 and 03 are listed in {brackets}.
 
 * (α) No meeting Monday: MLK day
 * (β) No meeting Monday: Pres Day
 * (γ) No meeting Monday: Pats Day

Some possible bonus topics:

 * Garbage Collection
 * High Level Solutions for Parallelism and Concurrency

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

There's a homework or challenge assignment due nearly every week. These
assignments will be posted and submitted on Inkfish - make sure to check there
for accurate assignment info and due dates.

Assignments in this class is difficult and you are *expected* to get stuck.
Start early so you have time to get unstuck.

Challenges are just like homework, except they're harder, worth more points, and
they are graded more harshly. You'll want to start early and plan to spend a
*lot* of time on them.

In order to learn the material in this class you must submit the assignments. If
at any point you have three unexcused zero grades for assignments that have been
graded you will fail the course.

If you fall behind on the course work for any reason, please come to the
instructor's office hours to discuss how you can catch up.

**Automatic Grading Script**

The Inkfish server will automatically run a test script each time you submit an
attempt at an assignment. The output from this script is usually displayed
immediately after you upload your code, and your score is displayed at the end
of this script output.

Except in the case of a clear mistake by the course staff, this automatically
generated grade is your grade for that component of the assignment. You are
responsible for waiting for your score to display and making a corrected
submission if you want a higher score.

### Late Work

Late submissions will be penalized by 1% for each hour late.

For the final assignment, late submissions will not be accepted after the sun
comes up in Boston and the TAs start grading.

**Late Registration**

If you register late for the course please contact the professor for extended
homework due dates as soon as possible. In general you will be expected to
complete all of your assignments in order, and you will receive an extension on
at most one assignment due after your registration date.

Late submissions will be penalized per the normal policy without an explicit
written extension from the instructor.

## Policies

### Contesting Grades

Homework and challenge grades will be posted on Inkfish. If you think your work
was graded incorrectly, you can challenge your grade through the following
process:

First, visit office hours or email the course staff member who graded your
work. If you can convince them that they made a concrete error in grading, they
will fix it for you.

If the grader doesn't agree that the grade was wrong, you can formally contest
your grade with the professor. This follows a variant of the "coaches challenge"
procedure used in the NFL.

For automated scripts the staff member responsible is Nat Tuck. Bugfixes to the
script can happen whenever, but adjustments to script-generated scores will only
happen after the manual component of the grade is posted.

Here's the formal challenge procedure: 

 - You start with two tokens.
 - You can spend a token to contest your grade on any assignment.
 - If you have no tokens left, you can't formally contest grades.
 - When you contest a grade, the instructor will regrade your assignment from
   scratch.
 - The new grade is applied to your assignment.
 - If your new score is higher than the old score, you get your token back.
 - Leftover tokens give you a small bonus to your final grade.
 - Formal challenges must be submitted within two weeks of the grade being
   posted to Inkfish, and no later than Tuesday of finals week.

### Special Accomodations

Students needing disability accommodations should visit the [Disability Resource
Center](http://www.northeastern.edu/drc/about-the-drc/) (DRC).

If you have been granted special accommodations either through the DRC or as a
student athlete, let your instructor know as soon as possible.

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

**Penalty for Plagiarism or Providing Solution Code**

First offense:

 - You get an F in the course.
 - You will be reported to OSCCR and CCIS.

Avoid copying code if you can. If you're looking at an example, understand what
it does, type something similar that is appropriate to your program, and provide
attribution. If you must copy code, put in the attribution immediately, every
time or you will fail the course over what feels like a minor mistake.

