# Author : Alperen CAN

.text

start:			jal menu
			
			li $v0,10
			syscall

menu:			la $a0,prompt3
			li $v0,4
			syscall
			
			la $a0,prompt4
			li $v0,4
			syscall
			
			la $a0,prompt5
			li $v0,4
			syscall
			
			la $a0,prompt6
			li $v0,4
			syscall
			
			la $a0,prompt7
			li $v0,4
			syscall
			
			la $a0,prompt8
			li $v0,4
			syscall
			
			la $a0,prompt9
			li $v0,4
			syscall
			
			la $a0,prompt10
			li $v0,4
			syscall
			
			li $v0,5
			syscall
			
			beq $v0,1,option1
			beq $v0,2,option2
			beq $v0,3,option3
			beq $v0,4,option4
			beq $v0,5,option5
			beq $v0,6,option6
			beq $v0,7,option7
			
option1:		la $v0,4
			la $a0,prompt1
			syscall
		
			li $v0,5
			syscall
			
			blez $v0,retake		# N should be greater than zero.
		
			move $t0,$v0		# t0 is the matrix size N in terms of dimension.
			
			la $a0,prompt19
			li $v0,4
			syscall
			
			move $a0,$t0
			li $v0,1
			syscall
			
			la $a0,prompt21
			li $v0,4
			syscall
	
			j menu
			
retake:			la $a0,prompt23		# N should be greater than zero
			li $v0,4
			syscall
			
			j option1
			
						
option2:		blez $t0,notValid	# The current N should be greater than zero.

			mul $t1,$t0,$t0		
			mul $a0,$t1,4
			li $v0,9		# Allocates the array by syscall 9
			syscall
		
			move $t1,$v0		# t1 is starting address of the array 

			#jal initArray
			jal fillArray
			
			la $a0,prompt24
			li $v0,4
			syscall
			
			j menu
			
notValid:		la $a0,prompt22		# N should be greater than zero
			li $v0,4
			syscall
			
			j menu
			
option3:		jal accessElement
			j menu

option4:		jal rowMajorSum
			j menu

option5:		jal columnMajorSum
			j menu
	
option6:		jal displayRowCol
			j menu

option7:		li $v0,10
			syscall
			
#################################### SUBPROGRAM initArray ###################################		

initArray:		mul $t2,$t0,$t0 	# t2 is number of elements 
			move $t3,$t1 		# t3 is the address
			
			la $a0,prompt20
			li $v0,4
			syscall
			
initLoop:		beqz $t2,initLoopDone
			la $a0,prompt2
			li $v0,4
			syscall
			
			li $v0,5
			syscall
			
			sw $v0,0($t3)
			addi $t3,$t3,4
			subi $t2,$t2,1
			j initLoop

initLoopDone:		jr $ra

#################################### Subprogram fillArray ###################################
############################ Fills array with consecutive values.############################

fillArray:		mul $t2,$t0,$t0		# t2 is number of elements
			move $t3,$t1		# t3 is the address
			li $t4,1		
			
fillLoop:		beqz $t2,fillLoopDone
			sw $t4,0($t3)
			addi $t3,$t3,4
			subi $t2,$t2,1
			addi $t4,$t4,1
			j fillLoop
		
fillLoopDone:		jr $ra
###################################### SUBPROGRAM columnMajorSum ################################
			
columnMajorSum:		mul $t2,$t0,$t0 	# t2 is number of elements
			move $t3,$t1 		# t3 is the address
			li $t4,0 		# t4 is the sum
			
columnSumLoop:		beqz $t2,columnSumLoopDone
			lw $t5,0($t3)
			add $t4,$t4,$t5
			addi $t3,$t3,4
			subi $t2,$t2,1
			j columnSumLoop

columnSumLoopDone:	la $a0,prompt11
			li $v0,4
			syscall
			
			li $v0,1
			move $a0,$t4
			syscall
			
			jr $ra
			
##################################### SUBPROGRAM rowMajorSum  ######################################

rowMajorSum:		mul $t2,$t0,$t0 	# t2 is number of elements
			
			li $t4,0 		# t4 is the sum
			mul $t6,$t0,4 		# t6 is Nx4
			li $t8,0
			li $s0,0
			
			
rowMajLoop1:		beq $t8,$t0,rowMajLoop1Done
			move $t7,$t0
			mul $s0,$t8,4
			move $t3,$t1 		# t3 is the address
			add $t3,$t3,$s0
		
			
	rowMajLoop2:		beqz $t7,rowMajLoop2Done
				lw $t5,0($t3)
				add $t4,$t4,$t5
				add $t3,$t3,$t6
				subi $t7,$t7,1
				j rowMajLoop2

	rowMajLoop2Done:	addi $t8,$t8,1
				j rowMajLoop1
			
rowMajLoop1Done:	la $a0,prompt12
			li $v0,4
			syscall
			
			move $a0,$t4
			li $v0,1
			syscall
			
			jr $ra

