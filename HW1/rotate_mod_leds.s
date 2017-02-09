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
		
;******************************************************************************** 
; Passed in pointer to LED data on R0, and size of array on R1
; Will rotate led data with led_array_data[0] <-- led_array_data[size-1] and
; led_array_data[1] <-- led_array_data[0], ...  Also modifies data as it 
; rotates it adding 0x08 to red, and subtracting 0x08 from blue, while leaving
; green content unchanged.
;********************************************************************************
	;; TODO -- implement EABI compliant function rotate_mod_leds
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
	
	
	
	
	ENDP
    align
        

    END
        
        
