#line 1 "C:/Users/lucas/usp/ap micros/03. USART/Interruption/MyProject.c"

sbit LCD_RS at RB4_bit;
sbit LCD_EN at RB5_bit;
sbit LCD_D4 at RB0_bit;
sbit LCD_D5 at RB1_bit;
sbit LCD_D6 at RB2_bit;
sbit LCD_D7 at RB3_bit;

sbit LCD_RS_Direction at TRISB4_bit;
sbit LCD_EN_Direction at TRISB5_bit;
sbit LCD_D4_Direction at TRISB0_bit;
sbit LCD_D5_Direction at TRISB1_bit;
sbit LCD_D6_Direction at TRISB2_bit;
sbit LCD_D7_Direction at TRISB3_bit;







void USART_Init(long baud_rate);


char out = '0';
char count = '0';
void main() {

 ADCON1 = 0b00001111;

 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Delay_ms(50);
 Lcd_Out(1, 1, "Received: ");
 Delay_ms(2000);
 RCIF_bit = 0;
 TXIF_bit = 0;
 USART_Init(9600);
 while(1){
 Lcd_Chr(2, 1, out);
 Lcd_Chr(2, 8, count);
 count++;
 }
}





void USART_Init(long baud_rate){
 float temp;
 trisc6_bit = 0;
 trisc7_bit = 1;


 temp = (( (float) ( 8000000/64 ) / (float) baud_rate ) - 1);
 SPBRG = (int) temp;


 TXSTA = 0x20;


 RCSTA = 0x90;

 INTCON.GIE = 1;
 INTCON.PEIE = 1;
 PIE1.RCIE = 1;

}

void interrupt(){
 if(RCIF_bit == 1){
 out = RCREG;
 while(TXIF_bit == 0);
 TXREG = out + 1;
 }
}
