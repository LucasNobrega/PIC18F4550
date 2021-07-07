
_main:

;MyProject.c,6 :: 		void main() {
;MyProject.c,8 :: 		trisb = 0;       // PORT B is configured as ouput
	CLRF        TRISB+0 
;MyProject.c,10 :: 		while(1){
L_main0:
;MyProject.c,11 :: 		latb0_bit = 1;  // Turns LED on
	BSF         LATB0_bit+0, BitPos(LATB0_bit+0) 
;MyProject.c,12 :: 		MSdelay(500);   // 500ms delay
	MOVLW       244
	MOVWF       FARG_MSdelay_val+0 
	MOVLW       1
	MOVWF       FARG_MSdelay_val+1 
	CALL        _MSdelay+0, 0
;MyProject.c,13 :: 		latb0_bit = 0;  // Turns LED off
	BCF         LATB0_bit+0, BitPos(LATB0_bit+0) 
;MyProject.c,14 :: 		MSdelay(500);   // 500ms delay
	MOVLW       244
	MOVWF       FARG_MSdelay_val+0 
	MOVLW       1
	MOVWF       FARG_MSdelay_val+1 
	CALL        _MSdelay+0, 0
;MyProject.c,15 :: 		}
	GOTO        L_main0
;MyProject.c,17 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_MSdelay:

;MyProject.c,20 :: 		void MSdelay(unsigned int val)
;MyProject.c,23 :: 		for(i=0;i<val;i++)
	CLRF        R1 
	CLRF        R2 
L_MSdelay2:
	MOVF        FARG_MSdelay_val+1, 0 
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__MSdelay10
	MOVF        FARG_MSdelay_val+0, 0 
	SUBWF       R1, 0 
L__MSdelay10:
	BTFSC       STATUS+0, 0 
	GOTO        L_MSdelay3
;MyProject.c,24 :: 		for(j=0;j<165;j++);         /*This count Provide delay of 1 ms for 8MHz Frequency */
	CLRF        R3 
	CLRF        R4 
L_MSdelay5:
	MOVLW       0
	SUBWF       R4, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__MSdelay11
	MOVLW       165
	SUBWF       R3, 0 
L__MSdelay11:
	BTFSC       STATUS+0, 0 
	GOTO        L_MSdelay6
	INFSNZ      R3, 1 
	INCF        R4, 1 
	GOTO        L_MSdelay5
L_MSdelay6:
;MyProject.c,23 :: 		for(i=0;i<val;i++)
	INFSNZ      R1, 1 
	INCF        R2, 1 
;MyProject.c,24 :: 		for(j=0;j<165;j++);         /*This count Provide delay of 1 ms for 8MHz Frequency */
	GOTO        L_MSdelay2
L_MSdelay3:
;MyProject.c,25 :: 		}
L_end_MSdelay:
	RETURN      0
; end of _MSdelay
