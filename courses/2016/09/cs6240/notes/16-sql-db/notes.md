---
layout: default
---

# Map Reduce: SQL Databases

## Project Annoucement

 - Teams of 2
 - Competition: Extra credit for top performance

## Homework Questions?

## SQL Databases

 - Small to Medium data (fits on a hard drive)
 - Schemas
 - Query with SQL
 - Indexes
 - Updates
 - Transactions
 - Constraints

## Schemas

 - Data is organized in tables.
 - Columns of tables are named, typed fields.
 - Rows of tables are records.
 - This avoids parsing overhead, and allows for some type checking.

## SQL Queries

 - Ask for what you want.
 - Lots of people know some SQL.
 - Joins are a basic operation.
 - Hadoop cluster data can be queried using SQL with tools like Hive.

## Indexes

 - SQL databases can have indexes, which are data structures like hash
   tables or b-trees that allow specific rows in a table to be found in
   sub-linear time.
 - This allows individual records with specific keys (values in indexed 
   columns) to be found quickly.
 - This can speed up queries drastically when they don't need to scan
   entire tables.
 - It can occasionally be useful to build indexes (or caches) during Map-Reduce
   style programs using an external data store.

## Updates

 - The biggest conceptual difference between Hadoop style data access and a
   database is updates.
 - Data can be modified in place.
 - This allows for some applications that are infeasible without updates.
 - It also makes some calculations more efficient than they could otherwise be.
 - Unfortunately, allowing updates makes scaling to large datasets difficult or
   even impossible.

## Transactions

 - Databases allow concurrent access.
 - This means that any updates are writes to shared data.
 - To avoid the standard problems with data races, they need to guarantee that reads
   always see a valid overall state.
 - To enable this, they allow transactions - which group several operations into one
   atomic group.
 - Writes can be concurrent, so transactions sometimes fail if they read stale data as
   an input into their updates.

## Constraints

 - With schemas, updates, and transactions, it's useful to enforce specific rules about
   the data.
 - For example, we might have a rule that says that every row in the "accounts" table
   references an existing row in the "users" table.
 - Constraints guarantee that these rules hold. Transactions that try to break the rules
   fail.

## Scaling SQL Databases

 - Scaling for read-only workloads is easy: Just make as many copies of the database as
   you want and query one or more of these replicas at a time.
 - If the data doesn't fit on one machine, split it up into multiple shards. Read queries
   are then two steps:
    1. Figure out which shard to query.
    2. Query the right shard.
 - Everything breaks once you want updates. Since reads can be done from any replica at
   any time, all writes must be committed to all replicas atomicly. This means that writes
   are innately sequential.
 - The protocal needed to confirm writes on many nodes and fail the transaction if all nodes
   don't agree is complicated and failure prone.
 - Some databases support this model reasonably well, even understanding replicas and shards
   natively. For very read heavy workloads, this works well.
 - Optimizing writes breaks things. Basically, you lose transactions and constraints if you
   want performance. Databases tuned for this - called NoSQL databases - are next week's topic.

