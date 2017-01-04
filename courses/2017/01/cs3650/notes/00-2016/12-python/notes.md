---
layout: default
---

# CS3650: A Day of Python

## First Thing
 
 - Homework Questions

## Scripting Languages

Why?

 - Extension of shell scripting. You can do a lot in the Unix shell,
   but it gets awkward for anything but very small programs.

What?

 - High level languages: A few lines of code do a lot.
 - Programs exist as source code. No compilation step.
 - Fast startup. A short program can start, run, and exit quickly.
 - Easy access to OS functionality (like system calls).
 - Good at text processing.
 - Two standard data structures:
   - Dynamic array
   - Hash table

Three major examples on Linux:
 
 - Perl
 - Python
 - Ruby

High level dynamic languages that are not "scripting languages" in this sense:

 - Racket - Not optimized for OS access, hash tables, or string processing.
 - JavaScript - Not optimized for OS access or string processing.
 - Anything on the JVM (e.g. Groovy) - Slow startup.

Python is the lamest of the three. We'll look at Python.

## Python Basics

 - Open a text file, traditionally named whatever.py
 - Type in the program.
 - Execute the file with "python whatever.py"
 - Shebang line. We can start the file with
    #!/usr/bin/python
    set it executable
    and just run it like a program


## The Cool Things about Python

 - List comprehensions.
    - [x + 1 for x in range(1, 10) if x % 3 == 0]
 - Range syntax.
    - range(0, 10)[3:7]
 - NumPy / SciPy

## Sample Python Programs

 - Reverse words.
   - .split() returns a list.
   - .reverse() mutates a list. 
   - reversed(...) gives a reverse iterator
 - This list: https://wiki.python.org/moin/SimplePrograms

## Mention SWIG

 - Call C functions from any of a variety of languages.


