;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname tree-lecture-130) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; A BT is one of:
;  - Number
;  - (make-node BT BT)
(define-struct node [left right])

#;
(define (bt-tmpl bt)
  (cond [(number? bt) ...]
        [else ... (bt-tmpl (node-right bt))
                  (bt-tmpl (node-left bt))]))


(define bt1 (make-node (make-node (make-node 0 0)
                                 5)
                      6))
(define bt2 (make-node (make-node 21 22)
                       (make-node 31 32)))


; Number BT -> Boolean
; Is the number somewhere in the tree?
(check-expect (contains? 5 bt1) true)
(check-expect (contains? 7 bt1) false)

#;(define (contains? n bt)
  (cond [(number? bt) (= n bt)]
        [else (or (contains? n (node-right bt))
                  (contains? n (node-left bt)))]))

(define working-or
  (lambda (a b) (or a b)))

(define (contains? n bt)
  (tree-fold working-or
             (lambda (x) (= n x))
             bt))

; BT -> [List-of Number]
; Make a list of all the numbers in the tree.

(check-expect (flatten bt1) '(0 0 5 6))
(check-expect (flatten bt2) '(21 22 31 32))

#;(define (flatten bt)
  (cond [(number? bt) (list bt)]
        [else (append (flatten (node-left bt))
                      (flatten (node-right bt)))]))



; [X -> Y] [Number -> X] BT -> Y
(define (tree-fold node-op leaf-op bt)
  (cond [(number? bt) (leaf-op bt)]
        [else (node-op (tree-fold node-op leaf-op (node-left bt))
                       (tree-fold node-op leaf-op (node-right bt)))]))

(define (flatten bt)
  (tree-fold append list bt))