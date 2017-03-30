
(def n 0)

(defn incn []
   (alter n inc)))

(dorun (dosync (apply pcalls (repeat 10000 incn))))

(println @n)

(shutdown-agents)

