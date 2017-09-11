import lc3b_types::*;

module stall_logic
(
	input 							clk,
	input lc3b_control_word  	mem_control,
	input logic 					count_in,
	input logic						instr_resp,
	input logic						mem_resp,
	input logic						instr_mem_read,
	input logic 					indirect_load,
	input logic						mem_write,
	output logic 					enable
);

/* Internal Signals */
logic		mem_ind;
logic		instr_ind;
logic		ready;

initial
begin
mem_ind = 1'b0;
instr_ind = 1'b0;
end

always_ff @(posedge clk)
begin
	/* Check for mem readiness */
	if(mem_resp & (mem_control.mem_read | mem_write))
		mem_ind <= 1'b1;
	else if(~(mem_control.mem_read | mem_write))	
		mem_ind <= 1'b1;
	else
		mem_ind <= mem_ind;
		
	/* Check for instruction readiness */	
	if(instr_resp)
		instr_ind <= 1'b1;
	else if(~instr_mem_read)
		instr_ind <= 1'b1;
	else
		instr_ind <= instr_ind;
	
	/* Check if enable has been set high, and reset for the next cycle */
	if(ready) begin
		mem_ind <= 1'b0;
		instr_ind <= 1'b0;
		end
end


always_comb
begin
	/* Stall for LDI or STI */
	if((mem_control.sti_ind | mem_control.ldi_ind) & (~count_in || ~indirect_load))
 		enable = 1'b0;
	/*else if(~(mem_ind & instr_ind))
		enable = 0;*/
		
	/* Stall for instruction and data memory */
	else if(~(mem_ind & instr_ind) & ((instr_mem_read  & (mem_control.mem_read | mem_write))| (instr_mem_read & ~(mem_control.mem_read | mem_write)) | (~instr_mem_read & (mem_control.mem_read | mem_write)))) begin
		/* Both respond immediately */
		if(instr_resp & ((mem_resp) & (mem_control.mem_read | mem_write)))
			enable = 1'b1;
		/* Instruction responds and Data was not waiting */
		else if(instr_resp & (/*(~mem_resp) &*/ ~(mem_control.mem_read | mem_write)))
			enable = 1'b1;
		/* Instruction responds and Data was previously resolved */
		else if(instr_resp & mem_ind)
			enable = 1'b1;
		/* No instruction read, but a mem access is happening */
		else if (~instr_mem_read & mem_resp)
			enable = 1'b1;
		/* Data responds and Instruction was previously resolved */
		else if(mem_resp & instr_ind)
			enable = 1'b1;
		/* The indicators are not high, and the above cases have not been met, stall	 */
		else	
			enable = 1'b0;
		end
	
	/* Do not stall under normal conditions */
	else
		enable = 1'b1;
		
	/* ADD MORE SHIT HERE */
	/* Check combinationally if both values come in immediately (both caches hit) */
	/* Check combinationally if one registered value is high, and the other response comes in. (one cache hit, other miss) */
end

assign ready = enable;

endmodule : stall_logic