;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname graphs2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; Better plan:
(define-struct node [name edges])
; A Node is (make-node Symbol [List-of Symbol])
; A Graph is [List-of Node]

; This is called an "adjacency list".
(define Tgraph
  (list
   (make-node 'OG '(NS))
   (make-node 'NS '(LE OG PS DC))
   (make-node 'LE '(NS))
   (make-node 'PS '(AW NE DC NS))
   (make-node 'DC '(PS NS RU BW))
   (make-node 'AW '(PS))
   (make-node 'NE '(PS))
   (make-node 'RU '(DC))
   (make-node 'BW '(DC))))

; Graph could be a directed graph. We're representing it
; as undirected which duplicates all edges.

; But, conceptually the T could have one-way edges.
(define Graph2
  (list (make-node 'Earth '(Mars))
        (make-node 'Mars '())))


; Rather than putting the other end of an edge
; directly in the current node, we put a *reference*
; to it. This layer of indirection allows us to have
; cycles in our data.

; Graph Symbol -> Node
; Find a node in a graph.

(check-error  (find-node Tgraph 'XX) "no such node")
(check-expect (find-node Tgraph 'OG) (make-node 'OG '(NS)))

(define (find-node g x)
  (cond [(empty? g) (error "no such node")]
        [(cons? g) (if (symbol=? x (node-name (first g)))
                       (first g)
                       (find-node (rest g) x))]))

; Graph Symbol Symbol -> Boolean
; Is there a route from a to b in the graph?

(check-expect (route? Tgraph 'OG 'RU) true)
(check-expect (route? Tgraph 'LE 'BW) true)
(check-expect (route? Graph2 'Earth 'Mars) true)
(check-expect (route? Graph2 'Mars 'Earth) false)

#;
(define (route.0? g a b)
  (local ((define a-node (find-node g a)))
    (cond [(symbol=? a b) true]
          [(empty? (node-edges a-node)) false]
          [else (ormap (λ (x) (route? g x b)) (node-edges a-node))])))


; Problem: This function doesn't terminate.

; More design:
; - Is this structural or generative?
; - Base case?
; - How do we recurse?
; - What smaller problem can we solve to solve whole problem?
; - How do we show that it terminates?


; How can we make it a smaller problem?
; Plan A: Remove the current node from the graph before recursing.

(define (route? g a b)
  (local ((define a-node (find-node g a))
          (define graph1 (remove-node g a)))
    (cond [(symbol=? a b) true]
          [(empty? (node-edges a-node)) false]
          [else (ormap (λ (x) (route? graph1 x b)) (node-edges a-node))])))

; Graph Symbol -> Graph
; Remove a node from the graph.

(define (remove-node g a)
  (cond [(empty? g) empty]
        [(cons? g) (if (symbol=? a (node-name (first g)))
                       (remove-node (rest g) a)
                       (cons (remove-edges-to (first g) a)
                             (remove-node (rest g) a)))]))

; Node Symbol -> Node
; Remove any edges from this node to the given node.

(define (remove-edges-to n a)
  (make-node (node-name n)
             (filter (λ (x) (not (symbol=? x a))) (node-edges n))))


; Plan B: Accumulator
;  - Add a parameter tracking what we've done so far.
;  - In this case, add a [List-of Symbol] called 'seen'.
;    If we've seen a node, don't go there.
(check-expect (route.v2? Tgraph 'OG 'RU) true)
(check-expect (route.v2? Tgraph 'LE 'BW) true)
(check-expect (route.v2? Graph2 'Earth 'Mars) true)
(check-expect (route.v2? Graph2 'Mars 'Earth) false)

(define (route.v2? g a b)
  (route?-helper g a b '()))

(define (route?-helper g a b seen)
  (cond [(member? a seen) false]
        [(symbol=? a b) true]
        [else (ormap (λ (x) (route?-helper g x b (cons a seen)))
                     (node-edges (find-node g a)))]))


; Graph Symbol Symbol -> [Maybe [List-of Symbol]]
; Find a path from a to b.
(define (route g a b)
  (route1 g a b '()))

(define (route1 g a b path)
  (cond [(member? a path) false]
        [(symbol=? a b) (reverse (cons b path))]
        [else (foldr (λ (x y) (if (not (false? y))
                                  y
                                  (route1 g x b (cons a path))))
                     false
                     (node-edges (find-node g a)))])) 

; Describe iterative deepening.


; Other graph reps:
;  - List in-edges instead of out-edges
;  - (make-graph [Set-of Symbol] [Set-of (make-edge Symbol Symbol)])
;  - List of edges (verticies are implied)
;  - Edge predicate
;  - Adjacency matrix


