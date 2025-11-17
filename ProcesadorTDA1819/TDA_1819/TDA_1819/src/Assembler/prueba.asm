		.data
A:		.word	0
		.code 
		daddi r1, r0, 2
		daddi r2, r0, 4
		pushh r1
		nop
		nop
		nop
		pushh r2
		halt
	