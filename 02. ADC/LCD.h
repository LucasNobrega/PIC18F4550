
#ifndef LCD_H_
#define LCD_H_


#define RS LATD0_bit                    /*PORTD 0 pin is used for Register Select*/
#define EN LATD1_bit                    /*PORTD 1 pin is used for Enable*/
#define ldata LATB                  /*PORTB is used for transmitting data to LCD*/

void LCD_Init();
void LCD_Command(char );
void LCD_Char(char x);
void LCD_String(const char *);
void MSdelay(unsigned int );
void LCD_String_xy(char ,char , char*);

#endif        /* LCD_H_ */