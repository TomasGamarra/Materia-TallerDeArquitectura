		.data
A:		.hword	8528
B:		.hword	15093
SUMA:		.hword	0
MAYOR:		.hword	0
MENOR:		.hword	0
		.code
		lh r1, A(r0)
		lh r2, B(r0)
		slt r3, r1, r2
		andi r3, r3, 1
		dadd r4, r1, r2
		pushh r4
		beqz r3, aux
		lh r6, A(r0)
		lh r7, B(r0)
		jmp sigo
aux:		lh r6, B(r0)
		lh r7, A(r0)
sigo:		andi r5, r4, 1
		beqz r5, esPar
esImpar:	pushh r6
		pushh r7
		lh r8, 0(SP)
		sh r8, MAYOR(r0)
		lh r8, 2(SP)
		sh r8, MENOR(r0)
		jmp incisoh
esPar:		pushh r7
		pushh r6
		lh r8, 0(SP)
		sh r8, MENOR(r0)
		lh r8, 2(SP)
		sh r8, MAYOR(r0)
incisoh:	lh r8, 4(SP)
		sh r8, SUMA(r0)
		beqz r5, Cero
Uno:	sh r5, 4(SP)
		poph r7
		poph r6
		jmp fin
Cero:	sh r0, 4(SP)
		poph r6
		poph r7
fin:		nop
		poph r4
		halt
	