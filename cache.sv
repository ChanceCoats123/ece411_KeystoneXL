import lc3b_types::*;

module cache
(
	/* Clock! */
	input clk,
	/* To/From CPU */
	input lc3b_word mem_address,
	input lc3b_word mem_wdata,
	input logic mem_read,
	input logic mem_write,
	input lc3b_mem_wmask mem_byte_enable,
	output lc3b_word mem_rdata,
	output logic mem_resp,
	/* To/From Physical Memory */
	input lc3b_chunk pmem_rdata,
	input logic pmem_resp,
	output lc3b_word pmem_address,
	output lc3b_chunk pmem_wdata,
	output logic pmem_read,
	output logic pmem_write	
);

/* Internal Signals */
logic valid0_in;
logic valid1_in;
logic valid0_out;
logic valid1_out;
logic valid0_wr_enable;
logic valid1_wr_enable;
logic alloc_dirty0_write;
logic alloc_dirty1_write;
logic dirty0_in;
logic dirty1_in;
logic tag_comp;
logic dirty0_out;
logic dirty1_out;
logic way0_hit;
logic way1_hit;
logic LRU_way_select;
logic idling;
logic pmem_addr_sel;

/* Cache Controller Instantiation */
cache_control cache_control
(
	/* Clock! */
	.clk(clk),
	/* To/From Cache Data Path */
	.dirty0_out(dirty0_out),
	.dirty1_out(dirty1_out),
	.way0_hit(way0_hit),
	.way1_hit(way1_hit),
	.LRU_way_select(LRU_way_select),
	.valid0_out(valid0_out),
	.valid1_out(valid1_out),	
	.valid0_in(valid0_in),
	.valid1_in(valid1_in),
	.valid0_wr_enable(valid0_wr_enable),
	.valid1_wr_enable(valid1_wr_enable),
	.alloc_dirty0_write(alloc_dirty0_write),
	.alloc_dirty1_write(alloc_dirty1_write),
	.dirty0_in(dirty0_in),
	.dirty1_in(dirty1_in),
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
cache_datapath cache_datapath
(
	/* Clock! */
	.clk(clk),
	/* Control Signals */
	.dirty0_out(dirty0_out),
	.dirty1_out(dirty1_out),
	.way0_hit(way0_hit),
	.way1_hit(way1_hit),
	.LRU_way_select(LRU_way_select),
	.valid0_in(valid0_in),
	.valid1_in(valid1_in),
	.valid0_wr_enable(valid0_wr_enable),
	.valid1_wr_enable(valid1_wr_enable),
	.alloc_dirty0_write(alloc_dirty0_write),
	.alloc_dirty1_write(alloc_dirty1_write),
	.dirty0_in(dirty0_in),
	.dirty1_in(dirty1_in),
	.tag_comp(tag_comp),
	.idling(idling),
	.pmem_addr_sel(pmem_addr_sel),
	.valid0_out(valid0_out),
	.valid1_out(valid1_out),
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

endmodule : cache