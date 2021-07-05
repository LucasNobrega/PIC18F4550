
_interrupt_Low:
	MOVWF       ___Low_saveWREG+0 
	MOVF        STATUS+0, 0 
	MOVWF       ___Low_saveSTATUS+0 
	MOVF        BSR+0, 0 
	MOVWF       ___Low_saveBSR+0 

;pratica01.c,9 :: 		void interrupt_Low() iv 0x0018 ics ICS_AUTO {
;pratica01.c,10 :: 		if(TMR0IF_bit){           // Was the interruption from Timer0?
	BTFSS       TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
	GOTO        L_interrupt_Low0
;pratica01.c,11 :: 		TMR0ON_bit = 0;
	BCF         TMR0ON_bit+0, BitPos(TMR0ON_bit+0) 
;pratica01.c,13 :: 		count  = (count+1)%10;   // Display next number
	MOVLW       1
	ADDWF       _count+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _count+1, 0 
	MOVWF       R1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _count+0 
	MOVF        R1, 0 
	MOVWF       _count+1 
;pratica01.c,14 :: 		portb = display[count];
	MOVF        R0, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       R3 
	RLCF        R2, 1 
	BCF         R2, 0 
	RLCF        R3, 1 
	MOVLW       _display+0
	ADDWF       R2, 0 
	MOVWF       FSR0L+0 
	MOVLW       hi_addr(_display+0)
	ADDWFC      R3, 0 
	MOVWF       FSR0L+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       PORTB+0 
;pratica01.c,16 :: 		if(mode == 1){
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt_Low9
	MOVLW       1
	XORWF       _mode+0, 0 
L__interrupt_Low9:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt_Low1
;pratica01.c,17 :: 		TMR0L = 0b11011100;    // Start Timer0 with 3036 (for counting 1 second)
	MOVLW       220
	MOVWF       TMR0L+0 
;pratica01.c,18 :: 		TMR0H = 0b00001011;
	MOVLW       11
	MOVWF       TMR0H+0 
;pratica01.c,19 :: 		}else{
	GOTO        L_interrupt_Low2
L_interrupt_Low1:
;pratica01.c,20 :: 		TMR0L = 0b11110111;    // Start Timer0 with 49 911 (for counting 0.25 seconds)
	MOVLW       247
	MOVWF       TMR0L+0 
;pratica01.c,21 :: 		TMR0H = 0b11000010;
	MOVLW       194
	MOVWF       TMR0H+0 
;pratica01.c,22 :: 		}
L_interrupt_Low2:
;pratica01.c,23 :: 		TMR0ON_bit = 1;
	BSF         TMR0ON_bit+0, BitPos(TMR0ON_bit+0) 
;pratica01.c,24 :: 		}
L_interrupt_Low0:
;pratica01.c,25 :: 		TMR0IF_bit = 0;       // Clear interruption flag
	BCF         TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
;pratica01.c,26 :: 		}
L_end_interrupt_Low:
L__interrupt_Low8:
	MOVF        ___Low_saveBSR+0, 0 
	MOVWF       BSR+0 
	MOVF        ___Low_saveSTATUS+0, 0 
	MOVWF       STATUS+0 
	SWAPF       ___Low_saveWREG+0, 1 
	SWAPF       ___Low_saveWREG+0, 0 
	RETFIE      0
; end of _interrupt_Low

_main:

;pratica01.c,32 :: 		void main() {
;pratica01.c,33 :: 		IPEN_bit = 1;
	BSF         IPEN_bit+0, BitPos(IPEN_bit+0) 
;pratica01.c,34 :: 		ADCON1 = 0b00001111;   // Configurando todas as portas do PIC como digitais
	MOVLW       15
	MOVWF       ADCON1+0 
;pratica01.c,35 :: 		trisa.trisa0 = 1;      // Configurando a porta RA0 como entrada
	BSF         TRISA+0, 0 
;pratica01.c,36 :: 		trisa.trisa1 = 1;      // Configurando a porta RA1 como entrada
	BSF         TRISA+0, 1 
;pratica01.c,37 :: 		trisb = 0;             // Configurando toda a porta B como saída
	CLRF        TRISB+0 
;pratica01.c,38 :: 		trisc = 0;
	CLRF        TRISC+0 
;pratica01.c,39 :: 		portb = 63;            // The display starts at 0
	MOVLW       63
	MOVWF       PORTB+0 
;pratica01.c,41 :: 		INTCON = 0b11100000;   // Enables interruption from Timer0
	MOVLW       224
	MOVWF       INTCON+0 
;pratica01.c,43 :: 		T0CON = 0b10000100;    // TIMER0 with 16 bits, interval clock and 1:32 prescaler
	MOVLW       132
	MOVWF       T0CON+0 
;pratica01.c,44 :: 		TMR0IP_bit = 0;        // Timer 0 is low priority
	BCF         TMR0IP_bit+0, BitPos(TMR0IP_bit+0) 
;pratica01.c,46 :: 		TMR0L = 0b11011100;    // Start Timer0 with 3036 (for counting 1 second)
	MOVLW       220
	MOVWF       TMR0L+0 
;pratica01.c,47 :: 		TMR0H = 0b00001011;
	MOVLW       11
	MOVWF       TMR0H+0 
;pratica01.c,49 :: 		TMR0ON_bit = 1;            // Starts Timer0
	BSF         TMR0ON_bit+0, BitPos(TMR0ON_bit+0) 
;pratica01.c,51 :: 		while(1){
L_main3:
;pratica01.c,52 :: 		if(porta.ra0 == 0){
	BTFSC       PORTA+0, 0 
	GOTO        L_main5
;pratica01.c,53 :: 		mode = 1;
	MOVLW       1
	MOVWF       _mode+0 
	MOVLW       0
	MOVWF       _mode+1 
;pratica01.c,54 :: 		}
L_main5:
;pratica01.c,55 :: 		if(porta.ra1 == 0){
	BTFSC       PORTA+0, 1 
	GOTO        L_main6
;pratica01.c,56 :: 		mode = 0;
	CLRF        _mode+0 
	CLRF        _mode+1 
;pratica01.c,57 :: 		}
L_main6:
;pratica01.c,58 :: 		}
	GOTO        L_main3
;pratica01.c,59 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
