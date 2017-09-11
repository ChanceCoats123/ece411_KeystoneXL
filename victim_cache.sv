import lc3b_types::*;

module victim_cache
(
	input 						clk,
	input lc3b_word			address_from_l1,
	/* To/From L2 */
	input logic					l2_read,
	input logic					l2_write,
	input	lc3b_word			l2_address,
	input lc3b_full_chunk	l2_wdata,
	output logic				l2_resp,	
	output lc3b_full_chunk	l2_rdata,
	input logic					dirty0_out,
	input logic					dirty1_out,
	input logic					dirty2_out,
	input logic					dirty3_out,
	input logic [1:0]			LRU_way_select,
	output logic 				dirty,
	/* To/From Pmem */
	input logic					pmem_resp,	
	input lc3b_full_chunk	pmem_rdata,
	output logic				pmem_read,
	output logic				pmem_write,
	output lc3b_word			pmem_address,
	output lc3b_full_chunk	pmem_wdata	
);

/* Internal Signals */
logic	hit;
logic valid;
logic valid0_out;
logic valid1_out;
logic valid2_out;
logic valid3_out;
logic	write_state;
logic write_tag_data;
logic write_buffer;
logic write_valid;
logic rdata_mux_sel;
logic controller_resp;
logic address_mux_sel;
logic	in_pmem_wb;

vc_datapath victim_cache_datapath
(
	.clk(clk),
	.address_from_l1(address_from_l1),
	/* To/From the L2 Cache */
	.l2_address(l2_address),
	.l2_wdata(l2_wdata),
	.l2_rdata(l2_rdata),
	.l2_resp(l2_resp),
	.dirty0_out(dirty0_out),
	.dirty1_out(dirty1_out),
	.dirty2_out(dirty2_out),
	.dirty3_out(dirty3_out),
	.LRU_way_select(LRU_way_select),
	/* To/From Physical Memory */
	.pmem_resp(pmem_resp),
	.pmem_rdata(pmem_rdata),
	.pmem_address(pmem_address),
	.pmem_wdata(pmem_wdata),
	/* To/From the VC Controller */
	.write_state(write_state),
	.write_tag_data(write_tag_data),
	.write_buffer(write_buffer),
	.write_valid(write_valid),
	.rdata_mux_sel(rdata_mux_sel),
	.controller_resp(controller_resp),
	.address_mux_sel(address_mux_sel),
	.in_pmem_wb(in_pmem_wb),
	.hit(hit),
	.valid(valid),
	.valid0_out(valid0_out),
	.valid1_out(valid1_out),
	.valid2_out(valid2_out),
	.valid3_out(valid3_out),
	.dirty(dirty)
);

vc_controller victim_cache_controller
(
	.clk(clk),
	/* To/From the L2 */
	.l2_write(l2_write),
	.l2_read(l2_read),
	.dirty0_out(dirty0_out),
	.dirty1_out(dirty1_out),
	.dirty2_out(dirty2_out),
	.dirty3_out(dirty3_out),
	.LRU_way_select(LRU_way_select),
	/* To/From the VC Datapath */
	.hit(hit),
	.valid(valid),
	.dirty(dirty),
	.valid0_out(valid0_out),
	.valid1_out(valid1_out),
	.valid2_out(valid2_out),
	.valid3_out(valid3_out),
	.write_state(write_state),
	.write_tag_data(write_tag_data),
	.write_buffer(write_buffer),
	.write_valid(write_valid),
	.rdata_mux_sel(rdata_mux_sel),
	.controller_resp(controller_resp),
	.address_mux_sel(address_mux_sel),
	.in_pmem_wb(in_pmem_wb),
	/* To/From Physical Mem */
	.pmem_resp(pmem_resp),
	.pmem_read(pmem_read),
	.pmem_write(pmem_write)	
);

endmodule : victim_cache