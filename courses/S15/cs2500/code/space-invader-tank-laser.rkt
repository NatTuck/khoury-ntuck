;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname space-invader-tank-laser) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
(require 2htdp/image)
(require 2htdp/universe)

; Space Invader Game
;
; The player controls a tank, which must defend the world from
; alien spaceships that are trying to land. The tank can
; shoot a laser straight up. If the laser hits the alien, it is
; destroyed and the player gets 1 point. If the alien spaceship
; reaches the ground, the player loses.

; We're going to ignore the alien and score for the moment.

; Constants
(define WSIZE 600)
(define BG (empty-scene WSIZE WSIZE))

(define TANK (rectangle 30 10 "solid" "black"))
(define TANK-Y 590)
(define TANK-SPEED 10)
(define TANK-START (/ WSIZE 2))

(define LASER (rectangle 5 15 "solid" "red"))
(define LASER-SPEED 10)

; A Laser is one of:
;  - (make-posn Number Number)
;  - 'none
; The value 'none is used if no laser has been fired.
#;(define (laser-tmpl las)
    (cond
      [(posn? las) ... (posn-x las) ... (posn-y las) ...]
      [(symbol? las) ... las ...]))
  
; World State
(define-struct game [tank-x laser])
; A Game is a structure (make-game Number Laser)
; interpretation: The position of the tank and state of the laser.
#;(define (game-tmpl g)
    (... (game-tank-x g) ... (game-laser g) ...))

; Wish List
;  [ Basics ]
;  - to-draw function (Game -> Image)
;  - on-tick function: Move laser, if any.
;  - on-key function: Move the tank or fire the laser.
;  [ Other Stuff ]
;  - Draw the tank
;  - Draw the laser
;  - Move the laser
;  - Move the tank

; Main Function
; Whatever -> Game
; Launches the game
(define (main _unused)
  (big-bang (make-game TANK-START 'none)
            [to-draw   render-game]
            [on-tick   update-game]
            [on-key    got-key]))
  
; Game -> Image
; Draws the current frame.
(define (render-game g)
  (draw-laser (draw-tank BG g) g))

; Game -> Game
; Updates the game state on each tick.
(define (update-game g)
  (make-game (game-tank-x g) (update-laser g)))

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
(check-expect (clamp 10 0 50) 10)
(check-expect (clamp -5 0 10) 0)
(check-expect (clamp 70 0 50) 50)

(define (clamp x lo hi)
  (cond
    [(< x lo) lo]
    [(> x hi) hi]
    [else x]))
  
; Game -> Game
; Move the tank.
(check-expect (move-tank (make-game 10 'none) 5)
              (make-game 15 'none))

(define (move-tank g dx)
  (make-game 
    (clamp (+ (game-tank-x g) dx) 0 WSIZE)
    (game-laser g)))

; Game -> Game
; Fire the laser
(check-expect (fire-laser (make-game 10 'none))
              (make-game 10 (make-posn 10 TANK-Y)))

(define (fire-laser g)
  (make-game
     (game-tank-x g)
     (make-posn (game-tank-x g) TANK-Y)))

; Image Game -> Image
; Add the tank to the scene.
(check-expect (draw-tank BG (make-game 50 'none))
              (place-image TANK 50 TANK-Y BG))

(define (draw-tank img g)
  (place-image TANK (game-tank-x g) TANK-Y img))

; Image Game -> Image
; Add the laser to the scene.
(check-expect (draw-laser BG (make-game 50 'none)) BG)
(check-expect (draw-laser BG (make-game 50 (make-posn 100 100)))
              (place-image LASER 100 100 BG))

(define (draw-laser img g)
  (cond
    [(symbol? (game-laser g)) img]
    [(posn? (game-laser g)) 
       (place-image LASER
                    (posn-x (game-laser g))
                    (posn-y (game-laser g))
                    img)]))
