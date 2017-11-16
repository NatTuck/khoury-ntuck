---
layout: default
---

## First Thing

 - Project questions?
 - Project submissions due before next class.
 - Anyone who wants to be a course assistant, apply now.

# Random Web Technologies

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

## WASM Example

```
cd ~/Apps/emsdk*
. ./emsdk_env.sh
mkdir /tmp/dubinc
cd /tmp/dubinc
```

Show the doubinc example:

 - dubinc.c
 - Makefile
 - test.html

## Electron

Desktop apps in JS?

 - The app is basically just a web page + a bundled browser (chromium).
 - Since this web page is running as part of local app rather than
   the web, it can do all the things an app can do:
    - Access the file system
    - Make multiple network connections
    - etc
    - This is largely exposed via the NodeJS APIs
  
Advantages:
 
  - Front-end web developers are cheap compared to native app developers,
    if the latter still exists at all.
  - Cross platform (Windows / Mac / Linux) with minimum compatibility issues.
  - Hello World is 50 megs, compressed.
  
Show electron-quick-start

 - Start app
 - Show index.html
 - Show main.js
 - Show package.json

## ReactNative

Mobile Apps in React?

 - Turns out that Android/iOS do GUIs with XML trees.
 - So the JSX / Virtual DOM strategy works for them too.

## Local Storage

 - Cookies let you save a little bit of data in a user's web browser that
   will be sent back to the server on every request.
 - Local storage lets you save quite a bit of data in a user's browser, and then
   access it with JavaScript later.

http://orteil.dashnet.org/cookieclicker/

 - Click some cookies.
 - Close the tab.
 - Reopen the tab - state is unchanged.

## Web Workers

 - JavaScript is single threaded.
 - The entire programming model assumes a single event loop per
   open web page. Two parallel threads able to do things like
   manipulate the DOM would break everything.
 - But sometimes you want to be able to do computationally intensive tasks
   in the background without blocking the main thread.
 - Enter Web Workers. They're JavaScript code that runs in a separate thread
   but can't do anything except communicate by message passing.
 - Workers can spawn sub-workers.
 - Workers can be shared, even accepting messages from different tabs.

## Service Workers

 - A service worker is a kind of shared web worker with an extra ability.
 - It can intercept AJAX requests from web pages.
 - This lets it manage caching and enable offline functionality for web
   applications. 

## References

 - http://www.emscripten.org/
 - https://medium.com/@eliamaino/calling-c-functions-from-javascript-with-emscripten-first-part-e99fb6eedb22
 - https://github.com/dexteryy/spellbook-of-modern-webdev
 - https://polyfill.io/v2/docs/
 - https://css-tricks.com/now-ever-might-not-need-jquery/
 - https://electron.atom.io/
 - https://medium.com/developers-writing/building-a-desktop-application-with-electron-204203eeb658


