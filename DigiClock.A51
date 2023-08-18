


					
			R10 EQU 30H
			R11 EQU 31H
			R12 EQU 32H
			; CHECK THAT MAIN CODE IS NOT OVERWRITTE BY SUBROUTINES
			ORG 0FFF0H
			LJMP ISR_T0

			ORG 0FFF6H
			LJMP ISR_T1
			
	;---------------------Main-----------------------------
			ORG 8100H
			MOV TMOD, #11H
			MOV TL0, #00H
			MOV TH0, #00H
			MOV TL1, #00H
			MOV TH1, #00H
			MOV IE, #8BH
			MOV R6, #14
			MOV R7, #14
			MOV A, #89H
			MOV DPTR, #0E803H
			MOVX @DPTR, A
			
			SETB TR0

	MODE0:			;---------------Clock Mode (MODE0)-----------------
			CLR TR1
			MOV DPTR, #0E802H
			MOVX A, @DPTR
			ANL A, #01H
			JNZ MODE1
	 
			LCALL UNPACK_CLOCK
			LCALL DISPLAY		

			SJMP MODE0	
			
			
	MODE1:			;---------------Stopwatch Mode (MODE1)-----------------  
			LCALL INITAIALIZE_MODE1
	CONTINUE:
			MOV DPTR, #0E802H
			MOVX A, @DPTR
			ANL A, #01H
			JZ MODE0
		
			LCALL UNPACK_STOPWATCH
			LCALL DISPLAY
			
			MOV DPTR, #0E802H
			MOVX A, @DPTR
			ANL A, #02H
			JZ STOP
			SETB TR1
			SJMP CONTINUE
	STOP:	CLR TR1
			SJMP CONTINUE	
	
	;-----------------------------------Main Ends------------------------------------------------	
	
	
	
	
	;------------------Mode1 Initializer----------------------
	INITAIALIZE_MODE1:
			MOV A, #00H
			MOV DPTR, #9003H
			MOVX @DPTR, A
			MOV DPTR, #9004H
			MOVX @DPTR, A
			MOV DPTR, #9005H
			MOVX @DPTR, A
			MOV TL1, A
			MOV TH1, A
			MOV R7, #14
			RET

	
	;------------------Clock Unpacker----------------------
	UNPACK_CLOCK:		
			MOV DPTR, #9002H		; Unpacking ss
			MOVX A, @DPTR
			MOV R1, A
			ANL A, #0FH
			MOV R0, A
			MOV A, R1
			SWAP A
			ANL A, #0FH
			MOV R1, A

			MOV DPTR, #9001H		; Unpacking mm
			MOVX A, @DPTR
			MOV R3, A
			ANL A, #0FH
			MOV R2, A
			MOV A, R3
			SWAP A
			ANL A, #0FH
			MOV R3, A

			MOV DPTR, #9000H		; Unpacking hh
			MOVX A, @DPTR
			MOV R5, A
			ANL A, #0FH
			MOV R4, A
			MOV A, R5
			SWAP A
			ANL A, #0FH
			MOV R5, A
			RET
	
	;------------------Stopwatch Unpacker----------------------
	UNPACK_STOPWATCH:		
			MOV DPTR, #9005H		; Unpacking ss
			MOVX A, @DPTR
			MOV R1, A
			ANL A, #0FH
			MOV R0, A
			MOV A, R1
			SWAP A
			ANL A, #0FH
			MOV R1, A

			MOV DPTR, #9004H		; Unpacking mm
			MOVX A, @DPTR
			MOV R3, A
			ANL A, #0FH
			MOV R2, A
			MOV A, R3
			SWAP A
			ANL A, #0FH
			MOV R3, A

			MOV DPTR, #9003H		; Unpacking hh
			MOVX A, @DPTR
			MOV R5, A
			ANL A, #0FH
			MOV R4, A
			MOV A, R5
			SWAP A
			ANL A, #0FH
			MOV R5, A
			RET
	
	
	;------------------hh mm ss displayer---------------------		
	DISPLAY:
			MOV A, R0
			MOV DPTR, #MAPPING
			MOVC A, @A+DPTR
			MOV DPTR, #0E800H
			MOVX @DPTR, A	
			MOV DPTR, #0E801H
			MOV A, #0FEH
			MOVX @DPTR, A

			LCALL DELAY
			
			MOV A, R1
			MOV DPTR, #MAPPING
			MOVC A, @A+DPTR
			MOV DPTR, #0E800H
			MOVX @DPTR, A	
			MOV DPTR, #0E801H
			MOV A, #0FDH
			MOVX @DPTR, A

			LCALL DELAY
			
			MOV A, R2
			MOV DPTR, #MAPPING
			MOVC A, @A+DPTR
			MOV DPTR, #0E800H
			MOVX @DPTR, A	
			MOV DPTR, #0E801H
			MOV A, #0FBH
			MOVX @DPTR, A	

			LCALL DELAY
			
			MOV A, R3
			MOV DPTR, #MAPPING
			MOVC A, @A+DPTR
			MOV DPTR, #0E800H
			MOVX @DPTR, A	
			MOV DPTR, #0E801H
			MOV A, #0F7H
			MOVX @DPTR, A	

			LCALL DELAY
			
			MOV A, R4
			MOV DPTR, #MAPPING
			MOVC A, @A+DPTR
			MOV DPTR, #0E800H
			MOVX @DPTR, A	
			MOV DPTR, #0E801H
			MOV A, #0EFH
			MOVX @DPTR, A	

			LCALL DELAY
			
			MOV A, R5
			MOV DPTR, #MAPPING
			MOVC A, @A+DPTR
			MOV DPTR, #0E800H
			MOVX @DPTR, A	
			MOV DPTR, #0E801H
			MOV A, #0DFH
			MOVX @DPTR, A	

			LCALL DELAY	
			RET

			;--------------10ms delay-----------------
	ORG 8500H
	DELAY:
			;PUSH R0
			;PUSH R1
			;PUSH R2
			MOV R10, #10
		L4: MOV R11, #44
		L5: MOV R12, #42
		L6: DJNZ R12, L6
			DJNZ R11, L5
			DJNZ R10, L4

			;POP R2
			;POP R1
			;POP R0
			RET
			
			;-------------ISR_Timer0---------------
			ORG 8600H
	ISR_T0:
			;PUSH DPL
			;PUSH DPH
			;PUSH 0E0H
			;PUSH 00H
			;PUSH 01H
			;PUSH 02H
			;PUSH 03H
			;PUSH 04H
			;PUSH 05H
	
			CLR TR0
			MOV TL0, #00H
			MOV TH0, #00H

			DJNZ R6, SKIP00
			MOV R6, #14

			LCALL UNPACK_CLOCK
			
			INC R0					;incrementing ss
			CJNE R0, #10, SKIP01
			MOV R0, #0H
			INC R1
			CJNE R1, #6, SKIP01
			MOV R1, #0H

			INC R2					;incrementing mm
			CJNE R2, #10, SKIP02
			MOV R2, #0H
			INC R3
			CJNE R3, #6, SKIP02
			MOV R3, #0H

			INC R4					;incrementing hh
			CJNE R4, #4, SKIP03
			CJNE R5, #2, SKIP03
			MOV R4, #0H
			MOV R5, #0H
			SJMP SKIP04
	SKIP03:	
			CJNE R4, #10, SKIP04
			MOV R4, #0H
			INC R5
	SKIP04:							;packing hh
			MOV A, R5
			SWAP A
			ORL A, R4
			MOV DPTR, #9000H
			MOVX @DPTR, A
	SKIP02:							;packing mm	
			MOV A, R3
			SWAP A
			ORL A, R2
			MOV DPTR, #9001H
			MOVX @DPTR, A
	SKIP01:							;packing ss	
			MOV A, R1
			SWAP A
			ORL A, R0
			MOV DPTR, #9002H
			MOVX @DPTR, A

	SKIP00:	SETB TR0

			;POP 05H
			;POP 04H
			;POP 03H
			;POP 02H
			;POP 01H
			;POP 00H
			;POP 0E0H
			;POP DPH
			;POP DPL
			RETI


			;-------------ISR_Timer1---------------
			ORG 8800H
	ISR_T1:
			;PUSH DPL
			;PUSH DPH
			;PUSH A
			;PUSH R0
			;PUSH R1
			;PUSH R2
			;PUSH R3
			;PUSH R4
			;PUSH R5
	
			CLR TR1
			MOV TL1, #00H
			MOV TH1, #00H

			DJNZ R7, SKIP10
			MOV R7, #14

			LCALL UNPACK_STOPWATCH
			
			INC R0					;incrementing ss
			CJNE R0, #10, SKIP11
			MOV R0, #0H
			INC R1
			CJNE R1, #6, SKIP11
			MOV R1, #0H

			INC R2					;incrementing mm
			CJNE R2, #10, SKIP12
			MOV R2, #0H
			INC R3
			CJNE R3, #6, SKIP12
			MOV R3, #0H

			INC R4					;incrementing hh
			CJNE R4, #10, SKIP13
			MOV R4, #0H
			INC R5
			CJNE R5, #10, SKIP13
			MOV R5, #0H
	SKIP13:							;packing hh
			MOV A, R5
			SWAP A
			ORL A, R4
			MOV DPTR, #9003H
			MOVX @DPTR, A
	SKIP12:							;packing mm	
			MOV A, R3
			SWAP A
			ORL A, R2
			MOV DPTR, #9004H
			MOVX @DPTR, A
	SKIP11:							;packing ss	
			MOV A, R1
			SWAP A
			ORL A, R0
			MOV DPTR, #9005H
			MOVX @DPTR, A

	SKIP10:	SETB TR1

			;POP R5
			;POP R4
			;POP R3
			;POP R2
			;POP R1
			;POP R0		
			;POP A
			;POP DPH
			;POP DPL
			RETI
			
			
	
			;-------------Mapping--------------
			ORG 9000H
	MAPPING:			
			DB 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F				
				
			END