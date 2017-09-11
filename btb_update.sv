import lc3b_types::*;

module btb_update
(
	input logic				branch_enable,
	input logic [1:0] 	target_mux_sel,
	input logic				hit,
	input logic				wb_hit,
	input logic				wb_sel,
	input logic [1:0]		current_pred,
	input logic [1:0]		lru,
	output logic 			pred0_write,
	output logic 			pred1_write,
	output logic 			pred2_write,
	output logic 			pred3_write,
	output logic [1:0] 	pred_update,
	output logic 			data0_write,
	output logic 			data1_write,
	output logic 			data2_write,
	output logic 			data3_write,
	output logic 			tag0_write,
	output logic 			tag1_write,
	output logic 			tag2_write,
	output logic 			tag3_write,
	output logic 			LRU_write	
);

always_comb
/* This module updates the predictor and predicted pc for the current branch instruction */
begin
	/* Default output assignments */
	pred0_write = 1'b0;
	data0_write = 1'b0;
	pred1_write = 1'b0;
	data1_write = 1'b0;
	pred2_write = 1'b0;
	data2_write = 1'b0;
	pred3_write = 1'b0;
	data3_write = 1'b0;
	pred_update = 2'b00;
	tag0_write = 1'b0;
	tag1_write = 1'b0;
	tag2_write = 1'b0;
	tag3_write = 1'b0;
	LRU_write = 1'b0;
	
	/* Must be in WB of a branch instruction to update */
	if (wb_sel) begin
		if (~(hit || wb_hit)) begin
			if (branch_enable) begin
				pred_update = 2'b01;
			end	
		/* Evict using the LRU */
			unique case(lru)
				2'b00: begin
					tag0_write = 1'b1;
					LRU_write = 1'b1;
					//pred0_write = 1'b1;
					data0_write = 1'b1;
				end
				2'b01: begin
					//pred1_write = 1'b1;
					data1_write = 1'b1;				
					tag1_write = 1'b1;
					LRU_write = 1'b1;
				end
				2'b10: begin
					//pred2_write = 1'b1;
					data2_write = 1'b1;
					tag2_write = 1'b1;
					LRU_write = 1'b1;
				end
				2'b11: begin
					//pred3_write = 1'b1;
					data3_write = 1'b1;
					tag3_write = 1'b1;
					LRU_write = 1'b1;
				end
			endcase
		end	
	
		/* Set the corresponding write signal high */
		else begin
			if (wb_hit) begin
			LRU_write = 1'b1;
			unique case (target_mux_sel)
				2'b00: begin
					pred0_write = 1'b1;
					data0_write = 1'b1;
				end
				2'b01: begin
					pred1_write = 1'b1;
					data1_write = 1'b1;
				end
				2'b10: begin
					pred2_write = 1'b1;
					data2_write = 1'b1;
				end
				2'b11: begin
					pred3_write = 1'b1;
					data3_write = 1'b1;
				end	
			endcase
			end
		
			/* Predictor update logic */
			unique case (current_pred)
				2'b00: begin
					if (branch_enable)
						pred_update = 2'b01;
					else
						pred_update = 2'b00;
				end
				2'b01: begin
					if (branch_enable)
						pred_update = 2'b10;
					else
						pred_update = 2'b00;
				end
				2'b10: begin
					if (branch_enable)
						pred_update = 2'b11;
					else
						pred_update = 2'b01;
				end
				2'b11: begin
					if (branch_enable)
						pred_update = 2'b11;
					else
						pred_update = 2'b10;
				end
				endcase
		end	
	end	
end

endmodule : btb_update