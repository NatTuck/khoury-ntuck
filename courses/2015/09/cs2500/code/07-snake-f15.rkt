;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 07-snake-f15) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

; Data Definitions
; These let us build up our "state of the world",
; which includes everything that changes as time
; passes or with user input.

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


; Constants
; These don't change as the program runs.

(define WSIZE 600) ; pixels
(define GRID-ROWS 40) ; Also, columns
(define CELL-SIZE (/ WSIZE GRID-ROWS)) ; pixels
(define SEG-RADIUS (/ CELL-SIZE 2))
(define TICK-SPEED 0.2) ; seconds/tick
(define BG (empty-scene WSIZE WSIZE))


; Sample worlds.

; Here's our initial world, with three snake segments.
(define WORLD0 (make-world
                (make-snake "right" (list (make-seg 9 6 'red)
                                          (make-seg 9 7 'red)
                                          (make-seg 9 8 'red)))
                (make-food 12 12 'green)))

; Two sample worlds, one where the snake is about to move,
; and one where the snake is about to eat and grow.
(define WORLD-MOVE (make-world
                    (make-snake "up" (list (make-seg 2 2 'blue)))
                    (make-food 10 10 'red)))
(define WORLD-GROW (make-world
                    (make-snake "up" (list (make-seg 2 2 'blue)))
                    (make-food 2 2 'red)))

; Any -> World
; Start up the game.

(define (main _unused)
  (big-bang WORLD0
            [to-draw render]
            [on-tick update-world TICK-SPEED]
            [on-key  got-key]))

; World KeyEvent -> World
; The user pressed a key.
(check-expect (got-key WORLD-MOVE "down")
              (make-world
               (make-snake "down" (list (make-seg 2 2 'blue)))
               (world-food WORLD-MOVE)))

(define (got-key w ke)
  (make-world (make-snake ke
                          (snake-segs (world-snake w)))
              (world-food w)))


; World -> World
; Make next world: move snake, maybe food, maybe grow.
(check-expect (update-world WORLD-MOVE)
              (make-world (make-snake "up"
                                      (list (make-seg 2 1 'blue)))
                          (make-food 10 10 'red)))

; When food is eaten, new food is random. So we just test
; the snake here.
(check-expect (world-snake (update-world WORLD-GROW))
              (make-snake "up"
                          (list (make-seg 2 1 'red)
                                (make-seg 2 2 'blue))))

(define (update-world w)
  (if (snake-dead? (world-snake w))
      WORLD0
      (make-world (update-snake w)
                  (update-food w))))

; Snake -> Boolean
; Has the snake run into something?
(check-expect (snake-dead? (world-snake WORLD0)) false)
(check-expect (snake-dead? (make-snake "up" (list (make-seg 5 5 'red)
                                                  (make-seg 5 5 'blue))))
                           true)

(define (snake-dead? sn)
  (or (hit-wall? (snake-segs sn))
      (hit-self? (snake-segs sn))))

; LoSegs -> Boolean
; Has the snake hit the wall?
(check-expect (hit-wall? (list (make-seg -5 3 'red))) true)
(check-expect (hit-wall? (list (make-seg 3 3 'blue))) false)

(define (hit-wall? xs)
  (not (on-grid? (seg->posn (first xs))))) 

; Posn -> Boolean
; Is this position within the grid?
(check-expect (on-grid? (make-posn 1 1)) true)
(check-expect (on-grid? (make-posn 5 3792)) false)

(define (on-grid? p)
  (and (>= (posn-x p) 0)
       (>= (posn-y p) 0)
       (<  (posn-x p) GRID-ROWS)
       (<  (posn-y p) GRID-ROWS)))

; LoSegs -> Boolean
; Has the head hit any of the other segments?
(check-expect (hit-self? (list (make-seg 3 3 'green) (make-seg 3 4 'blue))) false)
(check-expect (hit-self? (list (make-seg 3 3 'red)
                               (make-seg 3 4 'green)
                               (make-seg 4 4 'blue)
                               (make-seg 4 3 'red)
                               (make-seg 3 3 'red)
                               (make-seg 3 2 'purple))) true)

(define (hit-self? xs)
  (hit-any? (first xs) (rest xs)))

; Seg LoSegs -> Boolean
; Is this seg at the same position as any of the segs in the list?
(check-expect (hit-any? (make-seg 3 2 'red) (list (make-seg 3 3 'red) (make-seg 3 4 'red))) false)
(check-expect (hit-any? (make-seg 3 3 'red) (list (make-seg 3 4 'green)
                                                  (make-seg 4 4 'green)
                                                  (make-seg 4 3 'green)
                                                  (make-seg 3 3 'green)
                                                  (make-seg 3 2 'green))) true)

(define (hit-any? s los)
  (cond [(empty? los) false]
        [(cons? los)  (if (posn=? (seg->posn s) (seg->posn (first los)))
                          true
                          (hit-any? s (rest los)))]))


; World -> Snake
; Produce the next snake by moving and possibly growing.
(check-expect (update-snake WORLD-MOVE)
              (make-snake "up" (list (make-seg 2 1 'blue))))
                          
; When food is eaten, new food is random. So we just test
; the snake here.
(check-expect (update-snake WORLD-GROW)
              (make-snake "up"
                          (list (make-seg 2 1 'red)
                                (make-seg 2 2 'blue))))

(define (update-snake w)
  (if (eating? w)
      (grow-snake w)
      (move-snake (world-snake w))))

; grow-snake : World -> Snake
; Add a segment to the snake.

(check-expect (grow-snake WORLD-GROW)
              (make-snake "up"
                          (list (make-seg 2 1 'red)
                                (make-seg 2 2 'blue))))

(define (grow-snake w)
  (make-snake (snake-dir (world-snake w))
              (cons (new-head (world-food w)
                              (snake-dir (world-snake w)))
                    (snake-segs (world-snake w)))))

; Food Dir -> Seg
; Make a new head for snake.

(check-expect (new-head (make-food 2 2 'red) "up")
              (make-seg 2 1 'red))
(check-expect (new-head (make-food 2 2 'red) "down")
              (make-seg 2 3 'red))
(check-expect (new-head (make-food 2 2 'red) "left")
              (make-seg 1 2 'red))
(check-expect (new-head (make-food 2 2 'red) "right")
              (make-seg 3 2 'red))


(define (new-head food d)
  (cond [(string=? "up" d)
         (make-seg (food-x food)
                   (- (food-y food) 1)
                   (food-color food))]
        [(string=? "down" d)
         (make-seg (food-x food)
                   (+ (food-y food) 1)
                   (food-color food))]
        [(string=? "left" d)
         (make-seg (- (food-x food) 1)
                   (food-y food)
                   (food-color food))]
        [(string=? "right" d)
         (make-seg (+ (food-x food) 1)
                   (food-y food)
                   (food-color food))]))

; World -> Boolean
; Is the snake currently eating?
(check-expect (eating? WORLD-MOVE) false)
(check-expect (eating? WORLD-GROW) true)

(define (eating? w)
  (posn=? (food-posn (world-food w))
          (snake-head-posn (world-snake w))))

; Posn Posn -> Boolean
; Do these Posns represent the same location?
(check-expect (posn=? (make-posn 5 5) (make-posn 5 5)) true)
(check-expect (posn=? (make-posn 5 3) (make-posn 5 5)) false)

(define (posn=? p1 p2)
  (and (= (posn-x p1)
          (posn-x p2))
       (= (posn-y p1)
          (posn-y p2))))

; Food -> Posn
; Where is the food?
(check-expect (food-posn (make-food 3 5 'green)) (make-posn 3 5))

(define (food-posn food)
  (make-posn (food-x food) (food-y food)))

; Snake -> Posn
; Where is the Snake's head?
(check-expect (snake-head-posn (world-snake WORLD0))
              (make-posn 9 6))

(define (snake-head-posn sn)
  (seg->posn (first (snake-segs sn))))

; Seg -> Posn
; Find the position of a segment.
(check-expect (seg->posn (make-seg 5 5 'blue)) (make-posn 5 5))

(define (seg->posn s)
  (make-posn (seg-x s) (seg-y s)))

; update-food : World -> Food
; Move the food if it was eaten.
(check-expect (update-food WORLD0) (world-food WORLD0))
(check-expect (food? (update-food WORLD-GROW)) true)

(define (update-food w)
  (if (eating? w)
      (make-food (random GRID-ROWS) (random GRID-ROWS) (pick-color (random 7)))
      (world-food w)))

; Number -> String
; Pick a color.
(define (pick-color x)
  (cond [(= x 0) 'red]
        [(= x 1) 'green]
        [(= x 2) 'blue]
        [(= x 3) 'purple]
        [(= x 4) 'magenta]
        [(= x 5) 'black]
        [else 'orange]))

; Snake -> Snake
; The snake slithers forward.
(check-expect (move-snake (world-snake WORLD0))
              (make-snake "right"
                          (list (make-seg 10 6 'red)
                                (make-seg 9 6 'red)
                                (make-seg 9 7 'red))))

(define (move-snake sn)
  (make-snake (snake-dir sn)
              (cons (new-move-head (snake-dir sn) (snake-segs sn))
                    (drop-last-seg (snake-segs sn)))))

; Dir LoSegs -> Seg
; Make the new head of the snake.
(check-expect (new-move-head "left" (list (make-seg 9 7 'red)
                                          (make-seg 9 8 'blue)))
              (make-seg 8 7 'blue))

(define (new-move-head dir los)
  (move-seg dir (make-seg (seg-x (first los))
                          (seg-y (first los))
                          (seg-color (last-seg los)))))

; Dir Seg -> Seg
; "Move" a segment one square in the given direction.
(check-expect (move-seg "up" (make-seg 9 7 'red))
              (make-seg 9 6 'red))
(check-expect (move-seg "down" (make-seg 9 7 'green))
              (make-seg 9 8 'green))
(check-expect (move-seg "left" (make-seg 9 7 'green))
              (make-seg 8 7 'green))
(check-expect (move-seg "right" (make-seg 9 7 'green))
              (make-seg 10 7 'green))

(define (move-seg d seg)
  (cond [(string=? "up" d)
         (make-seg (seg-x seg)
                   (- (seg-y seg) 1)
                   (seg-color seg))]
        [(string=? "down" d)
         (make-seg (seg-x seg)
                   (+ (seg-y seg) 1)
                   (seg-color seg))]
        [(string=? "left" d)
         (make-seg (- (seg-x seg) 1)
                   (seg-y seg)
                   (seg-color seg))]
        [(string=? "right" d)
         (make-seg (+ (seg-x seg) 1)
                   (seg-y seg)
                   (seg-color seg))]))

; LoSegs -> Seg
; Get the last item in a list of Segs
(check-expect (last-seg (list (make-seg 9 7 'red)
                              (make-seg 9 6 'red)
                              (make-seg 9 5 'red)))
              (make-seg 9 5 'red))

(define (last-seg xs)
  (cond [(empty? (rest xs)) (first xs)]
        [else (last-seg (rest xs))]))

; LoSegs -> LoSegs
; Drop the last segment in the list of segments.
(check-expect (drop-last-seg (list (make-seg 9 7 'red)
                                   (make-seg 9 6 'red)
                                   (make-seg 9 5 'red)))
              (list (make-seg 9 7 'red)
                    (make-seg 9 6 'red)))

(define (drop-last-seg xs)
  (cond [(empty? (rest xs)) empty]
        [(cons? (rest xs)) (cons (first xs)
                                 (drop-last-seg (rest xs)))]))
             
; render : World -> Image
; Draw the world.

(check-expect (render WORLD-MOVE)
              (place-image/grid (circle SEG-RADIUS 'solid 'blue)
                           2 2
                           (place-image/grid (circle SEG-RADIUS 'solid 'red)
                                10 10
                                BG)))

(check-expect (render WORLD-GROW)
              (place-image/grid (circle SEG-RADIUS 'solid 'blue)
                                2 2
                                (place-image/grid (circle SEG-RADIUS 'solid 'red)
                                                  2 2 BG)))

(define (render w)
    (draw-snake (world-snake w) (draw-food (world-food w) BG)))

;draw-snake : Snake Image -> Image
; Add the snake to the scene.
(check-expect (draw-snake (world-snake WORLD-MOVE) BG)
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

