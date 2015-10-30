;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname abstractions-2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
(require 2htdp/image)

; A LOS (List of Strings) is one of:
;  - empty
;  - (cons String LOS)

; A LON (List of Numbers) is one of:
;  - empty
;  - (cons String LON)

; A [List-of T] is one of:
;  - empty
;  - (cons T [List-of T])

; This is a [List-of Number]:
(define NUMS (list 1 2 3 4 5))

; This is a [List-of String]:
(define DOGS (list "husky" "mastiff" "poodle"))

; If T is Symbol, what is [List-of T]?

; map*: [Number -> Number] LON -> LON
; Apply the function to each item in the list.
(check-expect (map* add1 NUMS) (list 2 3 4 5 6))

(define (map* fn xs)
  (cond
    [(empty? xs) empty]
    [(cons? xs) (cons (fn (first xs))
                      (map* fn (rest xs)))]))

; map*: [String -> Number] LOS -> LON
(check-expect (map* string-length DOGS) (list 5 7 6))

; map*: [Number -> Number] LON -> LON
; map*: [String -> Number] LOS -> LON
; map*: [Number -> Number] [List-of Number] -> [List-of Number]
; map*: [String -> Number] [List-of String] -> [List-of String]
; map*: [A B] [A -> B] [List-of A] -> [List-of B]

(define BG (empty-scene 300 300))

; Number -> Posn
; Create a Posn with x = y = 50*n
(define (sq-posn n)
  (make-posn (* 50 n) (* 50 n)))

(define POINTS (map* sq-posn (list 1 2 3 4 5)))
(define DOT (circle 10 'solid 'blue))

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

; [Posn Image -> Image] Image [List-of Posn] -> Image
; Combine a list into a single element given an initial
; zero (base case) value and a combining operation.
(define (reduce op zero xs)
  (cond
    [(empty? xs) zero]
    [(cons? xs) (op (first xs)
                    (reduce op zero (rest xs)))]))

(check-expect (reduce scene+dot BG POINTS) (place-dots POINTS))

; reduce: [A B] [A B -> B] B [List-of A] -> B
; What were A and B above?

(define-struct pair [key val])
; A [Pair A B] is (make-pair A B)

; [A B] [List-of A] [List-of B] -> [List-of [Pair A B]]
; Build a lookup table.
(define (build-table keys vals)
  (cond
    [(empty? keys) empty]
    [(cons? keys) (cons (make-pair (first keys) (first vals))
                        (build-table (rest keys) (rest vals)))]))

(define TAB1 (build-table '(a b) '(1 2)))
(check-expect TAB1 (list (make-pair 'a 1) (make-pair 'b 2)))

; [A B] [List-of [Pair A B]] A [A A -> Boolean] -> B
; Look something up in a table.
(check-expect (lookup TAB1 'b symbol=?) 2)

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
; Split a number into digits, backwards.
(define (digits* x)
  (cond
    [(= x 0) empty]
    [else (cons (modulo x 10)
                (digits* (floor (/ x 10))))]))

; Number -> [List-of Digit]
; Split a number into digits.
(check-expect (digits 8314) '(8 3 1 4))

(define (digits x)
  (reverse (digits* x)))

; Number -> [List-of String]
; Convert a number to the list of names of its digits.
(check-expect (digit-names 831) '("eight" "three" "one"))

(define (digit-names n)
  (map* digit->name (digits n)))

; Digit -> String
; Convert a digit to its name.
(define (digit->name d)
  (lookup NAMES d =))