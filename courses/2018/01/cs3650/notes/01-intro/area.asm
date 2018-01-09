# Register conventions:
#  $a0 - $a3 : Function arguments
#  $v0       : Function return value; syscall number
#  $t0 - $t9 : User variables - "temporary"
#  $s0 - $s7 : More user variables - "saved"

.globl main

.data
	msg: .asciiz "Area is: "
	eol: .asciiz "\n"

.text
main:
	# $s0 is side
	# $s1 is area
	li $s0, 4 	# int side = 4

	move $a0, $s0   # int area = square_area(side)
	jal square_area
	move $s1, $v0

	la $a0, msg    # print "Area is: "
	li $v0, 4
	syscall

	li $v0, 1      # print area
	move $a0, $s1
	syscall

	la $a0, eol	# print "\n"
	li $v0, 4
	syscall

	li $a0, 0
	li $v0, 10     # exit
	syscall

square_area:
	# $s0 is xx
	# $s1 is yy
	move $s0, $a0 # Argument xx

	mult $s0, $s0 # yy = xx * xx
	mflo $s1

	move $v0, $s1 # return yy
	jr $ra
