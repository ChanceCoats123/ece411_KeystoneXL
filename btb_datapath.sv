import lc3b_types::*;

module btb_datapath
(
	input 				clk,
	input lc3b_word 	pc_address,
	input lc3b_word	wb_pred_addr,
	input logic			opcode,
	input logic 		wb_sel,
	input lc3b_word	wb_pc,
	input logic			wb_btb_hit,
	input logic			branch_enable,
	output logic 		btb_sig,
	output lc3b_word 	btb_dest,
	output logic 		pred_to_datapath,
	output logic 		decode_reset,
	output logic 		hit
);

/* Internal signals */
logic 			data0_write;
logic 			data1_write;
logic 			data2_write;
logic 			data3_write;
logic 			tag0_write;
logic 			tag1_write;
logic 			tag2_write;
logic 			tag3_write;
logic				LRU_wr_enable;
logic [2:0]		lru_in;
logic [2:0]		lru_out;
lc3b_word		tag0_out;
lc3b_word		tag1_out;
lc3b_word		tag2_out;
lc3b_word		tag3_out;
lc3b_word		data0_out;
lc3b_word		data1_out;
lc3b_word 		data2_out;
lc3b_word		data3_out;
logic [1:0]		target_mux_sel;
lc3b_word		target_mux_out;
logic [1:0]		pred0_out;
logic [1:0]    pred1_out;
logic [1:0]		pred2_out;
logic [1:0]		pred3_out;
logic [1:0]		pred_out;
logic [1:0]		pred_update;
logic				pred0_write;
logic				pred1_write;
logic				pred2_write;
logic				pred3_write;
logic [1:0]		LRU_way_select;
logic [1:0]		encoder_out;
lc3b_word		data_mux_out;
logic				comp0_out;
logic 			comp1_out;
logic				comp2_out;
logic 			comp3_out;
logic				comp4_out;
logic 			comp5_out;
logic				comp6_out;
logic 			comp7_out;
logic				valid0_out;
logic				valid1_out;
logic				valid2_out;
logic				valid3_out;
logic [1:0]		decode_sel;
logic	[1:0]		pred_datapath;
logic				wb_hit;

/* Hit determination */
assign hit = ((comp0_out&valid0_out) || (comp1_out&valid1_out) || (comp2_out&valid2_out) || (comp3_out&valid3_out)); 
assign wb_hit = ((comp4_out&valid0_out) || (comp5_out&valid1_out) || (comp6_out&valid2_out) || (comp7_out&valid3_out)); 

/* Predictor updating */
btb_update update
(
	.branch_enable(branch_enable),
	.target_mux_sel(target_mux_sel),
	.hit(wb_btb_hit),
	.wb_hit(wb_hit),
	.wb_sel(wb_sel),
	.current_pred(pred_out),
	.lru(LRU_way_select),
	.pred0_write(pred0_write),
	.pred1_write(pred1_write),
	.pred2_write(pred2_write),
	.pred3_write(pred3_write),
	.pred_update(pred_update),
	.data0_write(data0_write),
	.data1_write(data1_write),
	.data2_write(data2_write),
	.data3_write(data3_write),
	.tag0_write(tag0_write),
	.tag1_write(tag1_write),
	.tag2_write(tag2_write),
	.tag3_write(tag3_write),
	.LRU_write(LRU_wr_enable)	
);

/* Data arrays for each of the four sets */

