
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

reg [31:0] Registers [4:0];

initial Registers[5'd0] = 32'd0;


assign ReadPortA = Registers[ReadSourceA];
assign ReadPortB = Registers[ReadSourceB];

always @ (posedge Clock)
begin

	if(WriteEnable)
	begin
		Registers[WriteTarget] <= WriteData;
	end

end


endmodule

