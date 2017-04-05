;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname interp-day-2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;
; Language we're building: Husky Language
; We're building it in:    ISL+

; Husky language code = SExprs

; A Var is a Symbol

; A HExpr (Husky Expression) is one of:
;  - Number                                    ; (e.g 5, value = itself)
;  - Var                                       ; (e.g. + or x, value of variable)
;  - HListExpr

; A HListExpr is one of:
;  - (list 'const SExp)                        ; this is like "quote"
;  - (list 'if HExp HExp HExp)                 ; if
;  - (list HExp HExp ...)                      ; call a function
;  - (list 'fun (list Var ...) HExp)           ; like "lambda"

#;
(define (hexpr-tmpl hexp)
  (cond [(number? hexp) ...]
        [(symbol? hexp) ...]
        [(cons? hexp) (hlistexpr-tmpl hexp)]))

; A Value is one of:
;  - SExp
;  - Procedure

(define-struct builtin [handler])
(define-struct func [params body])   
; A Procedure is one of:
;  - (make-func [List-of Var] Hexp)
;  - (make-builtin [[List-of Value] -> Value])

(define (isl->builtin f)
  (make-builtin (λ (xs) (apply f xs))))

(define-struct bind [name value])
; A Binding is (make-bind Var Value)
; An Environment is a [List-of Binding]

(define ENV0
  (list (make-bind '< (isl->builtin <))
        (make-bind 'minus1 (isl->builtin sub1))
        (make-bind '+ (isl->builtin +))
        (make-bind 'tru (isl->builtin true))
        (make-bind 'fals (isl->builtin false))
        (make-bind 'cons (isl->builtin cons))
        (make-bind 'kar  (isl->builtin first))
        (make-bind 'cdr  (isl->builtin rest))
        (make-bind 'cons? (isl->builtin cons?))))

(define ENV1
  (list (make-bind 'x 'boat)))

; HExpr Environment -> Value
; Evaluate a husky expression.

(check-expect (eval1 4 '()) 4)
(check-expect (eval1 7 '()) 7)
(check-expect (eval1 'x ENV1) 'boat)
(check-expect (eval1 '(const foo) '()) 'foo)
(check-expect (eval1 '(if (const #t) 3 5) '()) 3)
(check-expect (eval1 '(if (< 3 5) 3 5) ENV0) 3)
(check-expect (eval1 '(+ a (+ 5 a)) (cons (make-bind 'a 10) ENV0)) 25)
(check-expect (eval1 '(if (< 5 3) 3 5) ENV0) 5)
(check-expect (eval1 '((fun (x) (+ x 10)) 5) ENV0) 15)
(check-expect (eval1 '(((fun (x) (fun (y) (+ x y))) 10) 20)
                     (cons (make-bind 'x 0) ENV0))
              30)


(define (eval1 hexp env)
  (cond [(number? hexp) hexp]
        [(symbol? hexp) (lookup hexp env)]
        [(cons? hexp) (eval1-list hexp env)]))

(define (eval1-list hexp env)
  (local ((define op   (first hexp))
          (define args (rest  hexp)))
    (cond [(keyword=? 'const op) (first args)]
          [(keyword=? 'if op)
           (if (eval1 (first args) env)
               (eval1 (second args) env)
               (eval1 (third args) env))]
          [(keyword=? 'fun op)
           (make-func (first args)
                      (second args))]
          [else (apply1 (eval1 op env)
                        (map (λ (x) (eval1 x env)) args)
                        env)])))

(define (keyword=? kw expr)
  (and (symbol? expr)
       (symbol=? kw expr)))


; Procedure [List-of Value] Environment -> Value 

;(make-builtin [[List-of Value] -> Value]) 

(define (apply1 f args env)
  (cond [(builtin? f) ((builtin-handler f) args)]
        [(func? f)
         ; example: ((fun (x) (+ x 10)) 5) ; args = '(5)
         ; Bind names to args.
         ; Eval body in new environment.
         (eval1 (func-body f)
                (append (map (λ (x y) (make-bind x y)) (func-params f) args)
                        env))]))

; An HListExpr is one of:
;  - (list 'const SExp)                        ; this is like "quote"
;  - (list 'if HExp HExp HExp)                 ; if
;  - (list 'fun (list Var ...) HExp)           ; like "lambda"
;  - (list HExp HExp ...)                      ; call a function
            

; Symbol Environemnt -> Value
; Give the value bound to the name.

(define (lookup name env)
  (cond [(empty? env) (error "No such var" name)]
        [(cons? env) (if (symbol=? (bind-name (first env)) name)
                         (bind-value (first env))
                         (lookup name (rest env)))]))

; (const (foo bar)) => '(foo bar)
; (+ 1 2) => 3
; (- 7 4) => 3
; (- 7 x) => 4 when x = 3
; (< 3 4) => #t
; (< x 4) => #t when x = 3
; (max 3 4) => 4
; (if (< 3 4) 5 6) => 5
#;
((fun (abs1) (list (abs1 (- 5 7))
                   (abs1 (- 7 5))))
 (fun (x) (if (< x 0) (- x) x)))
;  => ??

(eval1 '(((fun (x) (fun (y) (+ x y))) 10) 20) ENV0)


                  