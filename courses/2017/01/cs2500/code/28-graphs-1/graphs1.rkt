;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname graphs1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))


; A Graph is a mathematical object consisting of a bunch
; of things and a bunch of connections between the things.

; Example:
;  - T Stops
;  - Airports
;  - Computer Networks
;  - Mazes
;  - Road Maps - Google Maps is a graph app.
;  - Social Networks - Finding all the dissidents on Facebook is graph app.

; Draw the simplfied T graph. (V = {North Station, Downtown Crossing, Park, Alewife,
;          Oak Grove, Ruggles, Lechmere, Northeastern, South Station})

; Relabel the simplified T graph.

; Formally, we say a graph is a set V of vertices (aka nodes)
; and a set E of edges. Each edge is a pair of vertices from V.

; Graph Variants:
;  - Are edges single-directional or bidirectional?
;  - In a directed graph, are self-edges allowed?
;  - ... and others


; How do we represent the simplified T graph?

(define-struct node0 [name edges])
; A Node is (make-node0 Symbol [List-of Node])

; Breaks horribly with cycles.


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

; Other graph reps:
;  - List in-edges instead of out-edges
;  - (make-graph [Set-of Symbol] [Set-of (make-edge Symbol Symbol)])
;  - List of edges (verticies are implied)
;  - Edge predicate
;  - Adjacency matrix


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

; More design:
; - Is this structural or generative?
; - Base case?
; - How do we recurse?
; - What smaller problem can we solve to solve whole problem?
; - How do we show that it terminates?
#|
(check-expect (route? Tgraph 'OG 'RU) true)
(check-expect (route? Tgraph 'LE 'BW) true)
|#
(check-expect (route? Graph2 'Earth 'Mars) true)
(check-expect (route? Graph2 'Mars 'Earth) false)

(define (route? g a b)
  (local ((define a-node (find-node g a)))
    (cond [(symbol=? a b) true]
          [(empty? (node-edges a-node)) false]
          [else (andmap (λ (x) (route? g x b)) (node-edges a-node))])))


; Problem: This function doesn't terminate.








