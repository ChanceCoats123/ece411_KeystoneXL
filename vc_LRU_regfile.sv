import lc3b_types::*;

module vc_LRU_regfile
(
	input 				clk,
	input logic			write,
	input logic[1:0] 	way_hit,	
	output logic[1:0] replace
);

/* Internal Registers */
logic [1:0] data [3:0];

initial
begin
	data[0] = 2'b00;
	data[1] = 2'b01;
	data[2] = 2'b10;
	data[3] = 2'b11;
end

always_ff @(posedge clk)
begin
	if(write) begin
		/* Update data[0] */
		if (data[0] < data[way_hit])
			data[0] <= data[0] + 2'b01;
		else if (data[0] == data[way_hit])
			data[0] <= 2'b00;
		else
			data[0] <= data[0];
		/* Update data[1] */
		if (data[1] < data[way_hit])
			data[1] <= data[1] + 2'b01;
		else if (data[1] == data[way_hit])
			data[1] <= 2'b00;
		else
			data[1] <= data[1];
		/* Update data[2] */
		if (data[2] < data[way_hit])
			data[2] <= data[2] + 2'b01;
		else if (data[2] == data[way_hit])
			data[2] <= 2'b00;
		else
			data[2] <= data[2];
		/* Update data[3] */
		if (data[3] < data[way_hit])
			data[3] <= data[3] + 2'b01;
		else if (data[3] == data[way_hit])
			data[3] <= 2'b00;
		else
			data[3] <= data[3];
	end
	else begin
		data <= data;
	end
end

always_comb
begin
	if (data[0] == 2'b11)
		replace = 2'b00;
	else if (data[1] == 2'b11)
		replace = 2'b01;
	else if (data[2] == 2'b11)
		replace = 2'b10;
	else
		replace = 2'b11;
end

endmodule : vc_LRU_regfile