			AREA morse, DATA, READONLY				


Morse		DCD 0xFFFFFF01, 0xFFFF1000, 0xFFFF1010, 0xFFFFF100, 0xFFFFFFF0, 0xFFFF0010
			DCD 0xFFFFF110, 0xFFFF0000, 0xFFFFFF00, 0xFFFF0111, 0xFFFFF101, 0xFFFF0100
			DCD 0xFFFFFF11, 0xFFFFFF10, 0xFFFFF111, 0xFFFF0110, 0xFFFF1101, 0xFFFFF010
			DCD 0xFFFFF000, 0xFFFFFFF1, 0xFFFFF001, 0xFFFF0001, 0xFFFFF001, 0xFFFF1001
			DCD 0xFFFF1011, 0xFFFFF110, 0xFFF01111, 0xFFF00111, 0xFFF00011, 0xFFF00001
			DCD 0xFFF00000, 0xFFF10000, 0xFFF11000, 0xFFF11100, 0xFFF11110, 0xFFF11111
			
			
Conversion	DCB "A", "B", "C", "D", "E", "F"
			DCB "G", "H", "I", "J", "K", "L"
			DCB "M", "N", "O", "P", "Q", "R"
			DCB "S", "T", "U", "V", "W", "X"
			DCB "Y", "Z", "1", "2", "3", "4"
			DCB "5", "6", "7", "8", "9", "0"
			
			AREA asm_functions, CODE, READONLY				
			EXPORT  translate_morse
				
				
;translate_morse(
		;char* vett_input, 		=R0
		;int vet_input_lenght,  =R1
		;char* vett_output, 	=R2
		;int vet_output_lenght, =R3
		;char change_symbol, 	SP
		;char space, 			SP
		;char sentence_end);	SP
translate_morse
				MOV R12, SP
				PUSH {R1-R12, LR}	; save R1-R12,LR,PC
				
				LDR R4, [R12], #4 	;CHANGE
				LDR R5, [R12], #4	;SPACE
				LDR R6, [R12]	 	;END
				
								
				MOV R7,  #0xFFFFFFFF; mask
				MOV R3,  #0			; counter
				MOV R8,  #0			; offset			
loop
				LDRB R9, [R0, R8]	; R7 = input value
	
				;  = 0
				CMP R9, #0
				BNE is_one
				LSL R7, #4
				B check
				
				
				
is_one			;  = 1
				CMP R9, #1
				BNE is_change
				LSL R7, #4
				ORR R7, R9, R7
				B check				

				
				; CHANGE = R4
is_change		CMP R9, R4
				BNE is_space
				BL find_conversion
				STRB R7, [R2, R3]
				MOV R7,  #0xFFFFFFFF
				ADD R3, #1
				B check
				
				
is_space		; space = R5
				CMP R9, R5
				BNE is_end
				BL find_conversion
				STRB R7, [R2, R3]
				ADD R3, #1
				; scrivo lo spazio
				MOV R7, #0x20
				STRB R7, [R2, R3]
				MOV R7,  #0xFFFFFFFF	
				ADD R3, #1
				B check
				
check
				ADD R8, r8, #1
				CMP R8, R1
				BEQ uscita
				B loop
				
is_end			; END = R6
				BL find_conversion
				STRB R7, [R2, R3]
				ADD R3, #1
				B uscita

					
					
find_conversion	PROC
				PUSH {R0-R6, R8-R12, LR}	; save R0-R6, R8-R12, LR,PC
				
				MOV R0, R7 		;R0 è il valore 
								
				LDR R1, =Morse
				LDR R2, =Conversion
				
loop_conv
				LDR R3, [R1], #4
				LDRB R4, [R2], #1
				
				CMP R0, R3
				BNE loop_conv
				MOV R7, R4
				
				POP {R0-R6, R8-R12, PC}	;restore R0-R6, R8-R12, LR,PC
				
				ENDP
				

uscita
				MOV R0, R3
				POP {R1-R12, PC}	;restore R1-R12,LR,PC
				

				END