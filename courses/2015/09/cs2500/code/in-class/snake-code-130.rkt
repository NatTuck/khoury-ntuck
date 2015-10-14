;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname snake-code-130) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)


; Some Constants
(define WSIZE 600) ; pixels
(define GRID-ROWS 40) ; Also, columns
(define CELL-SIZE (/ WSIZE GRID-ROWS)) ; pixels
(define SEG-RADIUS (/ CELL-SIZE 2))
(define TICK-SPEED 0.2) ; seconds/tick
(define BG (empty-scene WSIZE WSIZE))


; Data Definitions for the World

(define-struct snake [dir segs])
; A Snake is (make-snake Dir LoSegs)
; interpretation:
;  The head is the first seg in segs.

; A LoSegs is one of:
;  - empty
;  - (cons Seg LoSegs)

; A Dir is one of: "up" "down" "left" "right"

(define-struct seg [x y color])
; A Seg is (make-seg Number Number Symbol)
; x, y are in grid cells; +y is down

(define-struct food [x y color])
; A Food is (make-food Number Number Symbol)
; x, y are in grid cells; +y is down

(define-struct world [snake food])
; A World is (make-world Snake Food)
#;(define (world-tmpl w)
    (... (world-snake w) ...
         (world-food w)  ...))

(define WORLD1 (make-world
                (make-snake "up" (cons (make-seg 2 2 'blue) empty))
                (make-food 10 10 'red)))
(define WORLD2 (make-world
                (make-snake "down"
                            (list (make-seg 4 5 'blue)
                                  (make-seg 4 6 'green)))
                (make-food 10 15 'red)))


#|
Wishlist:

-- on-tick stuff --
update-world : World -> World
move-snake : Snake -> Snake
grow-snake : World -> Snake
eating? : World -> Boolean
make-meal : World -> World

-- to-draw stuff --
render : World -> Image
draw-snake : Snake Image -> Image
draw-food : Food Image -> Image
place-image/grid : Image Number Number Image -> Image

|#

#;(define (main _unused)
  (big-bang WORLD0
            [on-tick ...]
            [on-key ...]
            [stop-when ...]
            [to-draw ...]))



; render : World -> Image
; Draw the world.

(check-expect (render WORLD1)
              (place-image/grid (circle SEG-RADIUS 'solid 'blue)
                           2 2
                           (place-image/grid (circle SEG-RADIUS 'solid 'red)
                                10 10
                                BG)))

(check-expect (render WORLD2)
              (place-image/grid (circle SEG-RADIUS 'solid 'blue)
                           4 5
                           (place-image/grid (circle SEG-RADIUS 'solid 'green)
                                             4 6
                                             (place-image/grid (circle SEG-RADIUS 'solid 'red)
                                                               10 15
                                                               BG))))

(define (render w)
    (draw-snake (world-snake w) (draw-food (world-food w) BG)))

;draw-snake : Snake Image -> Image
; Add the snake to the scene.
(check-expect (draw-snake (world-snake WORLD1) BG)
              (place-image/grid (circle SEG-RADIUS 'solid 'blue)
                                2 2 BG))

(define (draw-snake s scn)
  (draw-segs (snake-segs s) scn))

;draw-segs: Segs Image -> Image
; Add a list of segments to the scene.
(check-expect (draw-segs (cons (make-seg 2 2 'blue) empty) BG)
              (place-image/grid (circle SEG-RADIUS 'solid 'blue)
                                2 2 BG))
(check-expect (draw-segs empty BG)
              BG)

(define (draw-segs xs scn)
  (cond [(empty? xs) scn]
        [(cons? xs) (draw-seg (first xs)
                              (draw-segs (rest xs) scn))]))


; Seg Image -> Image
; Add one seg to the scene.
; (check-expect really goes here)

(define (draw-seg s scn)
  (place-image/grid (circle SEG-RADIUS
                            'solid
                            (seg-color s))
                    (seg-x s)
                    (seg-y s)
                    scn))

;draw-food : Food Image -> Image
;place-image/grid : Image Number Number Image -> Image

(define (draw-food s scn)
  (place-image/grid (circle SEG-RADIUS
                            'solid
                            (food-color s))
                    (food-x s)
                    (food-y s)
                    scn))

; place-image/grid : Image Number Number Image -> Image
; Add an image using grid coordinates.

; (check-expect ...)

(define (place-image/grid fg x y bg)
  (place-image fg
               (* x CELL-SIZE)
               (* y CELL-SIZE)
               bg))

