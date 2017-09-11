import lc3b_types::*;

module MEM_WB_Register
(
	input clk,
	input logic load,
	input logic load_cc,
	input logic reset,
	/* Data inputs */
	input lc3b_control_word control,
	input lc3b_word pc,
	input lc3b_word branch_addr,
	input lc3b_nzp branch_enable,
	input lc3b_word mem_data,
	input lc3b_word alu,
	input lc3b_reg dr,
	input lc3b_reg sr1,
	input lc3b_reg sr2,
	input logic pred,
	input logic btb_hit,
	/* Data outputs */
	output lc3b_word pc_data,
	output lc3b_control_word control_data,
	output lc3b_word branch_addr_data,
	output lc3b_nzp branch_enable_data,
	output lc3b_word mem_data_data,
	output lc3b_word alu_data,
	output lc3b_reg dr_data,
	output lc3b_reg sr1_data,
	output lc3b_reg sr2_data,
	output logic pred_data,
	output logic btb_hit_data
);

initial
begin
control_data = 0;
pc_data = 0;
branch_addr_data = 0;
branch_enable_data = 0;
mem_data_data = 0;
alu_data = 0;
dr_data = 0;
sr1_data = 0;
sr2_data = 0;
pred_data = 0;
btb_hit_data = 0;
end

always_ff @(posedge clk)
begin
	if(reset) begin
		control_data = 0;
		pc_data = 0;
		branch_addr_data = 0;
		branch_enable_data = 0;
		mem_data_data = 0;
		alu_data = 0;
		dr_data = 0;
		sr1_data = 0;
		sr2_data = 0;
		pred_data = 0;
		btb_hit_data = 0;
		end
	else begin
		unique case ({load_cc,load})
			2'b00: begin
				control_data <= control_data;
				pc_data <= pc_data;
				branch_addr_data <= branch_addr_data;
				branch_enable_data <= branch_enable_data;
				mem_data_data <= mem_data_data;
				alu_data <= alu_data;
				dr_data <= dr_data;
				sr1_data <= sr1_data;
				sr2_data <= sr2_data;
				pred_data <= pred_data;
				btb_hit_data <= btb_hit_data;
				end
			2'b01: begin
				control_data <= control;
				pc_data <= pc;
				branch_addr_data <= branch_addr;
				mem_data_data <= mem_data;
				alu_data <= alu;
				dr_data <= dr;
				sr1_data <= sr1;
				sr2_data <= sr2;
				pred_data <= pred;
				btb_hit_data <= btb_hit;
				end
			2'b10: begin
				control_data <= control_data;
				pc_data <= pc_data;
				branch_addr_data <= branch_addr_data;
				branch_enable_data <= branch_enable;
				mem_data_data <= mem_data_data;
				alu_data <= alu_data;
				dr_data <= dr_data;
				sr1_data <= sr1_data;
				sr2_data <= sr2_data;
				pred_data <= pred_data;
				btb_hit_data <= btb_hit_data;
				end
			2'b11: begin
				control_data <= control;
				pc_data <= pc;
				branch_addr_data <= branch_addr;
				branch_enable_data <= branch_enable;
				mem_data_data <= mem_data;
				alu_data <= alu;
				dr_data <= dr;
				sr1_data <= sr1;
				sr2_data <= sr2;
				pred_data <= pred;
				btb_hit_data <= btb_hit;
				end
			default: 
				/* Do nothing */ ;
			endcase	
		end	
end

endmodule : MEM_WB_Register