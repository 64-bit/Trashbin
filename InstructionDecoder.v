
module InstructionDecoder(

	input wire[31:0] Instruction,

	//Register outputs
	output wire [4:0] RD,
	output wire [4:0] RS1,
	output wire [4:0] RS2,
	
	//Decoded imediate outputs
	output reg [31:0] DecodedImediate,
	
	//Control outputs
	output reg [1:0] LHSsource,
	output reg [1:0] RHSsource,
	output reg [3:0] ALUOperation,
	
	
	//Other random crap control signals

	output reg WritesRegisterFile,
	output reg WritesRam,
	output reg ReadsRam,

	//Error handling / debug signals
	output reg InvalidInstructionSignal
);


wire [6:0] opcode;
assign opcode = Instruction[6:0];

wire [4:0] rd;
assign rd = Instruction[11:7];
assign RD = rd;

wire [4:0] rs1;
assign rs1 = Instruction[19:15];
assign RS1 = rs1;

wire [4:0] rs2;
assign rs2 = Instruction[24:20];
assign RS2 = rs2;

wire [2:0] funct3;
assign funct3 = Instruction [14:12];

wire [6:0] funct7;
assign funct7 = Instruction[31:25];



always @ (*) begin

	InvalidInstructionSignal <= 1'b0;
	DecodedImediate <= 32'd0;
	LHSsource <= 2'd0;	
	RHSsource <= 2'd0;	

	ALUOperation <= 4'd0;
	
	WritesRegisterFile <= 0;

	casez (opcode)
		
		//OPI
		
		
				
		
		//OP
		7'b01100?? : begin

		//All ops can directly consume this concatinated thing into the ALU
		ALUOperation <= {Instruction[30] ,funct3};
		//All ops use the same read/write ports
		LHSsource <= 2'd0;	
		RHSsource <= 2'd0;	
		
		
		case({Instruction[30] ,funct3})
		
		
		4'b0000 : begin //ADD
		//LHS => rs1
		//RHS => rs2
		//ALU mode => add
			WritesRegisterFile <= 1;
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
