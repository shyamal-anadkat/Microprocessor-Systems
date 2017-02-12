; Filename:     leds_rotate.s
; Author:       Shyamal Anadkat
; Description:  Rotates leds by 1 index

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
UPDATE_COLOR	RN R3
RED				RN R4
BLUE			RN R5
PREV_INDEX  	RN R6
POST_INDEX		RN R7
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
	PUSH {R4-R12} ; save reg
	
	SUB R12, ARRAY_SIZE, #1 ;arraysize -1 
	MOV RED	, #0x00000800  ;change in red
	MOV BLUE, #0x00000008  ;change in blue
	MOV R9, #4
	
	;led_array[0] <- led_arrat[size-1] - 0x08 on red, + 0x08 on blue
	MUL R11, R9, R12
	LDR UPDATE_COLOR, [LED_ARRAY_ADDR, R11] ; R3 = ledarray[size-1] 
	SUB UPDATE_COLOR, UPDATE_COLOR, RED     ; -0x08 on red 
	ADD UPDATE_COLOR, UPDATE_COLOR, BLUE    ; +0x08 on blue 
	LDR PREV, [LED_ARRAY_ADDR, #0]          ; store previous led data
	STR UPDATE_COLOR, [LED_ARRAY_ADDR, #0]  ; write to led_addr
	
	MOV PREV_INDEX , #0       ; counter 
	MOV POST_INDEX, #0
	
LOOP_BEGIN
    ; till array_size -1
	ADD PREV_INDEX , PREV_INDEX , #4   ; increment counter
	MUL R11, ARRAY_SIZE, R9
	CMP PREV_INDEX , R11
	BEQ LOOP_END
	
	; led[POST_INDEX] = led[PREV_INDEX] - 0x08 on red, + 0x08 on blue 
	MOV UPDATE_COLOR, PREV
	SUB UPDATE_COLOR, UPDATE_COLOR, RED     ; -0x08 on red 
	ADD UPDATE_COLOR, UPDATE_COLOR, BLUE    ; +0x08 on blue 
	LDR PREV, [LED_ARRAY_ADDR, PREV_INDEX ] ; persist previous led data
	STR UPDATE_COLOR, [LED_ARRAY_ADDR, PREV_INDEX ] ; write to led_addr
	
	ADD POST_INDEX, POST_INDEX, #4   ; increment cntr
	B LOOP_BEGIN					 ; branch to begin 
LOOP_END

	POP {R4-R12} ; restore regs
	BX LR ;return from function
	ENDP
    align
        

    END
        
        
