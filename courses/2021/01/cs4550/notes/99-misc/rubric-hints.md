+++
title = "Rubric Hints"
draft = true
+++

For most homeworks, the grading rubric will be structured as follows:

 - 50% - Program Functionality / Quality
 - 50% - Successful Deployment

Deployment is important. Writing the best web application in the world is pretty
pointless if no-one can use it. 

To make sure that your app deploys, it's best to deploy early and often - the 
partial credit for a half working, deployed app may be greater than the credit
for a fully working app that isn't deployed.

TAs will still try to grade non-deployed applications, at least for HW, by
cloning your git repo and testing locally, but there's no guarantee that what
works on your machine will work on theirs.

Within those headings, the details of the requirements will vary by assignment,
but here are some things that are likely to lose you points on any assignment:

## Program Functionality / Quality Deductions

(This is not a complete rubric for any assignment.)

 - The required functionality should work. If none of it works, you get none of
   the points.
 - If the use of specific techniques to solve specific problems is specified in
   the assignment, you should use those techniques to solve those problems.
 - Your app shouldn't feel broken. Links should work, and there shouldn't be
   server error pages or JavaScript errors in response to user actions.
 - Your web design should be reasonable. The TA should be able to read your
   pages and figure out how to use them.
 - Your code should be high quality and well written. 
 - Your code should have consistent indentation, indicating the use of a
   properly configured editor with automatic indentation for the programming
   languages that we use.

## Successful Deployment Deductions

(This is not a complete rubric for any assignment.)

 - Your app should load when the TA visits the correct hostname.
 - Your CSS and JS assets should load correctly.
 - Your websockets (if any) should connect.
 - Your app should be entirely hosted on your VPS. No cloud services (e.g. AWS)
   should be used, and no assets should be hosted on a CDN.
   - We generally won't be using external client-side APIs - like Google Maps -
     this semester, but that would be a possible exception to this rule.
 - Your app should come up automatically if your server reboots. We have no way
   to test this, but you don't want to lose points if it gets tested by mistake.
   
