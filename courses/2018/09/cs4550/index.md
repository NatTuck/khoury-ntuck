---
layout: default
---

# CS 4550 - Web Development

Fall 2018

Discusses Web development for sites that are dynamic, data driven, and
interactive. Focuses on the software development issues of integrating multiple
languages, assorted data technologies, and Web interaction. Requires each
student to deploy individually designed Web experiments that illustrate the Web
technologies and at least one major integrative Web site project. Each student
or team must also create extensive documentation of their goals, plans, design
decisions, accomplishments, and user guidelines.


## Essential Resources

 - [Bottlenose](https://bottlenose.ccs.neu.edu) - View and submit homework assignments.
 - [Piazza](https://piazza.com/northeastern/fall2018/cs4550) - Class discussion
   & announcements.
 - [Undergrad Tutoring](http://www.ccis.northeastern.edu/current-students/undergraduate/resources/)
 - [Guides](./guides) - Instructions that might be useful.
 - [Nat's Notes](./notes) - Probably confusing, but includes most code shown in class.

## Sections

{: .table .table-striped }
| Section | Location | Time               |
|---------|----------|--------------------|
|      01 | WVG 102  | 3:25pm-5:05pm TuFr |

## Office Hours

{: .table .table-striped }
| Name     | Location | Hours | Email                |
|----------|----------|-------|----------------------|
| Nat Tuck | NI 132 E | TBA   | ntuck ⚓ ccs.neu.edu  |
| ...      | ...      | TBA   | ...                  |

## Schedule

This is an initial schedule, subject to revision as the semester progresses.

{: .table .table-striped }
| Week | Starts | Topics                                | Work Due                   |
|------|--------|---------------------------------------|----------------------------|
|   1+ | Sep 03 | Intro: Dev on the Web; Server Setup   | -                          |
|    2 | Sep 10 | JS & DOM ; Elixir & Phoenix Intro     | HW01: Dev & Server Setup   |
|    3 | Sep 17 | Webpack, Bootstrap, Modern JS & React | HW02: Warm Up              |
|    4 | Sep 24 | Sockets / Channels; Server-side State | HW03: Client-Side Game     |
|    5 | Oct 01 | OTP: GenServers, Agents, Supervisors  | HW04: Client-Server Game   |
|    6 | Oct 08 | Resources, REST, Ecto                 | HW05: Two-Player Game      |
|    7 | Oct 15 | Relations, Relational DB              | HW06: CRUD - One Model     |
|    8 | Oct 22 | JSON Resources & AJAX                 | HW07: CRUD - Relations     |
|    9 | Oct 29 | SPAs, Redux, Password Security        | Project Proposal           |
|   10 | Nov 05 | Using Web APIs; OAuth2                | HW09: CRUD - SPA + PW Auth |
|   11 | Nov 12 | Canvas, WebGL, Web Assembly           | -                          |
|  12+ | Nov 19 | NoSQL                                 | -                          |
|   13 | Nov 26 | Presentations Part 1 & 2              | Monday 26th: Project Due   |
|  14+ | Dec 03 | Presentations Part 3; Wrap Up         | -                          |

(+) One Lecture Weeks: Start, Thanksgiving, End

Assignments will frequently be due at 11:59pm Thursday.

## Required Supplies

There is no required textbook for this course. Your primary resource should be
the official documentation for the languages, libraries, tools, and frameworks
we use in the class.

Each student must have virtual private server and a domain name, accessible from
the public internet. Getting these will be part of the first homework
assignment. This will cost around $30 for the semester.

Domain Registrars: [joker](https://joker.com/), [gandi](https://www.gandi.net), 
[namecheap](http://www.namecheap.com).

VPS Providers: [vultr](https://www.vultr.com/), [linode](https://www.linode.com/),
[prgmr](https://www.prgmr.com/).
 
Your VPS should have Ubuntu 18.04 and at least 1 GB of RAM. Either your domain
registrar or your VPS provider should provide DNS hosting.

## Library, Framework, Tool, and Language Documentation

 - [HTML5](https://dev.w3.org/html5/html-author/)
 - [CSS](https://www.w3schools.com/cssref/)
 - [JavaScript Language & Browser Stdlib](https://www.w3schools.com/jsref/)
 - [New ES6 Features](http://es6-features.org/)
 - [jQuery](http://api.jquery.com/)
 - [Bootstrap 4](https://getbootstrap.com/docs/4.0/getting-started/introduction/)
 - [Elixir Language & Stdlib](https://elixir-lang.org/docs.html)
 - [Phoenix Framework](https://hexdocs.pm/phoenix/overview.html)
 - [Ecto Library](https://hexdocs.pm/ecto/Ecto.html)
 - [PostgreSQL Database](https://www.postgresql.org/docs/9.5/static/index.html)
 - [React Library](https://reactjs.org/docs/hello-world.html)
 - [ReactStrap](https://github.com/reactstrap/reactstrap)
 - [React Konva](https://github.com/lavrton/react-konva)

Prof Rasala's Web Dev Links: 
[Web Dev Links](https://web.northeastern.edu/rasala/webdevlinks.htm)

## Editors

We will be writing code in several languages. Programming is much easier with
editor support, so you *must* find and configure an editor that supports the
languages we are using. Most editors will do HTML / CSS / JS well out of the
box. Elixir is supported less broadly - these editors should work well:

 - Vim with [vim-elixir](https://github.com/elixir-editors/vim-elixir)
 - Emacs with elixir-mode.
 - [Spacemacs](http://spacemacs.org) with the elixir layer.
 - [Atom](https://atom.io/) with the packages language-elixir and auto-ident.

Submitted code with indentation that shows that you aren't using an editor with
automatic indentation support (and using it successfully) will be penalized
harshly.

## Grading

 * Homework: 60%
 * Project:  40%
 
### Letter Grades

The number to letter mapping will be as follows:

95+ = A, 90+ = A-, 85+ = B+, 80+ = B, 75+ = B-, 70+ = C+, 65+ = C, 60+ = C-, 
50+ = D, else = F

There may be a curve or scale applied to any assignment or the final grades, in
either direction.

### Homework

Most weeks there will be a homework assignment due. You'll have to do some web
design, programming, system administration, database manipulation, etc.

The homework portion of your grade will include some "virtual" assignments which
you'll get a grade for but don't require assignment submissions:

 - Participation - For example, Piazza posts and good Piazza answers.
 - Grade Challenges - See the grade challenge policy below.

### Project

Your project will exercise many of the techniques and technologies covered in the
homework to create a significant web application from scratch.

### Late Work

Late submissions will be penalized by 1% per hour late.

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
   Bottlenose, and before the end (Friday) of finals week.

### Special Accomodations

Students needing disability accommodations should visit the [Disability Resource
Center](http://www.northeastern.edu/drc/about-the-drc/) (DRC).

If you have been granted special accomodations either through the DRC or as a
student athlete, let me know as soon as possible.

### Code Copying &amp; Collabaration Policy

Copying code and submitting it without proper attribution is strictly prohibited
in this class. This is plagiarism, which is a serious violation of academic
integrity.

Details:

 - For solo assignments, you should personally write your code either from
   scratch or using only the starter code provided in the assignment.
 - For team assignments, your team should do the same.
 - The use of published libraries through the standard package tools is fine.
 - The use of automatically generated code from tools like "mix gen" is fine.
 - All code will be posted publicaly on Github. In the case of an authorship
   dispute, whoever pushed to Github first wins.
   
**Non-Code Work**

Obviously, written text for something like a project report can also be
plagarized. The standard rules for writing apply.

**Lecture Notes**

Lecture notes are *not* starter code, and should not be copied without
attribution. As long as attribution is provided, there is no penalty for
appropriately using code from the lecture notes.

**Collaboration and Attribution:**

Since it's not plagiarism if you provide attribution, as a special exception
to these rules, any code sharing with attribution will not be treated as a
major offense.

There is no penalty for copying small snippets of code (a couple of lines) with
attribution as long as this code doesn't significantly remove the intended
challenge of the assignment. This should be in a comment above these lines
clearly indicating the source (including author name and URL, if any).

If you copy a large amount of code with attribution, you won't recieve credit
for having completed that portion of the assignment, but there will be no
further penalty. The attribution must be obvious and clearly indicate both
which code it applies to and where it came from.

**Penalty for Plagarism**

First offense:

 - You get an F in the course.
 - You will be reported to OSCCR and CCIS.

Avoid copying code if you can. If you're looking at an example, understand what
it does, type something similar that is appropriate to your program, and provide
attribution. If you must copy code, put in the attribution immediately, every
time or you will fail the course over what feels like a minor mistake.

