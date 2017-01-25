;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname dr-examples) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; Design a function to convert Fareninheight temperatures to Celsius

; Number -> Number
; Convert Fareinheit to Celsius

(check-expect (f->c 32) 0)
(check-expect (f->c 212) 100)
(check-expect (f->c -40) -40)

; Template
#;
(define (number-tmpl x)
  ... x ...)

(define (f->c f)
  (* 5/9 (- f 32)))



; Something with a struct





; Something with an enumeration






; Something nested




; Something with a 
