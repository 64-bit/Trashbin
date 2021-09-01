
/*
interface CpuDataInterface ();

logic [31:0] AddressBus;
logic [31:0] DataReadBus;
logic [31:0] DataWriteBus;

logic WriteAssert;

logic ReadOK;
logic WriteOK;
*/

module FirstMemoryController(

	input wire CoreClock,

	CpuDataInterface cpuInterface,

	//Memory interface
	output wire [13:0] AddressBus,
	output wire [31:0] DataWriteBus,
	output wire WriteAssert,
	input wire [31:0] DataReadBus
);

//It would be really cool if this could keep it's single cycle read nature, at least for aligned reads/writes

wire Is4ByteAligned = cpuInterface.AddressBus[1:0] == 2'b00;
wire Is2ByteAligned = cpuInterface.AddressBus[0] == 1'b0;

reg [31:0] MisalignedWriteBuffer;
reg [31:0] MisalignedReadBuffer;

assign cpuInterface.ReadOK = 1'b1;
assign cpuInterface.WriteOK = 1'b1;

assign AddressBus = cpuInterface.AddressBus[15:2];//TODO:Support for mis-aligned LS
assign DataWriteBus = cpuInterface.DataWriteBus;

assign WriteAssert = cpuInterface.WriteAssert;

assign cpuInterface.DataReadBus = DataReadBus;









endmodule
