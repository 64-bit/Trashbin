#pragma once

//Driver code for hardware Input/output devices

//8 Green LEDS, 1 per bit
volatile unsigned int* const LED_Green = (unsigned int*) 0x10000;
//10 Red LEDS, 1 per bit
volatile unsigned int* const LED_Red = (unsigned int*) 0x10004;
//4 7 segment displays showing the lower 16 bits of the value in HEX
volatile unsigned int* const HexDisplay = (unsigned int*) 0x10008;

//10 hardware switches, 1 bit per switch
volatile unsigned int* const Switches = (unsigned int*) 0x11000;
//4 buttons, 1 bit per button
volatile unsigned int* const Keys = (unsigned int*) 0x11004;