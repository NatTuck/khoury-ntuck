
; clojure -cp .
; (require 'demo)
; (time (fib 40))

(defn fib [x]
  (if (< x 2)
    1
    (+ (fib (- x 1))
       (fib (- x 2)))))

(def forties (into [] (repeat 5 40)))

; (time (map fib forties))
; (time (pmap fib forties))



