#line 1 "C:/Users/lucas/pic/02. ADC/MyProject.c"
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for pic/include/stdio.h"
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for pic/include/stdlib.h"







 typedef struct divstruct {
 int quot;
 int rem;
 } div_t;

 typedef struct ldivstruct {
 long quot;
 long rem;
 } ldiv_t;

 typedef struct uldivstruct {
 unsigned long quot;
 unsigned long rem;
 } uldiv_t;

int abs(int a);
float atof(char * s);
int atoi(char * s);
long atol(char * s);
div_t div(int number, int denom);
ldiv_t ldiv(long number, long denom);
uldiv_t uldiv(unsigned long number, unsigned long denom);
long labs(long x);
int max(int a, int b);
int min(int a, int b);
void srand(unsigned x);
int rand();
int xtoi(char * s);
#line 1 "c:/users/lucas/pic/02. adc/lcd.h"









void LCD_Init();
void LCD_Command(char );
void LCD_Char(char x);
void LCD_String(const char *);
void MSdelay(unsigned int );
void LCD_String_xy(char ,char , char*);
#line 6 "C:/Users/lucas/pic/02. ADC/MyProject.c"
void ADC_Init();
int ADC_Read(int channel);


char dados[10];
int digital;
float volt;


void main() {



 OSCCON = 0b01110010;
 LCD_Init();
 ADC_Init();

 LCD_String_xy(1, 1, "Tensao...");

 while(1){

 digital = ADC_Read(0);


 volt = digital*((float) 5.0  / (float)1023);


 sprintf(dados, "%.2f", volt);

 strcat(dados, "V");

 LCD_String_xy(2, 4, dados);
 }
}








void ADC_Init(){

 trisa = 0b11111111;


 ADCON1 = 0b00001110;



 ADCON0 = 0b00000001;


 ADCON2 = 0b10010010;


 ADRESH = 0;
 ADRESL = 0;
}


int ADC_Read(int channel){
 int digital;


 ADCON0 &= 0b11000011;
 ADCON0 |= ( (channel<<2) & (0b0011110) );


 ADON_bit = 1;


 GO_bit = 1;



 while(GO_bit == 1);


 digital = (ADRESH*256) | (ADRESL);


 return (digital);


}
