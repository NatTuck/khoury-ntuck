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

 - Numeric casts convert.
   - 
 - Pointer casts reinterpret bytes.
 - String <-> number conversions are stdlib functions.
 - Int lengths:
   - sizeof(char)
   - sizeof(short)
   - sizeof(int)
   - sizeof(long)
 - What if we cast a pointer to two shorts {1, 0} to an int\*?

# Function Pointers

 - Show map example.

# Malloc and Free

 - p = malloc(nn) allocates a block of nn bytes from the heap.
 - free(p) gives that memory back
 - let's make map actually work correctly
 - Print address of something malloc'd compared to &main and something on the stack.

# Structs

 - Passing nn around is silly. Let's extend map with fat pointers.
 - In C we need to say "struct foo" whenever we use a foo.

# Typedefs

 - Function pointers and structs are obnoxious.
 - Let's rename our types to something reasonable.

# Headers, Macros
 
 - Let's put int\_vec in a separate file.
 - Header.
 - Include guards.

# Generics
 
 - We don't have them. That's what C++ does. We can do without, it just sucks.

# Evil Macros, Static Functions

 - If we have time.
