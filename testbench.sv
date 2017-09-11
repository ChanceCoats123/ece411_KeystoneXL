import lc3b_types::*;

module testbench;

timeunit 1ns;
timeprecision 1ns;

logic 		clk;
logic 		pmem_read;
logic 		pmem_write;
logic 		pmem_resp;
lc3b_word	pmem_address;
lc3b_full_chunk	pmem_rdata;
lc3b_full_chunk 	pmem_wdata;	

/* Clock Generator */
initial clk = 0;
always #5 clk = ~clk;

Keystone_XL DUT
(
	.clk(clk),
	.pmem_rdata(pmem_rdata),
	.pmem_resp(pmem_resp),
	.pmem_address(pmem_address),
	.pmem_wdata(pmem_wdata),
	.pmem_read(pmem_read),
	.pmem_write(pmem_write)
);

physical_memory pmem
(
    .clk(clk),
    .read(pmem_read),
    .write(pmem_write),
    .address(pmem_address),
    .wdata(pmem_wdata),
    .resp(pmem_resp),
    .rdata(pmem_rdata)
);

endmodule : testbench