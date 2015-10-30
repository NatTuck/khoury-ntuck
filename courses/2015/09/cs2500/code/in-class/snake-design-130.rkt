;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname snake-design-130) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; == Snake Game ==

; Snake segments and food appear on a grid.
; Each "tick", the head of the snake moves in
; the direction it's facing.
; Facing is changed by pressing arrow keys.

; Snake Head
;  - Where? (changes)
;  - Which way will it go next? (changes)
;  - Color (changes)
;  - Size, and that it's a circle (const)

; The rest of the snake:
;  - Position of each segment (changes)

; Idea:
;  - Segments stick around for a number of ticks.

; More stuff:
;  - Tick speed (constant, for now)
;  - Window size (const)
;  - Food and snake segments are circles. (const)

; Food:
;  - Location (changes)

; Grid (all constant)
;  - Size of cells - squares, in pixels - implies snake speed
;  - Number of cells per row / col of the window.
;  - Boundries