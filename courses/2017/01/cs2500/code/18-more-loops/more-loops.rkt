;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname more-loops) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; Parameterized Data Definitions

; A Digit is a Number from 0 - 9.

; A [Pair A B] is (list A B)

(define NAMES
  '((0 "zero") (1 "one") (2 "two") (3 "three") (4 "four")
    (5 "five") (6 "six") (7 "seven") (8 "eight") (9 "nine")))

; Wait, what are the actual rules for quote?
;  - number, string -> itself
;  - name -> symbol
;  - parens -> list of quoted contents

; What's NAMES?
; [List-of [Pair Digit String]]


; Digit [List-of [Pair Digit String]] -> String
(check-expect (lookup1 1 NAMES) "one")
(check-error  (lookup1 11 NAMES) "No such key")

(define (lookup1 k tab)
  (cond [(empty? tab) (error "No such key")]
        [(cons? tab) (if (= k (first (first tab)))
                         (second (first tab))
                         (lookup1 k (rest tab)))]))

(define TEAMS
  '(("Boston" "Red Sox") ("New York" "Yankees") ("Baltimore" "Orioles")
    ("Tampa Bay" "Rays") ("Toronto" "Blue Jays")))

; What's TEAMS?
; [List-of [Pair String String]]

; (lookup1 "Boston" TEAMS)
; nope - different equality predicate

; A [List-of [Pair A B]] [A A -> Boolean] -> B
; Look up a value in a table by key.
(check-expect (lookup 1 NAMES =) "one")
(check-error  (lookup 11 NAMES =) "No such key")
(check-expect (lookup "Boston" TEAMS string=?) "Red Sox")

(define (lookup k tab eq-pred?)
  (cond [(empty? tab) (error "No such key")]
        [(cons? tab) (if (eq-pred? k (first (first tab)))
                         (second (first tab))
                         (lookup k (rest tab) eq-pred?))]))

; ==
; Loops
; ==

; Three main loops:
;  - map
;  - filter
;  - foldr

; You should be comfortable with these:
;  - What do they do?
;  - When do you use them?
;  - How do they work?

; [X -> Y] [List-of X] -> [List-of Y]
(define (map* op xs)
  (cond [(empty? xs) empty]
        [(cons? xs) (cons (op (first xs))
                          (map* op (rest xs)))]))
(check-expect (map* add1 '(1 2 3)) '(2 3 4))
; step through that example

; Map
;  - We've got a list.
;  - We want another list of the same length, based on the
;    individual items in the first list.

; Filter
;  - We've got a list.
;  - We want a shorter list, with elements from the from
;    the first list based on their value.


; A [List-of X] is one of:
;  - empty
;  - (cons X [List-of X])

#;
(define (lox-tmpl xs)
  (cond [(empty? xs) ...]
        [(cons? xs) ... (first xs)
                        (lox-tmpl (rest xs))]))

; [X Y -> Y] Y [List-of X] -> Y
(define (foldr* op base xs)
  (cond [(empty? xs) base]
        [(cons? xs) (op (first xs)
                        (foldr* op base (rest xs)))]))
(check-expect (foldr* + 0 '(1 2 3)) 6)

; Another way to think of foldr:
; (cons 1 (cons 2 (cons 3 empty)))
;  cons  -> op
;  empty -> base
; (+    1 (+    2 (+    3     0)))

; Step through example above.

; ==
; Here's some more loops:
; ==

; Design a function that turns a natural number
; into the list of numbers n..1

#;(define (nn-tmpl n)
    (cond [(zero? n) ...]
          [else ... n ...
                ... (nn-tmpl (sub1 n))]))

; NN -> [List-of Number]
; Generate a list counting down from n to 1.
(check-expect (count-down 5) '(5 4 3 2 1))

(define (count-down n)
    (cond [(zero? n) empty]
          [else (cons n (count-down (sub1 n)))]))

; build-list: Number [Number -> X] -> [List-of X]
; Generate a list of n things using function applied to (0..n-1).

(check-expect (build-list 5 add1) '(1 2 3 4 5))
(check-expect (build-list 5 identity) '(0 1 2 3 4))

; andmap: [X -> Boolean] [List-of X] -> Boolean
; Does every item in the list satisfy the predicate?

(check-expect (andmap even? (list 2 4 6)) true)
(check-expect (andmap even? (list 2 3 6)) false)

; ormap: [X -> Boolean] [List-of X] -> Boolean
; Does any item in the list satisfy the predicate?

(check-expect (ormap odd? (list 2 4 6)) false)
(check-expect (ormap odd? (list 2 3 6)) true)

; Finally, these exist:
;  - sort
;  - argmax
;  - argmin

; sort: [List-of X] [X X -> Boolean] -> [List-of X]
; Sorts a list given a comparison function.

(check-expect (sort '(2 3 1) >) '(3 2 1))
(check-expect (sort '(2 3 1) <) '(1 2 3))

; argmax: [X -> Number] [List-of X] -> X
; Find a value in the list that maximizes the function.

(check-expect (argmax abs '(1 2 3 -1 -2 -4)) -4)

; argmin: [X -> Number] [List-of X] -> X
; Find a value in the list that minimizes the function.

(check-expect (argmin abs '(1 2 3 -1 -2 -4)) 1)


(define-struct person [first last])
; A Person is a (make-person String String)

(define PEOPLE (list
                (make-person "James" "Howlett")
                (make-person "Ororo" "Munroe")
                (make-person "Katherine" "Pryde")
                (make-person "Robert" "Drake")))

; Person -> Number
; Get the length of a Person's name
(define (name-length p)
  (string-length (string-append (person-first p) (person-last p))))

; [List-of Person] -> Person
; Get the person with the longest name.
(check-expect (longest-name PEOPLE) (make-person "Katherine" "Pryde"))

(define (longest-name ps)
  (argmax name-length ps))

; Person Person -> Boolean
; Compare two people by last name.
(define (person<? p0 p1)
  (string<? (person-last p0) (person-last p1)))

; [List-of Person] -> [List-of Person]
; Sort a list of people by last name.
(define (sort-people ps)
  (sort ps person<?))


