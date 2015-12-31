;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname church-430) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
; [List-of NatNum] -> NatNum
; Add up the numbers in the list.
(check-expect (sum0 '()) 0)
(check-expect (sum0 '(1 2 3)) 6)

(define (sum0 xs)
  (if (empty? xs)
      0
      (+ (first xs)
         (sum0 (rest xs)))))

; λ-gremlins stole our booleans!

; A Boolean is a function of two arguments.
; It picks one depending on its value.
(define z-true (λ (yes no) yes))
(define z-false (λ (yes no) no))

(define z-and (λ (a b)
                (a b z-false)))
(define z-or (λ (a b)
               (a z-true b)))
(define z-not (λ (a)
                (a z-false z-true)))

(define (show-zb b) (b 'true 'false))
(check-expect (show-zb (z-and z-true z-true)) 'true) 
(check-expect (show-zb (z-and z-false z-true)) 'false) 
(check-expect (show-zb (z-or  z-false z-false)) 'false)
(check-expect (show-zb (z-or  z-false z-true)) 'true) 

#|
(define test z-true)
((test
 (lambda () 5)
 (lambda () (/ 5 0))))
|#

(check-expect (sum1 '()) 0)
(check-expect (sum1 '(1 2 3)) 6)

(define (sum1 xs)
  (((z-empty1? xs) 
      (lambda () 0)
      (lambda () (+ (first xs)
                    (sum1 (rest xs)))))))

(define (z-empty1? xs)
  (if (empty? xs) z-true z-false))

; The gremlins got our lists.

(define z-cons (λ (hd tl)
                 (λ (f) (f hd tl z-false))))
; head = z-first
(define head (λ (p)
               (p (λ (hd tl e?) hd))))
; tail = z-rest
(define tail (λ (p)
               (p (λ (hd tl e?) tl))))
(define z-empty (λ (f) (f 'none 'none z-true)))
(define z-empty? (λ (xs) (xs (λ (hd tl e?) e?)))) 
                   

(check-expect (sum2 z-empty) 0)
(check-expect (sum2 (z-cons 1 (z-cons 2 (z-cons 3 z-empty))))
              6)

(define (sum2 xs)
  (((z-empty? xs) 
      (lambda () 0)
      (lambda () (+ (head xs)
                    (sum2 (tail xs)))))))

; The gremlins have stolen our numbers.

; A Natural Number n is a function that
; take another function and an argument and
; applys the function repeated n times.

(define zero (λ (f) (λ (x) x)))
(define one  (λ (f) (λ (x) (f x))))
(define succ (λ (n) (λ (f) (λ (x) (f ((n f) x))))))
(define two  (succ one))
(define four (succ (succ two)))

(define add  (λ (a b)
               (λ (f) (λ (x) ((a f) ((b f) x))))))

(define z-zero? (λ (n)
                (z-not ((n (λ (q) z-true)) z-false))))



