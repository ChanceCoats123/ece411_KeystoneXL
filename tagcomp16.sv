import lc3b_types::*;

module tagcomp16
(
	input lc3b_word A,
	input lc3b_word B,
	output logic F
);

always_comb
begin
	if(A == B)
		F = 1'b1;
	else
		F = 1'b0;
end

endmodule : tagcomp16