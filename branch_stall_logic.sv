import lc3b_types::*;

module branch_stall_logic
(
	input lc3b_control_word control_in,
	input logic btb_hit,
	output logic enable
);

always_comb
begin
	if((control_in.br_ind && ~btb_hit) ||control_in.jsr_ind || control_in.trap_ind)
		enable  = 1'b0;
	else
		enable = 1'b1;
end

endmodule : branch_stall_logic