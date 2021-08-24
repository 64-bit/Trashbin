

module TrashbinSOC(

input wire CoreClock,

output wire [9:0] LEDS,
output wire [7:0] LEDS_G
);


wire [31:0] DebugData;


assign LEDS[9:0] = DebugData[29:20];
assign LEDS_G[0] = DebugData[0];

//Memory Wires
wire [31:0] AddressBus;
wire [31:0] DataReadBus;
wire [31:0] DataWriteBus;

wire WriteAssert;


TempRam datRam(
	AddressBus[13:0],
	CoreClock,
	DataWriteBus,
	WriteAssert,
	DataReadBus);


TrashbinCore Core(
	CoreClock,
	DebugData,
	
	//Memory bus
	AddressBus,
	DataReadBus,
	DataWriteBus,
	WriteAssert
);


endmodule