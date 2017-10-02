---
layout: default
---

# Computer Systems

## First Thing

 - Questions on the Homework?

## More Shell Examples

    sort # type stuff into stdin
    sort < file # redirect from file
    sort > file # redirect to file
    sleep 2 # wait
    sleep 10 &   # don't wait, show ps
    sleep 10 # ctrl+Z, fg
    sleep 10 # ctrl+Z, bg
    sort | uniq # pipe
    true
    echo $?
    false
    echo $?
    true && echo good
    true || echo good 

## System Calls in C

 - Hello -> Hello-fio -> Hello-sysio
 - man 2 open
 - man 2 close

## Processes

 - A running program is a process.
 - Each process has:
   - A process ID
   - A user ID (who owns this process)
   - Its own virtual address space
   - A table of open file descriptors.
   - (A bunch of other state.)
 - When the computer boots, there's one process (init, pid = 1)
 - Every other process is created by fork(2)

## Fork & Exec

 - draw a picture
 - man fork
 - man execl
 - fork - copy the current process
 - exec - replace program in the current process with a new one

## Fork Examples

 - show fork1, fork2, etc.
 
## Program Loader

 - Exec loads a program from disk and overwrites the current program.
 - This means building a fresh virtual address space.
 - The binary is in ELF format, which is laid out something liek this:
   - ELF Header
   - Segments table
   - ... stuff to load ...
   - Sections table
 - The stuff to load consists of:
   - Many segments.
   - Each containing many sections.
 - Each section or segment can have specific access flags (e.g. read-only)
 - Possible layout:
   - read only section
     - .text
     - .rodata
   - read/write section
     - .data
 - Segments mostly exist for historical reasons.
 - Sections are the relevent part on modern systems.
   - Each sections has type, address to load data to, size, offset in binary, flags
   - The loader just copies the sections to the right spot in memory and sets the
     memory permissions for that memory range.
 - Once the loader is done, it basically just does a JUMP (address of .text section).

## Pipe Examples

 - If there's time.

