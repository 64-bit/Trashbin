

module TrashbinSOC(

input wire CoreClock,

output wire [9:0] LEDS,
output wire [7:0] LEDS_G,

output wire [15:0] HexDisplay
);


wire [31:0] DebugData;


assign LEDS[9:0] = DebugData[29:20];
assign LEDS_G[0] = DebugData[0];
assign LEDS_G[1] = StartupSignal;

assign HexDisplay = {AddressBus[15:0]};

//Memory Wires
wire [31:0] AddressBus;
wire [31:0] DataReadBus;
wire [31:0] DataWriteBus;

wire WriteAssert;

reg StartupSignal = 1'd0;

always @(posedge CoreClock)
begin
	StartupSignal <= 1'd1;
end


CpuDataInterface cpuDataInterface();

FirstMemoryController firstMemoryController(

	CoreClock,

	cpuDataInterface.MemoryController,
	
	AddressBus,
	DataWriteBus,
	WriteAssert,
	DataReadBus
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


endmodule
