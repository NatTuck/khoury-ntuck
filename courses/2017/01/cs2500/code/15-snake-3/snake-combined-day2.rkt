;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname snake-combined-day2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

; I lost the 4:30 version, so here's a combined version.
; Changes:
;  - Move to 4:30's Dir, with strings for ease of key event handling.
;  - Move to 4:30's window size: 800x800, 40px grid cells.
;  - Keep    1:30's snake & food: both squares.

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
; constraint: segs is never empty
#;
(define (snake-tmpl sn)
  (... (dir-tmpl (snake-dir sn)) ...
       (losegs-tmpl (snake-segs sn)) ...))

; A Dir is one of:
;  - "right"
;  - "left"
;  - "up"
;  - "down"
; interp: right is +x, down is +y
#;
(define (dir-tmpl dir)
  (cond [(symbol=? "left" dir) ...]
        [(symbol=? "right" dir) ...]
        [(symbol=? "down" dir) ...]
        [(symbol=? "up" dir) ...]))
		
; A LoSegs (List of Segs) is one of:
;  - empty
;  - (cons Seg LoSegs)

(define WINDOW-HEIGHT 800)
(define WINDOW-WIDTH  800)
(define CELL-SIZE 40)
(define GRID-HEIGHT (/ WINDOW-HEIGHT CELL-SIZE)) 
(define GRID-WIDTH  (/ WINDOW-WIDTH  CELL-SIZE))
(define FOOD-IMAGE (square CELL-SIZE 'solid 'green))
(define SEG-IMAGE  (square CELL-SIZE 'solid 'red))
(define BG         (empty-scene WINDOW-WIDTH WINDOW-HEIGHT)) 

(define WORLD0 (make-sw (make-posn 10 10)
                        (make-snake "right"
                                    (list (make-posn 5 5)
                                          (make-posn 5 6)))))

; A Seg is a Posn.
; interp: Food position is in *grid* coordinates.
;         x, y directions normal graphics conventions.

(define (main _unused)
  (big-bang WORLD0
            [to-draw draw-world]
            [on-tick update-world]))
;		  [on-key change-dir]
;		  [stop-when game-over?])
  
; draw-world: SnakeWorld -> Image
; Renders the snake world.
(define (draw-world sw)
  (draw-snake (sw-snake sw)
              (draw-food (sw-food sw) BG)))

; draw-food: Posn Image -> Image
; Render food on background.	   
(define (draw-food loc bg)
  (place-image/grid FOOD-IMAGE
                    (posn-x loc)
                    (posn-y loc)
                    bg))

; draw-snake: Snake Image -> Image
; Render snake on background.
(define (draw-snake sn bg)
  (draw-segments (snake-segs sn) bg))

; draw-segments: LoSegs Image -> Image
; Draw the segments.
(define (draw-segments segs bg)
  (cond [(empty? segs) bg]
        [(cons? segs) (draw-one-segment (first segs)
                                        (draw-segments (rest segs) bg))]))

; draw-one-segment: Seg Image -> Image
; Draw one segment.
(define (draw-one-segment seg bg)
  (place-image/grid SEG-IMAGE
                    (posn-x seg)
                    (posn-y seg)
                    bg))

; Image Number Number Image -> Image
; Place image using grid square coordinates.
(define (place-image/grid img x y bg)
  (place-image img
               (* x CELL-SIZE)
               (* y CELL-SIZE)
               bg))

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
(define (update-world sw)
  (make-sw (update-food (sw-food sw) (sw-snake sw))
           (update-snake (sw-snake sw) (sw-food sw))))

; Food Snake -> Food
; Updates food.
(define (update-food food snake)
  (if (eating? snake food)
      (random-food food)
      food))

; Snake Food -> Boolean
; Check to see if snake is eating the food.
(define (eating? snake food)
  (posn=? (snake-head snake) food))

; Stuff that 4:30 didn't have, below this line.

; Posn Posn -> Boolean
; Posns equal?
(define (posn=? p1 p2)
  (and (= (posn-x p1) (posn-x p2))
       (= (posn-y p1) (posn-y p2))))

; Snake -> Posn
; Get the position of the head of the snake.
(define (snake-head snake)
  (first (snake-segs snake)))

; random-food: Posn -> Posn
; Makes a new food in random location.
(define (random-food old)
  (make-posn (random GRID-WIDTH)
             (random GRID-HEIGHT)))

; update-snake: Snake Food -> Snake
; Move snake or, if eating, grow snake.
(define (update-snake snake food)
  (if (eating? snake food)
      (grow-snake snake)
      (move-snake snake)))

; Snake -> Snake
; Add new head at beginning of snake.
(define (grow-snake snake)
  (make-snake (snake-dir snake)
              (cons (make-new-head (snake-dir snake)
                                   (first (snake-segs snake)))
                    (snake-segs snake))))

; Dir Posn -> Posn
; Make a new head in the direction of travel.

; TODO: Fix with direction template.
(define (make-new-head dir old)
  ...)

(define (move-snake snake)
  snake)

;To move snake: Remove last segment, add new head.
;To eat -> (not) Make the food (position) the new head (won't work).
;          If on food, don't remove last segment when we move.
