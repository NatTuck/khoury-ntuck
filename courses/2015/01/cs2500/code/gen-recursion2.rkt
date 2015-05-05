;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname gen-recursion2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;
; Last time on Fundies 1:
; Structural Recursion:
;  - Follow your Templates
;  - You can make templates for multiple complex arguments.

; NN [List-of A] -> [List-of A]
; Take the first n items of the list.
(check-expect (take 2 empty) empty)
(check-expect (take 0 '(1 2 3)) empty)
(check-expect (take 2 '(1 2 3)) '(1 2))

(define (take n xs)
  (cond
    [(or (empty? xs) (zero? n)) empty]
    [else (cons (first xs)
                (take (sub1 n) (rest xs)))]))

; nn [List-of A] -> [List-of A]
; Drop the first n items of the list, take the rest.
(check-expect (drop 2 empty) empty)
(check-expect (drop 0 '(1 2 3)) '(1 2 3))
(check-expect (drop 2 '(1 2 3)) '(3))

(define (drop n xs)
  (cond
    [(empty? xs) empty]
    [(zero? n) xs]
    [else (drop (sub1 n) (rest xs))]))

; Today: Generative Recursion

; Design Recipe:
;  - Data Definition
;  - Signature, Purpose Statement
;  - Examples / Tests

; For Generative Recursion:
;  - What are we doing?
;  - If we can't just recurse on the
;    parts of the structure, what are
;    we going to do instead?
;  - How does that solve the problem?
;  - Give examples / add tests for the
;    various cases.
;  - Strategy Statement
;  - Termination Argument (How does each 
;    recursion get us closer to a solution?)

; Problem:
;   Given a list of single characters,
;   (e.g. '("a" "b" "c" "d"))
;   bundle them into groups of size n.

; [List-of 1String] Number -> [List-of String]
; Bundle the characters into n-sized groups.
(check-expect (bundle (explode "abcdef") 3) '("abc" "def"))
(check-expect (bundle (explode "ab") 3) '("ab"))
(check-expect (bundle (explode "") 3) '())

; How?
; 'take' the first n items of the list, 
;      put them together in one string.
; 'drop' the first n items for the recursion.
; Combine with 'cons'.

; Termination argument:
; Since we drop some of the items in xs before
; we recur, we'll eventually end up with an empty
; list. When we have an empty list we can stop.

(define (bundle xs n)
  (cond
    [(empty? xs) empty]
    [(cons? xs) (cons (concat (take n xs))
                      (bundle (drop n xs) n))]))

; [List-of String] -> String
; Concatenate some strings into one.
(check-expect (concat '()) "")
(check-expect (concat '("a" "b")) "ab")

(define (concat xs)
  (foldr string-append "" xs))


#;(bundle (explode "ab") 0)
; -> (cons (take 0 '("a" "b")) (bundle (take 0 '("a" "b"))
; Problem doesn't get smaller. We run forever, or run out
; of memory.
; Termination argument requires n > 0.
; Might be worth adding [(< n 1) (error "Nope")]

;
; The "template" for generative recursion:
#;(define (generative-recursive-fun problem)
    (cond
      [(trivially-solvable? problem)
       (determine-solution problem)]
      [else
       (combine-solutions
        ... problem ...
        (generative-recursive-fun (generate-problem-1 problem))
        ...
        (generative-recursive-fun (generate-problem-n problem)))]))

; For bundle
;  - The trivial (base) case was (empty? xs)
;  - generate-problem was (drop n xs)
;  - We had to figure out the rest.

; Let's look at merge sort again.

; [List-of Number] -> [List-of Number]
; Sort the list of numbers from least to greatest.
; How?
;  - A list of length 0 or 1 is sorted (base cases).
;  - For longer lists, split them in half and sort
;    recursively.
;  - Combine with 'merge', which maintains sortedness.
; Why does it terminate?
;  - Splitting in half always make smaller problems.
(check-expect (msort empty) empty)
(check-expect (msort '(5)) '(5))
(check-expect (msort '(2 7 3 1)) '(1 2 3 7))

(define (msort xs)
  (cond
    [(empty? xs) xs]
    [(empty? (rest xs)) xs]
    [else (local ((define evens (take-evens xs)) ; Generate
                  (define odds  (take-odds xs))) ; Generate
            (merge (msort evens) (msort odds)))])) ; Combine

; [List-of Number] -> [List-of Number]
; Take the first, third, etc numbers.
(check-expect (take-odds '(1 2 3)) '(1 3))
(check-expect (take-odds empty) empty)

(define (take-odds xs)
  (cond
    [(empty? xs) empty]
    [else (cons (first xs) (take-odds (drop 2 xs)))]))

; This is generative.
;  combine = cons
;  generate = drop 2 

; [List-of Number] -> [List-of Number]
(define (take-evens xs)
  (take-odds (drop 1 xs)))

; [List-of Number] [List-of Number] -> [List-of Number]
; Merge two sorted lists.
(check-expect (merge empty empty) empty)
(check-expect (merge '(1 3) '(2 4)) '(1 2 3 4))
; Two other cases.

(define (merge xs ys)
  (cond
    [(empty? xs) ys]
    [(empty? ys) xs]
    [(< (first xs) (first ys))
     (cons (first xs) (merge (rest xs) ys))]
    [else
     (cons (first ys) (merge xs (rest ys)))]))
            
; This is structural.
; Template is for two lists. 

; Quick sort:
;   Combine = append
;   Generate = Find less than, greater than pivot.

; [List-of Number] -> [List-of Number]
; Sort a list.
; How:
;  - An empty list is sorted (base case).
;  - Otherwise, pick a pivot (the first item).
;  - Split the rest of the list into.
;    - Items less than the pivot.
;    - Items greater than the pivot.
;  - Sort those lists recursively.
;  - Combine by appending(lt, pivot, gt)
; Why does it terminate?
;  - We remove the pivot from the list at each
;    step, so the subproblems are smaller.
(check-expect (qsort empty) empty)
(check-expect (qsort '(5)) '(5))
(check-expect (qsort '(2 7 3 1)) '(1 2 3 7))

(define (qsort xs)
  (if (empty? xs)
      empty
      (local ((define pivot (first xs))
              (define lt (filter (lambda (x) (< x pivot)) (rest xs)))
              (define gt (filter (lambda (x) (>= x pivot)) (rest xs))))
        (append (qsort lt) (list pivot) (qsort gt)))))
