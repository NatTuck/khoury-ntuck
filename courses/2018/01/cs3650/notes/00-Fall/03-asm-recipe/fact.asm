.globl main

.text
main:
	li $v0, 5 	# read int
	syscall
	move $a0, $v0
	
	jal fact
	move $a0, $v0
	
	li $v0, 1	# print int
	syscall
	
	li $v0, 10	# exit(0)
	syscall


fact:
	# fact(x):
	#    if x == 1:
	#       return 1
	#    else:
	#    	a = fact(x - 1)
	#       return x * a
	# $t0 is x
	# $t1 is a

	subi $sp, $sp, 20
	sw $ra, 0($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	
	move $t0, $a0
	li $t1, 1
	bne $t0, $t1, fact_else
	
	# x == 1
	li $v0, 1
	j fact_return
	
fact_else:
	# x != 1
	subi $a0, $t0, 1
	jal fact
	move $t1, $v0
	
	mult $t0, $t1
	mflo $v0	

fact_return:
	lw $t1, 8($sp)
	lw $t0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 20
	jr $ra
