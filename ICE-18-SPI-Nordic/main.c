// Copyright (c) 2014, Joe Krachey
// All rights reserved.
//
// Redistribution and use in binary form, with or without modification, 
// are permitted provided that the following conditions are met:
//
// 1. Redistributions in binary form must reproduce the above copyright 
//    notice, this list of conditions and the following disclaimer in 
//    the documentation and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR 
// PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR 
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; 
// OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
// WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
// EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

//*****************************************************************************
// main.c
// Author: jkrachey@wisc.edu
//*****************************************************************************
#include "main.h"

#define TX_MODE  true

/******************************************************************************
 * Global Variables
 *****************************************************************************/
// ADD CODE
uint8_t myID[]      = { 3,5,3,0,0};
uint8_t remoteID[]  = { 3,5,3,0,1};

//*****************************************************************************
//*****************************************************************************
void DisableInterrupts(void)
{
  __asm {
         CPSID  I
  }
}

//*****************************************************************************
//*****************************************************************************
void EnableInterrupts(void)
{
  __asm {
    CPSIE  I
  }
}


//*****************************************************************************
//*****************************************************************************
void initializeBoard(void)
{
  DisableInterrupts();
  init_serial_debug(true, true);

  spi_select_init();
  spi_select(NORDIC);
  wireless_initialize();
  SysTick_Config(10000000);
  EnableInterrupts();
}


//*****************************************************************************
//*****************************************************************************
int 
main(void)
{                     
  wireless_com_status_t status;
  uint32_t data;
  int i = 0;
  bool validate;
  
  initializeBoard();
  
  validate = validate_ice(ICE_SPI_NORDIC);
  if( validate == false)
  {
    //while(1){};
  }
  
  printf("\n\r");
  printf("**************************************\n\r");
  printf("* ECE353 - SPI ICE\n\r");
  printf("**************************************\n\r");
  printf("\n\r");
  
  printf("MyID:%i%i%i%i%i\n\r",myID[0],myID[1],myID[2],myID[3],myID[4]);
  printf("RmID:%i%i%i%i%i\n\r",remoteID[0],remoteID[1],remoteID[2],remoteID[3],remoteID[4]);
  
  wireless_configure_device(myID, remoteID ) ;
  
  printf("\n\r");
  
  if(TX_MODE)
  {
    printf("Tx Mode\n\r");
  }
  else
  {
    printf("Rx Mode\n\r");
  }

  // Infinite Loop
  while(1)
  {

      if(TX_MODE && AlertOneSec)
      {
          printf("Sending: %d\n\r",i);
          status = wireless_send_32(false, false, i);
          if(status != NRF24L01_TX_SUCCESS)
          {
            printf("Error Message: %s\n\r",wireless_error_messages[status]);
          }
          AlertOneSec = false;
          i++;
      }
      else if (!TX_MODE)
      {
        status =  wireless_get_32(false, &data);
        if(status == NRF24L01_RX_SUCCESS)
        {
            printf("Received: %d\n\r", data);
        }
        
        AlertOneSec = false;
      }
    }
}
