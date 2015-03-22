;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname trees) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
; lec20.ss

; An Atom is one of:
;  - Symbol
;  - String
;  - Number
(define (atom? x)
  (or (number? x) (string? x) (symbol? x)))

(define (atom=? x y)
  (cond [(and (symbol? x) (symbol? y)) (symbol=? x y)]
        [(and (string? x) (string? y)) (string=? x y)]
        [(and (number? x) (number? y)) (= x y)]
        [else false]))


(define-struct node [left right])
; A BT is one of
;  - Atom
;  - (make-node BT BT)

; How many people think this is a BT?
; - 10
; - 'purple-cow
; - (make-node 'a (make-node 10 empty))
; - (make-node (make-node 10 20) (make-node 10 20))

; PROBLEM:
;   Design a function that checks whether 5 occurs
;   in a given BT.

; BT -> Boolean
; Does this BT have a 5 in it?
(check-expect (has-5? 5) true)
(check-expect (has-5? "5") false)
(check-expect (has-5? (make-node 
                       (make-node 5 3) 
                       (make-node 7 5)))
              true)

