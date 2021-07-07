
_main:

;MyProject.c,29 :: 		void main() {
;MyProject.c,31 :: 		ADCON1 = 0b00001111;           // Vtg reference wwill be VDD and VSS and all ports are digital.
	MOVLW       15
	MOVWF       ADCON1+0 
;MyProject.c,33 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;MyProject.c,34 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;MyProject.c,35 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;MyProject.c,36 :: 		USART_Init(9600);
	MOVLW       128
	MOVWF       FARG_USART_Init_baud_rate+0 
	MOVLW       37
	MOVWF       FARG_USART_Init_baud_rate+1 
	MOVLW       0
	MOVWF       FARG_USART_Init_baud_rate+2 
	MOVWF       FARG_USART_Init_baud_rate+3 
	CALL        _USART_Init+0, 0
;MyProject.c,37 :: 		Delay_ms(50);
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
;MyProject.c,38 :: 		while(1){
L_main1:
;MyProject.c,39 :: 		Lcd_Out(1, 1, "Test2");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_MyProject+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_MyProject+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;MyProject.c,40 :: 		data_in = USART_ReceiveChar();
	CALL        _USART_ReceiveChar+0, 0
	MOVF        R0, 0 
	MOVWF       _data_in+0 
;MyProject.c,41 :: 		LCD_Chr(2, 1, data_in);
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVF        R0, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;MyProject.c,42 :: 		USART_TransmitChar(++data_in);   // Transmmits the next char in the ascii table
	INCF        _data_in+0, 1 
	MOVF        _data_in+0, 0 
	MOVWF       FARG_USART_TransmitChar_out+0 
	CALL        _USART_TransmitChar+0, 0
;MyProject.c,43 :: 		}
	GOTO        L_main1
;MyProject.c,44 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_USART_Init:

;MyProject.c,50 :: 		void USART_Init(long baud_rate){
;MyProject.c,52 :: 		trisc6_bit = 0;           // TX pin as output
	BCF         TRISC6_bit+0, BitPos(TRISC6_bit+0) 
;MyProject.c,53 :: 		trisc7_bit = 1;           // RX pin as input
	BSF         TRISC7_bit+0, BitPos(TRISC7_bit+0) 
;MyProject.c,56 :: 		temp = (( (float) (F_CPU) / (float) baud_rate ) - 1);
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
;MyProject.c,57 :: 		SPBRG = (int) temp;
	CALL        _double2int+0, 0
	MOVF        R0, 0 
	MOVWF       SPBRG+0 
;MyProject.c,61 :: 		SYNC_bit = 0;        // Enable asynchornous serial port by clearing SYNC_bit
	BCF         SYNC_bit+0, BitPos(SYNC_bit+0) 
;MyProject.c,62 :: 		SPEN_bit = 1;        // Enable asynchornous serial port by setting SPEN_bit
	BSF         SPEN_bit+0, BitPos(SPEN_bit+0) 
;MyProject.c,63 :: 		TXCKP_bit = 0;       // If the signal from TX is inverted, set TXCKP_bit
	BCF         TXCKP_bit+0, BitPos(TXCKP_bit+0) 
;MyProject.c,64 :: 		TXIE_bit = 0;        // If Interrupts are desired, set TXIE_bit
	BCF         TXIE_bit+0, BitPos(TXIE_bit+0) 
;MyProject.c,65 :: 		TX9_bit = 0;         // If 9-bit transmition is desired, set TX9_bit
	BCF         TX9_bit+0, BitPos(TX9_bit+0) 
;MyProject.c,66 :: 		TXEN_bit = 1;        // Enable transmition by setting TXEN_bit
	BSF         TXEN_bit+0, BitPos(TXEN_bit+0) 
;MyProject.c,67 :: 		BRGH_bit = 0;        // High Baud Rate speed (0 if low speed)
	BCF         BRGH_bit+0, BitPos(BRGH_bit+0) 
;MyProject.c,68 :: 		TRMT_bit = 0;        // TSR starts full
	BCF         TRMT_bit+0, BitPos(TRMT_bit+0) 
;MyProject.c,69 :: 		TX9D_bit = 0;        // TX9D  (9th bit of transmit data)
	BCF         TX9D_bit+0, BitPos(TX9D_bit+0) 
;MyProject.c,70 :: 		TXSTA = 0x20;        // Setting the all the above bits of TXSTA in one command
	MOVLW       32
	MOVWF       TXSTA+0 
;MyProject.c,74 :: 		SYNC_bit = 0;        // Enable asynchornous serial port by clearing SYNC_bit
	BCF         SYNC_bit+0, BitPos(SYNC_bit+0) 
;MyProject.c,75 :: 		SPEN_bit = 1;        // Enable asynchornous serial port by setting SPEN_bit
	BSF         SPEN_bit+0, BitPos(SPEN_bit+0) 
;MyProject.c,76 :: 		RX9_bit = 0;         // If 9-bit transmition is desired, set RX9_bit
	BCF         RX9_bit+0, BitPos(RX9_bit+0) 
;MyProject.c,77 :: 		SREN_bit = 0;        // Don't care (For assynchornous mode)
	BCF         SREN_bit+0, BitPos(SREN_bit+0) 
;MyProject.c,78 :: 		RXDTP_bit = 0;       // If the signal from RX is inverted, set RXDTP_bit
	BCF         RXDTP_bit+0, BitPos(RXDTP_bit+0) 
;MyProject.c,79 :: 		RCIE_bit = 0;            // If Interrupts are desired, set RCIE_bit
	BCF         RCIE_bit+0, BitPos(RCIE_bit+0) 
;MyProject.c,80 :: 		CREN_bit = 1;        // Enables receiver
	BSF         CREN_bit+0, BitPos(CREN_bit+0) 
;MyProject.c,81 :: 		ADDEN_bit = 0;       // Disables address detection
	BCF         ADDEN_bit+0, BitPos(ADDEN_bit+0) 
;MyProject.c,82 :: 		FERR_bit = 0;        // No framing error
	BCF         FERR_bit+0, BitPos(FERR_bit+0) 
;MyProject.c,83 :: 		OERR_bit = 0;        // No overrun error
	BCF         OERR_bit+0, BitPos(OERR_bit+0) 
;MyProject.c,84 :: 		RX9D_bit = 0;        // Parity bit not used
	BCF         RX9D_bit+0, BitPos(RX9D_bit+0) 
;MyProject.c,85 :: 		RCSTA = 0x90;         // Setting all the above bits of RCSTA in one command
	MOVLW       144
	MOVWF       RCSTA+0 
;MyProject.c,87 :: 		}
L_end_USART_Init:
	RETURN      0
; end of _USART_Init

_USART_TransmitChar:

;MyProject.c,90 :: 		void USART_TransmitChar(char out){
;MyProject.c,91 :: 		while(TXIF_bit == 0);   // Wait for transmit interrupt flag
L_USART_TransmitChar3:
	BTFSC       TXIF_bit+0, BitPos(TXIF_bit+0) 
	GOTO        L_USART_TransmitChar4
	GOTO        L_USART_TransmitChar3
L_USART_TransmitChar4:
;MyProject.c,92 :: 		TXREG = out;            // Write data to transmit register
	MOVF        FARG_USART_TransmitChar_out+0, 0 
	MOVWF       TXREG+0 
;MyProject.c,93 :: 		}
L_end_USART_TransmitChar:
	RETURN      0
; end of _USART_TransmitChar

_USART_ReceiveChar:

;MyProject.c,96 :: 		char USART_ReceiveChar(){
;MyProject.c,97 :: 		while(RCIF_bit == 0);   // Wait for receive interrupt flag
L_USART_ReceiveChar5:
	BTFSC       RCIF_bit+0, BitPos(RCIF_bit+0) 
	GOTO        L_USART_ReceiveChar6
	GOTO        L_USART_ReceiveChar5
L_USART_ReceiveChar6:
;MyProject.c,99 :: 		if(OERR_bit){           // If an error ocurred, clear the error bit by clearing enable bit CREN
	BTFSS       OERR_bit+0, BitPos(OERR_bit+0) 
	GOTO        L_USART_ReceiveChar7
;MyProject.c,100 :: 		CREN_bit = 0;
	BCF         CREN_bit+0, BitPos(CREN_bit+0) 
;MyProject.c,101 :: 		Delay_ms(10);
	MOVLW       26
	MOVWF       R12, 0
	MOVLW       248
	MOVWF       R13, 0
L_USART_ReceiveChar8:
	DECFSZ      R13, 1, 1
	BRA         L_USART_ReceiveChar8
	DECFSZ      R12, 1, 1
	BRA         L_USART_ReceiveChar8
	NOP
;MyProject.c,102 :: 		CREN_bit = 1;
	BSF         CREN_bit+0, BitPos(CREN_bit+0) 
;MyProject.c,103 :: 		}
L_USART_ReceiveChar7:
;MyProject.c,104 :: 		return (RCREG);
	MOVF        RCREG+0, 0 
	MOVWF       R0 
;MyProject.c,105 :: 		}
L_end_USART_ReceiveChar:
	RETURN      0
; end of _USART_ReceiveChar
