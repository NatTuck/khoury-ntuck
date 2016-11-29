---
layout: default
---

# Map Reduce: SQL Databases

## Exam Results



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

    create table salaries (yearID string, teamID string, lgID string, playerID string, salary integer);
    .mode csv
    .separator ","
    .import 'baseball/Salaries.csv' salaries
    select * from salaries limit 5;
    select playerID, (salary / 1000) from salaries limit 5;

## SQL Queries

 - Ask for what you want.
 - Lots of people know some SQL.
 - Joins are a basic operation.
 - Hadoop cluster data can be queried using SQL with tools like Hive.

    create table college (playerID string, schoolID string, year integer);
    .import 'baseball/CollegePlaying.csv' college
    select schoolID, max(salary) as msal from salaries, college where salaries.playerID = college.playerID group by schoolID order by msal desc limit 10;

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

    create index spid on salaries (playerID);

## Updates

 - The biggest conceptual difference between Hadoop style data access and a
   database is updates.
 - Data can be modified in place.
 - This allows for some applications that are infeasible without updates.
 - It also makes some calculations more efficient than they could otherwise be.
 - Unfortunately, allowing updates makes scaling to large datasets difficult or
   even impossible.

    $ sqlite3 /tmp/sal.db
    create table salaries (year integer, teamID string, lgID string, playerID string, salary integer);
    .mode csv
    .separator ","
    .import 'baseball/Salaries.csv' salaries
    update salaries set salary = 10 where year = 1985 and playerID = 'hubbagl01';

## Transactions

 - Databases allow concurrent access.
 - This means that any updates are writes to shared data.
 - To avoid the standard problems with data races, they need to guarantee that reads
   always see a valid overall state.
 - To enable this, they allow transactions - which group several operations into one
   atomic group.
 - Writes can be concurrent, so transactions sometimes fail if they read stale data as
   an input into their updates.

    shell1$ sqlite3 /tmp/sal.db
    begin;
    update salaries set salary = salary + 10 where year = 1985 and playerID = 'hubbagl01';
    # wait
    commit;
   
    shell2$ sqlite3 /tmp/sal.db
    begin;
    update salaries set salary = salary + 10 where year = 1985 and playerID = 'hubbagl01';
    # wait
    commit;
    

## Constraints

 - With schemas, updates, and transactions, it's useful to enforce specific rules about
   the data.
 - For example, we might have a rule that says that every row in the "accounts" table
   references an existing row in the "users" table.
 - Constraints guarantee that these rules hold. Transactions that try to break the rules
   fail.
 - No example. sqlite3 doesn't really do constraints

## Scaling SQL Databases

 - Scaling for read-only workloads is easy: Just make as many copies of the database as
   you want and query one or more of these replicas at a time.

Draw picture of replicas: This increases performance for *any* read.

 - If the data doesn't fit on one machine, split it up into multiple shards. Read queries
   are then two steps:
    1. Figure out which shard to query.
    2. Query the right shard.

Draw picture of shards. This increases storage, and performance for *disparate* reads.

Shards break joins; shards break constraints.

 - Replicas break once you want updates. Since reads can be done from any replica at
   any time, all writes must be committed to all replicas atomicly. This means that writes
   are innately sequential.
 - The protocal needed to confirm writes on many nodes and fail the transaction if all nodes
   don't agree is complicated and failure prone.
 - Some databases support this model reasonably well, even understanding replicas and shards
   natively. For very read heavy workloads, this works well.
 - Optimizing writes breaks things. Basically, you lose transactions and constraints if you
   want performance. Databases tuned for this - called NoSQL databases - are next week's topic.

 - "Cluster" SQL databases with moderately efficient writes do exist. There are a lot of tricky
   engineering tradeoffs, and none of them are efficient in all the cases that a simple sequential
   database can be efficient in.

## Query Optimizers

 - How do we do a select? Index? Sequential scan?
 - How do we do a join? Nested for loop (n^2)? Select from one table then use index?
 - Optimizer can significantly improve performance.
 - Spark Data Frames take advantage of same ideas.


