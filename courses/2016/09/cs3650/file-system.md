---
layout: default
---

# Building a Secure, Distributed File System

## Stage 1: Read Only, One Archive

 * Build a fuse filesystem that can mount a zip file read only
 * libfuse
 * libzip

## Stage 2: Read Only, Many Archives
 
 * Build a fuse filesystem that can mount a directory of many zip files read only
 * If multiple zip archives in the directory contain the same path, only the newest version
   of that file should exist in the mounted filesystem.

## Stage 3: Writes

 * Add write support.
 * Writes are done to files in a temporary shadow directory.
 * Occasionally, this cache directory is flushed.
    * The contents is archived into a new zip file
    * That archive is moved into the directory of tarballs.
    * The cache directory is cleared
    * Good times to flush might be on fsync() and close().

## Stage 4: Multiple readers / writers.

 * Make sure the implementation handles multiple mounts of the same directory of
   zip files at different locations by different processes.
 * This means that new zip files may be added to the directory at any time. This
   should work "as expected".
 * The zip files must be named to avoid collisions: 16 bytes read from /dev/urandom
   and used as a hex string (+ ".zip") makes a good file name.
 * Each writer process will need its own temporary shadow directory. 
   Maybe "~/.cache/${appname}/${pid}/"

We have no shared, writable data, but we're *simulating* shared writable data in
the form of any of the files on the filesystem.

 * What happens when two processes write to the same file at the same time?
 * Is this bad?
 * I'm not sure we can do much better, especially once we add network support.

## Stage 5: Attributes and Deletes

There are two clear problems at this point:

 * Storing Unix permissions in zip files is potentially annoying.
 * There's no way to support deletes.

Strategy to fix:

 * Put an index file next to each zip file ("${random}.idx" maybe)
 * The index file contains file names, file permissions, last modified timestamp, and a 
   deleted flag for each entry in the zip.
 * Readers can now find files using only the indexes. If the lastest version is a delete,
   the file isn't there.
 * On write, write the index file second. This guarantees that concurrent readers will be
   able to find the associated zip file.
 * Add a CRC64 checksum to the end of the index file. This lets readers ignore
   partially-written indexes.

## Stage 6: Network Support

This requires a server, and a new program to handle inter-machine syncing.

 * Set up passwordless SSH key auth on your CCIS account.

New program:

 * Saves its pid to "~/.cache/${appname}/sync.pid" as text.
   * Read first, quit and complain if there's a live process with the prev pid.
 * Every 5 minutes, or on SIGUSR1, runs rsync to sync the directory of zips with the server.
   * First, copy new files up to the server.
   * Next, copy new files down from the server.
   * Make sure rsync doesn't delete or overwrite anything on either end.
 * The filesystem program should SIGUSR1 the sync program on every flush.
 * Add a sync script that SIGUSR1's the sync program.

We now have a distributed filesystem. Running this on multiple machines should work,
although syncs could be delayed or need to be triggered manually.

## Stage 6: Garbage Collection

The current design will make a new copy of a file every time it's changed, and never deletes
anything. When a zip file contains only old versions of files, it can be removed.

But... we want to be careful that zip / index files aren't deleted before new versions have
propagated over the network.

 * Add a rmlog directory to the zip directory ("${zipdir}/rmlog/")
 * Roll a random 32-hex-digit identifier for each machine, save it to "~/.config/${appname}/boxid"

In the filesystem program:

 * After flush, scan the indexes for dead zip archives.
 * Log the dead zip archive to ("${zipdir}/rmlog/#{boxid}"), make sure this is an atomic append for
   local concurrency.
 * Locally remove the dead zip and index files.

In the sync program:
 
 * Before sync, check the rmlog and delete any locally-dead zip files on the server ("ssh rm ...")
 * Sync
 * After sync, check all other rmlogs and delete any now-dead zip files locally.

## Stage 8: Crypto

 * Encrypt zip files before moving them to the zip directory.
 * Decrypt on read.
 * Command line gpg with a new key is probably the laziest solution.

Problem: How to distribute the key to all machines sharing the file system?

# Advanced Version

## Stage 1: Block Cache

In the current filesystem design, reads are *slow* since they're unpacking a zip file every time.

Once we get some data once, we shouldn't have to reunzip to get it again. But, some files are big
and we'll reuse only small pieces. So we should have a *block* cache rather than a file cache.

Now's a good time to move to C++ if you haven't already.

 * Add a cache: Map[Path, Map[Block#, Data]]
 * Reads and writes should go to the cache first.
 * Flush cache to shadow directory when it gets big.

Problem: The cache can get out of date when concurrent writes happen.

Solution:

 * Use inotify to monitor the zip directory.
 * Invalidate appropriate non-dirty blocks when a concurrent write occurs.

Problem: What to do with dirty blocks?
 
 * Default: invalidate them too, they've been overwritten.
 * Alternative: Use file transaction semantics to try to preserve the
   "some consistent version" behavior.

## Stage 2: Efficiency

Here's where things get tricky.

In the design so far, small writes to large files are awful. They copy the
whole file locally and across the network on *every* write.

Real file systems deal with this problem by manipulating blocks instead of files, but that makes
the indexing problem way messier.

Here's an approach that almost works:

 * Store 4k blocks instead of files.
 * Write them to the shadow directory as "${filename}-${block#}"
 * Reads have to track down each block seperately.

We've made the problem from the block cache worse though: Two processes on different machines
can make concurrent, incompatible partial updates to a file. File corruption is pretty likely
at this point.

Probably should move away from zip files, and store both the blocks and the metadata
in a file-backed persistent B-Tree.

Start here for that:

https://www.youtube.com/watch?v=T0yzrZL1py0

