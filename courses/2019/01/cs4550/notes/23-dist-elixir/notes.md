---
layout: default
---

## First: Project Questions?

Presentations:

 - Both classes next week
 - Random teams will be selected to present each day
 - There will be a peer-evaluation component.
 - You need to show up both days.

Remember to do your TRACE evals. 

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

## Let's build a replicated Key-Value Store

```
$ git clone https://github.com/NatTuck/kv_store
$ git checkout 1-map-server
```

 * This is an Elixir app generated with "mix new ... --sup"
 * Show lib/kv\_store/map\_server.ex
 * Show the server getting started in applicaiton.ex

Demo:

```
  $ iex -S mix
  iex> alias KvStore.MapServer
  iex> MapServer.put(:a, 5)
  iex> MapServer.get(:a)
```

### Allow map updates from other nodes.

Add additional interface in map\_server.ex that include
the name of the target node.

You can generally replace a process PID or registered name with a tuple of
{pid/name, node-name} for any sort of sent message in elixir.

```
  def put(node, k, v) do
    GenServer.call({__MODULE__, node}, {:put, k, v})
  end

  def get(node, k) do
    GenServer.call({__MODULE__, node}, {:get, k})
  end
```

Two terminal windows again:

```
  # Window 1:
  $ iex --sname alice -S mix
  
  # Window 2:
  $ iex --sname bob -S mix
  iex> Node.ping(:alice@greyarea)
  iex> KvStore.MapServer.put(:alice@greyarea, :a, 5)
  
  # Window 1:
  iex> KvStore.MapServer.get(:a, 5)
  iex> KvStore.MapServer.put(:a, 7)
  
  # Window 2:
  iex> KvStore.MapServer.get(:alice@greyarea, :a)
```

## Let's automate cluster startup.

Add libcluster dep to mix.exs:

```
  defp deps do
    [
      {:libcluster, "~> 3.0"},
```

Run ```mix deps.get```

Add libcluster supervisor to application.ex

```
  def start(_type, _args) do
    topologies = [
      local: [
        strategy: Cluster.Strategy.Epmd,
        config: [
          hosts: [:node0@localhost, :node1@localhost, :node2@localhost]
        ],
      ],
    ]
    
    children = [
      {Cluster.Supervisor, [topologies, [name: KvStore.ClusterSupervisor]]},
```

Create a start script, local-start.sh

```
#!/bin/bash

export WD=`pwd`

cat > /tmp/tabs.$$ <<"EOF"
title: node0;; workdir: $WD;; command: iex --sname node0@localhost -S mix
title: node1;; workdir: $WD;; command: iex --sname node1@localhost -S mix
title: node2;; workdir: $WD;; command: iex --sname node2@localhost -S mix
EOF

konsole --hold --tabs-from-file /tmp/tabs.$$
```

Let's try this out:

```
 $ bash local-start.sh
 
 # In node0 tab:
 iex> Node.self()
 iex> Node.list()
 iex> KvStore.MapServer.put(:node2@localhost, :a, 5)
 
 # In node1 tab:
 iex> Node.self()
 iex> Node.list()
 iex> KvStore.MapServer.get(:node2@localhost, :a)
```

## Let's distribute the data.

We'll go with the simplest plan:

 - Writes go to all nodes.
 - Reads happen on any node.

Add get and put methods to lib/kv_store.ex:

```
defmodule KvStore do
  def get(k) do
    # Need one node, so grab the local copy.
    KvStore.MapServer.get(k)
  end

  def put(k, v) do
    nodes = [Node.self() | Node.list()]
    results = Enum.map nodes, fn node ->
      KvStore.MapServer.put(node, k, v)
    end
    if Enum.all?(results, &(&1 == :ok)) do
      :ok
    else
      {:error, "didn't write to all replicas"}
    end
  end
end
```

Let's try this version:

```
 $ bash local-start.sh

 # node0
 iex> KvStore.put(:a, 5)
 
 # node1
 iex> KvStore.get(:a)
 
 # node2
 iex> KvStore.get(:a)

 # Ctrl+C node0
 # node1
 iex> KvStore.get(:a)
 iex> KvStore.put(:a, 8)
 
 # node2
 iex> KvStore.get(:a)
 
 # restart node0 in new tab
 $  iex --sname node0@localhost -S mix
 iex> KvStore.get(:a)
 ... wrong answer
```

## Resync on recovery

 - We're replicating to increase reliability.
 - Good: When a node goes down, the other nodes still have the data.
 - Bad: When a node comes back up, it doesn't have the data.

