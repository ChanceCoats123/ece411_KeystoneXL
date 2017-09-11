import lc3b_types::*;

module arbiter_controller
(
	/* Clock */
	input clk,
	/* Inputs */
	input logic L1I_read,
	input logic L1D_read,
	input logic L1I_write,
	input logic L1D_write,
	input logic pmem_resp,
	/* Outputs */
	output logic L1I_resp,
	output logic L1D_resp,
	output logic pmem_read,
	output logic pmem_write,
	output logic arbiter_fsm_sel
);

enum int unsigned
{
	idle_state, service_data, service_instruction
} state, next_state;

always_comb
begin
	/* Default ASSignments */
	L1I_resp = 1'b0;
	L1D_resp = 1'b0;
	pmem_read = 1'b0;
	pmem_write = 1'b0;
	arbiter_fsm_sel = 1'b0;
	/* Default next_state */
	next_state = state;

	/* Current State Outputs */
	case(state)
		idle_state: /* DO NOOOOOOTHING! */ ;
		
		service_data: begin
			arbiter_fsm_sel = 1'b1;
			pmem_read = L1D_read;
			pmem_write = L1D_write;
			L1D_resp = pmem_resp;
			end
			
		service_instruction: begin
			arbiter_fsm_sel = 1'b0;
			pmem_read = L1I_read;
			pmem_write = L1I_write;
			L1I_resp = pmem_resp;
			end
		
		default: /* DO NOOOOOOTHING! */ ;
		
		endcase
	
	/* Next State Determinations */
	case(state)
		idle_state: begin
			if(L1D_read | L1D_write)
				next_state = service_data;
			else if(L1I_read | L1I_write)
				next_state = service_instruction;
			else
				next_state = idle_state;
			end
		
		service_data: begin
			if(pmem_resp) begin
				if(L1I_read | L1I_write)
					next_state = service_instruction;
				else
					next_state = idle_state;
				end
			else
				next_state = service_data;
			end
			
		service_instruction: begin
			if(pmem_resp) begin
				if(L1D_read | L1D_write)
					next_state = service_data;
				else
					next_state = idle_state;
				end
			else
				next_state = service_instruction;
			end
		
		default: /* DO NOOOOOOTHING! */ ;
		
		endcase			
end

always_ff @(posedge clk)
begin
	state <= next_state;
end

endmodule : arbiter_controller