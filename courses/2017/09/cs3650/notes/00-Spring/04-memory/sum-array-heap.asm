.globl main

.data
count_prompt: .asciiz "Array size? "
item_prompt:  .asciiz "Enter number: "
sum_text:     .asciiz "sum = "

# Note: This program breaks on n = 0

.text
main:
	# x is $t0
	# ii is $t1
	# n is $t2
	# tmp is $t3
	# 4 is $t4 (size of word)
	# sum is $t5
	# xs is $t6

	li $v0, 4
	la $a0, count_prompt
	syscall
		
	# read n
	li $v0, 5
	syscall
	move $t2, $v0

	# allocate n words on heap
	li $t4, 4
	mul $t3, $t2, $t4
	
	li $v0, 9
	move $a0, $t3
	syscall 
	move $t6, $v0
	
	li $t1, 0
input_loop:
	li $v0, 4
	la $a0, item_prompt
	syscall
	
	# read item
	li $v0, 5
	syscall
	move $t0, $v0
	
	# calculate address of $sp + 4 * ii
	mul $t3, $t1, $t4
	add $t3, $t6, $t3
	
	# xs[ii] = x
	sw $t0, 0($t3)
	
	addi $t1, $t1, 1
	blt $t1, $t2, input_loop

	li $t1, 0
	li $t5, 0
sum_loop:
	# calculate address of $sp + 4 * ii
	mul $t3, $t1, $t4
	add $t3, $t6, $t3
	
	lw $t0, 0($t3)
	add $t5, $t5, $t0
	
	addi $t1, $t1, 1
	blt $t1, $t2, sum_loop

	# output sum
	li $v0, 4
	la $a0, sum_text
	syscall
	
	li $v0, 1
	move $a0, $t5
	syscall
	
	li $v0, 10
	syscall
