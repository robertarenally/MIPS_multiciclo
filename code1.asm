.text
	addi $t0, $zero, 3
	add $t1, $t0, $t0
	sub $t2, $zero, $t0
	addi $t3, $zero, 1
	and $t4, $t3,$t3
	and $t4, $zero, $t3
	or $t4, $zero, $t3
	nor $t4, $zero,$t3
	or $t4,$t3,$t3
	nor $t4,$t3,$t3
	xor $t4, $zero,$t3
	xor $t4, $zero,$zero
	xor $t4, $t3,$t3
	slt $t5, $t3, $t0
	slt $t5, $t0, $t3
	addi $t3, $zero, 1
	sll $t5, $t3, 2
	srl $t5, $t5, 2
	
