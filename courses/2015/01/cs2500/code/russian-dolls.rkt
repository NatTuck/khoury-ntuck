;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname russian-dolls) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
(require 2htdp/image)
(require 2htdp/universe)

; A Color is one of:
;  - "red"
;  - "blue"
;  ... any other color name string.

(define-struct dolls [color inner])
; A DollStack (of russian dolls) is one of
;  - A Color
;  - (make-dolls Color DollStack)
; Examples:
(define DOLL1 "red")
(define DOLL2 (make-dolls "yellow" "red"))
(define DOLL3 (make-dolls "blue"   (make-dolls "yellow" "red")))
(define DOLL5 (make-dolls "purple" (make-dolls "orange" DOLL3)))                                                        

;  - "red"
;  - (make-doll "red" "green")
;  - (make-doll "blue" (make-doll "red" "green"))
#;(define (dolls-tmpl d)
    (cond
      [(string? d) (... d ...)]
      [(dolls? d) (... (dolls-color d) ... (dolls-inner d) ...)]))

; RussianDoll -> Color
; Gives the color of the outer doll.
(check-expect (outer-color "red") "red")
(check-expect (outer-color (make-dolls "red" "green")) "red")

(define (outer-color d)
  (cond
    [(string? d) d]
    [(dolls? d) (dolls-color d)]))

; RussianDoll -> Color
; Gives the color of the innermost doll.
(check-expect (innermost-color DOLL1) "red")
(check-expect (innermost-color DOLL3) "red")

(define (innermost-color d)
  (cond
    [(string? d) d]
    [(dolls? d) (innermost-color (dolls-inner d))]))

; RussianDoll Number -> Color
; Gives the color of the Nth doll from the outside.
(check-expect (nth-color DOLL5 1) "purple")
(check-expect (nth-color DOLL5 3) "blue")

(define (nth-color d n)
  (cond
    [(= n 1) (outer-color d)]
    [else (nth-color (dolls-inner d) (- n 1))]))

; RussianDoll -> Number
; Count the dolls.
(check-expect (count-dolls DOLL1) 1)
(check-expect (count-dolls DOLL5) 5)

(define (count-dolls d)
  (cond
    [(string? d) 1]
    [(dolls? d) (+ 1 (count-dolls (dolls-inner d)))]))

; Color -> Image
; Draw a single doll.
(define (draw-one-doll size color)
  (overlay/xy (circle size "solid" color)
              (- (/ size 2)) size
              (circle (* size 1.5) "solid" color)))  

; RussianDoll -> Image
; Size to draw outer doll.
(check-expect (doll-size DOLL1) 10)
(check-expect (doll-size DOLL2) 20)
(check-expect (doll-size DOLL3) 30)

(define (doll-size d)
  (* 10 (count-dolls d)))

; RussianDoll -> Image
; Draw a stack of dolls.
(define (draw-dolls d)
  (cond
    [(string? d) (draw-one-doll (doll-size d) d)]
    [(dolls? d) (overlay (draw-dolls (dolls-inner d))
                         (draw-one-doll (doll-size d) (dolls-color d)))]))

; Other Examples of Recursion
; NOTE: Open a new racket window here so stepper is clear.

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

; Introducing Lists

; A LOS (List of Strings) is one of:
;  - empty
;  - (cons String LOS)
#;(define (los-tmpl xs)
    (cond
      [(empty? xs) ...]
      [(cons? xs)  ... (first xs) ... (rest xs) ...]))

(define LOS0 empty)
(define LOS1 (cons "One" empty))
(define LOS2 (cons "Two" LOS1))
(define LOS3 (list "Three" "Two" "One"))

; LOS -> Number
; count the number of strings in the given LOS
(define (count xs)
   (cond
     [(empty? xs) 0]
     [(cons? xs) (+ 1 (count (rest xs)))]))

; LOS -> Number
; count the number of chars in the given LOS
(define (size l)
   (cond
     [(empty? l) 0]
     [(cons? l) (+ (string-length (first l))  
                   (size (rest l)))]))


; LOS String -> Boolean
; is s on the given list?
(define (in? l s)
   (cond
     [(empty? l) false]
     [(cons? l) (or (string=? (first l) s) (in? (rest l) s))]))

; LOS String String -> LOS
; replace new with old on l
(define (replace l old new)
   (cond [(empty? l) empty]
         [(cons? l)
          (cond [(string=? (first l) old)
                 (cons new (replace (rest l) old new))]
                [else (cons (first l)
                            (replace (rest l) old new))])]))

; Common List Functions
;  - list
;  - length
;  - reverse

; LOS -> String
; Get the last string in the list.
(check-expect (last1 (list "a" "b")) "b")
(check-expect (last1 (list "a")) "a")

(define (last1 xs)
  (cond
    [(empty? (rest xs)) (first xs)]
    [else (last1 (rest xs))]))

; LOS -> String
; Simpler way to get the last string in the list.
(define (last2 xs)
  (first (reverse xs)))

; A LON (List of Numbers) is one of:
;  - empty
;  - (cons Number LON)
(check-expect (lon-min (list 2 3 1 4)) 1)

(define (lon-min xs)
  (cond
    [(empty? (rest xs)) (first xs)]
    [else (min (first xs) (lon-min (rest xs)))]))

