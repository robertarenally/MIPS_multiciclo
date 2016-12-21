.data
	x:	.word 6
.text
	lw $t0,128($zero)
	add $t1, $t0, $zero
	sw $t1,1($zero)
	lw $t2,1($zero) 
