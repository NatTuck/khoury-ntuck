;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname list-functions) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; A LOS (List of Strings) is one of:
;  - empty
;  - (cons String LOS)
#;(define (los-tmpl xs)
    (cond
      [(empty? xs) ...]
      [(cons? xs) ... (first xs) ... (rest xs) ...]))

(define FRUIT (cons "Apple" (cons "Pear" (cons "Banana" empty))))

; LOS String String -> LOS
; Replace all copies of 'new' with 'old' in list. 
(check-expect (replace FRUIT "Goat" "Panda") FRUIT)
(check-expect (replace empty "Goat" "Panda") empty)
(check-expect (replace FRUIT "Apple" "Pear")
              (list "Pear" "Pear" "Banana"))
(check-expect (replace (replace FRUIT "Apple" "Pear") "Pear" "Mango")
              (list "Mango" "Mango" "Banana"))

(define (replace xs old new)
  (cond
    [(empty? xs) empty]
    [(cons? xs)
       (cond
          [(string=? (first xs) old) 
           (cons new (replace (rest xs) old new))]
          [else (cons (first xs)
                      (replace (rest xs) old new))])]))

; LOS -> Number
; count the number of chars in the given LOS
(check-expect (size empty) 0)
(check-expect (size (list "goat" "pie")) 7)

(define (size xs)
   (cond
     [(empty? xs) 0]
     [(cons? xs) (+ (string-length (first xs))  
                    (size (rest xs)))]))

; LOS String -> Boolean
; is s on the given list?
(define L2 (cons "One" (cons "Two" empty)))
(check-expect (in? empty "Goat") false)
(check-expect (in? L2 "Three") false)
(check-expect (in? L2 "Two") true)

(define (in? xs s)
   (cond
     [(empty? xs) false]
     [(cons? xs) (or (string=? (first xs) s) (in? (rest xs) s))]))


; A LON (List of Numbers) is:
;  - empty
;  - (cons Number LON)
#;(define (lon-tmpl xs)
    (cond
      [(empty? xs) ...]
      [(cons? xs) ... (first xs) ... (rest xs) ...]))


; LON -> LON
; Square all numbers in list.
(check-expect (sqr-all empty) empty)
(check-expect (sqr-all (list 2 4 6)) (list 4 16 36))

(define (sqr-all xs)
  (cond
    [(empty? xs) empty]
    [(cons? xs) (cons (sqr (first xs)) (sqr-all (rest xs)))]))


; LON -> Number
; Get the minimum number from a list.
(check-expect (lon-min (list 2 3 1 4)) 1)

(define (lon-min xs)
  (cond
    [(empty? (rest xs)) (first xs)]
    [else (min (first xs) (lon-min (rest xs)))]))

; LON -> Number
; Get the second number in the list.
(check-expect (second (list 2 3)) 3)

#;(define (second xs)
    (first (rest xs)))

; LON -> LON
; Get the differences between adjacent numbers in the list.
(check-expect (diffs (list 2 4 8)) (list 2 4))

(define (diffs xs)
  (cond
    [(<= (length xs) 1) empty]
    [else (cons (- (second xs) (first xs)) (diffs (rest xs)))]))
