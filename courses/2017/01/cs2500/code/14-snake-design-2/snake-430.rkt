1. Figure out the constants in the world.

 - The snake segment and food images
   - Radius
   - Color
 - Snake speed
 
  == Pick two ==
 - Pixels per grid cell
 - Background: Height & Width
 - Number of grid cells (x and y) 

2. Figure out the world data definition.
   - Stuff that does change.

; A SnakeWorld is (make-sw Snake Posn)
(define-struct sw [snake food])
; interp:
;  - Food Posn in grid units.
;  - Directions from graphics coordinates, +y is down.  

#;
(define (sw-tmpl sw)
  (... (snake-tmpl (sw-snake sw)) ...
       (posn-tmpl (sw-food sw)) ...))
 
; A Snake is (make-snake Dir LoSeg)
(define-struct snake [dir segs])
; interp: The first item in the list is the head.

#;
(define (snake-tmpl sn)
  (... (dir-tmpl (snake-dir sn)) ...
       (loseg-tmpl (snake-segs sn)) ..))

; A Dir is one of:
;  - "up"
;  - "down"
;  - "right"
;  - "left"
; clarification: when this comes from
;    keyboard, handle else case
; +y is down

#;
(define (dir-tmpl d)
  (cond [(string=? d "up") ...]
        [(string=? d "down") ...]
		[(string=? d "right") ...]
		[(stirng=? d "left") ...]
		[else ...]))

; A LoSegs (List of Segments) is one of:
;  - empty
;  - (cons Seg LoSegs)

; A Seg is a Posn
; +y is down, grid coordinates

3. Build a wishlist.

(big-bang ...
          [to-draw draw-world]
		  [on-tick update-world]
		  [on-key  handle-key]
		  [stop-when game-over?])

; draw-world: SnakeWorld -> Image
; Draw the snake world.

#;
(define (draw-world sw)
  (draw-snake (sw-snake sw)
              (draw-food (sw-food sw) BG)))

; draw-snake: Snake Image -> Image
; Draw a snake on a background.

; draw-food: Posn Image -> Image
; Draw the food on a background.	   
	   
; update-world: SnakeWorld -> SnakeWorld
; Make the new snake world.

; handle-key: SnakeWorld KeyEvent -> SnakeWorld
; Responds to key events.

; game-over?: SnakeWorld -> Boolean
; Is the game over?



		  

