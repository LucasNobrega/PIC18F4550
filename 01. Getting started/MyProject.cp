#line 1 "C:/Users/lucas/pic/01. Getting started/MyProject.c"


void MSdelay(unsigned int val);


void main() {

 trisb = 0;

 while(1){
 latb0_bit = 1;
 MSdelay(500);
 latb0_bit = 0;
 MSdelay(500);
 }

}


void MSdelay(unsigned int val)
{
 unsigned int i,j;
 for(i=0;i<val;i++)
 for(j=0;j<165;j++);
 }