mux2 #(.width(16)) data_mux
(
	.sel(wb_sel),
	.a(pc_address),
	.b(wb_pc - 4'h2),
	.f(data_mux_out)
);

l2_array #(.width(16)) data_way0
(
	.clk(clk),
	.write(data0_write),
	.index(data_mux_out[6:5]),
	.datain(wb_pred_addr),
	.dataout(data0_out)
);

l2_array #(.width(16)) data_way1
(
	.clk(clk),
	.write(data1_write),
	.index(data_mux_out[6:5]),
	.datain(wb_pred_addr),
	.dataout(data1_out)
);

l2_array #(.width(16)) data_way2
(
	.clk(clk),
	.write(data2_write),
	.index(data_mux_out[6:5]),
	.datain(wb_pred_addr),
	.dataout(data2_out)
);

l2_array #(.width(16)) data_way3
(
	.clk(clk),
	.write(data3_write),
	.index(data_mux_out[6:5]),
	.datain(wb_pred_addr),
	.dataout(data3_out)
);

/* Tag arrays for each of the four sets */

l2_array #(.width(16)) tag_way0
(
	.clk(clk),
	.write(tag0_write),
	.index(data_mux_out[6:5]),
	.datain(data_mux_out),
	.dataout(tag0_out)
);

l2_array #(.width(16)) tag_way1
(
	.clk(clk),
	.write(tag1_write),
	.index(data_mux_out[6:5]),
	.datain(data_mux_out),
	.dataout(tag1_out)
);

l2_array #(.width(16)) tag_way2
(
	.clk(clk),
	.write(tag2_write),
	.index(data_mux_out[6:5]),
	.datain(data_mux_out),
	.dataout(tag2_out)
);

l2_array #(.width(16)) tag_way3
(
	.clk(clk),
	.write(tag3_write),
	.index(data_mux_out[6:5]),
	.datain(data_mux_out),
	.dataout(tag3_out)
);

/* Branch predictors for each set */

l2_array #(.width(2)) brpred_way0
(
	.clk(clk),
	.write(pred0_write),
	.index(data_mux_out[6:5]),
	.datain(pred_update),
	.dataout(pred0_out)
);

l2_array #(.width(2)) brpred_way1
(
	.clk(clk),
	.write(pred1_write),
	.index(data_mux_out[6:5]),
	.datain(pred_update),
	.dataout(pred1_out)
);

l2_array #(.width(2)) brpred_way2
(
	.clk(clk),
	.write(pred2_write),
	.index(data_mux_out[6:5]),
	.datain(pred_update),
	.dataout(pred2_out)
);

l2_array #(.width(2)) brpred_way3
(
	.clk(clk),
	.write(pred3_write),
	.index(data_mux_out[6:5]),
	.datain(pred_update),
	.dataout(pred3_out)
);

/* Valid arrays */

l2_array #(.width(1)) valid_way0
(
	.clk(clk),
	.write(data0_write),
	.index(data_mux_out[6:5]),
	.datain(1'b1),
	.dataout(valid0_out)
);

l2_array #(.width(1)) valid_way1
(
	.clk(clk),
	.write(data1_write),
	.index(data_mux_out[6:5]),
	.datain(1'b1),
	.dataout(valid1_out)
);

l2_array #(.width(1)) valid_way2
(
	.clk(clk),
	.write(data2_write),
	.index(data_mux_out[6:5]),
	.datain(1'b1),
	.dataout(valid2_out)
);

l2_array #(.width(1)) valid_way3
(
	.clk(clk),
	.write(data3_write),
	.index(data_mux_out[6:5]),
	.datain(1'b1),
	.dataout(valid3_out)
);

/* Tag compares for the result from each set */

tagcomp16 tag0
(
	.A(tag0_out),
	.B(pc_address),
	.F(comp0_out)
);

tagcomp16 tag1
(
	.A(tag1_out),
	.B(pc_address),
	.F(comp1_out)
);

tagcomp16 tag2
(
	.A(tag2_out),
	.B(pc_address),
	.F(comp2_out)
);

tagcomp16 tag3
(
	.A(tag3_out),
	.B(pc_address),
	.F(comp3_out)
);

/* Tag compares for WB */
tagcomp16 tag4
(
	.A(tag0_out),
	.B(wb_pc - 4'h2),
	.F(comp4_out)
);

tagcomp16 tag5
(
	.A(tag1_out),
	.B(wb_pc - 4'h2),
	.F(comp5_out)
);

tagcomp16 tag6
(
	.A(tag2_out),
	.B(wb_pc - 4'h2),
	.F(comp6_out)
);

tagcomp16 tag7
(
	.A(tag3_out),
	.B(wb_pc - 4'h2),
	.F(comp7_out)
);

/* LRU hardware */

l2_array #(.width(3)) LRU_array
(
	.clk(clk),
   .write(LRU_wr_enable),
   .index(data_mux_out[6:5]),
   .datain(lru_in),
   .dataout(lru_out)
);

LRU_replacement way_replace_module
(
	.lru_state(lru_out),
	.replace(LRU_way_select)
);

LRU_input LRU_input_module
(
	.lru_state(lru_out),
	.way_hit(target_mux_sel),
	.new_state(lru_in)
);

btb_encoder encoder
(
	.comp0_out(comp4_out & valid0_out),
	.comp1_out(comp5_out & valid1_out),
	.comp2_out(comp6_out & valid2_out),
	.comp3_out(comp7_out & valid3_out),
	.target_mux_sel(target_mux_sel)
);

btb_encoder encoder1
(
	.comp0_out(comp0_out & valid0_out),
	.comp1_out(comp1_out & valid1_out),
	.comp2_out(comp2_out & valid2_out),
	.comp3_out(comp3_out & valid3_out),
	.target_mux_sel(decode_sel)
);

mux4 #(.width(16)) target_mux
(
	.sel(decode_sel),
	.a(data0_out),
	.b(data1_out),
	.c(data2_out),
	.d(data3_out),
	.out(target_mux_out)
);

mux4 #(.width(2)) brpred_mux
(
	.sel(decode_sel),
	.a(pred0_out),
	.b(pred1_out),
	.c(pred2_out),
	.d(pred3_out),
	.out(pred_datapath)
);

mux4 #(.width(2)) brpred_mux1
(
	.sel(target_mux_sel),
	.a(pred0_out),
	.b(pred1_out),
	.c(pred2_out),
	.d(pred3_out),
	.out(pred_out)
);

btb_output btb_out
(
	.opcode(opcode),
	.target_mux_out(target_mux_out),
	.pc_address(pc_address),
	.pred(pred_datapath),
	.hit(hit),
	.btb_sig(btb_sig),
	.btb_dest(btb_dest),
	.pred_out(pred_to_datapath),
	.decode_reset(decode_reset)
);

endmodule : btb_datapath