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

  # This is sketchy, where's $a0?
	jal strlen
	move $t1, $v0
	
	move $a0, $t1
	li $v0, 1
	syscall
	
	lw $ra, 0($sp)
	addi $sp, $sp, 100
	
	# exit
	li $v0, 10
	syscall

strlen:
	# strlen(xs)
	#  xs is $s0
	#  x  is $s1
	subi $sp, $sp, 16
	sw $ra, 0($sp)
	move $s0, $a0

	# x = xs[i]
	lb $s1, 0($s0)
	
	# unless x != 0
	bne $s1, $zero, count_byte
	move $v0, $zero
	j return

count_byte:
	addi $a0, $s0, 1
	jal strlen

	addi $v0, $v0, 1
	
return:	
	lw $ra, 0($sp)
	addi $sp, $sp, 16
	jr $ra
