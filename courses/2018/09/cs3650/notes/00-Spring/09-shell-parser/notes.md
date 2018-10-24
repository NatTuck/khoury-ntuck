---
layout: default
---

# Computer Systems

## First: Homework Questions

## Second: Challenge 01: Sexp Shell

# Part 1: Solving HW04

## Shared Structure & Linked Lists

 - Problem from last time: 
   - Reversing a list resulted in two lists sharing elements.
   - Freeing one list freed the elements from the other list.
 - Solutions:
   - Copy the items when copying the list.
   - Manage the items separately (e.g. have a token array own them).
   - Reference counting.
   - Garbage collection.

## Sequence Collections

We now have three data structures for sequences:

 - Arrays
   - Problem: Doesn't know size
   - Problem: Changing size is hard
 - Vectors / Dynamic Arrays
   - Solves the problem with arrays
   - Slightly more complex
 - Linked list
   - Prepend is easy
   - Pointers everywhere
   - Random access is hard
   - Shared structure is tempting, but hard

## Writing a Simple Parser

 - Let's look at the HW04 test cases.
 - Cases:
   - Zero operators: Don't even need a data structure.
     - Show the process.
   - One operator: Need a single sequence structure and two scans.
     - Show the process.
   - >1 operator: Need some more complex strategy.
     - Split-on-op and recurse.
     - Build a tree.

Solving the general case:

## Transform to RPN Form

 - Describe this on board.
 - Walk through example:
   - 4 * 3 + 2 * 7
 - Create operator stack and output.
 - For each token:
   - If number, put to output.
   - If operator:
     - Pop any higher presidence ops from stack and put to output.
     - Push operator to stack.
   - If open paren, push to stack.
   - If close paren, pop ops from stack until corresponding open paren.

## RPN to sexp / tree

 - Reverse the list.
 - Consume items from the front of the list:
   - Operators are an interior node with two children
     consumed from the list.
   - Need to swap children.
   - Numbers are leaf nodes.
 - Interior nodes might want to be struct { op, tree, tree }.

# Part 2: Shell Concepts

## I/O Syscalls

Progress from fgets / stdio to pure syscall I/O.

## Fork & Exec

Cover simple example

## File I/O

Show stdio and syscall solutions.


