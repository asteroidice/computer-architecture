## Description: This program written using the MIPs instruction set prompts for two values A and B then computes their
## product using booths algorithm.

## Variables
## $t1 - A
## $t2 - B
## $t3 - (-B)
## $t4 - Count (number of shifts)
## $t5 - Misc.
## $t6 - Misc.
## $t7 - Padding bit

.data
	enter1: .asciiz "Enter Number 1\n Valid numbers are 65,536 >= A >= -65,537.\nA = "
	enter2: .asciiz "Enter Number 2\n Valid numbers are 65,536 >= B >= -65,537.\nB = "
	var1: .word 0			#	The value for A
	var2: .word 0			# The value for B
	count: .word 0


	.text

main:
	# setup initial values
	li $t0, 0
	sw $t0, count


	# Prompt and store val 1 in var1
	li $v0, 4
	la $a0, enter1
	syscall
	li $v0, 5          # load code for read_int call in register $v0
	syscall            # read integer
	sw $v0, var1

	# Prompt and store val 2 in var2
	li $v0, 4
	la $a0, enter2
	syscall
	li $v0, 5          # load code for read_int call in register $v0
	syscall            # read integer
	sw $v0, var2

	# Setup A, B, and -b
	lw $t1, var1 					# Load A
	andi $t1, 0x0000FFFF	# Clear the upper 16 bits.
	lw $t2, var2 					# Load B
	andi $t2, 0x0000FFFF

	not $t3, $t2				# invert the bits of B
	addi $t3, $t3, 1		# Add 1

	# Shift B and -B 16 bits to the left so they can be added to A
	sll $t2, $t2, 16
	sll $t3, $t3, 16

start:
	# Concat the padding bit to the last bit of A($t1)
	andi $t4, $t1, 1
	sll $t4, $t4, 1
	andi $t4, $t4, 2
	or $t4, $t4, $t7

	# 00 do_nothing
	# 01 add_B
	# 10 sub_B
	# 11 do_nothing

	# Compare $t4 to the above table.
	li $t5, 1
	beq $t4, $t5, add_B
	li $t5, 2
	beq $t4, $t5, sub_B

	j do_nothing

sub_B:
	addu $t1, $t1, $t3
	j do_nothing

add_B:
	addu $t1, $t1, $t2

do_nothing:
	# add last bit of A ($t1) to padding ($t7)
	andi $t7, $t1, 1
	sra $t1, $t1, 1

	# keep track of the shifts. (This is some do while logic.)
	lw $t4, count
	addi $t4, $t4, 1		# Increment the counter
	sw $t4, count
	li $t6, 16					# load a constant into a register
	slt $a0, $t4, $t6		# set on less than (i < 7)
	bne $a0, $zero, start	# If i = 7 then continue with the rest of the program.


	# Print values added to console
	li $v0, 1
	move $a0, $t1
	syscall


	# exit the program
	li $v0, 10
	syscall
