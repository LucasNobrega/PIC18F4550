#line 1 "C:/Users/lucas/usp/ap micros/02. ADC/MyProject.c"

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
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for pic/include/string.h"





void * memchr(void *p, char n, unsigned int v);
int memcmp(void *s1, void *s2, int n);
void * memcpy(void * d1, void * s1, int n);
void * memmove(void * to, void * from, int n);
void * memset(void * p1, char character, int n);
char * strcat(char * to, char * from);
char * strchr(char * ptr, char chr);
int strcmp(char * s1, char * s2);
char * strcpy(char * to, char * from);
int strlen(char * s);
char * strncat(char * to, char * from, int size);
char * strncpy(char * to, char * from, int size);
int strspn(char * str1, char * str2);
char strcspn(char * s1, char * s2);
int strncmp(char * s1, char * s2, char len);
char * strpbrk(char * s1, char * s2);
char * strrchr(char *ptr, char chr);
char * strstr(char * s1, char * s2);
char * strtok(char * s1, char * s2);
#line 22 "C:/Users/lucas/usp/ap micros/02. ADC/MyProject.c"
void ADC_Init();
int ADC_Read(int channel);


char dados[10] = "";
int digital = 0;
float volt = 0.0;


void main() {


 ADC_Init();
 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 digital = 0;

 while(1){

 digital = ADC_Read(0);



 volt = digital*((float) 5.0  / (float)1023);


 sprintf(dados, "%.2f", volt);


 Lcd_Out(1, 2, "Tensao: ");
 Lcd_Out(2, 2, dados);
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
