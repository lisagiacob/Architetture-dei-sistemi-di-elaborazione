#include "button.h"
#include "lpc17xx.h"

#include "../led/led.h"
#include "../timer/timer.h"

extern int translate_morse(uint8_t vett_input[100], int vet_input_lenght, char* vett_output, int vet_output_lenght, char change_symbol, char space, char sentence_end);

void EINT0_IRQHandler (void)	  	/* INT0														 */
{
	LED_On(0);
	LPC_SC->EXTINT &= (1 << 0);     /* clear pending interrupt         */
}
void EINT1_IRQHandler (void)	  	/* KEY1														 */
{
	LED_Out(0);											//spegnamo tutti i LED
 	
	//read messege
	
	LED_Out(255);										//8 bit, 1 per ogni led, 255 per mettere tutto a 1
	
	NVIC_DisableIRQ(EINT0_IRQn);				//disabilito il pulsante int0
	NVIC_ClearPendingIRQ(EINT0_IRQn);		//faccio il clear del pending di int0
		
	NVIC_DisableIRQ(EINT2_IRQn);				//disabilito il pulsante key2
	NVIC_ClearPendingIRQ(EINT2_IRQn);		//faccio il clear del pending di key2
		
	init_timer(0, 0x047868C0);			//inizializzo il timer a 3 secondi
	enable_timer(0);
	
	NVIC_EnableIRQ(EINT0_IRQn);					//riabilito le chiavi
	NVIC_EnableIRQ(EINT2_IRQn);					//riabilito le chiavi
		
	//NVIC_SetPendingIRQ(EINT1_IRQn);
  //LED_On(1);
	LPC_SC->EXTINT &= (1 << 1);     /* clear pending interrupt         */

}

void EINT2_IRQHandler (void)	  	/* KEY2														 */
{/*
	LED_Off(0);
	LED_Off(1);
  LPC_SC->EXTINT &= (1 << 2);     // clear pending interrupt         
	enable_timer(0);  */
	uint8_t vett_input[100] = {0, 0, 0, 0, 2, 1, 1, 1, 2, 0, 1, 0, 0, 2, 0, 1, 3, 1, 1, 2, 0, 0, 1, 2, 1, 0, 2, 1, 0, 0, 2, 1, 1, 1, 3, 0, 1, 1, 1, 1, 2, 0, 0, 1, 1, 1, 4};
	int vet_input_lenght = 47;
	char vett_output[100];
	int vet_output_lenght;
	char change_symbol = 2;
	char space = 3;
	char sentence_end = 4;
	int result;
		
	NVIC_DisableIRQ(EINT0_IRQn);				//disabilito il pulsante int0
	NVIC_ClearPendingIRQ(EINT0_IRQn);		//faccio il clear del pending di int0
		
	NVIC_DisableIRQ(EINT1_IRQn);				//disabilito il pulsante key2
	NVIC_ClearPendingIRQ(EINT1_IRQn);		//faccio il clear del pending di key2
	
	result = translate_morse(vett_input, vet_input_lenght, vett_output, vet_output_lenght, change_symbol, space, sentence_end);
		
	NVIC_EnableIRQ(EINT0_IRQn);					//riabilito la chiave int0
	NVIC_EnableIRQ(EINT1_IRQn);					//riabilito la chiave key1
}


