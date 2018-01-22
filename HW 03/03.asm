## Write a MIPS assembly language program that implements Booth’s multiplication algorithm.
## Run it on the MARS or QTSpim simulatorswith a range of inputs to verify correct operation.
## Program notes:
##  a.Communicate clearly to the person running the program:
##    i.How to enter the numbers to be multiplied.
##    ii.How to terminate the program.
##  b.Test your program with positive numbers, negative numbers, and 0.



.text
	la $t0, value

	# Prompt and store val 1 in 0($t0)
	li $v0, 4
	la $a0, enter1
	syscall
	li $v0, 5          # load code for read_int call in register $v0
	syscall            # read integer
	sw $v0, 4($t0)

	# Prompt and store val 2 in 2($t0)
	li $v0, 4
	la $a0, enter2
	syscall
	li $v0, 5          # load code for read_int call in register $v0
	syscall            # read integer
	sw $v0, 8($t0)


	# Move values to registers
	lw $t1, 4($t0)
	lw $t2, 8($t0)

	# Print values added to console
	li $v0, 1
	add $a0, $t1, $t2
	syscall


	# exit the program
	li $v0, 10
	syscall

.data
	enter1: .asciiz "Enter Number 1\n Valid numbers are 2,147,483,647 >= x >= -2,147,483,648.\nX_1 = "
	enter2: .asciiz "Enter Number 2\n Valid numbers are 2,147,483,647 >= x >= -2,147,483,648.\nX_2 = "
	value: .word 0, 0, 0
