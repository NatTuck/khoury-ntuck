;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname sexps-2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; Two complex inputs
;  Possibilities
;   - Call a helper for each.
;   - Pick one template, pass the other thing through.
;   - Simultaneious recursion
;   - Handle a x b cases

; A [List-of Number] is one of:
;  - empty
;  - (cons Number [List-of Number])

#;
(define (lon-lon-tmpl xs ys)
  (cond [(and (empty? xs) (empty? ys))
         ...]
        [(and (empty? xs) (cons? ys))
         ... (first ys) ... (lon-tmpl (rest ys))]
        [(and (cons? xs) (empty? ys))
         ... (first xs) ... (lon-tmpl (rest xs))]
        [(and (cons? xs) (cons? ys))
         ... (first xs)
         ... (first ys)
         ... (lon-lon-tmpl (rest xs) (rest ys))]))

; lon=?: [List-of Number] [List-of Number] -> Boolean
; Are two lists of numbers equal?
(check-expect (lon=? '(1 2 3) '(1 2 3)) true)
(check-expect (lon=? '(1 2 3) '(1 2 3 4)) false)
(check-expect (lon=? '(1 2 3) '(1 3 3)) false)

(define (lon=? xs ys)
  (cond [(and (empty? xs) (empty? ys))
         true]
        [(and (cons? xs) (cons? ys))
         (and (= (first xs) (first ys))
              (lon=? (rest xs) (rest ys)))]
        [else false]))

; concat: [List-of Number] [List-of Number] -> [List-of Number]
; Concatenate two lists.
(check-expect (concat '(1 2 3) '(4 5 6)) '(1 2 3 4 5 6))

(define (concat xs ys)
  ; Work up to this.
  (foldr cons ys xs))

; S-expr S-expr -> Boolean
; Are two S-exprs equal?
(check-expect (sexp=? 5 5) true)
(check-expect (sexp=? 5 'goat) false)
(check-expect (sexp=? '(some (5 goats)) '(some (5 goats))) true)
(check-expect (sexp=? '(some (5 goats)) '(some (5 cows))) false)

(define (sexp=? se0 se1)
  (cond
    [(and (atom? se0) (atom? se1)) (atom=? se0 se1)]
    [(and (list? se0) (list? se1)) (sl=? se0 se1)]
    [else false]))


    
; SL SL -> Boolean
; Are two SLs equal?
(check-expect (sl=? empty empty) true)
(check-expect (sl=? empty '(goat)) false)
(check-expect (sl=? '(goat) empty) false)
(check-expect (sl=? '(goat) '(goat)) true)
(check-expect (sl=? '(one two) '(one)) false)
(check-expect (sl=? '(goat) '(5)) false)

(define (sl=? xs ys)
  (cond
    [(and (empty? xs) (empty? ys)) true]
    [(empty? xs) false]
    [(empty? ys) false]
    [else (and (sexp=? (first xs) (first ys))
               (sl=? (rest xs) (rest ys)))]))


(define-struct cow [weight spots])
(define-struct pig [weight nickname])
(define-struct chicken [weight color])

; An Animal is one of:
;  - (make-cow Number Number)
;  - (make-pig Number String)
;  - (make-chicken Number Symbol)

; TODO: Define (bigger a b)
;       for two animals 
;  - First with double template.
;  - Then with helper and local.




