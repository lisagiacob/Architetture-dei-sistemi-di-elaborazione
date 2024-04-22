#include "button.h"
#include "lpc17xx.h"


#include "../led/led.h"
#include "../timer/timer.h"

#define CHANGE 2
#define SPACE 3
#define END 4

extern int translate_morse(char* vett_input, int vet_input_lenght, char* vett_output, int vet_output_lenght, char change_symbol, char space, char sentence_end);

char values[100] = {0,0,0,0,2,1,1,1,2,0,1,0,0,2,0,1,3,1,1,2,0,0,1,2,1,0,2,1,0,0,2,1,1,1,3,0,1,1,1,1,2,0,0,1,1,1,4};
int values_length = 0; 
const int max_length = 100;
char output[100];


void EINT0_IRQHandler (void)	  	/* INT0														 */
{
	All_LED_off();
	values_length = 0;
	LPC_SC->EXTINT &= (1 << 0);     /* clear pending interrupt         */
}


void EINT1_IRQHandler (void)	  	/* KEY1														 */
{
  int i = 0;
	
	uint32_t time = 1 * 12500000;
	values_length = 0;
	All_LED_off();
	
	//reading message
	for (i=0; i<max_length; i++){
		values_length ++;
		if (values[i] == END ){
			break;
		}
	}
	
	//At the end of the message (after reading the digit 4 in vett_input), 
	//all LEDs are switched on for 3s. During this period, INT0 and KEY2 are disabled
	All_LED_on();
	//disable interrupts
	NVIC_DisableIRQ(EINT0_IRQn);
	NVIC_DisableIRQ(EINT2_IRQn);
	
	//attivi timer
	enable_timer(0);
	init_timer(0, time);
	
	
	LPC_SC->EXTINT &= (1 << 1);     /* clear pending interrupt         */
}

void EINT2_IRQHandler (void)	  	/* KEY2														 */
{
	volatile int res = 0;
	
	//enable interrupts
	NVIC_DisableIRQ(EINT0_IRQn);
	NVIC_DisableIRQ(EINT1_IRQn);
	
	
	res = translate_morse(values, values_length, output, max_length, CHANGE, SPACE, END);
	
	LED_Out(res);
	
	//clear pending
	NVIC_ClearPendingIRQ(EINT0_IRQn);
	NVIC_ClearPendingIRQ(EINT1_IRQn);
	
	//enable interrupts
	NVIC_EnableIRQ(EINT0_IRQn);
	NVIC_EnableIRQ(EINT1_IRQn);
	
  LPC_SC->EXTINT &= (1 << 2);     /* clear pending interrupt         */  
	enable_timer(0);  
}




