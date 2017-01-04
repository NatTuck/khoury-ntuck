.globl main

.data
nums: .word 2, 4, 6, 8
eol:  .asciiz "\n"

.text
# main wants to be first in mars
main:                   	# int main(...)
	la $a0, nums    	# pa(nums, 4)
	li $a1, 4
	jal pa
	
	li $v0, 10      	# return 0
	syscall

pi:                    		# void pi(xx) {
	li $v0, 1       	# print xx
	syscall
	
	li $v0, 4      		# print "\n"
	la $a0, eol
	syscall
	
	jr $ra         		# }

pa:                   		# void pa(xx, nn) {
	subi $sp, $sp, 40
	sw $ra, 0($sp)
	sw $t0, 4($sp)   # xs
	sw $t1, 8($sp)   # nn
	sw $t2, 12($sp)  # ii
	sw $t3, 16($sp)  # 4*ii
	sw $t4, 20($sp)  # (xs + 4*ii)
	move $t0, $a0
	move $t1, $a1
	
	li $t2, 0		# for (ii = 0;
pa_loop:
	beq $t2, $t1, pa_done	# ii != nn
	sll $t3, $t2, 2		
	addu $t4, $t0, $t3	
	lw $a0, ($t4)		# *(xs + ii)
	jal pi			# pi(...)
	addi $t2, $t2, 1	# ; ++ii)
	j pa_loop		# }

pa_done:
	lw $ra, 0($sp)
	lw $t0, 4($sp)   # xs
	lw $t1, 8($sp)   # nn
	lw $t2, 12($sp)  # ii
	lw $t3, 16($sp)  # 4*ii
	lw $t4, 20($sp)  # (xs + 4*ii)
	addi $sp, $sp, 40
	jr $ra

