
interface CpuDataInterface ();

logic [31:0] AddressBus;
logic [31:0] DataReadBus;
logic [31:0] DataWriteBus;

logic WriteAssert;
logic ReadAssert;

logic ReadOK;
logic WriteOK;


modport CPU (output AddressBus, input DataReadBus, output DataWriteBus, output WriteAssert, output ReadAssert, input ReadOK, input WriteOK);
modport MemoryController (input AddressBus, output DataReadBus, input DataWriteBus, input WriteAssert, input ReadAssert, output ReadOK, output WriteOK);

endinterface
