;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname loops) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
(require 2htdp/universe)
(require 2htdp/image)

(define DOT (circle 10 'solid 'blue))
(define WSIZE 300)
(define GRSZ  50)

; The most basic loops are:
;  - map
;  - foldr
;  - filter

; But first, build-list.

; build-list: Number [Number -> X] -> [List-of X]
; Generate a list of n things using a function that converts
; numbers 0...n into things.

(check-expect (build-list 5 add1) '(1 2 3 4 5))
(check-expect (build-list 5 identity) '(0 1 2 3 4))

; Any -> Number
; Throw away argument, always returns zero.
(define (always-zero _unused) 
  0)

(check-expect (build-list 5 always-zero) '(0 0 0 0 0))

; map: [X -> Y] [List-of X] -> [List-of Y]
; Apply a function to each element of an input
; list to produce an output list.

(check-expect (map add1 (list 1 2 3 4)) (list 2 3 4 5))
(check-expect (map always-zero '(1 2)) '(0 0))

; Number -> Posn
; Generate a Posn for a dot from an integer.
; The Posns will go in a grid across then down.
(define DOTS-PER-LINE (add1 (/ WSIZE GRSZ)))

(define (grid-point x)
  (make-posn (* GRSZ (modulo x DOTS-PER-LINE))
             (* GRSZ (floor (/ x DOTS-PER-LINE)))))

(check-expect (build-list 2 grid-point) (list (make-posn 0 0) (make-posn 50 0)))

(define GRID (build-list 49 grid-point))

; foldr: [X Y -> Y] Y [List-of X] -> Y
; Fold a list into a single value, starting with a
; base value and folding in elements left to right.

(check-expect (foldr + 0 (list 2 4 6)) 12)

; Posn Image -> Posn
; Add a dot to an image.
(define (place-dot p img)
  (place-image DOT (posn-x p) (posn-y p) img))

; [List-of Posn] -> Image
; Place some dots in an empty scene.
(define (show-dots xs)
  (foldr place-dot (empty-scene WSIZE WSIZE) xs))

#;(show-dots GRID)

(define (move-dot p)
  (make-posn (modulo (+ (posn-x p) 2) WSIZE) 
             (modulo (+ (posn-y p) 1) WSIZE)))

(define (move-dots xs)
  (map move-dot xs))

(define (scroll-dots ds)
  (big-bang ds
            [on-tick move-dots]
            [to-draw show-dots]))

#;(scroll-dots GRID)
  
; filter: [X -> Boolean] [List-of X] -> [List-of X]
; Takes the items from the list that match the 
; passed-in predicate.

(check-expect (filter even? (list 1 2 3 4)) (list 2 4))

; Posn -> Boolean
; Is the dot in the top half of the grid?
(define (top-half? p)
  (< (posn-y p) (/ WSIZE 2)))

(define TOP-DOTS (filter top-half? GRID))

#;(show-dots TOP-DOTS)
#;(scroll-dots TOP-DOTS)

; Then we have:
;  - foldl
;  - andmap
;  - ormap

; foldl: [X Y -> Y] Y [List-of X] -> Y
; (foldr ... (reverse xs) ...)

(check-expect (foldr cons empty '(1 2 3)) '(1 2 3))
(check-expect (foldl cons empty '(1 2 3)) '(3 2 1))

; andmap: [X -> Boolean] [List-of X] -> Boolean
; Does every item in the list satisfy the predicate?

(check-expect (andmap even? (list 2 4 6)) true)
(check-expect (andmap even? (list 2 3 6)) false)

; ormap: [X -> Boolean] [List-of X] -> Boolean
; Does any item in the list satisfy the predicate?

(check-expect (ormap odd? (list 2 4 6)) false)
(check-expect (ormap odd? (list 2 3 6)) true)

; Finally, these exist:
;  - sort
;  - argmax
;  - argmin

; sort: [List-of X] [X X -> Boolean] -> [List-of X]
; Sorts a list gien a comparison function.

(check-expect (sort '(2 3 1) >) '(3 2 1))
(check-expect (sort '(2 3 1) <) '(1 2 3))

; argmax: [X -> Number] [List-of X] -> X
; Find a value in the list that maximizes the function.

(check-expect (argmax abs '(1 2 3 -1 -2 -4)) -4)

; argmin: [X -> Number] [List-of X] -> X
; Find a value in the list that minimizes the function.

(check-expect (argmin abs '(1 2 3 -1 -2 -4)) 1)


(define-struct person [first last])
; A Person is a (make-person String String)

(define PEOPLE (list
                (make-person "James" "Howlett")
                (make-person "Ororo" "Munroe")
                (make-person "Katherine" "Pryde")
                (make-person "Robert" "Drake")))

; Person -> Number
; Get the length of a Person's name
(define (name-length p)
  (string-length (string-append (person-first p) (person-last p))))

; [List-of Person] -> Person
; Get the person with the longest name.
(check-expect (longest-name PEOPLE) (make-person "Katherine" "Pryde"))

(define (longest-name ps)
  (argmax name-length ps))

; Person Person -> Boolean
; Compare two people by last name.
(define (person<? p0 p1)
  (string<? (person-last p0) (person-last p1)))

; [List-of Person] -> [List-of Person]
; Sort a list of people by last name.
(define (sort-people ps)
  (sort ps person<?))
