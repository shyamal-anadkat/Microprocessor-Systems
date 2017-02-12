; Filename:     leds_write.s
; Author:       Shyamal Anadkat
; Description:  

	export write_leds
;******************************************************************************** 
; Constant Variables (FLASH) Segment
;******************************************************************************** 
    AREA    FLASH, CODE, READONLY
    align
		
;****************************************
; Rename registers for coad readability *
;****************************************
LED_ARRAY_ADDR 	RN R0	; passed in as argument
NUM_LEDS		RN R1	; passed in as argument
GPIO_ADDR		RN R2	; passed in as argument
LED_INDEX		RN R3	; working index for accessing LED data
LED_DATA		RN R4	; stores LED color data
LOGIC_HIGH		RN R5	; used to store a 0x80 for writing logic high to GPIO
LOGIC_LOW		RN R6	; used to store a 0x00 for wrting logic low to GPIO
DELAY_INDX		RN R7	; used as index in delay loops
BIT_INDX		RN R8	; used as bit index for 24-bit loop

;********************************************************************************
; function write_leds
;  
; Description: 
;		writes to leds and maintains neopixels
; Parameters:	
; Returns: 
;********************************************************************************        
write_leds   PROC
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; LED_ARRAY_ADDR will be passed value of led_array_addr ;;
	;; NUM_LEDS will be passed array size (number of LEDs)   ;;
	;; GPIO_ADDR will be passed the address of the GPIO port ;;
	;; the LEDs are connected to                             ;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	PUSH {R0-R8}  ; Store off registers modified to mLake EABI compliant

	MOV		LOGIC_HIGH, #0x80		; used to write a 1 to port pin
	MOV		LOGIC_LOW, #0x00		; used to write a 0 to port pin
	ADD		LED_INDEX, NUM_LEDS, #1	; start LED_INDEX at NUM_LEDS+1 because decremented immediately in loop
	
write_loop								; for number of NeoPixels to write
	SUBS	LED_INDEX, LED_INDEX, #1	; subtract 1 from index
	CMP		LED_INDEX, #0				; is index zero...
	BEQ		done_write					;    if so we are done
	LDR		LED_DATA, [LED_ARRAY_ADDR], #4	; read 24-bit LED data and increment pointer to next LED data
	MOV		BIT_INDX, #24			; index on bit loop for 24 bits in a LED
	
bit_loop
	STRB	LOGIC_HIGH, [GPIO_ADDR]		; all NeoPixel bits begin with logic high write to GPIO
	TST		LED_DATA, #0x00800000		; is MSB of LED_DATA set
	MOV		LED_DATA, LED_DATA, LSL #1	; shift register left to get to next bit
	BEQ		write_zero					; if MSB of data was not set we write logic zero to serial out
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Below is write a "1" to NeoPixel ;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	MOV		DELAY_INDX, #8			; currently at 4 clock cycles of high, need 40 total, (8-1)*4+2 = 30 clock cycles
high_delay1					; loop below takes (N-1)*4+2 clock cycles.  Using N of 7, to get 30 cyles of delay
	SUBS	DELAY_INDX, DELAY_INDX, #1
	BNE		high_delay1
	;; Add 6 NOPs to flush out needed delay for total of 40 clocks with logic high on pin
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	STRB	LOGIC_LOW,	[GPIO_ADDR]		; clear GPIO pin as part of a write of "1" to LED, now need 22 low cycles
	MOV		DELAY_INDX, #3				; (3-1)*4+2 = 10 clock cycles delay, need 22 low prior to next write of "1"
low_delay1
	SUBS	DELAY_INDX, DELAY_INDX, #1
	BNE		low_delay1
	NOP
	SUBS	BIT_INDX, BIT_INDX, #1		; decrement bit index
	BEQ		write_loop					; done with this 24-bits of LED data, move on to next 24-bits of LED data
	; NOPs to flush out needed delay for total of 22 clocks with logic low on pin
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
    B		bit_loop
	
write_zero
	MOV		DELAY_INDX, #3			; (3-1)*4+2 = 10 clock cycles delay, at 6 by end of this instr, need 20 high
high_delay0
	SUBS	DELAY_INDX, DELAY_INDX, #1
	BNE		high_delay0
	; NOPs to flush out needed delay for total of 20 clocks with logic high on pin
	NOP
	NOP
	NOP
	NOP
	STRB	LOGIC_LOW,	[GPIO_ADDR]	; clear GPIO pin
	MOV		DELAY_INDX, #8			; (8-1)*4+2 = 30 clock cycles, need 42 low
low_delay0
	SUBS	DELAY_INDX, DELAY_INDX, #1
	BNE		low_delay0
	NOP
	SUBS	BIT_INDX, BIT_INDX, #1	; decrement bit index
	BEQ		write_loop				; done with this 24-bits of LED data, move on to next 24-bits of LED data
	; NOPs to flush out needed delay for total of 42 clocks with logic low on pin
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
    B		bit_loop
	
done_write
	POP {R0-R8}		;Restore registers prior to return
	BX LR ; return from the function
    ENDP
    align        
    
    END



