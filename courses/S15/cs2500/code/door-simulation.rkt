;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname door-simulation) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
(require 2htdp/image)
(require 2htdp/universe)

(define CLOSE-DELAY 2)
(define TEXT-SIZE 80)

; A DoorState is one of:
;  - "locked"
;  - "closed"
;  - "open"

; Program Main
; Simulates a door with an automatic closer.
(define (door-simulation s0)
  (big-bang s0
            [on-tick door-closer CLOSE-DELAY]
            [on-key door-actions]
            [to-draw door-render]))

; DoorState -> DoorState
; closes an open door over the period of one tick
(check-expect (door-closer "locked") "locked")
(check-expect (door-closer "closed") "closed")
(check-expect (door-closer "open") "closed")

(define (door-closer s)
  (cond
    [(string=? "locked" s) "locked"]
    [(string=? "closed" s) "closed"]
    [(string=? "open" s)   "closed"]))

; DoorState KeyEvent -> DoorState
; simulates actions on the door
(check-expect (door-actions "locked" "u") "closed")
(check-expect (door-actions "closed" "l") "locked")
(check-expect (door-actions "closed" " ") "open")
(check-expect (door-actions "open" "a") "open")
(check-expect (door-actions "closed" "a") "closed")

(define (door-actions s ke)
  (cond
    [(and (string=? "locked" s) (string=? "u" ke)) "closed"]
    [(and (string=? "closed" s) (string=? "l" ke)) "locked"]
    [(and (string=? "closed" s) (string=? " " ke)) "open"]
    [else s]))

; DoorState -> Image
; render the current state of the door as large red text

(check-expect (door-render "closed")
              (text "closed" TEXT-SIZE "red"))

(define (door-render s)
  (text s TEXT-SIZE "red"))

