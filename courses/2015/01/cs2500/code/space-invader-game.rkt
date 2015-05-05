;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname space-invader-game) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
(require 2htdp/image)
(require 2htdp/universe)

; Space Invader Game
;
; The player controls a tank, which must defend the world from
; alien spaceships that are trying to land. The tank can
; shoot a laser straight up. If the laser hits the alien, it is
; destroyed and the player gets 1 point. If the alien spaceship
; reaches the ground, the player loses.

; Constants
(define WSIZE 600)
(define BG (empty-scene WSIZE WSIZE))

(define TANK (rectangle 30 10 "solid" "black"))
(define TANK-Y 590)
(define TANK-START (/ WSIZE 2))
(define TANK-SPEED 10)

(define LASER (rectangle 5 15 "solid" "red"))
(define LASER-SPEED 10)
(define NEAR 40)

(define ALIEN (circle 20 "solid" "green"))
(define ALIEN-SPEED-DOWN 2)
(define ALIEN-SPEED-ACROSS 5)
(define ALIEN-START (make-posn 300 10))

(define SCORE-SIZE 20)
(define SCORE-X 550)
(define SCORE-Y 50)

; World State
(define-struct game [tank-x laser alienp score])
; A Game is a structure (make-game Posn Number Number Boolean Number)
; interpretation:
;  + The alien's position
;  - The tank's x position
;  - The laser's state
;  + The player's score

; Wish List
;  [ Basics ]
;  - to-draw function (Game -> Image)
;  - on-tick function: Move the laser (+ and alien).
;  - on-key function: Move the tank or fire the laser.
;  + stop-when function: End game if player loses.
;  [ Other Stuff ]
;  - Draw the alien
;  - Draw the score
;  - Move the alien
;  - Did the laser hit the alien?

; Main Function
; Whatever -> Game
; Launches the game
(define (main _unused)
  (big-bang (make-game TANK-START 'none ALIEN-START 0)
            [to-draw   render-game]
            [on-tick   update-game]
            [on-key    got-key]
            [stop-when game-over?]))

; Game -> Image
; Draws the current frame.
(define (render-game g)
  (draw-score (draw-laser (draw-alien (draw-tank BG g) g) g) g))

; Game -> Game
; Updates the game state on each tick.
(define (update-game g)
  (make-game (game-tank-x g)
             (update-laser g)
             (move-alien g)
             (next-score g)))

; Posn Posn -> Number
; How far apart are two points?
(check-expect (distance (make-posn 0 0) (make-posn 0 10)) 10)
(check-expect (distance (make-posn 10 0) (make-posn 20 0)) 10)

(define (distance p0 p1)
  (sqrt (+ (sqr (- (posn-x p0) (posn-x p1)))
           (sqr (- (posn-y p0) (posn-y p1))))))

; Game -> Bool
; Did the laser hit the alien?
(define (laser-hit-alien? g)
  (cond
    [(posn? (game-laser g)) (< (distance (game-alienp g) (game-laser g)) 
                               NEAR)]
    [else false]))

; Posn Number Number -> Posn
; Move a Posn
(check-expect (posn+ (make-posn 5 5) 0 10)
              (make-posn 5 15))
(check-expect (posn+ (make-posn 595 595) 10 -10)
              (make-posn 5 585))

(define (posn+ p dx dy)
  (make-posn (modulo (+ (posn-x p) dx) WSIZE)
             (modulo (+ (posn-y p) dy) WSIZE)))

; Game -> Posn
; Move the alien
(define (move-alien g)
  (cond 
    [(laser-hit-alien? g) ALIEN-START]
    [else (posn+ (game-alienp g) 
                 ALIEN-SPEED-ACROSS ALIEN-SPEED-DOWN)]))

; Game -> Laser
; Update the state of the laser.
(define (update-laser g)
  (cond
    [(symbol? (game-laser g)) (game-laser g)]
    [(posn? (game-laser g)) (move-laser (game-laser g))]))

; Posn -> Laser
; Move the laser.
(define (move-laser las)
  (cond
    [(< (posn-y las) 0) 'none]
    [else (make-posn (posn-x las) (- (posn-y las) LASER-SPEED))]))

; Game -> Number
; Update the score if we hit the alien.
(define (next-score g)
  (cond
    [(laser-hit-alien? g) (+ 1 (game-score g))]
    [else (game-score g)]))

; Game KeyEvent -> Game
; Updates the game state on key press.
(define (got-key g ke)
  (cond
    [(string=? ke "left") (move-tank g (- TANK-SPEED))]
    [(string=? ke "right") (move-tank g TANK-SPEED)]
    [(string=? ke " ") (fire-laser g)]
    [else g]))

; Number Number Number -> Number
; Clamp a number between two other numbers.
(define (clamp x lo hi)
  (cond
    [(< x lo) lo]
    [(> x hi) hi]
    [else x]))
  
; Game -> Game
; Move the tank.
(define (move-tank g dx)
  (make-game 
    (clamp (+ (game-tank-x g) dx) 0 WSIZE)
    (game-laser g)
    (game-alienp g)
    (game-score g)))

; Game -> Game
; Fire the laser
(define (fire-laser g)
  (make-game
     (game-tank-x g)
     (make-posn (game-tank-x g) TANK-Y)
     (game-alienp g)
     (game-score g)))

; Game -> Bool
; End the game if the alien has reached the ground.
(check-expect (game-over? (make-game 0 0 (make-posn 300 300) 0)) false)
(check-expect (game-over? (make-game 0 0 (make-posn 300 600) 0)) true)

(define (game-over? g)
  (> (posn-y (game-alienp g)) TANK-Y))

; Image Game -> Image
; Add the alien to the scene.
(check-expect (draw-alien BG (make-game 10 'none (make-posn 300 300) 0))
              (place-image ALIEN 300 300 BG))

(define (draw-alien img g)
  (place-image ALIEN 
               (posn-x (game-alienp g))
               (posn-y (game-alienp g))
               img))

; Image Game -> Image
; Add the tank to the scene.
(check-expect (draw-tank BG (make-game 50 'none (make-posn 0 0) 0))
              (place-image TANK 50 TANK-Y BG))

(define (draw-tank img g)
  (place-image TANK
               (game-tank-x g)
               TANK-Y
               img))

; Image Game -> Image
; Add the laser to the scene.
(check-expect (draw-laser BG (make-game 50 'none (make-posn 0 0) 0)) BG)
(check-expect (draw-laser BG (make-game 50 (make-posn 100 100) (make-posn 0 0) 0))
              (place-image LASER 100 100 BG))

(define (draw-laser img g)
  (cond
    [(symbol? (game-laser g)) img]
    [(posn? (game-laser g)) 
       (place-image LASER
                    (posn-x (game-laser g))
                    (posn-y (game-laser g))
                    img)]))

; Image Game -> Game
; Add the score to the scene.
(check-expect (draw-score BG (make-game 0 'none (make-posn 0 0) 20)) 
              (place-image (text "20" SCORE-SIZE "black") SCORE-X SCORE-Y BG))

(define (draw-score img g)
  (place-image (text (number->string (game-score g)) SCORE-SIZE "black")
               SCORE-X SCORE-Y img))


