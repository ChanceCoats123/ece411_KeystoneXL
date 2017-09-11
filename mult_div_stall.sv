import lc3b_types::*;

module mult_div_stall
(
	input clk,
	input logic load,
	input logic stalled,
	output logic enable
);

/* Internal Signals */
logic[2:0]	count;

initial
begin
count = 3'b000;
end

always_ff @(posedge clk)
begin
	if(load) begin
		case(count)
			3'b000: count <= 3'b001;
			3'b001: count <= 3'b010;
			3'b010: count <= 3'b011;
			3'b011: count <= 3'b100;
			3'b100: count <= 3'b101;
			3'b101: begin
				if(stalled)
					count <= 3'b000;
				else
					count <= 3'b101;
			end
			default: count <= 3'b000;
		endcase
	end
	else
		count <= count;
end

always_comb
begin
	if((count != 3'b000) && (count != 3'b101))
		enable = 1'b0;
	else if ((load == 1'b1) && (count == 3'b000))
		enable = 1'b0;
	else
		enable = 1'b1;
end

endmodule : mult_div_stall