import lc3b_types::*;

module l2_cache_datapath #(parameter width = 256)
(
	/* Clock! */
	input clk,
	/* Control Signals */
	input logic valid0_in,
	input logic valid1_in,
	input logic valid2_in,
	input logic valid3_in,
	input logic valid0_wr_enable,
	input logic valid1_wr_enable,
	input logic valid2_wr_enable,
	input logic valid3_wr_enable,
	input logic alloc_dirty0_write,
	input logic alloc_dirty1_write,
	input logic alloc_dirty2_write,
	input logic alloc_dirty3_write,
	input logic dirty0_in,
	input logic dirty1_in,
	input logic dirty2_in,
	input logic dirty3_in,
	input logic tag_comp,
	input logic idling,
	input logic pmem_addr_sel,
	input logic dirty_from_vc,
	output logic dirty0_out,
	output logic dirty1_out,
	output logic dirty2_out,
	output logic dirty3_out,
	output logic way0_hit,
	output logic way1_hit,
	output logic way2_hit,
	output logic way3_hit,
	output logic[1:0] LRU_way_select,
	output logic valid0_out,
	output logic valid1_out,
	output logic valid2_out,
	output logic valid3_out,
	/* Cpu signals */
	input logic mem_write,
	input logic mem_read,
	input lc3b_chunk mem_wdata,
	input lc3b_word mem_address,
	input lc3b_mem_wmask mem_byte_enable,
	output lc3b_chunk mem_rdata,
	output logic mem_resp,	
	/* Physiscal Memory Signals */
	input lc3b_full_chunk pmem_rdata,
	input logic pmem_resp,
	output lc3b_word pmem_address,
	output lc3b_full_chunk pmem_wdata
);

/* Internal Signals */
lc3b_word internal_address;
logic[1:0] way_select;
logic way0_wr_enable;
logic way1_wr_enable;
logic way2_wr_enable;
logic way3_wr_enable;
lc3b_full_chunk data0_in;
lc3b_full_chunk data0_out;
lc3b_full_chunk data1_in;
lc3b_full_chunk data1_out;
lc3b_full_chunk data2_in;
lc3b_full_chunk data2_out;
lc3b_full_chunk data3_in;
lc3b_full_chunk data3_out;
lc3b_chunk chunk0_mux_out;
lc3b_chunk chunk1_mux_out;
lc3b_chunk chunk2_mux_out;
lc3b_chunk chunk3_mux_out;
logic[2:0] lru_in;
logic[2:0] lru_out;
logic LRU_wr_enable;
logic dirty0_wr_enable;
logic dirty1_wr_enable;
logic dirty2_wr_enable;
logic dirty3_wr_enable;
lc3b_tag tag0_out;
lc3b_tag tag1_out;
lc3b_tag tag2_out;
lc3b_tag tag3_out;
logic comp0_out;
logic comp1_out;
logic comp2_out;
logic comp3_out;
lc3b_word tagmux_out;


mux2 addrmux
(
	.sel(pmem_addr_sel),
	.a(mem_address),
	.b(tagmux_out),
	.f(pmem_address)
);

mux4 #(.width(16)) tagmux
(
	.sel(LRU_way_select),
	.a({tag0_out,mem_address[6:0]}),
	.b({tag1_out,mem_address[6:0]}),
	.c({tag2_out,mem_address[6:0]}),
	.d({tag3_out,mem_address[6:0]}),
	.out(tagmux_out)
);

l2_array #(.width(256)) data0
(
	.clk(clk),
   .write(way0_wr_enable),
   .index(mem_address[6:5]),
   .datain(data0_in),
   .dataout(data0_out)
);

l2_array #(.width(256)) data1
(
	.clk(clk),
   .write(way1_wr_enable),
   .index(mem_address[6:5]),
   .datain(data1_in),
   .dataout(data1_out)
);

l2_array #(.width(256)) data2
(
	.clk(clk),
   .write(way2_wr_enable),
   .index(mem_address[6:5]),
   .datain(data2_in),
   .dataout(data2_out)
);

