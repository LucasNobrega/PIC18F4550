
_main:

;MyProject.c,15 :: 		void main() {
;MyProject.c,19 :: 		OSCCON = 0b01110010;     // Internal OSC Freq = 8;
	MOVLW       114
	MOVWF       OSCCON+0 
;MyProject.c,20 :: 		LCD_Init();              // Initialize 16x2 LCD
	CALL        _LCD_Init+0, 0
;MyProject.c,21 :: 		ADC_Init();              // Initialize 10-bit ADC
	CALL        _ADC_Init+0, 0
;MyProject.c,23 :: 		LCD_String_xy(1, 1, "Tensao...");
	MOVLW       1
	MOVWF       FARG_LCD_String_xy+0 
	MOVLW       1
	MOVWF       FARG_LCD_String_xy+0 
	MOVLW       ?lstr1_MyProject+0
	MOVWF       FARG_LCD_String_xy+0 
	MOVLW       hi_addr(?lstr1_MyProject+0)
	MOVWF       FARG_LCD_String_xy+1 
	CALL        _LCD_String_xy+0, 0
;MyProject.c,25 :: 		while(1){
L_main0:
;MyProject.c,27 :: 		digital = ADC_Read(0);
	CLRF        FARG_ADC_Read_channel+0 
	CLRF        FARG_ADC_Read_channel+1 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _digital+0 
	MOVF        R1, 0 
	MOVWF       _digital+1 
;MyProject.c,30 :: 		volt = digital*((float)vref / (float)1023);
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
;MyProject.c,33 :: 		sprintf(dados, "%.2f", volt);
	MOVLW       _dados+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(_dados+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_2_MyProject+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_2_MyProject+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_2_MyProject+0)
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
;MyProject.c,35 :: 		strcat(dados, "V");
	MOVLW       _dados+0
	MOVWF       FARG_strcat_to+0 
	MOVLW       hi_addr(_dados+0)
	MOVWF       FARG_strcat_to+1 
	MOVLW       ?lstr3_MyProject+0
	MOVWF       FARG_strcat_from+0 
	MOVLW       hi_addr(?lstr3_MyProject+0)
	MOVWF       FARG_strcat_from+1 
	CALL        _strcat+0, 0
;MyProject.c,37 :: 		LCD_String_xy(2, 4, dados);
	MOVLW       2
	MOVWF       FARG_LCD_String_xy+0 
	MOVLW       4
	MOVWF       FARG_LCD_String_xy+0 
	MOVLW       _dados+0
	MOVWF       FARG_LCD_String_xy+0 
	MOVLW       hi_addr(_dados+0)
	MOVWF       FARG_LCD_String_xy+1 
	CALL        _LCD_String_xy+0, 0
;MyProject.c,38 :: 		}
	GOTO        L_main0
;MyProject.c,39 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_ADC_Init:

;MyProject.c,48 :: 		void ADC_Init(){
;MyProject.c,50 :: 		trisa = 0b11111111;             // All pins of PORT A will be used as input
	MOVLW       255
	MOVWF       TRISA+0 
;MyProject.c,53 :: 		ADCON1 = 0b00001110;           // Vtg reference wwill be VDD and VSS
	MOVLW       14
	MOVWF       ADCON1+0 
;MyProject.c,57 :: 		ADCON0 = 0b00000001;          // The default channel is 0, and the converter is enabled
	MOVLW       1
	MOVWF       ADCON0+0 
;MyProject.c,60 :: 		ADCON2 = 0b10010010;          // Right justified, 4Tad, Fosc/32
	MOVLW       146
	MOVWF       ADCON2+0 
;MyProject.c,63 :: 		ADRESH = 0;
	CLRF        ADRESH+0 
;MyProject.c,64 :: 		ADRESL = 0;
	CLRF        ADRESL+0 
;MyProject.c,65 :: 		}
L_end_ADC_Init:
	RETURN      0
; end of _ADC_Init

_ADC_Read:

;MyProject.c,68 :: 		int ADC_Read(int channel){
;MyProject.c,72 :: 		ADCON0 &= 0b11000011;                              // Clear channel bits
	MOVLW       195
	ANDWF       ADCON0+0, 1 
;MyProject.c,73 :: 		ADCON0 |= ( (channel<<2) & (0b0011110) );           // Set channel bits
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
;MyProject.c,76 :: 		ADON_bit = 1;
	BSF         ADON_bit+0, BitPos(ADON_bit+0) 
;MyProject.c,79 :: 		GO_bit = 1;
	BSF         GO_bit+0, BitPos(GO_bit+0) 
;MyProject.c,83 :: 		while(GO_bit == 1);
L_ADC_Read2:
	BTFSS       GO_bit+0, BitPos(GO_bit+0) 
	GOTO        L_ADC_Read3
	GOTO        L_ADC_Read2
L_ADC_Read3:
;MyProject.c,86 :: 		digital = (ADRESH*256) | (ADRESL);
	MOVF        ADRESH+0, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        ADRESL+0, 0 
	IORWF       R0, 1 
	MOVLW       0
	IORWF       R1, 1 
;MyProject.c,89 :: 		return (digital);
;MyProject.c,92 :: 		}
L_end_ADC_Read:
	RETURN      0
; end of _ADC_Read
