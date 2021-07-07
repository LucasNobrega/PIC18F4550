
_main:

;MyProject.c,27 :: 		void main() {
;MyProject.c,29 :: 		ADCON1 = 0b00001111;           // Vtg reference wwill be VDD and VSS and all ports are digital.
	MOVLW       15
	MOVWF       ADCON1+0 
;MyProject.c,31 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;MyProject.c,32 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;MyProject.c,33 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;MyProject.c,34 :: 		Delay_ms(50);
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_main0:
	DECFSZ      R13, 1, 1
	BRA         L_main0
	DECFSZ      R12, 1, 1
	BRA         L_main0
	NOP
	NOP
;MyProject.c,35 :: 		Lcd_Out(1, 1, "Received: ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_MyProject+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_MyProject+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;MyProject.c,36 :: 		Delay_ms(2000);
	MOVLW       21
	MOVWF       R11, 0
	MOVLW       75
	MOVWF       R12, 0
	MOVLW       190
	MOVWF       R13, 0
L_main1:
	DECFSZ      R13, 1, 1
	BRA         L_main1
	DECFSZ      R12, 1, 1
	BRA         L_main1
	DECFSZ      R11, 1, 1
	BRA         L_main1
	NOP
;MyProject.c,37 :: 		RCIF_bit = 0;
	BCF         RCIF_bit+0, BitPos(RCIF_bit+0) 
;MyProject.c,38 :: 		TXIF_bit = 0;
	BCF         TXIF_bit+0, BitPos(TXIF_bit+0) 
;MyProject.c,39 :: 		USART_Init(9600);
	MOVLW       128
	MOVWF       FARG_USART_Init_baud_rate+0 
	MOVLW       37
	MOVWF       FARG_USART_Init_baud_rate+1 
	MOVLW       0
	MOVWF       FARG_USART_Init_baud_rate+2 
	MOVWF       FARG_USART_Init_baud_rate+3 
	CALL        _USART_Init+0, 0
;MyProject.c,40 :: 		while(1){
L_main2:
;MyProject.c,41 :: 		Lcd_Chr(2, 1, out);
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVF        _out+0, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;MyProject.c,42 :: 		Lcd_Chr(2, 8, count);
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       8
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVF        _count+0, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;MyProject.c,43 :: 		count++;
	INCF        _count+0, 1 
;MyProject.c,44 :: 		}
	GOTO        L_main2
;MyProject.c,45 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_USART_Init:

;MyProject.c,51 :: 		void USART_Init(long baud_rate){
;MyProject.c,53 :: 		trisc6_bit = 0;           // TX pin as output
	BCF         TRISC6_bit+0, BitPos(TRISC6_bit+0) 
;MyProject.c,54 :: 		trisc7_bit = 1;           // RX pin as input
	BSF         TRISC7_bit+0, BitPos(TRISC7_bit+0) 
;MyProject.c,57 :: 		temp = (( (float) (F_CPU) / (float) baud_rate ) - 1);
	MOVF        FARG_USART_Init_baud_rate+0, 0 
	MOVWF       R0 
	MOVF        FARG_USART_Init_baud_rate+1, 0 
	MOVWF       R1 
	MOVF        FARG_USART_Init_baud_rate+2, 0 
	MOVWF       R2 
	MOVF        FARG_USART_Init_baud_rate+3, 0 
	MOVWF       R3 
	CALL        _longint2double+0, 0
	MOVF        R0, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
	MOVLW       0
	MOVWF       R0 
	MOVLW       36
	MOVWF       R1 
	MOVLW       116
	MOVWF       R2 
	MOVLW       143
	MOVWF       R3 
	CALL        _Div_32x32_FP+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       127
	MOVWF       R7 
	CALL        _Sub_32x32_FP+0, 0
;MyProject.c,58 :: 		SPBRG = (int) temp;
	CALL        _double2int+0, 0
	MOVF        R0, 0 
	MOVWF       SPBRG+0 
;MyProject.c,61 :: 		TXSTA = 0x20;        // Setting the all the above bits of TXSTA in one command
	MOVLW       32
	MOVWF       TXSTA+0 
;MyProject.c,64 :: 		RCSTA = 0x90;         // Setting all the above bits of RCSTA in one command
	MOVLW       144
	MOVWF       RCSTA+0 
;MyProject.c,66 :: 		INTCON.GIE = 1;       // Enable Global interrupt
	BSF         INTCON+0, 7 
;MyProject.c,67 :: 		INTCON.PEIE = 1;      // Enable Peripheral Interrupt
	BSF         INTCON+0, 6 
;MyProject.c,68 :: 		PIE1.RCIE = 1;        // Enable Receive Interrupt
	BSF         PIE1+0, 5 
;MyProject.c,70 :: 		}
L_end_USART_Init:
	RETURN      0
; end of _USART_Init

_interrupt:

;MyProject.c,72 :: 		void interrupt(){
;MyProject.c,73 :: 		if(RCIF_bit == 1){      // Waits for the Receiveid Flag to be set (reception is complete)
	BTFSS       RCIF_bit+0, BitPos(RCIF_bit+0) 
	GOTO        L_interrupt4
;MyProject.c,74 :: 		out = RCREG;               // Copies received to _out
	MOVF        RCREG+0, 0 
	MOVWF       _out+0 
;MyProject.c,75 :: 		while(TXIF_bit == 0);          // Waits for the register to be empty
L_interrupt5:
	BTFSC       TXIF_bit+0, BitPos(TXIF_bit+0) 
	GOTO        L_interrupt6
	GOTO        L_interrupt5
L_interrupt6:
;MyProject.c,76 :: 		TXREG = out + 1;             //
	MOVF        _out+0, 0 
	ADDLW       1
	MOVWF       TXREG+0 
;MyProject.c,77 :: 		}
L_interrupt4:
;MyProject.c,78 :: 		}
L_end_interrupt:
L__interrupt10:
	RETFIE      1
; end of _interrupt
