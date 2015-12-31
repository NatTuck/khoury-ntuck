;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname design-recipe-in-class) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; So far:
;  We learned the basics of programming in some concrete programming language.

; Design Recipe for Functions:
;  (Six Steps)
; 1. Describe your data

; Example:
;   A Weight is a Number.
;   interpretation Pounds

; 2. Write down "signature" and "purpose statement.
;    Signature: What types are the input and output?

; Example:
;    fat-cat? : Weight -> Boolean
;    Is this cat overweight?

; 3. Functional examples

; Example:
;    (fat-cat? 3) -> false
;    (fat-cat? 80) -> true

; 4. Template

; Example
;    Template for Weight -> ?
#;(define (weight-tmpl w)
    (... w ...))

; 5. Write code

;    (fat-cat? 3) -> false
;    (fat-cat? 80) -> true
; >= 10 lbs is overweight
(define (fat-cat? w)
    (>= w 10))

; 6. Write tests

(check-expect (fat-cat? 3) false)
(check-expect (fat-cat? 80) true)


; Next example:
; Given the name of a semester, output the numeric starting month.

; == Data Definition ==
; A Semester is one of:
;  - "Fall"
;  - "Spring"
;  - "Summer 1"
;  - "Summer 2"

; A Month is a Number in the range 1..12, inclusive.


; == Signature and Purpose Statement ==
; Semester -> Month
; Given a semester, return the starting month.

; == Examples ==
; (starting-month "Summer 1") -> 5
; (starting-month "Spring") -> 1

; A Semester is one of:
;  - "Fall"
;  - "Spring"
;  - "Summer 1"
;  - "Summer 2"

; == Template ==
; Semester -> ?
#;(define (semester-tmpl s)
    (cond [(string=? "Fall" s) ...]
          [(string=? "Spring" s) ...]
          [(string=? "Summer 1" s) ...]
          [(string=? "Summer 2" s) ...]))

; Semester -> Month
(define (starting-month s)
    (cond [(string=? "Fall" s) 9]
          [(string=? "Spring" s) 1]
          [(string=? "Summer 1" s) 5]
          [(string=? "Summer 2" s) 7]))

(check-expect (starting-month "Summer 1") 5)
(check-expect (starting-month "Spring") 1)
(check-expect (starting-month "Summer 2") 7)
(check-expect (starting-month "Fall") 9)



(define-struct student (name gpa))
; A Student is (make-student String Number)
;  - Name is the student's name - "Last, First"
;  - GPA is the student's GPA, unweighted (0 - 4.0)

; Student -> ?
#;(define (student-tmpl s)
    ( ... (student-name s) ... (student-gpa s) ...))

; passing? : Student -> Boolean
; Is the student passing? (GPA >= 2.0)
; Examples:
;  - (passing? (make-student "Doe, Jane" 1.0) false)
;  - (passing? (make-student "Smith, John" 3) true)
(define (passing? s)
    (>= (student-gpa s) 2.0))

(check-expect (passing? (make-student "Doe, Jane" 1.0)) false)
(check-expect (passing? (make-student "Smith, John" 3)) true)







