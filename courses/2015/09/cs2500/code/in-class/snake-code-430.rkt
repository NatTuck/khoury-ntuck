;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname snake-code-430) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
(require 2htdp/image)
(require 2htdp/universe)

; Constants
(define CELL-SIZE 20) ; pixels
; GRID-ROWS is also # of columns
(define GRID-ROWS 20)
(define WSIZE (* CELL-SIZE GRID-ROWS)) ; pixels
(define BG (empty-scene WSIZE WSIZE))
(define SEG-SIZE (/ CELL-SIZE 2)) ; pixels
(define TICK-SPEED 0.2) ; seconds/tick


(define-struct snake [dir segs])
; A Snake is a (make-snake Dir LoSegs)
; interpretation: First segment in list
;    is the head of the snake.

; A Dir is one of:
;  - "up"
;  - "down"
;  - "left"
;  - "right"

; A LoSegs is one of:
;  - empty
;  - (cons Seg LoSegs)

(define-struct seg [x y color])
; A Seg is a
;  (make-seg Number Number Symbol)
; interpretation
;   x, y are in grid coordinates, +y is down

(define-struct food [x y color])
; A Food is
;  (make-food Number Number Symbol)
; interpretation
;   x, y are in grid coordinates, +y is down

(define-struct world [snake food])
; A World is (make-world Snake Food)

(define WORLD1 (make-world
                (make-snake "up"
                            (list (make-seg 1 2 'green)))
                (make-food 5 7 'red)))


#|

update : World -> World
move-snake : Snake -> Snake
move-food : Food -> Food

draw-world : World -> Image
image+snake : Snake Image -> Image
image+food : Food Image -> Image
place-image/grid : Image Number Number Image -> Image

|#

#;(define (main _unused)
    (big-bang WORLD0
              [on-tick update]
              [to-draw draw-world]
              [on-key ...]
              [stop-when ...]))

; World -> Image
; Draw the world.
(check-expect (draw-world WORLD1)
              (place-image/grid (circle 10 'solid 'green)
                           1 2
                           (place-image/grid (circle 10 'solid 'red)
                                             5 7 
                                             BG)))


(define (draw-world w)
  (image+snake (world-snake w) 
               (image+food (world-food w) BG)))

; Food Image -> Image
(check-expect (image+food (make-food 3 5 'purple) BG)
              (place-image/grid 
               (circle SEG-SIZE 'solid 'purple)                          
               3 5 BG))

(define (image+food f scn)
  (place-image/grid (circle SEG-SIZE 'solid (food-color f))
                    (food-x f) (food-y f) scn))



; Image Number Number Image -> Image
(check-expect (place-image/grid 
               (circle 5 'solid 'red)
               1 2 BG)
              (place-image
               (circle 5 'solid 'red)
               (* 1 CELL-SIZE)
               (* 2 CELL-SIZE)
               BG))

(define (place-image/grid fg x y bg)
  (place-image
   fg (* x CELL-SIZE) (* y CELL-SIZE) bg))


; Snake Image -> Image

(check-expect (image+snake 
               (make-snake "down"
                           (list (make-seg 5 6 'red)
                                 (make-seg 5 7 'blue)))
               BG)
              (place-image/grid
               (circle SEG-SIZE 'solid 'red)
               5 6
               (place-image/grid
                (circle SEG-SIZE 'solid 'blue)
                5 7
                BG)))


(define (image+snake s scn)
  (image+segs (snake-segs s) scn))


; LoSegs Image -> Image
; Add all the snake segments to the scene.
; (check-expect ...)

(define (image+segs xs scn)
  (cond [(empty? xs) scn]
        [(cons? xs) (image+seg (first xs)
                               (image+segs (rest xs) scn))]))



; Seg Image -> Image
; Place one segment.

(define (image+seg s scn)
  (place-image/grid
   (circle SEG-SIZE 'solid (seg-color s)) 
   (seg-x s) (seg-y s) scn))