import lc3b_types::*;

module LRU_input
(
	input logic[2:0] lru_state,
	input logic[1:0] way_hit,
	output logic[2:0] new_state
);

assign new_state[0] = way_hit[1];

always_comb
begin
	case(way_hit[1])
		1'b0: begin
			new_state[1] = way_hit[0];
			new_state[2] = lru_state[2];
		end
		1'b1: begin
			new_state[2] = way_hit[0];
			new_state[1] = lru_state[1];
		end
	endcase	
end

endmodule : LRU_input