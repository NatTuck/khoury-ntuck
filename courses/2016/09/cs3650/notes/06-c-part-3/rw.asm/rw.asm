.globl main

.data
text:
.space 80
temp:
.space 80

.text
main:








copy_word:
	addi $sp, $sp, 40
	sw $ra, 0($sp)
	sw $t0, 4($sp)  
	sw $t1, 8($sp)   
	
	li $t0, 0
	
loop:
	lw 	
	beq 
	
	lw $t1, 8($sp)
	lw $t0, 4($sp)
	lw $ra, 0($sp)
	subi $sp, $sp, 40
	jr $ra