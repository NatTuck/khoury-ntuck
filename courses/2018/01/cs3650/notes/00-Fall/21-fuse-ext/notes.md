---
layout: default
---

# Computer Systems

 - 09:50 – 11:30
 - 13:35 – 15:15

## FUSE API

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

Show CH03 starter code.

 - make
 - make mount

Key idea: Run the FS in one terminal, test it in another.

View code, nufs.c:

 - Start at the bottom in main.
 - Look at the list of ops.
 - Mostly each op is implementing what would traditionally be
   the kernel side of a syscall.
 - Look at the args for nufs_read, compare to the read(2) manpage.
 - Convention: FUSE callbacks return errors as -errno.
   - Show "man errno".
 - getattr always needs to return the right error codes.
   - Getattr is the implementation of stat / lstat.
   - But is also called extra times by FUSE. 
   - FUSE tends to getattr first and give up if that gives
     a the wrong answer. e.g. You can only make a file if stating
     it returns ENOENT.
     
Look at storage.c:

 - This implements a data store.
 - The point of this file is to minimally get something to run and hint
   at a structure for your code.
 - You shouldn't keep any of the data structures or function bodies in
   this file.

Hints directory:

 - It's there.
 - We'll come back to it if we have time.

## Ext File System

The Extended File System (ext) was the standard filesystem for early Linux. It
was based on the traditional UNIX filesystem, UFS.

Basic Layout:

 - Superblock
 - inodes
 - Data Blocks (4k each)

Looks at lot like FAT. 

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
 - # of hard links
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

Ext Advantages:

 - Supports POSIX filesystem features
   - Space for significant metadata
   - Hard links
 - Metadata and blocks are all in one place; less seeking than FAT for files over one block.
 - Bitmaps are faster than FAT for finding free space.

Ext disadvantages:

 - Still slow on spinning disk.
 - Bad locality - inodes and data blocks are not near each other and need to be accessed
   alternatively in path traversals.

## Hints

 - Look at hints folder.
 - Talk about how the pieces map to an ext-style FS.

## Slides

 - Start the FS slides from ~slide 16

## Plan for Filesystems

 - 4 lectures
   - Hardware and FAT
   - CH03 starter code, EXT
   - FS slides (EXT optimizations)
   - logs and COWs
 - core topics:
   - hard disks vs. SSDs vs. ideal NVRAM
   - FAT
   - ext (basic)
   - FUSE
 - secondary topics:
   - ext2/3/4 optimizations
   - COW filessytems
   - log-based FSes




