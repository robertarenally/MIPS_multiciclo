.text
	addi $t0, $zero, 2	# 0 + 2 = 2
	beq $t0, $zero, exit	# Salta se 2 == 0, nesse caso não deve executar o salto
	add $t1, $t0, 8		# 2 + 8 = 10
	and $t2, $t1, $t0	# 10 and 2 = 2
	or $t2, $t1, $t0	# 10 or 2 = 10
	nor $t2, $t1, $t0	# 10 nor 2 = -11
	xor $t2, $t1, $t0	# 10 xor 2 = 8
	ori $t2, $t1, 2		# 10 ori 2 = 10
	bne $zero, $zero, exit	# Salta se 0 != 0, nesse caso não deve executar o salto
	sub $t3, $t1, $t0	# 10 - 2 = 8
	slt $t4, $t2, $t1	# 8 < 10 = 1
	slt $t4, $t1, $t2	# 10 < 8 = 0
	sll $t5, $t3, 3		# 8 << 3 = 64
	srl $t5, $t5, 3		# 8 >> 3 = 8
	beq $t5, $t3, L1	# Salta para L1 se 8 = 8
	add $t0, $zero, $zero	# nao deve ser executado
L1:	bne $t5, $t0, L2	# Branch para L2 se 8 != 2
	add $t0, $t0, 3		# nao deve ser executado
L2: 	jal L3			#
	add $t1, $zero, $t5	# 
	sw $t5, 0($t1)		# guarda 8 na memoria
	lw $t6, 0($t1)		# recupera 8 da memoria
	j exit			# salta para o fim do programa
L3:	jr $ra			# retorna para depois do jal
exit:
