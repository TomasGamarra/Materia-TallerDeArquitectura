		.data
A:		.word	0
		.code 
		daddi r1, r0, 6
		daddi r2, r0, 4
		pushh r2
		nop
		nop
		nop
		pushh r1
		nop
		nop
		nop
		poph  r2
		halt
	