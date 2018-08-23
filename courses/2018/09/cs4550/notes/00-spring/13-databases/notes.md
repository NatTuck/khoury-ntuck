---
layout: default
---

# First: HW Questions?

# Databases

The goal: Long-term Persistent State

## Plan A: Files on the Filesystem

 - The normal way to store long-term persitent data on a computer
   is by saving a file.
 - Files are a reasonably efficient method of mapping heirarchical string
   keys to arbitrarily large chunks of data.
 
Problems:

 - Opening files is a bit slow - it takes syscalls and needs to maintain
   POSIX semantics.
 - Concurrency isn't handled by default = data races.
 - Solving these two things results in building a key-value store.
 - Scales poorly beyond one machine. Network filesystems are a huge pile
   of bad compromises.
   
**Walk Through Solving Microblog**

## Plan B: Key-Value Store

This is a library or service that stores values associated with keys.

Minimally, has two operations: get and put

Advantages:

 - Can optimize actions without conforming to the requirements for file
   operations.
 - Can enforce atomic get and put, but also atomic read-modify-write
   (e.g. with per-key locks).
 - Can be made to scale easily with key-based sharding.
 - Can be made redundant with m-of-n replicas.

Disadvantages:

 - Multi-key operations usually aren't atomic (= data races).
 - Efficient and powerful queries can be difficult, especially
   joining data between separate records.
 - Can't get all the guarantees you really want for reliability,
   especially data consistency across multiple resources.

**Walk Through Solving Microblog**

## Plan C: Relational Database

A Relational Database Management System, or SQL Database, splits data up into a
set of tables, specifies a query language (SQL), and provides "transactions",
which offer a set of guaranteed reliability properties.

Examples:

 - PostgreSQL
 - MySQL / MariaDB
 - Oracle
 - Microsoft SQL Server
 - SQLite

ACID:

 - Atomic: All transactions - operations that mutate data in the database - are
   atomic, even if several records in different tables are effected.
 - Consistent: All queries see the data in a consistent state - each transaction
   has either happened or not. Transactions appear to be applied in some
   globally consistent sequential order.
 - Isolation: Queries don't see the result of transaction until those
   transactions are guaranteed to have successfully completed.
 - Durability: Once an transacton is successfully completed, even power loss
   won't unexpectedly undo it.

Advantages:

 - We want the ACID properties. They're really nice, especially if we care about
   our data at all.
 - SQL DBs validate schemas, including foreign key constraints. They protect us from
   ending up with an inconsisant (corrupt) database.
 - Foreign key references make join queries possible.
 - Transactions apply to mutation of multiple tables.

Disadvantages:

 - Scaling to multiple machines is hard. SQL databases largely can't handle
   write operations on multiple DB servers.
 - Providing a bunch of guarantees costs performance.
 - Schemas are mandatory and changing them is annoying.
 - Is innately pretty complicated.

**Scaling SQL Databases:**

 - First, buy a bigger server. They scale nicely with multiple cores.
 - Next, add read-only replicas that handle read requests. This can scale pretty far.
 - After that, you're stuck with either:
   - Cluster solutions, which are all annoying (e.g. require all data in RAM).
   - Manual sharding across multiple servers which loses you some transaction
     atomicity.

## NoSQL

NoSQL is the name for the broad idea that getting rid of features from SQL DBs
results in a useful datastore.

Generally these systems don't use SQL as the query language, and they don't
provide the ACID data reliability guarantees. 

### Example 1: Memcached

 - An in-memory string key to blob value data store.
 - For caching.
 - Can do key-based sharding to scale perfectly.
 - Doesn't care about losing data, it's primarily a cache.
 - Users: This makes a good chunk of the web go.

### Example 2: Redis

 - String key to structured value (e.g. list, hash table, score-based ordered set, etc)
 - Doesn't cluster.
 - Operations that make sense on values (e.g. list prepend) are very efficient.
 - Data can be persisted to disk occaionally, but without hard guarantees.
 - Users: Commonly used for stuff like queues & small caches.

### Example 3: Riak KV

 - String key to BLOB value
 - Replication: Writes are duplicated to several (N) nodes - all of which must
   complete for a write to be correct - reads can be from any of the replicas.
   This implies key-based sharding.
 - This scales OK for writes and great for reads, but loses availability in case
   of a network partition.
 - Eventually synced to disk.
 - Map-Reduce Indexes
 - User: Uber (car dispatch)
 
### CAP Theorem

 - Consistency: All reads complete in finite time and always return the latest value.
 - Availability: All writes complete in finite time.
 - Partition tolerance: The system can handle having the nodes partitioned into
   two groups that can't communicate for an unbounded amount of time.
   
You can only have two of the above 3 properties.

Proof: Consider a data store with two nodes (A and B) that currently can't
communicate due to a netsplit. We do a write to node A and then read the same
key from node B.

The system must, before the netsplit is resolved:

 - Accept the write to A in order to maintain availablility.
 - Respond to B with the value written to A in order to maintain consistency.

### Example 4: CouchDB
 
 - JSON Document Store
 - No transaction guarantees
 - Eventual Consistency by Versioning 
 - Nodes can write without permission, so scales very well.
 - Eventually synced to disk.
 - Map-Reduce Indexes
 - User: This is where NPM package metadata is stored.

Offline support:

 - You can put a CouchDB node on a client (e.g. a phone). This allows
   offline app usage.
 - You can put a PouchDB node on a user's browser. This does the same
   thing.
 - Of course, you'd only want to store docuemnts for that user on their
   local node.

### Example 5: MongoDB

 - JSON Doucument Store
 - Sharding by key
 - Replicas: Default majority read & write
 - Optional schemas, which enable limited join queries.
 - Schema-based indexes.
 - Eventually synced to disk.
 - Bad reputation:
  - Hyped as an SQL replacement, isn't one.
  - Broken data model: Can get multiple versions of the same document on query during update.
 - Users: Ebay (media metadata)
 
### Example 6: Cassandra

 - Cassandra is a lot like a SQL database without ACID transactions, so that it
   can do replication and sharding instead.
 - Query language is almost SQL
 - Column store: Table columns are stored together in memory; efficient for
   queries that don't access all columns.
 - Cassandra guarantees durability.
 - Replicas: Default majority read & write, configurable
 - Users: Netflix (shows)
 
