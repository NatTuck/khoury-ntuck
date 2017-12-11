# Register conventions:
#  $a0 - $a3 : Function arguments 
#  $v0       : Function return value; syscall number
#  $t0 - $t9 : User variables - caller-save
#  $s0 - $s7 : More user variables - callee-save

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
      	# complications: 
      	#  - we just lost $ra
      	#    on a real system, we would normally
      	#    return from main
      	#  - we just lost $s0, by convention
      	#    if we wanted it, we needed to save it 
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
