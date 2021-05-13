+++
title = "CS4550 - Web Development"
weight = 20
+++

**This is draft. Information subject to change.**

Spring 2021

Discusses development of web sites that are dynamic, data driven, and
interactive. Focuses on the software development issues of integrating multiple
languages, assorted data technologies, and Web interaction. Requires each
student to deploy individually designed Web experiments that illustrate the Web
technologies and at least one major integrative Web site project. Each student
or team must also create extensive documentation of their goals, plans, design
decisions, accomplishments, and user guidelines.

## Essential Resources

 - [Inkfish](https://inkfish.ntuck-neu.site) - View and submit homework
   assignments.
 - [Guides](./guides) - Instructions that might be useful.
 - [Nat's Scratch Repo](https://github.com/NatTuck/scratch-2021-01) - A git repo
   of stuff that may have happened in lecture.
 - [Piazza](https://piazza.com/northeastern/spring2021/cs4550) - Q&A
 - Zoom links for lectures are available on Canvas.

## Sections

{% striped() %}
| Section | Location | Time                 |
|---------|----------|----------------------|
|      01 | BK 310   | 9:50am-11:30am Tu/Fr |
{% end %}

## Office Hours

Office hours will be held online using Khoury Office Hours and Microsoft Teams.

Check the office hours calendar when you're planning your work. Use early office
hours and don't rely on being able to get extensive help right before the due
date.

 - [Khoury Office Hours](https://officehours.khoury.northeastern.edu)
 - [CS4550 Office Hours Calendar](https://outlook.office365.com/owa/calendar/77326df9a3cc4e3c804ae34923a24da6@northeastern.edu/19fe2baf54864671b410af44c4ce888815518400692254605308/calendar.html)

# Course Staff

{% striped() %}
| Name                    | Email                                |
|-------------------------|--------------------------------------|
| Nat Tuck                | ntuck ⚓ ccs.neu.edu                 |
| --                      | -                                    |
| Akash Boda              | boda.a ⚓ husky.neu.edu              |
| Anagha Bhosale          | bhosale.a ⚓ husky.neu.edu           |
| Ankita Mahapatra        | mahapatra.an ⚓ husky.neu.edu        |
| Archana Ajith           | ajith.a ⚓ northeastern.edu          |
{% end %}

## Schedule

This is a draft schedule. It will likely be revised before and/or after the
semester starts.

{% striped() %}
| Week | Starts | Topics                                | Work Due                   |
|------|--------|---------------------------------------|----------------------------|
| 1    | Jan 18 | Intro: Dev on the Web; Server Setup   | HW01: Dev & Server Setup   |
| 2    | Jan 25 | JS & DOM ; Webpack & React            | HW02: Browser Warm Up      |
| 3    | Feb 01 | Elixir & Phoenix Intro                | HW03: Browser Game         |
| 4    | Feb 08 | Sockets / Channels; Server-side State | HW04: Server Warm Up       |
| 5    | Feb 15 | OTP: GenServers, Agents, Supervisors  | HW05: Client-Server Game   |
| 6    | Feb 22 | Resources, REST, Ecto                 | HW06: Four Player Game     |
| 7    | Mar 01 | Relations, Relational DB              | HW07: CRUD - One Model     |
| 8    | Mar 08 | JSON Resources & AJAX                 | HW08: CRUD - Relations     |
| 9    | Mar 15 | SPAs, Redux, Password Security        | Project Proposal           | 
| 10   | Mar 22 | Using Web APIs; OAuth2                | HW09: CRUD - SPA + PW Auth |
| 11   | Mar 29 | Canvas, WebGL, Web Assembly           | -                          |
| 12   | Apr 05 | NoSQL? Ethics?                        | Final Project              |
| 13   | Apr 12 | Presentations Part 1 & 2              | HW10: Ethics?              |
| 14   | Apr 19 | Presentations Part 3                  | -                          |
{% end %}

Assignments will frequently be due at 11:59pm Friday.

## Required Supplies

There is no required textbook for this course. Your primary resource should be
the official documentation for the languages, libraries, tools, and frameworks
we use in the class.

Each student must have virtual private server and a domain name, accessible from
the public internet. Getting these will be part of the first homework
assignment. This will cost around $30 for the semester.

Domain Registrars: 
  [joker](https://joker.com/), 
  [gandi](https://www.gandi.net), 
  [namecheap](http://www.namecheap.com).

VPS Providers: 
  [vultr](https://www.vultr.com/),
  [linode](https://www.linode.com/), 
  [digital ocean](https://www.digitalocean.com/).
 
Your VPS should have Debian 10 and at least 1 GB of RAM. Either your domain
registrar or your VPS provider should provide DNS service.

You may not use a cloud server (e.g. Amazon EC2, Google Compute, Azure) in place
of a VPS.

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

## Editors

We will be writing code in several languages. Programming is much easier with
editor support, so you *must* find and configure an editor that supports the
languages we are using. Most editors will do HTML / CSS / JS well out of the
box. Elixir is supported less broadly - these editors should work well:

 - Vim with [vim-elixir](https://github.com/elixir-editors/vim-elixir)
 - Emacs with lsp-mode and some effort.
 - [Spacemacs](http://spacemacs.org) with the elixir layer.
 - [Atom](https://atom.io/) with the packages language-elixir and auto-indent.
 - [VS Code](https://github.com/VSCodium/vscodium)

Submitted code with indentation that shows that you aren't using an editor with
automatic indentation support (and using it successfully) will be penalized
harshly.

## Grading

 * Homework: 68%
 * Project: 30%
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

Homework and project grades will be posted on Inkfish. If you think your work
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
   Inkfish, and no later than Tuesday of finals week.
 - Leftover contest tokens give you a small bonus to your final grade.

### Special Accomodations

Students needing disability accommodations should visit the [Disability Resource
Center](http://www.northeastern.edu/drc/about-the-drc/) (DRC).

If you have been granted special accommodations either through the DRC or as a
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
 - All code will be posted publicly on Github. In the case of an authorship
   dispute, whoever pushed to Github first wins.
   
**Non-Code Work**

Obviously, written text for something like a project report can also be
plagiarized. The standard rules for writing apply.

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

