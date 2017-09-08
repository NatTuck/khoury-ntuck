.globl main

.data 
is_bigger:  .asciiz "X is bigger than 10"
not_bigger: .asciiz "X not bigger than 10"

.text
main:
	# $t0 is x
	# $t1 is n

	li $v0, 5	# x = read_int
	syscall
	move $t0, $v0

	li $t1, 10
	bgt $t0, $t1, x_is_big   # if x > 10

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
