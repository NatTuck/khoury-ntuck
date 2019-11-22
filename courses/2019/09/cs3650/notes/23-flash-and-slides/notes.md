---
layout: default
---

# Computer Systems

## Disk Hardware

Three kinds of HW to consider:

 - Hard Drives
 - Flash SSDs
 - Ideal NVRAM

### Hard Drives

 * We talked about hard disks last class.
 * They're mechanical devices, and seeking makes them slow.
 * One more important point:

Hard disk scheduling:

 - If we have multiple requests in the queue, reordering them can improve performance.
 - Example:
   * Head is at track 0.
   * We have read requests in queue for [10, 5, 8].
   * Sorting the reads by track minimizes seek time.
 - Hard disks and disk drivers do this. This will mess us up later - we can't rely on
   writes occuring in a specific order without completely blocking the whole
   disk for a single write because the hardware itself is allowed to reorder things.

### Flash SSDs

Modern SSDs are based on NAND flash. It's quite a bit faster than spinning hard disks,
but it's got some weirdness.

 - Written in 16k "pages". Page must be clean to write.
 - Erased (dirty -> clean) in 256k "blocks".
 - Each block can only be erased a limited number of times.

Speed: As high as 2+ GBPS read, 1+ GBPS write

Latency: as low as 50 microseconds, but can spike to 10 ms

SSDs simulate a spinning disk. That means LBAs pointing to 512B / 4K disk
blocks. There may be advantages to smaller blocks for NVMe.

Draw:

 - 4k OS pages in 8k physical pages in 16k physical blocks
   * Draw 4 physical blocks = 16 OS pages
 - Consider a write pattern of writing pages and then updating an index for
   each: 1,2,1,3,1,4,1,5,1,6,1,7,1,8
 - Read / Modify / Write happens a lot for block 1.
 - Now do it again with virtualized pages. (draw a virtual <-> physical page map)
 - Consider a DRAM cache - that'll eliminate the repeated writes of page 1.

Garbage collection:

 - Eventually we end up with a bunch of blocks that are half-used, with the other
   pages superceded by more recent mappings.
 - This isn't efficient use of space, so periodically the SSD is garbage collected.
 - This copies live data from half-used pages to new blocks and erases the resulting
   unused pages.

Wear leveling:

 - We have per-block write limits.
 - Some LBAs get rewritten frequently (browser history index)
 - Other pages are rewitten rarely (the background pictures included with your OS)
 - We want to spread the writes around. To do this, sometimes the garbage collector
   will move rarely-written pages to heavily used blocks, in the hope that they'll
   continue to not be written. This serves to distribute writes over the blocks
   on the disk.

Optimizing for SSDs:

 - There's still seek time, so sequential reads are faster than random reads.
 - The same is true for writes, but...
   * Pages are virtualized and we want to limit read/modify/write cycles, so all
     writes end up being seqential anyway.
 - We want to write entire pages at once. Writes below the physical page size are
   waste write cycles and cause write amplification (they're 16k anyway).

### Optane

 - Similar to ReRAM or "resistive RAM".
 - Byte addressable
 - Very low latency
 - More rewrites than flash, but still not unlimited
   - 256GB of Optane might give you 250 PB of writes
   - They expect it to last about 5 years in heavy use
 - I don't know how Optane wear leveling works, nor how it wears out

Shows up in two configs:

 - Disks, which act like SSDs. Not byte addressable.
 - DIMMs, which act like memory (promised since 2016, actually available as of
   this semester although only for servers with Intel processors)

### Ideal NVRAM

Once we have more RAM-like NVRAM, filesystem designs will want to change.

 - Small, random writes become OK.
 - No longer need or want fixed-size blocks. 
 - Instead, we want memory allocators, and possibly GC.


# Slides

[Christo's FS Slides](http://www.ccs.neu.edu/home/ntuck/courses/2018/09/cs3650/notes/00-Spring/20-file-systems/10_File_Systems.pptx)
