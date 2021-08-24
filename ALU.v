
module ALU(
input [31:0] LHS,
input [31:0] RHS,

output [31:0] Result,

input [4:0] Function,

input Clock

);

function [31:0] ALU_Logic;
	input [31:0] lhs;
	input [31:0] rhs;
	input [4:0] func;
	begin
	
	case(func)
	
	
		default : ALU_Logic = 32'd0;
	endcase
	
	end
endfunction

assign Result = ALU_Logic(LHS,RHS,Function);

endmodule
