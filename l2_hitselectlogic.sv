module l2_hitselectlogic
(
	input logic mem_write,
	input logic mem_read,
	input logic comp0,
	input logic comp1,
	input logic comp2,
	input logic comp3,
	/* ACTUAL LRU from replacement module */
	input logic[1:0] LRU,
	input logic valid0,
	input logic valid1,
	input logic valid2,
	input logic valid3,
	input logic tag_comp,
	input logic alloc_dirty0_write,
	input logic alloc_dirty1_write,
	input logic alloc_dirty2_write,
	input logic alloc_dirty3_write,
	input logic idling,
	input logic pmem_resp,
	output logic way0_wr_enable,
	output logic way1_wr_enable,
	output logic way2_wr_enable,
	output logic way3_wr_enable,
	output logic LRU_wr_enable,
	output logic dirty0_wr_enable,
	output logic dirty1_wr_enable,
	output logic dirty2_wr_enable,
	output logic dirty3_wr_enable,
	output logic way0_hit,
	output logic way1_hit,
	output logic way2_hit,
	output logic way3_hit,
	output logic mem_resp
);

/* Way write if a way hit occurs while cpu is mem writing */
/* Or if BOTH ways miss, and the way is LRU */
assign way0_wr_enable = ((valid0&comp0&mem_write)|(pmem_resp & (LRU == 2'b00) &alloc_dirty0_write));
assign way1_wr_enable = ((valid1&comp1&mem_write)|(pmem_resp & (LRU == 2'b01) &alloc_dirty1_write));
assign way2_wr_enable = ((valid2&comp2&mem_write)|(pmem_resp & (LRU == 2'b10) &alloc_dirty2_write));
assign way3_wr_enable = ((valid3&comp3&mem_write)|(pmem_resp & (LRU == 2'b11) &alloc_dirty3_write));
/*Write to the LRU only when a hit occurs, and we're in the tag_comp state */
assign LRU_wr_enable = ((valid0&comp0)|(valid1&comp1)|(valid2&comp2)|(valid3&comp3))&(tag_comp || mem_resp);
/* Enable dirty write if  hit occurs while the cpu is writing and in the tag_comp state */
assign dirty0_wr_enable = mem_write &(valid0&comp0)&tag_comp || mem_write&mem_resp&(valid0&comp0);
assign dirty1_wr_enable = mem_write &(valid1&comp1)&tag_comp || mem_write&mem_resp&(valid1&comp1);
assign dirty2_wr_enable = mem_write &(valid2&comp2)&tag_comp || mem_write&mem_resp&(valid2&comp2);
assign dirty3_wr_enable = mem_write &(valid3&comp3)&tag_comp || mem_write&mem_resp&(valid3&comp3);
/* Hit occurs on a way with tag match and valid match in the tag_comp state */
assign way0_hit = (valid0&comp0)&(tag_comp | idling);
assign way1_hit = (valid1&comp1)&(tag_comp | idling);
assign way2_hit = (valid2&comp2)&(tag_comp | idling);
assign way3_hit = (valid3&comp3)&(tag_comp | idling);
/* Mem respond if a hit occurs in the tag_comp state or if a read/write occurs while idling */
assign mem_resp = ((valid0&comp0)|(valid1&comp1)|(valid2&comp2)|(valid3&comp3))&(tag_comp|idling)&(mem_write|mem_read);

endmodule : l2_hitselectlogic