;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname snake-data-defs-130) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)


; Some Constants
(define WSIZE 600) ; pixels
(define GRID-ROWS 40) ; Also, columns
(define CELL-SIZE (/ WSIZE GRID-ROWS)) ; pixels
(define TICK-SPEED 0.2) ; seconds/tick
(define BG (empty-scene WSIZE WSIZE))


; Data Definitions for the World

(define-struct snake [dir segs])
; A Snake is (make-snake Dir LoSegs)
; interpretation:
;  The head is the first seg in segs.

; A LoSegs is one of:
;  - empty
;  - (cons Seg LoSegs)

; A Dir is one of: "up" "down" "left" "right"

(define-struct seg [x y color])
; A Seg is (make-seg Number Number Symbol)
; x, y are in grid cells; +y is down

(define-struct food [x y color])
; A Food is (make-food Number Number Symbol)
; x, y are in grid cells; +y is down







