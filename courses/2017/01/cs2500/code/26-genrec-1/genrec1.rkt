;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname genrec1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

; - Exam 2 is in one week.
; - Everything we cover by next Monday is fair game on the exam.

(define NUMS
  (build-list 10 (lambda (_x) (random 20))))

; [List-of Number] -> [List-of Number]
; Sort the list.
(check-expect (isort '(1 3 2)) '(1 2 3))

(define (isort xs)
  (cond [(empty? xs) empty]
	[else        (insert (first xs)
			     (isort (rest xs)))]))

; Number [List-of Number] -> [List-of Number]
; Put number into sorted list in the right spot.

(check-expect (insert 4 (list 1 5 7)) (list 1 4 5 7))

(define (insert n xs)
   (cond [(empty? xs) (list n)]
	 [else (if (< n (first xs))
		   (cons n xs)
		   (cons (first xs) (insert n (rest xs))))]))

; Draw insertion sort on the board with nums.
; Draw quicksort on the board with nums.
; Point out that quicksort is probably faster.

(define (sort.v2 xs)
  (cond [(empty? xs) empty]
	[else (local [(define pivot (first xs))
		      (define smalls (filter (lambda (x) (<= x pivot)) xs))
		      (define bigs   (filter (lambda (x) (>  x pivot)) xs))]
		(append (sort.v2 smalls)
			(sort.v2 bigs)))]))

(define (sort.v3 xs)
  (cond [(empty? xs) empty]
	[else (local [(define pivot (first xs))
		      (define smalls (filter (lambda (x) (< x pivot)) xs))
		      (define sames  (filter (lambda (x) (= x pivot)) xs))
		      (define bigs   (filter (lambda (x) (>  x pivot)) xs))]
	        (append (sort.v3 smalls)
			(sort.v3 sames) ; C'mon -- don't recurse!
			(sort.v3 bigs)))]))

; That's not the list template.

; New thing: Generative Recursion
; Steps:
;  - Signature / Purpose
;  - Tests
;  - Strategy: How are we going to compute the result?
;    - Base case: When do we stop the recursion?
;    - General case: What do we do when we're not done?
;    - This may require a "leap of insight".
;  - New: Why does this terminate.
;    - Provide an explicit argument showing that each time
;      you apply the general case branch you get one step
;      closer to the base case.

; With isort, we know it terminates because it follows the
; list template. All code that follows the template terminates,
; (if we assume data is finite size): the template will never
; visit a part of the data twice.

; Quicksort:
;  - Base case: An empty list is sorted:
;  - General case: Split around a pivot, sort the two halves, append.
;  - Note that we're not even recursing on part of the list. We're
;    generating two new lists to recurse on.

; The general strategy in Quicksort is called "divide and conquor".
; The plan:
;  - Split the input into two parts.
;  - Solve the parts.
;  - Combine the parts to build the result.


;; --------------------------------------------------------
;; PROBLEM: n^m
;; Integer exponentiation

; Integer Integer -> Integer
; Raise n^m

; Follows the NN template.
; Structural recursion on naturals.
(check-expect (pow.slow 2 6) 64)

(define (pow.slow n m)
  (cond [(zero? m) 1]
        [else (* n (pow.slow n (- m 1)))]))

; Doesn't follow the NN template.
; Divide and conquor on naturals.
(check-expect (pow.fast 2 6) 64)

(define (pow.fast n m)
  (cond [(zero? m) 1]
	[(even? m) (pow.fast (* n n)
			     (/ m 2))]
	[else      (* n (pow.fast (* n n)
				  (/ (- m 1) 2)))]))

;(time (modulo (pow.slow 5 100000) 100))
; numbers in milliseconds

; The plan:
;  - n^m = = n * n^(m - 1) 
;  - Notice that m^n = (n^2)^(m / 2) if m even.
;  - Where'd that else come from?

; Why does this terminate?
;  - m always gets smaller, leading us towards the base case
;  - neither dividing by two nor subtracting 1 can skip zero

; Number [List-of Number] -> [List-of Number]
; Take the first n items from the list.
(check-expect (take 3 '(1 2 3 4 5)) '(1 2 3))

(define (take n xs)
  (cond [(or (empty? xs)(zero? n))
         empty]
        [else (cons (first xs)
                    (take (sub1 n) (rest xs)))]))


; Number [List-of Number] -> [List-of Number]
; Drop the first n items from the list.
(check-expect (drop 3 '(1 2 3 4 5)) '(4 5))

(define (drop n xs)
  (cond [(or (empty? xs) (zero? n))
         xs]
        [else (drop (sub1 n) (rest xs))]))


; [List-of Number] -> [List-of Number]
; Sort a list of numbers.
;(check-expect (msort NUMS) (sort NUMS <))

(define (msort xs)
  (cond [(empty? xs) xs]
        [(empty? (rest xs)) xs]
        [else
         (local ((define half  (/ (length xs) 2))
                 (define part0 (take half xs))
                 (define part1 (drop half xs)))
           (merge (msort part0) (msort part1)))]))


; [List-of Number] [List-of Number] -> [List-of Number]
; Merge two sorted lists into a sorted list.

(define (merge xs ys)
  (cond [(empty? xs) ys]
        [(empty? ys) xs]
        [else (if (< (first xs) (first ys))
                  (cons (first xs)
                        (merge (rest xs) ys))
                  (cons (first ys)
                        (merge xs (rest ys))))]))



