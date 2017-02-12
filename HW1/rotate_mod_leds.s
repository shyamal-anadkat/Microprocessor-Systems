; Filename:     leds_rotate.s
; Author:       Shyamal Anadkat
; Description:  

	export rotate_mod_leds
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
ARRAY_SIZE  	RN R1	; passed in as argument
RED				RN R4
BLUE			RN R5
PREV			RN R10
		
;******************************************************************************** 
; Passed in pointer to LED data on R0, and size of array on R1
; Will rotate led data with led_array_data[0] <-- led_array_data[size-1] and
; led_array_data[1] <-- led_array_data[0], ...  Also modifies data as it 
; rotates it adding 0x08 to red, and subtracting 0x08 from blue, while leaving
; green content unchanged.
;********************************************************************************
	;; implement EABI compliant function rotate_mod_leds
;******************************************************************************** 
; function rotate_mod_leds
;  
; Description: 
;		rotates array of LED colors by index of 1
; Parameters:
;		RO - address of led array 
;		R1 - array size 		
; Returns: 
;
;******************************************************************************** 
rotate_mod_leds PROC
	PUSH {R2-R11} ; save reg
	SUB R2, ARRAY_SIZE, #1 ;arraysize -1 
	MOV RED	, #0x00000800
	MOV BLUE, #0x00000008
	MOV R9, #4
	
	MUL R11, R9, R2
	LDR R3, [LED_ARRAY_ADDR, R11] ; R3 = ledarray[size-1] 
	;SUB R3, R3, RED   ; -0x08 on red 
	;ADD R3, R3, BLUE   ; +0x08 on blue 
	LDR PREV, [LED_ARRAY_ADDR, #0]
	STR R3, [LED_ARRAY_ADDR, #0] ; write to addr
	
	MOV R6, #0       ; counter 
	MOV R7, #0
LOOP_BEGIN
    ; till array_size -1
	ADD R6, R6, #4   ; increment counter
	MUL R8, ARRAY_SIZE, R9
	CMP R6, R8
	BEQ LOOP_END
	
	; led[R7] = led[R6] - 0x08 on red, + 0x08 on blue 
	MOV R3, PREV
	;SUB R3, R3, RED   ; -0x08 on red 
	;ADD R3, R3, BLUE   ; +0x08 on blue 
	LDR PREV, [LED_ARRAY_ADDR, R6]
	STR R3, [LED_ARRAY_ADDR, R6] ;  write to addr
	
	ADD R7, R7, #4   ; increment cntr
	B LOOP_BEGIN
LOOP_END

	POP {R2-R11} ; restore regs
	BX LR ;return from function
	ENDP
    align
        

    END
        
        
