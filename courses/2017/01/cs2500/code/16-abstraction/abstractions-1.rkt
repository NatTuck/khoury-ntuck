;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname abstractions-1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define ANIMALS (list "monkey" "cat" "dog"))
(define PLANTS  (list "shrub" "flower" "tree"))

; LOS -> Boolean
; Does the list contain "dog"?
(check-expect (contains-dog? PLANTS) false)
(check-expect (contains-dog? ANIMALS) true)

(define (contains-dog? l)
  (cond
    [(empty? l) false]
    [else
     (or (string=? (first l) "dog")
         (contains-dog? (rest l)))]))

; LOS -> Boolean
; Does the list contain "cat"?
(check-expect (contains-cat? PLANTS) false)
(check-expect (contains-cat? ANIMALS) true)

(define (contains-cat? l)
  (cond
    [(empty? l) false]
    [else
     (or (string=? (first l) "cat")
         (contains-cat? (rest l)))]))

; String LOS -> Boolean
; Does the list contain the given string?
(check-expect (contains? "tree" ANIMALS) false)
(check-expect (contains? "cat" ANIMALS) true)

(define (contains? x xs)
  (cond
    [(empty? xs) false]
    [else (or (string=? (first xs) x)
              (contains? x (rest xs)))]))

; LOS -> Boolean
; Does the list contain the string "cat"?

; NOTE: Go back and replace old contains-cat, contains-dog
;   and show the existing tests still work.
(define (contains-cat?* xs)
  (contains? "cat" xs))

(define (contains-dog?* xs)
  (contains? "dog" xs))


(define NUMS (list 1 2 3 4 5 6 7 8 9))

; LON -> LON
; Take the numbers greater than 5.
(check-expect (take-over-5 NUMS) (list 6 7 8 9))

(define (take-over-5 xs)
  (cond
    [(empty? xs) empty]
    [(cons? xs) (if (> (first xs) 5)
                    (cons (first xs) (take-over-5 (rest xs)))
                    (take-over-5 (rest xs)))]))

; LON -> LON
; Take the even numbers.
(check-expect (take-evens NUMS) (list 2 4 6 8))

(define (take-evens xs)
  (cond
    [(empty? xs) empty]
    [(cons? xs) (if (even? (first xs))
                    (cons (first xs) (take-evens (rest xs)))
                    (take-evens (rest xs)))]))

; Number -> Boolean
; Is the number greater than 5?
(check-expect (over-five? 3) false)
(check-expect (over-five? 8) true)

(define (over-five? x)
  (> x 5))

; LON ??? -> LON
; LON [Number -> Boolean] -> LON
; Take the numbers that satisfy the predicate.
(check-expect (take-by even? NUMS)      '(2 4 6 8))
(check-expect (take-by over-five? NUMS) '(6 7 8 9))

(define (take-by pred? xs)
  (cond
    [(empty? xs) empty]
    [(cons? xs) (if (pred? (first xs))
                    (cons (first xs) (take-by pred? (rest xs)))
                    (take-by pred? (rest xs)))]))


; NOTE: Now go back and implement take-over-5, take-evens with take-by.


(define (add1-to-all xs)
  (cond [(empty? xs) empty]
        [(cons? xs) (cons (+ 1 (first xs))
                          (add1-to-all (rest xs)))]))

(define (add5-to-all xs)
  (cond [(empty? xs) empty]
        [(cons? xs) (cons (+ 5 (first xs))
                          (add5-to-all (rest xs)))]))

; Abstract with parameter.
(define (addn-to-all n xs)
  (cond [(empty? xs) empty]
        [(cons? xs) (cons (+ n (first xs))
                          (add5-to-all (rest xs)))]))
  
(define (square-all xs)
  (cond [(empty? xs) empty]
        [(cons? xs) (cons (sqr (first xs))
                          (add5-to-all (rest xs)))]))

; Abstract with function parameter.

; LON [Number -> Number] -> LON
; Apply a function to each item in a LON.
(check-expect (do-to-all number->string (list 2 3)) (list "2" "3"))

(define (do-to-all fn xs)
  (cond
    [(empty? xs) empty]
    [(cons? xs) (cons (fn (first xs))
                      (do-to-all fn (rest xs)))]))

; [Number -> Number] -> Number
(define (do-to-five op)
  (op 5))

;(do-to-5 add1)
; Number -> Number
(define (double x)
  (* 2 x))

; (do-to-all do-to-five (list add1 sub1 double))
; Wait... that's doesn't match the signature...



