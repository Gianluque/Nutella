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
#include "Muestreo.h"
/* Include shared modules, which are used for whole project */
#include "PE_Types.h"
#include "PE_Error.h"
#include "PE_Const.h"
#include "IO_Map.h"


/* User includes (#include below this line is not maintained by Processor Expert) */
char flag=0; 								//Este flag se encagará de realizar el muestreo a 1KHz


// Envio de la data, verifica que la data se ha enviado correctamente, sino, vuelve a enviar.
void SendData(char block[]){
	char error;   							// Variable que verifica si la data fue enviada correctamente
	char ptr;     							// Variable que guarda el tamaño de la data que se ha enviado
	
	do{
		error=AS1_SendBlock(block,4,&ptr);	 // Envio del bloque de data
		
	}while(error!=ERR_OK); 					 // Verificación 
}



//Entramado de la señal 
void Masksignal(char signal[]){
	
	
	       signal[0]   = (signal[0] << 2 | signal[1]>>6);  		// Asignación de los 2 MSB del byte 2 en el los 2 LSB del byte 1
		   signal[0]   = (signal[0] & 0b00111111);				// Enmascarado de la señal 
		   signal[1] = (signal[1] & 0b00111111) | 0b10000000;   // Eliminación de los 2 MSB del byte 2 y enmascarado de la señal
		
		   signal[2]   = (signal[2] << 2 | signal[3]>>6);		// Asignación de los 2 MSB del byte 3 en el los 2 LSB del byte 2
		   signal[2]   = (signal[2] | 0b10000000);				// Enmascarado de la señal 
		   signal[3] = (signal[3] & 0b00111111) | 0b10000000;	// Eliminación de los 2 MSB del byte 2 y enmascarado de la señal
					

		
}


// Verifica si se ha recibido alguna señal de los canales digitales y los asignas en el segundo MSB 
void DigitalSig (char Signal []){
	
	if (Bit1_GetVal()) Signal[0]=Signal[0] | 0b01000000;    
	
	if (Bit2_GetVal()) Signal[2]=Signal[2] | 0b01000000;
}




void main(void)
{
// Data de entrada
  char byte[4];
 
  		  

  /*** Processor Expert internal initialization. DON'T REMOVE THIS CODE!!! ***/
  PE_low_level_init();
  /*** End of Processor Expert internal initialization.                    ***/
  
  // Ciclo que verfica un flag que cumple la funcion de muestreo a 2khz
  
  for(;;){
	 
	 if(flag){
		  flag=0;
		  //Muestreo del ADC de todos los canales que esten en uso
		  AD1_Measure(TRUE);  
		  AD1_GetValue(byte);
		 
		  // Proceso de enmascarado de la señal y adquisicion de la señal digital
		  Masksignal(byte);
		  DigitalSig(byte);
		  // Envio de la data
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
