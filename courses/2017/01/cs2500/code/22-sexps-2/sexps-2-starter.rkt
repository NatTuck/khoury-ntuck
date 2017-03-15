
; An Atom is one of: 
; – Number
; – String
; – Symbol 

#;(define (atom-tmpl a)
    (cond
      [(number? a) ...]
      [(string? a) ...]
      [(symbol? a) ...]))

; Any -> Boolean
; Is this an atom?
(check-expect (atom? 5) true)
(check-expect (atom? (make-posn 3 5)) false)

(define (atom? x)
  (or (number? x) (symbol? x) (string? x)))

; Atom Atom -> Boolean
; Are two atoms equal?
(check-expect (atom=? 5 5) true)
(check-expect (atom=? 5 6) false)
(check-expect (atom=? "goat" "goat") true)
(check-expect (atom=? "goat" "boat") false)
(check-expect (atom=? 'bear 'bear) true)
(check-expect (atom=? 'bear 'pear) false)
(check-expect (atom=? 'bear "bear") false)
(check-expect (atom=? 5 "5") false)

(define (atom=? a b)
  (cond
    [(and (number? a) (number? b)) (= a b)]
    [(and (string? a) (string? b)) (string=? a b)]
    [(and (symbol? a) (symbol? b)) (symbol=? a b)]
    [else false]))

; An SL (S-list) is [List-of S-expr]

; (List template)

; An S-expr (S-expression) is one of: 
; – Atom
; – SL

#;(define (sexp-tmpl se)
    (cond
      [(atom? se) (atom-tmpl se)]
      [(list? se) (sl-tmpl xs)]))


