#line 1 "C:/Users/lucas/usp/ap micros/03. USART/MyProject.c"

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
void USART_TransmitChar(char out);
char USART_ReceiveChar();


char data_in = 'c';

void main() {

 ADCON1 = 0b00001111;

 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 USART_Init(9600);
 Delay_ms(50);
 while(1){
 Lcd_Out(1, 1, "Test2");
 data_in = USART_ReceiveChar();
 LCD_Chr(2, 1, data_in);
 USART_TransmitChar(++data_in);
 }
}





void USART_Init(long baud_rate){
 float temp;
 trisc6_bit = 0;
 trisc7_bit = 1;


 temp = (( (float) ( 8000000/64 ) / (float) baud_rate ) - 1);
 SPBRG = (int) temp;



 SYNC_bit = 0;
 SPEN_bit = 1;
 TXCKP_bit = 0;
 TXIE_bit = 0;
 TX9_bit = 0;
 TXEN_bit = 1;
 BRGH_bit = 0;
 TRMT_bit = 0;
 TX9D_bit = 0;
 TXSTA = 0x20;



 SYNC_bit = 0;
 SPEN_bit = 1;
 RX9_bit = 0;
 SREN_bit = 0;
 RXDTP_bit = 0;
 RCIE_bit = 0;
 CREN_bit = 1;
 ADDEN_bit = 0;
 FERR_bit = 0;
 OERR_bit = 0;
 RX9D_bit = 0;
 RCSTA = 0x90;

}


void USART_TransmitChar(char out){
 while(TXIF_bit == 0);
 TXREG = out;
}


char USART_ReceiveChar(){
 while(RCIF_bit == 0);

 if(OERR_bit){
 CREN_bit = 0;
 Delay_ms(10);
 CREN_bit = 1;
 }
 return (RCREG);
}
