---
layout: default
---

# Computer Systems

## First Thing

 - Questions on the Homework?
 
## Intro to Unix Shell

 - Create text file (one, two, three, four)
 - Sort it with 'sort'
 - Operators: Pipe and redirect
 - sort | tac
 - All words with boat, no apostrophe, and the letter e, reversed.
   - Write as multi-line shell script with temporaries.
 
## Copy Bytes

 - Value data can be copied by copying its bytes.
 - The same bytes mean the same thing if they're
   interpreted the same way.

## Reverse Lines

 - Can read a line into a fixed size buffer with fgets.
 - Don't use "gets". Just mentioning it is a security hole.
 - Variable length arrays.
   - Struct of (data, size, capacity)
   - Double capacity when out of space.
   - For strings, takes ownership of a copy.
   - Ownership = string is freed when vec is freed.

## Calculator

Tokens:

 - Two kinds of token: number, operator
 - Distinguishers: isdigit, isspace, neither
 
Abstract syntax tree:

 - Four ops: add, sub, mul, div
 - Leaves are values, op is '='
 - calc_ast struct: (op, value, arg0, arg1)

Parsing:

 - Find lowest priority op.
 - Split on it.
 - Recurse
 - Build an AST 

Evaluation:

 - Call eval, which traverses the tree.
 
