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
  
;******************************************************************************** 
;******************************************************************************** 
hw1   PROC

	;; TODO -- Setup argument to pass to init_leds
	LDR  R0, =(WS2812B_LEDS)
	LDR  R1, =(UPDATE_LEDS)
	;; TODO -- call init_leds routine
    BL init_leds
infinite_loop
	;; TODO -- do stuff specified in HW1 problem statement
	BL write_leds
	B		infinite_loop
	
    ENDP
    align
        

    END
        
        
