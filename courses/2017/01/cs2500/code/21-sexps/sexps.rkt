;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname sexps) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))

; An Atom is one of: 
; – Number
; – String
; – Symbol 

#;(define (atom-tmpl a)
    (cond
      [(number? a) ...]
      [(string? a) ...]
      [(symbol? a) ...]))

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

; An S-expr (S-expression) is one of: 
; – Atom
; – SL

#;(define (sexp-tmpl se)
    (cond
      [(atom? se) (atom-tmpl se)]
      [(list? se) (sl-tmpl xs)]))

; Any -> Boolean
; Is this an atom?
(check-expect (atom? 5) true)
(check-expect (atom? (make-posn 3 5)) false)

(define (atom? x)
  (or (number? x) (symbol? x) (string? x)))

; S-expr Symbol -> Number
; Count all occurances of the symbol in se
(check-expect (count 'world 'hello) 0)
(check-expect (count '(world hello) 'hello) 1)
(check-expect (count '((hello world) hello world) 'hello) 2)
(check-expect (count 5 'hello) 0)

(define (count se sym)
  (cond
    [(atom? se) (count-atom se sym)]
    [(list? se) (foldr (lambda (item sum)
                         (+ (count item sym) sum))
                       0 se)]))

; Atom -> Number
; If this atom is the symbol sym, then 1. Otherwise, 0.
(check-expect (count-atom 5 'hello) 0)
(check-expect (count-atom 'hello 'hello) 1)
(check-expect (count-atom 'goat 'hello) 0)

(define (count-atom a sym)
  (if (and (symbol? a)
           (symbol=? a sym))
      1
      0))


; S-expr Atom Atom -> S-expr
; Replace all occurances of old in se with new.
(check-expect (replace1 '(1 2 1 3) 1 4) '(4 2 4 3))
(check-expect (replace1 '(blue 5 blue) 'blue 5) '(5 5 5))

(define (replace1 se old new)
  (local (; Atom -> S-expr
          ; Replace the atom if it's equal to old.
          (define (replace-atom a)
            (if (atom=? a old) new a))
          ; SL -> S-expr
          ; Replace each item in the list if it's equal to old.
          (define (replace-list xs)
            (cond
              [(empty? xs) empty]
              [(cons? xs) (cons (replace1 (first xs) old new)
                                (replace-list (rest xs)))])))
    (cond
      [(atom? se) (replace-atom se)]
      [(list? se) (replace-list se)])))

; S-expr Atom Atom -> S-expr
; Replace all occurances of old in se with new.
(check-expect (replace2 '(1 2 3) 1 4) '(4 2 3))
(check-expect (replace2 '(blue 5) 'blue 5) '(5 5))

(define (replace2 se old new)
  (cond
    [(atom? se) (if (atom=? se old) new se)]
    [(list? se) (map (lambda (se1) (replace2 se1 old new)) se)]))


; S-expr -> Number
; Evaluate the S-expr as an arithmetic expression.
(check-expect (calc 5) 5)
(check-expect (calc '(* 3 2)) 6)
(check-expect (calc '(+ (/ 6 2) (- 9 4))) 8)

(define (calc se)
  (cond
    [(atom? se) se]
    [(list? se) (calc-list se)]))

; SL -> Number
; Evaluate the SL as an arithmetic operation.
(check-expect (calc-list '(+ 1 2)) 3)

(define (calc-list se)
  (local ((define op (first se))
          (define args (map calc (rest se))))
    (cond
      [(symbol=? '+ op) (foldr + 0 args)]
      [(symbol=? '- op) (foldr - 0 args)]
      [(symbol=? '* op) (foldr * 1 args)]
      [(symbol=? '/ op) (foldr / 1 args)])))


; S-expr -> Number
; Evaluate the S-expr as an arithmetic operation,
; except use add, sub, mul, div in place of symbols.
(check-expect (calc-w '(mul 2 3)) 6)
(check-expect (calc-w '(add (div 6 2) (sub 9 4))) 8)

(define (calc-w se)
  (cond
    [(atom? se) se]
    [(list? se) 
     (local ((define op (first se))
             (define args (map calc-w (rest se))))
       (cond
         [(symbol=? 'add op) (foldr + 0 args)]
         [(symbol=? 'sub op) (foldr - 0 args)]
         [(symbol=? 'mul op) (foldr * 1 args)]
         [(symbol=? 'div op) (foldr / 1 args)]))]))

; S-expr [List-of [List-of Atom]] -> S-expr
; Perform multiple replacements on an S-expr
(check-expect (replace* '(a b) '((a 1) (b 2))) '(1 2))

(define (replace* se changes)
  (foldr (lambda (ch se1)
           (replace2 se1 (first ch) (second ch)))
         se changes))
               
; S-expr -> Number
; Evaluate the S-expr as an arithmetic operation,
; except use add, sub, mul, div in place of symbols.
(check-expect (calc-w* '(mul 2 3)) 6)
(check-expect (calc-w* '(add (div 6 2) (sub 9 4))) 8)

(define (calc-w* se)
  (calc (replace* se '((add +) (sub -) (mul *) (div /)))))



; More examples:
;  flatten-sexp
;  reverse-sexp
