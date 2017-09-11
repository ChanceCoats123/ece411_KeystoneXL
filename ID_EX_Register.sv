import lc3b_types::*;

module ID_EX_Register
(
	input clk,
	input logic load,
	input logic reset,
	/* Data inputs */
	input lc3b_control_word control,
	input lc3b_word pc,
	input lc3b_word sr1_out,
	input lc3b_word sr2_out,
	input lc3b_word sext_value,
	input lc3b_reg dr,
	input lc3b_reg sr1,
	input lc3b_reg sr2,
	input logic pred,
	input logic btb_hit,
	/* Data outputs */
	output lc3b_word pc_data,
	output lc3b_control_word control_data,
	output lc3b_word sr1_out_data,
	output lc3b_word sr2_out_data,
	output lc3b_word sext_value_data,
	output lc3b_reg dr_data,
	output lc3b_reg sr1_data,
	output lc3b_reg sr2_data,
	output logic pred_data,
	output logic btb_hit_data
);

initial
begin
control_data = 0;
pc_data  = 0;
sr1_out_data = 0;
sr2_out_data = 0;
sext_value_data = 0;
dr_data = 0;
sr1_data = 0;
sr2_data = 0;
pred_data = 0;
btb_hit_data = 0;
end

always_ff @(posedge clk)
begin
	if(reset) begin
		control_data <= 0;
		pc_data <= 0;
		sr1_out_data <= 0;
		sr2_out_data <= 0;
		sext_value_data <= 0;
		dr_data <= 0;
		sr1_data <= 0;
		sr2_data <= 0;
		pred_data <= 0;
		btb_hit_data <= 0;
		end
	else if(load) begin
		control_data <= control;
		pc_data <= pc;
		sr1_out_data <= sr1_out;
		sr2_out_data <= sr2_out;
		sext_value_data <= sext_value;
		dr_data <= dr;
		sr1_data <= sr1;
		sr2_data <= sr2;
		pred_data <= pred;
		btb_hit_data <= btb_hit;
		end
	else begin
		control_data <= control_data;
		pc_data <= pc_data;
		sr1_out_data <= sr1_out_data;
		sr2_out_data <= sr2_out_data;
		sext_value_data <= sext_value_data;
		dr_data <= dr_data;
		sr1_data <= sr1_data;
		sr2_data <= sr2_data;
		pred_data <= pred_data;
		btb_hit_data <= btb_hit_data;
		end
end

endmodule : ID_EX_Register