---
layout: default
---

# Computer Systems

## Homework Questions?
 
## Slides

 * Finish out the slides. We're starting @ deletes with journaling.

[Christo's FS Slides](http://www.ccs.neu.edu/home/ntuck/courses/2018/09/cs3650/notes/00-Spring/20-file-systems/10_File_Systems.pptx)

## RAID Modes

Disks can be slow, and sometimes disks fail.

Using multiple disks configured in a RAID (redundant array of inexpensive disks)
it's possible to work around these problems.

Common modes:

 * RAID-0: Striping.
   * Uses 2+ disks to improve performance.
   * Blocks are written to alternating disks.
   * Large reads and writes can happen in parallel.
   * N disks store N disks worth of data, with a speedup of N.
 * RAID-1: Mirroring.
   * Stores the same data on 2 or 3 disks to improve reliability.
   * If one disk fails, you still have the data on the other one.
   * Since large reads can happen in parallel (picking different blocks from
     different copies on different disks), this can speed up reads by the number
     of mirrors.
   * N disks store N/2 data allowing one failure or N/3 data allowing two
     failures.
 * RAID-10: Stripe + Mirror
   * Build a RAID-0 array out of RAID-1 arrays.
   * Allows an N/2 speedup and the loss of one disk.
 * RAID-4: Parity
   * Mirroring many disks is expensive - half your disks are just for
     redundancy.
   * RAID-4 instead uses one disk for parity (e.g. the XOR of the data on the
     other disks). If a disk fails, the data on it can be recalculated from
     the data on the other disks and the parity data.
   * This allows N disks to store N-1 disks worth of data and still handle one
     failed drive without data loss.
   * Problem 1: Writes are limited by the parity disk.
   * Problem 2: The parity disk gets hit hard.
   * Problem 3: Writes require reading all disks to calculate parity, unless the
     blocks are cached.
   * RAID-4 is sometimes used in practice with a fast disk (e.g. an SSD) as the
     parity disk and slow disks as the data disks.
 * RAID-5: Distributed Parity
   * RAID-5 is just like RAID-4, except the parity blocks are spread evenly
     across all the disks.
   * Again, N disks store N-1 data and allow one failure without data loss.
   * A random write hits two disks (data + parity), but different disks each
     time.
   * Reads can be distributed like RAID-0 for an (N-1) speedup.
   * Writes can be distributed like RAID-0, but to two disks, so you get an
     (N/2) speedup.
 * RAID-6: Duplicate distributed parity.
   * The nightmare of RAID-5 is this:
     * A disk fails
     * You swap it out for a second disk
     * You start the rebuild of the array, which requires reading every
       block of every disk.
     * This either causes or exposes a second disk failure.
     * You can only handle one disk failure, so you lose all your data.
   * In RAID-6, you use two disks worth of space for parity. This is a bit more
     complicated than XOR, but it allows two disk failures without data loss.
   * RAID-6 is pretty common in large storage arrays - 12 disks with a 10-disk
     data capacity, a 10x speedup on reads, a 4x speedup on writes, and the
     ability to handle two failures is pretty great.

## Copy on Write Filesystems

In 2005, Sun Microsystems released a new filesystem for Solaris (their UNIX OS)
called ZFS.

ZFS is built on the ideas from Log Structured filesystems and persistent
immutable data structures from functional programming.

Core ideas:

 - The whole filesystem is one big tree.
   - The root of the tree is the root directory.
   - Directories use B-trees to map file names to inodes.
   - Inodes can use B-trees to map data block numbers to data blocks on disk.
   - Data blocks are the leaves of the tree.
 - Trees can be implemented as immutable persistent data structures.
   - Notes in the tree are immutable - they can't be changed once created.
   - To change the tree, you create a new version.
   - Writing means reading the disk block, making the changes to a copy in
     memory, and writing the new version as a new disk block. So "copy on
     write".
   - This means a new version of some node in the tree, and then new
     versions of all the ancestors of the node up to the new root.
   - (draw a persistent binary tree, show update with new root)
   - Old nodes are eventually garbage collected.
 - This has some advantages:
   - All operations are atomic. The old root remains valid, and the update
     only occurs when the new root is written.
   - Old versions of the complete filesystem can be kept around as snapshots.
     If you mess up the system, you can always roll back the entire filesystem
     to a previous version.
   - If you want to undelete a file, the old version is potentially still there
     and you can traverse from an old root to find it.

ZFS also added some additional features:

 - Per file checksums, which allow data corruption to be detected.
   - Disks sometimes mess up and write bad data or use undetected bad blocks,
     being able to detect this is extremely useful.
 - Built in RAID-style redundancy modes for multiple disks.
   - Mirroring (write two copies of each tree node to each device).
   - RAID-Z: Provides RAID-5 or RAID-6 style parity.
   - Combined with checksums, this can allow file corruption to be fixed.
   - Having this built in to the filesystem lets it do some stuff more
     efficiently than traditional RAID systems, like adding disks.
 - zfs send: Allows snapshots to be efficiently sent from one machine to another
   over the network. This is great for backups and for creating replica
   machines - without worrying about where a tarball of your entire filesystem
   will fit.

ZFS probably should have taken over the world, but there were some
complications:

 - Sun released it as open source, but with a license that prevents it from
   being included in the Linux kernel.
 - Sun got bought out by Oracle, who have effectively killed off Solaris.

It's still one of the nicest filesystems out there, and can be used on several
different OSes:

 - Currently, ZFS is excellent on FreeBSD.
 - ZFS-on-Linux provides a loadable kernel module for ZFS on Linux.
   - This is likely to be legal.
   - This is well supported on Ubuntu.
   - This sort of externally maintained module can be awkward when
     it gets out of sync with Linux kernel releases.
 - ZFS apparently can be used on Mac.

Modern filesystems are tending to look like ZFS:

 - BTRFS is a ZFS clone, initially written by Oracle, that's provided by default
   in the Linux kernel.
   - It has most of the same features.
   - Simulated RAID-5/6 is still considered unstable.
   - Progress has been slow in making it quite as complete or mature as ZFS
   - I've been running it for years, works great for desktop and light-use 
     server systems.
 - Apple's AFS provides a subset of the ZFS features: snapshots and metadata
   checksums. It doesn't provide any native multi-disk support. This is standard
   on new Apple devices.
 - Microsoft's ReFS is available on Windows Server, but not on consumer desktop
   versions of Windows. It has multi-disk support, data and metadata checksums,
   and snapshots (but not the ability to write to C-O-W copies of snapshots).

Copy-on-write filesystems can be slow for some use cases, especially storing
things like databases and file system images that have their own layers for
versioning and crash resistence.


