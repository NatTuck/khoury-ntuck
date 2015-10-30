;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname snake-sp15) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
(require 2htdp/image)
(require 2htdp/universe)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Data definitions

(define SEG-RADIUS 10)
(define GRID-SIZE (* 2 SEG-RADIUS))
(define SNAKE-SEG-IMG (circle SEG-RADIUS 'solid 'red))
(define FOOD-SEG-IMG (circle SEG-RADIUS 'solid 'green))
(define WSIZE (* 30 GRID-SIZE))
(define BG (empty-scene WSIZE WSIZE))

;; Number Number -> Posn
;; Make a Posn at the given grid position.
(define (grid-posn x y)
  (make-posn (* x GRID-SIZE) (* y GRID-SIZE)))

;;a World is a (make-world Food Snake)
(define-struct world (food snake))

;; a Snake is a (make-snake symbol LoSegments)
(define-struct snake (dir segs))

(define snake1 (make-snake 'up 
                           (cons (grid-posn 3 1) empty)))

(define snake3 (make-snake 'down 
                           (list (grid-posn 3 2)
                                 (grid-posn 4 2)
                                 (grid-posn 5 2))))

;; a LoSegments is one of
;;  - empty
;;  - (cons posn LoSegments)

; LoSegments -> ?
#;(define (los-temp a-los)
    (cond [(empty? a-los) ...]
          [(cons? a-los) ...(first a-los) ... 
                         (los-temp (rest a-los))]))

;; A Food is a Posn

;; A Dir is one of:
;;  - 'up
;;  - 'down
;;  - 'left
;;  - 'right

(define world0 (make-world (grid-posn 7 10) snake3))
                           
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Drawing the Snake

;; Posn Image -> Image
;; Draw one segment of the snake onto the scene
(define (draw-seg p scn)
  (place-image SNAKE-SEG-IMG
               (posn-x p)
               (posn-y p)
               scn))

(check-expect (draw-seg (make-posn 300 150) BG)
              (place-image SNAKE-SEG-IMG 300 150 BG))

;; LoSegments Image -> Image
;; Draw the snake segments onto the scene
(define (draw-segs a-los scn)
  (cond [(empty? a-los) scn]
        [(cons? a-los) 
         (draw-segs (rest a-los)
                    (draw-seg (first a-los) scn ))]))

;; Snake -> Image
;; Draw the snake onto the scene
;; Need a draw function with one input to work with big-bang
(define (draw-snake sn)
  (draw-segs (snake-segs sn) BG))

(check-expect (draw-segs (snake-segs snake1) BG)
              (place-image SNAKE-SEG-IMG 60 20 BG))


;; World -> Image
;; Draw the world (snake, food)
(define (draw-world w)
  (place-image FOOD-SEG-IMG
               (posn-x (world-food w))
               (posn-y (world-food w))
               (draw-snake (world-snake w))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Moving and growing the snake

;; Posn Dir -> Posn
;; Move a segment in the direction specified
(define (move-seg p d)
  (cond [(symbol=? d 'up)
         (make-posn (posn-x p) (- (posn-y p) (* 2 SEG-RADIUS)))]
        [(symbol=? d 'down)
         (make-posn (posn-x p) (+ (posn-y p) (* 2 SEG-RADIUS)))]
        [(symbol=? d 'left)
         (make-posn (- (posn-x p) (* 2 SEG-RADIUS)) (posn-y p))]
        [(symbol=? d 'right)
         (make-posn (+ (posn-x p) (* 2 SEG-RADIUS)) (posn-y p))]))

(check-expect (move-seg (grid-posn 1 3) 'up)
              (grid-posn 1 2))

(check-expect (move-seg (grid-posn 1 3) 'down)
              (grid-posn 1 4))

;; LoSegments -> LoSegments
;; Take all but the last snake segment.
(define (all-but-last a-los)
  (cond [(empty? (rest a-los)) empty]
        [(cons? a-los) (cons (first a-los) 
                             (all-but-last (rest a-los)))]))

(check-expect (all-but-last (list (make-posn 30 15)
                                  (make-posn 40 15)
                                  (make-posn 50 15) ))
              (list (make-posn 30 15)
                    (make-posn 40 15)))

;; Snake -> Snake
;; Move the snake in the direction specified
(define (move-snake sn)
  (make-snake 
   (snake-dir sn) 
   (cons (move-seg (first (snake-segs sn)) (snake-dir sn))
         (all-but-last (snake-segs sn)))))

(check-expect (move-snake snake3)
              (make-snake 'down 
                          (list (grid-posn 3 3)
                                (grid-posn 3 2)
                                (grid-posn 4 2))))

;; Snake -> Snake
;; Grow the snake.
(define (grow-snake sn)
  (make-snake 
   (snake-dir sn) 
   (cons (move-seg (first (snake-segs sn)) (snake-dir sn))
         (snake-segs sn))))

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
  (or (< (posn-x p1) 0)
      (>= (posn-x p1) WSIZE)
      (< (posn-y p1) 0)
      (>= (posn-y p1) WSIZE)))

;; Posn LoSegments -> Boolean
;;did the head of the snake collide with any other snake segment?
(define (segs-collide? head body)
  (cond [(empty? body) false]
        [(posn=? head
                 (first body)) true]
        [else (segs-collide? head (rest body))]))

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
         (make-world (grid-posn (random 30) (random 30))
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
                 (make-snake (string->symbol key)
                             (snake-segs (world-snake w))))]
    [else w]))

; Start It Up
#;(big-bang world0
          (to-draw draw-world)
          (on-tick world-tick .3)
          (on-key key-handler)
          (stop-when game-over?))