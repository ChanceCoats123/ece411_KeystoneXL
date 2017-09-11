import lc3b_types::*;

module l2_cache
(
	/* Clock! */
	input clk,
	/* To/From CPU */
	input lc3b_word mem_address,
	input lc3b_chunk mem_wdata,
	input logic mem_read,
	input logic mem_write,
	input lc3b_mem_wmask mem_byte_enable,
	output lc3b_chunk mem_rdata,
	output logic mem_resp,
	/* To/From Physical Memory */
	input lc3b_full_chunk pmem_rdata,
	input logic pmem_resp,
	output lc3b_word pmem_address,
	output lc3b_full_chunk pmem_wdata,
	output logic pmem_read,
	output logic pmem_write,
	/* Specifically for the VC */
	output logic dirty0_out,
	output logic dirty1_out,
	output logic dirty2_out,
	output logic dirty3_out,
	output logic[1:0] LRU_way_select,
	input logic dirty
);

/* Internal Signals */
logic valid0_in;
logic valid1_in;
logic valid2_in;
logic valid3_in;
logic valid0_out;
logic valid1_out;
logic valid2_out;
logic valid3_out;
logic valid0_wr_enable;
logic valid1_wr_enable;
logic valid2_wr_enable;
logic valid3_wr_enable;
logic alloc_dirty0_write;
logic alloc_dirty1_write;
logic alloc_dirty2_write;
logic alloc_dirty3_write;
logic dirty0_in;
logic dirty1_in;
logic dirty2_in;
logic dirty3_in;
logic tag_comp;
/*
logic dirty0_out;
logic dirty1_out;
logic dirty2_out;
logic dirty3_out;
*/
logic way0_hit;
logic way1_hit;
logic way2_hit;
logic way3_hit;
/*
logic[1:0] LRU_way_select;
*/
logic idling;
logic pmem_addr_sel;

/* Cache Controller Instantiation */
l2_cache_control cache_control
(
	/* Clock! */
	.clk(clk),
	/* To/From Cache Data Path */
	.dirty0_out(dirty0_out),
	.dirty1_out(dirty1_out),
	.dirty2_out(dirty2_out),
	.dirty3_out(dirty3_out),
	.way0_hit(way0_hit),
	.way1_hit(way1_hit),
	.way2_hit(way2_hit),
	.way3_hit(way3_hit),
	.LRU_way_select(LRU_way_select),
	.valid0_out(valid0_out),
	.valid1_out(valid1_out),
	.valid2_out(valid2_out),
	.valid3_out(valid3_out),	
	.valid0_in(valid0_in),
	.valid1_in(valid1_in),
	.valid2_in(valid2_in),
	.valid3_in(valid3_in),
	.valid0_wr_enable(valid0_wr_enable),
	.valid1_wr_enable(valid1_wr_enable),
	.valid2_wr_enable(valid2_wr_enable),
	.valid3_wr_enable(valid3_wr_enable),
	.alloc_dirty0_write(alloc_dirty0_write),
	.alloc_dirty1_write(alloc_dirty1_write),
	.alloc_dirty2_write(alloc_dirty2_write),
	.alloc_dirty3_write(alloc_dirty3_write),
	.dirty0_in(dirty0_in),
	.dirty1_in(dirty1_in),
	.dirty2_in(dirty2_in),
	.dirty3_in(dirty3_in),
	.tag_comp(tag_comp),
	.idling(idling),
	.pmem_addr_sel(pmem_addr_sel),
	.mem_resp(mem_resp),
	/* To/From Physical Memory */
	.pmem_resp(pmem_resp),
	.pmem_read(pmem_read),
	.pmem_write(pmem_write),
	/* To/From CPU */
	.mem_read(mem_read),
	.mem_write(mem_write)
);

/* Cache Data Path Instantiation */
l2_cache_datapath  l2_cache_datapath 
(
	/* Clock! */
	.clk(clk),
	/* Control Signals */
	.dirty0_out(dirty0_out),
	.dirty1_out(dirty1_out),
	.dirty2_out(dirty2_out),
	.dirty3_out(dirty3_out),
	.dirty_from_vc(dirty),
	.way0_hit(way0_hit),
	.way1_hit(way1_hit),
	.way2_hit(way2_hit),
	.way3_hit(way3_hit),
	.LRU_way_select(LRU_way_select),
	.valid0_in(valid0_in),
	.valid1_in(valid1_in),
	.valid2_in(valid2_in),
	.valid3_in(valid3_in),
	.valid0_wr_enable(valid0_wr_enable),
	.valid1_wr_enable(valid1_wr_enable),
	.valid2_wr_enable(valid2_wr_enable),
	.valid3_wr_enable(valid3_wr_enable),
	.alloc_dirty0_write(alloc_dirty0_write),
	.alloc_dirty1_write(alloc_dirty1_write),
	.alloc_dirty2_write(alloc_dirty2_write),
	.alloc_dirty3_write(alloc_dirty3_write),
	.dirty0_in(dirty0_in),
	.dirty1_in(dirty1_in),
	.dirty2_in(dirty2_in),
	.dirty3_in(dirty3_in),
	.tag_comp(tag_comp),
	.idling(idling),
	.pmem_addr_sel(pmem_addr_sel),
	.valid0_out(valid0_out),
	.valid1_out(valid1_out),
	.valid2_out(valid2_out),
	.valid3_out(valid3_out),
	/* Cpu signals */
	.mem_write(mem_write),
	.mem_read(mem_read),
	.mem_wdata(mem_wdata),
	.mem_address(mem_address),
	.mem_byte_enable(mem_byte_enable),
	.mem_rdata(mem_rdata),
	.mem_resp(mem_resp),	
	/* Physiscal Memory Signals */
	.pmem_rdata(pmem_rdata),
	.pmem_resp(pmem_resp),
	.pmem_address(pmem_address),
	.pmem_wdata(pmem_wdata)
);

endmodule : l2_cache