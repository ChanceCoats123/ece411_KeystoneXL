import lc3b_types::*;

module nzp_comparator
(
	input lc3b_nzp a,
	input lc3b_reg b,
	output logic z
);

always_comb
begin
	z = (a[0] & b[0]) | (a[1] & b[1]) | (a[2] & b[2]);
end

endmodule : nzp_comparator