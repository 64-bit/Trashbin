
module InstructionDecoder(

	input wire[31:0] Instruction,




	output reg InvalidInstructionSignal
);


wire [6:0] opcode;
assign opcode = Instruction[6:0];

wire [4:0] rd;
assign rd = Instruction[11:7];

wire [4:0] rs1;
assign rs1 = Instruction[19:15];

wire [4:0] rs2;
assign rs1 = Instruction[24:20];




always @ (Instruction) begin

	case(opcode)
		

		default: begin	
			InvalidInstructionSignal <= 1;		
		end

	endcase
	
end


endmodule
