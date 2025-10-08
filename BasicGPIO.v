
module BasicGPIO(

input CoreClock,

MMPeripheralInterface.Peripheral	MemoryController,

IOInterface IO
);


reg [15:0] LED_Green; //0x0000
reg [15:0] LED_Red;	 //0x0004
reg [15:0] HexDisplay;//0x0008

reg [15:0] Switches; //0x1000
reg [15:0] Keys;		//0x1004

reg [15:0] DataReadRegister;

assign MemoryController.DataReadBus = {16'h0, DataReadRegister};
assign MemoryController.WriteOK = 1'b1;
assign MemoryController.ReadOK = 1'b1;

//Always, drive output values from register
assign IO.LED_Green = LED_Green[7:0];
assign IO.LED_Red = LED_Red[9:0];

//On every clock, latch the input values
always@(posedge CoreClock)
begin
	Switches[9:0] <= IO.Switch;
	Keys[3:0] <= ~IO.Key;
end

//Always, drive the data read bus with the correct register
always@(*)
begin
	DataReadRegister[15:0] <= 16'h0;
	
	case(MemoryController.AddressBus[15:0])

	16'h0000: DataReadRegister[15:0] <= LED_Green;
	16'h0004: DataReadRegister[15:0] <= LED_Red;
	16'h0008: DataReadRegister[15:0] <= HexDisplay;
	
	16'h000C: DataReadRegister[15:0] <= Switches;
	16'h0010: DataReadRegister[15:0] <= Keys;
	
	endcase
end

//On every clock, if write assert, write to a writeable register

always@(posedge CoreClock)
begin
	if(MemoryController.WriteAssert) begin
		case(MemoryController.AddressBus[15:0])
 
			16'h0000: LED_Green <= MemoryController.DataWriteBus[15:0];
			16'h0004: LED_Red <= MemoryController.DataWriteBus[15:0];
			16'h0008: HexDisplay <= MemoryController.DataWriteBus[15:0];
 
		endcase
	end
end



//7 Segment displays
SevenSegment seg0(
HexDisplay[3:0],
IO.HEX0
);

SevenSegment seg1(
HexDisplay[7:4],
IO.HEX1
);

SevenSegment seg2(
HexDisplay[11:8],
IO.HEX2
);

SevenSegment seg3(
HexDisplay[15:12],
IO.HEX3
);


endmodule