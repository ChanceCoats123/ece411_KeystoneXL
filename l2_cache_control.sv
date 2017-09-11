//import lc3b_types::*;

module l2_cache_control
(
	/* Clock! */
	input clk,
	/* To/From Cache Data Path */
	input logic dirty0_out,
	input logic dirty1_out,
	input logic dirty2_out,
	input logic dirty3_out,
	input logic way0_hit,
	input logic way1_hit,
	input logic way2_hit,
	input logic way3_hit,
	input logic[1:0] LRU_way_select,
	input logic valid0_out,
	input logic valid1_out,	
	input logic valid2_out,
	input logic valid3_out,	
	output logic valid0_in,
	output logic valid1_in,
	output logic valid2_in,
	output logic valid3_in,
	output logic valid0_wr_enable,
	output logic valid1_wr_enable,
	output logic valid2_wr_enable,
	output logic valid3_wr_enable,
	output logic alloc_dirty0_write,
	output logic alloc_dirty1_write,
	output logic alloc_dirty2_write,
	output logic alloc_dirty3_write,
	output logic dirty0_in,
	output logic dirty1_in,
	output logic dirty2_in,
	output logic dirty3_in,
	output logic tag_comp,
	output logic idling,
	output logic pmem_addr_sel,
	input logic mem_resp,
	/* To/From Physical Memory */
	input logic pmem_resp,
	output logic pmem_read,
	output logic pmem_write,
	/* To/From CPU */
	input logic mem_read,
	input logic mem_write
);

/* Internal */
logic		serviced;

/* Enumerate FSM states */
enum int unsigned
{
	idle_state, tag_compare_state, allocate_state, write_back_state
} state, next_state;

/* Current State Logic */
always_comb
begin
	/* Default assignments */
	valid0_in = 1'b0;
	valid1_in = 1'b0;
	valid2_in = 1'b0;
	valid3_in = 1'b0;
	valid0_wr_enable = 1'b0;
	valid1_wr_enable = 1'b0;
	valid2_wr_enable = 1'b0;
	valid3_wr_enable = 1'b0;
	alloc_dirty0_write = 1'b0;
	alloc_dirty1_write = 1'b0;	
	alloc_dirty2_write = 1'b0;
	alloc_dirty3_write = 1'b0;	
	dirty0_in = 1'b1;
	dirty1_in = 1'b1;
	dirty2_in = 1'b1;
	dirty3_in = 1'b1;
	tag_comp = 1'b0;
	idling = 1'b0;
	pmem_read = 1'b0;
	pmem_write = 1'b0;
	pmem_addr_sel = 1'b0;
	
	unique case (state)
		idle_state: begin
			idling = 1;
			end
		
		tag_compare_state: begin
			/* Signal that the tag compare state is the current state for mem_resp purposes (see hitselectlogic.sv) */
			tag_comp = 1;
			dirty0_in = 1'b1;
			dirty1_in = 1'b1;
			dirty2_in = 1'b1;
			dirty3_in = 1'b1;
			if(valid0_out & valid1_out & valid2_out & valid3_out)//((LRU_way_select == 2'b00) & dirty0_out & valid1_out & valid2_out & valid3_out) | ((LRU_way_select == 2'b01) & dirty1_out & valid0_out & valid2_out & valid3_out)| ((LRU_way_select == 2'b10) & dirty2_out & valid0_out & valid1_out & valid3_out) | ((LRU_way_select == 2'b11) & dirty3_out & valid0_out & valid1_out & valid2_out))
				pmem_addr_sel = 1;
			else
				pmem_addr_sel = 0;
			end
		
		allocate_state: begin
			/* If the least recently used way is 1, overwrite way1's data */
			case(LRU_way_select)
				2'b00: begin
					/* Set alloc_dirty1_write high to write the dirty bit since new data is present */	
					dirty0_in = 0;
					alloc_dirty0_write = 1;
					/* Set the valid bit as 1 since the data is now legitimate */
					valid0_in = 1;
					valid0_wr_enable = 1;
				end
				2'b01: begin
					/* Set alloc_dirty1_write high to write the dirty bit since new data is present */	
					dirty1_in = 0;
					alloc_dirty1_write = 1;
					/* Set the valid bit as 1 since the data is now legitimate */
					valid1_in = 1;
					valid1_wr_enable = 1;
				end
				2'b10: begin
					/* Set alloc_dirty1_write high to write the dirty bit since new data is present */	
					dirty2_in = 0;
					alloc_dirty2_write = 1;
					/* Set the valid bit as 1 since the data is now legitimate */
					valid2_in = 1;
					valid2_wr_enable = 1;
				end
				2'b11: begin
					/* Set alloc_dirty1_write high to write the dirty bit since new data is present */	
					dirty3_in = 0;
					alloc_dirty3_write = 1;
					/* Set the valid bit as 1 since the data is now legitimate */
					valid3_in = 1;
					valid3_wr_enable = 1;
				end
				default: /* Fuck off */ ;
			endcase
			/* Initiate a read from the physical memory */
			pmem_read = 1;
			end
			
		write_back_state: begin
			/* Select the tag address instead of the mem_address */
			pmem_addr_sel = 1;
			/* Initiate a write to the physical memory */
			pmem_write = 1;
			end
			
		default:
			/* Do nothing */ ;
	endcase
end

/* Next State Logic */
always_comb
begin
	/* Default action */
	next_state = state;
	
	unique case (state)
		idle_state: begin
			/* If there is a read or write signal from the cpu, enter the tag_compare_state */
			if(~mem_resp && (mem_read | mem_write))
				next_state = tag_compare_state;
			/* Otherwise, stay in the idle_state */	
			else
				next_state = idle_state;
			end
			
		tag_compare_state: begin
			/* If either way has a hit, return to the idle_state */
			if(way0_hit | way1_hit | way2_hit | way3_hit | serviced)
				next_state = idle_state;
			/* If LRU=way1 and way1=dirty,OR if LRU=way0 and way0=dirty, write back */	
			else if(valid0_out & valid1_out & valid2_out & valid3_out)//((LRU_way_select == 2'b00) & dirty0_out & valid1_out & valid2_out & valid3_out) | ((LRU_way_select == 2'b01) & dirty1_out & valid0_out & valid2_out & valid3_out)| ((LRU_way_select == 2'b10) & dirty2_out & valid0_out & valid1_out & valid3_out) | ((LRU_way_select == 2'b11) & dirty3_out & valid0_out & valid1_out & valid2_out))
				next_state = write_back_state;
			/* If a miss occurred and the line was clean, allocate */
			else
				next_state = allocate_state;
			end
			
		allocate_state: begin
			/* Wait for physical memory to respond */
			if(pmem_resp == 1)
				next_state = tag_compare_state;
			else
				next_state = allocate_state;
			end
			
		write_back_state: begin
			/* Wait for physical memory to respond */
			if(pmem_resp)
				next_state = allocate_state;
			else
				next_state = write_back_state;
			end
			
		default:
			/* Do nothing */ ;
	endcase
end

/* Next State Transition */
always_ff @(posedge clk)
begin
	state <= next_state;
	if(mem_resp & idling)
		serviced <= 1'b1;
	else if(~mem_resp & idling)
		serviced <= 1'b0;
	else
		serviced <= 1'b0;
end

endmodule : l2_cache_control