---
layout: default
---

# Timesheets App: Requirements

## Introduction

ACME Engineering is a (fictional) company that builds medical devices under
contract for the US Department of Veterans Affairs Office of Research and
Development.

You have been hired to migrate their timekeeping system from paper to a new
web-based digital system.

This document describes the business requirements for the new digital system.

## Workers

Engineers working for ACME are full time employees who work 8 hour days.

Each day the engineers fill out a paper timesheet form. This form lists the
tasks that they worked on, and associates each task with a Job Code. The form
then goes to managers for approval. This form is the core thing that the new
digital system should replace.

Every hour worked (8 hours per day) must be associated with a task with a valid
job code that has sufficient budget to pay for those work hours. This is
validated by hand in the paper system, but the new digital system should notify
a worker's manager if this policy is violated.

## Managers

Each worker has an associated manager. This manager is responsible for verifying
and approving that worker's time sheets.

## Jobs

When ACME accepts a new contract, that contract is assigned a Job Code. The Job
Code is an alphanumeric identifier assigned outside of the timekeeping system.

Each Job has an associated manager, who is responsible for the contract.

Each contract has a budget (specfied in work hours). Tasks can be billed to a
job code until those hours are used up. It must be possible to bill excess hours
to a job code, but the job's manager should be notified when that occurs.

A Job has a name and a multi-line textual description.

## Tasks

A row in a worker's timesheet is called a Task. Each task has an associated worker,
job code, and number of hours worked. The sum of hours for tasks a user works on
in a single day (a single timesheet) cannot exceed 8 hours.

If a worker's tasks add up to less than 8 hours, their manager should be
notified.

Each task includes a note, where the worker must enter a one line summary of the
work they did.

## Required Forms

 - A worker should be able to enter their timesheet for any day in the past.
 - A manager should be able to approve timesheets for workers they supervise.
 - A manager should be able to approve days worth of tasks for jobs they
   supervise.
 - A manager should be able to modify entered timesheets for any worker that
   they supervise.
 - A manager should be able to create a new Job.
 - A mananger should be able to create or edit users.

## Required Reports

 - A worker should be able to see any of their timesheets.
   - A heading should show the worker's name and the date.
   - A table should have a row for each task that day.
   - A list of problems with the timesheet (overbilled jobs, underbilled hours)
     should appear below the table.
 - A manager should be able to see any timesheets for the workers they
   supervise.
 - A manager should be able to see a worker timesheet summary for any day.
   - This should show all the users they supervise, and any problems with
     that day's timesheets.
 - A manager should be able to see a job summary.
   - This should show a table of tasks worked on the job, with worker, number
     of hours, and the note that the worker entered.
   - The number of hours of budget left on the Job should be shown, with a
     clear warning indication if the Job is over budget.
 - Any manager should be able to see a summary of all jobs.
   - For each job, this shows total budget, hours spent, and hours left.
   - Jobs that are over budget should be clearly indicated.

## Required Notifications

Notifications should appear immediately when an appropriate timesheet is
submitted, assuming that the appropriate manager is logged into the app and
viewing any application screen.

 - A manager should be notified when their Job goes over budget.
 - A manager should be notified when a worker reporting to them submits a
   timesheet with less than 8 hours of tasks billed to valid Job Codes.

## Users and Authentication

For the digital systems, users should log in using an email address and
password. Passwords must be at least 12 characters, and should be handled using
appropriate best practices for security.

A user is either a Worker or a Manager, but not both.

## Sample Data

Users

| Name           | Email          | Manager? | Password     |
|----------------|----------------|----------|--------------|
| Alice Anderson | alice@acme.com | t        | password1234 |
| Bob Anderson   | bob@acme.com   | t        | password1234 |
| Carol Anderson | carol@acme.com | f        | password1234 |
| Dave Anderson  | dave@acme.com  | f        | password1234 |

Jobs

| Job Code | Budget (Hours) | Name          | Description |
|----------|----------------|---------------|-------------|
| VAOR-01  | 20             | Cyborg Arm    | (1)         |
| VAOR-02  | 45             | Sobriety Pill | (1)         |
| VAOR-03  | 12             | Rat Cancer    | (1)         |

(1) Should support at least three paragraphs of 
[Lorem Ipsem](https://www.lipsum.com/).

