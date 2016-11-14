---
layout: default
---

# Map Reduce: Pig / Pig Latin

## Homework Questions?

## Apache Pig

 - Writing MapReduce programs is annoying. You spend your time fiddling with
   implementation details like combiners.
 - It's reasonable to think that running a "Job" should take about one line of code.
 - Pig was initially a "scripting interface" to MapReduce.
 - Today it can also use Apache Tez as a somewhat more efficient backend than MapReduce.
 - Pig programs are written using the Pig Latin language.
 - Pig also provides an interactive shell.

### Basic Pig Latin Commands

Start pig locally with "pig -x local".

    # Load a file from disk.
    # Produces a sequence of lines.
    A = LOAD 'alice.txt';
    
    STORE A into 'foo.txt'; 

    # Show the data.
    DESCRIBE A;
    DUMP A;

    # Load a file from disk, expected CSV
    # Produces a series of tuples.
    A = LOAD 'baseball/Salaries.csv' using PigStorage(',');
    STORE A INTO 'foo' using PigStorage(',');

    # Rank
    # Adds rank field at front and sorts.
    # Fields in tuple are $0, $1, ...
    B = RANK A BY $1 desc;

    # Foreach
    # Kind of like a map operation.
    # e.g. Project only first two columns.
    FOREACH A GENERATE $0, $1; 

    # Filter
    # Does what you think.
    FILTER A BY $0 == 1982;

    # Join
    # Joins two collections.
    # Can specify multiple fields to join on.
    pl = LOAD 'baseball/Salaries.csv' using PigStorage(',');
    hh = LOAD 'baseball/HallOfFame.csv' using PigStorage(',');
    jj = JOIN pl by $0, hh by $0;
   
    # Random sample. 
    B = SAMPLE A 0.001;
   
