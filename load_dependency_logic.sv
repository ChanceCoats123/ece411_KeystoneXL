import lc3b_types::*;

module load_dependency_logic
(
	input clk,
	input lc3b_reg mem_dest,
	input lc3b_reg ex_src_A,
	input lc3b_reg ex_src_B,
	input logic enable,
	input lc3b_control_word mem_control,
	output logic stall,
	output logic reset
);

/* Internal Register */
logic enable_int;

always_ff @(posedge clk)
begin
	if(((mem_dest == ex_src_A) || (mem_dest == ex_src_B)) && mem_control.mem_read)
		enable_int <= enable;
	else
		enable_int <= 1'b1;
end

always_comb
begin
	/* Stall for dependency */
	if(((mem_dest == ex_src_A) || (mem_dest == ex_src_B)) && mem_control.mem_read) begin // Change this later to avoid 000 dependencies//
		if((~enable_int | ~enable) )
			stall = 1'b0;
		else
			stall = 1'b1;
		end
		
	else 
		stall = 1'b1;
	
	/* Reset after resolution */
	if((~enable_int & enable) & (mem_dest == ex_src_A) || (mem_dest == ex_src_B) & mem_control.mem_read)
		reset = 1'b1;
	else
		reset = 1'b0;
end

endmodule : load_dependency_logic