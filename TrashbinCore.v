
module TrashbinCore(

input wire CoreClock,

output wire [31:0] DebugData,


//Memory
/*
output reg [31:0] AddressBus,
input wire [31:0] DataReadBus,
output wire [31:0] DataWriteBus,

output wire WriteAssert,

input wire ReadOK,
input wire WriteOK
*/

CpuDataInterface coreMemoryInterface



);


//Memory interface binding stuff

//output reg [31:0] AddressBus,
//input wire [31:0] DataReadBus,
//output wire [31:0] DataWriteBus,

//output wire WriteAssert,

//input wire ReadOK,
//input wire WriteOK



assign coreMemoryInterface.WriteAssert = 0;

assign DebugData[0] = coreMemoryInterface.DataReadBus[0];

//assign DebugData[31:1] = CurrentInstruction[31:1];
assign DebugData[31:1] = RegisterReadPortA[31:1];

//Main CPU Core, this should be separate from any memory system / L1 cache / on-die ram


reg [4:0] CPU_PHASE;
initial CPU_PHASE = 5'd0;
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
	end else if(CPU_PHASE == 1) begin
		if(coreMemoryInterface.ReadOK == 1)
		begin
			CPU_PHASE <= CPU_PHASE + 1;		
		end
	end else if(CPU_PHASE == 2) begin
		if(InvalidInstruction == 1)
		begin		
			//OH SHIT we hard locked
		end else begin
			CPU_PHASE <= CPU_PHASE + 1;		
		end
	end else begin
		CPU_PHASE <= CPU_PHASE + 1;
	end
end


reg [31:0] ProgramCounter;
initial ProgramCounter = 32'd0;

wire IsBranchTaken = ALU_Comparisons[BranchCondition];

always@ (posedge CoreClock)
begin
	if(CPU_PHASE == 3)
	begin
	
		if(IsBranchInstruction && IsBranchTaken)
		begin
			ProgramCounter <= ProgramCounter + DecodedImediate;
		
		end else if(IsJumpInstruction) begin
		
			if(JumpMode) begin 
			//JARL
				ProgramCounter <= RegisterReadPortA + DecodedImediate;			
			end else begin
			//JAL
				ProgramCounter <= ProgramCounter + DecodedImediate;
			end
			
		end else begin
			ProgramCounter <= ProgramCounter+4;
		end
	
	end
end

//Instruction read

reg [31:0] CurrentInstruction;

always@ (posedge CoreClock)
begin
	if(CPU_PHASE == 1)
	begin
		CurrentInstruction <= coreMemoryInterface.DataReadBus;
	end
end







//RegisterFile

wire [31:0] RegisterWriteData;
wire [4:0] RegisterWriteTarget;
wire RegisterWriteEnable;

wire [31:0] RegisterReadPortA;
wire [4:0] RegisterReadTargetA;
wire [31:0] RegisterReadPortB;
wire [4:0] RegisterReadTargetB;


//TODO:Can this be hard-wired or is it more involved to set reg read A/B
assign RegisterReadTargetA = RS1;
assign RegisterReadTargetB = RS2;
assign RegisterWriteTarget = RD;

assign RegisterWriteEnable = (CPU_PHASE == 3) & WritesRegisterFile;


RegisterFile registerFile
(
	CoreClock,

	RegisterWriteData,
	RegisterWriteTarget,
	RegisterWriteEnable,
	
	RegisterReadPortA,
	RegisterReadTargetA,
	RegisterReadPortB,
	RegisterReadTargetB
);


//ALU Stuff

wire [31:0] LHS;
wire [31:0] RHS;
wire [31:0] ALU_Result;
wire [5:0] ALU_Comparisons;
wire [3:0] ALU_Func;

ALU alu(
	LHS,
	RHS,
	ALU_Result,
	ALU_Comparisons,
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
	wire [2:0] LHSSource;
	wire [1:0] RHSSource;
	
	wire IsBranchInstruction;
	wire [2:0] BranchCondition;
	
	wire IsJumpInstruction;
	wire JumpMode; //0 == JAL, 1 == JALR
	
	wire IsMemoryWrite;
	wire IsMemoryRead;
	wire [1:0] MemoryAccessWidth;
	wire MemoryAccessSignExtend;
	

InstructionDecoder instructionDecoder(
	CurrentInstruction,
	
	RD,
	RS1,
	RS2,
	
	DecodedImediate,
	LHSSource,
	RHSSource,
	ALU_Func,
	//Other random control signals
	WritesRegisterFile,
	WritesRam,
	ReadsRam,
	
	IsBranchInstruction,
	BranchCondition,
	
	IsJumpInstruction,
	JumpMode,
	
	IsMemoryWrite,
	IsMemoryRead,
	MemoryAccessWidth,
	MemoryAccessSignExtend,
		
	InvalidInstruction
);


//Bus Drivers - Move to other files ???
always@ (*)
begin

	coreMemoryInterface.AddressBus <= { 2'b00, ProgramCounter[31:2]}; //TODO:MOVE THIS TO MEMORY CONTROLLER HOLY SHIT
	//TODO:Load & Store
end


wire [7:0] DebugProgramCounterShort = ProgramCounter[7:0];

//Bus driver sources 



//LHS bus driver

assign LHS = LHSBusDriver(
	LHSSource,
	
	RegisterReadPortA,
	DecodedImediate,
	coreMemoryInterface.DataReadBus,
	ProgramCounter

);

function [31:0] LHSBusDriver;
	input [2:0] sourceSelect;

	input [31:0] RegisterPortA;
	input [31:0] ImediateValue;
	input [31:0] MemoryReadPort;
	input [31:0] ProgramCounter;

	begin
	
	case(sourceSelect)
	
		3'b000 : LHSBusDriver = RegisterPortA;//Mem -> Base value for memory access
		3'b001 : LHSBusDriver = ImediateValue;
		3'b010 : LHSBusDriver = MemoryReadPort;
		3'b011 : LHSBusDriver = 32'd0;
		3'b100 : LHSBusDriver = ProgramCounter;
	
		default : LHSBusDriver = 32'd0;
	endcase
	
	end
endfunction



//RHS bus driver
assign RHS = RHSBusDriver(
	RHSSource,
	
	RegisterReadPortB,
	DecodedImediate,
	coreMemoryInterface.DataReadBus
);

function [31:0] RHSBusDriver;
	input [1:0] sourceSelect;

	input [31:0] RegisterPortB;
	input [31:0] ImediateValue;
	input [31:0] MemoryReadPort;
	
	begin
	
	case(sourceSelect)
	
		2'b00 : RHSBusDriver = RegisterPortB;//Mem -> Store Source
		2'b01 : RHSBusDriver = ImediateValue;//Mem -> Load/Store offset 
		2'b10 : RHSBusDriver = MemoryReadPort;
		2'b11 : RHSBusDriver = 32'd4;
	
		default : RHSBusDriver = 32'd0;
	endcase
	
	end
endfunction

//Register write bus driver
assign RegisterWriteData = RegisterWriteBusDriver(
	2'b00,	
	ALU_Result
);

function [31:0] RegisterWriteBusDriver;
	input [1:0] sourceSelect;

	input [31:0] ALUResult;
	
	begin
	
	case(sourceSelect)
	
		2'b00 : RegisterWriteBusDriver = ALUResult;

	
		default : RegisterWriteBusDriver = 32'd0;
	endcase
	
	end
endfunction

endmodule
