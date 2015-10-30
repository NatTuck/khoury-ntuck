;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname snake-design-notes-430) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; The snake:
;  - Size of circles      (const)
;  - Direction of travel  (changes)
;  - Speed                (const)
;  - Position of each segment (changes)
;  - color of each segment (changes)
;    (List of Segments)
;  - Head is the first? / last? segment in list

; The food:
;  - Position (changes)
;  - Color (changes)
;  - Size of circle (constant)

; The Window
;  - Size (const)
;  - Grid cell size (const)
;  - Number of grid rows / cols (const)
