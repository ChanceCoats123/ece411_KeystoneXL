import lc3b_types::*;

module mux8
(
	input logic[2:0] sel,
	input lc3b_word a,b,c,d,e,f,g,h,
	output lc3b_word out
);

always_comb 
begin
	unique case(sel)
			3'b000: out = a;
			3'b001: out = b;
			3'b010: out = c;
			3'b011: out = d;
			3'b100: out = e;
			3'b101: out = f;
			3'b110: out = g;
			3'b111: out = h;
			default: /* Do nothing */ ;
		endcase	
end

endmodule : mux8