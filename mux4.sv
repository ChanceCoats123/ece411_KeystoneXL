module mux4 #( parameter width = 16 )
(
	input logic[1:0] sel,
	input logic[width-1:0] a,b,c,d,
	output logic[width-1:0] out
);

always_comb 
begin
	unique case(sel)
			2'b00: out = a;
			2'b01: out = b;
			2'b10: out = c;
			2'b11: out = d;
			default: /* Do nothing */ ;
		endcase
end

endmodule : mux4