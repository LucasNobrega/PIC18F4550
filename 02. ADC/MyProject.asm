
_main:

;MyProject.c,31 :: 		void main() {
;MyProject.c,34 :: 		ADC_Init();              // Initialize 10-bit ADC
	CALL        _ADC_Init+0, 0
;MyProject.c,35 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;MyProject.c,36 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;MyProject.c,37 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;MyProject.c,38 :: 		digital = 0;
	CLRF        _digital+0 
	CLRF        _digital+1 
;MyProject.c,40 :: 		while(1){
L_main0:
;MyProject.c,42 :: 		digital = ADC_Read(0);
	CLRF        FARG_ADC_Read_channel+0 
	CLRF        FARG_ADC_Read_channel+1 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _digital+0 
	MOVF        R1, 0 
	MOVWF       _digital+1 
;MyProject.c,46 :: 		volt = digital*((float)vref / (float)1023);
	CALL        _int2double+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       40
	MOVWF       R5 
	MOVLW       32
	MOVWF       R6 
	MOVLW       119
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _volt+0 
	MOVF        R1, 0 
	MOVWF       _volt+1 
	MOVF        R2, 0 
	MOVWF       _volt+2 
	MOVF        R3, 0 
	MOVWF       _volt+3 
;MyProject.c,49 :: 		sprintf(dados, "%.2f", volt);
	MOVLW       _dados+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(_dados+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_1_MyProject+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_1_MyProject+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_1_MyProject+0)
	MOVWF       FARG_sprintf_f+2 
	MOVF        R0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVF        R1, 0 
	MOVWF       FARG_sprintf_wh+6 
	MOVF        R2, 0 
	MOVWF       FARG_sprintf_wh+7 
	MOVF        R3, 0 
	MOVWF       FARG_sprintf_wh+8 
	CALL        _sprintf+0, 0
;MyProject.c,52 :: 		Lcd_Out(1, 2, "Tensao: ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_MyProject+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_MyProject+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;MyProject.c,53 :: 		Lcd_Out(2, 2, dados);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _dados+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_dados+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;MyProject.c,54 :: 		}
	GOTO        L_main0
;MyProject.c,55 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_ADC_Init:

;MyProject.c,64 :: 		void ADC_Init(){
;MyProject.c,66 :: 		trisa = 0b11111111;             // All pins of PORT A will be used as input
	MOVLW       255
	MOVWF       TRISA+0 
;MyProject.c,69 :: 		ADCON1 = 0b00001110;           // Vtg reference wwill be VDD and VSS
	MOVLW       14
	MOVWF       ADCON1+0 
;MyProject.c,73 :: 		ADCON0 = 0b00000001;          // The default channel is 0, and the converter is enabled
	MOVLW       1
	MOVWF       ADCON0+0 
;MyProject.c,76 :: 		ADCON2 = 0b10010010;          // Right justified, 4Tad, Fosc/32
	MOVLW       146
	MOVWF       ADCON2+0 
;MyProject.c,79 :: 		ADRESH = 0;
	CLRF        ADRESH+0 
;MyProject.c,80 :: 		ADRESL = 0;
	CLRF        ADRESL+0 
;MyProject.c,81 :: 		}
L_end_ADC_Init:
	RETURN      0
; end of _ADC_Init

_ADC_Read:

;MyProject.c,84 :: 		int ADC_Read(int channel){
;MyProject.c,88 :: 		ADCON0 &= 0b11000011;                              // Clear channel bits
	MOVLW       195
	ANDWF       ADCON0+0, 1 
;MyProject.c,89 :: 		ADCON0 |= ( (channel<<2) & (0b0011110) );           // Set channel bits
	MOVF        FARG_ADC_Read_channel+0, 0 
	MOVWF       R0 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R0, 1 
	BCF         R0, 0 
	MOVLW       30
	ANDWF       R0, 1 
	MOVF        R0, 0 
	IORWF       ADCON0+0, 1 
;MyProject.c,90 :: 		ADON_bit = 1;
	BSF         ADON_bit+0, BitPos(ADON_bit+0) 
;MyProject.c,93 :: 		GO_bit = 1;
	BSF         GO_bit+0, BitPos(GO_bit+0) 
;MyProject.c,97 :: 		while(GO_bit == 1);
L_ADC_Read2:
	BTFSS       GO_bit+0, BitPos(GO_bit+0) 
	GOTO        L_ADC_Read3
	GOTO        L_ADC_Read2
L_ADC_Read3:
;MyProject.c,100 :: 		digital = (ADRESH*256) | (ADRESL);
	MOVF        ADRESH+0, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        ADRESL+0, 0 
	IORWF       R0, 1 
	MOVLW       0
	IORWF       R1, 1 
;MyProject.c,103 :: 		return (digital);
;MyProject.c,106 :: 		}
L_end_ADC_Read:
	RETURN      0
; end of _ADC_Read
