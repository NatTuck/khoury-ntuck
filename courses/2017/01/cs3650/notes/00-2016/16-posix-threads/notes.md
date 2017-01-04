---
layout: default
---

# CS3650: POSIX Threads

## First Thing

 - Homework Questions?

## Concurrency and Parallelism

 - We're used to multiple running processes.
 - Calling "fork" starts a process, and that process runs concurrently
   with other processes on the computer.
 - If we have multiple processor cores, multiple processes can run in
   parallel.

That's two different words.

 - Concurrency: Two (or or more) tasks need to happen, and we don't know
     or care what order they happen in. If the first task to be started is
     slow, a second - faster -task is allowed to finish first.
 - Parallelism: We have hardware resources that allow parallel execution.
     This means two tasks can be started and executed at the same time.

On modern multi-core computers, processes provide us with both concurrency and
parallelism. Let's look at an example: A Web Server

### Sequential Web Server

 - A web server program is running on a single-core machine with a single
   process.
 - Alice requests an unpopular 100 MB file.
 - Immediately after, Bob requests a popular 10 KB file.

Things will probably happen in this order:

 1. The operating system gets the network connection from Alice and forwards it
    on to the web server. 
 2. The operating system gets the network request from Bob, but the web server
    is busy, so it adds the request to a queue.
 3. The web server opens the file Alice requested and starts reading and sending
    data back to Alice. This takes a while, and the server spends most of it's time
    waiting on disk I/O.
 4. Eventually, the web server finishes sending the file to Alice and requests another
    incoming connection from the OS.
 5. The OS gives the web server Bob's connection. 
 6. The server sends Bob's file. This goes quickly, since Bob's file is popular and was
    already in RAM in the OS's disk cache.

Problem: Bob's fast request is stuck waiting for Alice's slow request to finish.

### Forking Web Server

An improvement to this system is the way the Apache webserver worked in the
late 90's. Instead of having the main server process respond to requests, it
would fork off a new process to handle each incoming connection. 

Alice and Bob's connections would go something like this.

 1. The operating system gets the connection from Alice and forwards it to the server.
 2. The server forks off a process to handle Alice's request.
 3. The operationg system gets Bob's connection and gives it to the server.
 4. The server forks off a process to handle Bob's request.
 5. Alice's server process starts reading her file and blocks on disk I/O.
 6. Bob's server process sends him the file and exists.
 7. Some time later, Alice's process is done reading and sending the file and exits.

This method works pretty well, and was the way the most popular web server
worked right when the web took over the world. When multiple-processor server
systems became popular, this scaled beautifully - the separate processes
parallelized perfectly to multiple cores.

There's a couple problems though:

 - fork() isn't free. Even once you have copy-on-write, you still need to copy
   the page tables and all the pages that get written to. This web server
   design resulted in Linux having the fastest fork() implementation around, but
   it's still slower than not forking. 
 - Switching between processes isn't free. Minimally, as we've seen, every
   process switch required flushing the TLB.
 - Even with copy-on-write and shared memory for code, every process takes some
   memory. Each Apache process back then took several megabytes on machines a couple
   hundred megs of RAM.

This last problem was the most obvious. You could easily make a machine run out
of memory by making a hundred or so simultaneious requests.

Apache solved that by providing a process limit, generally 20-50 concurrent
processes at a time. Any requests after that would go in the queue.

There's a neat denial of service attack that exploits this - called Slow Loris
- that can still break Apache servers today. The idea is that you open enough
  simultanious connections to hit the limit and then keep them open as long as
possible. HTTP requests can be as big as 1k - Slow Loris just sends them one
character every 10 seconds or so.

### Enter Threads

 - Threads are a way to have multiple concurrent flows of execution within a
   single process.
 - Each thread gets its own stack and requires a small amount of data in the
   kernel, but all the threads in a single process share most of their stuff.

Stuff threads share:

 - An address space, and thus the page table.
 - Code
 - The heap (usually)
 - The file descriptor table

Threads were implemented on Linux late. The kernel had been structured to
assume processes were the scheduling unit, and both fork() and shared memory
worked well. Until Linux 2.6 in 2003, threads were just normal separate
processes with a hack to share an address space - each thread had its own pid.

For comparison, proper threads were introduced for Windows in Windows 95. On
the other hand, windows doesn't have fork() and CreateProcess is still pretty
slow today.

A common variant is cooperative threads: Run sequentially until you either
explicitly call yield() to schedule a different thread or yield implicitly by
making a blocking call (e.g. I/O or sleep). These are - to some extent -
concurrent but they can't be run in aparallel. Threads in Windows 3.1 or Python
work this way.

### Threaded Apache

Apache eventually moved to threads instead of processes as its default model.
They're faster to start, cheap to switch between, and use less RAM.

Slow Loris still works. If the process limit was 50, the thread limit is
probably 150.

More "modern" web servers use a combination of threads and explict logic to
interleave the handling of multiple requests in a single thread. This is
complicated business and easy to mess up, but people care enough about
webservers to have done it.

### POSIX Threads

The API for threads on Linux (and other Unix-like systems) is POSIX threads.

    #include <pthread.h>

 - Start a thread with pthread\_create
 - Wait for it to finish with pthread\_join
 - Link your program with -lpthread

*Let's take a look at that.*

There's an alternative to pthread\_join: pthread\_detatch. If you call this, you're
telling the system that you never plan to join on this thread. You either don't care
when it finishes, or you plan to deal with that some other way. 

 - When your main thread finishes (return from main, exit()), your program ends.
 - Stack size: Default 2MB. Doesn't auto-grow. 

More stuff to look at:

 - Check out the manpages for pthread\_create, pthread\_attr\_init and the various
  pthread\_setattr\_* calls. 


