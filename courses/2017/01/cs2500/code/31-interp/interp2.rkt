;;; An evaluator (interpreter) for Husky, a higher-order functional language,
;;; written in the Intermediate Student Language with Lambda.
;;;
;;; (But really it's a meta-circular Scheme interpreter.)
;;; This file is mostly comments; the core of the interpreter is only
;;; 26 lines of actual code.
;;;     -Olin

;;; Syntax -- the grammar of Husky, as Racket sexpressions.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; A HExp (Husky Expression) is one of:
;;; - Number					; <number>
;;; - Var					; <var>
;;; - (list 'const SExp)			; (CONST <constant-sexpression>)
;;; - (list 'fun (list Var ...) HExp)		; (FUN (<var> ...) <body>)
;;; - (list 'if HExp HExp HExp) 		; (IF <test> <then> <else>)
;;; - (list HExp HExp ...)			; (<fun> <arg> <arg> ...)
;;;
;;; A Var is a Symbol.

;;; Two example Husky programs:
;;; ((fun (abs) (list (abs (- 5 7)) 			; Should produce
;;;                   (abs (- 7 5))))			; '(2 2).
;;;  (fun (x) (if (< x 0) (- x) x)))
;;;
;;; ((fun (x) (if (< x 0) (const (x is negative))	; Should produce
;;; 	      (if (= x 0) (const (x is zero))		; '(x is negative).
;;; 		  (const (x is positive)))))
;;;  (* 3 (- 7 10)))
;;;
;;; For these two programs to work, you'd have to run them with a top-level
;;; environment that provided bindings for the five variables
;;;     list - < = *

;;; Semantics -- semantic values, environments and the interpreter
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; A Value is one of:
;;; - SExp		(a number, boolean, cons, etc.)
;;; - Procedure		
;;;
;;; A Procedure is one of:
;;; - (make-closure [List-of Var] HExp Env)	(a user procedure)
;;; - (make-primop [[List-of Value] -> Value])	(a built-in procedure)
;;;
;;; Closures are what we get when we evaluate (FUN (<var> ...) <body>) terms
;;; in some given environment -- we package up the parameters (<var> ...),
;;; the function's <body> expression, and the current environment into a
;;; closure.
;;;
;;; Primops represent "built-in" primitive operations that the interpreter does
;;; directly. Every primop comes with a handler that we use to do the primop.

(define-struct closure (params body env))
(define-struct primop  (handler))

;;; Env = [Listof (make-binding Var Value)]
(define-struct binding (var val))
;;; An environment represents a set of variable/value bindings.
 
;;; lookup: Env Var -> Val
;;; Look up the variable's value in the environment.
;;; Environments are scanned left to right, so consing a binding for variable
;;; V onto the front of a list shadows any other bindings of V further down
;;; in the environment.
(define (lookup env var)
  (cond [(empty? env) (error 'lookup "Variable is not bound: " var)]
        [else (local [(define b (first env))]
	        (cond [(symbol=? (binding-var b) var)
		       (binding-val b)]
		      [else (lookup (rest env) var)]))]))

(define test-env (list (make-binding 'x 5)
		       (make-binding 'y 2)
		       (make-binding 'x 7)))
(check-expect (lookup test-env 'x) 5)
(check-expect (lookup test-env 'y) 2)
(check-error  (lookup test-env 'z) "lookup: Variable is not bound: 'z")


;;; Eval & Apply -- the yin/yang pair that make the interpreter.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Symbol SExp -> Boolean
;;; Is the s-expression the given keyword?
(define (keyword=? kwd sexp)			; Cheesy little syntax
  (and (symbol? sexp)				; utility function.
       (symbol=? kwd sexp)))

;; ev : HExp Env -> Value
;; Evaluate the Husky expression in the given environment.
(define (ev exp env)
  (cond [(number? exp) exp]	; Numeric constants self-evaluate.

	;; Look up variable references in the current environment.
	[(symbol? exp) (lookup env exp)]

	;; Expression is a list -- CONST exp, FUN exp, IF exp or function call.
	[else (local [(define e1 (first exp))]
	        (cond
		 ;; (CONST sexp) -- a constant
		 [(keyword=? 'const e1) (second exp)]

		 ;; (FUN (var ...) body)
		 [(keyword=? 'fun e1)	
		  ;; Make a code+env closure:
		  (make-closure (second exp) ; the params
				(third exp)  ; the body
				env)]	     ; the env

		 ;; (IF test then else)
		 [(keyword=? 'if e1)
		  (ev ((cond [(ev (second exp) env) third]
			     [else                  fourth]) exp)
		      env)]

		 ;; Function application: (function arg ...) 
		 [else (app (ev (first exp) env)    ; Eval the fun,
			    (map (λ (a) (ev a env)) ; and all the args,
				 (rest exp)))]))])) ; then apply fun to args.

;;; Value [Listof Value] -> Value
;;; Apply the Husky function to the Husky arguments.
(define (app f args)
  (cond [(closure? f)			; Proc is a closure:
	 (ev (closure-body f)		; Eval the function's body
	     (append (map make-binding	     ; in the closure env extended
			  (closure-params f) ; with the parameter/argument
			  args)		     ; bindings.
		     (closure-env f)))]

	;; Just hand off to primop's handler.
	[(primop? f) ((primop-handler f) args)]	

	[else (error 'app "Attempting to apply a non-function: " f)]))

             
;; HExp -> Value
;; Run the Husky expression in the top-level environment
(define (run e) (ev e top-env))

(check-expect (run '1)         1)
(check-expect (run '(plus2 5)) 7)
(check-expect (run '(plus2 5)) 7)
(check-expect (run '((fun (x) (minus1 (plus2 x))) 5)) 6)
(check-expect (run '((fun (f) (f (f 0))) plus2)) 4)

;;; The hard way to write 120 -- really exercise the interpreter.
;;; Apply the Y combinator to a factorial generator; apply the result to 5.
;;; Yahoo.
(check-expect (run '(((fun (f) ((fun (g) (f (fun (x) ((g g) x))))
				(fun (g) (f (fun (x) ((g g) x))))))
		      (fun (fact)
		        (fun (n) (if (= n 0) 1
				     (* n (fact (- n 1)))))))
		     5))
	      120)

;;; Primops & the top-level environment
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Convert a Racket/ISL/ASL function into a Husky-interpreter primop.
(define (racket->husky-primop f)
  (make-primop (λ (args) (apply f args))))


(define top-env
  (list (make-binding 'plus1  (racket->husky-primop add1))
	(make-binding 'minus1 (racket->husky-primop sub1))
	(make-binding 'kar    (racket->husky-primop car))
	(make-binding 'kdr    (racket->husky-primop cdr))
	(make-binding 'tru    true)
	(make-binding 'fals   false)
	(make-binding 'not    (racket->husky-primop not))
	(make-binding 'plus2  (racket->husky-primop (λ (n) (+ n 2))))
	(make-binding '*      (racket->husky-primop *))
	(make-binding '=      (racket->husky-primop =))
	(make-binding '-      (racket->husky-primop -))))
	

