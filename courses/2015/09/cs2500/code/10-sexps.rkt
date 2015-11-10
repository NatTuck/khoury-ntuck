;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname in-class-sexps-130) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; An Atom is one of:
;  - Number
;  - Symbol
;  - String

; An SExp (s-expression) is one of:
;  - Atom
;  - [List-of SExp]

; Number SExp -> Boolean
; Is the number n in the s-expression se?
(check-expect (has-num? 5 '(1 blue 5)) true)
(check-expect (has-num? 6 '(1 blue 5)) false)
(check-expect (has-num? 5 '(1 (((5))) 3 (blue 7))) true)

(define (has-num? n se)
  (cond [(atom? se) (and (number? se)
                         (= n se))]
        [(list? se)
         (ormap (λ (o) (has-num? n o)) se)]))
         
; Anything -> Boolean
; Is this an atom?
(check-expect (atom? '(1)) false)
(check-expect (atom? "pie") true)
               
(define (atom? x)
  (or (number? x)
      (symbol? x)
      (string? x)))

; An SExp (s-expression) is one of:
;  - Atom
;  - [List-of SExp]

; SExp SExp -> Boolean
; Are two s-expressions equal?
(check-expect (se=? 5 5) true)
(check-expect (se=? 5 '(5)) false)
(check-expect (se=? '(1 2 (5 7) 3)
                    '(1 2 (5 7) 3))
              true)
(check-expect (se=? '(1 2 (5 7) 3)
                    '(1 2 (6 7) 3))
              false)

(define (se=? a b)
  (cond [(and (atom? a) (atom? b))
         (atom=? a b)]       
        [(and (list? a) (list? b))
         (and (se=? (first a) (first b))
              (se=? (rest a) (rest b)))]
        [else false]))

(define atom=? =)