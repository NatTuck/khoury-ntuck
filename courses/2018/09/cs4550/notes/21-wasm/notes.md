---
layout: default
---

 - Project Questions?

## History of Native Code in Browser

Until 1995, web pages were static things. They didn't run code.

That changed when Java Applets were introduced in May 1995. The initial release
of the Java programming language included a browser plugin that allowed Java
code to be downloaded and run in a user's browser, sandboxed for security.

A few months later, in September, Netscape Navgiator 2.0 released a native
browser scripting language called LiveScript. Because Java was hyped as the
language of the web, LiveScript was renamed to JavaScript by December.

For the next 20 years, these were the two widely supported methods to run code
in a browser: plugins and scripts. Java applets died to be replaced by another
plugin: Flash. Other scripting languages like VBScript got no traction.

Around 2010, two separate teams had the same idea for a third plan. They noticed
that users were spending more time in browsers but that most exisisting
applications, game engines, libraries, programming languages, etc were written
to target native code platforms like desktop apps.

The new plan: Run native code in the browser, by making the browser a new target
platform for compilers and such.

### NACL

The first team, at Google, released NACL in 2011. 
 
 - Subset of 32-bit x86 code called NaCL that
 - Had a standard library that was basically Linux.
 - Could be easily sandboxed by static analysis.
 - Disadvantage: Not portable to non-x86 processors

### asm.js

The second team, at Mozilla, relased ASM.js in 2013.

 - A subset of JavaScript.
 - Made a reasonable compiler target for native code languages.
 - Could be JIT compiled to efficient machine code easily.
 - Disadvantage: Weird

## QuakeJS

http://www.quakejs.com/

 - This is Quake 3, a top PC game from 1999, later open sourced.
 - It's written in C.
 - It's running in the browser, at basically full performance.
 - The trick: ASM.js
 - We saw better graphics yesterday in pure JS + fancy shaders running on the
   GPU, but this is basically just the Linux version of Quake recompiled.
 - Writing in C over JS means a small speedup, no GC pauses, etc.

## Web Assembly

 - A binary code format that can run in web browsers.
 - Kind of like Java bytecode, but very efficiently compiles to
   machine code.
 - Provides an assembly language (hence the name), which is already
   supported by LLVM as a target for C and C++ code.

Using techniques demonstrated by Mozilla's ASM.js and Google's NaCL, native code
can be run directly in the browser with a relatively small (20% maybe)
performance penalty - at least in theory.

Another way to look at this is that it lets you write code that runs in the
browser and is 2-5x faster than JS.

Quake demonstrated two of the key ideas:

 - Graphically / computationally intensive programs.
 - The ability to recompile exisiting C/C++ programs with the browser
   as the target platform.

Two more things to consider:

 - Web app frontends don't need to be in JavaScript.
 - Web app frontends don't need to be in HTML/CSS either.

## Fib Example

Prereqs:
 
  - wasm starter: https://github.com/yurydelendik/wasmception
  - wasm tools: https://github.com/WebAssembly/wabt
  - Note: LLVM takes like an hour to compile.

Start in the wasmception directory.

```
$ cp -r example fib
$ cd fib
```

Take a look at index.html

 - WASM code is downloaded by JS
 - We run it through a WASM -> native compiler
 - We give it a memory space (in 64k WASM pages)
 - We can pass references to JS functions to our WASM code.
 - We can then call WASM functions from JS code.

Take a look at main.c

 - Forward declare functions getting passed from JS.
 - Then we can declare functions to export.
 - Note the way string is getting passed to JS as
   int-from-pointer and length. This same stratgy can be
   used to transfer any serialized data.

Back to index.html

 - Note use of "decoder" in implementation of ```__console_log```.

Let's run the starter code:

```
$ python3 -m http.server
```

Now let's create a fib form (in index.html):

```
<body>
  <h1>WASM Fib</h1>

  <div>
    <input id="x" type="text">
    <p id="y">None</p>
    <button id="btn">Fib!</button>
  </div>

  <script type="text/javascript">
   function btn_click() {
     let x = parseInt(document.getElementById('x').value);
     let t0 = performance.now();
     let y = window.fib(x);
     console.log(performance.now() - t0);
     document.getElementById('y').innerText = y;
   }
   document.getElementById('btn').addEventListener('click', btn_click);
  </script>

  ...
  
      WebAssembly.instantiate(module, imports).then(function(instance) {
      //console.log(instance.exports.do_something(2));
      window.fib = function(x) {
        return instance.exports.fib(x);
      }
    });
```

And a fib function in the C file:

```
int 
fib(int x)
{
  if (x <= 2) {
    return 1;
  }
  else {
    return fib(x-1) + fib(x-2);
  }
}
```

Update the Makefile to export "fib".

```
		-Wl,--export=fib \
```

Run that, then add a JS fib and compare:

```
   function fib2(x) {
     if (x <= 2) {
       return 1;
     }
     else {
       return fib2(x-1) + fib2(x-2);
     }
   }
```

Next, let's look at the 'wat' file.

```
$ wasm2wat main.wasm -o main.wat
$ view main.wat
```

## POW: JS vs Rust

Let's create a new Rust WASM project.

Prereqs:

 - Rustup installed, latest rust.
 - https://www.rust-lang.org/
 - Setup steps here:
 - https://rustwasm.github.io/book/introduction.html
 - Might require updated node/npm with nvm.

```
$ cargo generate --git https://github.com/rustwasm/wasm-pack-template
Project Name: hash-bench
```

Add to Cargo.toml:

```
[dependencies]
sha2 = "0.8.0"
```



## POW Example

Bitcoin Proof of Work:

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


## C WASM Example

 - clang + WASM: https://github.com/yurydelendik/wasmception
 - wasm tools: https://github.com/WebAssembly/wabt
 
