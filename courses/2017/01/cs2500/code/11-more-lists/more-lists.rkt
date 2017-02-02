;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname more-lists) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; A Truck is (make-truck String String Number)
(define-struct truck [make model year])

#;
(define (truck-tmpl t)
  (... (truck-make t) ...
       (truck-model t) ...
       (truck-year t)...))



; A LoT (List of Trucks) is one of:
;  - empty
;  - (cons Truck LoT)

#;
(define (lot-tmpl ts)
  (cond [(empty? ts) ...]
        [(cons? ts) ... (truck-tmpl (first ts)) ...
                    ... (lot-tmpl (rest ts)) ...]))

(define TRUCKS
  (cons (make-truck "Toyota" "Tacoma" 2007)
        (cons (make-truck "Ford" "F150" 2014)
              (cons (make-truck "Toyota" "Tundra" 2009)
                    (cons (make-truck "Ford" "F150" 2008) empty)))))

; Design a function that finds all trucks of a given make in a list of trucks.

; LoT String -> LoT
; Find all trucks of a given make.

(check-expect (find-by-make TRUCKS "Toyota")
              (cons (make-truck "Toyota" "Tacoma" 2007)
                    (cons (make-truck "Toyota" "Tundra" 2009) empty)))
(check-expect (find-by-make TRUCKS "Honda") empty)

(define (find-by-make ts make)
  (cond [(empty? ts) empty]
        [(cons? ts) (if (match-make? (first ts) make)
                        (cons (first ts) (find-by-make (rest ts) make))
                        (find-by-make (rest ts) make))]))



; Truck String -> Boolean
; Is the truck of the given make?

(check-expect (match-make? (make-truck "Toyota" "Tacoma" 2008) "Toyota") true)
(check-expect (match-make? (make-truck "Toyota" "Tacoma" 2008) "Ford") false)

(define (match-make? t make)
  (string=? (truck-make t) make))




; A ShapeName is one of:
;  - 'circle
;  - 'square
;  - 'triangle

#;
(define (sname-tmpl sn)
  (cond [(symbol=? sn 'circle) ...]
        [(symbol=? sn 'square) ...]
        [(symbol=? sn 'triangle) ...]))



; A Shape is (make-shape ShapeName Number Number Number)
(define-struct shape [name size x y])

#;
(define (shape-tmpl sh)
  (... (sname-tmpl (shape-name sh)) ...
       (shape-size sh) ...
       (shape-x sh) ...
       (shape-y sh) ...))


; A LoSh (List of Shapes) is one of:
;  - empty
;  - (cons Shape LoSh)


; Design a function that will draw a list of shapes on a 600x600 scene.











