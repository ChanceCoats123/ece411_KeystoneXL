module hitselectlogic
(
	input logic mem_write,
	input logic mem_read,
	input logic comp0,
	input logic comp1,
	input logic LRU,
	input logic valid0,
	input logic valid1,
	input logic tag_comp,
	input logic alloc_dirty0_write,
	input logic alloc_dirty1_write,
	input logic idling,
	input logic pmem_resp,
	output logic way0_wr_enable,
	output logic way1_wr_enable,
	output logic way_select,
	output logic LRU_way_select,
	output logic LRU_wr_enable,
	output logic LRU_in,
	output logic dirty0_wr_enable,
	output logic dirty1_wr_enable,
	output logic way0_hit,
	output logic way1_hit,
	output logic mem_resp
);

/* Way write if a way hit occurs while cpu is mem writing */
/* Or if BOTH ways miss, and the way is LRU */
assign way0_wr_enable = ((valid0&comp0&mem_write)|(pmem_resp&/*~(~valid0&comp0)&*/LRU&alloc_dirty0_write));
assign way1_wr_enable = ((valid1&comp1&mem_write)|(pmem_resp&/*~(~valid1&comp1)&*/~LRU&alloc_dirty1_write));
/* Select word based on way1 hit status. If hit, select 1, if miss, select 0 */
assign way_select = comp1;
/* Invert the LRU output since it holds the MRU */
assign LRU_way_select = ~LRU;
/*Write to the LRU only when a hit occurs, and we're in the tag_comp state */
assign LRU_wr_enable = ((valid0&comp0)|(valid1&comp1))&(tag_comp || mem_resp);
/* Set the input to the LRU array as way1 hit status. 1 on hit, 0 on miss */
assign LRU_in = comp1;
/* Enable dirty write if  hit occurs while the cpu is writing and in the tag_comp state */
assign dirty0_wr_enable = mem_write&(valid0&comp0)&tag_comp || mem_write&mem_resp&(valid0&comp0);
assign dirty1_wr_enable = mem_write&(valid1&comp1)&tag_comp || mem_write&mem_resp&(valid1&comp1);
/* Hit occurs on a way with tag match and valid match in the tag_comp state */
assign way0_hit = (valid0&comp0)&tag_comp;
assign way1_hit = (valid1&comp1)&tag_comp;
/* Mem respond if a hit occurs in the tag_comp state or if a read/write occurs while idling */
assign mem_resp = ((valid0&comp0)|(valid1&comp1))&(tag_comp|idling)&(mem_write|mem_read);

endmodule : hitselectlogic