###################################### Subprogram accessElement ###################################

accessElement:		move $t2,$t0 		# t2 is N
			move $t3,$t1 		# t3 is the address
			
			la $a0,prompt13
			li $v0,4
			syscall
			
			la $a0,prompt14
			li $v0,4
			syscall
					
			li $v0,5
			syscall
			move $t4,$v0 		# t4 is the row no
			
			la $a0,prompt15
			li $v0,4
			syscall
			
			li $v0,5
			syscall
			move $t5,$v0 		# t5 is the column no
			
			subi $t6,$t5,1 		# t6 is column no-1
			mul $t7,$t0,4
			mul $t7,$t6,$t7	 	# t7 is (Nx4)x(colNo-1)
			subi $t6,$t4,1
			mul $t6,$t6,4
			add $t3,$t3,$t7
			add $t3,$t3,$t6
			
			lw $t8,0($t3)
			
			la $a0,prompt16
			li $v0,4
			syscall
			
			li $v0,1
			move $a0,$t8
			syscall
			
			jr $ra
			
############################################# Subprogram displayRowCol ######################################
			
displayRowCol:		move $t2,$t0 		# t2 is N
			move $t3,$t1 		# t3 is the address
			
			la $a0,prompt13
			li $v0,4
			syscall
			
			la $a0,prompt17
			li $v0,4
			syscall
			
askAgain:		la $a0,prompt14
			li $v0,4
			syscall
			
			li $v0,5
			syscall
			move $t4,$v0 		# t4 is row no
			
			la $a0,prompt15
			li $v0,4
			syscall
			
			li $v0,5
			syscall
			move $t5,$v0 		# t5 is column no
			
			beq $t4,$t5,invalid
			beq $t4,0,displayCol
			beq $t5,0,displayRow

invalid:		la $a0,prompt18
			li $v0,4
			syscall	
			b askAgain
			
displayCol:		subi $t6,$t5,1 		# t6 is colno-1
			mul $t7,$t0,4
			mul $t6,$t6,$t7
			add $t3,$t3,$t6 	# array address now starts from top of column
			
displayColLoop:		beqz $t2,displayColLoopDone
			
			lw $a0,0($t3)
			li $v0,1
			syscall
			
			la $a0,space
			li $v0,4
			syscall
			
			addi $t3,$t3,4
			subi $t2,$t2,1
			j displayColLoop

displayColLoopDone:	jr $ra

displayRow:		move $t2,$t0 		# t2 is N
			move $t3,$t1 		# t3 is the address
			
			subi $t6,$t4,1
			mul $t6,$t6,4
			add $t3,$t3,$t6 	# array address now starts from the beginning of the row
			mul $t7,$t0,4 		# t7 is Nx4
			
displayRowLoop:		beqz $t2,displayRowLoopDone

			lw $a0,0($t3)
			li $v0,1
			syscall
			
			la $a0,space
			li $v0,4
			syscall
			
			add $t3,$t3,$t7
			subi $t2,$t2,1
			j displayRowLoop
			
displayRowLoopDone: 	jr $ra
			
			


.data
space: 			.asciiz " "
newLine:		.asciiz "\n"
prompt1:		.asciiz "Enter the matrix size N in terms of dimension : "
prompt2:		.asciiz "Enter number: "
prompt3:		.asciiz "\nWhat do you want to do?"
prompt4:		.asciiz "\n(1) Enter the size N for an NxN matrix "
prompt5:		.asciiz "\n(2) Allocate the array with the current N value "
prompt6:		.asciiz "\n(3) Access the matrix element at [x,y]"
prompt7:		.asciiz "\n(4) Obtain Row-Major summation"
prompt8:		.asciiz "\n(5) Obtain Column-Major summation"
prompt9:		.asciiz "\n(6) Display the whole row or column elements"
prompt10:		.asciiz "\n(7) Exit\n"
prompt11:		.asciiz "The column-major sum is : "
prompt12:		.asciiz "The row-major sum is : "
prompt13:		.asciiz "Note that row and column numbers start from 1"
prompt14:		.asciiz "\nEnter row no   : "
prompt15:		.asciiz "Enter column no: "
prompt16:		.asciiz "The searched element is : "
prompt17:		.asciiz "\nTo display row, enter 0 to col no. To display col,enter 0 to row no."
prompt18:		.asciiz "This subprogram displays either the row or column. Enter 0 to one of them."
prompt19: 		.asciiz "\n*** N is set to "
prompt20:		.asciiz "Initialize the array\n"
prompt21:		.asciiz " ***"
prompt22:		.asciiz "\n*** First, please enter an N value greater than zero. ***"
prompt23:		.asciiz "*** The N value should be greater than zero ***\n."
prompt24:		.asciiz "*** Array is initialized with consecutive values. ***"

