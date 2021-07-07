#line 1 "C:/Users/lucas/pic/02. ADC/LCD.c"
#line 1 "c:/users/lucas/pic/02. adc/lcd.h"









void LCD_Init();
void LCD_Command(char );
void LCD_Char(char x);
void LCD_String(const char *);
void MSdelay(unsigned int );
void LCD_String_xy(char ,char , char*);
#line 4 "C:/Users/lucas/pic/02. ADC/LCD.c"
void LCD_Init()
{
 TRISB = 0;
 TRISD=0;
 MSdelay(5);
 LCD_Command(0x38);
 LCD_Command(0x01);
 LCD_Command(0x06);
 LCD_Command(0x0c);
}


void LCD_Command(char cmd )
{
  LATB = cmd;
  LATD0_bit  = 0;
  LATD1_bit  = 1;
 MSdelay(1);
  LATD1_bit  = 0;
 MSdelay(3);
}

void LCD_Char(char dat)
{
  LATB = dat;
  LATD0_bit  = 1;
  LATD1_bit =1;
 MSdelay(1);
  LATD1_bit =0;
 MSdelay(3);
}


void LCD_String(const char *msg)
{
 while((*msg)!=0)
 {
 LCD_Char(*msg);
 msg++;
 }

}

void LCD_String_xy(char row,char pos,const char *msg)
{
 char location=0;
 if(row<=1)
 {
 location=(0x80) | ((pos) & 0x0f);
 LCD_Command(location);
 }
 else
 {
 location=(0xC0) | ((pos) & 0x0f);
 LCD_Command(location);
 }


 LCD_String(msg);



}
void MSdelay(unsigned int val)
{
 unsigned int i,j;
 for(i=0;i<=val;i++)
 for(j=0;j<81;j++);
 }
