#line 1 "C:/Users/lucas/usp/ap micros/pratica 01/pratica01.c"


int display[10] = {63, 6, 91, 79, 102, 109, 125, 7, 127, 111};
int count = 0;
int mode = 0;



void interrupt_Low() iv 0x0018 ics ICS_AUTO {
 if(TMR0IF_bit){
 TMR0ON_bit = 0;

 count = (count+1)%10;
 portb = display[count];

 if(mode == 1){
 TMR0L = 0b11011100;
 TMR0H = 0b00001011;
 }else{
 TMR0L = 0b11110111;
 TMR0H = 0b11000010;
 }
 TMR0ON_bit = 1;
 }
 TMR0IF_bit = 0;
}





void main() {
 IPEN_bit = 1;
 ADCON1 = 0b00001111;
 trisa.trisa0 = 1;
 trisa.trisa1 = 1;
 trisb = 0;
 trisc = 0;
 portb = 63;

 INTCON = 0b11100000;

 T0CON = 0b10000100;
 TMR0IP_bit = 0;

 TMR0L = 0b11011100;
 TMR0H = 0b00001011;

 TMR0ON_bit = 1;

 while(1){
 if(porta.ra0 == 0){
 mode = 1;
 }
 if(porta.ra1 == 0){
 mode = 0;
 }
 }
}
