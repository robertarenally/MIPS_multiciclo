.data
x:	.word 5
.text
	beq $zero, $zero, Logic	# salta para Logic
A:	addi $t6, $zero, 3	#$t6 = 3
	add $t7, $t6,$t6	#$t7 = 6
	sub $t8,$t7,$t6		#$t8 = 3
	slt $t0,$t6,$t7		#$t0 = 1
	slt $t0,$t7,$t6		#$t0 = 0
	jal E			# salta para E
	beq $t3, $t4, Exit	# salta para Exit
Logic:	ori $t1, $zero, 1	# $t1 = 1
	and $t2, $t1, $t1	#$t2 = 1
	and $t3, $zero, $t1	#$t3 = 0
	or $t4, $t3, $t2	#$t4 = 1
	nor $t5, $t3, $t2	#$t5 = -2
	xor $t5, $t1, $t1	#$t5 = 0
	xor $t5, $zero,$t1	#$t5 = 1
	bne $zero, $t5, A	#salta para A
E:	sll $t9, $t6, 2		#$t9 = 12
	srl $t9, $t9, 2		#$t9 = 3
	lw $t1,0($zero)		#$t1 = 5
	add $t2, $t1, $t9	#$t2 = 8
	sw $t2, 1($zero)	#grava na memoria
	jr $ra			#retorna para o endereco depois de jal
Exit:
