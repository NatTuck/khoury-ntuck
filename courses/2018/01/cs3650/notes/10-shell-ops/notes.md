---
layout: default
---

# Computer Systems

## First: Homework Questions

# Shell Concepts

## Fork & Exec

Cover simple examples

## I/O Syscalls

Progress from fgets / stdio to pure syscall I/O.

## File I/O

Show stdio and syscall solutions.

Discuss the process FD table.

Initial slots:

 - 0 = stdin
 - 1 = stdout
 - 2 = stderr
 - 3 = first opened file
 - ...

## Pipes

A pipe is a pair of file discriptors. What goes in the input end comes out the
output end. These can be in different processes if you've forked.


