import lc3b_types::*;

module vc_dirty_buffer
(
	input 				clk,
	input logic			load,
	input logic			in,
	output logic		out	
);

initial
begin
out = 1'b0;
end

always_ff @(posedge clk)
begin
	if(load)
		out <= in;
	else
		out <= out;
end

endmodule : vc_dirty_buffer