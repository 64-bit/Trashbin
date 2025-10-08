
interface MMPeripheralInterface ();

wire [31:0] AddressBus;

wire [31:0] DataReadBus;
wire [31:0] DataWriteBus;

wire WriteAssert;
wire ReadAssert;

wire WriteOK;
wire ReadOK;

modport MemoryController(
	output AddressBus,
	input DataReadBus,
	output DataWriteBus,
	
	output WriteAssert,
	output ReadAssert,
	
	input WriteOK,
	input ReadOK);
	
modport Peripheral(
	input AddressBus,
	output DataReadBus,
	input DataWriteBus,
	
	input WriteAssert,
	input ReadAssert,
	
	output WriteOK,
	output ReadOK);

endinterface