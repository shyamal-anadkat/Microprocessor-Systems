// Copyright (c) 2015-16, Joe Krachey
// All rights reserved.
//
// Redistribution and use in source or binary form, with or without modification, 
// are permitted provided that the following conditions are met:
//
// 1. Redistributions in source form must reproduce the above copyright 
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

#include "main.h"

char individual[] = "Shyamal Anadkat";

//*****************************************************************************
//*****************************************************************************
int 
main(void)
{
  char msg1[] = "This is easy";
	char msg2[] = "This is a little trickier";
  char msg3[] = "Krachey's HW2 was harder so don't complain!";
  initialize_serial_debug();

  lcd_config_gpio();

    // Run validation code
  if( validate_ice(ICE_GPIO_PORT) == false)
  {
    while(1){
    };
  }
  put_string("\n\r");
  put_string("************************************\n\r");
  put_string("ECE353 - Fall 2016 HW2\n\r  ");
  put_string("\n\rName:");
  put_string(individual);
  put_string("\n\r");  
  put_string("************************************\n\r");
  
  lcd_config_screen();
  lcd_clear_screen(LCD_COLOR_BLACK);
  
  lcd_print_stringXY(msg1,1,5,LCD_COLOR_YELLOW,LCD_COLOR_BLACK);
  lcd_print_stringXY(msg2,9,8,LCD_COLOR_GREEN,LCD_COLOR_BLACK);
	lcd_print_stringXY(msg3,1,18,LCD_COLOR_YELLOW,LCD_COLOR_BROWN);
  
  // Reach infinite loop
  while(1){};
}
