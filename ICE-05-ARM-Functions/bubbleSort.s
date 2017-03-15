export bubble_sort
export swap_values
        
    AREA    FLASH, CODE, READONLY
    ALIGN
        

;******************************************************************************
; Description
;     Given the address in R7, it will read the unsigned byte at R7 and R7 + 1.
;     If [R7] > [R7 + 1], swap the values
;
;     Modify only registers R8 or greater.
;
; Parameters
;   R7 - Array Address
;
; Returns
;   Nothing
;******************************************************************************
swap_values PROC
     ;---------------------------------------
     ; START ADD CODE
     ;---------------------------------------
     
	 ; load current and next byte 
	 LDR R8, [R7]
	 LDR R9, [R7, #1]
	 
	 ; Check to see if next value if less than curr value 
	 CMP R9, R8
	 
	 ; if so, swap values 
	 MOVLO R10, R9
	 MOVLO R9, R8
	 MOVLO R8, R10 
     
     ;---------------------------------------
     ; END ADD CODE
     ;---------------------------------------
    ENDP


    
;******************************************************************************
; Description
;   Uses Bubble Sort to sort an array of unsigned 8-bit numbers.
;
;   Modify only registers R0-R7
;
; Parameters
;   R0 - Array Address
;   R1 - Array Size
;
; Returns
;   Nothing
;******************************************************************************
bubble_sort PROC

    ; Save registers
     PUSH   {R0-R12, LR}
     
     ;---------------------------------------
     ; START ADD CODE
     ;---------------------------------------
     ;verify if array addr != 0 
	 CMP R0, #0
     BXEQ LR 
	 
	 MOV R7, R0 
	 MOV R2, #1

while_start 
	 ;if reached end of array 
	 CMP R2, R1
	 BHS while_end
	 
	 LDR R3, =(swap_values)
	 BLX R3
	 
	 ;increment counter 
	 ADD R2, R2, #1

while_end
     
     
     ; NOTE: The return from the function is already
     ; provided below
     
     ;---------------------------------------
     ; END ADD CODE
     ;---------------------------------------
     
    
    ; Restore Registers
    POP     {R0-R12, LR}
    
    ; Return from the function
    BX      LR
    
    ENDP
         
    END     

