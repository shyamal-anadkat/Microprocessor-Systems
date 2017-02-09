; Filename:     leds_init.s
; Author:       Shyamal Anadkat
; Description: 

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
	;; TODO -- Implement EABI compliant function init_leds
init_leds PROC
	;init LED color codes 
	; 25- 3F, 50- 7F, 75-BF
	MOV32 R2, #0x00007F00
	STR R2, [R0, #0]
	MOV32 R3, #0x003F7F00
	STR R3, [R0, #4]
	MOV32 R4, #0x007F7F00
	STR R4, [R0, #8]
	MOV32 R5, #0x007F3F00
	STR R5, [R0, #12]
	MOV32 R6, #0x007F0000
	STR R6, [R0, #16]
	MOV32 R7, #0x007F003F
	STR R7, [R0, #20]
	MOV32 R8, #0x007F007F
	STR R8, [R0, #24]
	MOV32 R9, #0x003F007F
	STR R9, [R0, #28]

	;clear the 32-bit value pointed to by update_led_addr
	MOV32 R1, #0
	
	BX LR ; return from the function
	ENDP
		
    END
        
        
