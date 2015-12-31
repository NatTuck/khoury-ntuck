;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname in-class-sets-130) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; Lecture #20-something: Sets, part 1

; A [Set-of X] is a [List-of X]
;  order is ignored
;  repetition is disallowed

; A SoN (set of numbers) is a [Set-of Numbers]
(define s1 '(1 2 4))   ; = {1, 2, 4}
(define s2 '(4 1 2))   ; = {1, 2, 4}

; SoN -> Number
; Set cardinality
(check-expect (set-size empty) 0)
(check-expect (set-size s1) 3)

#;(define (set-size s)
  (local [(define (mystery _val sum)
            (+ 1 sum))]
    (foldr mystery 0 s)))

(define set-size length)

; SoN Number -> Boolean
; Is x a member of the set?
#;(check-expect (set-member? s1 3) false)
#;(check-expect (set-member? s1 4) true)

#;(define (set-member?.v1 s x)
  (member? x s))

#;(define (set-member?.v2 s x)
  (and (not (empty? s))
       (or (= x (first s))
           (set-member? (rest s) x))))

#;(define (set-member? s x)
  (ormap (λ (y) (= y x)) s)) 

; this is ormap



; Set operations (one set):
;  - Cardinality
;  - Membership
;  - Power set (skip)

; SoN SoN -> SoN
; Set intersection
(check-expect (intersect '(1 2 3) '(2 3 4))
              '(2 3))
(check-expect (intersect '(1 2 3) empty)
              empty)

(define (intersect a b)
  (cond [(empty? a) empty]
        [else (if (member? (first a) b)
                  (cons (first a)
                        (intersect (rest a) b))
                  (intersect (rest a) b))]))

; SoN SoN -> SoN
; Set union
(check-expect (union '(1 2 3) '(2 3 4))
              '(1 2 3 4))
(check-expect (union '(1 2 3) empty)
              '(1 2 3))
(check-expect (set=? (union '(1 3 2) '(4 2 3 5))
                     '(5 4 3 2 1))
              true)

(define (union.v1 a b)
  (cond [(empty? a) b]
        [else (if (not (member? (first a) b))
                  (cons (first a) (union (rest a) b))
                  (union (rest a) b))]))

(define (union.v2 a b)
  (append
   (filter (lambda (x)
             (not (member? x b))) a)
   b))

(define (union a b)
  (local [(define (set+n n s)
            (if (not (member? n s))
                (cons n s)
                s))]
  (foldr set+n b a)))

; (cons 1 (cons 2 (cons 3 empty)))
; (set+n 1 (set+n 2 (set+n 3 b))))
  
; SoN SoN -> Boolean
; Are the sets equal?
(check-expect (set=? empty empty) true)
(check-expect (set=? '(3 1 2) '(1 2 3)) true)
(check-expect (set=? '(1 2 3) '(1 4 3)) false)

(define (set=? a b)
  (and (subset? a b) (subset? b a)))

; SoN SoN -> Boolean
; Is x a subset of y?
(check-expect (subset? '(1) '(1 2)) true)
(check-expect (subset? '(3) '(1 2)) false)

(define (subset?.v1 x y)
  (local [(define (is-elem-of-y? q)
            (member? q y))]
    (andmap is-elem-of-y? x)))

(define (subset? x y)
  (andmap (lambda (z)
            (member? z y))
          x))


; Operations on two sets:
;  - Intersection
;  - Union
;  - Equality
;  - Cross Product
;  - Symmetric Difference
;  - Set Subtraction


