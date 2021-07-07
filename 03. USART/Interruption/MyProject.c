// LCD module connections
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
// End LCD module connections


#define F_CPU 8000000/64
#define Baud_value (((float)(F_CPU)/(float)baud_rate)-1)

// Defined functions for USART communication
void USART_Init(long baud_rate);

// Variables used
char out = '0';
char count = '0';
void main() {

  ADCON1 = 0b00001111;           // Vtg reference wwill be VDD and VSS and all ports are digital.

  Lcd_Init();
  Lcd_Cmd(_LCD_CLEAR);               // Clear display
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




// Initialize USART
void USART_Init(long baud_rate){
     float temp;
     trisc6_bit = 0;           // TX pin as output
     trisc7_bit = 1;           // RX pin as input

      // Initialize SPBRG register for the appropriate baud rate
      temp = (( (float) (F_CPU) / (float) baud_rate ) - 1);
      SPBRG = (int) temp;

      // Enable Transmit (TX)
      TXSTA = 0x20;        // Setting the all the above bits of TXSTA in one command

      // Enable Receive (RX)
      RCSTA = 0x90;         // Setting all the above bits of RCSTA in one command
      
      INTCON.GIE = 1;       // Enable Global interrupt
      INTCON.PEIE = 1;      // Enable Peripheral Interrupt
      PIE1.RCIE = 1;        // Enable Receive Interrupt
      //PIE1.TXIE = 1;        // Enable Transmit Interrupt
}

void interrupt(){
     if(RCIF_bit == 1){      // Waits for the Receiveid Flag to be set (reception is complete)
       out = RCREG;               // Copies received to _out
       while(TXIF_bit == 0);          // Waits for the register to be empty
       TXREG = out + 1;             //
     }
}
