
module InstructionDecoder(

	input wire[31:0] Instruction,

	//Register outputs
	output wire [4:0] RD,
	output wire [4:0] RS1,
	output wire [4:0] RS2,
	
	//Decoded imediate outputs
	output reg [31:0] DecodedImediate,
	
	//Control outputs
	output reg [2:0] LHSsource,
	output reg [1:0] RHSsource,
	output reg [3:0] ALUOperation,
	
	
	//Other random crap control signals

	output reg WritesRegisterFile,
	output reg WritesRam,
	output reg ReadsRam,
	
	output reg IsBranchInstruction,
	output reg [2:0] BranchCondition,
	
	output reg IsJumpInstruction,
	output reg JumpMode,
	
	output reg IsMemoryWrite,
	output reg IsMemoryRead,
	output reg [1:0] MemoryAccessWidth,
	output reg MemoryAccessSignExtend,
		

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

//RIP code quality. there must be a better way to write this lol...
//At least I don't have to write a X86 decoder...
//Sign extend driver does not have to be this wide, but it makes the code below cleaner, and the compiler will optimize away the un-used bits
wire [31:0] signExtendDriver = {
Instruction[31],Instruction[31],Instruction[31],Instruction[31],    Instruction[31],Instruction[31],Instruction[31],Instruction[31],
Instruction[31],Instruction[31],Instruction[31],Instruction[31],    Instruction[31],Instruction[31],Instruction[31],Instruction[31],
Instruction[31],Instruction[31],Instruction[31],Instruction[31],    Instruction[31],Instruction[31],Instruction[31],Instruction[31],
Instruction[31],Instruction[31],Instruction[31],Instruction[31],    Instruction[31],Instruction[31],Instruction[31],Instruction[31]};

wire [11:0] immediate_I_type = Instruction[31:20];
wire [31:0] immediate_I_typeSignExtended = {signExtendDriver[31:12], immediate_I_type[11:0]};

wire [11:0] immediate_S_type = {Instruction[31:25], Instruction[11:7]};
wire [31:0] immediate_S_typeSignExtended = {signExtendDriver[31:12], immediate_S_type[11:0]};

wire [12:0] immediate_B_type = {Instruction[31], Instruction[7], Instruction[30:25], Instruction[11:8], 1'd0};
wire [31:0] immediate_B_typeSignExtended = {signExtendDriver[31:13], immediate_B_type[12:0]};

wire [31:0] immediate_U_type = {Instruction[31:12], 12'd0};
wire [31:0] immediate_U_typeSignExtended = immediate_U_type;

wire [20:0] immediate_J_type = {Instruction[31], Instruction[19:12], Instruction[20], Instruction[30:21], 1'd0};
wire [31:0] immediate_J_typeSignExtended = {signExtendDriver[31:21], immediate_J_type[20:0]};


always @ (*) begin

	InvalidInstructionSignal <= 1'b0;
	DecodedImediate <= 32'd0;
	LHSsource <= 3'd0;	
	RHSsource <= 2'd0;	

	ALUOperation <= 4'd0;
	
	WritesRegisterFile <= 0;
	
	IsBranchInstruction <= 0;
	BranchCondition <= 3'd0;
	
	IsJumpInstruction <= 0;
	JumpMode <= 0;//0 == JAL, 1 == JARL
	
	IsMemoryWrite <= 0;
	IsMemoryRead <= 0;
	MemoryAccessWidth <= 2'd0; //0 == 1 byte, 1 == 2 bytes, 2 == 4 bytes
	MemoryAccessSignExtend <= 0; //0 = zero extend, 1 = sign extend

	casez (opcode)
		
		
		//Begin LUI
		7'b01101?? : begin	
		//Passthrough on ALU ?, Zero source
		//Encode as
		DecodedImediate <= immediate_U_typeSignExtended;
		ALUOperation <= 4'b0111;//AND, allows passthrough
		LHSsource <= 3'd1;//Fully Decoded Imediate	
		RHSsource <= 2'd1;//Fully Decoded Imediate	
		WritesRegisterFile <= 1;

		//end LUI
		end
		
		
		//BEGIN OPI
		7'b00100?? : begin	
		//All ops can directly consume this concatinated thing into the ALU
		ALUOperation <= {1'd0 ,funct3};
		//All ops use the same imediate format
		DecodedImediate <= immediate_I_typeSignExtended;
		
		//All ops use the same read/write ports
		LHSsource <= 3'd0;//Register file read port A	
		RHSsource <= 2'd1;//Fully Decoded Imediate	
		WritesRegisterFile <= 1;
		
		case({1'd0 ,funct3})
		
		4'b0000 : begin end//ADDI
		4'b0010 : begin end//Set less than
		4'b0011 : begin end//Set less than unsigned

		4'b0100 : begin end//XORI
		4'b0110 : begin end//ORI
		4'b0111 : begin end//ANDI
		
		//Shift operations break the rules because of course something has to
		4'b0001 : begin end //Shift left logical imediate. Decodes correctly as I type because the ALU will truncate the ALU RHS bus to 5 bits
		
		//Shift Right Logical / Arithmatic Imediate needs special case to select mode
		4'b0101 : begin
			ALUOperation <= {Instruction[30] ,3'b101};
		end
		
		default: begin InvalidInstructionSignal <= 1'b1; end
		endcase
		end
		//END OPI
		
		
		
		
		//BEGIN OP
		7'b01100?? : begin

		//All ops can directly consume this concatinated thing into the ALU
		ALUOperation <= {Instruction[30] ,funct3};
		//All ops use the same read/write ports
		LHSsource <= 3'd0;	
		RHSsource <= 2'd0;	
		WritesRegisterFile <= 1;

		
		case({Instruction[30] ,funct3})
		
		
		4'b0000 : begin //ADD
		//LHS => rs1
		//RHS => rs2
		//ALU mode => add
		end
		4'b1000 : begin //Sub
		end
		
		4'b0010 : begin end//Set less than
		4'b0011 : begin end//Set less than unsigned
		
		4'b0001 : begin end //Shift Left Logical

		4'b0100 : begin end //Xor
		4'b0101 : begin end //Shift Right Logical
		4'b1101 : begin end //Shift Right Arithmatic
		
		4'b0110 : begin //Or
		end
		4'b0111 : begin //And
		end		
		
		
		default: begin InvalidInstructionSignal <= 1'b1; end
		endcase
		end
		//END OP
		
		
		
		
		
		//BEGIN BRANCH
		7'b11000?? : begin
		DecodedImediate <= immediate_B_typeSignExtended;
		ALUOperation <= 4'b0000;//Don't Care, compare always active
		LHSsource <= 3'd0;//Fully Decoded Imediate	
		RHSsource <= 2'd0;//Fully Decoded Imediate	
		IsBranchInstruction <= 1;
		
		case(funct3)
		3'b000 : BranchCondition <= 3'd0;//==
		3'b001 : BranchCondition <= 3'd1;//!=
		3'b100 : BranchCondition <= 3'd3;//<
		3'b101 : BranchCondition <= 3'd5;//>=
		3'b110 : BranchCondition <= 3'd2;//unsigned <
		3'b111 : BranchCondition <= 3'd4;//unsigned >=
		
		
		default: begin InvalidInstructionSignal <= 1'b1; end
		endcase		
		end
		//END BRANCH
		
		
		
		
		
		//BEGIN JAL
		7'b11011?? : begin
		
		DecodedImediate <= immediate_J_typeSignExtended;
		ALUOperation <= 4'b0000;//Add, to add 4 to the Program counter

		LHSsource <= 3'd4;//Program Counter
		RHSsource <= 2'd3;//4
		
		IsJumpInstruction <= 1;
		JumpMode <= 0;//0 == JAL, 1 == JARL
		
		WritesRegisterFile <= 1;
		end
		//END JAL
		
		
		
		
		
		
		//BEGIN JARL
		7'b11001?? : begin
		
		DecodedImediate <= immediate_I_typeSignExtended;
		ALUOperation <= 4'b0000;//Add, to add 4 to the Program counter

		LHSsource <= 2'd4;//Program Counter
		RHSsource <= 2'd3;//4
		
		IsJumpInstruction <= 1;
		JumpMode <= 1;//0 == JAL, 1 == JARL
		
		WritesRegisterFile <= 1;	
		end
		//END JARL
		
		

		default: begin	
			InvalidInstructionSignal <= 1'b1;		
		end

	endcase
	
end


endmodule
