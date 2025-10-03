
module BasicGPIO(

input CoreClock,

input wire [31:0] AddressBus,
output wire [31:0] DataReadBus,
input wire [31:0] DataWriteBus,
input WriteAssert,




output wire [7:0] w_LED_Green,
output wire [9:0] W_LED_Red,
output wire [15:0] w_HexDisplay,

input wire [9:0] w_Switches,
input wire [3:0] w_Keys
);


reg [15:0] LED_Green; //0x0000
reg [15:0] LED_Red;	 //0x0004
reg [15:0] HexDisplay;//0x0008

reg [15:0] Switches; //0x1000
reg [15:0] Keys;		//0x1004

reg [15:0] DataReadRegister;

assign DataReadBus = {16'h0, DataReadRegister};


//Always, drive output values from register
assign w_LED_Green = LED_Green[7:0];
assign W_LED_Red = LED_Red[9:0];
assign w_HexDisplay = HexDisplay[15:0];

//On every clock, latch the input values
always@(posedge CoreClock)
begin
	Switches[9:0] <= w_Switches;
	Keys[3:0] <= w_Keys;
end

//Always, drive the data read bus with the correct register
always@(*)
begin
	DataReadRegister[15:0] <= 16'h0;
	
	case(AddressBus[15:0])

	16'h0000: DataReadRegister[15:0] <= LED_Green;
	16'h0004: DataReadRegister[15:0] <= LED_Red;
	16'h0008: DataReadRegister[15:0] <= HexDisplay;
	
	16'h1000: DataReadRegister[15:0] <= Switches;
	16'h1004: DataReadRegister[15:0] <= Keys;
	
	endcase
end

//On every clock, if write assert, write to a writeable register

always@(posedge CoreClock)
begin
	if(WriteAssert) begin
		case(AddressBus[15:0])
 
			16'h0000: LED_Green <= DataWriteBus[15:0];
			16'h0004: LED_Red <= DataWriteBus[15:0];
			16'h0008: HexDisplay <= DataWriteBus[15:0];
 
		endcase
	end
end


endmodule