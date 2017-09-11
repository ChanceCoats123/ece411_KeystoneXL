import lc3b_types::*;

module counter
(
	input clk,
	input logic load,
	output logic out
);

initial
begin
out = 0;
end

always_ff @(posedge clk)
begin
	if(load) begin
		case(out)
			1'b0: out <= 1'b1;
			1'b1: out <= 1'b0;
			endcase
		end		
	else
		out <= out;
end

endmodule : counter