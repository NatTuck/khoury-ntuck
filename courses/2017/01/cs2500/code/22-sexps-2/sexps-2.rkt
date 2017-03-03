
; Two complex inputs
;  Possibilities
;   - Pick one template
;   - Simultaneious recursion
;   - Handle a x b cases

; append

; lon=?




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
