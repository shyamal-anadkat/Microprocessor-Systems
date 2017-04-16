//*****************************************************************************
// main.c
// Author: Shyamal Anadkat
//*****************************************************************************
#include <stdio.h>
#include <stdint.h>
#include <string.h>

#include "TM4C123.h"
#include "driver_defines.h"
#include "validate.h"

/******************************************************************************
 * Includes
 *****************************************************************************/
//include ws2812b.h in main.c
#include "ws2812b.h"

/******************************************************************************
 * MACROS
 *****************************************************************************/
 // ADD CODE 03: MACRO
#define    NUM_LEDS    8

/******************************************************************************
 * Global Variables
 *****************************************************************************/
// ADD CODE 04
WS2812B_t LEDs[NUM_LEDS];


//*****************************************************************************
// External Functions
//*****************************************************************************
extern void WS2812B_write(uint32_t port_base_addr, uint8_t *led_array_base_addr, uint16_t num_leds);

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
int 
main(void)
{
  int i;
  
  // ADD CODE 05 (initialize LED color intensities)
		LEDs[0].green = 0x00;
		LEDs[0].red = 0x00;
		LEDs[0].blue = 0x80;
		LEDs[1].green = 0x00;
		LEDs[1].red = 0x80;
		LEDs[1].blue = 0x00;
		LEDs[2].green = 0x00;
		LEDs[2].red = 0x80;
		LEDs[2].blue = 0x80;
		LEDs[3].green = 0x80;
		LEDs[3].red = 0x00;
		LEDs[3].blue = 0x00;
		LEDs[4].green = 0x80;
		LEDs[4].red = 0x00;
		LEDs[4].blue = 0x80;
		LEDs[5].green = 0x80;
		LEDs[5].red = 0x80;
		LEDs[5].blue = 0x00;
		LEDs[6].green = 0x80;
		LEDs[6].red = 0x80;
		LEDs[6].blue = 0x80;
		LEDs[7].green = 0x40;
		LEDs[7].red = 0x20;
		LEDs[7].blue = 0x80;
  
	if( validate_ice(ICE_INTRO_TO_C) == false)
	{
		// Error in configuing the board, so enter infinite loop.
		DisableInterrupts();
		while(1){};
	}
  put_string("\n\r\n\r");
  put_string("**************************************\n\r");
  put_string("* ECE353: ICE-08-Intro-To-C\n\r");
  put_string("**************************************\n\r");

  
  // Infinite Loop
  while(1){
    // ADD CODE 06
		WS2812B_write(WS2812B_GPIO_ADDR,(uint8_t *)LEDs, 8);
	  
    // ADD CODE 07
		ws2812b_rotate(LEDs, 8);
		ws2812b_pulse(LEDs, 8);

    // ADD CODE 08
		for(i = 0; i < 80000; i++) {
			
		}
  };
}
