---
layout: default
---

# Map Reduce: Algorithms pt1

## Homework Questions?

## The Bird Problem

We've got a bunch of bird observations:

    (Species, Color)

We want to calculate the following:
  - Given a species
  - What's the probability of a given color?

So if our data is:

(Robin, Blue)
(Robin, Red)
(Cardinal, Red)
(Roblin, Blue)
...
[no more robins]

Then we can calculate that if we see a Robin, it's
got a 2/3 chance of being blue.

The calculation we need to do is as follows:

For each (S, C) pair:
    p(C | S) = count((S, C)) / count(S)

This can easily be calculated in M-R by picking species
as key. Then we get:

map(...,  (S, C)):
    emit(S, (C, 1))

reduce(S, [(C1, N1), (C2, N2), ...]):
   Scount = sum(all N's)
   Ccount = for each C, sum (C, N's)

   for each C, emit ((S, C), Ccount[C] / Scount)

How good is this:
 - Mapper is as parallel as we want.
 - Reducer count limited to number of species. Two species = 2 reducers.

Can we do better?

Let's think of this as a table:
 - Rows are species
 - Cols are colors
 - Cells contain (S, C) counts.

We split on rows.

It'd be really nice to split on *cells*. Then we could get a reducer
for each (S, C) combo. 

Problem: We need counts of the entire species
in each reducer.

Solution: Send counts per species to each reducer.

map(..., (S, C)):
   emit((S, C), 1)
   for each reducer X:
       emit((S, dummyX), 1)

This requires a custom partitioner.
   e.g. (if key.color == dummyX then X else key.hashCode())

If we make sure dummyX sorts first, then it'll come into the
reducer first, and we won't need extra RAM in the reducer.

Advantage: Perfect reducer parallelism.
Disadvantage: Increased communication by # of reducers factor.

Optimizations:
Combiner: Those (S, dummyX) keys are going to be pretty common.

Parallelism / Communication tradeoff:
 - Best communication: Rows
 - Best parallelism: Cells
 - Compromise: Blocks

This tradeoff idea can be taken pretty far, but it can also get complicated.


## Standard Utilities

# Map-Only Job

If you just want to do a simple

for each record:
   Compute something or do a job.

Then you don't need a reducer at all. Just don't set one, and the output
will be the output of the mapper.

This actually ends up being a pretty common situation. You could even
build something like a web crawler this way:

map(..., URL):
    page = wget URL
    emit(URL, (page, processHTML(page)))

# Random Sampling

map(..., X):
   flip a biased coin
   if heads: emit(X)

# Random Shuffling

map(..., X):
  emit(random(), X)

# Approximate Quantiles

- Take a random sample.
- Sort with secondary sort.
- Pick quantiles in single reducer.

# Top K

- Do it on the board.
- What can the combiner do?

## Filler Nonsense

- Implement top-K.
- Implement approx quantiles.

