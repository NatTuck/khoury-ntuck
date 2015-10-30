;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname traffic-light) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
(require 2htdp/image)
(require 2htdp/universe)

(define LIGHT-SIZE 80)
(define BOX-HEIGHT (* LIGHT-SIZE 8))
(define BOX-WIDTH  (* LIGHT-SIZE 4))
(define DELAY 2)

; (( Data definiton for an enumeration ))
; A LightState is one of three colors:
;  - "red"
;  - "yellow"
;  - "green"
; A traffic light has one of three colored bulbs turned on.
; We represent its state as the color of the currently-lit bulb.

; An ImageMode is one of two things:
;  - "solid"   - The image is drawn filled in.
;  - "outline" - Only the outline is drawn.
; LightState LightStates -> ImageMode
(define (light-mode light s)
  (cond
    [(string=? light s) "solid"]
    [else "outline"]))

(check-expect (light-mode "green" "green") "solid")
(check-expect (light-mode "green" "red") "outline")

; LightState -> Image
; Draw a traffic light given a state.
(define (traffic-light s)
  (overlay
    (above (circle LIGHT-SIZE (light-mode "red" s) "red")
           (circle LIGHT-SIZE (light-mode "yellow" s) "yellow")
           (circle LIGHT-SIZE (light-mode "green" s) "green"))
    (rectangle BOX-WIDTH BOX-HEIGHT "solid" "black")))

; LightState -> LightState
; The next state of the traffic light.
(define (next-state s)
  (cond
    [(string=? s "green") "yellow"]
    [(string=? s "yellow") "red"]
    [(string=? s "red") "green"]))

(check-expect (next-state "green") "yellow")
(check-expect (next-state "yellow") "red")
(check-expect (next-state "red") "green")

; Launches the traffic light.
; Usage: (main "red")
(define (main s)
  (big-bang s
            [on-tick next-state DELAY]
            [to-draw traffic-light]))