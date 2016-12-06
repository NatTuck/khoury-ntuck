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

The general idea of NoSQL databases is to give up the absolute consistency of
transactions from SQL in favor of better performance, especially for data big
enough to not fit on / get decent query performance out of one machine.


## The CAP Theorem

When we build a database system distributed across many computers, there are
three properties we'd really like to have:

 - Consistency: Reads give you the right data.
 - Availability: You can always do a read or write in bounded time.
 - Partition Tolerance: You can cut the cluster in half and everything
     still works on both sides of the cut.

If you're clever, you can build a system with two out of three. No system can
do all three. Trivially, if a partition has occured, you can't read consistent
data on one side of the partition if a write has occurred on the other. You
could block the read or write until the partition is fixed, but that'd violate
availability.


## Key-Value Store

The most basic type of NoSQL database is a key-value store. Generally, these
map a string key to arbitrary string data, like a big HashMap[String, String].
The implementation tends to be a "Distributed Hash Table", which is a neat bit
of technology worth googling.

Because the data is stored on a cluster, you generally want to survive machine
failures. This is handled by data replicas. Rather than storing each record
once, you instead store it several times. If you store each record on three
nodes, then any two nodes can fail without data loss. This can also speed up
reads - any of the three nodes can respond to a read request.

The values stored in a K-V store are generally big enough that you can store
complex data using string serializeation (e.g. JSON). But the K-V store has no
idea what the value means: value serialization, deserialization, and processing
is entirely up to the application.

Assume we have 3 replicas per key-value pair.

"Eventual Consistency":

If reads and writes each require 1 replica to respond, then we've given up
consistency. You may write to replica A then read from replica B, and the read
will get old data. Availibility is pretty good - access to any one replica
allows reads and writes.

Once you've written to one replica, the system will automatically replicate the
write to the others. Usually this takes only a few miliseconds, which is an
acceptable window for old data in many applications. In the presence of
partitions, there's no guarantee that this will happen in a reasonable amount
of time - but it will happen "eventually".

"Strong Consistency":

If reads and writes each require 2 replicas to respond, then we have
consistency. If you do a write, it'll update 2/3 replicas. Any subsequent read
will have to talk to a replica with the latest data. This loses availability.
If the cluster is partitioned, only one side of the split will have access to
the required 2/3 to do a read or write.

An example of a K-V store that works exactly like this is Riak.


## Document Stores

If you're storing JSON in your K-V store, then there are a couple of benefits
you can get from building support for JSON into the database itself. Systems
like this are called Document Stores.

JSON (or, equally, XML) document support gives you:

 - Field based queries. You can scan for a document where the key "foo" has the
   value "bar".
 - Indexes. You can build secondary indexes based on the contents of the documents.

An example of a JSON document store is CouchDB. In CouchDB, indexes are added
by creating a JavaScript function that maps a JSON document to a string.
Whenever a new document is added, it runs this function to find the secondary
index key for the document.


## Column Stores

A column store adds schemas to the basic K-V store design. Instead of a single
value being associated with a key, a key gives you access to a whole row of
values.

Internally, this is implemented as key-value store per column, with the system
handling each column having its own type. This has some efficiency advantages
over the RDBMS strategy of storing rows together, especially if queries that
select only some fields of a "table" are common.

Example: Apache Cassandra

Cassandra uses a language that's basically SQL for queries, and provides the
same concept of replicas and consistency / performance tradeoffs of a K-V store.


## K-V Store for Index Join in Map-Reduce job

Joins in Map-Reduce can be inefficient, especially if you're doing multiple
joins to a small portion of a dataset.

If you load the dataset into a K-V store in one map-only job, then it's easy to
do joins to that dataset in further map-only jobs. This is pretty similar to an
index join in an RBDMS, using the K-V store as the index.

