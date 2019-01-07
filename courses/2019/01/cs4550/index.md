---
layout: default
---

# CS 4550 - Web Development

Spring 2019

Discusses Web development for sites that are dynamic, data driven, and
interactive. Focuses on the software development issues of integrating multiple
languages, assorted data technologies, and Web interaction. Requires each
student to deploy individually designed Web experiments that illustrate the Web
technologies and at least one major integrative Web site project. Each student
or team must also create extensive documentation of their goals, plans, design
decisions, accomplishments, and user guidelines.


## Essential Resources

 - [Bottlenose](https://bottlenose.ccs.neu.edu) - View and submit homework assignments.
 - [Piazza](https://piazza.com/northeastern/spring2019/cs4550) - Class discussion
   & announcements.
 - [Undergrad Tutoring](http://www.ccis.northeastern.edu/current-students/undergraduate/resources/)
 - [Guides](./guides) - Instructions that might be useful.
 - [Nat's Notes](./notes) - Probably confusing, but includes most code shown in class.

## Sections

{: .table .table-striped }
| Section | Location | Time               |
|---------|----------|--------------------|
|      01 | RB 109  | 11:45am-1:25pm MoTh |

## Office Hours

{: .table .table-striped }
| Name             | Location | Hours                    | Email                      |
|------------------|----------|--------------------------|----------------------------|
| Nat Tuck         | NI 132 E | Tu 5:30-6:30pm; Th 2-3pm | ntuck ⚓ ccs.neu.edu       |
|------------------|----------|--------------------------|----------------------------|
| Benjamin Muschol | RY 285   | Th 6-8pm                 | muschol.b ⚓ husky.neu.edu |

## Schedule

This is a draft schedule. It will likely be revised before and/or after the
semester starts.

{: .table .table-striped }
| Week | Starts | Topics                                | Work Due                   |
|------|--------|---------------------------------------|----------------------------|
|    1 | Jan 07 | Intro: Dev on the Web; Server Setup   | HW01: Dev & Server Setup   |
|    2 | Jan 14 | JS & DOM ; Elixir & Phoenix Intro     | HW02: Browser Warm Up      |
|   3+ | Jan 21 | (MLK) Webpack & React                 | HW03: Server Warm Up     |
|    4 | Jan 28 | Sockets / Channels; Server-side State | HW04: Client-Side Game     |
|    5 | Feb 04 | OTP: GenServers, Agents, Supervisors  | HW05: Client-Server Game   |
|    6 | Feb 11 | Resources, REST, Ecto                 | -                          |
|   7+ | Feb 17 | (Pres) Relations, Relational DB       | Proj1: Multi-Player Game   |
|    8 | Feb 25 | JSON Resources & AJAX                 | HW06: CRUD - One Model     |
|    - | Mar 03 | (spring break)                        | -                          |
|    9 | Mar 11 | SPAs, Redux, Password Security        | HW07: CRUD - Relations     |
|   10 | Mar 18 | Using Web APIs; OAuth2                | HW08: CRUD - SPA + PW Auth |
|   11 | Mar 25 | Canvas, WebGL, Web Assembly           | -                          |
|   12 | Apr 01 | NoSQL                                 | Project 2: CRUD App        |
|   13 | Apr 08 | Presentations Part 1 & 2              | -                          |
|   14 | Apr 15 | Patriot's Day, No Class               | -                          |

(+) One Lecture Weeks

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
   [digital ocean](https://www.digitalocean.com/)
 
Your VPS should have Ubuntu 18.04 and at least 1 GB of RAM. Either your domain
registrar or your VPS provider should provide DNS hosting.

You may not use a cloud server (e.g. Amazon EC2, Google Compute, Azure) in place
of a VPS. 

## Library, Framework, Tool, and Language Documentation

 - [HTML5](https://dev.w3.org/html5/html-author/)
 - [CSS](https://www.w3schools.com/cssref/)
 - [JavaScript Language & Browser Stdlib](https://www.w3schools.com/jsref/)
 - [New ES6 Features](http://es6-features.org/)
 - [jQuery](http://api.jquery.com/)
 - [Bootstrap 4](https://getbootstrap.com/docs/4.0/getting-started/introduction/)
 - [Elixir Language and Stdlib](https://elixir-lang.org/docs.html)
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
 - [VS Code](https://github.com/VSCodium/vscodium)

Submitted code with indentation that shows that you aren't using an editor with
automatic indentation support (and using it successfully) will be penalized
harshly.

## Grading

 * Homework: 58%
 * Projects: 40%
 * Other:     2% (Participation, Challenges)
 
### Letter Grades

The number to letter mapping will be as follows:

95+ = A, 90+ = A-, 85+ = B+, 80+ = B, 75+ = B-, 70+ = C+, 65+ = C, 60+ = C-, 
50+ = D, else = F

There may be a curve or scale applied to any assignment or the final grades, in
either direction.

### Homework

Most weeks there will be a homework assignment due. You'll have to do some web
design, programming, system administration, database manipulation, etc.

In order to learn the material in this class you must submit the homework. If at
any point you have three unexcused zero grades for past-due assignments you will
fail the course.

If you fall behind on the course work for any reason, please come to the
professor's office hours to discuss how you can catch up.

### Projects

Your projects will exercise many of the techniques and technologies covered in the
homework to create a significant web application from scratch.

### Late Work

Late submissions will be penalized by 1% per hour late.

The last assignment of the semester may not be submitted more than 12 hours late.

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

