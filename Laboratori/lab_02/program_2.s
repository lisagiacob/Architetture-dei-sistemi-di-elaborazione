.data
i:	.double	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
w: .double 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
b: .double	171
x: .double	0
y: .double	0

.text
l.d 	F1, b(R0) #inizializzo x a 0
daddi	R2, R0, 0 #inizializzo j a 0
daddi	R3, R0, 240 

a:
	l.d		F5, i(R2)	#valore j di i
	l.d		F6, w(R2)	#valore j di w
	
	mul.d	F10, F5, F6
	add.d	F1,	F1, F10
	daddi	R2, R2, 8	#incremento l'indice
	bne		R2, R3, a

	s.d		F1, x(R0)
	ld		R1, x(R0)
	
	dsll		R1, R1,	1
	dsrl		R1, R1, 26
	dsrl		R1, R1, 26
	
	daddi		R5, R0, 0x7ff
	beq			R1, R5, b
	sd			R1, y(R0)
	HALT
	
b:	
	HALT

 
