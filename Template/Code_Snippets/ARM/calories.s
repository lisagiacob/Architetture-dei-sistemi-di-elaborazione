Reset_Handler   PROC
                EXPORT  Reset_Handler             [WEAK]      
					
				LDR r1, =Calories_food		;load dell'indirizzo di mem
				LDR r2, =Calories_sport	
				LDR r3, =Num_days
				LDR r4, =Num_days_sport
				LDRB r3, [r3]
				LDRB r4, [r4]
				
				MOV r0, #0		;index per il primo ciclo
				ADD r11, #0		;inizializzo numero giorni <500kcal
				
				SUB R1, #4
				SUB R2, #4
				
init	
				CMP r0, r3
				BEQ stop
				ADD r0, #1			;incremento l'index del ciclo 1
				LDR r5, [r1, #4]!	;giorno
				LDR r6, [r1, #4]!	;cal del giorno
				
				
				MOV r10, #0		;index per il secondo ciclo
ciclo	;inizio a ciclare sulle calorie consumate
				ADD r10, #1			;incremento l'index del ciclo 2
				LDR r7, [r2, #4]!	;giorno
				LDR r8, [r2, #4]!	;calorie consumate
			
				CMP r5, r7 			;comparo i giorni del food e dello sport
				BEQ uguali
				;giorni diversi
				CMP r4, r10			;i=3?
				BEQ init
				BNE ciclo 
uguali			;giorni uguali
				SUB r6, r6, r8		;calorie totali
				CMP r6, #500
				ADDGT r11, #1		;se + di 500 ingerite, incremento r11
				B init
				
				
stop            BX      R0
                ENDP

					LTORG
padd				SPACE	4096
					ALIGN 	2
Days				DCB 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07

Calories_food 	 	DCD 0x06, 1300, 0x03, 1700, 0x02, 1200, 0x04, 1900
					DCD 0x05, 1110, 0x01, 1670, 0x07, 1000

Calories_sport	 	DCD 0x02, 500, 0x05, 800, 0x06, 400

Num_days	 		DCB 7
Num_days_sport		DCB 3