;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname interp-part-2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; Husky Language

; A Var is a Symbol

; A HExp (Husky Expression) is one of:
;  - Number                          ; e.g. 123
;  - Var                             ; e.g. x or +
;  - One of the list cases

; List Cases
;  - (list HExp HExp ...)            ; e.g. (+ 1 2)
;  - (list 'if HExp HExp Hexp)       ; e.g. (if (< x 4) 5 7)
;  - (list 'const SExp)              ; (const (foo bar)) => '(foo bar)
;  - (list 'fun (list Var ...) HExp) ; e.g. (fun (x) (+ x 2))

#;
(define (hexp-tmpl exp)
  (cond [(number? exp) ...]
        [(symbol? exp) ...]
        [(cons? exp) (hexp-list-tmpl expr)]))

#;
(define (hexp-list-tmpl exp)
  (local ((define op (first exp))
          (define args (rest exp)))
    (cond [(symbol=? op 'if) ... args ...]
          [(symbol=? op 'const) ... args ...]
          [(symbol=? op 'fun) ...]
          [else ... op ... args ... ])))

; A Value is
;  - An SExpr
;  - Procedure

(define-struct builtin [handler])
(define-struct func [params body])
; A Procedure is one of:
;  - (make-func [List-of Var] HExp)
;  - (make-builtin [[List-of Value] -> Value])

; ((lambda (x) x) (< 3 5))

#;((fun (abs) (list (abs (- 5 7))
                    (abs (- 7 5))))
   (fun (x) (if (< x 0) (- x) x)))
; need pre-defined functions: -, list, < 
; (list 2 2)

(define code1 '((λ (abs1) (list (abs1 (- 5 7))
                                (abs1 (- 7 5))))
                (λ (x) (if (< x 0) (- x) x))))


(define-struct bind [name value])
; A Binding is (make-bind Symbol Value)
; An Environment is a [List-of Binding]

; ISL Function -> (make-builtin [[List-of Value] -> Value])
(define (isl->builtin f)
  (make-builtin (λ (xs) (apply f xs)))) 

(define ENV0
  (list (make-bind '< (isl->builtin <))
        (make-bind '+ (isl->builtin +))
        (make-bind 'tru (isl->builtin true))
        (make-bind 'fals (isl->builtin false))
        (make-bind 'cons (isl->builtin cons))
        (make-bind 'empty? (isl->builtin empty?))
        (make-bind 'add2 (isl->builtin (λ (x) (+ x 2))))
        (make-bind 'kar (isl->builtin first))
        (make-bind 'kdr (isl->builtin rest))
        (make-bind '=  (isl->builtin =))))

(define ENV1
  (list (make-bind 'FOUR 4)
        (make-bind 'true #t)))

; Environment Var -> Value
; Look up a value in the environment.

(check-expect (lookup ENV1 'FOUR) 4)

(define (lookup env name)
  (cond [(empty? env) (error "Unknown name" name)]
        [(cons? env) (if (symbol=? (bind-name (first env)) name)
                         (bind-value (first env))
                         (lookup (rest env) name))]))
              
; HExpr Environment -> Value
; Evaluate an expression in a given environment.

(check-expect (eval1 3 ENV1) 3)
(check-expect (eval1 '(if (const #t) 1 2) '()) 1)
(check-expect (eval1 '(if (const #f) 1 2) '()) 2)
(check-expect (eval1 '(if (< 3 5) 10 20) ENV0) 10)
(check-expect (eval1 '((fun (x y) (+ x y)) 6 4) ENV0) 10)




;(check-expect (eval1 '(+ FOUR 1) ENV1) 5)
; ((fun (x) (+ x 2)) 1) -> 3

(define (eval1 expr env)
  (cond [(number? expr) expr]
        [(symbol? expr) (lookup env expr)]
        [(cons? expr) (eval1-list expr env)]))

; HExprList Environment -> Value
; Evaluate an expression in a given environment.

(define (eval1-list exp env)
  (local ((define op (first exp))
          (define args (rest exp)))
    (cond [(and (symbol? op)
                (symbol=? op 'if))
           (if (eval1 (first args) env)    ; true
               (eval1 (second args) env)
               (eval1 (third args) env))]
          [(and (symbol? op)
                (symbol=? op 'const)) (first args)]
          ;  (list 'fun (list Var ...) HExp)
          [(and (symbol? op)
                (symbol=? op 'fun))
           (make-func (first args) (second args))]
          [else (apply1 (eval1 op env)
                        (map (λ (x) (eval1 x env)) args)
                        env)])))

; Procedure [List-of Value] Environment -> Value 
(define (apply1 f args env)
  (cond [(builtin? f)
         ((builtin-handler f) args)]
        [(func? f)
         (eval1 (func-body f)
                (append (bind-args (func-params f) args)
                        env))]))

; [List-of Var] [List-of Value] -> Environment

(define (bind-args names vals)
  (map (λ (x y) (make-bind x y)) names vals))

; TODO: Create a default environment with some
;  standard symbols: true, false

; plug in 4 for x
; evaluate the result


; Stuff we're skipping...
;  - Other atomic data: String, Symbol, Image, ...
;  - (define ...)

(eval1 '(((fun (x) (fun (y) (+ x y))) 4) 100) ENV0)
(((λ (x) (λ (y) (+ x y))) 4) 100)

