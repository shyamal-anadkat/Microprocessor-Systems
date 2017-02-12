; Filename:     leds_init.s
; Author:       Shyamal Anadkat
; Description:  Initilaizes LED color codes

	export init_leds
;******************************************************************************** 
; SRAM
;******************************************************************************** 
    AREA    SRAM, READWRITE
    align
        
;******************************************************************************** 
; Constant Variables (FLASH) Segment
;******************************************************************************** 
    AREA    FLASH, CODE, READONLY
    align
		
;****************************************
; Rename registers for coad readability *
;****************************************
LED_ARRAY_ADDR 	RN R0	; passed in as argument
UPDATE_LED_ADDR	RN R1	; passed in as argument
		
;******************************************************************************** 
; function init_leds
;  
; Description: 
;		initializes color codes for each led 
; Parameters:
;		RO - address of led array 
;		R1 - address of update led array		
; Returns: 
;
;******************************************************************************** 
init_leds PROC
	PUSH {R4-R10}  ; save regs used 
	
	;init LED color codes 
	;25- 3F, 50- 7F, 75 - BF
	MOV32 R10, #0x00007F00
	STR R10, [LED_ARRAY_ADDR, #0]
	MOV32 R11, #0x003F7F00
	STR R11, [LED_ARRAY_ADDR, #4]
	MOV32 R4, #0x007F7F00
	STR R4, [LED_ARRAY_ADDR, #8]
	MOV32 R5, #0x007F3F00
	STR R5, [LED_ARRAY_ADDR, #12]
	MOV32 R6, #0x007F0000
	STR R6, [LED_ARRAY_ADDR, #16]
	MOV32 R7, #0x007F003F
	STR R7, [LED_ARRAY_ADDR, #20]
	MOV32 R8, #0x007F007F
	STR R8, [LED_ARRAY_ADDR, #24]
	MOV32 R9, #0x003F007F
	STR R9, [LED_ARRAY_ADDR, #28]

	;clear the 32-bit value pointed to by update_led_addr
	MOV32 R9, #0x00000000
	STR R9, [UPDATE_LED_ADDR]
	
	POP {R4-R10} ; restore regs used
	BX LR ; return from the function
	ENDP
		
    END
        
        
