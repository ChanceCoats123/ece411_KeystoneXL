import lc3b_types::*;

module btb_output
(
	input logic opcode,
	input lc3b_word target_mux_out,
	input lc3b_word pc_address,
	input logic [1:0] pred,
	input logic hit,
	output logic btb_sig,
	output lc3b_word btb_dest,
	output logic pred_out,
	output logic decode_reset
);

always_comb
begin
	/* Default output assignments */
	btb_sig = 1'b0;
	btb_dest = 0;
	pred_out = 1'b0;
	decode_reset = 1'b0;
	
	/* If the br ind is not high, we are not predicting */
	if (~opcode)
		btb_sig = 1'b0;
	/* If there was a pc_address hit, then observe its branch prediction */
	else if (hit)
	begin	
		decode_reset = 1'b1;
		unique case (pred)
			2'b00: begin
				btb_sig = 1'b1;
				btb_dest = pc_address + 4'h2;
				pred_out = 1'b0;
			end
			2'b01: begin
				btb_sig = 1'b1;
				btb_dest = pc_address + 4'h2;
				pred_out = 1'b0;
			end
			2'b10: begin
				btb_sig = 1'b1;
				btb_dest = target_mux_out;
				pred_out = 1'b1;
			end
			2'b11: begin
				btb_sig = 1'b1;
				btb_dest = target_mux_out;
				pred_out = 1'b1;
			end
		endcase
	end		
end

endmodule : btb_output