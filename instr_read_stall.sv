import lc3b_types::*;

module instr_read_stall
(
	input clk,
	input logic mem_resp,
	input logic reset,
	input logic [3:0] opcode,
	input logic [2:0] nzp,
	output logic read
);

/*Internal Signals */
logic [3:0] opcode_int;
logic [2:0] nzp_int;

initial
begin
opcode_int = 4'b0;
nzp_int = 3'b0;
end

always_ff @(posedge clk)
begin
	if(reset) begin
		opcode_int <= 4'b0;
		nzp_int <= 3'b0;
		end
	else if(mem_resp) begin	
		opcode_int <= opcode;
		nzp_int <= nzp;
		end
	else begin
		opcode_int <= opcode_int;
		nzp_int <= nzp_int;
		end
end

always_comb
begin
	case (opcode_int)
		op_br: begin
			if(nzp_int)
				read = 1'b0;
			else
				read = 1'b1;
			end
		op_jmp: read = 1'b0;
		op_jsr: read = 1'b0;
		op_trap: read = 1'b0;
		default: read = 1'b1;
		endcase
end

endmodule : instr_read_stall