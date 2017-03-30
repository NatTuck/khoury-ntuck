;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname accum) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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

;; [List-of X] -> [List-of X]
;; Reverse a list.

(check-expect (reverse1 '(a b c d)) '(d c b a))

(define (reverse1 l)
  (cond
    [(empty? l) empty]
    [else (append (reverse1 (rest l)) (list (first l)))]))

(check-expect (reverse2 '(a b c d)) '(d c b a))

(define (reverse2 l)
  (local ((define (reverse l seen)
            (cond
              [(empty? l) seen]
              [else (reverse (rest l) (cons (first l) seen))])))
    (reverse l empty)))

; Fibonacci
;  f(0) = 1
;  f(1) = 1
;  f(x) = f(x-1) + f(x-2) when x > 1

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

; Why is this slow?
;  - Double recursion, just like with the "biggest" function.
;  - Draw it.
;  - What if we remembered what we're doing, rather than recalculating?

; NN -> NN
; Calculate the nth Fibonacci number.
(check-expect (fib2 0) 1)
(check-expect (fib2 1) 1)
(check-expect (fib2 7) 21)

(define (fib2 n)
  (local (; NN NN NN -> NN
          ; Add accumulators for n and n-1.
          (define (fib-acc x fx fx-1)
            (cond
              [(= x n) fx]
              [else (fib-acc (add1 x) (+ fx fx-1) fx)])))
    (fib-acc 0 1 0)))

#;(fib1 35)
#;(fib2 35)
#;(fib2 100)

; We could call this the "accumulator" solution, but it's also known
; as the "iterative" solution. Other languages have a "loop" mechanism
; that is frequently used in place ofrecursion, and this is equivilent
; to that.

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


; Abstraction: What's similar between product and reverse2?

; [X Y -> Y] Y [List-of X] -> Y
; Reduce a list, given an initial accumulator.
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

;; [List-of Number] -> [List-of Number]
;; Convert a list of relitive distances to a list of absolute distances
;; from the start point.

(check-expect (relative->absolute '(1 2 2 2 1)) '(1 3 5 7 8))

(define (relative->absolute.v0 l) 
  (cond
    [(empty? l) empty]
    [else (local ((define fst (first l))
                  (define rst (relative->absolute (rest l))))
            (cons fst (map (lambda (x) (+ fst x)) rst)))]))

(define (relative->absolute l) 
  (local (;; [Listof Number] Number -> [Listof Number]
          ;; accumulator: how far have we gone by now? 
          (define (convert l up-to-here)
            (cond
              [(empty? l) empty]
              [else (local ((define fst (first l))
                            (define acc (+ fst up-to-here)))
                      (cons acc (convert (rest l) acc)))])))
    (convert l 0)))

(define-struct two (sum rest))
;; NN [Listof Number] -> (make-two NN [Listof Number])
;; remove the first n items from l and record their sum and the rest
(check-expect (pick 3 '(1 2 3 4)) (make-two 6 '(4)))
(check-expect (pick 3 '(1 2)) (make-two 3 '()))

(define (pick.v0 n l)
  (cond
    [(empty? l) (make-two 0 empty)]
    [(zero? n) (make-two 0 l)]
    [else (local ((define r (pick (sub1 n) (rest l))))
            (make-two (+ (first l) (two-sum r)) (two-rest r)))]))

(define (pick n l)
  (local ((define (pick n l sum)
            (cond
              [(empty? l) (make-two sum empty)]
              [(zero? n) (make-two sum l)]
              [else (pick (sub1 n) (rest l) (+ (first l) sum))])))
    (pick n l 0)))



