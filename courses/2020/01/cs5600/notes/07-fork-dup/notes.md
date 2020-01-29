---
layout: default
---

# Computer Systems

## First: Homework Questions

# Part 2: Shell Concepts

## File I/O

Progress from fgets /  to pure syscall I/O.

## Filesystem Ops

show ls.c

## Fork & Exec

Cover simple example.

 - A running instance of a program is a process.
 - Fork *copies* a process.
 - Exec loads a binary and replaces the contents of a 
   running process, like some sort of horror movie.

## Shell Operators

Demonstrate each of these in a shell:

 - Redirect input: sort < foo.txt
 - Redirect output: sort foo.txt > output.txt
 - Pipe: sort foo.txt | uniq
   - man 2 pipe
 - Background: sleep 10 &
 - And: true && echo one
   - Return value from main
   - Success (rv = 0) is true
   - Return val of last command in $?
 - Or: true || echo one
 - Semicolon: echo one; echo two

## Redirect Example

 - redir.c

## Pipe Examples

 - pipe0, pipe1
 - sort-pipe

