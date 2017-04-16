; Filename:     addMultiply.s 
; Author:       Shyamal Anadkat 
; Description:  

    export addMultiply

;**********************************************
; SRAM
;**********************************************
    AREA    SRAM, READWRITE
    align
        
;**********************************************
; Constant Variables (FLASH) Segment
;**********************************************
    AREA    FLASH, CODE, READONLY
    align


;**********************************************
; Four arrays of 8-bit signed numbers are 
; passed via the first four paramters.
; The 5th paramter indicates the length of the
; arrays. For each entry in the array, the
; following operation takes place.
;
; Array3[i] = (Array0[i] + Array1[i]) * Array2[i]
;
; Parameter 0       Array Address 0
; Parameter 1       Array Address 1
; Parameter 2       Array Address 2
; Parameter 3       Array Address 3
; Parameter 4       Array Size 
;
; Returns
;   if ALL parameters are valid, return 0
;   else return -1.
;
;  An address is valid if it is non zero
;  The size is valid if it is greater than zero
;**********************************************
addMultiply PROC
    
    ; Validate Parameters
	; Return -1 if error
	; Return 0 if success
	MOV R5, #-1
	MOV R6, #0
	
	CMP R0, #0
	MOVEQ R0, R5
	BEQ LOOP_END
	CMP R1, #0
	MOVEQ R0, R5
	BEQ LOOP_END
	CMP R2, #0
	MOVEQ R0, R5 
	BEQ LOOP_END
	CMP R3, #0
	MOVEQ R0, R5
	BEQ LOOP_END
	LDRB R4, [SP]
	CMP R4, #0
	MOVLE R0, R5
	BLE LOOP_END
	
    ; Save required registers
    PUSH {R4-R10}
	
    ; For each index in the arrays, compute  
    ; Array3[i] = (Array0[i] + Array1[i]) * Array2[i]
	
	MOV R7, #0 ;loop counter 
LOOP_START
	;check if not reached array size, return 0 for success
	CMP R7, R4
	MOVEQ R0, R6 ; return 0 if success, -1 if something wrong 
	BEQ LOOP_END

	; load array vals at index R7 
	LDRB R8, [R0, R7]  ;0
	LDRB R9, [R1, R7]  ;1
	LDRB R10,[R2, R7]  ;2
	
	; Array3[i] = (Array0[i] + Array1[i]) * Array2[i]
	ADD R8, R8, R9
	MUL R8, R8, R10 
	STRB R8, [R3, R7]
	
	;increment index and branch to start 
	ADD R7, R7, #1
	B LOOP_START
LOOP_END
	
    ; Restore registers saved to the stack
    POP {R4-R10}
    ; Return from the loop
	BX LR 
    ENDP
    align
        

    END            
