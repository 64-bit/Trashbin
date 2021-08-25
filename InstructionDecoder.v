
module InstructionDecoder(

	input wire[31:0] Instruction,

	//Register outputs
	output reg [4:0] RD,
	output reg [4:0] RS1,
	output reg [4:0] RS2,
	
	//Decoded imediate outputs
	output reg [31:0] DecodedImediate,
	
	//Control outputs
	output reg [1:0] LHSsource,
	output reg [1:0] RHSsource,


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

wire [2:0] funct3;
assign funct3 = Instruction [14:12];

wire [6:0] funct7;
assign funct7 = Instruction[31:25];



always @ (Instruction) begin

	InvalidInstructionSignal <= 1'b0;
	DecodedImediate <= 32'd0;

	case(opcode)
		
		//OPI
		
		
		
		
		
		
		//OP
		7'b01100?? : begin		
		case({Instruction[30] ,funct3})
		
		4'b0000 : begin //ADD
		//LHS => rs1
		//RHS => rs2
		//ALU mode => add
		//WriteTarget => reg
		//WriteReg => rd
		end
		
		
		
		default: begin InvalidInstructionSignal <= 1'b1; end
		endcase
		end
		

		default: begin	
			InvalidInstructionSignal <= 1'b1;		
		end

	endcase
	
end


endmodule
