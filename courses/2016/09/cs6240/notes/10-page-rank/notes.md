---
layout: default
---

# Map Reduce: Iterative Algos

## Homework Questions?

## Page Rank

 - We have a set of web pages (vertexes).
 - Each page has zero or more outgoing links, which link to other
   pages in the set (directed edges).
 - We start with each page equally weighted.
 - Each iteration we:
   - For each page:
     - Send it's weight, split equally, to the pages that it links to.
   - For each page:
     - The new weight is the sum of the incoming weights.
 - This leaves a problem: Pages with no outlinks simply lose their weight.
 - We need to catch all this lost weight and add it split evenly among
   all pages.
 - This process eventually stabilizes, but we can see trends after even
   a couple of iterations.

 - Show example: Triangle with links going around, one extra node with a
   link from the triangle.
 - Run a couple iterations.

## k-Means in-class assignment.

 - Input -> Iterations\* -> Output
 - Key idea: Custom partitioner to seperate cluster centers (in reducer 0)
     from clusters (in other reducers).
 - Global counter (# of changes per iteration) to detect convergence.
 - config.setInt() to pass K and iteration to reducers.
 - Need a sequence of input / output directories. Iteration 5's output
   should be iteration 6's input.

