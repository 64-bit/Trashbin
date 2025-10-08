# 0 "/home/FemboyWarlord/repos/Trashbin/Code/main.cpp"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "/home/FemboyWarlord/repos/Trashbin/Code/main.cpp"





volatile unsigned int* const LED_Green = (unsigned int*) 0x10000;

volatile unsigned int* const LED_Red = (unsigned int*) 0x10004;

volatile unsigned int* const HexDisplay = (unsigned int*) 0x10008;


volatile unsigned int* const Switches = (unsigned int*) 0x1000C;

volatile unsigned int* const Keys = (unsigned int*) 0x10010;

void main()
{
    int counter = 0;
    while((*Keys & 0x1) == 0)
    {
        *LED_Red = counter >> 8;
        counter++;
    }


    counter = 0;

    while(true)
    {
        int shifted = counter >> 8;
        *LED_Green = shifted;
        shifted = shifted >> 8;
        *LED_Red = shifted;

        *HexDisplay = shifted;

        counter++;

    }
}
