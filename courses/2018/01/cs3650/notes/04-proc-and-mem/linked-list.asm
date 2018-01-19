.globl main

.text
main:
	# Build up a list.

	# Call sum on it.

	li $v0, 10
	syscall

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
	# $s0 is number a
	# $s1 is address of another cons, or 0 for nil
	# $s2 is the address of the new cons cell
	subi $sp, $sp, 20
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)

	move $s0, $a0
	move $s1, $a1

	li $v0, 9
	li $a0, 8
	syscall # Allocate 8 bytes = 2 words
	move $s2, $v0

	sw $s0, 0($s2)
	sw $s1, 4($s2)

	move $v0, $s2
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 20
	jr $ra

sum:
	# sum(xs):
	#   if empty?(xs):
	#	return 0
	#   else:
	#	return 1 + sum(cdr(xs))
