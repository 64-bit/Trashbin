
module TrashbinCore(

input wire CoreClock,

output wire [31:0] DebugData,


//Memory
output reg [31:0] AddressBus,
input wire [31:0] DataReadBus,
output wire [31:0] DataWriteBus,

output wire WriteAssert,

input wire ReadOK,
input wire WriteOK


);


assign WriteAssert = 0;

assign DebugData[0] = DataReadBus[0];

assign DebugData[31:1] = CurrentInstruction[31:1];


//Main CPU Core, this should be separate from any memory system / L1 cache / on-die ram


reg [4:0] CPU_PHASE = 0;
//Explain plz bro

//Phase 0: Clock PC into memory, issue read
//Phase 1: Wait for memory read to succeed, if so, clock result into current instruction register
//Phase 2: Clocking ins into reg will trigger it's execution, by the time phase 2 clocks, the instruction will be finished,
	//Different paths may be taken here
	
	//A: reg->reg Write result to register, increment program counter
	//B: Store: Issue memory write (address calc is part of 1) 
	//C: Load: This is the slower one, as phase 1 sets up the address bus for memory, and this clock issues the read
	//D: Branch/Jump Clock data into both return result register and the program counter
	
//Phase 3:
	//C: Load: clock data bus into register, increment PC (possibly always increment PC here, and just idle in other ins for simplicity


always@ (posedge CoreClock)
begin

	if(CPU_PHASE == 4)
	begin
		CPU_PHASE <= 0;
	end if(CPU_PHASE == 1) begin
		if(ReadOK)
		begin
			CPU_PHASE <= CPU_PHASE + 1;		
		end
	end else begin	
	if(!InvalidInstruction)
		begin
				CPU_PHASE <= CPU_PHASE + 1;
		end
	end
end


reg [31:0] ProgramCounter;
initial ProgramCounter = 32'd0;

always@ (posedge CoreClock)
begin
	if(CPU_PHASE == 4)
	begin
		ProgramCounter <= ProgramCounter+4;
	end
end

//Instruction read

reg [31:0] CurrentInstruction;

always@ (posedge CoreClock)
begin
	if(CPU_PHASE == 1)
	begin
		CurrentInstruction <= DataReadBus;
	end
end







//RegisterFile

wire [31:0] RegisterWriteData;
wire [4:0] RegisterWriteTarget;
wire RegisterWriteEnable;

wire [31:0] RegisterReadPortA;
wire [4:0] RegisterReadTargetA;
wire [31:0] RegisterReadPorB;
wire [4:0] RegisterReadTargetB;


//TODO:Can this be hard-wired or is it more involved to set reg read A/B
assign RegisterReadTargetA = RS1;
assign RegisterReadTargetB = RS2;
assign RegisterWriteTarget = RD;

RegisterFile registerFile
(
	CoreClock,

	RegisterWriteData,
	RegisterWriteTarget,
	RegisterWriteEnable,
	
	RegisterReadPortA,
	RegisterReadTargetA,
	RegisterReadPorB,
	RegisterReadTargetB
);


//ALU Stuff

wire [31:0] LHS;
wire [31:0] RHS;
wire [31:0] ALU_Result;
wire [4:0] ALU_Func;

ALU alu(
	LHS,
	RHS,
	ALU_Result,
	ALU_Func
);

//Instruction Decoder
wire InvalidInstruction;

	//Register outputs
	wire [4:0] RD;
	wire [4:0] RS1;
	wire [4:0] RS2;
	
	//Decoded imediate outputs
	wire [31:0] DecodedImediate;
	
	//Control outputs
	wire [1:0] LHSSource;
	wire [1:0] RHSSource;


InstructionDecoder instructionDecoder(
	CurrentInstruction,
	
	RD,
	RS1,
	RS2,
	
	DecodedImediate,
	LHSSource,
	RHSSource,

	InvalidInstruction
);


//Bus Drivers - Move to other files ???
always@ (*)
begin

	AddressBus <= ProgramCounter;
	//TODO:Load & Store
end

//LHS bus driver
always@ (*)
begin 
	
end

//RHS bus driver



endmodule

