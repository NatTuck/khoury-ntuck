---
layout: default
---

# Map Reduce: Iterative Algos

## Homework Questions?

## Single Source Shortest Path

 - Draw on board.

In Map Reduce:
 - Job 1: Build graph from input.
 - Job 2:
   - Mapper broadcasts out links to their destination with best distance.
   - Reducer marks nodes with best distance seen.
 - Finish when goal has a distance. 

## k-Means

 - Set of points in n-space
 - Want to group into k clusters.

Plan:
 - Pick k random points as cluster centers.
 - Repeat until convergence:
   - Color each point with nearest cluster center.
   - Take new cluster centers as average of points in cluster.

In Map Reduce:
 - Job 1: Pick k random points, output to "centers".
 - Job 2:
   - Input: Original set of points.
   - Each mapper reads centers, outputs with key as cluster of nearest point.
   - Reducer calculates new centers for its cluster.
 - Repeat Job 2 until centers don't change much.
 - Job 3:
   - Read final centers list and actually mark points by cluster.


