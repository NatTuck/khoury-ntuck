---
layout: default
---

# Computer Systems

 - Two more classes.
 - TRACE Evals - Do them.
 - Challenge 2a Questions?

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

## Non-Shared File Data

We can eliminate the data race by making the data no longer shared.

New plan:

 - Each file descriptor writes to a separate version of the file.
   - Copy on read? Copy on write?
 - Changes aren't externally visible until they are committed.
   - New behavior: close and fsync both commit their fd.
 - We can intentionally revert a file by performing a rollback.
   - This is a new FS op. We'll need to add it.
 - What if there are two confliciting writes?
   - Option A: Last write wins. 
     - Problem: Data is lost, nobody is told.
   - Option B: Files have version numbers. Any write must go from
     version n to version n+1, or it fails.
     - Advantage: Writer knows they failed and can retry.
     - Disadvantage: Now you really need to check that return
       value from "close(2)".
     - New behavior: This.

## Implementing "Rollback"

 - In Unix, everything looks like a file.
 - That includes hardware devices, like line printers or
   tape drives.
 - You write to a tape drive with the "write" syscall.
 - How do you rewind the tape?
   - Or eject a DVD from a DVD drive.
 - Unix allows custom ops on FS objects with "ioctl".
 - ioctl docs: /usr/include/asm-generic/ioctl.h
   - For each ioctl, stuff is encoded in the 32-bit ioctl #.
     - Direction of argument: (none, input, or output)
     - Size of argument: 14 bits.
   - Rollback makes the FUSE cache no longer correct.
     - Need to set fi->direct_io on open.

## Open

```
int
nufs_open(const char* path, struct fuse_file_info* fi)
{
    // Need to allocate a unique int per open file.
    // Then need some way to map fh -> open file.
    int fh = storage_open(path);
    int rv = 0;
    if (fh >= 0) {
        fi->fh = fh;
        fi->direct_io = 1;
    }
    else {
        rv = fh;
    }
    printf("open(%s) -> { fh: %d } %d\n", path, fh, rv);
    return rv;
}
```

## Close / Commit

```
// Flush is called on close, possibly more than once.
int
nufs_flush(const char* path, struct fuse_file_info* fi)
{
    int fh = (int) fi->fh;
    int rv = storage_commit(fh);
    printf("flush(%s) -> { fh: %d } %d\n", path, fh, rv);
    return rv;
}

// Release is called on close, once per open.
int
nufs_release(const char* path, struct fuse_file_info* fi)
{
    int fh = (int) fi->fh;
    int rv = storage_close(fh);
    printf("release(%s) -> { fh: %d } %d\n", path, fh, rv);
    return rv;
}
```

## Walk through the tests on the board.

...


