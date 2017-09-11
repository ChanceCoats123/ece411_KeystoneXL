import lc3b_types::*;

module LRU_replacement
(
	input logic[2:0] lru_state,
	output logic[1:0] replace
);

always_comb
begin
	case(lru_state[0])
		1'b0: begin
			case(lru_state[2])
				1'b0: replace = 2'b11;
				1'b1: replace = 2'b10;
			endcase
		end
		1'b1: begin
			case(lru_state[1])
				1'b0: replace = 2'b01;
				1'b1: replace = 2'b00;
			endcase
		end
	endcase	
end

endmodule : LRU_replacement