---
layout: default
---

# First Thing
 
 - Homework Questions

# A Program Becomes a Process

 - C to ASM
 - Assembly to Machine Code
   - Two passes: Generate &amp; Collect; Fill in labels
   - Do this out on the board for progC
 - Machine code is stored in a "binary"
   - Has table of contents showing segments
   - Segments: Text, Data, others...
 - When you run the program:
   - Operating creates an address space for your program.
     - It'll look like you have the only program in memory.
   - Operating system copies segments from binary to memory.
   - Operating system allocates stack (and heap).
   - Operating system jumps to entry point (conceptually, main:)
 - Load up progA in MARS.
   - Draw an address space.
   - Where's text? data? stack? Put them in the diagram.

# Casts

 - Pointer casts reinterpret bytes.
 - Numeric casts convert.
 - String <-> number conversions are stdlib functions.
 - Int lengths:
   - sizeof(char)
   - sizeof(short)
   - sizeof(int)
   - sizeof(long)
 - What if we cast a pointer to two shorts {1, 0} to an int*?


