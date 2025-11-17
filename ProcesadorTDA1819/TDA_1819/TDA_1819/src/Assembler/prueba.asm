		.data
A:		.word	0
		.code 
		daddi r1, r0, 2
		daddi r2, r0, 4
		andr r2, r1, r0
		nop
		nop
		andr r2, r2, r0
		halt
	