.globl main

.data
is_bigger:  .asciiz "X is bigger than 10"
not_bigger: .asciiz "X not bigger than 10"

.text
main:
	# $s0 is x
	# $s1 is n

	li $v0, 5	# x = read_int
	syscall
	move $s0, $v0

	li $s1, 10
	bgt $s0, $s1, x_is_big   # if x > 10

	# else
	la $a0, not_bigger    # print
	li $v0, 4
	syscall

	j done

x_is_big:
	# then
	la $a0, is_bigger    # print
	li $v0, 4
	syscall

done:
	li $v0, 10	# exit(0)
	move $a0, $zero
	syscall
