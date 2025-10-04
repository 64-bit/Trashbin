# 0 "/home/FemboyWarlord/repos/Trashbin/Code/main.cpp"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "/home/FemboyWarlord/repos/Trashbin/Code/main.cpp"


volatile unsigned int* LED_Green = (unsigned int*) 0x10000;
volatile unsigned int* LED_Red = (unsigned int*) 0x10004;
volatile unsigned int* HexDisplay = (unsigned int*) 0x10008;

volatile unsigned int* Switches = (unsigned int*) 0x11000;
volatile unsigned int* Keys = (unsigned int*) 0x11004;
# 19 "/home/FemboyWarlord/repos/Trashbin/Code/main.cpp"
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
