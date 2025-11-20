		.data
A:		.hword	7
B:		.hword  10
SUMA:		.hword	0
MAYOR:		.hword	0
MENOR:		.hword	0
		.code 
		lh r1, A(r0) -- r1 = A
		lh r2, B(r0) -- r2 = B
		slt r3, r1, r2 --Si r1 < r2 --> r3=1
		dadd r4, r1, r2 --r4 = r1 + r2
		pushh r4
		beqz r3, aux --Salto si r1 < r2
		lh r6, A(0) --
		lh r7, B(0)
		jmp sigo
aux:		lh r6, B(0)
		lh r7, A(0)		
sigo:		andi r5, r4, 1 -- Si r5=1 la SUMA es impar, caso contrario es par
		beqz r5, esPar
esImpar:	pushh r6 --El registro r6 sera el de menor valor
		pushh r7 --El registro r7 sera el de mayor valor
		lh r8, 0(SP)  -- r8=MAYOR
		sh r8, MAYOR(0)
		lh r8, 2(SP)
		sh r8, MENOR(0)
		jmp incisoh		
esPar:		pushh r7
		pushh r6
		lh r8, 0(SP) -- r8=MENOR
		sh r8, MENOR(0)
		lh r8, 2(SP)
		sh r8, MAYOR(0)
incisoh:	lh r8, 4(SP)
		sh r8, SUMA(0)
		beqz r5, sobrescribirCero
sobrescribirUno:	sh r5, 4(SP)
		jmp sigo2
sobrescribirCero:	sh r0, 4(SP)
sigo2:		beqz r5, esPar2
		poph r7
		poph r6
		jmp fin
esPar2:		poph r6
		poph r7		
fin:		poph r4
		halt
	