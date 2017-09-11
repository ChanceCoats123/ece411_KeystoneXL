import lc3b_types::*;

module mult_div_alu
(
	input clk,
	input logic multi_en,
	input logic div_en,
	input lc3b_word a,
	input lc3b_word b,
	output lc3b_word result
);

/* Internal Signals */
lc3b_word	mult_out;
lc3b_word	div_out;

multiplier multiplier
(
	.clken(multi_en),
	.clock(clk),
	.dataa(a[7:0]),
	.datab(b[7:0]),
	.result(mult_out)
);

dividor divider
(
	.clken(div_en),
	.clock(clk),
	.denom(b),
	.numer(a),
	.quotient(div_out),
	.remain()
);

mux2 #(.width(16)) output_mux
(
	.sel(div_en),
	.a(mult_out),
	.b(div_out),
	.f(result)
);

endmodule : mult_div_alu