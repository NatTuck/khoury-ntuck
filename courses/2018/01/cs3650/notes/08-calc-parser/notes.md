---
layout: default
---

# Computer Systems

## Homework: Parse to Sexp

## Tokenizing to Linked List

 - Two kinds of token:
   - Number
   - Operator
 - Build a linked list that can take either, using
   the tag-and-cast strategy.
 - Strategy is build and reverse.
 - ...

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

## RPN to sexp

 - Reverse the list.
 - Consume items from the front of the list:
   - Operators are an interior node with two children
     consumed from the list.
   - Numbers are leaf nodes.



