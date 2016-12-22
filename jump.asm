.text
	jal l1
	beq $zero, $zero, Exit
l1:	or $t1, $zero, $zero
	jr $ra
Exit: