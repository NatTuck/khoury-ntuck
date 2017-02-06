;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname bouncing-balls) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

; A Ball is (make-ball Symbol Number Posn Posn)
(define-struct ball [color size pos vel])

; Posn for vel: It's a position in velocity space?

#;
(define (ball-tmpl b)
  (... (ball-color b) ...
       (ball-size b) ...
       (posn-tmpl (ball-pos b)) ...
       (posn-tmpl (ball-vel b)) ...))

(define B1 (make-ball 'red 10 (make-posn 100 100) (make-posn 0 0)))
(define B2 (make-ball 'blue 15 (make-posn 200 200) (make-posn 4 -2)))

; A LoB (List of Balls) is one of:
;  - empty
;  - (cons Ball LoB)

; TODO: Explain "list"
(define BS (list B1 B2))
(define G  (make-posn 0 1))

#;
(define (lob-tmpl bs)
  (cond [(empty? bs) ...]
        [(cons? bs) ... (ball-tmpl (first bs)) ...
                    ... (lob-tmpl (rest bs)) ...]))

; Our World is a LoB

(define BG (empty-scene 800 800))

; LoB -> Image
; Draw the world.
(check-expect (draw-world BS)
              (draw-one-ball B1 (draw-one-ball B2 BG)))

(define (draw-world bs)
  (cond [(empty? bs) BG]
        [(cons? bs) (draw-one-ball (first bs)
                                   (draw-world (rest bs)))]))

; Ball Image -> Image
; Draw one ball on the background.
(check-expect (draw-one-ball B1 BG)
              (place-image (circle (ball-size B1) 'solid (ball-color B1))
                           (posn-x (ball-pos B1))
                           (posn-y (ball-pos B1))
                           BG))

(define (draw-one-ball b bg)
  (place-image (circle (ball-size b) 'solid (ball-color b))
               (posn-x (ball-pos b))
               (posn-y (ball-pos b))
               bg))  

; LoB -> LoB
; Reset the world.
(define (reset-world bs _ke)
  (random-world (length bs))) 

; Number -> Ball
; Generate a random ball
(check-expect (ball? (random-ball 4)) true)

(define (random-ball x)
  (make-ball (number->color (modulo x 4))
             (+ 5 (random 20))
             (make-posn (random 800) (random 800))
             (make-posn 0 0)))

; Number -> Symbol
; Pick a color.
(define (number->color nn)
  (cond [(= nn 0) 'red]
        [(= nn 1) 'blue]
        [(= nn 2) 'orange]
        [else 'purple]))

; NN -> LoB
; Generate a random world.
(check-expect (length (random-world 10)) 10)
 
(define (random-world nn)
  (cond [(zero? nn) empty]
        [else (cons (random-ball nn)
                    (random-world (sub1 nn)))]))

; LoB -> LoB
; Generate the next world.
(define (update-world bs)
  (update-balls bs bs))

; LoB LoB -> LoB
; Update each ball.
(define (update-balls bs all)
  (cond [(empty? bs) empty]
        [(cons? bs) (cons (update-one-ball (first bs) all)
                          (update-balls (rest bs) all))]))

; Ball LoB -> Ball
; Update one ball.
(define (update-one-ball b all)
  (make-ball (ball-color b)
             (ball-size b)
             (move-posn (ball-pos b) (ball-vel b))
             (if (< (- 800 (posn-y (ball-pos b))) (posn-y (ball-vel b)))
                 (make-posn (posn-x (ball-vel b))
                            (- (posn-y (ball-vel b))))
                 (move-posn (ball-vel b) G))))

; Posn Posn -> Posn
; Add two posns.
(define (move-posn p dp)
  (make-posn (+ (posn-x p) (posn-x dp))
             (+ (posn-y p) (posn-y dp))))

(define (main nn)
  (big-bang (random-world nn)
            [to-draw draw-world]
            [on-tick update-world]
            [on-key reset-world]))

