---
layout: default
---

# Programming Challenge

Write a program that takes a boolean expression in conjunctive normal form and
either outputs a set of values for the variables that makes the expression true
or "no variable values can make this true".

You can assume the following input format:

 * A text file
 * Variables are represented by integers starting at zero.
 * Each line in the file is a clause; the clauses are all ANDed together.
 * Each item in a line is a variable or a negated variable; these are ORed
   together within a clause.
 * "-N" indicates the variable N is negated in that clause.
 * A line starting with "c" is a comment and should be skipped.

For example:

```
0 1
1 -2 3
0 -1
4 5 -3
```

Means:

```
(x0 ∨ x1) ∧ (x1 ∨ ¬x2 ∨ x3) ∧ (x0 ∨ ¬x1) ∧ (x4 ∨ x5 ∨ ¬x3)
```

Visit https://toughsat.appspot.com/ to get test cases.

Try:

 * Random Subset Sum
 * Set size = 10
 * Max number = 10

AND = ∧
OR  = ∨ 
NOT = ¬ 
