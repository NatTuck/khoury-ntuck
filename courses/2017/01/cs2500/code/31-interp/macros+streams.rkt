#lang racket

#|
 == Stuff we start with ==

(SET! var exp)
(IF exp exp exp)
(QUOTE sexp)
(LAMBDA (var ...) exp)
(exp exp ...) ; or (CALL exp exp ...)
|#

#|
 == Stuff we can build ==

(LET  ((var exp) ...) exp)
(LET* ((var exp) ...) exp)
(BEGIN exp exp ...)
(COND clause ...)
(AND exp ...)
(OR exp ...)
(DEFINE var exp)

|#

(define-syntax :and
  (syntax-rules ()
    ((:and) #t)
    ((:and e1) e1)
    ((:and e1 e2 ...)
     (if e1 (:and e2 ...) #f))))

(define-syntax :or
  (syntax-rules ()
    ((:or) #f)
    ((:or e1) e1)
    ((:or e1 e2 ...) (if e1 #t (:or e2 ...)))))

(define-syntax :let
  (syntax-rules ()
    ((:let ((v1 e1) ...) body)
     ((lambda (v1 ...) body) e1 ...))))

(define-syntax :begin
  (syntax-rules ()
    ((:begin)    #t)
    ((:begin e1) e1)
    ((:begin e1 e2 ...)
     ((lambda (ignore-me) (:begin e2 ...))
      e1))))

(define-syntax :cond
  (syntax-rules ()
    ((:cond) #f)
    ((:cond (test1 body1))
     (if test1 body1 #f))
    ((:cond (test1 body1) clause ...)
     (if test1 body1 (:cond clause ...)))))

#;
(define-syntax :delay
  (syntax-rules ()
    ((:delay exp) (lambda () exp))))

(define (memoise thunk)
  (let ((forced? #f)
        (val     #f))
    (lambda ()
      (begin (if (not forced?)
                 (begin (set! val (thunk))
 		        (set! forced? #t))
		 #f)
	     val))))

(define-syntax :delay
  (syntax-rules ()
    ((:delay exp) (memoise (lambda () exp)))))

(define (:force delayed-thing)
  (delayed-thing))



(define-struct scons [first rest])

;;; A [Stream-of X] is one of:
;;; - empty
;;; - (stream-cons X (:delay [Stream-of X]))

(define-syntax stream-cons
  (syntax-rules () 
    ((stream-cons x1 xs-exp) (make-scons x1 (:delay xs-exp)))))

(define stream-first
  scons-first)

(define (stream-rest s)
  (:force (scons-rest s)))

(define (stream+ as bs)
  (if (or (empty? as) (empty? bs)) '()
      (stream-cons (+ (stream-first as)
                      (stream-first bs))
                   (stream+ (stream-rest as)
                            (stream-rest bs)))))

(define (take s n)
  (if (or (zero? n) (empty? s))
      '()
      (cons (stream-first s)
            (take (stream-rest s) (- n 1)))))

(define (drop s n)
  (cond [(empty? s) '()]
        [(zero? n) s]
        [else (drop (stream-rest s)
                    (- n 1))]))

(define (stream-map f s)
  (if (empty? s) '()
      (stream-cons (f (stream-first s))
		   (stream-map f (stream-rest s)))))

(define ones (stream-cons 1 ones))
(define nats (stream-cons 0 (stream-map add1 nats)))
(define fib-seq
  (stream-cons 1 (stream-cons 1 (stream+ fib-seq (stream-rest fib-seq)))))

(define (int-range lo hi) ; [lo,hi)
  (if (< lo hi)
      (stream-cons lo (int-range (+ lo 1) hi))
      '()))

(define (stream-filter test s)
  (if (empty? s) '()
      (local [(define elt (stream-first s))]
        (if (test elt)
            (stream-cons elt (stream-filter test (stream-rest s)))
            (stream-filter test (stream-rest s))))))

(define (sieve nums)
  (local [(define p (stream-first nums))]
    (stream-cons p
                 (sieve (stream-filter (lambda (n) (not (zero? (modulo n p))))
                                       nums)))))

(take (sieve (int-range 2 200)) 10)