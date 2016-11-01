---
layout: default
---

# Map Reduce: Random stuff

## Homework Questions?

## Matrix Multiplication

To multiply two n\*n matrices together:

    C[i][j] = sum[k=1..n](A[i][k] * B[k][j])

This is trivial to paralleize with shared memory:

 * A and B are read only.
 * You can have n\*n parallel tasks each compute a single cell of C
   with a single for loop.

In a map-reduce style it's a bit trickier.

The similar solution would be to take (i, j) for C as the reduce key. This
means the mapper needs to emit `n` copies of each input value, which gives us
O(n^3) communication cost. A combiner can't save us, since we don't have enough
information in the mapper.

Another option would be to transpose B and distribute it to each mapper
(e.g. using the distributed cache). This would require O(p\*n^2) communication
cost to distribute the matrices, and each mapper would need to read in all of
B for each input row. Advantage: The output would be the rows of C with no further
processing needed.

Distributed cache points:

 * You add a file to the distributed cache for a job.
 * Before the job, it copies the file to each worker node.
 * It has special handling for zip files (it unzips them).
 * This is more efficient than direct filesystem reads *if*
   the file is small enough to fit on workers' local disk.

We can use similar strategies in Spark. Let's take a look.

## Matrix-Vector Multiplication

To multiply an n\*n matrix A by a n-vector B to produce an n-vector C:

    C[i] = sum[k=1..n](A[i][k] * B[k])

Each element in C is the sum of the pairwise products of the elements
in one row of A and the entire vector B.

Addition is commutative, so these additions can be performed in any order.

So how do we do this in paralllel?

 * Data-wise, this looks a bit like a join. We need to match items in one
   input with items from another.
 * From the join types we've looked at, it also looks a bit like the
   map-only case with one large file. We want to give the vector to all
   nodes and use the matrix as the input file.
 * That's one solution: Distribute the vector and handle the matrix by rows.
 * This requires distributing the whole vector to each mapper.

 * Another solution is to handle the matrix by columns and read only one value per
   column from the vector. 
 * This reduces input size by a factor of n.
 * But it increases output size by a factor of n - every output is a column vector.

