---
layout: default
---

# Map Reduce: Joins and also Spark

## Homework Questions?

## RDD Operations

Actual Docs:
http://spark.apache.org/docs/latest/programming-guide.html

### Input / Output

 - sc.parallelize  // array -> RDD
 - sc.textFile     // text file -> RDD
 - xs.saveAsTextFile // RDD -> text file
 - sc.sequenceFile
 - xs.saveAsSequenceFile
 - sc.objectFile   // default Java serializeation
 - xs.saveAsObjectFile

### RDD[Record] operations.

 - xs.map          // RDD to RDD, function on each value
 - xs.flatMap      // Like map, but operation 
 - xs.reduce       // RDD to single value, function on two records
 - xs.filter
 - xs.take
 - xs.sample
 - xs.pipe         // Send data to a shell command, collect the results.
 - xs.collect      // RDD -> Array
 - xs.forEach      // Operate on each element with no result, for side effects

## Distributing Closures

    var n = 10
    var xs = ... some RDD
    
    var ys = xs.map( x => x + n )

Your Spark program runs sequentially on the "driver" node. Parallel operations are
sent to worker nodes to be executed. 

This means the lambda needs to be serialized and sent over the network.

Lambdas can access variables in the containing scope. The structure that stores the
lambda code and any "captured" variables is called a closure.

When the map line is executed, the current value for any captured variables is
broadcast to the worker nodes. So they have the value of x to execute the lambda.

When the lambda is finished on each worker, local copies of the captured
variables are discarded. This changes the semantics of Spark functions compared
to other higher order functions: Mutations to captured variables are lost.

This behavior doesn't show up in local execution. This means that code that
works locally may still be wrong.

### Broadcast Variables

For large values, resending the same value to multiple RDD operations as
a captured variable can be expensive. This operation can be performed manually
once with sc.broadcast().

    var xx = sc.broadcast(... anything ...)
    { => xx.value }

Values that have been broadcast should not be modified.

### RDD[(Key, Value)] operations.

Spark has special operations for the common case of an RDD of (Key, Value)
pairs (a PairRDD), allowing the RDD to be treated as if it were a Map of { Key
=> [List of Values] }.
 
 - xs.mapValues    // RDD to RDD, function on values only.
 - xs.reduceByKey  // RDD to RDD, multiple values for each key are combined to one/key.
 - xs.join(ys)     // Combine two RDDs so that (K1, V1), (K1, V2) -> (K1, (V1, V2))
 - xs.groupByKey   // Actually produces the RDD[(Key, List[Values])] data structure.
 - xs.sortByKey
 - xs.cogroup(ys)  // (K, V), (K, W) -> (K, List[V], List[W])
 - xs.collectAsMap // Return to driver process as map.

### Partition operations

When running on multiple machines, RDD data is partitioned across the worker nodes.

This is explicitly exposed in the RDD API, allowing you to select how the data
is partitioned and then operate on entire partitions.

 - sc.paralleize(array, NN) // RDD with NN partitions
 - mapPartitions            // List[RDD] -> List[RDD], operate on entire partitions
 - mapPartitionsWithIndex   // Like mapPartitions, but tells you which partition you're on

 - xs.partitionBy          // PairRDD shuffled according to partitioner

### Caching and Regeneration

 - xs.persist
 - xs.cache

### Accumulators

The one safe global operation in parallel Spark code is updating an Accumulator.
These are like global counters in Map-Reduce.

Get an accumulator:

 - acc = sc.longAccumulator("name")
 - acc = sc.doubleAccumulator("name")

Valid operations in parallel:

 - acc.add(same-type)

Note that many functional RDD operations are lazy, and so will not actually
occur until needed. This isn't a problem with xs.forEach.

Valid operations in driver:

 - acc.reset()
 - acc.sum
 - acc.count
 - acc.avg

Custom accumulators:

 - If you have a value that you want to accumulate by repeated application
   of an operation that is both associative and commutative, you can define
   a custom accumulator type.
 - Usually this isn't nessisary - you could have just used xs.reduce()


## Bloom Filter Join

Given tables S and T, emit all records in S with a corresponding record in T.

(e.g. Show the names of all hall-of-fame members.)

 - Normal equi-join, just don't output T data.
 - Normal map-only / replicated join, just don't output T data.

Using a Bloom Filter:

 - A Bloom filter is like a HashSet, except it may have false positives.
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


## Hall of Fame

 - Show bloom filter example.


