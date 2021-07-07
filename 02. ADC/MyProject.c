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


#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void ADC_Init();
int ADC_Read(int channel);

#define vref 5.0
char dados[10] = "";     // To be displayed on LCD
int digital = 0;
float volt = 0.0;


void main() {

   // Interfacing wit 16x2 LCD display
   ADC_Init();              // Initialize 10-bit ADC
   Lcd_Init();
   Lcd_Cmd(_LCD_CLEAR);               // Clear display
   Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
   digital = 0;

   while(1){
            // Read channel 0
            digital = ADC_Read(0);

            
            // Convert digital value to analog (float)
            volt = digital*((float)vref / (float)1023);
            
            // Convert volt to ascii string
            sprintf(dados, "%.2f", volt);
            
            // Print on LCD
            Lcd_Out(1, 2, "Tensao: ");
            Lcd_Out(2, 2, dados);
   }
}








void ADC_Init(){
  // Configure Pins as input
  trisa = 0b11111111;             // All pins of PORT A will be used as input

  // Configure voltage reference and config pins as analog pins
  ADCON1 = 0b00001110;           // Vtg reference wwill be VDD and VSS
                                 // AN0 will be analog and the other will be digital

  // Select A/D input channel (Will be redone when reading)
  ADCON0 = 0b00000001;          // The default channel is 0, and the converter is enabled

  // Select R or L justified, acquisition time and conversion clock
  ADCON2 = 0b10010010;          // Right justified, 4Tad, Fosc/32

  // Flush ADC outut Register
  ADRESH = 0;
  ADRESL = 0;
}


int ADC_Read(int channel){
  int digital;

  // Select channel
  ADCON0 &= 0b11000011;                              // Clear channel bits
  ADCON0 |= ( (channel<<2) & (0b0011110) );           // Set channel bits
  ADON_bit = 1;

  // Starts conversion
  GO_bit = 1;

  // Wait for end of conversion (G/done == 0 -> conversion comppleted)
  // We can also use interruption!
  while(GO_bit == 1);

  // Get value from registers (Right justified)
  digital = (ADRESH*256) | (ADRESL);

  // Return value
  return (digital);


}