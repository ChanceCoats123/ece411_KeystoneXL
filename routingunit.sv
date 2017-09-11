import lc3b_types::*;

module routingunit
(
	input lc3b_offset offset,
	input logic hit,
	input lc3b_word mem_wdata,
	input lc3b_chunk pmem_rdata,
	input lc3b_chunk way_data,
	input lc3b_mem_wmask byte_enable,
	output lc3b_chunk out
);

/* Internal Signals */
logic[1:0] sel0;
logic[1:0] sel1;
logic[1:0] sel2;
logic[1:0] sel3;
logic[1:0] sel4;
logic[1:0] sel5;
logic[1:0] sel6;
logic[1:0] sel7;
lc3b_word  data0;
lc3b_word  data1;
lc3b_word  data2;
lc3b_word  data3;
lc3b_word  data4;
lc3b_word  data5;
lc3b_word  data6;
lc3b_word  data7;

assign sel0 = {(~hit),(offset==3'b000)};
assign sel1 = {(~hit),(offset==3'b001)};
assign sel2 = {(~hit),(offset==3'b010)};
assign sel3 = {(~hit),(offset==3'b011)};
assign sel4 = {(~hit),(offset==3'b100)};
assign sel5 = {(~hit),(offset==3'b101)};
assign sel6 = {(~hit),(offset==3'b110)};
assign sel7 = {(~hit),(offset==3'b111)};

mux4 word0
(
	.sel(sel0),
	.a(way_data[15:0]),
	.b(data0),
	.c(pmem_rdata[15:0]),
	.d(pmem_rdata[15:0]),
	.out(out[15:0])
);

mux4 word1
(
	.sel(sel1),
	.a(way_data[31:16]),
	.b(data1),
	.c(pmem_rdata[31:16]),
	.d(pmem_rdata[31:16]),
	.out(out[31:16])
);

mux4 word2
(
	.sel(sel2),
	.a(way_data[47:32]),
	.b(data2),
	.c(pmem_rdata[47:32]),
	.d(pmem_rdata[47:32]),
	.out(out[47:32])
);

mux4 word3
(
	.sel(sel3),
	.a(way_data[63:48]),
	.b(data3),
	.c(pmem_rdata[63:48]),
	.d(pmem_rdata[63:48]),
	.out(out[63:48])
);

mux4 word4
(
	.sel(sel4),
	.a(way_data[79:64]),
	.b(data4),
	.c(pmem_rdata[79:64]),
	.d(pmem_rdata[79:64]),
	.out(out[79:64])
);

mux4 word5
(
	.sel(sel5),
	.a(way_data[95:80]),
	.b(data5),
	.c(pmem_rdata[95:80]),
	.d(pmem_rdata[95:80]),
	.out(out[95:80])
);

mux4 word6
(
	.sel(sel6),
	.a(way_data[111:96]),
	.b(data6),
	.c(pmem_rdata[111:96]),
	.d(pmem_rdata[111:96]),
	.out(out[111:96])
);

mux4 word7
(
	.sel(sel7),
	.a(way_data[127:112]),
	.b(data7),
	.c(pmem_rdata[127:112]),
	.d(pmem_rdata[127:112]),
	.out(out[127:112])
);

mux4 wdata0
(
	.sel(byte_enable),
	.a(way_data[15:0]),
	.b({way_data[15:8],mem_wdata[7:0]}),
	.c({mem_wdata[15:8],way_data[7:0]}),
	.d(mem_wdata),
	.out(data0)
);

mux4 wdata1
(
	.sel(byte_enable),
	.a(way_data[31:16]),
	.b({way_data[31:24],mem_wdata[7:0]}),
	.c({mem_wdata[15:8],way_data[23:16]}),
	.d(mem_wdata),
	.out(data1)
);

mux4 wdata2
(
	.sel(byte_enable),
	.a(way_data[47:32]),
	.b({way_data[47:40],mem_wdata[7:0]}),
	.c({mem_wdata[15:8],way_data[39:32]}),
	.d(mem_wdata),
	.out(data2)
);

mux4 wdata3
(
	.sel(byte_enable),
	.a(way_data[63:48]),
	.b({way_data[63:56],mem_wdata[7:0]}),
	.c({mem_wdata[15:8],way_data[55:48]}),
	.d(mem_wdata),
	.out(data3)
);

mux4 wdata4
(
	.sel(byte_enable),
	.a(way_data[79:64]),
	.b({way_data[79:72],mem_wdata[7:0]}),
	.c({mem_wdata[15:8],way_data[71:64]}),
	.d(mem_wdata),
	.out(data4)
);

mux4 wdata5
(
	.sel(byte_enable),
	.a(way_data[95:80]),
	.b({way_data[95:88],mem_wdata[7:0]}),
	.c({mem_wdata[15:8],way_data[87:80]}),
	.d(mem_wdata),
	.out(data5)
);

mux4 wdata6
(
	.sel(byte_enable),
	.a(way_data[111:96]),
	.b({way_data[111:104],mem_wdata[7:0]}),
	.c({mem_wdata[15:8],way_data[103:96]}),
	.d(mem_wdata),
	.out(data6)
);

mux4 wdata7
(
	.sel(byte_enable),
	.a(way_data[127:112]),
	.b({way_data[127:120],mem_wdata[7:0]}),
	.c({mem_wdata[15:8],way_data[119:112]}),
	.d(mem_wdata),
	.out(data7)
);

endmodule : routingunit