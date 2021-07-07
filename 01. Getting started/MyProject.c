

void MSdelay(unsigned int val);


void main() {

     trisb = 0;       // PORT B is configured as ouput
     
     while(1){
              latb0_bit = 1;  // Turns LED on
              MSdelay(500);   // 500ms delay
              latb0_bit = 0;  // Turns LED off
              MSdelay(500);   // 500ms delay
     }

}


void MSdelay(unsigned int val)
{
 unsigned int i,j;
 for(i=0;i<val;i++)
     for(j=0;j<165;j++);         /*This count Provide delay of 1 ms for 8MHz Frequency */
 }