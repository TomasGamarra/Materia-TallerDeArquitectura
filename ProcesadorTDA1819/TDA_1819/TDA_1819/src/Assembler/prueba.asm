		.data
A:		.word	6
B:		.hword	10
		.code
		daddi r1, r0, 4
		daddi r2, r0, 8
		lh r2, A(r1)
		nop
		nop
		nop
		pushh r1
		nop
		nop
		pushh r2
		halt
	