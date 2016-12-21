.text
	beq $zero, $zero, l1
	ori $t1, $zero, 3
l1:	add $t2,$t1,$t1
	beq $t2,$t1,l1