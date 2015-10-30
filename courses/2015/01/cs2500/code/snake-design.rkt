;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname morning-snake) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
(require 2htdp/image)
(require 2htdp/universe)

; Design recipie for a world program:
;  - Constants
;  - World State
;  - Wish List
;  - Main Function

#|
  Snake is a game. The player controlls a "snake" with the arrow
  keys on a 30 x 30 grid. The snake has a direction, set by the
  last arrow key press. It moves one grid square in that direction
  each tick.

  The grid has "food" on it, taking up a grid square. If the snake's
  head touches the food, it eats it, growing by one segment.

  The snake can be many segments, and it drags the segments around after
  it by its head.

  Game over if the snake hits itself or the edges.
|#

; Constants:
;  - A snake segment (image).
;  - A food particle (image).
;  - Size of the grid.
;  - Size a grid square in pixels.
;  - How long is a tick?

(define SEG-RADIUS 10)
(define GRID-SIZE (* 2 SEG-RADIUS))
(define SNAKE-SEG-IMG (circle SEG-RADIUS 'solid 'red))
(define FOOD-SEG-IMG  (circle SEG-RADIUS 'solid 'green))
(define WSIZE (* 30 GRID-SIZE))
(define BG (empty-scene WSIZE WSIZE))

; Number Number -> Posn
; Make a Posn at the given grid position.
(define (grid-posn x y)
  (make-posn (* x GRID-SIZE) (* y GRID-SIZE)))

; World State:
;  "World" Structure: 
;   - Snake
;     - A List of segment positions.
;     - A direction of travel
;   - Food (just a Posn)

(define-struct world [food snake])
; A World is (make-world Food Snake)
(define-struct snake [dir segs])
; A Snake is (make-snake Dir LoSegments)
; A Dir is one of ('up, 'down, 'left, 'right)
; A Food is a Posn
; A LoSegments is one of:
;  - empty
;  - (cons Segment LoSegments)
; A Segment is a Posn

(define SNAKE0 (make-snake 'down
                           (list (grid-posn 3 2)
                                 (grid-posn 4 2)
                                 (grid-posn 5 2))))
(define WORLD0 (make-world (grid-posn 7 10) SNAKE0))

; Wish List:
;  - Key Handler
;  - Render Image
;    - Render Snake
;    - Render Food
;  - Stop-When - Is the game over, did we hit anything?
;  - On-Tick - Move the snake.
;    - Did we hit food?
;    - Add Segment to Snake

; World -> World
; Main Function
#;(define (main w0)
    (big-bang w0
            [to-draw draw-world]
            [on-tick world-tick TICK-TIME]
            [on-key key-handler]
            [stop-when game-over?]))


