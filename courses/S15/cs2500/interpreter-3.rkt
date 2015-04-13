;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname interpreter-3) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
; An Atom is one of:
;  - Symbol
;  - Number
;  - Boolean

; An S-expr is one of:
;  - Atom
;  - [List-of S-expr]

; A Value is one of:
;  - Number
;  - Boolean
;  - Function
;  - List

(define-struct bind [name value])
; A Binding is (make-bind Symbol Value)

; An Environment is a [List-of Binding]

; Symbol Value Environment -> Environment
; Add a binding to an environment.
(check-expect (put-env 'a 5 '()) (list (make-bind 'a 5)))

(define (put-env name value env)
  (cons (make-bind name value) env))

; Symbol Environment -> [Maybe Value]
; Look up a value by name in an environment.
(check-error (get-env 'x (list (make-bind 'y 3))) "No such name: 'x")
(check-expect (get-env 'x (put-env 'x 5 '())) 5)
(check-expect (get-env 'empty '()) (make-none))

(define (get-env name env)
  (cond
    [(symbol=? name 'empty) (make-none)]
    [(empty? env) (error "No such name: " name)]
    [(symbol=? name (bind-name (first env)))
     (bind-value (first env))]
    [else
     (get-env name (rest env))]))

(define-struct none [])

(define-struct cell [first rest])
; A List is a Cell or (make-none)
; A Cell is (make-cell Value List)


(define-struct func [params body env])
; A Function is (make-func [List-of Symbol] [S-expr] [List-of Value])

; Any -> Boolean
; Is this an atom?
(define (value? x)
  (or (func? x) (number? x) (cell? x) (none? x) (boolean? x)))

; S-expr Environment -> Value
; Evaluate an expression, with simple support for
; a lambda.
(check-expect (eval1 '(lambda (x) (+ x 2)) '()) (make-func '(x) '(+ x 2) '()))

(define (eval1 expr env)
  (cond
    [(symbol? expr) (get-env expr env)]
    [(value? expr) expr]
    [(list? expr) (eval1-list (first expr) (rest expr) env)]))
  
; Symbol [List-of S-expr] Environment -> Value
; Evaluate an application (fun call or special form).
(define (eval1-list op args env)
  (local (; S-Expr -> Value
          ; Evaluate an expression in this environment.
          (define (eval1-env expr)
            (eval1 expr env)))
    (cond
      [(special? op)
       (eval1-special op args env)]
      [(builtin? op)
       (apply-builtin op (map eval1-env args) env)]
      [else
       (apply1 (eval1-env op) (map eval1-env args) env)])))

; Symbol -> Boolean
; Is this a special form?
(check-expect (special? 'if) true)
(check-expect (special? '+) false)
(check-expect (special? 'foo) false)

(define (special? name)
  (member? name '(if lambda do)))

; Symbol -> Boolean
; Is this a built-in function?
(check-expect (builtin? 'if) false)
(check-expect (builtin? '+) true)
(check-expect (builtin? 'foo) false)

(define (builtin? name)
  (member name '(+ < cons empty? first rest)))

; Symbol [List-of S-expr] Environment -> Value
; Evaluate a special form.
(define (eval1-special name args env)
  (cond
    [(symbol=? name 'if)
     (if (eval1 (first args) env)
         (eval1 (second args) env)
         (eval1 (third args) env))]
    [(symbol=? name 'lambda)
     (make-func (first args) (second args) env)]
    [(symbol=? name 'do)
     (eval1-do args env)]
    [else (error "No such special form: " name)]))

; Symbol [List-of S-expr] Environment -> Value
; Evaluate a builtin function.
(define (apply-builtin name args env)
  (cond
    [(symbol=? name '+) (apply + args)]
    [(symbol=? name '<) (apply < args)]
    [(symbol=? name 'cons)
     (make-cell (first args) (second args))]
    [(symbol=? name 'empty?)
     (none? (first args))]
    [(symbol=? name 'first)
     (cell-first (first args))]
    [(symbol=? name 'rest)
     (cell-rest (first args))]
    [else (error "No such builtin: " name)]))

; Symbol [List-of Value] Environment -> Value
; Evaluate a user-defined function.
(check-expect (apply1 (make-func '(x) '(+ x 1) '()) '(5) '()) 6)

(define (apply1 fn args env)
  (local ((define our-env (add-args (func-params fn) args (func-env fn))))
    (eval1 (func-body fn) our-env)))

; [List-of Symbol] [List-of Value] Environment -> Environment
; Add a bunch of bindings to an environment.
(define (add-args ps vs env)
  (cond
    [(and (empty? ps) (empty? vs)) env]
    [(or  (empty? ps) (empty? vs)) (error "Not enough params / values")]
    [else (add-args (rest ps) 
                    (rest vs) 
                    (cons (make-bind (first ps) (first vs)) env))]))
    

; [List-of S-expr] Environment -> Value
; Evaluate a "do" special form.
;  Rules:
;   - If an item is a "define", update the environment.
;   - Return the value of the first expression.
(check-expect (eval1-do '((define x 5)
                          (+ x 1)) 
                        '()) 
              6)

(define (eval1-do xs env)
  (cond
    [(define? (first xs))
     (eval1-do (rest xs) (add-def (first xs) env))]
    [else
     (eval1 (first xs) env)]))

; [List-of S-expr] -> Boolean
; Is this S-expr a "define"?
(define (define? xs)
  (symbol=? (first xs) 'define))

; [List-of S-expr] Environment -> Value
; Add a "define" binding to the environment.
(define (add-def parts env)
  (cons (make-bind (second parts)
                   (eval1 (third parts) env))
        env))

; [List-of S-expr] -> Value
; Evaluate a program in an empty environment.
(check-expect (run1 '(do 
                       (define x 5)
                       (define add1 (lambda (x) (+ x 1)))
                       (add1 x)))
              6)

#;(check-expect (run1 '(do
                       (define L (cons 1 (cons 2 (cons 3 empty))))
                       (define sum 
                         (lambda (xs)
                           (if (empty? xs)
                               0
                               (+ (first xs) (sum (rest xs))))))
                       (sum L)))
              6)

(check-expect (run1 '(do
                       (define x 7)
                       (define bar
                         (lambda (y)
                           (+ x y)))
                       (define foo
                         (lambda (x)
                           (bar 3)))
                       (foo 2)))
              10)

                    
(define (run1 pgm)
  (eval1 pgm '()))


