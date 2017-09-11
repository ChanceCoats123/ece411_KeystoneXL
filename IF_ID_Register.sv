import lc3b_types::*;

module IF_ID_Register
(
	input clk,
	input logic load,
	input logic reset,
	/* Data inputs */
	input lc3b_word pc,
	input lc3b_word instr,
	/* Data outputs */
	output lc3b_word pc_data,
	output lc3b_word instr_data
);

initial
begin
pc_data = 0;
instr_data = 0;
end

always_ff @(posedge clk)
begin
	if(reset) begin
		pc_data <= 0;
		instr_data <= 0;
		end
	else if(load) begin
		pc_data <= pc;
		instr_data <= instr;
		end
	else begin
		pc_data <= pc_data;
		instr_data <= instr_data;
		end
end

endmodule : IF_ID_Register