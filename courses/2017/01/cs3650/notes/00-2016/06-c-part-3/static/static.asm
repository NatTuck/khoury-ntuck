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
	
	la $a0, foo
	li $a1, 4
	jal pa 
	
	jal exit
	
endl:
	li $v0, 4
	la $a0, eol
	syscall
	jr $ra

pa:
	subi $sp, $sp, 20
	sw $ra, 0($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	move $t1, $a0
	move $t2, $a1
	
	li $t0, 0
again:
	beq $t0, $t2, done
	sll $t3, $t0, 2
	add $t3, $t3, $t1
	lw $a0, 0($t3)
	jal pi
	addi $t0, $t0, 1	
	j again

done:
	lw $ra, 0($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $t3, 16($sp)	
	addi $sp, $sp, 20
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
