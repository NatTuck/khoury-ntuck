;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname traffic-light) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
(require 2htdp/image)
(require 2htdp/universe)

(define LIGHT-SIZE 80)
(define BOX-HEIGHT (* LIGHT-SIZE 8))
(define BOX-WIDTH  (* LIGHT-SIZE 4))
(define DELAY 2)

; (( Data definition of an enumeration ))
; A LightState is one of three colors:
;  - "red"
;  - "green"
;  - "yellow"
; A traffic light has one of three bulbs turned on.
; We represent its state as the color of the currently-lit bulb.

; An ImageMode is one of two things:
;  - "solid"   - The image is drawn filled-in.
;  - "outline" - Only the outline is drawn.

; (( signature ))
; LightState LightState -> ImageMode
; (( purpose statement ))
; Determines how to draw a circle for a traffic light
; from the current tn.
(define (light-mode light tn)
  (cond
    [(string=? light tn) "solid"]
    [else "outline"]))

(check-expect (light-mode "green" "green") "solid")
(check-expect (light-mode "green" "red") "outline")

; LightState -> Image
; Constructs an image of a traffic light given a TrafficLight.
(define (traffic-light tn)
  (overlay
   (above (circle LIGHT-SIZE (light-mode "red" tn) "red")
          (circle LIGHT-SIZE (light-mode "yellow" tn) "yellow")
          (circle LIGHT-SIZE (light-mode "green" tn) "green"))
   (rectangle BOX-WIDTH BOX-HEIGHT "solid" "black")))

; LightState -> LightState
; The next state of the traffic light.
(define (next-state tn)
  (cond
    [(string=? tn "green") "yellow"]
    [(string=? tn "yellow") "red"]
    [(string=? tn "red") "green"]))

(check-expect (next-state "green") "yellow")
(check-expect (next-state "yellow") "red")
(check-expect (next-state "red") "green")

; Launches the traffic light.
; Usage: (main "red")
(define (main tn)
  (big-bang tn
            [on-tick next-state DELAY]
            [to-draw traffic-light]))
