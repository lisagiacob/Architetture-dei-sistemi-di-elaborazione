.data
v1:		.byte	2, 6, -3, 11, 9, 11, -3, 6, 2		#9 elementi
v2:		.byte	4, 7, -10, 3, 11, 9, 7, 6, 4
v3:		.byte	9, 22, 5, -1, 9, -1, 5, 22, 9
flag1:	.space 	1
flag2:	.space 	1
flag3:	.space 	1
v4:		.space	9
v5:		.byte	11, 28, 2, 10, 18, 10, 2, 28, 11
length:	.byte	8

.text
main:
	dadd	R4, R0, R0		#metto 0 in R4
	lb		R8,	length(R4)
	
	#Inizializzo dei parametri per riconoscere che vettore stiamo analizzando:
	daddui	R20, R0, 1		#Registro 20 a 1
	daddui	R11, R0, 1
	j		load1			#vai a loop e salva l'indirizzo della prossima istruzione in ra
	
p1:	
	daddui	R3, R0, 1
	sb		R3, flag1(R0)
	
	dadd	R4, R0, R0		#Reinizializzo i registri
	lb		R8,	length(R4)
	
	#SOMMA dei palindromi: Uso i registri da 21 a 29 per salvare i valori temporanei di v4
	lb		R21, v1(R4)
	daddui	R4, R4, 1
	lb		R22, v1(R4)
	daddui	R4, R4, 1
	lb		R23, v1(R4)
	daddui	R4, R4, 1
	lb		R24, v1(R4)
	daddui	R4, R4, 1
	lb		R25, v1(R4)
	daddui	R4, R4, 1
	lb		R26, v1(R4)
	daddui	R4, R4, 1
	lb		R27, v1(R4)
	daddui	R4, R4, 1
	lb		R28, v1(R4)
	daddui	R4, R4, 1
	lb		R29, v1(R4)
	
p2:
	dadd	R4, R0, R0		#Reinizializzo i registri
	lb		R8,	length(R4)
	
	daddui	R20, R0, 2
	daddui 	R12, R0, 2
	j		load2			#vai a loop e salva l'indirizzo della prossima istruzione in ra

p2b:	
	dadd	R4, R0, R0		#Reinizializzo i registri
	lb		R8,	length(R4)
	sb		R3, flag2(R0)
	
	lb		R5, v2(R4)
	dadd	R21, R21, R5
	daddui	R4, R4, 1
	lb		R5, v2(R4)
	dadd	R22, R22, R5
	daddui	R4, R4, 1
	lb		R5, v2(R4)
	dadd	R23, R23, R5
	daddui	R4, R4, 1
	lb		R5, v2(R4)
	dadd	R24, R24, R5
	daddui	R4, R4, 1
	lb		R5, v2(R4)
	dadd	R25, R25, R5
	daddui	R4, R4, 1
	lb		R5, v2(R4)
	dadd	R26, R26, R5
	daddui	R4, R4, 1
	lb		R5, v2(R4)
	dadd	R27, R27, R5
	daddui	R4, R4, 1
	lb		R5, v2(R4)
	dadd	R28, R28, R5
	daddui	R4, R4, 1
	lb		R5, v2(R4)
	dadd	R29, R29, R5

p3:
	dadd	R4, R0, R0		#Reinizializzo i registri
	lb		R8,	length(R4)

	daddui	R20, R0, 3
	daddui	R13, R0, 3
	j		load3			#vai a loop e salva l'indirizzo della prossima istruzione in ra

p3b:	
	dadd	R4, R0, R0		#Reinizializzo i registri
	lb		R8,	length(R4)
	sb		R3, flag3(R0)
	
	lb		R5, v3(R4)
	dadd	R21, R21, R5
	sb		R21, v4(R4)
	daddui	R4, R4, 1
	lb		R5, v3(R4)
	dadd	R22, R22, R5
	sb		R22, v4(R4)
	daddui	R4, R4, 1
	lb		R5, v3(R4)
	dadd	R23, R23, R5
	sb		R23, v4(R4)
	daddui	R4, R4, 1
	lb		R5, v3(R4)
	dadd	R24, R24, R5
	sb		R24, v4(R4)
	daddui	R4, R4, 1
	lb		R5, v3(R4)
	dadd	R25, R25, R5
	sb		R25, v4(R4)
	daddui	R4, R4, 1
	lb		R5, v3(R4)
	dadd	R26, R26, R5
	sb		R26, v4(R4)
	daddui	R4, R4, 1
	lb		R5, v3(R4)
	dadd	R27, R27, R5
	sb		R27, v4(R4)
	daddui	R4, R4, 1
	lb		R5, v3(R4)
	dadd	R28, R28, R5
	sb		R28, v4(R4)
	daddui	R4, R4, 1
	lb		R5, v3(R4)
	dadd	R29, R29, R5
	sb		R29, v4(R4)
	
	HALT
	

loop:
	bne		R1, R2, vF		#Se i valori non sono uguali il vettore non è palindromo
	
	#Se sono qua gli el sono uguali: ho due opzioni
	beq		R4, R8, vP		#Se sono al centro dell'array il vettore e' palindromo
	
	daddui 	R4, R4, 1		#Altrimenti aggiorno gli indici per poter elaborare i prossimi valori
	daddi	R8, R8, -1
	
	jr		R31				#Aggiorno i valori in R1 e R2

load1: 	#Load di v1
	lb		R1, v1(R4)		#Metto l'el della posizione desiderata in R1
	lb		R2, v1(R8)		#Metto l'el della posizione desiderata in R2
	jal		loop			#Salto nel ciclo per identificare i palindromi
	j		load1
	
load2: 	#Load di v2
	lb		R1, v2(R4)		#Metto l'el della posizione desiderata in R1
	lb		R2, v2(R8)		#Metto l'el della posizione desiderata in R2
	jal		loop			#Salto nel ciclo per identificare i palindromi
	j		load2
	
load3: 	#Load di v3
	lb		R1, v3(R4)		#Metto l'el della posizione desiderata in R1
	lb		R2, v3(R8)		#Metto l'el della posizione desiderata in R2
	jal		loop			#Salto nel ciclo per identificare i palindromi
	j		load3
	
vP:
	beq		R20, R11, p1
	beq		R20, R12, p2b
	beq		R20, R13, p3b
	
vF:
	beq		R20, R11, v1F
	beq		R20, R12, v2F
	beq		R20, R13, v3F
	
	
v1F:	#L'array non è palindromo
	sb		R0, flag1(R0)
	j		p2
	
v2F:	#L'array non è palindromo
	sb		R0, flag2(R0)
	j		p3

v3F:	#L'array non è palindromo
	sb		R0, flag3(R0)
	HALT
