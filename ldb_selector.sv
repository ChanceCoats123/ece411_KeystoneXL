import lc3b_types::*;

module ldb_selector #(parameter width = 16)
(
	input [width-1:0] in,
	input logic [1:0] sel,
	output lc3b_word out
);

always_comb
begin
	unique case(sel)
		2'b00: out = in;
		2'b01: out = in;
		2'b10: out = {{8'b0},{in[7:0]}};
		2'b11: out = {{8'b0},{in[15:8]}};
		default: /* Do nothing */ ;
		endcase
end

endmodule : ldb_selector