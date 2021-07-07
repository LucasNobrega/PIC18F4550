
_LCD_Init:

;LCD.c,4 :: 		void LCD_Init()
;LCD.c,6 :: 		TRISB = 0;
	CLRF        TRISB+0 
;LCD.c,7 :: 		TRISD=0;
	CLRF        TRISD+0 
;LCD.c,8 :: 		MSdelay(5);
	MOVLW       5
	MOVWF       FARG_MSdelay+0 
	MOVLW       0
	MOVWF       FARG_MSdelay+1 
	CALL        _MSdelay+0, 0
;LCD.c,9 :: 		LCD_Command(0x38);     /*uses 2 line and initialize 5*7 matrix of LCD*/
	MOVLW       56
	MOVWF       FARG_LCD_Command+0 
	CALL        _LCD_Command+0, 0
;LCD.c,10 :: 		LCD_Command(0x01);     /*clear display screen*/
	MOVLW       1
	MOVWF       FARG_LCD_Command+0 
	CALL        _LCD_Command+0, 0
;LCD.c,11 :: 		LCD_Command(0x06);     /*increment cursor (shift cursor to right)*/
	MOVLW       6
	MOVWF       FARG_LCD_Command+0 
	CALL        _LCD_Command+0, 0
;LCD.c,12 :: 		LCD_Command(0x0c);     /*display on cursor off*/
	MOVLW       12
	MOVWF       FARG_LCD_Command+0 
	CALL        _LCD_Command+0, 0
;LCD.c,13 :: 		}
L_end_LCD_Init:
	RETURN      0
; end of _LCD_Init

_LCD_Command:

;LCD.c,16 :: 		void LCD_Command(char cmd )
;LCD.c,18 :: 		ldata= cmd;            /*Send command to LCD */
	MOVF        FARG_LCD_Command_cmd+0, 0 
	MOVWF       LATB+0 
;LCD.c,19 :: 		RS = 0;                /*Command Register is selected*/
	BCF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;LCD.c,20 :: 		EN = 1;                /*High-to-Low pulse on Enable pin to latch data*/
	BSF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;LCD.c,21 :: 		MSdelay(1);
	MOVLW       1
	MOVWF       FARG_MSdelay+0 
	MOVLW       0
	MOVWF       FARG_MSdelay+1 
	CALL        _MSdelay+0, 0
;LCD.c,22 :: 		EN = 0;
	BCF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;LCD.c,23 :: 		MSdelay(3);
	MOVLW       3
	MOVWF       FARG_MSdelay+0 
	MOVLW       0
	MOVWF       FARG_MSdelay+1 
	CALL        _MSdelay+0, 0
;LCD.c,24 :: 		}
L_end_LCD_Command:
	RETURN      0
; end of _LCD_Command

_LCD_Char:

;LCD.c,26 :: 		void LCD_Char(char dat)
;LCD.c,28 :: 		ldata= dat;            /*Send command to LCD */
	MOVF        FARG_LCD_Char_dat+0, 0 
	MOVWF       LATB+0 
;LCD.c,29 :: 		RS = 1;                /*Data Register is selected*/
	BSF         LATD0_bit+0, BitPos(LATD0_bit+0) 
;LCD.c,30 :: 		EN=1;                  /*High-to-Low pulse on Enable pin to latch data*/
	BSF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;LCD.c,31 :: 		MSdelay(1);
	MOVLW       1
	MOVWF       FARG_MSdelay+0 
	MOVLW       0
	MOVWF       FARG_MSdelay+1 
	CALL        _MSdelay+0, 0
;LCD.c,32 :: 		EN=0;
	BCF         LATD1_bit+0, BitPos(LATD1_bit+0) 
;LCD.c,33 :: 		MSdelay(3);
	MOVLW       3
	MOVWF       FARG_MSdelay+0 
	MOVLW       0
	MOVWF       FARG_MSdelay+1 
	CALL        _MSdelay+0, 0
;LCD.c,34 :: 		}
L_end_LCD_Char:
	RETURN      0
; end of _LCD_Char

_LCD_String:

;LCD.c,37 :: 		void LCD_String(const char *msg)
;LCD.c,39 :: 		while((*msg)!=0)
L_LCD_String0:
	MOVF        FARG_LCD_String_msg+0, 0 
	MOVWF       TBLPTRL+0 
	MOVF        FARG_LCD_String_msg+1, 0 
	MOVWF       TBLPTRH+0 
	MOVF        FARG_LCD_String_msg+2, 0 
	MOVWF       TBLPTRU+0 
	TBLRD*+
	MOVFF       TABLAT+0, R1
	MOVF        R1, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_LCD_String1
