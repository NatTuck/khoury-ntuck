---
layout: default
---

# Advanced Map-Reduce: In-Class Coding

## Homework has Changed
 
 - New input year. Rewording of some requirements.

## Review DivisibleLengths

 - Note use of emitting multiple records with seperate keys for a single input.

## Multiple Map-Reduce Jobs

 - You can make multiple instances of the Job class.
 - To chain together multiple jobs:
   - Set the first output to some temporary path
   - Set the next input to that path.
   - Delete the temporary path when done.
 - Communication in Map-Reduce only happens once per job, at the shuffle step.
 - Multiple jobs = multiple shuffles = multiple communication phases.

## In-Class Exercise

 - Wordcount, then sort by count.
 - Solution 1: 1 reducer; sort in cleanup()
 - Solution 2: Two jobs: Word count, sort by count

