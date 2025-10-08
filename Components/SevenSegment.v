
module SevenSegment(

input [3:0] value,
output [6:0] segments

);


function [6:0] get_segs;
	input [3:0] val;
	
	begin
   case (val)
      4'h0  : get_segs[6:0] = ~7'b0111111;
      4'h1  : get_segs[6:0] = ~7'b0000110;
      4'h2  : get_segs[6:0] = ~7'b1011011;
      4'h3  : get_segs[6:0] = ~7'b1001111;

		4'h4  : get_segs[6:0] = ~7'b1100110;
      4'h5  : get_segs[6:0] = ~7'b1101101;	
      4'h6  : get_segs[6:0] = ~7'b1111101;		
      4'h7  : get_segs[6:0] = ~7'b0000111;
		
      4'h8  : get_segs[6:0] = ~7'b1111111;
      4'h9  : get_segs[6:0] = ~7'b1100111;
      4'ha  : get_segs[6:0] = ~7'b1110111;
      4'hb  : get_segs[6:0] = ~7'b1111100;

      4'hc  : get_segs[6:0] = ~7'b0111001;
      4'hd  : get_segs[6:0] = ~7'b1011110;
      4'he  : get_segs[6:0] = ~7'b1111001;
      4'hf  : get_segs[6:0] = ~7'b1110001;
		
      default : get_segs[6:0] = ~7'hf; 
    endcase	
	end
	
endfunction

assign segments[6:0] = get_segs(value);

endmodule