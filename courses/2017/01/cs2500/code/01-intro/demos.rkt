;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname demos) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))

; This line is a comment.

5
; = 5

(+ 4 2)
; = 6

(sqr 5)
; = 25

(+ 2 (sqr 5))
; = 50

; Here's a function:
(define (radius r)
  (* pi (sqr r)))
; (radius 1) = pi

