
module RegisterFile(

	input wire Clock,

	input wire [31:0] WriteData,
	input wire [4:0] WriteTarget,
	input wire WriteEnable,

	output wire [31:0] ReadPortA,
	input wire [4:0] ReadSourceA,
	
	output wire [31:0] ReadPortB,
	input wire [4:0] ReadSourceB
	
);

reg [31:0] Registers [0:31];


wire [31:0] data_b;
wire wren_b;

assign data_b = 32'b0;
assign wren_b = 1'b0;

wire [4:0] PortA_Address;
assign PortA_Address = WriteEnable ? WriteTarget : ReadSourceA;

wire SafeWriteEnable;
assign SafeWriteEnable = (WriteTarget != 5'b0) & WriteEnable;
/*
RamRegisterFile RegisterRam(
	PortA_Address,
	ReadSourceB,
	Clock,
	WriteData,
	data_b,
	SafeWriteEnable,
	wren_b,
	ReadPortA,
	ReadPortB);
*/

	/*
RamRegisterFile_Double PortA(
	Clock,
	WriteData,
	ReadSourceA,
	WriteTarget,
	SafeWriteEnable,
	ReadPortA);
	
	
RamRegisterFile_Double PortB(
	Clock,
	WriteData,
	ReadSourceB,
	WriteTarget,
	SafeWriteEnable,
	ReadPortB);
	
	*/
	
	
	
//Old Impl	
	
initial Registers[5'd0] = 32'd0;


assign ReadPortA = Registers[ReadSourceA];
assign ReadPortB = Registers[ReadSourceB];

always @ (posedge Clock)
begin

	if(WriteEnable && WriteTarget != 5'd0)//Can't write register 0
	begin
		Registers[WriteTarget] <= WriteData;
	end

end




endmodule
