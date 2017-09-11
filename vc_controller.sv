import lc3b_types::*;

module vc_controller
(
	/* Clock! */
	input 					clk,
	/* To/From the L2 */
	input logic				l2_write,
	input logic 			l2_read,
	input logic				dirty0_out,
	input logic				dirty1_out,
	input logic				dirty2_out,
	input logic				dirty3_out,
	input logic [1:0]		LRU_way_select,
	/* To/From the VC Datapath */
	input logic				hit,
	input logic				valid,
	input logic				dirty,
	input logic				valid0_out,
	input logic				valid1_out,
	input logic				valid2_out,
	input logic				valid3_out,
	output logic			write_state,
	output logic			write_tag_data,
	output logic			write_buffer,
	output logic			write_valid,
	output logic			rdata_mux_sel,
	output logic			controller_resp,
	output logic			address_mux_sel,
	output logic			in_pmem_wb,
	/* To/From Physical Mem */
	input logic				pmem_resp,
	output logic			pmem_read,
	output logic			pmem_write	
);

enum int unsigned 
{
	idle, update_vc, vc_miss, vc_hit, pmem_wb, read_through
} state, next_state;

always_ff @(posedge clk)
begin
	state <= next_state;
end

always_comb
begin
	/* Default Assignments */
	write_state = 1'b0;
	write_tag_data = 1'b0;
	write_buffer = 1'b0;
	write_valid = 1'b0;
	rdata_mux_sel = 1'b0;
	controller_resp = 1'b0;
	pmem_read = 1'b0;
	pmem_write = 1'b0;
	address_mux_sel = 1'b0;
	in_pmem_wb = 1'b0;
	
	next_state = state;
	
	/* Current State Outputs */
	case(state)
		idle: begin
			/* Do nothing */;
		end
		update_vc: begin
			write_state = 1'b1;
			write_tag_data = 1'b1;
			write_buffer = 1'b1;
			write_valid = 1'b1;
			controller_resp = 1'b1;
		end
		vc_miss: begin
			pmem_read = 1'b1;
		end
		vc_hit: begin
			controller_resp = 1'b1;
			rdata_mux_sel = 1'b1;
		end
		pmem_wb: begin
			pmem_write = 1'b1;
			address_mux_sel = 1'b1;
			in_pmem_wb = 1'b1;
		end
		read_through: begin
			pmem_read = 1'b1;
		end
	endcase
	/* Next State Logic */
	case(state)
		idle: begin
			if(l2_write) 
				next_state = update_vc;
			else if(l2_read) begin
				if(valid)
					next_state = update_vc;
				else
					next_state = read_through;
			end	
			else
				next_state = idle;
		end
		update_vc: begin
			if(hit)
				next_state = vc_hit;
			else
				next_state = vc_miss;
		end
		vc_miss: begin
			/* This needs to check for validity in all four entries before going to pmem_wb */
			if(valid0_out & valid1_out & valid2_out & valid3_out) begin
				if(pmem_resp) begin
					if(dirty)
						next_state = pmem_wb;
					else
						next_state = idle;
				end	
			end		
			else if(pmem_resp)
				next_state = idle;
			else
				next_state = vc_miss;
		end
		vc_hit: begin
			next_state = idle;
		end
		pmem_wb: begin
			if(pmem_resp)
				next_state = idle;
			else
				next_state = pmem_wb;
		end
		read_through: begin
			if(pmem_resp)
				next_state = idle;
			else
				next_state = read_through;
		end
	endcase
end

endmodule : vc_controller