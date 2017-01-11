---
layout: default
---

# cs2500: Programming Basics

## Intro Repeats

 - My website (ccs.neu.edu/home/ntuck)
 - Course website (ccs.neu.edu/course/cs2500)
 - Homework: Course Website, Submit on Blackboard
 - Piazza: Sign up and make sure to check it regularly - annoucements will be made here,
     and participation (good questions / answers) may help your whim grade. Don't post code.
 - Reading:
   - The syllabus on the course site gives the topics for each class.
   - Find the associated sections in HTDP 2e and read them *before* class.
   - Then again after class.
 - Times for both exams are posted. Make sure to let us know if any conflicts
   develop *before* the exams.

## Algorithms

What is 142 + 229?

How do you calculate 142 + 229?

How do you teach a computer to add two numbers?

How do you teach a computer to do stuff?

How do you teach a person to teach a computer to do stuff?

## The Basics

Rule 1: Values: Enter a value, get that value back.

Definitions pane: The program you're writing.

Interaction pane: Run single lines of code and see the result.

Kinds of value:
 - Numbers
   - Integers
   - Rational Numbers (e.g. 2/3)
   - Approximate numbers (e.g. pi, sqrt 2)
 - Images
 - Strings
   - Double quote, some stuff, double quote

How do we evaluate a function? 

  f(x) = x + 5
  f(3) = ?

Rule 2: Functions / operations: 

 - Open paren, operation, arguments, close paren
 - Gives the value of applying the function to the arguments.
 - Rule is the same as for math. Plug &amp; Chug

Rule 3: Nesting

 - Evaluate the innermost parens first.
 - For now at least, we can replace any function application with
   its resulting value.

Value definitions:

    (define NUM 5)

Function definitions:

    (define (function x y) 
      (+ x y 1))

## Arithmetic of Numbers

 - We saw some basic arithmetic operations last time.
 - (+ 3 4) - "+" is a function that takes two arguments and gives us the sum.
 - (sqr 5) - "sqr" is a function that takes one argumetn and gives us its square.
 - add1
 - add2?
   - Define our own function
   - Show check expects

## Arithmetic of Images

 - To get an image, we either paste one in or we can build them.
 - (circle 20 "solid" "black") gives us a circle.
 - (circle 40 "outline" "blue") gives us a different circle.
 - (above C1 C2) is a function that combines two images, by sticking them
   together vertically.
 - (overlay C1 C2) sticks them on top of each other.
 - There are a bunch more operations. Right click on "circle" and helpdesk it.
   Scroll around a bit.

 - Add an operation: Donut

    (define (donut color)
      (overlay (circle 20 "solid" "white")
               (circle 40 "solid" color)))

   (define (donut2 size color)
     (overlay (circle (/ size 2) "solid" "white")
              (circle size "solid" "color")))

 - empty-scene
 - place-image

## Arithmetic of Strings

 - New kind of value today: Strings
 - Operations:
   - string-append
   - string-length
   - substring
     - Half open interval, zero indexed. Why?
   - text : String -> Image

## Back to the Rocket

 - Height function ("height from ground in pixels").
   - check-expects
 - Draw function
   - Take height, make image.
   - Demo place-image
   - Demo empty-scene
 - big bang
   - How to draw?   (time -> image)
   - How to get next time? (number -> number)


