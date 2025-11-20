		.data
A:		.hword	6
B:		.hword	10
		.code
		daddi r1, r0, 4
		daddi r2, r0, 8
		pushh r1
		pushh r2
		poph r2
		poph r1
		halt
	