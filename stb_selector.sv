import lc3b_types::*;

module stb_selector
(
	input lc3b_word in,
	input logic sel,
	output lc3b_word out
);

always_comb
begin
	if(sel == 0)
		out = in;
	else
		out = {{in[7:0]},{8'b0}}; 
end

endmodule : stb_selector