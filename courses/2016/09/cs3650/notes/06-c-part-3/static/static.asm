.globl main

.data
.align 6
foo:
.word 10, 20, 30, 40
.align 6
bar: 
.space 20
.align 6
eol:
.asciiz "\n"

.text
main:
	la $t0, foo
	
	lw $a0, 0($t0)
	jal pi
	
	lw $a0, 8($t0)
	jal pi
	
	la $a0, foo
	jal pi
	
	la $a0, bar
	jal pi
	
	la $t0, foo
	la $t1, bar
	sub $a0, $t1, $t0
	jal pi
	
	jal exit
	
endl:
	li $v0, 4
	la $a0, eol
	syscall
	jr $ra

pi:
	li $v0, 1
	syscall
	j endl

ps:
	li $v0, 4
	syscall
	j endl

exit:
	li $v0 10
	syscall