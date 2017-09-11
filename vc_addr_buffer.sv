import lc3b_types::*;

module vc_addr_buffer
(
	input 						clk,
	input logic					load,
	input lc3b_word			in,
	output lc3b_word			out
);

always_ff @(posedge clk)
begin
	if(load)
		out <= in;
	else
		out <= out;
end

endmodule : vc_addr_buffer