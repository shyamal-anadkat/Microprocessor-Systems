; Filename:     ece353_hw1
; Author:       Shyamal Anadkat 
; Description:  hw1.s

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
ZERO 	  RN R4
  
;******************************************************************************** 
; function hw1
;  
; Description: main execution
;
; Parameters:		
; Returns: 
;******************************************************************************** 
hw1   PROC
	
	;Setup argument to pass to init_leds
	LDR  LEDS,   =(WS2812B_LEDS)		;load address of LEDS into R0 
	LDR  UPDATE, =(UPDATE_LEDS)		    ;load address of UPDATE_LEDS into R1
	
	;call init_leds routine	
	PUSH {LEDS,UPDATE}					;EABI caller save
    BL init_leds					    ;call init_leds with params R0, R1	
	POP {LEDS, UPDATE}					;EABI caller restore
	
infinite_loop

	;Check if update_leds is non-zero to continue 
	LDR  UPDATE, =(UPDATE_LEDS)			;init UPDATE_LEDS
	LDR  R5, [UPDATE] 				    ;get value of UPDATE_LEDS into R5
	MOV ZERO, #0           				;move 0 to R4 to compare
	CMP ZERO, R5						;check if UPDATE_LEDS value is zero 
	BEQ infinite_loop				    ;if so, branch to start of infinite loop 
	
	;Execute the assembly instruction “CPSID I” 
	CPSID I 
	
	;Set update-leds to 0 
	STR ZERO, [UPDATE]
	
	;Call rotate_mod_leds
	LDR  LEDS, =(WS2812B_LEDS)	        ;init first arg
	MOV UPDATE, #8					    ;pass in second parameter 
	PUSH {R0,R1}						;EABI store reg
	BL rotate_mod_leds					;call rotate_mod_leds
	POP {R0,R1}							;EABI restore reg
	
	;Call write_leds 
	LDR  LEDS, =(WS2812B_LEDS)          ;init 1st arg
	MOV UPDATE, #8	                    ;init 2nd argument
	MOV32 GPIO, #0x400073FC 			;pass in 3rd arg 
	PUSH {R0-R3}						;EABI save reg
	BL write_leds						;call writ_leds
	POP {R0-R3}						    ;EABI restore reg
	
	;Execute the assembly instruction “CPSIE I”. 
	CPSIE I 
	B		infinite_loop
	BX LR  ;return
    ENDP
    align
        
    END