import lc3b_types::*;

module vc_datapath
(
	/* CLOCK!!! */
	input 						clk,
	input lc3b_word			address_from_l1,
	/* To/From the L2 Cache */
	input lc3b_word 			l2_address,
	input lc3b_full_chunk 	l2_wdata,
	output lc3b_full_chunk 	l2_rdata,
	output logic				l2_resp,
	/* To/From Physical Memory */
	input logic					pmem_resp,
	input lc3b_full_chunk	pmem_rdata,
	output lc3b_word			pmem_address,
	output lc3b_full_chunk	pmem_wdata,
	input logic					dirty0_out,
	input logic					dirty1_out,
	input logic					dirty2_out,
	input logic					dirty3_out,
	input logic [1:0]			LRU_way_select,
	/* To/From the VC Controller */
	input logic					write_state,
	input logic					write_tag_data,
	input logic					write_buffer,
	input logic					write_valid,
	input logic					rdata_mux_sel,
	input logic					controller_resp,
	input logic					address_mux_sel,
	input logic					in_pmem_wb,
	output logic				hit,
	output logic				valid,
	output logic				valid0_out,
	output logic				valid1_out,
	output logic				valid2_out,
	output logic				valid3_out,
	output logic				dirty	
);

/* Internal Signals */
lc3b_full_chunk	data_array_out;
lc3b_word			tag0_out;
lc3b_word			tag1_out;
lc3b_word			tag2_out;
lc3b_word			tag3_out;
logic					comp0_out;
logic					comp1_out;
logic					comp2_out;
logic					comp3_out;
logic					dirty0;
logic					dirty1;
logic					dirty2;
logic					dirty3;
logic	[1:0]			way_hit;
logic [1:0]			index_mux_out;
logic [1:0] 		replacement_index;
logic 		 		dirty_mux_in;
logic					dirty_mux_out;
lc3b_full_chunk	data_buffer_out;
lc3b_word			addr_buffer_out;
lc3b_word			LRU_tag_mux_out;
lc3b_word			truncated_l1_address;
lc3b_word			truncated_l2_address;

assign pmem_wdata = data_buffer_out;
assign l2_resp = (pmem_resp && ~in_pmem_wb) || controller_resp;
assign truncated_l1_address = {address_from_l1[15:5],5'b0};
assign truncated_l2_address = {l2_address[15:5],5'b0};
assign comp0_out = (truncated_l1_address == tag0_out);
assign comp1_out = (truncated_l1_address == tag1_out);
assign comp2_out = (truncated_l1_address == tag2_out);
assign comp3_out = (truncated_l1_address == tag3_out);
assign hit = (comp0_out & valid0_out) || (comp1_out & valid1_out) || (comp2_out & valid2_out) || (comp3_out & valid3_out);


l2_array #(.width(256)) data_array
(
	.clk(clk),
   .write(write_tag_data),
   .index(index_mux_out),
   .datain(l2_wdata),
   .dataout(data_array_out)
);

way_hit_encoder hit_encoder
(
	.way0_hit((comp0_out & valid0_out)),
	.way1_hit((comp1_out & valid1_out)),
	.way2_hit((comp2_out & valid2_out)),
	.way3_hit((comp3_out & valid3_out)),
	.way_hit(way_hit)
);

vc_tag_array #(.width(16)) tag_array
(
    .clk(clk),
    .write(write_tag_data),
    .index(index_mux_out),
    .datain(truncated_l2_address),
    .dataout0(tag0_out),
	 .dataout1(tag1_out),
	 .dataout2(tag2_out),
	 .dataout3(tag3_out)
);

mux2 #(.width(2)) index_mux
(
	.sel((comp0_out & valid0_out) || (comp1_out & valid1_out) || (comp2_out & valid2_out) || (comp3_out & valid3_out)),
	.a(replacement_index),
	.b(way_hit),
	.f(index_mux_out)
);

vc_LRU_regfile LRU_regfile
(
	.clk(clk),
	.write(write_state),
	.way_hit(index_mux_out),	
	.replace(replacement_index)
);

vc_data_buffer data_buffer
(
	.clk(clk),
	.load(write_buffer),
	.in(data_array_out),
	.out(data_buffer_out)
);

mux2 #(.width(256)) rdata_mux
(
	.sel(rdata_mux_sel),
	.a(pmem_rdata),
	.b(data_buffer_out),
	.f(l2_rdata)
);

mux4 #(.width(16)) LRU_tag_mux
(
	.sel(index_mux_out),
	.a(tag0_out),
	.b(tag1_out),
	.c(tag2_out),
	.d(tag3_out),
	.out(LRU_tag_mux_out)
);

vc_addr_buffer addr_buffer
(
	.clk(clk),
	.load(write_buffer),
	.in(LRU_tag_mux_out),
	.out(addr_buffer_out)
);

mux2 #(.width(16)) address_mux
(
	.sel(address_mux_sel),
	.a(truncated_l2_address),
	.b(addr_buffer_out),
	.f(pmem_address)
);

vc_tag_array #(.width(1)) valid_array
(
    .clk(clk),
    .write(write_valid),
    .index(index_mux_out),
    .datain(1'b1),
    .dataout0(valid0_out),
	 .dataout1(valid1_out),
	 .dataout2(valid2_out),
	 .dataout3(valid3_out)
);

mux4 #(.width(1)) valid_mux
(
	.sel(way_hit),
	.a(valid0_out),
	.b(valid1_out),
	.c(valid2_out),
	.d(valid3_out),
	.out(valid)
);

mux4 #(.width(1)) dirty_mux_input
(
	.sel(LRU_way_select),
	.a(dirty0_out),
	.b(dirty1_out),
	.c(dirty2_out),
	.d(dirty3_out),
	.out(dirty_mux_in)
);

vc_tag_array #(.width(1)) dirty_array
(
    .clk(clk),
    .write(write_valid),
    .index(index_mux_out),
    .datain(dirty_mux_in),
    .dataout0(dirty0),
	 .dataout1(dirty1),
	 .dataout2(dirty2),
	 .dataout3(dirty3)
);

mux4 #(.width(1)) dirty_mux_output
(
	.sel(index_mux_out),
	.a(dirty0),
	.b(dirty1),
	.c(dirty2),
	.d(dirty3),
	.out(dirty_mux_out)
);

vc_dirty_buffer dirty_buffer
(
	.clk(clk),
	.load(write_buffer),
	.in(dirty_mux_out),
	.out(dirty)	
);

endmodule : vc_datapath