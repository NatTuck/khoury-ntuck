;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 06a-snake-default) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define title "The Snake, Moving")

(require 2htdp/image)
(require 2htdp/universe)

;; GOAL: get them to see the connectivity among the data definitions for design.
;; SHOW: the data definitions, the constant definitions 
;; THEN: design the world-image function; time permitting also show world-move 

;;; The whole program is about 100 lines of code, plus tests, blank
;;; lines & comments.

(define-struct world (snake food))
(define-struct snake (dir segs))

;;; SNAKE WORLD 
;;;
;;; World is: (make-world Snake Food)
;;; Food is: Posn
;;; Snake is: (make-snake Direction Segs)
;;;   A snake's Segs may not be empty.
;;;   The first element of the list is the head. [Leave this out & discover it.]
;;; Direction is one of: 'up 'down 'left 'right
;;; Segs is one of:
;;;  -- empty
;;;  -- (cons Posn Segs)
;;; Coordinates are in "grid" units, with X running left-to-right,
;;; and Y running bottom-to-top.

;;; Start with the world, when you make up a wish list, the others will fall
;;; out. This should suggest something like that. 

;;; world->scene : World -> Scene
;;; food+scene   : Food Scene -> Scene 
;;; snake+scene  : Snake Scene -> Scene
;;; world->world : World -> World

;;; snake-slither : Snake -> Snake
;;; snake-change-direction : Snake Direction -> Snake
;;; snake-eat : World -> World
;;; snake-grow : Snake -> Snake
;;; snake-self-collide? : Snake -> Boolean
;;; snake-eating? : World -> Boolean
;;; snake-wall-collide? : Snake -> Boolean

;; Add purpose statements. Then pick a place and start. 

;; --- CONSTANTS : DESCRIBE PROPERTIES THAT ARE ALWAYS THE SAME 

(define GRID-SIZE 30) ; width of a game-board square
(define BOARD-HEIGHT 20) ; height in grid squares
(define BOARD-WIDTH  30) ; width  in grid squares
(define BOARD-HEIGHT-PIXELS (* GRID-SIZE BOARD-HEIGHT))
(define BOARD-WIDTH-PIXELS  (* GRID-SIZE BOARD-WIDTH))

(define BACKGROUND (empty-scene BOARD-WIDTH-PIXELS BOARD-HEIGHT-PIXELS))

(define SEGMENT-RADIUS (quotient GRID-SIZE 2))
(define SEGMENT-IMAGE  (circle SEGMENT-RADIUS 'solid 'red))
(define FOOD-RADIUS (floor (* 0.9 SEGMENT-RADIUS)))
(define FOOD-IMAGE  (circle FOOD-RADIUS 'solid 'green))

