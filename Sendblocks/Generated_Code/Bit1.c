/* ###################################################################
**     THIS COMPONENT MODULE IS GENERATED BY THE TOOL. DO NOT MODIFY IT.
**     Filename    : Bit1.c
**     Project     : Sendblocks
**     Processor   : MC9S08QE128CLK
**     Component   : BitIO
**     Version     : Component 02.086, Driver 03.27, CPU db: 3.00.067
**     Compiler    : CodeWarrior HCS08 C Compiler
**     Date/Time   : 2019-02-25, 13:54, # CodeGen: 16
**     Abstract    :
**         This component "BitIO" implements an one-bit input/output.
**         It uses one bit/pin of a port.
**         Methods of this component are mostly implemented as a macros
**         (if supported by target language and compiler).
**     Settings    :
**         Used pin                    :
**             ----------------------------------------------------
**                Number (on package)  |    Name
**             ----------------------------------------------------
**                       59            |  PTA3_KBI1P3_SCL1_ADP3
**             ----------------------------------------------------
**
**         Port name                   : PTA
**
**         Bit number (in port)        : 3
**         Bit mask of the port        : $0008
**
**         Initial direction           : Input (direction can be changed)
**         Safe mode                   : yes
**         Initial output value        : 1
**         Initial pull option         : up
**
**         Port data register          : PTAD      [$0000]
**         Port control register       : PTADD     [$0001]
**
**         Optimization for            : speed
**     Contents    :
**         SetDir - void Bit1_SetDir(bool Dir);
**         GetVal - bool Bit1_GetVal(void);
**         PutVal - void Bit1_PutVal(bool Val);
**         ClrVal - void Bit1_ClrVal(void);
**         SetVal - void Bit1_SetVal(void);
**         NegVal - void Bit1_NegVal(void);
**
**     Copyright : 1997 - 2014 Freescale Semiconductor, Inc. 
**     All Rights Reserved.
**     
**     Redistribution and use in source and binary forms, with or without modification,
**     are permitted provided that the following conditions are met:
**     
**     o Redistributions of source code must retain the above copyright notice, this list
**       of conditions and the following disclaimer.
**     
**     o Redistributions in binary form must reproduce the above copyright notice, this
**       list of conditions and the following disclaimer in the documentation and/or
**       other materials provided with the distribution.
**     
**     o Neither the name of Freescale Semiconductor, Inc. nor the names of its
**       contributors may be used to endorse or promote products derived from this
**       software without specific prior written permission.
**     
**     THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
**     ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
**     WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
**     DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
**     ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
**     (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
**     LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
**     ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
**     (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
**     SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**     
**     http: www.freescale.com
**     mail: support@freescale.com
** ###################################################################*/
/*!
** @file Bit1.c
** @version 03.27
** @brief
**         This component "BitIO" implements an one-bit input/output.
**         It uses one bit/pin of a port.
**         Methods of this component are mostly implemented as a macros
**         (if supported by target language and compiler).
*/         
/*!
**  @addtogroup Bit1_module Bit1 module documentation
**  @{
*/         

/* MODULE Bit1. */

#include "Bit1.h"
  /* Including shared modules, which are used in the whole project */
#include "PE_Types.h"
#include "PE_Error.h"
#include "PE_Const.h"
#include "IO_Map.h"
#include "Cpu.h"


/*
** ===================================================================
**     Method      :  Bit1_GetVal (component BitIO)
**     Description :
**         This method returns an input value.
**           a) direction = Input  : reads the input value from the
**                                   pin and returns it
**           b) direction = Output : returns the last written value
**     Parameters  : None
**     Returns     :
**         ---             - Input value. Possible values:
**                           FALSE - logical "0" (Low level)
**                           TRUE - logical "1" (High level)

** ===================================================================
*/
/*
bool Bit1_GetVal(void)

**  This method is implemented as a macro. See Bit1.h file.  **
*/

/*
** ===================================================================
**     Method      :  Bit1_PutVal (component BitIO)
**     Description :
**         This method writes the new output value.
**           a) direction = Input  : sets the new output value;
**                                   this operation will be shown on
**                                   output after the direction has
**                                   been switched to output
**                                   (SetDir(TRUE);)
**           b) direction = Output : directly writes the value to the
**                                   appropriate pin
**     Parameters  :
**         NAME       - DESCRIPTION
**         Val             - Output value. Possible values:
**                           FALSE - logical "0" (Low level)
**                           TRUE - logical "1" (High level)
**     Returns     : Nothing
** ===================================================================
*/
void Bit1_PutVal(bool Val)
{
  if (Val) {
    setReg8Bits(PTAD, 0x08U);          /* PTAD3=0x01U */
    Shadow_PTA |= 0x08U;               /* Set-up shadow variable */
  } else { /* !Val */
    clrReg8Bits(PTAD, 0x08U);          /* PTAD3=0x00U */
    Shadow_PTA &= 0xF7U;               /* Set-up shadow variable */
  } /* !Val */
}

/*
** ===================================================================
**     Method      :  Bit1_ClrVal (component BitIO)
**     Description :
**         This method clears (sets to zero) the output value.
**           a) direction = Input  : sets the output value to "0";
**                                   this operation will be shown on
**                                   output after the direction has
**                                   been switched to output
**                                   (SetDir(TRUE);)
**           b) direction = Output : directly writes "0" to the
**                                   appropriate pin
**     Parameters  : None
**     Returns     : Nothing
** ===================================================================
*/
/*
void Bit1_ClrVal(void)

**  This method is implemented as a macro. See Bit1.h file.  **
*/

/*
** ===================================================================
**     Method      :  Bit1_SetVal (component BitIO)
**     Description :
**         This method sets (sets to one) the output value.
**           a) direction = Input  : sets the output value to "1";
**                                   this operation will be shown on
**                                   output after the direction has
**                                   been switched to output
**                                   (SetDir(TRUE);)
**           b) direction = Output : directly writes "1" to the
**                                   appropriate pin
**     Parameters  : None
**     Returns     : Nothing
** ===================================================================
*/
/*
void Bit1_SetVal(void)

**  This method is implemented as a macro. See Bit1.h file.  **
*/

/*
** ===================================================================
**     Method      :  Bit1_NegVal (component BitIO)
**     Description :
**         This method negates (inverts) the output value.
**           a) direction = Input  : inverts the output value;
**                                   this operation will be shown on
**                                   output after the direction has
**                                   been switched to output
**                                   (SetDir(TRUE);)
**           b) direction = Output : directly inverts the value
**                                   of the appropriate pin
**     Parameters  : None
**     Returns     : Nothing
** ===================================================================
*/
/*
void Bit1_NegVal(void)

**  This method is implemented as a macro. See Bit1.h file.  **
*/

/*
** ===================================================================
**     Method      :  Bit1_SetDir (component BitIO)
**     Description :
**         This method sets direction of the component.
**     Parameters  :
**         NAME       - DESCRIPTION
**         Dir        - Direction to set (FALSE or TRUE)
**                      FALSE = Input, TRUE = Output
**     Returns     : Nothing
** ===================================================================
*/
void Bit1_SetDir(bool Dir)
{
  if (Dir) {
    setReg8(PTAD, (getReg8(PTAD) & (byte)(~(byte)0x08U)) | (Shadow_PTA & 0x08U)); /* PTAD3=Shadow_PTA[bit 3] */
    setReg8Bits(PTADD, 0x08U);         /* PTADD3=0x01U */
  } else { /* !Dir */
    clrReg8Bits(PTADD, 0x08U);         /* PTADD3=0x00U */
  } /* !Dir */
}


/* END Bit1. */
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