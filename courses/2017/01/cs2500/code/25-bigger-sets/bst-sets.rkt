;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname bst-sets) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct node [num left right])
; A BST (of Numbers) is one of:
;  - empty
;  - (make-node Number BST BST)
;
; Where (max left value) < value <= (min right value)
; for each node.

; BST -> List
; Extract the Numbers from a BST in sorted order.
(check-expect (extract empty) empty)
(check-expect (extract (make-node 5 empty (make-node 6 empty empty))) (list 5 6))

(define (extract bst)
  (cond
    [(empty? bst) empty]
    [(node? bst) (append (extract (node-left bst))
                         (list (node-num bst))
                         (extract (node-right bst)))]))

; Number BST -> BST
; Insert a number into the BST.
(check-expect (insert 5 empty) (make-node 5 empty empty))
(check-expect (insert 7 (make-node 5 empty empty))
              (make-node 5 empty (make-node 7 empty empty)))
(check-expect (insert 4 (make-node 5 empty empty))
              (make-node 5 (make-node 4 empty empty) empty))
(check-expect (insert 5 (make-node 5 empty empty))
              (make-node 5 empty empty))

(define (insert n bst)
  (cond
    [(empty? bst) (make-node n empty empty)]
    [(and (node? bst) (= (node-num bst) n)) bst]
    [else
     (if (< n (node-num bst))
         (make-node (node-num bst) 
                    (insert n (node-left bst))
                    (node-right bst))
         (make-node (node-num bst)
                    (node-left bst)
                    (insert n (node-right bst))))]))

; set insert:
;  - worst case: n
;  - balanced tree: log n

; [List-of Number] -> BST
; Build a list of numbers into a BST.
(check-expect (extract (build-bst empty)) empty)
(check-expect (extract (build-bst '(3 2 1))) '(1 2 3))

(define (build-bst xs)
  (foldr insert empty xs))

; Number BST -> Boolean
; Does the BST have the number in it?
(check-expect (contains? 5 (build-bst '(7 2 5))) true)
(check-expect (contains? 5 (build-bst '(7 2 6))) false)

(define (contains? n bt)
  (cond
    [(empty? bt) false]
    [(= n (node-num bt)) true]
    [(< n (node-num bt))
     (contains? n (node-left bt))]
    [else
     (contains? n (node-right bt))]))

; Set: member
;  - worst case: n 
;  - balanced tree: log n

; Number BST -> BST
; Remove a number from the BST.
(check-expect (extract (bst-remove 5 (build-bst '(7 2 5)))) '(2 7))
(check-expect (bst-remove 5 empty) empty)
(check-expect (extract (bst-remove 5 (build-bst '(5 8)))) '(8))
(check-expect (extract (bst-remove 5 (build-bst '(3 5 2)))) '(2 3))

(define (bst-remove n bt)
  (cond
    [(empty? bt) empty]
    [(= n (node-num bt)) 
     (if (empty? (node-left bt))
         (node-right bt)
         (make-node (node-num (node-left bt))
                    (bst-remove (node-num (node-left bt)) (node-left bt))
                    (node-right bt)))]
    [(< n (node-num bt)) 
     (make-node 
      (node-num bt)
      (bst-remove n (node-left bt))
      (node-right bt))]
    [else 
     (make-node
      (node-num bt)
      (node-left bt)
      (bst-remove n (node-right bt)))]))




; Operations:

; contains?
; union
; intersect



