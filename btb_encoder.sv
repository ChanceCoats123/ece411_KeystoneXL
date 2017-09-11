import lc3b_types::*;

module btb_encoder
(
	input logic comp0_out,
	input logic comp1_out,
	input logic comp2_out,
	input logic comp3_out,
	output logic [1:0] target_mux_sel
);

always_comb
begin	
	target_mux_sel = 2'b00;
	if (comp0_out)
		target_mux_sel = 2'b00;
	else if (comp1_out)
		target_mux_sel = 2'b01;
	else if (comp2_out)
		target_mux_sel = 2'b10;
	else if (comp3_out)
		target_mux_sel = 2'b11;
end

endmodule : btb_encoder