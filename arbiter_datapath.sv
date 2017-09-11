import lc3b_types::*;

module arbiter_datapath
(
	/* Inputs Here! */
	input logic arbiter_fsm_sel,
	
	input lc3b_word L1I_address,
	input lc3b_word L1D_address,
	
	input lc3b_chunk L1I_data,
	input lc3b_chunk L1D_data,
	
	/* Outputs Here! */
	output lc3b_word address_mux_out,
	output lc3b_chunk data_mux_out
);

/* Internal Signals */

mux2 address_mux
(
	.sel(arbiter_fsm_sel),
	.a(L1I_address),
	.b(L1D_address),
	.f(address_mux_out)
);

mux2 #(.width(128)) data_mux
(
	.sel(arbiter_fsm_sel),
	.a(L1I_data),
	.b(L1D_data),
	.f(data_mux_out)
);

endmodule : arbiter_datapath