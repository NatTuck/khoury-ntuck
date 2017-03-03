;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname lambda) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; Today's topic: Lambda and Variable Scope

(define-struct bar [x y])
; [Bar X Y] is (make-bar X Y)

; Signature?
(define (bar-x-map bars)
  (map bar-x bars))

; [List-of Number] -> [List-of Number]
; Add 2 to each number in a list.
(check-expect (all+2 '(1 2 3)) '(3 4 5))

(define (all+2 xs)
  (local (; Number -> Number
          ; Add two to a number.
          (define (add2 x)
            (+ x 2)))
  (map add2 xs)))

; [List-of Number] -> [List-of Number]
; Add 2 to each number in a list
(check-expect (map+2 (list 1 2)) (list 3 4))

(define (map+2 xs)
  (map (lambda (x) (+ x 2)) xs))


; Number -> Number
; Add 5 to a number.
(check-expect (add5 3) 8)

(define (add5 x)
  ((lambda (y) (+ y 5)) x))

; Number -> Number
; Add 6 to a number.
(check-expect (add6 1) 7)
(define add6
  (lambda (x)
    (+ x 6)))

; Number Number -> Number
; Add two numbers together.
(check-expect (add 1 3) 4)

(define add
  (lambda (x y)
    (+ x y)))


; [List-of Number] -> Number
; Sum the numbers in the list, plus one per
; addition performed.
(check-expect (sum+adds (list 1 2 3)) 9)

(define (sum+adds xs)
  (foldl (lambda (x y) (+ x y 1)) 0 xs))


; [List-of Number] -> [List-of Number]
; Return the numbers divisible by four.
(check-expect (muls-of-4 (list 2 8 6 3 32)) (list 8 32))

(define (muls-of-4 xs)
  (filter (lambda (x) (= 0 (modulo x 4))) xs))


; [List-of Number] -> [List-of Number]
; Find the xth powers of 2.
(check-expect (pows-of-2 (list 1 2 3 4)) (list 2 4 8 16))

(define (pows-of-2 xs)
  (map (lambda (x) (expt 2 x)) xs))

; [List-of Posn] -> Posn
; Find the Posn with the largest coordinate.
(check-expect (max-coord (list (make-posn 3 5) (make-posn 0 8) (make-posn 10 2)))
              (make-posn 10 2))

(define (max-coord xs)
  (argmax (lambda (p) (max (posn-x p) (posn-y p))) xs))


; Number -> [Number -> Number]
; Return a function that adds x to a number.
(check-expect ((adder 3) 5) 8)

(define (adder x)
  (lambda (y) (+ x y)))

; Substitution
;  ((adder 5) 7)
;  ((lambda (y) (+ 5 y)) 7)
;  (+ 5 7)
;  12

(define (deriv f)
  (lambda (x)
    (/ (- (f (+ x 0.0001))
          (f (- x 0.0001)))
       0.0002)))

;;; Computing computations! 
((deriv sin) 0)


; Number -> Number
; A simple function.
(check-expect (foo 2 3) 6)

(define (foo x y)
  ((lambda (x) (+ x y)) y))
   
; Substitution doesn't quite work.
; (foo 2 3)
; ((lambda (y) (+ 2 3) 2)
; (+ 2 3)
; 5

; The way it actually works: Scopes.
;
; Every function is really a lambda.
(check-expect (add2 3) (add2_ 3))
(define (add2_ x)
  (+ x 2))

(define add2
  (lambda (x) (+ x 2)))

; Every lambda makes a "scope", binding names to variables.

; (foo 2 3)
;  
; ((lambda (x) (+ x y)) y))
;  where x = 2, y = 3 in this scope
;
; ((lambda (x) (+ x y)) 
;     3 ; need a concrete value, take it from the scope
;      ))
;  where x = 2, y = 3 in this scope
;
; (+ x y)
;  where x = 3 in this scope
;  where x = 2, y = 3 in the outer scope
;
; (+ 3 ; from this scope
;    3 ; from the outer scope
;     )
;
; Draw the scopes on the chalk board.

(define d 7)

(define bar
  (lambda (a b c)
    (local ((define bar1
              (lambda (x y)
                (+ a x y)))
            (define bar2
              (lambda (x y)
                (+ b x y d))))
      (- (bar2 a b) (bar1 b c) d))))

(check-expect (bar 3 2 1) 1)
; Draw this out on the chalkboard, including the
; global scope.

; Pull up local.rkt and do examples of scope and lambda from there.



