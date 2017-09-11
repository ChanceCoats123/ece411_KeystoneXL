import lc3b_types::*;

module way_hit_encoder
(
	input logic way0_hit,
	input logic way1_hit,
	input logic way2_hit,
	input logic way3_hit,
	output logic[1:0] way_hit
);

always_comb
begin
	case({way0_hit,way1_hit,way2_hit,way3_hit})
		4'b1000: way_hit = 2'b00;
		4'b0100: way_hit = 2'b01;
		4'b0010: way_hit = 2'b10;
		4'b0001: way_hit = 2'b11;
		/* Potentially change this later */
		default: way_hit = 2'b00;
	endcase	
end

endmodule : way_hit_encoder