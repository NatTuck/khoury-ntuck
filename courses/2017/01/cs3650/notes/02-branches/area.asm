# Register conventions:
#  $a0 - $a3 : Function arguments 
#  $v0       : Function return value; syscall number
#  $t0 - $t9 : User variables
#  $s0 - $s7 : More user variables

.globl main

.data
	msg: .asciiz "Area is: "
	eol: .asciiz "\n"

.text
main:
	# $t0 is side
	# $t1 is area
	li $t0, 4 	# int side = 4

	move $a0, $t0   # int area = square_area(side)
	move $s0, $ra
      	jal square_area   
      	move $ra, $s0
      	move $t1, $v0
      	
      	la $a0, msg    # print "Area is: " 
      	li $v0, 4
      	syscall
      	
      	li $v0, 1      # print area
      	move $a0, $t1
      	syscall
      	
      	la $a0, eol	# print "\n"
      	li $v0, 4
      	syscall
      	
      	li $a0, 0
      	li $v0, 10     # exit
	syscall

square_area:
	# $t0 is xx
	# $t1 is yy
	move $t0, $a0 # Argument xx
	
	mult $t0, $t0 # yy = xx * xx
	mflo $t1
	
	move $v0, $t1 # return yy
	jr $ra