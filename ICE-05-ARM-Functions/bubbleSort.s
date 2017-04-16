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
	 LDRB R8, [R7, #0]
	 LDRB R9, [R7, #1]
	 
	 ; Check to see if next value if less than curr value 
	 CMP R9, R8
	 
	 ; if so, swap values 
	 STRBLO R8, [R7, #1]
	 STRBLO R9, [R7, #0]

	 
	 BX LR

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
 
	 SUB R1, R1, #1 

while1_start 
	 
	 ;if reached end of array 
	 CMP R1, #0
	 BEQ while1_end
	 
while2_start
	 MOV R4, #0 
	 
	 CMP R4, R1
	 BHS while2_end
	 
	 ADD R7, R0, R4
	 
	 BL swap_values
	 
	 ADD R4, R4, #1 
	 
	 B while2_start
while2_end
	 SUB R1, R1, #1
	 B while1_start
while1_end

     
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

