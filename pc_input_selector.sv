import lc3b_types::*;

module pc_input_selector
(
	input logic trap_ind,
	input logic br_ind,
	input logic jsr_ind,
	input logic wb_btb_hit,
	input logic wb_pred,
	input logic decode_btb_hit,
	input logic wb_branch_enable,
	input logic wrong_in,
	output logic [1:0] pc_mux_sel
);

logic correct, wrong;

assign correct = (br_ind && (wb_btb_hit && (wb_pred == wb_branch_enable))) || ~br_ind || (br_ind && ~wb_btb_hit);
assign wrong = ~correct;
assign pc_mux_sel[1] = ~(br_ind && wrong_in) && (trap_ind || decode_btb_hit);

always_comb
begin
	/* Give highest precedence to wrong predictions */
	if (wrong) begin
		if (wb_pred == 0)
			pc_mux_sel[0] = 1'b1;
		else
			pc_mux_sel[0] = 1'b0;
	end		
	else if (trap_ind) 	
		pc_mux_sel[0] = 1'b0;
	else if (jsr_ind)	
		pc_mux_sel[0] = 1'b1;
	else if (decode_btb_hit)
		pc_mux_sel[0] = 1'b1;
	else if (wb_branch_enable && br_ind && ~wb_btb_hit)
		pc_mux_sel[0] = 1'b1;
	else
		pc_mux_sel[0] = 1'b0;
end

endmodule : pc_input_selector