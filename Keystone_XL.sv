import lc3b_types::*;

module Keystone_XL
(
	/* Clock! */
	input clk,
	/* Inputs go here! */
	input lc3b_full_chunk	pmem_rdata,
	input logic			pmem_resp,
	/* Outputs go here! */
	output lc3b_word	pmem_address,
	output lc3b_full_chunk	pmem_wdata,
	output logic		pmem_read,
	output logic		pmem_write
);

/* Internal Signals */
logic					mem_resp;
logic					instr_mem_resp;
lc3b_word			mem_rdata;
lc3b_word			L1I_rdata;
lc3b_word			mem_address;
lc3b_word			instr_mem_address;
lc3b_word			mem_wdata;
logic					mem_write;
logic					mem_read;
logic					instr_mem_read;
lc3b_mem_wmask		mem_byte_enable;
logic					instruction_resp;
logic					instruction_read;
logic					instruction_write;
lc3b_word			instruction_address;
lc3b_chunk			instruction_wdata;
logic					data_resp;
logic					data_read;
logic					data_write;
lc3b_word			data_address;
lc3b_chunk			data_wdata;
lc3b_word			l2_address;
lc3b_chunk			l2_wdata;
logic 				l2_read;
logic					l2_write;
lc3b_chunk			l2_rdata;
logic					l2_resp;
lc3b_word			vc_address;
lc3b_full_chunk	vc_wdata;
logic 				vc_read;
logic					vc_write;
lc3b_full_chunk	vc_rdata;
logic					vc_resp;
logic					dirty0_out;
logic					dirty1_out;
logic					dirty2_out;
logic					dirty3_out;
logic[1:0] 			LRU_way_select;
logic 				dirty;

cpu_datapath datapath
(
	.clk,	
	/* Inputs go here! */
	.mem_resp(mem_resp),
	.instr_mem_resp(instr_mem_resp),
	.mem_rdata(mem_rdata),
	.L1I_rdata(L1I_rdata),
	/* Outputs go here! */
	.mem_address(mem_address),
	.instr_mem_address(instr_mem_address),
	.mem_wdata(mem_wdata),
	.mem_write(mem_write),
	.mem_read(mem_read),
	.instr_mem_read(instr_mem_read),
	.mem_byte_enable(mem_byte_enable)
);

cache L1I
(
	.clk(clk),
	/* To/From CPU */
	.mem_address(instr_mem_address),
	.mem_wdata(16'b0),
	.mem_read(instr_mem_read),
	.mem_write(1'b0),
	.mem_byte_enable(2'b11),
	.mem_rdata(L1I_rdata),
	.mem_resp(instr_mem_resp),
	/* To/From Physical Memory */
	.pmem_rdata(l2_rdata),
	.pmem_resp(instruction_resp),
	.pmem_address(instruction_address),
	.pmem_wdata(instruction_wdata),
	.pmem_read(instruction_read),
	.pmem_write(instruction_write)	
);

cache L1D
(
	.clk,
	/* To/From CPU */
	.mem_address(mem_address),
	.mem_wdata(mem_wdata),
	.mem_read(mem_read),
	.mem_write(mem_write),
	.mem_byte_enable(mem_byte_enable),
	.mem_rdata(mem_rdata),
	.mem_resp(mem_resp),
	/* To/From Physical Memory */
	.pmem_rdata(l2_rdata),
	.pmem_resp(data_resp),
	.pmem_address(data_address),
	.pmem_wdata(data_wdata),
	.pmem_read(data_read),
	.pmem_write(data_write)
);

arbiter arbitron
(
	.clk(clk),
	.L1I_address(instruction_address),
	.L1D_address(data_address),
	.L1I_data(instruction_wdata),
	.L1D_data(data_wdata),
	.L1I_read(instruction_read),
	.L1D_read(data_read),
	.L1I_write(instruction_write),
	.L1D_write(data_write),
	.pmem_resp(l2_resp),
	.pmem_read(l2_read),
	.pmem_write(l2_write),
	.address_to_pmem(l2_address),
	.data_to_pmem(l2_wdata),
	.L1I_resp(instruction_resp),
	.L1D_resp(data_resp)
);

l2_cache L2 
(
	.clk,
	/* To/From CPU */
	.mem_address(l2_address),
	.mem_wdata(l2_wdata),
	.mem_read(l2_read),
	.mem_write(l2_write),
	.mem_byte_enable(mem_byte_enable),
	.mem_rdata(l2_rdata),
	.mem_resp(l2_resp),
	/* To/From Physical Memory */
	.pmem_rdata(vc_rdata),
	.pmem_resp(vc_resp),
	.pmem_address(vc_address),
	.pmem_wdata(vc_wdata),
	.pmem_read(vc_read),
	.pmem_write(vc_write),
	/* Specifically for the VC */
	.dirty0_out(dirty0_out),
	.dirty1_out(dirty1_out),
	.dirty2_out(dirty2_out),
	.dirty3_out(dirty3_out),
	.LRU_way_select(LRU_way_select),
	.dirty(dirty)
);

victim_cache VC
(
	.clk(clk),
	.address_from_l1(l2_address),
	// To/From L2 
	.l2_read(vc_read),
	.l2_write(vc_write),
	.l2_address(vc_address),
	.l2_wdata(vc_wdata),
	.l2_resp(vc_resp),	
	.l2_rdata(vc_rdata),
	.dirty0_out(dirty0_out),
	.dirty1_out(dirty1_out),
	.dirty2_out(dirty2_out),
	.dirty3_out(dirty3_out),
	.LRU_way_select(LRU_way_select),
	// To/From Pmem 
	.pmem_resp(pmem_resp),	
	.pmem_rdata(pmem_rdata),
	.pmem_read(pmem_read),
	.pmem_write(pmem_write),
	.pmem_address(pmem_address),
	.pmem_wdata(pmem_wdata),	
	.dirty(dirty)
);

endmodule : Keystone_XL