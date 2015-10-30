;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname maze) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
(require 2htdp/universe)
(require 2htdp/image)

(define BG (empty-scene 800 800))

(define-struct room [name pos halls])
; A Room is (make-room Symbol Posn [List-of Symbol] Symbol)

(define MAZE
  (list (make-room 'A (make-posn 100 400) '(B))
        (make-room 'B (make-posn 300 400) '(A C E))
        (make-room 'C (make-posn 300 100) '(B D))
        (make-room 'D (make-posn 500 100) '(C))
        (make-room 'E (make-posn 300 700) '(B F G))
        (make-room 'F (make-posn 500 700) '(E G))
        (make-room 'G (make-posn 500 400) '(E F H))
        (make-room 'H (make-posn 700 400) '(G I J))
        (make-room 'I (make-posn 700 100) '(H))
        (make-room 'J (make-posn 700 700) '(H))))

(define START 'A)
(define GOAL  'J)

(define-struct st [path room seen])
; A State is (make-st [List-of Symbol] Symbol [List-of Symbol])
; where:
;  - Path is the path so far.
;  - Room is the current room.
;  - Seen is the list of already-tried rooms.

(define STATE0
  (make-st '() START '()))

; State -> State
; Start up the program with big-bang.
(define (main state0)
  (big-bang state0
            [to-draw render]
            [on-key  update]
            [stop-when done?]))

; State -> Image
; Draw the halls and rooms of the world.
(define (render s)
  (draw-rooms s (draw-halls BG)))

; State Image -> Image
; Add the halls to the scene.
(define (draw-halls scn)
  (foldr draw-room-halls scn MAZE))
  
; [List-of Rooms] -> [Room Image -> Image]
; Make a function that draw the halls for a room.
(define (draw-room-halls room scn)
  (foldr (draw-hall room) scn (room-halls room)))

; Room -> [Symbol Image -> Image]
; Make a function that draws a hall.
(define (draw-hall src)
  (lambda (dst-name scn)
    (local ((define dst (find-room dst-name MAZE)))
      (scene+line scn
                  (posn-x (room-pos src))
                  (posn-y (room-pos src))
                  (posn-x (room-pos dst))
                  (posn-y (room-pos dst))
                  'black))))

; Symbol [List-of Room] -> Room
; Find the room in the world by name.
(define (find-room name rs)
  (cond
    [(empty? rs) (error name)]
    [(cons? rs) (if (symbol=? name (room-name (first rs)))
                    (first rs)
                    (find-room name (rest rs)))]))

; State Image -> Image
; Add the rooms to the scene.
(define (draw-rooms s scn)
  (foldr (draw-room s) scn MAZE))

; Room Image -> Image
; Add a room to the scene.
(define (draw-room s)
  (lambda (room scn)
    (place-image (room-image room s)
                 (posn-x (room-pos room))
                 (posn-y (room-pos room))
                 scn)))

; Room -> Image
; Render the room (a circle with a letter in it.
(define (room-image room s)
  (overlay (text (symbol->string (room-name room)) 30 'black)
           (circle 40 'outline 'blue)
           (circle 40 'solid (room-color (room-name room) s))))

; Symbol State -> Symbol
; Select the room color based on the state.
(define (room-color name s)
  (cond
    [(symbol=? name (st-room s)) 'Green]
    [(member? name (st-path s)) 'PaleGreen]
    [(member? name (st-seen s)) 'Pink]
    [else 'white]))

; State -> Boolean
; Have we reached the goal?
(define (done? s)
  (symbol=? (st-room s) GOAL))

; State KeyEvent -> State
(define (update s ke)
  (local ((define room (find-room (st-room s) MAZE))
          (define (not-seen? name)
            (not (member? name (st-seen s))))
          (define exits (filter not-seen? (room-halls room))))
    (if (empty? exits)
        (make-st (rest (st-path s))
                 (first (st-path s))
                 (cons (st-room s) (st-seen s)))
        (make-st (cons (st-room s) (st-path s))
                 (first exits)
                 (cons (st-room s) (st-seen s))))))


; ----

; NN NN -> Image
; Draw a fractal triangle of a given size
; with a given number of nested levels.
(define (tri n size)
  (if (zero? n) 
      (triangle size 'outline 'green)
      (local ((define next-tri (tri (sub1 n) (/ size 2))))
        (above next-tri
               (beside next-tri next-tri)))))

