## Write a MIPS assembly language program that implements Booth’s multiplication algorithm.
## Run it on the MARS or QTSpim simulatorswith a range of inputs to verify correct operation.
## Program notes:
##  a.Communicate clearly to the person running the program:
##    i.How to enter the numbers to be multiplied.
##    ii.How to terminate the program.
##  b.Test your program with positive numbers, negative numbers, and 0.

## This program is written for 16 bit integers (small).

.data
	enter1: .asciiz "Enter Number 1\n Valid numbers are 65,536 >= X_1 >= -65,537.\nX_1 = "
	enter2: .asciiz "Enter Number 2\n Valid numbers are 65,536 >= X_2 >= -65,537.\nX_2 = "
	value: .word 0, 0, 0

	var1: .word 0
	var2: .word 0

	count: .word 0


	.text

main:
	# setup initial values
	li $t0, 0
	sw $t0, count
	la $t0, value


	# Prompt and store val 1 in 0($t0)
	li $v0, 4
	la $a0, enter1
	syscall
	li $v0, 5          # load code for read_int call in register $v0
	syscall            # read integer
	sw $v0, var1

	# Prompt and store val 2 in 2($t0)
	li $v0, 4
	la $a0, enter2
	syscall
	li $v0, 5          # load code for read_int call in register $v0
	syscall            # read integer
	sw $v0, var2

	# Setup A, B, and -b
	lw $t1, var1 				# Load A
	andi $t1, 0x0000FFFF
	lw $t2, var2 				# Load B
	andi $t2, 0x0000FFFF

	not $t3, $t2				# Calculate inverse of B
	addi $t3, $t3, 1		# Add 1

	# Shift B and -B accordingly.
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
	# add last bit to padding($t7)
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
