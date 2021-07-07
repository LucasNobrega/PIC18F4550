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
void USART_TransmitChar(char out);
char USART_ReceiveChar();

// Variables used
char data_in = 'c';

void main() {

  ADCON1 = 0b00001111;           // Vtg reference wwill be VDD and VSS and all ports are digital.

  Lcd_Init();
  Lcd_Cmd(_LCD_CLEAR);               // Clear display
  Lcd_Cmd(_LCD_CURSOR_OFF);
  USART_Init(9600);
  Delay_ms(50);
  while(1){
    Lcd_Out(1, 1, "Test2");
    data_in = USART_ReceiveChar();
    LCD_Chr(2, 1, data_in);          // Displays the received char on LCD
    USART_TransmitChar(++data_in);   // Transmmits the next char in the ascii table
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
      SYNC_bit = 0;        // Enable asynchornous serial port by clearing SYNC_bit
      SPEN_bit = 1;        // Enable asynchornous serial port by setting SPEN_bit
      TXCKP_bit = 0;       // If the signal from TX is inverted, set TXCKP_bit
      TXIE_bit = 0;        // If Interrupts are desired, set TXIE_bit
      TX9_bit = 0;         // If 9-bit transmition is desired, set TX9_bit
      TXEN_bit = 1;        // Enable transmition by setting TXEN_bit
      BRGH_bit = 0;        // High Baud Rate speed (0 if low speed)
      TRMT_bit = 0;        // TSR starts full
      TX9D_bit = 0;        // TX9D  (9th bit of transmit data)
      TXSTA = 0x20;        // Setting the all the above bits of TXSTA in one command
      
      
      // Enable Receive (RX)
      SYNC_bit = 0;        // Enable asynchornous serial port by clearing SYNC_bit
      SPEN_bit = 1;        // Enable asynchornous serial port by setting SPEN_bit
      RX9_bit = 0;         // If 9-bit transmition is desired, set RX9_bit
      SREN_bit = 0;        // Don't care (For assynchornous mode)
      RXDTP_bit = 0;       // If the signal from RX is inverted, set RXDTP_bit
      RCIE_bit = 0;            // If Interrupts are desired, set RCIE_bit
      CREN_bit = 1;        // Enables receiver
      ADDEN_bit = 0;       // Disables address detection
      FERR_bit = 0;        // No framing error
      OERR_bit = 0;        // No overrun error
      RX9D_bit = 0;        // Parity bit not used
      RCSTA = 0x90;         // Setting all the above bits of RCSTA in one command
      
}

// Transmit mode
void USART_TransmitChar(char out){
     while(TXIF_bit == 0);   // Wait for transmit interrupt flag
     TXREG = out;            // Write data to transmit register
}

// Receive mode
char USART_ReceiveChar(){
     while(RCIF_bit == 0);   // Wait for receive interrupt flag
     
     if(OERR_bit){           // If an error ocurred, clear the error bit by clearing enable bit CREN
       CREN_bit = 0;
       Delay_ms(10);
       CREN_bit = 1;
     }
     return (RCREG);
}
