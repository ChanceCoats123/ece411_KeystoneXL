import lc3b_types::*;

module vc_data_buffer
(
	input 						clk,
	input logic					load,
	input lc3b_full_chunk	in,
	output lc3b_full_chunk	out
);

always_ff @(posedge clk)
begin
	if(load)
		out <= in;
	else
		out <= out;
end

endmodule : vc_data_buffer