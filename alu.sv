import lc3b_types::*;

module alu
(
    input lc3b_aluop aluop,
    input lc3b_word a, b,
    output lc3b_word f
);

always_comb
begin
    case (aluop)
        alu_add: f = a + b;
        alu_and: f = a & b;
        alu_not: f = ~a;
        alu_pass: f = b;
        alu_sll: f = a << b;
        alu_srl: f = a >> b;
        alu_sra: f = $signed(a) >>> b;
		  alu_or: f = a | b;
		  alu_xor: f = a ^ b;
		  alu_sub: f = a - b;
        default: f = 0;
    endcase
end

endmodule : alu