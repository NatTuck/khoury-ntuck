.globl main

.text
main:
	li $v0, 5       # Read Int
	syscall
	move $t0, $v0

	#li $t0, 5
	#li $t1, 1
	#add $t2, $t0, $t1
	addi $t2, $t0, 1
	
	li $v0, 1       # Print Int
  	move $a0, $t2
   	syscall
      	
   	li $v0, 10      # Exit, success
   	move $a0, $zero
   	syscall
