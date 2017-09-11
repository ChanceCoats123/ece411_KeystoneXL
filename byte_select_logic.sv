import lc3b_types::*;

module byte_select_logic
(
	input logic low_addr_bit,
	input logic stb_ind,
	input logic ldb_ind,
	output lc3b_mem_wmask mem_byte_enable,
	output logic byte_sel
);

always_comb
begin
	if((stb_ind | ldb_ind) & low_addr_bit) begin
		mem_byte_enable = 2'b10;
		byte_sel = 1;
		end
	else if(stb_ind & ~low_addr_bit) begin
		mem_byte_enable = 2'b01;
		byte_sel = 0;
		end
	else begin
		mem_byte_enable = 2'b11;
		byte_sel = 0;
		end
end

endmodule : byte_select_logic