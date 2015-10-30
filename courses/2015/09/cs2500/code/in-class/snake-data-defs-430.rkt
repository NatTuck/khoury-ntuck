;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname snake-data-defs-430) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

; Constants
(define CELL-SIZE 20) ; pixels
; GRID-ROWS is also # of columns
(define GRID-ROWS 20)
(define WSIZE (* CELL-SIZE GRID-ROWS)) ; pixels
(define BG (empty-scene WSIZE WSIZE))
(define SEG-SIZE (/ CELL-SIZE 2)) ; pixels
(define TICK-SPEED 0.2) ; seconds/tick


(define-struct snake [dir segs])
; A Snake is a (make-snake Dir LoSegs)
; interpretation: First segment in list
;    is the head of the snake.

; A Dir is one of:
;  - "up"
;  - "down"
;  - "left"
;  - "right"

; A LoSegs is one of:
;  - empty
;  - (cons Seg LoSegs)

(define-struct seg [x y color])
; A Seg is a
;  (make-seg Number Number Symbol)
; interpretation
;   x, y are in grid coordinates, +y is down

(define-struct food [x y color])
; A Food is
;  (make-food Number Number Symbol)
; interpretation
;   x, y are in grid coordinates, +y is down