(define Snake1 (make-snake 'right (cons (make-posn 5 3) empty)))
(define Food1  (make-posn 8 12))
(define World1 (make-world Snake1 Food1))
(define World2 (make-world Snake1 (make-posn 5 3))) ; An eating scenario

;; --- FUNCTIONS 

;;; Image-painting functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; world->scene : World -> Scene
;;; Build an image of the given world.
(define (world->scene w)
  (snake+scene (world-snake w)
	       (food+scene (world-food w)
			   BACKGROUND)))

;;; food+scene : Food Scene -> Scene 
;;; Add image of food to the given scene.
(define (food+scene f scn)
  (place-image-on-grid FOOD-IMAGE (posn-x f) (posn-y f) scn))

;;; place-image-on-grid Image Number Number Scene
;;; Just like PLACE-IMAGE, but use grid coordinates.
(define (place-image-on-grid img x y scn)
  (place-image img
               (* GRID-SIZE x)
               (- BOARD-HEIGHT-PIXELS (* GRID-SIZE y))
               scn))

;;; snake+scene : Snake Scene -> Scene 
;;; Add an image of the snake to the scene.
(define (snake+scene snk scn)
  (segments+scene (snake-segs snk) scn))

;;; segments+scene : Segments Scene -> Scene 
;;; Add an image of the snake segments to the scene.
(define (segments+scene segs scn)
  (cond [(empty? segs) scn]
	[else (segment+scene (first segs)
			     (segments+scene (rest segs) scn))]))

;;; segment+scene : Posn Scene -> Scene
;;; Add one snake segment to a scene.
(define (segment+scene seg scn)
  (place-image-on-grid SEGMENT-IMAGE (posn-x seg) (posn-y seg) scn))

;;; Examples/tests: Scene-painting functions
;;; They are broken tests & need to be fixed.

#|
(check-expect (segments+scene empty BACKGROUND) BACKGROUND)
(check-expect (segments+scene (snake-segs Snake1) BACKGROUND)
              (place-image SEGMENT-IMAGE 50 170 BACKGROUND))

(check-expect (snake+scene Snake1 BACKGROUND)
              (place-image SEGMENT-IMAGE 50 170 BACKGROUND))

(check-expect (world->scene World1)
              (place-image FOOD-IMAGE 80 80
                           (place-image SEGMENT-IMAGE 50 170 BACKGROUND)))
|#

;;; Snake motion & growth
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; snake-slither : Snake -> Snake 
;;; Move the snake by one step in the appropriate direction.
;;; How: new head is old head moved 1 step; 
;;;      new tail is all the old segs but last.
(define (snake-slither s)
  (make-snake (snake-dir s)
	      (segments-move (snake-segs s)
			     (snake-dir s))))

;;; segments-move : Segs Direction -> Segs 
;;; Slither the list of segments one unit in the given direction.
;;; How: new head is old head moved 1 step; 
;;;      new tail is all the old segs but last.
(define (segments-move segs dir)
  (cons (move-posn (first segs) dir)	; New head: move old head 1 step.
	(segments-all-but-last segs)))	; New tail: all segs minus last one.

;;; NESegs -> NESegs
;;; Remove the last segment from a NON-EMPTY list.
;;; A NESegs (non-empty list of segments) is one of:
;;; - (cons Posn empty)
;;; - (cons Posn NESegs)

(define (segments-all-but-last seg)
  (cond [(empty? (rest seg)) empty]
        [else (cons (first seg)
		    (segments-all-but-last (rest seg)))]))

;;; Posn Direction -> Posn 
;;; Move posn one step in given direction.
(define (move-posn p dir)
  (cond [(symbol=? 'up    dir)	 (make-posn (posn-x p) (+ (posn-y p) 1))]
	[(symbol=? 'down  dir)	 (make-posn (posn-x p) (- (posn-y p) 1))]
	[(symbol=? 'left  dir)	 (make-posn (- (posn-x p) 1) (posn-y p))]
	[(symbol=? 'right dir)	 (make-posn (+ (posn-x p) 1) (posn-y p))]))

;;; snake-grow : Snake -> Snake
;;; Grow snake one step.
;;; This is just like SNAKE-SLITHER, but we don't drop the last segment.
(define (snake-grow s)
  (make-snake (snake-dir s)
	      (cons (move-posn (first (snake-segs s))	; Add new head
			       (snake-dir s))
		    (snake-segs s))))			; to entire snake.

;;; eat&grow : World -> World
;;; Eat the current food and grow the snake one segment.
;;; The new world has food at some random coordinate.

(define (eat&grow w)
  (make-world (snake-grow (world-snake w))
	      (make-posn (random BOARD-WIDTH)
			 (random BOARD-HEIGHT))))

;;; Examples/tests: Snake motion & growth
(check-expect (move-posn (make-posn 10 10) 'up)
	      (make-posn 10 11))

(check-expect (segments-all-but-last (snake-segs Snake1)) empty)
(check-expect (segments-all-but-last (cons (make-posn 10 20)
					   (cons (make-posn 10 21) empty)))
	      (cons (make-posn 10 20) empty))

(check-expect (move-posn (make-posn 10 20) 'up)
	      (make-posn 10 21))

(check-expect (snake-slither Snake1)
	      (make-snake 'right (cons (make-posn 6 3) empty)))

(check-expect (snake-grow Snake1)
	      (make-snake 'right (cons (make-posn 6 3)
				       (cons (make-posn 5 3) empty))))

;;; Just check the new world's snake -- we can't test the new food, 
;;; since it's randomly placed.
(check-expect (world-snake (eat&grow World2))
	      (make-snake 'right (cons (make-posn 6 3)
				       (cons (make-posn 5 3) empty))))


;;; Collisions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; posn=? : Posn Posn -> Bool
;;; Compare two posns.

(define (posn=? p1 p2)
  (and (= (posn-x p1) (posn-x p2))
       (= (posn-y p1) (posn-y p2))))

;;; segs-collide? : Posn Segs -> Bool
;;; Does posn HEAD collide with any posns in the list SEGS?
(define (segs-collide?-version1 head segs)
  (cond [(empty? segs) false]
	[(posn=? head (car segs)) true]
	[else (segs-collide? head (rest segs))]))

(define (segs-collide? head segs)
  (and (not (empty? segs))
       (or (posn=? head (car segs))
	   (segs-collide? head (rest segs)))))

;;; self-collide? : Snake -> Boolean
;;; Does the snake collide with itself?
(define (self-collide? snake)
  (segs-collide? (first (snake-segs snake))
		 (rest  (snake-segs snake))))

;;; eating? : World -> Boolean
;;; In world W, is the snake's head on the food?
(define (eating? w)
  (posn=? (world-food w)
	  (first (snake-segs (world-snake w)))))

;;; wall-collide? : Posn -> Boolean
;;; Has the snake's head collided with a wall?
(define (wall-collide? head)
  (or (<  (posn-x head) 0)
      (>= (posn-x head) BOARD-WIDTH)
      (<  (posn-y head) 0)
      (>= (posn-y head) BOARD-HEIGHT)))

;;; snake-death? : Snake -> Boolean
;;; Is the snake committing a fatal action (self collision or wall collision)?
(define (snake-death? snake)
  (or (wall-collide? (first (snake-segs snake)))
      (self-collide? snake)))

;;; Examples/tests: Collisions

(check-expect (posn=? (make-posn 10 80) (make-posn 10 80)) true)
(check-expect (posn=? (make-posn 10 80) (make-posn 80 10)) false)
(check-expect (segs-collide? (make-posn 80 50) empty)      false)
(check-expect (segs-collide? (make-posn 80 50)
			     (cons (make-posn 70 50)
				   (cons (make-posn 60 50) empty)))
	      false)
(check-expect (segs-collide? (make-posn 80 50)
			     (cons (make-posn 70 50)
				   (cons (make-posn 80 50) empty)))
	      true)

(check-expect (self-collide? Snake1) false)
(check-expect (self-collide? (make-snake 'up (cons (make-posn 70 50)
						   (cons (make-posn 70 50)
							 empty))))
	      true)

(check-expect (eating? World1) false)
(check-expect (eating? World2) true)

(check-expect (wall-collide? (make-posn 10 10))  false)
(check-expect (wall-collide? (make-posn 10 -10)) true)
(check-expect (wall-collide? (make-posn -10 10)) true)


;;; Movie handlers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; world->world : World -> World
;;; Step the world one tick.
#;
(define (world->world w)	; This version was for early testing.
  (make-world (snake-slither (world-snake w))
	      (world-food w)))

(define (world->world w)	; The real one.
  (cond [(world-done? w) World1]
        [(eating? w) (eat&grow w)]
	[else (make-world (snake-slither (world-snake w))
			  (world-food w))]))
  
;;; key-handler : World Key-Event -> World
;;; Handle things when the user hits a key on the keyboard.

(define (key-handler w ke)
  (cond [(key=? ke "n") World1] ; New game
	[(or (key=? ke "up")
	     (key=? ke "down")
	     (key=? ke "left")
	     (key=? ke "right"))
	 (make-world (make-snake (string->symbol ke)
				 (snake-segs (world-snake w)))
		     (world-food w))]
	[else w]))

;;; Examples/tests: Movie handlers

(check-expect (world->world World1)
	      (make-world (make-snake 'right (cons (make-posn 6 3) empty))
			  Food1))
                    
;;; An eating scenario.
(check-expect (world-snake (world->world World2))
	      (make-snake 'right (cons (make-posn 6 3)
				       (cons (make-posn 5 3) empty))))

(check-expect (key-handler World1 "down")
	      (make-world (make-snake 'down (snake-segs Snake1))
			  (world-food World1)))


;; --- RUN PROGRAM RUN

(define (world-done? w) (snake-death? (world-snake w)))

(define (main w0)
  (big-bang w0
            (to-draw   world->scene)
            (on-tick   world->world 0.3)
            (on-key    key-handler)))