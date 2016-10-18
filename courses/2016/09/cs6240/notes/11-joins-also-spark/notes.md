---
layout: default
---

# Map Reduce: Joins and also Spark

## Homework Questions?

## Joins in Map-Reduce

### Equi-join

Easy. Mapper emits join key as key, reducer joins. Parallelizes fine.

    select * from players join hall_of_fame where players.playerID = hall_of_fame.playerID

### Equi-join + filter.

Still easy. Can filter in mapper.

    select * from players join hall_of_fame where players.playerID = hall_of_fame.playerID 
    and hall_of_fame.year >= 1950;

### Inequality join.

    select * from Ta, Tb where a > b.

This is hard. We need to do the join in the reducer. How can we parallelize?

 - Have one reducer.
 - Duplicate one input.
 - Sort Ta into known ranges. Duplicate Tb only to reducers where a > b for
   some a.


### Map-Only Join

 - Duplicate one input in all \*mappers\*. This is good if one data set
   is small enough to fit entirely in mapper memory.

### 

Given tables S and T, emit all records in S with a corresponding record in T.

(e.g. Show the names of all hall-of-fame members.)

 - Normal equi-join, just don't output T data.
 - Normal map-only / replicated join, just don't output T data.

Using a Bloom Filter:

 - A Bloom filter is like a HashSet, except approximate.
 - Idea:
   - Set up an array of booleans.
   - Use multiple different hash functions.
   - For each item in the set, hash it with each function and
     put true in the resulting buckets.
   - Lookup: Hash something with the functions. If all buckets are true, it's
             probably in the set.
  - Uses: 
     - In setup() in a map-only join, create bloom filter. This saves memory.
     - Create bloom filter with MR job, then perform semi-join with second job.
     - Note that bloom filters reduce nicely.

Bloom Filter Example:

 Table: 8 slots, numbered 0-7

 h1(x) = x % 8
 h2(x) = (2x + 1) % 8

 Set: 1 3 5 6

 1: Set 1, 3
 3: Set 3, 7
 5: Set 5, 3
 6: Set 6, 5

Check 4: Not in set
Check 7: Is in set

Bloom Filter False Postives: (1-e^(-kn/m))^k
k = number of hashes
m = number of buckets (bits)
n = number of items

So expected false postive rate for the example is about 40%.


## Introducing Spark

Show two Spark examples.


