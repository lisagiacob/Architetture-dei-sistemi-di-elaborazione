#include "button.h"
#include "lpc17xx.h"

#include "../led/led.h"
int count = 0;

void EINT0_IRQHandler (void)	  	/* int0 */
{
	count = 0;
	LED_Out(count);
//	LED_On(0);
  LPC_SC->EXTINT &= (1 << 0);     /* clear pending interrupt         */
}


void EINT1_IRQHandler (void)	  	/*key 1 */
{
	count += 1;
	LED_Out(count);
//  LED_On(1);
	LPC_SC->EXTINT &= (1 << 1);     /* clear pending interrupt         */
}

void EINT2_IRQHandler (void)	  	/* key2*/
{	
	count -= 1;
	LED_Out(count);
//	LED_Off(0);
//	LED_Off(1);
  LPC_SC->EXTINT &= (1 << 2);     /* clear pending interrupt         */    
}


