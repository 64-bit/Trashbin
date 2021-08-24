
module unsaved (
	clk_clk,
	reset_reset_n,
	memory_mem_ca,
	memory_mem_ck,
	memory_mem_ck_n,
	memory_mem_cke,
	memory_mem_cs_n,
	memory_mem_dm,
	memory_mem_dq,
	memory_mem_dqs,
	memory_mem_dqs_n,
	oct_rzqin);	

	input		clk_clk;
	input		reset_reset_n;
	output	[9:0]	memory_mem_ca;
	output	[0:0]	memory_mem_ck;
	output	[0:0]	memory_mem_ck_n;
	output	[0:0]	memory_mem_cke;
	output	[0:0]	memory_mem_cs_n;
	output	[3:0]	memory_mem_dm;
	inout	[31:0]	memory_mem_dq;
	inout	[3:0]	memory_mem_dqs;
	inout	[3:0]	memory_mem_dqs_n;
	input		oct_rzqin;
endmodule
