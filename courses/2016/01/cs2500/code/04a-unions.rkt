#| ------------------------------------------------------------

    PROBLEM: Design an airline customer system. The system
    represents each customer via a title, first name, and last
    name. Airlines use the following titles: Dr., Mr., Mrs.

    The system should also support a function for writing
    formal letter openers and a function for measuring the 
    number of characters in a customer record.

    Problem 1: Create a data definition for customer records.

    Problem 2: Design a function that produces a letter formal
    opening from a customer record. Remember that a formal
    letter opening is something such as "Dear Dr. Scheme:".

    Problem 3: Design a function that counts the characters in
    a customer record. 
|#

;; We have done this with a first/last/title structure. Let's try
;; a different data definition today...

;; 1:
(define-struct dr (first last))
(define-struct mr (first last))
(define-struct mrs (first last))

;; A customer is one of:
;; -- (make-dr  String String)
;; -- (make-mr  String String)
;; -- (make-mrs String String)

;; 2:
;; contract: formal : Customer -> String
;; purpose: create formal letter opening from customer record

;; examples:
;; (make-dr "Olin" "Shivers") |----> "Dear Dr. Shivers:"
;; (make-mr "Olin" "Shivers") |----> "Dear Mr. Shivers:"
;; (make-mrs "Julia" "Shivers") |----> "Dear Mrs. Shivers:"  

;; We have three cases; each case is a structure.
;; So the template should record this: 
;; three distinctions, then extract values.

(dr? "Dr. Shivers")
(dr? (make-dr "Olin" "Shivers"))
(dr? 10)

(mr? (make-dr "Olin" "Shivers"))
(mr? (make-mr "Olin" "Shivers"))

;; LESSON: every structure definition generates 
;; - a constructor,
;; - some selectors, 
;; - and a PREDICATE (a function whose name ends in ?).

;; template:

#;
(define (template-customer c)
  (cond [(dr? c) ... (dr-first c) ... (dr-last c) ...]
        [(mr? c) ... (mr-first c) ... (mr-last c) ...]
        [(mrs? c) ... (mrs-first c) ... (mrs-last c) ...]))

;; code:

(define (formal-greeting c)
  (cond [(dr? c) (string-append "Dear Dr. " (dr-last c))]
        [(mr? c) (string-append "Dear Mr. " (mr-last c))]
        [(mrs? c) (string-append "Dear Mrs. " (mrs-last c))]))

(check-expect "Dear Mr. Shivers"
          (formal-greeting (make-mr "Olin" "Shivers")))
(check-expect "Dear Dr. Shivers"
          (formal-greeting (make-dr "Olin" "Shivers")))
(check-expect "Dear Mrs. Shivers" 
          (formal-greeting (make-mrs "Julia" "Shivers")))

