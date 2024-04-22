;int translate_morse(char* vett_input, int vet_input_lenght, char* vett_output, int vet_output_lenght, char change_symbol, char space, char sentence_end);
	AREA word, DATA, READWRITE
w_code 			space 8
word_final		space 100
	
	AREA morse, DATA, READONLY
w_Lenght_1		DCB		"T", 2_1
				DCB		"E", 2_0
w_Lenght_2		DCB		"A", 2_01
				DCB		"I", 2_00
				DCB		"M", 2_11
	 			DCB		"N", 2_10
w_Lenght_3		DCB 	"D", 2_100
				DCB		"G", 2_110
				DCB		"K", 2_101
				DCB		"O", 2_111
				DCB		"R", 2_010
				DCB		"S", 2_000
				DCB		"U", 2_001
				DCB		"W", 2_011
w_Lenght_4		DCB		'B'
				DCW		0x1000
				DCB		'C'
				DCW		0x1010
				DCB		"F"
				DCW		0x0010
				DCB		"H", 2_0000
				DCB		"J", 2_0111
				DCB		"L", 2_0100
				DCB		"P", 2_0110
				DCB		"Q", 2_1101
				DCB		"V", 2_0001
				DCB		"X", 2_1001
				DCB		"Y", 2_1011
				;DCB		"Z",�2_1100
w_Lenght_5		DCB 	"1", 2_01111
				DCB		"2", 2_00111
				DCB		"3", 2_00011
				DCB		"4", 2_00001
				DCB		"5", 2_00000
				DCB		"6", 2_10000
				DCB		"7", 2_11000
				DCB		"8", 2_11100
				DCB		"9", 2_11110
				DCB		"0", 2_11111

	AREA asm_functions, CODE, READONLY
	EXPORT translate_morse

inVA	rn 0
outVA	rn 2
t2	rn 4
t3	rn 5
t4	rn 6
len rn 8
wB	rn 10
w_LA	rn 1
	
translate_morse
			;save current SP to faster access to data in the stack
			mov r12, sp
			;save volatile registers
			stmfd sp!, {r4-r8, r10-r11, lr}
			ldr r4, [r12]	;2
			ldr r5, [r12, #4]
			ldr r6, [r12, #8]
			mov r8, #0		;lunghezza codice lettera
			
count 
			ldrb r10, [inVA], #1	;metto in r10 il byte
			
			;salvo in w_code il byte letto
			ldr r11, =w_code
			mov r9, wB
			
			;comparo il byte del codice carattere con i byte "speciali" 
			cmp wB, t2	
			beq wordCode
			cmp wB, t3
			beq wordCode
			cmp wB, t4
			beq wordCode
			
			strb wB, [r11], #1
			
			add len, len, #1	;incremento la lunghezza del codice parola
			
			b count
			
wordCode	; abbiamo letto tutto il codice lettera
			ldr r11, =w_code
			ldr r3, [r11]	
			
			cmp len, #1
			ldreq	w_LA, =w_Lenght_1
			cmp len, #2
			ldreq	w_LA, =w_Lenght_2
			cmp	len, #3
			ldreq	w_LA, =w_Lenght_3
			cmp	len, #4
			ldreq	w_LA, =w_Lenght_4
			cmp	len, #5
			ldreq	w_LA, =w_Lenght_5
			
			
			; reinizializzo la lunghezza per la prossima lettera
			mov len, #0
			
L
			ldr r7, [w_LA]			
			lsr r7, #12					; shifto a destra in modo da avere il solo codice carattere e eliminare i carattere in se
			cmp r7, r3					;compare tra word letta da vett_input e quella morse
			; se non coincidono passo a confrontare il codice parola sucessivo
			addne w_LA, w_LA, #8		;aggiungo 8 all'address del registro per passare al codice lettera sucessivo
			bne L

			sub w_LA, w_LA, #4
			ldr r7, [w_LA]
			ldr r8, =word_final
			str r7, [r8, #1]
			;controllo l'ultimo carattere letto e in base a quello salto
			cmp r9, t2
			beq C2
			cmp r9, t3
			beq C3
			cmp r9, t4
			beq C4
			
C2
			
C3
C4
			
			ldmfd sp!, {r4-r8, r10-r11, pc}
			end
