


			


            
            ADC_CTRL EQU 0E802H ;[D4 D3 D2 D1 D0 <=> EOC SC OE ALE 0]
            ADC_IN EQU 0E801H
            
            ORG 8100H

            MOV A, #8AH
			MOV DPTR, #0E803H
			MOVX @DPTR, A
            MOV A, #00H
			MOV DPTR, #ADC_CTRL
			MOVX @DPTR, A

INFINITE:
            MOV A, #02H         ;SET ALE
            MOV DPTR, #ADC_CTRL
            MOVX @DPTR, A

            LCALL DELAY

            MOV A, #0AH         ;SET SC
			MOVX @DPTR, A
            
            LCALL DELAY

            MOV A, #00H         ;CLR ALE AND SC
			MOVX @DPTR, A



            MOV A, #04H         ;SET OE
            MOV DPTR, #ADC_CTRL
            MOVX @DPTR, A

            LCALL DELAY

            MOV DPTR, #ADC_IN
            MOVX A, @DPTR
			MOV R0, A
			MOV DPTR, #9000H
            MOVX @DPTR, A

            SUBB A, #33
            JC START_HEATER
            MOV A, R0
            SUBB A, #40
            JNC START_FAN
START_HEATER:
            MOV A, #00H   
            MOV DPTR, #0E800H
            MOVX @DPTR, A
            SJMP HERE
START_FAN:
            MOV A, #01H  
            MOV DPTR, #0E800H
            MOVX @DPTR, A

HERE :      MOV A, #00H         ;CLR OE
            MOV DPTR, #ADC_CTRL
            MOVX @DPTR, A

            SJMP INFINITE
			
			
			ORG 8600H
DELAY: 		MOV R0, #5
		L4: MOV R1, #8
		L5: MOV R2, #10
		L6: DJNZ R2, L6
			DJNZ R1, L5
			DJNZ R0, L4	
			RET
			
			END

