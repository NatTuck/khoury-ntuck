;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname key-mouse-example) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
(require 2htdp/image)
(require 2htdp/universe)

(define BG (empty-scene 500 500))

(define (main s)
  (big-bang s
            [to-draw show-text]
            [on-mouse got-mouse]
            [on-key got-key]))

(define (show-text s)
  (overlay (text s 40 "green") BG))

(define (got-mouse s x y b)
  (format "~a ~a ~a" x y b))

(define (got-key s ke)
  (format "key: ~a" ke))