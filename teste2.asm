# LW, SW, ADD, ADDi, SUB, AND, OR, NOR, XOR, SLT, J, BEQ, BNE, ORi, SRL, SLL, JAL, JR

.text
	addi $t0, $zero, 2	# 0 + 2 = 2
	beq $t0, $zero, exit	# Branch se 2 == 0
	add $t1, $t0, 8		# 2 + 8 = A
	and $t2, $t1, $t0	# A and 2 = 2
	or $t2, $t1, $t0	# A or 2 = A
	nor $t2, $t1, $t0	# A nor 2 = FFFFFFF5
	xor $t2, $t1, $t0	# A xor 2 = 8
	ori $t2, $t1, 2		# A ori 2 = A
	bne $t1, $t2, exit	# Branch se A != A
	sub $t3, $t1, $t0	# A - 2 = 8
	slt $t4, $t2, $t1	# 8 < A = 1
	sll $t5, $t3, 3		# 8 << 3 = 40
	srl $t5, $t5, 3		# 8 >> 3 = 8
	beq $t5, $t3, L1	# Branch para L1 se 8 = 8
	add $t0, $zero, $zero	# nao deve ser executado
L1:	bne $t5, $t0, L2	# Branch para L2 se 8 != 2
	add $t0, $t0, 3		# nao deve ser executado
L2: 	jal L3			#
	add $t1, $zero, 8192	# 
	sw $t5, 0($t1)		# guarda 8 na memoria
	lw $t6, 0($t1)		# recupera 8 da memoria
	j exit			# salta para o fim do programa
L3:	jr $ra			# retorna para depois do jal
exit: