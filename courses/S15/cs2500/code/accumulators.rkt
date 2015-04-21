;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname accumulators) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))

; Accumulators

; Problem: Sum a list of numbers.

; [List-of Number] -> Number
; Produce the sum of the numbers in the list.
(check-expect (sum1 '()) 0)
(check-expect (sum1 '(5 5 8)) 18)

(define (sum1 xs)
  (cond
    [(empty? xs) 0]
    [(cons? xs) (+ (first xs)
                   (sum1 (rest xs)))]))

; [List-of Number] -> Number
; Sum a list of numbers.
(check-expect (sum2 '()) 0)
(check-expect (sum2 '(5 5 8)) 18)

(define (sum2 xs0)
  (sum2-acc xs0 0))

(define (sum2-acc xs acc)
  (cond
    [(empty? xs) acc]
    [(cons? xs) (sum2-acc (rest xs) (+ acc (first xs)))]))

; NN -> NN
; Calculate the nth Fibonacci number
(check-expect (fib1 0) 1)
(check-expect (fib1 1) 1)
(check-expect (fib1 7) 21)

(define (fib1 n)
  (cond
    [(= n 0) 1]
    [(= n 1) 1]
    [else (+ (fib1 (- n 1)) (fib1 (- n 2)))]))

#;(fib1 100)

; Each call to fib1 generates two calls to fib1: 
;        fib1(n-1) and fib1(n-2).
; So that's at least 2^(n/2) calls.
; For n = 100, that's >2^50 calls, which is too many for a computer.

; Problem:
;   Given a [List-of X], reverse it.

; [List-of X] -> [List-of X]
; Reverse a list.
(check-expect (reverse1 empty) empty)
(check-expect (reverse1 '(1 2 3)) '(3 2 1))

(define (reverse1 xs)
  (cond
    [(empty? xs) empty]
    [(cons? xs) (snoc (first xs)
                      (reverse1 (rest xs)))]))

; X [List-of X] -> [List-of X]
; Append x to the end of the list.
(check-expect (snoc 5 empty) '(5))
(check-expect (snoc 5 '(1 2)) '(1 2 5))

(define (snoc x xs)
  (cond
    [(empty? xs) (list x)]
    [(cons? xs) (cons (first xs)
                      (snoc x (rest xs)))]))

; Efficiency:
;  - 'reverse1' traverses the entire list, calling 'snoc' on each element.
;  - 'snoc' traverses entire list to put the element at the end.
;  = ~ n^2 operations.


; Ok, can we fix fib1 and reverse1 by
; adding an accumulator?

; NN -> NN
; Calculate the nth Fibonacci number.
(check-expect (fib2 0) 1)
(check-expect (fib2 1) 1)
(check-expect (fib2 7) 21)

(define (fib2 n)
  (local (; NN NN NN -> NN
          ; Add accumulators for n and n-1.
          (define (fib-acc x fn fn-1)
            (cond
              [(= x n) fn]
              [else (fib-acc (add1 x) (+ fn fn-1) fn)])))
    (fib-acc 0 1 0)))

#;(fib2 100)
#;(fib1 35)
#;(fib2 35)

; 'fib2' calculates fib(n) in n calls to fib.

; [List-of X] -> [List-of X]
; Reverse a list.
(check-expect (reverse2 empty) empty)
(check-expect (reverse2 '(1 2 3)) '(3 2 1))

(define (reverse2 xs)
  (local (; [List-of X] [List-of X] -> [List-of X]
          (define (rev2a xs acc)
            (cond
              [(empty? xs) acc]
              [(cons? xs) (rev2a (rest xs)
                                 (cons (first xs) acc))])))
    (rev2a xs empty)))

; 'reverse2' reverses the list in one pass over the list,
; calling 'cons' each time. Cons is a single operation.
;  = ~n operations

; Back to slides.


; Designing an Accumulator Function

;Template:
; Thing -> Stuff
; Turn a Thing into some Stuff.
; Accumulator Invariant:
;  - The accumulator holds the stuff, with every thing we've seen processed.
#;(define (acc-fn-tmpl thing0)
    (local (; Thing Stuff -> Stuff
            (define (tmpl-a thing acc)
              (cond
                [(done? thing) acc]
                [else (tmpl-a (next thing) (op thing acc))])))
      (tmpl-a thing0 acc0)))

; Problem: Find the product of a list of numbers.

; [List-of Number] -> Number
; Calculate the product of a list of numbers.
; Accumulator Invariant:
;  - The accumulator contains the product of the numbers seen so far.
(check-expect (product '()) 1)
(check-expect (product '(1 2 3)) 6)

(define (product xs0)
  (local (; [List-of Number] Number -> Number
          ; Product with an accumulator.
          (define (prod-a xs acc)
            (cond
              [(empty? xs) acc]
              [(cons? xs) (prod-a (rest xs) (* acc (first xs)))])))
    (prod-a xs0 1)))

; [List-of X] -> [List-of X]
; Reverse a list.
(check-expect (reverse3 empty) empty)
(check-expect (reverse3 '(1 2 3)) '(3 2 1))

(define (reverse3 xs)
  (foldl cons empty xs))

; [X Y -> Y] Y [List-of X] -> Y
; Reduce a list from right to left, given an operator
; and a base case.
(check-expect (foldl* cons empty '(1 2 3)) '(3 2 1))

(define (foldl* op acc xs)
  (cond
    [(empty? xs) acc]
    [(cons? xs) (foldl* op 
                        (op (first xs) acc) 
                        (rest xs))]))

; Let's compare this to foldr:
(check-expect (foldr* cons empty '(1 2 3)) '(1 2 3))

(define (foldr* op base xs)
  (cond
    [(empty? xs) base]
    [(cons? xs) (op (first xs)
                    (foldr* op base (rest xs)))]))



; Start with "actual-graph-notes.rkt"

; Graph [List-of Node] Node [List-of Node] -> [Maybe [List-of Node]]
; Find path in graph with accumulator.
;(check-expect (find-path3 G1 'E 'D '()) false)
;(check-expect (find-path3 G1 'D 'E '()) '(D E))
;(check-expect (find-path3 G1 'A 'E '()) '(A B C D E))
;(check-expect (find-path3 G2 'A 'E '()) '(A B C D E))

#;(define (find-path3 graph x y seen)
  (if (symbol=? x y)
      (list x)
      (local (; Node -> Boolean
              ; Is this a node we haven't visited before?
              (define (never-seen? n)
                (not (member? n seen)))
              (define maybe-path
                (find-path3/list graph 
                                 (filter never-seen? (neibs graph x))
                                 y
                                 (cons x seen))))
        (if (boolean? maybe-path)
            false
            (cons x maybe-path)))))
  
; Graph [List-of Node] Node -> [Maybe [List-of Node]]
; Find a path in the graph from a node in xs to y, if any.
#;(define (find-path3/list graph xs y seen)
  (if (empty? xs) false
      (local ((define maybe-path
                (find-path3 graph (first xs) y seen)))
        (if (list? maybe-path)
            maybe-path
            (find-path3/list graph (rest xs) y seen)))))