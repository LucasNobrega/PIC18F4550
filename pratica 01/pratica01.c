
// Variables used
int display[10] = {63, 6, 91, 79, 102, 109, 125, 7, 127, 111};
int count = 0;    // Which number to be displayed
int mode = 0;     // 1 for 1s period and 0 for 0.25 period


// TIMER0 interrupt routine (ISR)
void interrupt_Low() iv 0x0018 ics ICS_AUTO {
     if(TMR0IF_bit){           // Was the interruption from Timer0?
         TMR0ON_bit = 0;
         
         count  = (count+1)%10;   // Display next number
         portb = display[count];
         
         if(mode == 1){
                 TMR0L = 0b11011100;    // Start Timer0 with 3036 (for counting 1 second)
                 TMR0H = 0b00001011;
         }else{
               TMR0L = 0b11110111;    // Start Timer0 with 49 911 (for counting 0.25 seconds)
               TMR0H = 0b11000010;
         }
         TMR0ON_bit = 1;
     }
     TMR0IF_bit = 0;       // Clear interruption flag
}





void main() {
  ADCON1 = 0b00001111;   // Configurando todas as portas do PIC como digitais
  trisa.trisa0 = 1;      // Configurando a porta RA0 como entrada
  trisa.trisa1 = 1;      // Configurando a porta RA1 como entrada
  trisb = 0;             // Configurando toda a porta B como saída
  trisc = 0;
  portb = 63;            // The display starts at 0

  IPEN_bit = 1;          // Enables low priority interruption
  INTCON = 0b11100000;   // Enables interruption from Timer0
  
  T0CON = 0b10000100;    // TIMER0 with 16 bits, interval clock and 1:32 prescaler
  TMR0IP_bit = 0;        // Timer 0 is low priority
  
  TMR0L = 0b11011100;    // Start Timer0 with 3036 (for counting 1 second)
  TMR0H = 0b00001011;
  
  TMR0ON_bit = 1;            // Starts Timer0
  
  while(1){
    if(porta.ra0 == 0){
      mode = 1;              // 1 second period
    }
    if(porta.ra1 == 0){
      mode = 0;              // 0.25 second period
    }
  }
}