;LCD.c,41 :: 		LCD_Char(*msg);
	MOVF        FARG_LCD_String_msg+0, 0 
	MOVWF       TBLPTRL+0 
	MOVF        FARG_LCD_String_msg+1, 0 
	MOVWF       TBLPTRH+0 
	MOVF        FARG_LCD_String_msg+2, 0 
	MOVWF       TBLPTRU+0 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_LCD_Char_dat+0
	CALL        _LCD_Char+0, 0
;LCD.c,42 :: 		msg++;
	MOVLW       1
	ADDWF       FARG_LCD_String_msg+0, 1 
	MOVLW       0
	ADDWFC      FARG_LCD_String_msg+1, 1 
	ADDWFC      FARG_LCD_String_msg+2, 1 
;LCD.c,43 :: 		}
	GOTO        L_LCD_String0
L_LCD_String1:
;LCD.c,45 :: 		}
L_end_LCD_String:
	RETURN      0
; end of _LCD_String

_LCD_String_xy:

;LCD.c,47 :: 		void LCD_String_xy(char row,char pos,const char *msg)
;LCD.c,49 :: 		char location=0;
;LCD.c,50 :: 		if(row<=1)
	MOVF        FARG_LCD_String_xy_row+0, 0 
	SUBLW       1
	BTFSS       STATUS+0, 0 
	GOTO        L_LCD_String_xy2
;LCD.c,52 :: 		location=(0x80) | ((pos) & 0x0f);      /*Print message on 1st row and desired location*/
	MOVLW       15
	ANDWF       FARG_LCD_String_xy_pos+0, 0 
	MOVWF       R0 
	MOVLW       128
	IORWF       R0, 0 
	MOVWF       FARG_LCD_Command_cmd+0 
;LCD.c,53 :: 		LCD_Command(location);
	CALL        _LCD_Command+0, 0
;LCD.c,54 :: 		}
	GOTO        L_LCD_String_xy3
L_LCD_String_xy2:
;LCD.c,57 :: 		location=(0xC0) | ((pos) & 0x0f);      /*Print message on 2nd row and desired location*/
	MOVLW       15
	ANDWF       FARG_LCD_String_xy_pos+0, 0 
	MOVWF       R0 
	MOVLW       192
	IORWF       R0, 0 
	MOVWF       FARG_LCD_Command_cmd+0 
;LCD.c,58 :: 		LCD_Command(location);
	CALL        _LCD_Command+0, 0
;LCD.c,59 :: 		}
L_LCD_String_xy3:
;LCD.c,62 :: 		LCD_String(msg);
	MOVF        FARG_LCD_String_xy_msg+0, 0 
	MOVWF       FARG_LCD_String_msg+0 
	MOVF        FARG_LCD_String_xy_msg+1, 0 
	MOVWF       FARG_LCD_String_msg+1 
	MOVF        FARG_LCD_String_xy_msg+2, 0 
	MOVWF       FARG_LCD_String_msg+2 
	CALL        _LCD_String+0, 0
;LCD.c,66 :: 		}
L_end_LCD_String_xy:
	RETURN      0
; end of _LCD_String_xy

_MSdelay:

;LCD.c,67 :: 		void MSdelay(unsigned int val)
;LCD.c,70 :: 		for(i=0;i<=val;i++)
	CLRF        R1 
	CLRF        R2 
L_MSdelay4:
	MOVF        R2, 0 
	SUBWF       FARG_MSdelay_val+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__MSdelay16
	MOVF        R1, 0 
	SUBWF       FARG_MSdelay_val+0, 0 
L__MSdelay16:
	BTFSS       STATUS+0, 0 
	GOTO        L_MSdelay5
;LCD.c,71 :: 		for(j=0;j<81;j++);      /*This count Provide delay of 1 ms for 8MHz Frequency */
	CLRF        R3 
	CLRF        R4 
L_MSdelay7:
	MOVLW       0
	SUBWF       R4, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__MSdelay17
	MOVLW       81
	SUBWF       R3, 0 
L__MSdelay17:
	BTFSC       STATUS+0, 0 
	GOTO        L_MSdelay8
	INFSNZ      R3, 1 
	INCF        R4, 1 
	GOTO        L_MSdelay7
L_MSdelay8:
;LCD.c,70 :: 		for(i=0;i<=val;i++)
	INFSNZ      R1, 1 
	INCF        R2, 1 
;LCD.c,71 :: 		for(j=0;j<81;j++);      /*This count Provide delay of 1 ms for 8MHz Frequency */
	GOTO        L_MSdelay4
L_MSdelay5:
;LCD.c,72 :: 		}
L_end_MSdelay:
	RETURN      0
; end of _MSdelay
