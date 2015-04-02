;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname graph-actual-notes) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))


; We're going to define a structure for
; an adjacency list.

; A Node is a Symbol

; A Row is a [List-of Node]
; where:
;  - The first item is the current node.
;  - The rest of the list is the neighbors.

; A Graph is a [List-of Row]
; where:
;  - Each node in the graph has exactly one Row.

(define G1
  '((A B)
    (B C D)
    (C D)
    (D E)
    (E)))

; A [Maybe X] is one of:
;  - X
;  - false

; Note: [Maybe Boolean] doesn't work.

; Row -> Node
; Get the node that this row refers to.
(define (row-node r)
  (first r))

; Row -> [List-of Node]
; Get the neighbors for this row.
(define (row-neibs r)
  (rest r))

; Graph Node -> [List-of Node]
; Get the neighbors of the given node.
(check-expect (neibs G1 'E) '())
(check-expect (neibs G1 'B) '(C D))
(check-error  (neibs G1 'R) "No such vertex")

(define (neibs graph v)
  (cond
    [(empty? graph) (error "No such vertex")]
    [(symbol=? (row-node (first graph)) v)
     (row-neibs (first graph))]
    [else (neibs (rest graph) v)]))

; Graph Node Node -> [Maybe [List-of Node]]
; Find a path in the graph from x to y, if any.
; How?
;  - If x = y, we're done. (base case)
;  - If x has no neighbors, there's no path. (base case)
;  - Otherwise, try each neighbor n of x.
;    - Let p = (find-path graph n y)
;    - If one of those works, path = (cons x p)
; Terminates?
;  - Maybe not.

(check-expect (find-path1 G1 'E 'D) false)
(check-expect (find-path1 G1 'D 'E) '(D E))
(check-expect (find-path1 G1 'A 'E) '(A B C D E))

(define (find-path1 graph x y)
  (cond
    [(symbol=? x y) (list x)]
    [else (local (; Node -> [Maybe [List-of Node]]
                  ; Find a path from a neighbor to y in the graph.
                  (define (find-path-y n)
                    (find-path1 graph n y))
                  (define npaths
                    (filter list? (map find-path-y (neibs graph x)))))
            (if (empty? npaths)
                false
                (cons x (first npaths))))]))


(define G2
  '((A B)
    (B C D)
    (C A D)
    (D E)
    (E)))


; Termination:
;  - As long as there are no cycles, any path in the graph
;    is finite.
;  - Each recursive call to the function progresses one step
;    along each path.
;  - Eventually it will run out of path and terminate.


; Problem: This is slow.


; New plan:
;  - Check neighbors one at a time.
;  - Stop if we find a path.
(check-expect (find-path2 G1 'E 'D 0) false)
(check-expect (find-path2 G1 'D 'E 0) '(D E))
(check-expect (find-path2 G1 'A 'E 0) '(A B C D E))

(define (find-path2 graph x y len)
  (cond
    [(symbol=? x y) (list x)]
    [(> len (length graph)) false]
    [else (local ((define maybe-path
                    (find-path/list graph (neibs graph x) y len)))
            (if (boolean? maybe-path)
                false
                (cons x maybe-path)))]))

; Graph [List-of Node] Node -> [Maybe [List-of Node]]
; Find a path in the graph from a node in xs to y, if ay.
(define (find-path/list graph xs y len)
  (cond
    [(empty? xs) false]
    [else (local ((define maybe-path
                    (find-path2 graph (first xs) y (add1 len))))
            (if (list? maybe-path)
                maybe-path
                (find-path/list graph (rest xs) y len)))]))

; Solve cycles?
; New plan: 
;  - Count how long our path is.
;  - If it's longer than length(graph), it's bad.

(define (find-path graph x y)
  (find-path2 graph x y 0))