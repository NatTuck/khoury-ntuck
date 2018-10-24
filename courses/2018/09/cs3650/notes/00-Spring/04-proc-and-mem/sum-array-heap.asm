.globl main

.data
count_prompt: .asciiz "Array size? "
item_prompt:  .asciiz "Enter number: "
sum_text:     .asciiz "sum = "

# Note: This program breaks on n = 0

.text
main:
	# x is $s0
	# ii is $s1
	# n is $s2
	# tmp is $s3
	# 4 is $s4 (size of word)
	# sum is $s5
	# xs is $s6

	li $v0, 4
	la $a0, count_prompt
	syscall

	# read n
	li $v0, 5
	syscall
	move $s2, $v0

	# allocate n words on heap
	li $s4, 4
	mul $s3, $s2, $s4

	li $v0, 9
	move $a0, $s3
	syscall
	move $s6, $v0

	li $s1, 0
input_loop:
	li $v0, 4
	la $a0, item_prompt
	syscall

	# read item
	li $v0, 5
	syscall
	move $s0, $v0

	# calculate address of $sp + 4 * ii
	mul $s3, $s1, $s4
	add $s3, $s6, $s3

	# xs[ii] = x
	sw $s0, 0($s3)

	addi $s1, $s1, 1
	blt $s1, $s2, input_loop

	li $s1, 0
	li $s5, 0
sum_loop:
	# calculate address of $sp + 4 * ii
	mul $s3, $s1, $s4
	add $s3, $s6, $s3

	lw $s0, 0($s3)
	add $s5, $s5, $s0

	addi $s1, $s1, 1
	blt $s1, $s2, sum_loop

	# output sum
	li $v0, 4
	la $a0, sum_text
	syscall

	li $v0, 1
	move $a0, $s5
	syscall

	li $v0, 10
	syscall
