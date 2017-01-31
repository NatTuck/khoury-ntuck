;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname russian-dolls) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

; A Color is one of:
;  - 'red
;  - 'blue
;  ... any other color name string.

; introduce symbols

(define-struct shell [color inner])
; A RD (Russion Doll) s one of
;  - A Color
;  - (make-shell color RD)
; interp:
; Just a color is the innermost doll.
; A shell is hollow doll and all the dolls within.

; Examples:
(define DOLL1 'red)
(define DOLL2 (make-shell 'yellow 'red))
(define DOLL3 (make-shell 'blue   (make-shell 'yellow 'red)))
(define DOLL5 (make-shell 'purple (make-shell 'orange DOLL3)))                                                        

;; RD -> number
;; count the number of layers of a Russian Doll
#;
(define (rd-layers rd)
  (cond ((symbol? rd) ...)
        <tedious etc>...))

#;(define (rd-tmpl d)
    (cond
      [(symbol? d) (... d ...)]
      [(shell? d) (... (shell-color d) ... (shells-inner d) ...)]))

; RD -> Number
; Count the dolls.
(check-expect (count-dolls DOLL1) 1)
(check-expect (count-dolls DOLL5) 5)

(define (count-dolls d)
  (cond
    [(symbol? d) 1]
    [(shell? d) (+ 1 (count-dolls (shell-inner d)))]))

; RD -> Color
; Gives the color of the outer doll.
(check-expect (outer-color 'red) 'red)
(check-expect (outer-color (make-shell 'red 'green)) 'red)

(define (outer-color d)
  (cond
    [(symbol? d) d]
    [(shell? d) (shell-color d)]))

; RD -> Color
; Gives the color of the innermost doll.
(check-expect (innermost-color DOLL1) 'red)
(check-expect (innermost-color DOLL3) 'red)

(define (innermost-color d)
  (cond
    [(symbol? d) d]
    [(shell? d) (innermost-color (shell-inner d))]))

; RD Number -> Color
; Gives the color of the Nth doll from the outside.
(check-expect (nth-color DOLL5 1) 'purple)
(check-expect (nth-color DOLL5 3) 'blue)

(define (nth-color d n)
  (cond
    [(= n 1) (outer-color d)]
    [else (nth-color (shell-inner d) (- n 1))]))

; Number Color -> Image
; Draw a single doll.
(define (draw-one-doll size color)
  (overlay/xy (circle size "solid" color)
              (- (/ size 2)) size
              (circle (* size 1.5) "solid" color)))  

; RD -> Number
; Size to draw outer doll.
(check-expect (doll-size DOLL1) 10)
(check-expect (doll-size DOLL2) 20)
(check-expect (doll-size DOLL3) 30)

(define (doll-size d)
  (* 10 (count-dolls d)))

; RD -> Image
; Draw a stack of dolls.
(define (draw-dolls d)
  (cond
    [(symbol? d) (draw-one-doll (doll-size d) d)]
    [(shell? d) (overlay (draw-dolls (shell-inner d))
                         (draw-one-doll (doll-size d) (shell-color d)))]))

; Other Examples of Recursion
; NOTE: Open a new racket window here so stepper is clear.

; A NN (Natural Number) is one of:
;  - 0
;  - (add1 NN)
#;
(define (nn-tmpl x)
  (cond [(zero? x) ...]
        [else (nn-tmpl (sub1 x))]))


; Number -> Number
; Raise x to the yth power.
(check-expect (pow 3 2) 9)
(check-expect (pow 3 3) 27)
(check-expect (pow 8 0) 1)
(check-expect (pow 2 9) 512)

(define (pow x y)
  (cond
    [(zero? y) 1]
    [else (* x (pow x (- y 1)))]))

#;(pow 2 5) ; <- try the stepper on this
