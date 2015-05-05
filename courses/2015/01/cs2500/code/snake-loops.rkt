;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname snake-loops) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
(require 2htdp/image)
(require 2htdp/universe)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Data definitions

(define SEG-RADIUS 10)
(define SQUARE-SIZE (* 2 SEG-RADIUS))
(define GRID-SIZE 30)
(define SNAKE-SEG-IMG (circle SEG-RADIUS 'solid 'red))
(define FOOD-SEG-IMG (circle SEG-RADIUS 'solid 'green))
(define WSIZE (* SQUARE-SIZE GRID-SIZE))
(define BG (empty-scene WSIZE WSIZE))

;;a World is a (make-world Food Snake)
(define-struct world (food snake))

;; a Snake is a (make-snake String [List-of Segment])
(define-struct snake (dir segs))

(define SNAKE0 (make-snake "down" 
                           (list (make-posn 3 2)
                                 (make-posn 4 2)
                                 (make-posn 5 2))))

;; A Segment is a Posn
;; A Food is a Posn
;; A Dir is one of: "up", "down", "left", "right"

(define WORLD0 (make-world (make-posn 7 10) SNAKE0))
                           
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Drawing the Snake

;; Image -> [Posn Image -> Image]
;; Get a function that places one image on the scene.
(define (draw-seg-fn seg)
  (local (; Posn Image -> Image
          ; Add one image to the scene.
          (define (draw-seg p scn)
            (place-image seg
                         (* SQUARE-SIZE (posn-x p))
                         (* SQUARE-SIZE (posn-y p))
                         scn)))
    draw-seg))   

(check-expect ((draw-seg-fn SNAKE-SEG-IMG) (make-posn 1 1) BG)
              (place-image SNAKE-SEG-IMG SQUARE-SIZE SQUARE-SIZE BG))

;; World Image -> Image
;; Draw the snake onto the scene
(define (draw-snake w scn)
  (foldr (draw-seg-fn SNAKE-SEG-IMG) scn (snake-segs (world-snake w))))

;; World Image -> Image
;; Draw the food onto the scene
(define (draw-food w scn)
  ((draw-seg-fn FOOD-SEG-IMG) (world-food w) scn))

;; World -> Image
;; Draw the world (snake, food)
(define (draw-world w)
  (local (; [World Image -> Image] Image -> Image
          (define (draw fn scn)
            (fn w scn)))
  (foldr draw BG (list draw-snake draw-food))))

(check-expect (image? (draw-world WORLD0)) true)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Moving and growing the snake

;; Posn Dir -> Posn
;; Move a segment in the direction specified
(define (move-seg p d)
  (cond [(string=? d "up")    (make-posn (posn-x p) (sub1 (posn-y p)))]
        [(string=? d "down")  (make-posn (posn-x p) (add1 (posn-y p)))]
        [(string=? d "left")  (make-posn (sub1 (posn-x p)) (posn-y p))]
        [(string=? d "right") (make-posn (add1 (posn-x p)) (posn-y p))]))

(check-expect (move-seg (make-posn 1 3) "up")    (make-posn 1 2))
(check-expect (move-seg (make-posn 1 3) "down")  (make-posn 1 4))
(check-expect (move-seg (make-posn 1 3) "left")  (make-posn 0 3))
(check-expect (move-seg (make-posn 1 3) "right") (make-posn 2 3))

;; [List-of X] -> [List-of X]
;; Take all but the last item in a list.
;; The input list must not be empty.
(define (all-but-last a-los)
  (reverse (rest (reverse a-los))))

(check-expect (all-but-last '(1 2 3)) '(1 2))

;; Snake -> Snake
;; Grow the snake.
(define (grow-snake sn)
  (make-snake 
   (snake-dir sn) 
   (cons (move-seg (first (snake-segs sn)) (snake-dir sn))
         (snake-segs sn))))

;; Snake -> Snake
;; Move the snake in the direction specified
(define (move-snake sn)
  (make-snake 
   (snake-dir sn) 
   (all-but-last (snake-segs (grow-snake sn)))))

(check-expect (move-snake SNAKE0)
              (make-snake "down" 
                          (list (make-posn 3 3)
                                (make-posn 3 2)
                                (make-posn 4 2))))


;; World -> Boolean
;; Is the snake eating?
(define (eating? w)
  (posn=? (world-food w)
          (first (snake-segs (world-snake w)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Collision detection

;; Posn Posn -> Boolean
;; Are the two Posns equal?
(define (posn=? p1 p2)
  (and (= (posn-x p1) (posn-x p2))
       (= (posn-y p1) (posn-y p2))))

;; Posn -> Boolean
;; Did the snake head hit one of the walls
(define (wall-collide? p1)
  (not (and (< 0 (posn-x p1) GRID-SIZE)
            (< 0 (posn-y p1) GRID-SIZE))))

;; Posn LoSegments -> Boolean
;;did the head of the snake collide with any other snake segment?

; HERE
(define (segs-collide? head body)
  (local (; Posn -> Boolean
          (define (=head? p)
            (posn=? head p)))
    (ormap =head? body)))

;; Snake -> Boolean
(define (self-collide? sn)
  (segs-collide? (first (snake-segs sn))
                 (rest (snake-segs sn))))

;; Snake -> Boolean
;; Did the snake hit the wall or itself?
(define (snake-dead? sn)
  (or (wall-collide? (first (snake-segs sn)))
      (self-collide? sn)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Movie handlers

;; World -> World
(define (world-tick w)
  (cond [(eating? w) 
         (make-world (make-posn (add1 (random 28)) (add1 (random 28)))
                     (grow-snake (world-snake w)))]
        [else
         (make-world (world-food w)
                     (move-snake (world-snake w)))]))

;; World -> Boolean
(define (game-over? w)
  (snake-dead? (world-snake w)))

;; World KeyEvent -> World
(define (key-handler w key)
  (cond 
    [(or (string=? key "up")
         (string=? key "down")
         (string=? key "left")
         (string=? key "right"))
     (make-world (world-food w)
                 (make-snake key (snake-segs (world-snake w))))]
    [else w]))

; Start It Up
(define (main _)
  (big-bang WORLD0
            (to-draw draw-world)
            (on-tick world-tick .3)
            (on-key key-handler)
            (stop-when game-over?)))