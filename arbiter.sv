import lc3b_types::*;

module arbiter
(
	/* Clock */
	input clk,
	/* Inputs */
	input lc3b_word	L1I_address,
	input lc3b_word	L1D_address,
	input lc3b_chunk	L1I_data,
	input lc3b_chunk	L1D_data,
	input logic			L1I_read,
	input logic			L1D_read,
	input logic			L1I_write,
	input logic			L1D_write,
	input logic			pmem_resp,
	/* Outputs */
	output logic		pmem_read,
	output logic		pmem_write,
	output lc3b_word	address_to_pmem,
	output lc3b_chunk	data_to_pmem,
	output logic		L1I_resp,
	output logic		L1D_resp
);

/* Internal Signals */
logic 		arbiter_fsm_sel;

arbiter_datapath dp
(
	.arbiter_fsm_sel(arbiter_fsm_sel),
	.L1I_address(L1I_address),
	.L1D_address(L1D_address),
	.L1I_data(L1I_data),
	.L1D_data(L1D_data),
	.address_mux_out(address_to_pmem),
	.data_mux_out(data_to_pmem)
);

arbiter_controller control
(
	.clk(clk),
	.L1I_read(L1I_read),
	.L1D_read(L1D_read),
	.L1I_write(L1I_write),
	.L1D_write(L1D_write),
	.pmem_resp(pmem_resp),
	.L1I_resp(L1I_resp),
	.L1D_resp(L1D_resp),
	.pmem_read(pmem_read),
	.pmem_write(pmem_write),
	.arbiter_fsm_sel(arbiter_fsm_sel)
);

endmodule : arbiter