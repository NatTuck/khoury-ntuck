;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname bigger-sets) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Sets represented as predicates (characteristic functions)
;;; Set = [Number -> Boolean]

;;; How do I represent (do examples)
;;; - the set of even numbers
;;; - the set of numbers [0,10]
;;; - the set of all numbers

(define EVENS even?)

(define (TOTEN x)
  (and (>= x 0)
       (<= x 10)))

(define (ALLNUMS x)
  true)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; INTERFACE Set 

;; contains? :  Set Number -> Boolean 
;; is elt a member of set? 

(define (contains? s x)
  (s x))

;; union :     Set Set -> Set
;; create the set that contains the elements of both 

;; lst->set :  [List-of Number] -> Set 
;; create a set from the given list of objects 

(define (lst->set xs)
  (λ (x) (member? x xs))) 

;; insert :  Set Number -> Set 
;; create a set from the given set and object 

(define (insert x s)
  (λ (y) (or (= x y) (contains? s x))))

;; intersect : Set Set -> Set
;; create the set that contains the elements that the two sets share 


;; cartesian : Set Set -> Set
;; create all possible (make-X .. ..) of elements from set1 and set2 
(define-struct pair [a b])


;; set->lst : Set Number Number -> [List-of Number]
;; Give a list of all numbers in the set from the range [a, b].