l2_array #(.width(256)) data3
(
	.clk(clk),
   .write(way3_wr_enable),
   .index(mem_address[6:5]),
   .datain(data3_in),
   .dataout(data3_out)
);

l2_routing_unit routing0
(
	.bit4(mem_address[4]),
	.hit(way0_hit|mem_resp),
	.mem_wdata(mem_wdata),
	.pmem_rdata(pmem_rdata),
	.way_data(data0_out),
	.out(data0_in)
);

l2_routing_unit routing1
(
	.bit4(mem_address[4]),
	.hit(way1_hit|mem_resp),
	.mem_wdata(mem_wdata),
	.pmem_rdata(pmem_rdata),
	.way_data(data1_out),
	.out(data1_in)
);

l2_routing_unit routing2
(
	.bit4(mem_address[4]),
	.hit(way2_hit|mem_resp),
	.mem_wdata(mem_wdata),
	.pmem_rdata(pmem_rdata),
	.way_data(data2_out),
	.out(data2_in)
);

l2_routing_unit routing3
(
	.bit4(mem_address[4]),
	.hit(way3_hit|mem_resp),
	.mem_wdata(mem_wdata),
	.pmem_rdata(pmem_rdata),
	.way_data(data3_out),
	.out(data3_in)
);

mux2 #(.width(128)) chunk0_mux
(
	.sel(mem_address[4]),
	.a(data0_out[127:0]),
	.b(data0_out[255:128]),
	.f(chunk0_mux_out)
);

mux2 #(.width(128)) chunk1_mux
(
	.sel(mem_address[4]),
	.a(data1_out[127:0]),
	.b(data1_out[255:128]),
	.f(chunk1_mux_out)
);

mux2 #(.width(128)) chunk2_mux
(
	.sel(mem_address[4]),
	.a(data2_out[127:0]),
	.b(data2_out[255:128]),
	.f(chunk2_mux_out)
);

mux2 #(.width(128)) chunk3_mux
(
	.sel(mem_address[4]),
	.a(data3_out[127:0]),
	.b(data3_out[255:128]),
	.f(chunk3_mux_out)
);

mux4 #(.width(128)) way_selector
(
	.sel(way_select),
	.a(chunk0_mux_out),
	.b(chunk1_mux_out),
	.c(chunk2_mux_out),
	.d(chunk3_mux_out),
	.out(mem_rdata)
);

mux4 #(.width(256)) pmem_way_selector
(
	.sel(LRU_way_select),
	.a(data0_out),
	.b(data1_out),
	.c(data2_out),
	.d(data3_out),
	.out(pmem_wdata)
);

l2_array #(.width(3)) LRU_array
(
	.clk(clk),
   .write(LRU_wr_enable),
   .index(mem_address[6:5]),
   .datain(lru_in),
   .dataout(lru_out)
);

l2_array #(.width(1)) valid0_array
(
	.clk(clk),
   .write(valid0_wr_enable),
   .index(mem_address[6:5]),
   .datain(valid0_in),
   .dataout(valid0_out)
);

l2_array #(.width(1)) valid1_array
(
	.clk(clk),
   .write(valid1_wr_enable),
   .index(mem_address[6:5]),
   .datain(valid1_in),
   .dataout(valid1_out)
);

l2_array #(.width(1)) valid2_array
(
	.clk(clk),
   .write(valid2_wr_enable),
   .index(mem_address[6:5]),
   .datain(valid2_in),
   .dataout(valid2_out)
);

l2_array #(.width(1)) valid3_array
(
	.clk(clk),
   .write(valid3_wr_enable),
   .index(mem_address[6:5]),
   .datain(valid3_in),
   .dataout(valid3_out)
);

l2_array #(.width(1)) dirty0_array
(
	.clk(clk),
   .write(dirty0_wr_enable || alloc_dirty0_write),
   .index(mem_address[6:5]),
   .datain(dirty0_in | dirty_from_vc),
   .dataout(dirty0_out)
);

l2_array #(.width(1)) dirty1_array
(
	.clk(clk),
   .write(dirty1_wr_enable || alloc_dirty1_write),
   .index(mem_address[6:5]),
   .datain(dirty1_in | dirty_from_vc),
   .dataout(dirty1_out)
);

