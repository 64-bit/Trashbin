

module TrashbinSOC(

input wire CoreClock,

output wire [7:0] w_LED_Green,
output wire [9:0] W_LED_Red,
output wire [15:0] w_HexDisplay,

input wire [9:0] w_Switches,
input wire [3:0] w_Keys

);


wire [31:0] DebugData;


//assign LEDS[9:0] = DebugData[29:20];
//assign LEDS_G[0] = DebugData[0];
//assign LEDS_G[1] = StartupSignal;

//assign HexDisplay = {AddressBus[15:0]};

//Memory Wires
wire [31:0] AddressBus;
wire [31:0] DataReadBus;
wire [31:0] DataWriteBus;

wire WriteAssert;

wire [13:0] AddressBus_P;
//Peripheral Wires
wire [31:0] DataWriteBus_P;
wire WriteAssert_P;
wire [31:0] DataReadBus_p;



reg StartupSignal = 1'd0;

reg StartupCounter = 1'd0;

always @(posedge CoreClock)
begin
	StartupCounter <= 1'd1;
end


always @(posedge CoreClock)
begin
	if(StartupCounter == 1) begin
		StartupSignal <= 1'd1;
	end
end


CpuDataInterface cpuDataInterface();

FirstMemoryController firstMemoryController(

	CoreClock,

	cpuDataInterface.MemoryController,
	
	AddressBus,
	DataWriteBus,
	WriteAssert,
	DataReadBus,
	
	AddressBus_P,
	DataWriteBus_P,
	WriteAssert_P,
	DataReadBus_p
);


TempRam datRam(
	AddressBus[13:0],
	CoreClock,
	DataWriteBus,
	WriteAssert,
	DataReadBus);


TrashbinCore Core(
	CoreClock,
	DebugData,
	
	cpuDataInterface.CPU
	
	//Memory bus
	//AddressBus,
	//DataReadBus,
	//DataWriteBus,
	//WriteAssert,
	
	
	//1'b1, //Read OK
	//1'b1 //Write OK
);


BasicGPIO GPIO_Controller(
	CoreClock,

	AddressBus_P,
	DataReadBus_p,
	DataWriteBus_P,
	WriteAssert_P,

	w_LED_Green,
	W_LED_Red,
	w_HexDisplay,
	
	w_Switches,
	w_Keys
);


endmodule
