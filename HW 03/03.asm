## Write a MIPS assembly language program that implements Booth’s multiplication algorithm.
## Run it on the MARS or QTSpim simulatorswith a range of inputs to verify correct operation.
## Program notes:
##  a.Communicate clearly to the person running the program:
##    i.How to enter the numbers to be multiplied.
##    ii.How to terminate the program.
##  b.Test your program with positive numbers, negative numbers, and 0.

## This program is written for 16 bit integers (small).

.data
	enter1: .asciiz "Enter Number 1\n Valid numbers are 65,536 >= x >= -65,537.\nX_1 = "
	enter2: .asciiz "Enter Number 2\n Valid numbers are 65,536 >= x >= -65,537.\nX_2 = "
	value: .word 0, 0, 0

	var1: .word 0
	var2: .word 0


.text
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
	# Check the last two bits of B and goto the correct place
	andi $t4, $t1, 3
	li $t5, 0
	beq $t4, $t5, do_nothing
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
	srl $t1, $t1, 1

	# keep track of the shifts. (This is some do while logic.)
	addi $t6, $t6, 1		# Increment the counter
	li $t7, 17					# load a constant into a register
	slt $a0, $t6, $t7		# set on less than (i < 7)
	bne $a0, $zero, start	# If i = 7 then continue with the rest of the program.


	# Print values added to console
	li $v0, 1
	move $a0, $t1
	syscall


	# exit the program
	li $v0, 10
	syscall
