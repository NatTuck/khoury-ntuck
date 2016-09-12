.globl main

.text

main:
	# return addr is  0($sp)
	# input string to 4($sp)
	
	# xs  is $t0
	# len is $t1
	
	subi $sp, $sp, 100
	sw $ra, 0($sp)
	
	la $t0, 4($sp) # xs = string address

	move $a0, $t0
	li $a1, 20
	li $v0, 8
	syscall
	
	jal bsum
	move $t1, $v0
	
	move $a0, $t1
	li $v0, 1
	syscall
	
	lw $ra, 0($sp)
	addi $sp, $sp, 100
	
	# exit
	li $v0, 10
	syscall

bsum:
	# strlen(xs)
	#  xs  is $t0
	#  x   is $t1, 4($sp)
	#  sum is $t2
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	move $t0, $a0

	li $t2, 0
loop:
	# x = *xs
	lb $t1, 0($t0)

	add $t2, $t2, $t1
			
	# unless x != 0
	addi $t0, $t0, 1
	bne $t1, $zero, loop

	move $v0, $t2
				
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
