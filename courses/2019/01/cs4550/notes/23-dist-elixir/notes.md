---
layout: default
---

# First: Project Questions?

Presentations:

 - Both classes next week
 - Random teams will be selected to present each day
 - There will be a peer-evaluation component.
 - You need to show up both days.

# Today: Distributed Elixir

 - The Erlang VM was designed primarily for building reliable apps, even in the
   face of hardware failure.
 - That means redundant hardware, and means that the application state needs to
   be stored replicated across those machines.
 - So Erlang has a built in mechanism to form a distributed cluster of multiple
   Erlang VMs, possibly distributed across multiple machines, and allows message
   passing between processes within the cluster.

Simplest example, in two terminal windows:

```
   # Window 1
   $ iex --sname foo
   iex> node()
   
   # Window 2
   $ iex --sname bar
   iex> Node.ping(:foo@greyarea)
   iex> Node.list()
   
   # Window 1
   iex> Node.list()
   iex> hello = fn -> IO.puts("Hello") end
   iex> Node.spawn(:bar@greyarea, hello)   # Remembers source node for I/O.
   iex> Node.spawn(:bar@greyarea, fn -> IO.puts(node()) end) # Really on other node.
```

# Let's build a replicated Key-Value Store

```
$ git clone https://github.com/NatTuck/kv_store
$ git checkout 0-empty
```




