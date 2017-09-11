import lc3b_types::*;

module cache_datapath
(
	/* Clock! */
	input clk,
	/* Control Signals */
	input logic valid0_in,
	input logic valid1_in,
	input logic valid0_wr_enable,
	input logic valid1_wr_enable,
	input logic alloc_dirty0_write,
	input logic alloc_dirty1_write,
	input logic dirty0_in,
	input logic dirty1_in,
	input logic tag_comp,
	input logic idling,
	input logic pmem_addr_sel,
	output logic dirty0_out,
	output logic dirty1_out,
	output logic way0_hit,
	output logic way1_hit,
	output logic LRU_way_select,
	output logic valid0_out,
	output logic valid1_out,
	/* Cpu signals */
	input logic mem_write,
	input logic mem_read,
	input lc3b_word mem_wdata,
	input lc3b_word mem_address,
	input lc3b_mem_wmask mem_byte_enable,
	output lc3b_word mem_rdata,
	output logic mem_resp,	
	/* Physiscal Memory Signals */
	input lc3b_chunk pmem_rdata,
	input logic pmem_resp,
	output lc3b_word pmem_address,
	output lc3b_chunk pmem_wdata
);

/* Internal Signals */
lc3b_word internal_address;
logic way_select;
//logic way0_hit;
//logic way1_hit;
logic way0_wr_enable;
logic way1_wr_enable;
lc3b_chunk data0_in;
lc3b_chunk data0_out;
lc3b_chunk data1_in;
lc3b_chunk data1_out;
lc3b_word word0_select_out;
lc3b_word word1_select_out;
logic lru_in;
logic lru_out;
//logic LRU_way_select;
logic LRU_wr_enable;
//logic valid0_out;
//logic valid1_out;
logic dirty0_wr_enable;
logic dirty1_wr_enable;
lc3b_tag tag0_out;
lc3b_tag tag1_out;
logic comp0_out;
logic comp1_out;
lc3b_word tagmux_out;

/* pmem_address is mem_address */
//assign pmem_address = mem_address;

mux2 addrmux
(
	.sel(pmem_addr_sel),
	.a(mem_address),
	.b(tagmux_out),
	.f(pmem_address)
);

mux2 tagmux
(
	.sel(lru_out),
	.a({tag1_out,mem_address[6:0]}),
	.b({tag0_out,mem_address[6:0]}),
	.f(tagmux_out)
);

array #(.width(128)) data0
(
	.clk(clk),
   .write(way0_wr_enable),
   .index(mem_address[6:4]),
   .datain(data0_in),
   .dataout(data0_out)
);

array #(.width(128)) data1
(
	.clk(clk),
   .write(way1_wr_enable),
   .index(mem_address[6:4]),
   .datain(data1_in),
   .dataout(data1_out)
);

routingunit routing0
(
	.offset(mem_address[3:1]),
	.hit(way0_hit|mem_resp),
	.mem_wdata(mem_wdata),
	.pmem_rdata(pmem_rdata),
	.way_data(data0_out),
	.byte_enable(mem_byte_enable),
	.out(data0_in)
);

routingunit routing1
(
	.offset(mem_address[3:1]),
	.hit(way1_hit|mem_resp),
	.mem_wdata(mem_wdata),
	.pmem_rdata(pmem_rdata),
	.way_data(data1_out),
	.byte_enable(mem_byte_enable),
	.out(data1_in)
);


mux8 word0_selector
(
	.sel(mem_address[3:1]),
	.a(data0_out[15:0]),
	.b(data0_out[31:16]),
	.c(data0_out[47:32]),
	.d(data0_out[63:48]),
	.e(data0_out[79:64]),
	.f(data0_out[95:80]),
	.g(data0_out[111:96]),
	.h(data0_out[127:112]),
	.out(word0_select_out)
);

mux8 word1_selector
(
	.sel(mem_address[3:1]),
	.a(data1_out[15:0]),
	.b(data1_out[31:16]),
	.c(data1_out[47:32]),
	.d(data1_out[63:48]),
	.e(data1_out[79:64]),
	.f(data1_out[95:80]),
	.g(data1_out[111:96]),
	.h(data1_out[127:112]),
	.out(word1_select_out)
);

mux2 way_selector
(
	.sel(way_select),
	.a(word0_select_out),
	.b(word1_select_out),
	.f(mem_rdata)
);

mux2 #(.width(128)) pmem_way_selector
(
	.sel(LRU_way_select),
	.a(data0_out),
	.b(data1_out),
	.f(pmem_wdata)
);

array #(.width(1)) LRU_array
(
	.clk(clk),
   .write(LRU_wr_enable),
   .index(mem_address[6:4]),
   .datain(lru_in),
   .dataout(lru_out)
);

array #(.width(1)) valid0_array
(
	.clk(clk),
   .write(valid0_wr_enable),
   .index(mem_address[6:4]),
   .datain(valid0_in),
   .dataout(valid0_out)
);

array #(.width(1)) valid1_array
(
	.clk(clk),
   .write(valid1_wr_enable),
   .index(mem_address[6:4]),
   .datain(valid1_in),
   .dataout(valid1_out)
);

array #(.width(1)) dirty0_array
(
	.clk(clk),
   .write(dirty0_wr_enable || alloc_dirty0_write),
   .index(mem_address[6:4]),
   .datain(dirty0_in),
   .dataout(dirty0_out)
);

array #(.width(1)) dirty1_array
(
	.clk(clk),
   .write(dirty1_wr_enable || alloc_dirty1_write),
   .index(mem_address[6:4]),
   .datain(dirty1_in),
   .dataout(dirty1_out)
);

array #(.width(9)) tag0_array
(
	.clk(clk),
	.write(way0_wr_enable),
	.index(mem_address[6:4]),
	.datain(mem_address[15:7]),
	.dataout(tag0_out)
);

array #(.width(9)) tag1_array
(
	.clk(clk),
	.write(way1_wr_enable),
	.index(mem_address[6:4]),
	.datain(mem_address[15:7]),
	.dataout(tag1_out)
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

hitselectlogic selectlogic
(
	.mem_write(mem_write),
	.mem_read(mem_read),
	.comp0(comp0_out),
	.comp1(comp1_out),
	.LRU(lru_out),
	.valid0(valid0_out),
	.valid1(valid1_out),
	.tag_comp(tag_comp),
	.alloc_dirty0_write(alloc_dirty0_write),
	.alloc_dirty1_write(alloc_dirty1_write),
	.idling(idling),
	.pmem_resp(pmem_resp),
	.way0_wr_enable(way0_wr_enable),
	.way1_wr_enable(way1_wr_enable),
	.way_select(way_select),
	.LRU_way_select(LRU_way_select),
	.LRU_wr_enable(LRU_wr_enable),
	.LRU_in(lru_in),
	.dirty0_wr_enable(dirty0_wr_enable),
	.dirty1_wr_enable(dirty1_wr_enable),
	.way0_hit(way0_hit),
	.way1_hit(way1_hit),
	.mem_resp(mem_resp)
);	

endmodule : cache_datapath