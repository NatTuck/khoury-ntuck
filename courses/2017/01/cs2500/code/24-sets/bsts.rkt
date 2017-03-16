;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname bsts) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))

; Sets:
;  - A set is a bunch of values of the same type.
;  - Basic operation is "member?".
;    - Splits all values of the type into two groups.
;    - Some objects are in (members of) the set.
;    - All other objects of that type are not.
;
; (e.g.) The set { 2 4 }.
;   - Type: Number
;   - 2 is in the set.
;   - 5 and 3721 are not.
;
; Sets don't care about duplicate items.
;   { 2 4 4 } is the same as { 2 4 }.
;
; If we asked (member? (set '(2 4 4)) 4), it wouldn't care either way.

; Two ways to implement sets:
;  - Lists
;  - Binary Trees

; Basic operations:
;   set - Make a set.
;   member? - Does this set contain a given value.
;   insert - Add an item to a set.
;   remove - Remove an item from a set.
;   set=? - Are two sets equal?

; A ListSet is a [List-of Number].

; [List-of Number] -> ListSet
; Make a set.
(define (l-set xs)
  xs)

; Steps: One 'cons' per item.

(define LS1 (l-set '(5 10 20)))
(define LS2 (l-set '(1 3  5)))

; Number ListSet -> Boolean
; Does the set contain the number?
(check-expect (l-member? 10 LS1) true)
(check-expect (l-member? 10 LS2) false)

(define (l-member? x xs)
  (member? x xs))

; Steps: 
;  - Look at items until we find one.
;  - Probably have to look at half the items.

; Number ListSet -> ListSet
; Add a number to the set.
(check-expect (l-insert 15 LS1) (l-set '(15 5 10 20)))

(define (l-insert x xs)
  (cons x (l-remove x xs)))

; Steps: Look at each item to remove.
;        Don't want duplicates.

; Number ListSet -> ListSet
; Remove a number from the list.
(check-expect (l-remove 10 LS1) (l-set '(5 20)))

(define (l-remove x xs)
  (filter (lambda (y) (not (= y x))) xs))

; Steps: Look at each item.
;     - Could optimize to probabably only look at half the items.


; ListSet ListSet -> Boolean
; Are two sets equal?
(check-expect (l-set=? LS1 LS1) true)
(check-expect (l-set=? LS1 LS2) false)

(define (l-set=? xs ys)
  (list=? (sort xs <) (sort ys <)))

; [List-of Number] [List-of Number] -> Boolean
; Are the two lists equal?
(check-expect (list=? '(1 2 3) '(1 2 3)) true)
(check-expect (list=? '(1 2 4) '(1 2 3)) false)
(check-expect (list=? '(1) '(1 2)) false)

(define (list=? xs ys)
  (cond
    [(and (empty? xs) (empty? ys)) true]
    [(or (empty? xs) (empty? ys)) false]
    [(not (= (first xs) (first ys))) false]
    [else (list=? (rest xs) (rest ys))]))

; Steps: 
;  - Two sorts.
;  - Need to sort in case order is different.
;  - Each sort takes (n*log n) comparisons.

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

; Set remove steps:
;  - Worst case: n
;  - Balanced tree: log n