l2_array #(.width(1)) dirty2_array
(
	.clk(clk),
   .write(dirty2_wr_enable || alloc_dirty2_write),
   .index(mem_address[6:5]),
   .datain(dirty2_in | dirty_from_vc),
   .dataout(dirty2_out)
);

l2_array #(.width(1)) dirty3_array
(
	.clk(clk),
   .write(dirty3_wr_enable || alloc_dirty3_write),
   .index(mem_address[6:5]),
   .datain(dirty3_in | dirty_from_vc),
   .dataout(dirty3_out)
);

l2_array #(.width(9)) tag0_array
(
	.clk(clk),
	.write(way0_wr_enable),
	.index(mem_address[6:5]),
	.datain(mem_address[15:7]),
	.dataout(tag0_out)
);

l2_array #(.width(9)) tag1_array
(
	.clk(clk),
	.write(way1_wr_enable),
	.index(mem_address[6:5]),
	.datain(mem_address[15:7]),
	.dataout(tag1_out)
);

l2_array #(.width(9)) tag2_array
(
	.clk(clk),
	.write(way2_wr_enable),
	.index(mem_address[6:5]),
	.datain(mem_address[15:7]),
	.dataout(tag2_out)
);

l2_array #(.width(9)) tag3_array
(
	.clk(clk),
	.write(way3_wr_enable),
	.index(mem_address[6:5]),
	.datain(mem_address[15:7]),
	.dataout(tag3_out)
);

tagcomp tagcomp0
(
	.A(tag0_out),
	.B(mem_address[15:7]),
	.F(comp0_out)
);

tagcomp tagcomp1
(
	.A(tag1_out),
	.B(mem_address[15:7]),
	.F(comp1_out)
);

tagcomp tagcomp2
(
	.A(tag2_out),
	.B(mem_address[15:7]),
	.F(comp2_out)
);

tagcomp tagcomp3
(
	.A(tag3_out),
	.B(mem_address[15:7]),
	.F(comp3_out)
);

l2_hitselectlogic selectlogic
(
	.mem_write(mem_write),
	.mem_read(mem_read),
	.comp0(comp0_out),
	.comp1(comp1_out),
	.comp2(comp2_out),
	.comp3(comp3_out),
	/* ACTUAL LRU from replacement module */
	.LRU(LRU_way_select),
	.valid0(valid0_out),
	.valid1(valid1_out),
	.valid2(valid2_out),
	.valid3(valid3_out),
	.tag_comp(tag_comp),
	.alloc_dirty0_write(alloc_dirty0_write),
	.alloc_dirty1_write(alloc_dirty1_write),
	.alloc_dirty2_write(alloc_dirty2_write),
	.alloc_dirty3_write(alloc_dirty3_write),
	.idling(idling),
	.pmem_resp(pmem_resp),
	.way0_wr_enable(way0_wr_enable),
	.way1_wr_enable(way1_wr_enable),
	.way2_wr_enable(way2_wr_enable),
	.way3_wr_enable(way3_wr_enable),
	.LRU_wr_enable(LRU_wr_enable),
	.dirty0_wr_enable(dirty0_wr_enable),
	.dirty1_wr_enable(dirty1_wr_enable),
	.dirty2_wr_enable(dirty2_wr_enable),
	.dirty3_wr_enable(dirty3_wr_enable),
	.way0_hit(way0_hit),
	.way1_hit(way1_hit),
	.way2_hit(way2_hit),
	.way3_hit(way3_hit),
	.mem_resp(mem_resp)
);	

way_hit_encoder hit_encoder
(
	.way0_hit(way0_hit),
	.way1_hit(way1_hit),
	.way2_hit(way2_hit),
	.way3_hit(way3_hit),
	.way_hit(way_select)
);

LRU_replacement way_replace_module
(
	.lru_state(lru_out),
	.replace(LRU_way_select)
);

LRU_input LRU_input_module
(
	.lru_state(lru_out),
	.way_hit(way_select),
	.new_state(lru_in)
);

endmodule : l2_cache_datapath