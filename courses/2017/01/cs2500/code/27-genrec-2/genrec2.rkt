;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname genrec2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))


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


; The Intermediate Value Theorem
; - If fun is continuous
; - And fun crosses zero in range.
; - Then there's some value in range that is zero.

; We can test crossing zero in interval with:
;  (<= (* (f lo) (f hi)) 0)

; Number Number Number [Number -> Number] -> Number
; Find a zero of the given function.

(define (find-root.slow delta lo hi f)
  (local [(define width (- hi lo))
          (define num-wins (ceiling (/ width delta)))
          (define (mk-win i) ; A window is represented by its left edge.
            (+ lo (* i delta)))
          (define intervals  (build-list num-wins mk-win))
          (define (good win)
	    (<= (* (f win) (f (+ win delta))) 0))]
    ;; Why is the "first" justified in the following line:
    (first (filter good intervals)))) ;; mathematics
; No recursion. Filter was structural.


(define (find-root delta lo hi f)
   (cond [(<= (- hi lo) delta) lo]	; Search window [lo,hi] is tight enough.
         [else (local ((define mid (/ (+ lo hi) 2))
                       (define f@mid (f mid))
                       (define f@lo (f lo))
                       (define f@hi (f hi)))
                 (cond [(<= (* f@lo f@mid) 0)		; [lo,mid] has a zero,
			(find-root delta lo mid f)]    	;   so search there.
		       [else				; [mid,hi] has a zero,
			(find-root delta mid hi f)]))]));   so search there.
; Generative recursion:
; Why does it terminate?








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
; Gen Rec: Why does it terminate?


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




