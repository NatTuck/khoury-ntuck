;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname lec19) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;; Set is one of:
;; -- empty
;; -- (cons Number Set)

;; contains? : Set Number -> Boolean
(define (contains? s x)
   (cond
     [(empty? s) false]
     [else (or (= (first s) x) (contains? (rest s) x))]))

(equal? (contains? (list 1 2 3) 1) true)
(equal? (contains? (list 1 2 3) 4) false)

;; subset? : Set Set -> Boolean
;; is every element in s also in t?
(define (subset? s t)
   (cond
     [(empty? s) true]
     [else (and (contains? t (first s)) (subset? (rest s) t))]))

(check-expect (subset? empty (list 1)) true)
(check-expect (subset? (list 1) empty) false)
(check-expect (subset? (list 1) (list 1)) true)

;; set-equal? : Set Set -> Boolean
(define (set-equal? s t)
   (and (subset? s t) (subset? t s)))

;; union : Set Set -> Set
(define (union s t)
   (cond
     [(empty? s) t]
     [else (cons (first s) (union (rest s) t))]))

(set-equal? (union empty (list 1 2)) (list 1 2))
(set-equal? (union (list 1) (list 2)) (list 1 2))
