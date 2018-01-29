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
 - Primes
   - Make a project with mix new.
   - Stick code in lib/primes.ex
   - Write tests in test/
 - Markdown
   - New project.
   - ```{:earmark, "~> 1.2"}```
   - iex -S mix
   - Earmark.as_html
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




