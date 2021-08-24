
module TrashbinCore(

input wire CoreClock,

output wire [31:0] DebugData,


//Memory
output wire [31:0] AddressBus,
input wire [31:0] DataReadBus,
output wire [31:0] DataWriteBus,

output wire WriteAssert


);


assign WriteAssert = 0;

assign AddressBus = ProgramCounter;
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
	end else begin
		CPU_PHASE <= CPU_PHASE + 1;
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
	if(CPU_PHASE == 0)
	begin
		CurrentInstruction <= DataReadBus;
	end
end




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



endmodule

