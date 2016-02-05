;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname list-lecture-in-class) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; Exam 1: 02/22
; Two weeks from Monday.

; Today: Lists
; The next two weeks: Lists
; Then: An Exam
;  - Any guesses as to what will be on the exam?

; A LoS (list of strings) is one of:
;  - empty
;  - (cons String LoS)
#;
(define (los-tmpl los)
  (cond [(empty? los) ...]
        [(cons? los) ... (first los) ...
                     ... (los-tmpl (rest los)) ...]))


; Let's design a function that counts the
; strings in an LoS.

; LoS -> Number
; Count the strings in the list.

(check-expect (num-strings (cons "one"
                                 (cons "two"
                                       (cons "three" empty))))
              3)
(check-expect (num-strings empty)
              0)

(define (num-strings los)
  (cond [(empty? los) 0]
        [(cons? los) (+ 1 (num-strings (rest los)))]))


; Design a function that tells us if
; a given string is in a list of strings.


; LoS String -> Boolean
; Check if a given string is in the list.

(check-expect (in? empty "foo") false)
(check-expect (in? (cons "foo"
                         (cons "bar"
                               (cons "baz" empty)))
                   "bar")
              true)

(define (in? los s)
  (cond [(empty? los) false]
        [(cons? los) (or (string=? (first los) s)
                         (in? (rest los) s))]))

(define L1 (cons "foo" (cons "bar" (cons "baz" empty))))
(define L2 (cons "alice" (cons "bob" (cons "carol" L1))))
                 
(define M1 (cons "alice" (cons "bill" (cons "carol" L1))))




; LoS String String -> LoS
; Replace every instance of a in list with b.

(check-expect (replace L2 "bob" "bill") M1)
(check-expect (replace (cons "a" (cons "a" empty))
                       "a" "b")
              (cons "b" (cons "b" empty)))
(check-expect (replace empty "a" "b") empty)

(define (replace xs a b)
  (cond [(empty? xs) empty]
        [(cons? xs) (cons (if (string=? (first xs) a)
                              b
                              (first xs))
                          (replace (rest xs) a b))]))






              








; A "cons" is a kind of structure.
;  It has two fields: first and rest
;(define-struct cons [first rest])
; make-cons   -> cons
; cons-first  -> first
; cons-rest   -> rest
; cons?       -> cons?



