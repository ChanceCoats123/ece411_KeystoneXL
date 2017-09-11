import lc3b_types::*;

module adder #( parameter width = 16)
(
	input lc3b_word a, b,
	output lc3b_word result

);

always_comb
begin
	result = a + b;
end

endmodule : adder