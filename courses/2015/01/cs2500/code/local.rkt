;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname local) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ())))
; [List-of Number] -> [List-of Number]
; Add two to each number in a list.
(check-expect (all+2 '(1 2 3)) '(3 4 5))

(define (all+2 xs)
  (local (; Number -> Number
          ; Add two to a number.
          (define (add2 x)
            (+ x 2)))
  (map add2 xs)))


; Number [List-of Number] -> [List-of Number]
; Add a value to each number in a list.
(check-expect (all+x 5 '(6 3 10)) '(11 8 15))

(define (all+x x xs)
  (local (; Number -> Number
          ; Add x to a number.
          (define (addx y)
            (+ x y)))
    (map addx xs)))


; Posn Posn -> Number
; Find the distance between two points.
(check-expect (distance (make-posn 0 0) (make-posn 0 10)) 10)

(define (distance p0 p1)
  (local ((define dx (- (posn-x p0) (posn-x p1)))
          (define dy (- (posn-y p0) (posn-y p1))))
    (sqrt (+ (sqr dx) (sqr dy)))))


(define-struct truck [name mpg tank-size])
; A Truck is (make-truck String Number Number)

; Truck -> Number
; Get the truck range.
(define (truck-range t)
  (* (truck-mpg t) (truck-tank-size t)))

(define TRUCKS
  (local (; Number -> Truck
          ; Generate an arbitrary truck.
          (define (gen-truck n)
            (make-truck (string-append "Truck#" (number->string n))
                        (- 35 n)
                        (add1 n))))
    (build-list 35 gen-truck)))

; [List-of Truck] -> Truck
; Get the truck with the best range.
(define (best-range1 ts)
  (cond
    [(empty? ts) (make-truck "None" 0 0)]
    [else (if (> (truck-range (first ts)) 
                 (truck-range (best-range1 (rest ts))))
              (first ts)
              (best-range1 (rest ts)))]))
              

; [List-of Truck] -> Truck
; Get the truck with the best range.
(define (best-range2 ts)
  (cond
    [(empty? ts) (make-truck "None" 0 0)]
    [else (local ((define best-rest (best-range2 (rest ts))))
            (if (> (truck-range (first ts))
                   (truck-range best-rest))
                (first ts)
                best-rest))]))

; [List-of Truck] -> Truck
; Get the truck with the best range.
(define (best-range ts)
  (argmax truck-range ts))


; [X -> Boolean] [List-of X] -> [List-of X]
; Take the items in a list that satisfy the predicate.
(check-expect (filter* even? '(1 2 3 4)) (filter even? '(1 2 3 4)))

(define (filter* pred? xs)
  (local (; X [List-of X] -> [List-of X]
          ; Stick the item on a list if it satisfies the predicate.
          (define (cons-if x ys)
            (if (pred? x)
                (cons x ys)
                ys)))
    (foldr cons-if empty xs)))

; Number -> [List-of Number]
; Generate a list of n random numbers.
(check-expect (length (random-list 5)) 5)

(define (random-list n)
  (local (; Any -> Number
          ; Generate a random number, 1 - 10.
          (define (roll _)
            (add1 (random 10))))
    (build-list n roll)))

; [List-of Number] -> [List-of Number]
; Sort a list of numbers in increasing order.
(check-expect (isort '(1 0 3 9 5)) '(0 1 3 5 9))
(define TEST-LIST (random-list 100))
(check-expect (isort TEST-LIST) (sort TEST-LIST <))

(define (isort xs)
  (local (; Number [List-of Number] -> [List-of Number]
          ; Inserts a number into a sorted list.
          ; If the next item is bigger than x, insert x before it.
          (define (insert x ys)
            (cond
              [(empty? ys) (list x)]
              [(> (first ys) x) (cons x ys)]
              [else (cons (first ys) (insert x (rest ys)))])))
    (foldr insert empty xs)))

; Insert is local to make sure it doesn't get used on
; unsorted lists.


(define WSIZE 100)

; [List-of Posn] -> [List-of Posn]
; Remove any Posns that are off screen.
(define (remove-offscreen lop)
  (local ((define (good? p)
	    (and (<= 0 (posn-x p) WSIZE)
		 (<= 0 (posn-y p) WSIZE))))
    (filter good? lop)))

(check-expect 
 (remove-offscreen (list (make-posn 50 50) (make-posn 50 102)))
 (list (make-posn 50 50)))



; apply: [X* -> Y] [List-of X] -> Y
; Pass a list as arguments to a function.
(check-expect (apply + '(1 2)) 3)

; [List-of Number] -> Number
; Calculate the sum of a list.
(check-expect (sum1 '(1 2 3)) 6)

(define (sum1 xs)
  (foldr + 0 xs))

(check-expect (sum '(1 2 3)) 6)

(define (sum xs)
  (apply + xs))

; [List-of Number] -> Boolean
; Is the list sorted in ascending order?
(check-expect (sorted? '(1 2 3)) true)
(check-expect (sorted? '(2 1 3)) false)

(define (sorted? xs)
  (apply < xs))


; [X -> Boolean] [List-of X] -> Boolean
; Do all the items in the list satisfy the predicate?
(check-expect (andmap* even? '(2 4 6)) true)
(check-expect (andmap* odd? '(2 3 5)) false)

#;(define (andmap** pred? xs)
  (local ((define (boolean->number b)
            (if b 1 0)))
    (apply and (map pred? xs))))

; Boolean -> Number
; true -> 1, false -> 0
(define (bool->num b)
  (if b 1 0))

; Number -> Boolean
; 1 -> true, 0 -> false
(define (num->bool n)
  (if (= n 1) true false))

(define (andmap* pred? xs)
  (num->bool (apply * (map bool->num (map pred? xs)))))
