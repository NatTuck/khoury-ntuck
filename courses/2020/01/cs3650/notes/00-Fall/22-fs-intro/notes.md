---
layout: default
---

# Computer Systems

## Homework Questions?

We'll cover most of the relevent material today, but for getting started on HW10
you can also look at chapter 40 of the textbook.

### Hard Drives

Basic idea:

 - Hard drive is split up into 512B or 4kB blocks.
 - You access a block by its logical block address, from block 0 to whatever
   the maximum block number is.

Draw diagram

 - Platter (can have several)
 - Track
 - Read Head
 
Time for a request:

 - Move the head to the right track: 5-10ms
 - Wait for the platter to rotate to the right spot
 - Rotational latency: Time to rotate to the right block.
   * 7200 RPM = 4ms average (do the arithmetic)
   * 15k RPM  = 2ms average

 - Max transfer is maybe 150 MBPS
 - So 150 MB of sequential 4k blocks takes about a second
 - How long does it take to transfer 150 MB of random 4k blocks?
   * 6ms to move read head + 4 for disk = 10
   * 150M / 4k = 37.5k
   * So 375 seconds just for seeks.

Optimizing for HDDs:

 - Avoid seeks by avoiding random access
 
Technology Improvements:

 - The goal for persistent storage is NVRAM.
 - That'd be just like RAM, except you don't lose data when you power down.
 - SSDs are a step in that direction, but have some complications we'll talk
   about in a future class.
 - There's a bunch of other technology that gets even closer, but most of it
   isn't production quality yet.
 - The one exception is Intel Optane, which is a bit closer to the ideal of
   NVRAM than SSDs, but still not perfect.
   
## FAT Filesystem

Draw a directory tree:

 - C:\
   - BOOK\
     - CHAPTER1.TXT (800B)
     - CHAPTER2.TXT (1600B)
   - COMMAND.COM (2800B)

The year is 1994 and we've got a computer running 32-bit MS DOS.

The filesystem it uses is called FAT. Specifically, FAT-32.

We want to store a tree of filesystem objects.

Main kinds:

 - Files
 - Directories

For MSDOS, a directory is just a table with 

 - A Name (8 + 3 characters)
 - Type of object (file or directory)
 - Location of where the FS object starts (cluster #)
 - file size
 - other metadata (not much)

The file system is layed out in three sections:

 - Superblock (1 block)
   - number of clusters
   - cluster size
   - root directory ptr
- File Allocation Table
   - An array of 32-bit numbers, one per cluster (only 28 bits actually used)
 - Data clusters
   - Where the data actually goes

Data clusters are the minimum allocation size of disk space. They're
usually larger than one block.

Let's say we have a 101MB hard disk. That would have had a cluster
size of 1K, so we'd have 100K clusters.

Disk layout:
 - Superblock
 - FAT: 100K 32-bit integers = ~400KB
 - data: 100K 1k clusters = 100MB
 
Superblock: Root Dir @ 1

Root:

- BOOK (D) @ 2
 - COMMAND.COM (F) @ 3

Book:

 - CHAPTER1.TXT (F) @ 6
 - CHAPTER2.TXT (F) @ 7

FAT works like a linked list with two special values:

 - FREE
 - END-OF-LIST

Free clusters are found by scanning the FAT for FREE entries. This
could be kind of slow. Not too bad if you use a persistent pointer
and next-free - or if you just cache the whole FAT in RAM.

Fragmentation:

 - As files are added and deleted, the free space ends up being
   in non-consecutive clusters.
 - New large files fit, but are spread around the disk.
 - Traversing the FAT for non-adjacent large files is worst case
   for HDDs: you need to seek for both the blocks *and* for the
   linked list.
 - So "defrag" tools would move blocks around to make files
   consecutive again.

Maximum File Size:

 - FAT32 can't handle files over 4GB
 - Because it uses 32-bit int for file size in directories

Large Disks:

Maximum size for FAT32 was 2TB with 32K clusters.

 - That means 250MB of FAT
 - 2TB limit was due to not being able to store larger LBAs in 32-bit numbers.
 - That's also why BIOS maxes out at 2TB.

## Ext File System

This is the strategy I recommend for HW10 / CH03.

The Extended File System (ext) was the standard filesystem for early Linux. It
was based on the traditional UNIX filesystem, UFS.

Basic Layout:

 - Superblock
 - inodes
 - Data Blocks (4k each)

Looks a lot like FAT. 

More detail: Two bitmaps between superblock and inodex:

 - Free inodes
 - Free data blocks
 
Each file system object is represented by:

 - 1 inode (metadata)
 - 1 or more data blocks (data)

Superblock contains:

 - Size and location of all these pieces.
 - inode # of root directory

inodes contain:

 - owner user id
 - size in bytes
 - creation time
 - modification time
 - mode
   - object type (d / f / symlink / etc)
   - permissions (rwx / ugo)
 - number of hard links
 - array of 12 data blocks
   - 10 direct (10 * 4k = 40k)
   - 1 indirect (1024 * 4k = 4M)
   - 1 double indirect (1024 * 1024 * 4k = 4G)

directories contain a table of:

 - file name
 - inode #
 
Example:

 - /
   - /tmp
     - hello.txt (1k)
     - cat.jpg (17k)


## FUSE API / Starter Code

Pull down and unpack the starter code.

The idea:

 - Normally file systems are kernel code.
 - FUSE is an interface that allows file systems to be implemented
   as user programs.

What happens:

 - You run a FUSE program, mounting its file system on some path.
 - Future FS operations on filesystem objects in that subtree
   are handled by the FUSE program.
 - This continues until the filesystem is unmounted.
 - Each operation can be implemented pretty much any way, although
   some approximation of POSIX filesystem behavior will result in
   less buggy behavior.

## Hints

 - Look at hints folder.
 - Talk about how the pieces map to an ext-style FS.

## Slides

[Christo's FS Slides](http://www.ccs.neu.edu/home/ntuck/courses/2018/09/cs3650/notes/00-Spring/20-file-systems/10_File_Systems.pptx)


