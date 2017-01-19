.globl main

.data
main:
	# Build up a list.



car:
	# aka first
	# $a0 is the address of the cons cell
	# Can implement with no temporary registers.
	lw $v0, 0($a0)
	jr $ra

cdr:
	# aka rest
	# $a0 is the address of the cons cell
	# Can implement with no temporary registers
	lw $v0, 4($a0)
	jr $ra

cons:
	# (cons a b) -> (a . b)
	# $t0 is number a
	# $t1 is address of another cons, or 0 for nil
	# $t2 is the address of the new cons cell
	subi $sp, $sp, 20
	sw $ra, 0($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	
	move $t0, $a0
	move $t1, $a1
	
	li $v0, 9
	li $a0, 8
	syscall # Allocate 8 bytes = 2 words
	move $t2, $v0
	
	sw $t0, 0($t2)
	sw $t1, 4($t2)
	
	move $v0, $t2
	lw $t2, 12($sp)
	lw $t1, 8($sp)
	lw $t0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 20
	jr $ra

sum:
	# sum(xs):
	#   if empty?(xs):
	#	return 0
	#   else:
	#	return 1 + sum(cdr(xs))
