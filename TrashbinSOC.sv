

module TrashbinSOC(

input wire CoreClock,

IOInterface IO
);


wire [31:0] DebugData;
wire [7:0] DummyGreen;

//Memory Wires
wire [31:0] AddressBus;
wire [31:0] DataReadBus;
wire [31:0] DataWriteBus;
wire WriteAssert;
wire ReadAssert;

wire [13:0] AddressBus_P;
//Peripheral Wires
wire [31:0] DataWriteBus_P;
wire WriteAssert_P;
wire ReadAssert_P;
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

//assign w_LED_Green[0] = StartupCounter;
//assign w_LED_Green[7:1] = DebugData[6:0];

CpuDataInterface cpuDataInterface();
MMPeripheralInterface GPIOMemoryInterface();

FirstMemoryController firstMemoryController(

	CoreClock,

	cpuDataInterface.MemoryController,
	
	AddressBus,
	DataWriteBus,
	WriteAssert,
	ReadAssert,
	DataReadBus,
	
	GPIOMemoryInterface.MemoryController
);


TempRam datRam(
	AddressBus[15:2],
	CoreClock,
	DataWriteBus,
	WriteAssert,
	DataReadBus);


TrashbinCore Core(
	CoreClock,
	DebugData,
	
	cpuDataInterface.CPU
);


BasicGPIO GPIO_Controller(
	CoreClock,
	GPIOMemoryInterface.Peripheral,
	IO,
);


endmodule
