import lc3b_types::*;

module l2_routing_unit
(
	input logic bit4,
	input logic hit,
	input lc3b_chunk mem_wdata,
	input lc3b_full_chunk pmem_rdata,
	input lc3b_full_chunk way_data,
	output lc3b_full_chunk out
);

mux4 #(.width(256)) routing_mux
(
	.sel({~hit,bit4}),
	.b({mem_wdata,way_data[127:0]}),
	.a({way_data[255:128],mem_wdata}),
	.c(pmem_rdata),
	.d(pmem_rdata),
	.out(out)
);

endmodule : l2_routing_unit