

//Interface for bringing IO lines in and out of the core for:

//GPIO
//Board LED's / Hex Display
//Board buttons and switches
//Serial UART (both to PC and possibly a MCU)
//I2C
//SPI
//SD Card 

interface IOInterface ();

	wire [6:0] HEX0;
	wire [6:0] HEX1;
	wire [6:0] HEX2;
	wire [6:0] HEX3;

	wire [9:0] Switch;
	wire [3:0] Key;
	
	wire[7:0] LED_Green;
	wire [9:0] LED_Red;
	
  ///////// UART ///////// 2.5 V ///////
   wire	UART_RX;
   wire	UART_TX;
	
	///////// I2C ///////// 2.5 V ///////
   wire	I2C_SCL; //output
   logic	I2C_SDA;	//tri-state
	
	///////// SD ///////// 3.3-V LVTTL ///////
   wire             SD_CLK;//output
   logic              SD_CMD;//tri-state
   logic       [3:0]  SD_DAT;//tri-state


endinterface