---
layout: default
---

## First Thing

Project questions?

## Schedule

 - Today: Web Assembly
 - Next class = Last Class
 - FACT Reports
 
## QuakeJS

http://www.quakejs.com/

 - This is Quake 3, a top PC game from 1999, later open sourced.
 - It's written in C.
 - It's running in the browser, at basically full performance.
 - The trick: ASM.js

In-browser native code.

 - At around the same time, Mozilla and Google decided that you should be able
   to run native code in your browser.
 - Mozilla decided to define a subset of JavaScript - ASM.js - that:
   - Made a reasonable compiler target for native code languages.
   - Could be JIT compiled to efficient machine code easily.
   - Disadvantage: Weird
 - Google decided to create a subset of 32-bit x86 code called NaCL that
   - Had a standard library that was basically Linux.
   - Could be easily sandboxed by static analysis.
   - Disadvantage: Not portable

Two is too many standards, so both groups got together and designed...

## Web Assembly

 - A binary code format that can run in web browsers.
 - Kind of like Java bytecode, but very efficiently compiles to
   machine code.
 - Provides an assembly language (hence the name), which is already
   supported by LLVM as a target for C and C++ code.

Using techniques demonstrated by Mozilla's ASM.js and Google's NaCL, native code
can be run directly in the browser with a relatively small (20% maybe)
performance penalty.

Another way to look at this is that it lets you write code that runs in the
browser and is 2-5x faster than JS.

Quake demonstrated two of the key ideas:

 - Graphically / computationally intensive programs.
 - The ability to recompile exisiting C/C++ programs with the browser
   as the target platform.

Two more things to consider:

 - Web app frontends don't need to be in JavaScript.
 - Web app frontends don't need to be in HTML/CSS either.

## POW Example

 - Bitcoin Proof of Work:
   - Double SHA256
   - Goal: Find a seed that, when hashed, has a bunch of leading 0's.
   - That requires brute force, so we can measure performance in hashes/sec.

Setup:

 - Clone repo https://github.com/NatTuck/simple-wasm-pow
 - Delete main.js, csha/{Makefile, wrap.cc}

### Plan A: JavaScript

 - There's a library called js-sha256
 - We're going to skip npm for now.

```
function bench(op, id) {
  console.log("Start bench: " + id);
  let t0 = performance.now();
  let jj = 0;

  while (performance.now() - t0 < 5000) {
    for (let ii = 0; ii < 50; ++ii) {
      let _foo = op("" + ii);
      jj += 1;
    }
  }

  let ips = jj / 5;

  $(id).text("" + ips);
}

$(function() {
  bench(sha256, '#js-rate');
});
```

Result: Some number.

Let's try speeding it up with WASM.

### Plan B: Rewrite it in C++

 - There's a single file C implementation of sha256
 - To compile it to WASM, we need emscripten: emscripten.org
 - We need to get the sdk, and follow the install instructions.
 - Once we have emcc, we want a C++ wrapper for the lib - that'll
   let us do it the easy way.


```
#include <string>
#include <cstdint>
#include <sstream>
#include <iostream>
#include <iomanip>

// emscripten is easier if we modify our C++
// to be aware of it.
#include <emscripten/bind.h>
#include <emscripten.h>

#include "sha-256.h"

std::string
to_hex(uint8_t* data, size_t nn)
{
    std::ostringstream tmp;
    tmp << std::setw(2) << std::setfill('0') << std::hex;
    for (int ii = 0; ii < nn; ++ii) {
        tmp << (int) data[ii];
    }
    return tmp.str();
}

// This macro prevents dead code elimination.
EMSCRIPTEN_KEEPALIVE
std::string
sha256(std::string input)
{
    uint8_t hash[32];
    calc_sha_256(hash, (void*) input.c_str(), input.size());
    return to_hex(hash, 32);
}

// This exports the function to JS.
EMSCRIPTEN_BINDINGS(csha) {
    emscripten::function("sha256", &sha256);
}
```

Then we need a Makefile to build it.

```
OUTPUT := csha.js csha.wasm

$(OUTPUT): sha-256.cc sha-256.h wrap.cc
	emcc --bind -o csha.js -O3 -s WASM=1 *.cc

clean:
	rm -f $(OUTPUT)
	rm -f ../csha.js ../csha.wasm

copy:
	cp $(OUTPUT) ../

.PHONY: clean copy
```

Then we can just ```make && make copy```, and we have wasm.


## This will get easier.

Currently, tools like emscripten are built for the "port a C++ program to the
web" use case, which is neat but isn't really what we want for new programs.

There are already tools that let you "import" C, C++, or Rust files directly in
your JavaScript - if you have a dev env setup just right.



