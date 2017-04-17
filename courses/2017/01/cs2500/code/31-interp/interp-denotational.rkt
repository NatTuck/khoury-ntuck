;;; A "denotational" version of the interpreter.

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

;;; Semantics -- semantic values, environments and the interpreter
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; A Value is one of:
;;; - SExp		(a number, boolean, cons, etc.)
;;; - Procedure		
;;;
;;; Procedure = [Listof Value] -> Value
;;; Denotation = Env -> Value
;;;
;;; Env = [Listof (make-binding Var Value)]

(define-struct binding (var val))

;;; An environment represents a set of variable/value bindings.
 
;;; lookup: Env Var -> Value
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

;; den : HExp -> Denotation
;; Map the expression to its denotation.
(define (den exp)
  (cond [(number? exp) (lambda (env) exp)]	; Numeric constants self-evaluate.

	;; Look up variable references in the current environment.
	[(symbol? exp) (lambda (env) (lookup env exp))]

	;; Expression is a list -- CONST exp, FUN exp, IF exp or function call.
	[else (local [(define e1 (first exp))]
	        (cond
		 ;; (CONST sexp) -- a constant
		 [(keyword=? 'const e1) (lambda (env) (second exp))]

		 ;; (FUN (var ...) body)
		 [(keyword=? 'fun e1)	
		  (local [(define body-den (den (third exp)))
		          (define params (second exp))]
		    ;; The denotation:
		    (lambda (env)
		      ;; The procedure:
		      (lambda (args)
		        (body-den (append (map make-binding params args)
					  env)))))]

		 ;; (IF test then else)
		 [(keyword=? 'if e1)
		  (local [(define test-den (den (second exp)))
		  	  (define then-den (den (third exp)))
			  (define else-den (den (fourth exp)))]
		    (lambda (env)
		      (cond [(test-den env) (then-den env)]
		      	    [else (else-den env)])))]

		 ;; Function application: (function arg ...) 
		 [else (local [(define fn-den (den (first exp)))
		               (define args   (rest exp))]
			 (lambda (env)
			   ((fn-den env)
			    (map (lambda (arg) ((den arg) env))
				 args))))]))]))

;; HExp -> Value
;; Run the Husky expression in the top-level environment
(define (run e) ((den e) top-env))

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
  (λ (args) (apply f args)))

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
	

