.data
	x:	.word	4	
.text
	lw $t8,0($zero)		# $t8 = 4
	add $s0,$t8,$zero	#$s0 = 4
	addi $t0,$zero,2	# 0 + 2 = 2
	beq $t0,$zero, exit	# não executa o salto 
	ori $t1,$t0,8		# 8 or 2 = 10
	and $t3,$t1,$t0		# 10 and 2 = 2
	or $t4,$t1,$t0		# 10 or 2 = 10
	nor $t4,$t1,$t0		# 10 nor 2 = -11
	xor $t4,$t1,$t0		# 10 xor 2 = 8
	bne $zero,$zero,exit	# não executa o salto
	sub $t5, $t1, $t0	# 10 - 2 = 8
	slt $t2, $t5, $t1	# 8 < 10 = 1
	slt $t2, $t1, $t5	# 10 < 8 = 0
	sll $t2, $t5, 3		# 8 << 3 = 64
	srl $t5, $t2, 3		# 64 >> 3 = 8
	beq $t5, $t4, L1	# Salta para L1 se 8 = 8
	add $t6, $t0, $t0	# nao deve ser executado
L1:	bne $t5, $t0, L2	# Salta para L2 se 8 != 2
	add $t6, $t0, $t2	# nao deve ser executado
L2: 	jal L3			#
	add $t6, $t0, $t1	# 2 + 10 = 12
	sw $t6, 4($zero)	# guarda 12 na memoria
	lw $t7, 4($zero)	# recupera 12 da memoria
	add $t8,$t7,$zero	# 12 + 0 = 12
	j exit			# salta para o fim do programa
L3:	jr $ra			# retorna para depois do jal
exit:
	
	