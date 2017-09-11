import lc3b_types::*;

module stage_reset_logic
(
	input lc3b_control_word control_in,
	input logic btb_hit,
	input logic pred,
	input logic branch_enable,
	output logic reset
);

always_comb
begin
	if ((control_in.br_ind && ((pred != branch_enable) || ~(btb_hit))))
		reset = 1'b1;
	else if (control_in.jsr_ind | control_in.trap_ind)
		reset = 1'b1;
	else
		reset = 1'b0;
end

endmodule : stage_reset_logic