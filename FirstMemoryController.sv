
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



assign cpuInterface.ReadOK = 1'b1;
assign cpuInterface.WriteOK = 1'b1;

assign AddressBus = cpuInterface.AddressBus;
assign DataWriteBus = cpuInterface.DataWriteBus;

assign WriteAssert = cpuInterface.WriteAssert;

assign cpuInterface.DataReadBus = DataReadBus;


endmodule
