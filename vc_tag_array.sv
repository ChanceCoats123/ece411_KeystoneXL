import lc3b_types::*;

module vc_tag_array #(parameter width = 16)

(
    input clk,
    input write,
    input logic[1:0] index,
    input [width-1:0] datain,
    output logic [width-1:0] dataout0,
	 output logic [width-1:0] dataout1,
	 output logic [width-1:0] dataout2,
	 output logic [width-1:0] dataout3
);

logic [width-1:0] data [3:0];

/* Initialize array */
initial
begin
    for (int i = 0; i < $size(data); i++)
    begin
        data[i] = 1'b0;
    end
end

always_ff @(posedge clk)
begin
    if (write == 1)
    begin
        data[index] = datain;
    end
end

assign dataout0 = data[0];
assign dataout1 = data[1];
assign dataout2 = data[2];
assign dataout3 = data[3];

endmodule : vc_tag_array