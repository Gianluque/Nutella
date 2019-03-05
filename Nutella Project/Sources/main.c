/* ###################################################################
**     Filename    : main.c
**     Project     : Sendblocks
**     Processor   : MC9S08QE128CLK
**     Version     : Driver 01.12
**     Compiler    : CodeWarrior HCS08 C Compiler
**     Date/Time   : 2019-02-19, 17:18, # CodeGen: 0
**     Abstract    :
**         Main module.
**         This module contains user's application code.
**     Settings    :
**     Contents    :
**         No public methods
**
** ###################################################################*/
/*!
** @file main.c
** @version 01.12
** @brief
**         Main module.
**         This module contains user's application code.
*/         
/*!
**  @addtogroup main_module main module documentation
**  @{
*/         
/* MODULE main */


/* Including needed modules to compile this module/procedure */
#include "Cpu.h"
#include "Events.h"
#include "AD1.h"
#include "AS1.h"
#include "TI1.h"
#include "Led1.h"
#include "Bit1.h"
#include "Bit2.h"
/* Include shared modules, which are used for whole project */
#include "PE_Types.h"
#include "PE_Error.h"
#include "PE_Const.h"
#include "IO_Map.h"


/* User includes (#include below this line is not maintained by Processor Expert) */
char flag=0;


void SendData(char block[]){
	char error;
	char ptr;
	
	do{
		error=AS1_SendBlock(block,4,&ptr);
		
	}while(error!=ERR_OK);
}

void Masksignal(char signal[]){
	
	char i=0;
	
	do{
		signal[i]   = (signal[i] << 2 | signal[i+1] >> 6);
		i==0        ? (signal[i]=(signal[i] & 0b01111111)) : (signal[i]=(signal[i] | 0b10000000));
		signal[i+1] =  signal[i+1] << 2 ;
		signal[i+1] = (signal[i+1] & 0b00111111) | 0b10000000;
		i+=2;
	   }while(i<3);

		
}



void DigitalSig (char Signal []){
	
	if (Bit1_GetVal()) Signal[0]=Signal[0] | 0b01000000;
	
	if (Bit2_GetVal()) Signal[2]=Signal[2] | 0b01000000;
}




void main(void)
{
  char byte[4];
  		  

  /*** Processor Expert internal initialization. DON'T REMOVE THIS CODE!!! ***/
  PE_low_level_init();
  /*** End of Processor Expert internal initialization.                    ***/
  for(;;){
	 
	 if(flag){
		  flag=0;
		  
		  AD1_Measure(TRUE);
		  AD1_GetValue(byte);
		  Masksignal(byte);
		  DigitalSig(byte);
	      SendData(byte);
		  
		  
		  
	  }
	  
	  
}

  /*** Don't write any code pass this line, or it will be deleted during code generation. ***/
  /*** RTOS startup code. Macro PEX_RTOS_START is defined by the RTOS component. DON'T MODIFY THIS CODE!!! ***/
  #ifdef PEX_RTOS_START
    PEX_RTOS_START();                  /* Startup of the selected RTOS. Macro is defined by the RTOS component. */
  #endif
  /*** End of RTOS startup code.  ***/
  /*** Processor Expert end of main routine. DON'T MODIFY THIS CODE!!! ***/
  for(;;){}
  /*** Processor Expert end of main routine. DON'T WRITE CODE BELOW!!! ***/
} /*** End of main routine. DO NOT MODIFY THIS TEXT!!! ***/

/* END main */
/*!
** @}
*/
/*
** ###################################################################
**
**     This file was created by Processor Expert 10.3 [05.09]
**     for the Freescale HCS08 series of microcontrollers.
**
** ###################################################################
*/
