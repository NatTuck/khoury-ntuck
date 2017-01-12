---
layout: default
---

# cs2500: Landing the Rocket

## Strings

Operations:

 - string-append
 - string-length
 - substring
   - Half open interval, zero indexed. Why?
 - text : String -> Image

Name -> Greeting problem.

Greeting -> Name problem.

## Landing the Rocket

Start with World = Ticks

 - Rocket goes down at constant speed = 16 pixels / tick.
   - Rocket height is distance to bottom. Show static images.
 - We should stop at the bottom - need a cond.
 - Give some cond examples first.
   - Start with boolean expressions: = < > >= and or not

We should slow down. Move to World = Rocket Height.

 - Need to get data interpretation right. Mars lander story.
 - Tweak on-tick function rather than to-draw function.
 - Stepwise progression - multi-armed cond.

## More stuff

- Bouncing Rocket
- Distance Formula
- Click the rocket
- on-mouse, stop-when
