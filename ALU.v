
module ALU(
input [31:0] LHS,
input [31:0] RHS,

output [31:0] Result,

input [3:0] Function,

input Clock

);

/*

	ALU Functino mappings
	0000 -> Add
	1000 -> Subtract
	0001 -> SLL
	0010 -> SLT
	0011 -> SLTU
	0100 -> XOR
	0101 -> SRL
	1101 -> SRA
	0110 -> OR
	0111 -> AND



*/

function [31:0] ALU_Logic;
	input [31:0] lhs;
	input [31:0] rhs;
	input [3:0] func;
	begin
	
	case(func)
	
		4'b0000 : ALU_Logic = LHS + RHS;
		4'b1000 : ALU_Logic = LHS - RHS;

		
		4'b0100 : ALU_Logic = LHS ^ RHS;
		4'b0110 : ALU_Logic = LHS | RHS;
		4'b0111 : ALU_Logic = LHS & RHS;
		
	
		default : ALU_Logic = 32'd0;
	endcase
	
	end
endfunction

assign Result = ALU_Logic(LHS,RHS,Function);

endmodule
