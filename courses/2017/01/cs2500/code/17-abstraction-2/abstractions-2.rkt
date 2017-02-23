;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname abstractions-2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

(define DOGS (list "husky" "beagle" "bloodhound"))
(define NUMS (list 1 2 3 4 5))


; do-to-all: [Number -> Number] [List of Number] -> [List-of Number]
; Apply a function to each element of a list.

(check-expect (map add1 NUMS)
              '(2 3 4 5 6))
(check-expect (map string-length DOGS)
              '(5 6 10))

; What's the general signature of map?

(define (apply-to-five op) (op 5))
;(apply-to-five add1)
(define (double x) (* 2 x))
;(map apply-to-five (list add1 sub1 double))

; filter: [Number -> Boolean] [List-of Number] -> [List-of Number]

(check-expect (filter even? NUMS)
              '(2 4))

(define (even-length? s)
  (even? (string-length s)))

(check-expect (filter even-length? DOGS)
              (list "beagle" "bloodhound"))

; What's the general signature of filter?

; [List-of Number] -> Number
; Sums a list of numbers.
(check-expect (sum NUMS) 15)

(define (sum xs)
  (cond [(empty? xs) 0]
        [(cons? xs) (+ (first xs)
                       (sum (rest xs)))]))

; [List-of Number] -> Number
; Calculate the product of a list of numbers.
(check-expect (prod NUMS) 120)

(define (prod xs)
  (cond [(empty? xs) 1]
        [(cons? xs) (* (first xs)
                       (prod (rest xs)))]))


(define BG (empty-scene 300 300))
(define DOT (circle 10 'solid 'blue))

; Number -> Posn
; Create a Posn with x = y = 50*n
(define (sq-posn n)
  (make-posn (* 50 n) (* 50 n)))

(define POINTS (map sq-posn NUMS))

; Posn Image -> Image
; Place a dot at the given posn.
(define (scene+dot p scn)
  (place-image DOT (posn-x p) (posn-y p) scn))

; Image [List-of Posn] -> Image
; Place a list of dots into an image.
(define (place-dots xs)
  (cond
    [(empty? xs) BG]
    [(cons? xs) (scene+dot (first xs)
                           (place-dots (rest xs)))]))


; ###
;
; Similarities between sum, product, and place-dots?
;
; ###



; [Posn Image -> Image] Image [List-of Posn] -> Image
; Combine a list into a single element given an initial
; zero (base case) value and a combining operation.
(define (fold-r op zero xs)
  (cond
    [(empty? xs) zero]
    [(cons? xs) (op (first xs)
                    (fold-r op zero (rest xs)))]))

(check-expect (fold-r scene+dot BG POINTS) (place-dots POINTS))
(check-expect (fold-r + 0 NUMS) 15)
(check-expect (fold-r * 1 NUMS) 120)

; reduce: [A B] [A B -> B] B [List-of A] -> B
; What were A and B above?

(define-struct pair [key val])
; A [Pair A B] is (make-pair A B)

; [List-of A] [List-of B] -> [List-of [Pair A B]]
; Build a lookup table.
(define (build-table keys vals)
  (cond
    [(empty? keys) empty]
    [(cons? keys) (cons (make-pair (first keys) (first vals))
                        (build-table (rest keys) (rest vals)))]))

; Can we do this with fold-r?

(define TAB1 (build-table '(a b) '(1 2)))
(check-expect TAB1 (list (make-pair 'a 1) (make-pair 'b 2)))

; [List-of [Pair A B]] A [A A -> Boolean] -> B
; Look something up in a table.
(check-expect (lookup TAB1 'b symbol=?) 2)
(check-error  (lookup TAB1 'c symbol=?) "No such key")

(define (lookup tab k eq-pred?)
  (cond
    [(empty? tab) (error "No such key")]
    [(cons? tab) (if (eq-pred? k (pair-key (first tab)))
                     (pair-val (first tab))
                     (lookup (rest tab) k eq-pred?))]))

(define NAMES (build-table '(0 1 2 3 4 5 6 7 8 9)
                           '("zero" "one" "two" "three" "four"
                             "five" "six" "seven" "eight" "nine")))

; A Digit is a number from 0 - 9.

; Number -> [List-of Digit]
; Split a number into digits.
(check-expect (digits 8314) '(8 3 1 4))

(define (digits x)
  (reverse (digits* x)))

; Number -> [List-of Digit]
; Split a number into digits, backwards.
(define (digits* x)
  (cond
    [(= x 0) empty]
    [else (cons (modulo x 10)
                (digits* (floor (/ x 10))))]))

; Can we build this with fold-r?

; Number -> [List-of String]
; Convert a number to the list of names of its digits.
(check-expect (digit-names 831) '("eight" "three" "one"))

(define (digit-names n)
  (map digit->name (digits n)))

; Digit -> String
; Convert a digit to its name.
(define (digit->name d)
  (lookup NAMES d =))