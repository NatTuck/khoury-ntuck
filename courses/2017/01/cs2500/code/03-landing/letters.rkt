;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname letters) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))




(check-expect (greeting "Alice") "Dear Alice:")
(check-expect (greeting "Bob") "Dear Bob:")

; 
(define (greeting name)
  (string-append "Dear " name ":"))



(check-expect (greeting->name "Dear Alice:") "Alice")
(check-expect (greeting->name "Dear Bob:") "Bob")

(define (greeting->name greeting)
  (substring greeting
             5
             (- (string-length greeting) 1)))


