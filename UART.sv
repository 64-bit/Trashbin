module UART(

input core_clock,
input uart_clock,


output tx,
input rx,


input WriteData[7:0],
input WriteAssert,

output ReadData[7:0],
input ReadAssert,

output WriteBufferSize[9:0],
output ReadBufferSize[9:0]

);

//Write on TX'er side
//Read on CPU Side
/*
UartFIFO RXFifo(
	//data,
	core_clock,
	ReadAssert,
	//wrclk,
	//wrreq,
	ReadData,
	//rdempty,
	ReadBufferSize,
	//wrfull,
	//wrusedw);

);

//Write on CPU Sdie
//Read on TX'er Side

UartFIFO TXFifo(
	WriteData,
	//rdclk,
	//rdreq,
	core_clock,
	WriteAssert,
	//q,
	//rdempty,
	//rdusedw,
	//wrfull,
	WriteBufferSize);

);
*/

/*
module UartFIFO (
	data,
	rdclk,
	rdreq,
	wrclk,
	wrreq,
	q,
	rdempty,
	rdusedw,
	wrfull,
	wrusedw);

	input	[7:0]  data;
	input	  rdclk;
	input	  rdreq;
	input	  wrclk;
	input	  wrreq;
	output	[7:0]  q;
	output	  rdempty;
	output	[9:0]  rdusedw;
	output	  wrfull;
	output	[9:0]  wrusedw;
*/

endmodule