1. Figure out the constants.

   Size & Color of Food, Snake (or even the images)
   Velocity of snake.
   Size of grid squares
   Number of grid squares OR size of window (both X and Y)
   Background - (empty-scene ...)

2. Figure out what does change.

   Location of the food.
   How many parts to snake.
   Position of snake, direction of snake.
   
; A SnakeWorld is (make-sw Posn Snake)
(define-struct sw [food snake])
; interp: Food position is in *grid* coordinates.
;         x, y directions normal graphics conventions.
#;
(define (sw-tmpl sw)
  (... (posn-tmpl (sw-food sw)) ...
       (snake-tmpl (sw-snake sw)) ...))

; A Snake is (make-snake Dir LoSegs)
(define-struct snake [dir segs])
; interp: first segment in list is head of snake
#;
(define (snake-tmpl sn)
  (... (dir-tmpl (snake-dir sn)) ...
       (losegs-tmpl (snake-segs sn)) ...))


; A Dir is one of:
;  - 'right
;  - 'left
;  - 'up
;  - 'down
; interp: right is +x, down is +y
#;
(define (dir-tmpl dir)
  (cond [(symbol=? 'left dir) ...]
        [(symbol=? 'right dir) ...]
	    [(symbol=? 'down dir) ...]
		[(symbol=? 'up dir) ...]))
		
; A LoSegs (List of Segs) is one of:
;  - empty
;  - (cons Seg LoSegs)

; List template goes here.

; A Seg is a Posn.
; interp: Food position is in *grid* coordinates.
;         x, y directions normal graphics conventions.


3. Build a wishlist.
  - Start by writing main, filling out big bang.

(big-bang ...
          [to-draw draw-world]
		  [on-key change-dir]
		  [stop-when game-over?]
		  [on-tick update-world])
  
; draw-world: SnakeWorld -> Image
; Renders the snake world.
#;
(define (draw-world sw)
  (draw-snake (sw-snake sw)
	          (draw-food (sw-food sw) BG)))

; draw-food: Posn Image -> Image
; Render food on background.	   

; draw-snake: Snake Image -> Image
; Render snake on background.
(define (draw-snake sn bg)
  (draw-segments (snake-segs sn) bg))

; draw-segments: LoSegs Image -> Image
; Draw the segments.
; List template goes here, we need draw-one-segment.

; draw-one-segment: Seg Image -> Image
; Draw one segment.

; change-dir: SnakeWorld Key -> SnakeWorld
; Updates the direction of the snake in the world.

#;
(define (change-dir sw k)
  (make-sw ... (redirect-snake (sw-snake sw)) k))
  
; redirect-snake: Snake Key -> Snake
; Change snake direction.

; game-over?: SnakeWorld -> Boolean
; Check if snake has died in world.

; update-world: SnakeWorld -> SnakeWorld
; Advance the snake in current direction; eat if needed; maybe make new food.

; random-food: Posn -> Posn
; Makes a new food in random location.

; posn->grid : Posn -> Posn
; Converts a posn from pixels to grid coordinates.

; grid->pixels : Posn -> Posn
; Convert from grid to pixel coordinates. 


To move snake: Remove last segment, add new head.
To eat: Make the food (position) the new head.  
  
