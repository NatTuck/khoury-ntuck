---
layout: default
---

# Map Reduce: SQL Databases

## Project Questions?

## NoSQL Databases

SQL databases have some defining properties:

 - Fixed Schemas
 - Transactions
   - Work across tables
   - ACID

Supporting proper transactions is expensive. It either requires sequential
execution or it requires that multiple parallel processes "sync up" if they're
operating on potentially conflicting data.

If we aren't running a stock exchange, and we want better performance, it's
possible to give up some of these properties. 


## The CAP Theorem

When we build a database system distributed across many computers, 
there are three properties we'd really like to have:

 - Consistency: Reads give you the right data.
 - Availability: You can always do a read or write in bounded time.
 - Partition Tolerance: You can cut the cluster in half and everything
     still works on both sides of the cut.

If you're clever, you can build a system with two out of three. No system can
do all three. Trivially, if a partition has occured, you can't read consistent
data on one side of the partition if a write has occurred on the other. You
could block the read or write until the partition is fixed, but that'd violate
availability.


## Apache Cassandra

Cassandra is a good example for the discussion, because the interface it
provides is pretty close to SQL. It provides basic schemas and things that look
basically like tables.

Data is stored distributed (and replicated, for reliability) across a cluster
of machines. The number of replicas is user-configured, giving a tradeoff between
read performance, write performance, and failure tolerance. 

Cassandra gives you the option to chose between consistency and availability.
For reads and writes, the user selects how many replicas must reply to the
request.

Consider a cluster with a replication factor of 3.

 - If reads and writes each require 1 replica to respond, then we've given up
   consistency. You may write to replica A then read from replica B, and the
   read will get old data. Availibility is pretty good - access to any one replica
   allows reads and writes.

 - If reads and writes each require 2 replicas to respond, then we have
   consistency. If you do a write, it'll update 2/3 replicas. Any subsequent
   read will have to talk to a replica with the latest data. This loses 
   availability. If the cluster is partitioned, only one side of the split will
   have access to the required 2/3 to do a read or write.

If what you want is a distributed database, then Cassandra is a pretty good
option. It looks vaguely like an SQL database, and the choice between
availability and consistency is very clearly visible.

Cassandra is a "column store", like HBase.


## Key-Value Stores

Redis, Memcached, Riak, Voldemort

These are like a hash map with a network interface. They've got different
tradeoffs.


## Document Stores

MogoDB, Couchbase

Couchbase Deep Dive




## Graph DBs

Neo4J, etc.