Clearly, when a node comes back up, it should get the current state of the map.

Let's do that.

First, let's make our MapServer handle a :get_map message. This has no
public interface function since it's only used internally.

```
  @impl true
  def handle_call(:get_map, _from, state) do
    {:reply, state, state}
  end
```

Then, let's use that from the init function to sync state from any
existing node.

```
  @impl true
  def init(default) do
    # Get the map from all remote nodes.
    {replies, _} = GenServer.multi_call(Node.list(), __MODULE__, :get_map, 1000)
    if Enum.empty?(replies) do
      {:ok, default}
    else
      # All nodes have the current state, so we just take the first one.
      {_node, map} = hd(replies)
      {:ok, map}
    end
  end
```

The GenServer.multi_call function makes the same call to the same registered process
list of nodes. It returns the list of replies and the list of failures. Note that
we explicitly specify a timeout because there's no need to wait for slow nodes.

Let's try it:

```
 $ bash local-start.sh

 # node0
 iex> KvStore.put(:a, 5)
 iex> Ctrl+C Ctrl+C
 
 # node1
 iex> KvStore.get(:a)
 
 # new tab
 $  iex --sname node0@localhost -S mix
 iex> KvStore.get(:a)
```

So now we have a distributed key-value store that's resilient to node failure and
will behave correctly when a node leaves and rejoins.

## Running on a cluster.

Let's actually run it on a cluster of (virtual) machines.

I've got five virtual machines running remotely, named bot00 .. bot04.

First, we need to change our cluster topology in application.ex:

```
    topologies = [
      bots: [
        strategy: Cluster.Strategy.Epmd,
        config: [
          hosts: [:kv@bot00, :kv@bot01, :kv@bot02, :kv@bot03, :kv@bot04]
        ],
      ],
    ]
```

We've got the start of a script to push our code to the servers, but we need to
add one thing:

 - Show push.sh
 - Add the following lines:
 
```
# Erlang nodes must share a secret cookie in order to connect, to prevent
# distributed Erlang from having *no* security.
# This is not sufficient security to connect nodes over the public internet.
parallel -i ssh nat@{} rm ~/.erlang.cookie -- $HOSTS
parallel -i scp ~/.erlang.cookie nat@{}:~ -- $HOSTS
```

For testing, we can use the same strategy to start remote notes as local nodes.
Copy local-start.sh to remote-start.sh and edit it to:

```
#!/bin/bash

cat > /tmp/tabs.$$ <<"EOF"
title: bot00;; command: ssh nat@bot00 bash ~/kv_store/start.sh
title: bot01;; command: ssh nat@bot01 bash ~/kv_store/start.sh
title: bot02;; command: ssh nat@bot02 bash ~/kv_store/start.sh
title: bot03;; command: ssh nat@bot03 bash ~/kv_store/start.sh
title: bot04;; command: ssh nat@bot04 bash ~/kv_store/start.sh
EOF

konsole --hold --tabs-from-file /tmp/tabs.$$
```

Let's create that start.sh:

```
#!/bin/bash
killall beam.smp
(cd ~/kv_store && iex --sname kv -S mix)
```

Now push and run.

```
$ ./push.sh
$ ./remote-start.sh
```

And let's give it a try:

```
 # bot00
 iex> KvStore.put(:a, 1)
 iex> KvStore.put(:b, 2)
 
 # bot01
 iex> Node.list()
 iex> KvStore.get(:a)
 iex> KvStore.get(:b)
 
 # New terminal tab
 $ ssh nat@bot00
 bot00$ sudo reboot
 
 # bot01
 iex> Node.list()
 ... bot00 is gone
 iex> KvStore.put(:c, 3)
 
 # bot02
 iex> KvStore.get(:c)
 
 # New terminal tab
 $ ssh nat@bot00
 $ cd kv_store
 $ ./start.sh
 iex> KvStore.get(:c)
```

## What more could we add?

 - This app can store data, but there's no external interface. Maybe we could
   add a REST API with Phoenix.
   - Should every node be a web server?
   - Should the web server be one or more additional nodes?
   - We can use a load balancer to let this web service have one address that works
     even if a web server node goes down.
 - This should be deployed with a release and a systemd service so it's built in
   production mode and comes back when a server reboots.
 - There should be better automation than my simple scripts to deploy the app.
 - The current logic (data stored in a single genserver, writes to all, reads
   from one, resync only on start, no versioning) isn't an especially good
   datastore. If we want something better we could figure out the logic we want
   and build it.

