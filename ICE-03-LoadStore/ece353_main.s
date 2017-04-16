; Filename:     main.s 
; Author:       Shyamal Anadkat 
; Description:  

    export __main

;**********************************************
; Add Symbolic Constants here
;**********************************************
BYTE      EQU 1
HALF_WORD EQU 2
WORD      EQU 4
;**********************************************
; SRAM
;**********************************************
    AREA    SRAM, READWRITE
ARRAY1	SPACE	8*HALF_WORD
ARRAY2	SPACE	8*HALF_WORD
    align
        
;**********************************************
; Constant Variables (FLASH) Segment
;**********************************************
    AREA    FLASH, CODE, READONLY
LTABLE	DCW 0
		DCW 1
		DCW 8
		DCW 27
		DCW 64
		DCW 125
		DCW 216
		DCW 343	
    align
 
;**********************************************
; Code (FLASH) Segment
; main assembly program
;**********************************************
__main   PROC
	ADR	R0, LTABLE
	LDR R1, =(ARRAY1)
	LDR R2, =(ARRAY2)
	
	LDRH R10, [R0, #12] ;Place 0xD8 into R10 using LTABLE.
	
	;Copy the contents of LTABLE into ARRAY1 using the half word versions of LDR/STR.  
	;Use pre-indexed load/stores
	LDRH R3, [R0, #0*HALF_WORD]
	STRH R3, [R1, #0*HALF_WORD]
	LDRH R3, [R0, #2*HALF_WORD]
	STRH R3, [R1, #2*HALF_WORD]
	LDRH R3, [R0, #4*HALF_WORD]
	STRH R3, [R1, #4*HALF_WORD]
	LDRH R3, [R0, #6*HALF_WORD]
	STRH R3, [R1, #6*HALF_WORD]
	LDRH R3, [R0, #8*HALF_WORD]
	STRH R3, [R1, #8*HALF_WORD]
	
	;Copy the contents of LTABLE into ARRAY2 using the half word versions of LDR/STR.  
	;Use post-indexed load/stores
    LDRH R3, [R0], #2
	STRH R3, [R2], #2
	LDRH R3, [R0], #2
	STRH R3, [R2], #2
    LDRH R3, [R0], #2
	STRH R3, [R2], #2
    LDRH R3, [R0], #2
	STRH R3, [R2], #2
    ; DO NOT MODIFY ANTHING BELOW THIS LINE!!!	
        
INFINITE_LOOP
    B INFINITE_LOOP
    
    ENDP
    align
        

    END            