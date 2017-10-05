---
layout: default
---

# Computer Systems

## First Thing

 - Questions on the Homework?

## Pipe Examples

 - show pipe0, pipe1
 - show fork-pipe

## Redirect Example

```
$ cat sample.txt > /tmp/derp.txt
```

 * Initial process: nush (pid 10)
 * Fork: Parent (pid 10)
   * Wait on child.
   * Print next nush prompt.
 * Fork: Child (pid 11)
   * Open /tmp/derp as FD #1 (stdout)
   * Exec cat with argv[1] = "sample.txt"

## Pipe Example

```
$ cat sample.txt | sort
```

 * Initial process: nush (pid 10)
 * Command contains pipe, so fork for the pipe.
 * After fork #1, child, pid 11:
    * Create a pipe P, with two ends.
    * Fork for cat
    * After fork #2, child, pid 12:
      * Hook up FD #1 as P[input]
      * Exec cat with argv[1] = "sample.txt"
    * After fork #2, parent: pid 11:
      * Fork for sort
      * After fork #3, child, pid 13:
        * Hook up FD @0 as P[output]
        * Exec sort
      * After fork #3, parent, pid 11:
        * Wait for pids 12, 13
        * Exit
 * After fork #1, parent, pid 10:
    * Wait on pid 11
    * Print next nush prompt

## General Shell Strategy

 - Read input line.
 - Tokenize input.
 - Check token array for pipe.
   - If there's a pipe, fork.
   - Split token list on pipe to get left and right token lists.
   - Fork to execute command left of pipe, recursively.
   - Fork to execute command right of pipe, recursively.
   - Wait for both children.
 - Check for built in commands.
   - Execute them.
   - Done.
 - Fork.
   - Check token array for redirect, if so, set it up and remove it.
   - Execute the command.
   - Wait for child.

