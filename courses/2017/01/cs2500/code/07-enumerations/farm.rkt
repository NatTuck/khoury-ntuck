;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname farm) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; New kind of data definition: enumeration

; A Species is one of:
;  - "cow"
;  - "pig"
;  - "sheep"
; interpretation: what you'd expect

(define S1 "cow")

#;
(define (species-tmpl s)
  (cond [(string=? "cow" s) ...]
        [(string=? "pig" s) ...]
        [(string=? "sheep" s) ...]))


; Species -> String
; What sound does an animal of this species make?

(check-expect (s-sound "cow") "moo")
(check-expect (s-sound "pig") "oink")
(check-expect (s-sound "sheep") "baaa")

(define (s-sound s)
  (cond [(string=? "cow" s) "moo"]
        [(string=? "pig" s) "oink"]
        [(string=? "sheep" s) "baaa"]))



; An Animal is (make-animal Species String Number)
(define-struct animal [species name weight])
; Weight is in kilograms.

(define A1 (make-animal "cow" "Bessy" 200))

#;
(define (animal-tmpl a)
  (... (species-tmpl (animal-species a)) ...
       (animal-name a) ...
       (animal-weight a) ...))


; Animal -> String
; What sound does the animal make?

(check-expect (a-sound (make-animal "cow" "Bessy" 200)) "moo")

(define (a-sound a)
  (s-sound (animal-species a)))



