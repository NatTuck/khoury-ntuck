;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname trees) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))


;; Develop the next two on blackboard as well as computer.
;; ---------------------------------------------------------
(define-struct binary (left right))
;; A BTN is one of 
;; -- Number
;; -- (make-binary BTN BTN)

;; Are 
;10 'a "hello world"
;; BTs? 

;; Is
#;(make-binary '30 (make-binary 10 20)) 
;; a BT? 

;; Is 
#;(make-binary '4 (make-binary 10 empty))
;; a BT? 

;; PROBLEM: 
;;    Design a function that checks whether a given
;;    number occurs in a BT.

;; BTN Number -> Boolean 
;; Does x occur in t? 
;; TEMPLATE: ask the questions (see web site)
#;
(define (btn-occurs? t x)
  (cond [(number? t) ...]
        [(binary? t) 
	 ... (btn-occurs? (binary-left t) x) ... 
         ... (btn-occurs? (binary-right t) x) ...]))

(define (btn-occurs? t x)
  (cond [(number? t) (= t x)]
        [(binary? t) (or (btn-occurs? (binary-left t)) 
                         (btn-occurs? (binary-right t)))]))


; Let's do it another way.

(define-struct bt [left value right])
; A [BT-of X] is one of:
;  - 'leaf
;  - (make-bt [BT-of X] X [BT-of X])

; Draw this on the blackboard - compare to the other one.
; Make the template.

; Do bt-occurs for [BT-of Number]
(define (bt-occurs? t x)
  (cond [(symbol? t) false]
        [(bt? t) (or (= (bt-value t) x)
                     (bt-occurs? (bt-left t) x)
                     (bt-occurs? (bt-right t) x))]))


; Do bt-map




;; ---------------------------------------------------------

;; A [Forest-of X] is a [List-of [BT-of X]], so:
;;  ... one of:
;;  - empty
;;  - (cons [BT-of X] [Forest-of X])

;; Show connections among data definitions on blackboard.

;; Is 
;empty 
;; a Forest? 

;; Are 
#;(list 10)
#;(list 20 20)
;; Forests? 

;; How many trees do they contain? 

;; Is
;(list (make-binary 10 10) 10 (make-binary 10 20))
;; a forest? 

;; PROBLEM: 
;;    Design a function that checks whether a number x occurs 
;;    in a given [Forest-of Number]. 

;; forest-occurs? : [Forest-of Number] Number -> Boolean 
;; Does x occur in ft? 
;; TEMPLATE 
#;
(define (forest-occurs? ft x)
  (cond [(empty? ft) ...]
        [else ... (bt-occurs? (first ft)) ...
              ... (forest-occurs? ft x) ...]))

;; Show connections among templates on blackboard.

(define (forest-occurs? ft)
  (cond [(empty? ft) false]
        [else (or (bt-occurs? (first ft))
                  (forest-occurs? (rest ft)))]))

; Now with a loop.

;; Use check syntax to show connections among fun definitions

#|
'testing-forest-occurs?
(equal? (forest-occurs? empty) false)
(equal? (forest-occurs? (list 'b (make-binary 'a 10) "hell"))
        true)
|#
