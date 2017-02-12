; Filename:     ece353_hw1
; Author:       Shyamal Anadkat 
; Description:  

    export hw1
	export WS2812B_LEDS
	export UPDATE_LEDS
	import init_leds
	import rotate_mod_leds
	import write_leds
;******************************************************************************** 
; SRAM
;******************************************************************************** 
    AREA    SRAM, READWRITE
WS2812B_LEDS 	SPACE	32		; Space for 32-bit commands (24-bits used) for 8 NeoPixels
UPDATE_LEDS		SPACE	4
    align
		
        
;******************************************************************************** 
; Constant Variables (FLASH) Segment
;******************************************************************************** 
    AREA    FLASH, CODE, READONLY
    align
		
;****************************************
; Rename registers for coad readability *
;****************************************
LEDS      RN R0	
UPDATE    RN R1	 
GPIO 	  RN R2
  
;******************************************************************************** 
; function hw1
;  
; Description: 
;		main
; Parameters:		
; Returns: 
;******************************************************************************** 
hw1   PROC
	
	;Setup argument to pass to init_leds
	LDR  LEDS, =(WS2812B_LEDS)
	LDR  UPDATE, =(UPDATE_LEDS)
	
	;call init_leds routine	
    BL init_leds
	MOV R1, #8 

infinite_loop

	;check if update_leds is non-zero to continue 
    LDR  UPDATE, =(UPDATE_LEDS)
	MOV R3, #0
	CMP R3, UPDATE
	BEQ infinite_loop
	
	CPSID I 
	
	;set update-leds to 0 
	MOV32 R9, #0x00000000
	STR R9, [UPDATE]
	
	;call rotate_mod_leds
	MOV R1, #8 
	BL rotate_mod_leds
	
	MOV32 GPIO, #0x400073FC ;3rd arg 
	BL write_leds
	
	CPSIE I 
	B		infinite_loop
	
    ENDP
    align
        

    END
        
        
