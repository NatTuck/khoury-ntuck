;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname union-farm) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))


; A Cow is (make-cow String Number Number)
(define-struct cow [name weight no-of-spots])
; interp: given name, weight in lbs

(define COW1 (make-cow "Bessy" 3000 42))

(define (cow-tmpl c)
  (... (cow-name c) ...
       (cow-weight c)
       (cow-no-of-spots c) ...))

; A Pig is (make-pig String Number String)
(define-struct pig [name weight breed])
; interp: given name, weight in lbs

(define PIG1 (make-pig "Porky" 2000 "Chocktaw"))

(define (pig-tmpl p)
  (... (pig-name p) ...
       (pig-weight p) ...
       (pig-breed p) ...))



; An Animal is one of:
;  - Cow
;  - Pig

(define AN1 PIG1)

(define (animal-tmpl a)
  (cond [(cow? a) ... (cow-tmpl a) ... ]
        [(pig? a) ... (pig-tmpl a) ... ]))

; A function that gives the weight of an animal.

; Animal -> Number
; Get the animal's weight in lbs.

(check-expect (weight (make-cow "Bessy" 3000 42)) 3000)
(check-expect (weight (make-pig "Porky" 2000 "Chocktaw")) 2000)

(define (weight a)
  (cond [(cow? a) (cow-weight a)]
        [(pig? a) (pig-weight a)]))


; Alternate data def.

; An Animal is one of:
;  - (make-cow String Number Number)
;  - (make-pig String Number String)
;(define-struct cow [name weight no-of-spots])
;(define-struct pig [name weight breed])

(define (animal-tmpl a)
  (cond [(cow? a)
         ... (cow-name a) ...
         ... (cow-weight a) ...
         ... (cow-no-of-spots a) ... ]
        [(pig? a)
         ... (pig-name a) ...
         ... (pig-weight a) ...
         ... (pig-breed a) ...]))

; Do we ever have a cow that isn't used as an animal?
; Do we need Cow -> X Functions