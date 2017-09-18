---
layout: default
---

# Languages & Frameworks

 - Server-side code can be in pretty much any language.
 - Python / Ruby are familiar but slow.
 - C / C++ / Rust are fast but annoying.
 - C# or Java are kind of fast but kind of annoying. 
   They also use a lot of RAM.
 - JavaScript is a decent compromise, but we're not doing that.

Usually you don't just pick a language, you pick a language and
a framework (tooling/libraries for building a web app) together.

## Sequential vs. Parallel Programs

 - Most web frameworks are innately sequential.
 - You run a web server that handles requests in order.
 - Each request takes a few milliseconds
   - Sometimes more with complex DB queries
 - With a slow language you'll cap out at 25 reqs/second.
 - With a fast language and really efficient DB queries,
   maybe you'll get 250 reqs/second.
 - Some languages / frameworks have tricks.
   - nodejs is asynchronous, so it can intermix requests,
     preventing a couple slow DB queries from hurting the
     faster requests
 - Eventually you need to have multiple copies of the server
   running in parallel to handle more requests.
 - Now it's a distributed system. Hope you didn't make any bad
   assumptions that worked fine before but now are concurrency
   bugs.
   
But, there's a system that's built to be concurrent and distributed
by default...

# Introducing Elixir

 - There's a great language called Erlang that's been around since
   the late 80's.
 - It's a compiled-to-bytecode language with a VM like Java or C#.
 - It's heavily tuned for a couple of specific properties:
   - Reliability
   - Concurrency
 - Built for telecom switches, where "the service will be down for
   maintenence" is simply not OK.
 - Lightweight processes.
 - "Let it crash"
 - The semantics of Erlang are great.
 - High reliability and a focus on concurrency are *awesome* for web
   apps.
 - Erlang syntax is the absolute worst. You literally can't use 
   user-defined functions in an "if" condition.
   
 - Elixir is a language for the Erlang BEAM VM with the Erlang
   semantics but much less painful syntax.

## Similarities to ISL

 - Elixir is a lot like ISL from Fundies 1.
 - Functional language
 - Can't mutate data.
 - Can't re-assign variables.
 - Linked lists as core data type
 - No loop statements
 - Repeat by recursion
 - Loop functions: map, filter, reduce
 - Interactive REPL

## Features not in ISL

 - Non-LISP syntax
 - Seperate function / variable namespaces
 - Modules
 - Pattern matching
 - Multiple expressions per block
 - Side effects (like I/O)
 - Maps (associative arrays) are a core data type
 - Lightweight processes
 - send / receive 

Some elixir examples:

 - Fib
   - Compile Fib
   - Call Fib.fib from REPL (iex)
   - Pattern matching for functions
 - Fact
   - Accumulator pattern
   - Note tail recursion
 - RW
   - ElixirScript
   - Loop functions
   - Functions have module prefixes
   - Pipelines
 - Tick
   - Processes
   - IO (side effects)
   - Send / Receive
   - Pattern matching for control flow
   - Maps
   - Process with state pattern

# Introducing Phoenix

 - A web framework for Elixir
 - Design elements inspired by Ruby on Rails

# Create a Phoenix App

Create app:

```
mix phx.new nu_mart
```

Setup DB

```
$ sudo su - postgres
$ pwgen 10 1
[some password]
$ createuser -d -P nu_mart
Enter password: [some password]
Again: [some password]
$ exit # stop being the postgres user
```

Edit dev config (config/dev.exs)

```
config :microblog, Microblog.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "nu_mart",
  password: "[some password]",
  database: "nu_mart_dev",
  hostname: "localhost",
  pool_size: 10
```

Create db

```
$ mix ecto.create
```

Start the server.

```
# Kill the server, restart
$ mix phx.server
```

Check out http://localhost:4000/

Create Products resource

```
$ mix phx.gen.html Shop Product products name:string price:decimal desc:text
```

Add the suggested line to the router

We need a library for decimal numbers.

```
# Add to mix.exs: {:decimal, "~> 1.0"}
$ mix deps.get
```

Decimal requires settings in the DB schema.

```
$ vim priv/repo/migrations/*_create_products.exs
#     two digits after decimal place:
#     add :price, :decimal, precision: 12, scale: 2
```

Add the new table:

```
$ mix ecto.migrate
```

Try out the app

```
# Kill the server, restart
$ mix phx.server
```

Check out http://localhost:4000/products


<!--
## Deploy Our App

Edit the production config (config/prod.exs):

```
config :nu_mart, NuMartWeb.Endpoint,
  load_from_system_env: true,
  url: [host: "eagle.ferrus.net", port: 8000],
  server: true,
  cache_static_manifest: "priv/static/cache_manifest.json"
```

Do the deployment:

```
# Add to mix.exs: {:distillery, "~> 1.4"}
$ mix deps.get
$ mix release.init
$ MIX_ENV=prod mix release --env=prod
$ scp _build/prod/rel/nu_mart/releases/0.0.1/nu_mart.tar.gz nat@eagle.ferrus.net:~
$ ssh nat@eagle.ferrus.net
$ mkdir nu_mart
$ tar xzvf ../nu_mart.tar.gz
$ 
```
-->



