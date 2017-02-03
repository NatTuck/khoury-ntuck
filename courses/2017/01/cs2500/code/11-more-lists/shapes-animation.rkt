;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname shapes-animation) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

(define BG (empty-scene 600 600))

; The plan:
;  - have a list of shapes
;  - draw them all into a scene

; To draw a shape, need to know:
;  - which shape
;  - color - picked arbitrarily
;  - always solid
;  - size
;  - position (x, y)

; A Shape is (make-shape ShapeType Number Number Number)
(define-struct shape [type size x y])

; A ShapeType is one of:
;  - 'circle
;  - 'square
;  - 'triangle

; A LoSh (List of Shapes) is one of:
;  - empty
;  - (cons Shape LoSh)

(define LOSH
  (cons (make-shape 'circle 40 100 100)
        (cons (make-shape 'square 50 200 200)
              (cons (make-shape 'triangle 60 300 300)
                    empty))))


; LoSh Image -> Image
; Draw all shapes in list into a scene
(define (draw-shapes xs bg)
  (cond [(empty? xs) bg]
        [(cons? xs) (draw-one-shape (first xs)
                                    (draw-shapes (rest xs) bg))]))


; Shape Image -> Image
; Draw a shape
(define (draw-one-shape sh bg)
  (place-image (get-shape-image (shape-type sh)
                       (shape-size sh))
               (shape-x sh)
               (shape-y sh)
               bg))

; ShapeType Number -> Image
; Get the actual image by shape-type.

(define (get-shape-image st size)
  (cond [(symbol=? st 'circle) (circle size 'solid 'magenta)]
        [(symbol=? st 'square) (square size 'solid 'blue)]
        [(symbol=? st 'triangle) (triangle size 'solid 'orange)]))

#;(draw-shapes LOSH BG)

(define (render xs)
  (draw-shapes xs BG))

; LoSh -> LoSh
; Move the shapes.
(define (move-shapes xs)
  (cond [(empty? xs) empty]
        [(cons? xs) (cons (move-one-shape (first xs)) 
                          (move-shapes (rest xs)))]))


; Shape -> Shape
; Move one shape

(define (move-one-shape sh)
  (make-shape (shape-type sh)
              (shape-size sh)
              (modulo (+ 10 (shape-x sh)) 600)
              (modulo (+ 20 (shape-y sh)) 600)))


(big-bang LOSH
          [to-draw render]
          [on-tick move-shapes])

