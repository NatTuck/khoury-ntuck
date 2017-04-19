---
layout: default
---

# cs2500: Last Class

## The Basics

 * Expressions: Parens, Call Functions
 * Special forms: cond, if
 * Defining functions

## Design Recipe

Designing Data

 * Data Definition
 * Interpretation
 * Examples
 * Template - The structure of the code follows the structure of the data.

Designing Functions

 * Signature
 * Purpose Statement
 * Tests
 * Code

## Kinds of Data

 * Simple atomic data
 * Enumerations
 * Structures
 * Unions

## Recursive Data

 * Base case(s)
 * Structure that references self (directly or indirectly).
 * Follow the template, everything is easy.
 * The structure of the code follows the structure of the data.

## Abstraction: Data

 * We can parameterize data definitions.
 * This lets us have a list of anything.

## Abstractions: Functions

 * When functions look similar, abstract!
 * Duplicate code is a menace.
 
## Built In Abstractions: Loops

 * Map
 * Filter
 * Foldr
 * Others
 
## More Complex Data

 * Trees
 * Graphs
 * Sets

These gave us more examples of complex structures that can be represented as
data in a computer. We saw various ways to represent and process these kinds
of data.

## Accumulators

Usually, the structure of the code follows directly from the structure of the
data. But sometimes, we want to carry additional information along in order
to make the computation work better.

With standard templates, we always have the rest of the data that needs
processing. An accumulator adds some information about the work we've done so
far.

## Generative Recursion

Usually, the structure of the code follows directly from the structure of the
data. Occasionally, we come up with a better plan.

In a Generative Recursive function, we don't follow the structure of the data.
Instead we have a clever idea and do that instead. Unfortunately, this loses us
one of the good properties of structural recursion (templates) - guaranteed
termination. So we need to provide an explicit argument for why our function
terminates. Otherwise, we may never get an answer.

## More Stuff

 * Interpreter
 * Lambda Calculus
 * Macros & Streams

