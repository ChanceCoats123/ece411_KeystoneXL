import lc3b_types::*;

module branch_intercept
(
	input lc3b_control_word control_in,
	input lc3b_reg nzp,
	output lc3b_control_word control_out
);

/* Internal signals */
logic nzp_zero;
assign nzp_zero = nzp ? 1'b1 : 1'b0;

always_comb
begin
	control_out = control_in;

	if((control_in.opcode == op_br) & ~nzp_zero)
		control_out.br_ind = 0;
end

endmodule : branch_intercept