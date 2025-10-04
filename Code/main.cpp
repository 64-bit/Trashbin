//#include <iostream>

volatile unsigned int* LED_Green = (unsigned int*) 0x10000;
volatile unsigned int* LED_Red = (unsigned int*) 0x10004;
volatile unsigned int* HexDisplay = (unsigned int*) 0x10008;

volatile unsigned int* Switches = (unsigned int*) 0x11000;
volatile unsigned int* Keys = (unsigned int*) 0x11004;

/* From verilog
reg [15:0] LED_Green; //0x0000 8 LEDS
reg [15:0] LED_Red;	 //0x0004 10 LEDS
reg [15:0] HexDisplay;//0x0008

reg [15:0] Switches; //0x1000    10 Switches
reg [15:0] Keys;		//0x1004 4 Keys
*/

void main()
{
    int counter = 0;

    while(true)
    {
        *LED_Green = counter;
        int shifted = counter >> 8;
        *LED_Red = shifted;

        *HexDisplay = counter;

        counter++;
    }


}
