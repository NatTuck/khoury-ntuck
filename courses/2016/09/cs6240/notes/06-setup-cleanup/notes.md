---
layout: default
---

# Advanced Map-Reduce

## The Mapper

 - Mapper instance lifecycle.
   - Setup, foreach record: map, cleanup
 - Simulating combiners with in-map aggregation.
   - In-Map pros: Full control
   - In-Map cons: Memory usage; for very large input splits, combiner can
      potentially handle much larger chunks of data.

## The Reducer

 - Reducer instance lifecycle.
   - Setup, foreach key: reduce, cleanup
 - Not very useful with default partitioner.
 - More useful with custom partitioner, if keys sent to same reducer are related.

## The Partitioner

 - Range partitioning -- sorting
 - Secondary Sort
    - key comparitor (for sorting input to reducer)
    - grouping comparator (for selecting a reducer)

