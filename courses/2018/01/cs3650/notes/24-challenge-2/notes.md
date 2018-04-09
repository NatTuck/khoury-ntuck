---
layout: default
---

# Computer Systems

## Challenge 2a Questions?

## Introducing Challenge 2b

For this assignment you will extend your filesystem so that it supports
transactional operations on single files.

The idea of transactions is as follows:

 - Files are a shared, global resource.
 - If the same file is opened twice concurrently and at least one accessor
   writes, we have a data race.
 - The data race is likely to result in either:
   - Our file gets corrupted by conflicting writes.
   - A reader gets disrupted by inconsistent reads.
 - The POSIX standards require this data race enabling behavior for our system
   calls; but we can build a non-standard filesystem.
 - ...

## Seperate open files: File Handles

## Implementing "Rollback"

- ioctl docs: /usr/include/asm-generic/ioctl.h
 - For each ioctl, stuff is encoded in the 32-bit ioctl #.
   - Direction of argument: (none, input, or output)
   - Size of argument: 14 bits.
- Rollback makes the FUSE cache no longer correct.
  - Need to set fi->direct_io on open.
