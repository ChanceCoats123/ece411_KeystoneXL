import lc3b_types::*;

module forwarding_logic
(
	input lc3b_control_word ex_control,
	input lc3b_control_word mem_control,
	input lc3b_control_word wb_control,
	input lc3b_reg	mem_dest,
	input lc3b_reg	wb_dest,
	input lc3b_reg	ex_src_A,
	input lc3b_reg	ex_src_B,
	input lc3b_reg decode_src_A,
	input lc3b_reg decode_src_B,
	output logic[1:0] sel_A,
	output logic[1:0] sel_B,
	output logic decode_A,
	output logic decode_B,
	output logic[1:0] addr2_sel
);

always_comb
begin
	/* Default assignments */
	sel_A = 2'b00;
	sel_B = 2'b00;
	decode_A = 1'b0;
	decode_B = 1'b0;
	addr2_sel = 2'b00;
	/* Forwarding hazards! */
	
		/* ALU only instructions */
		/* ADD or AND with both source registers */
		if(((ex_control.opcode == op_add)|| (ex_control.opcode == op_and) || (ex_control.opcode == op_rti)) && ~ex_control.src2mux_sel) begin
			/* sr1 forwarding */
			if((ex_src_A == mem_dest) && ((mem_control.opcode == op_add)||(mem_control.opcode == op_and)||(mem_control.opcode == op_not)||(mem_control.opcode == op_shf)||(mem_control.opcode == op_rti)))
				sel_A = 2'b01;
			else if((ex_src_A == mem_dest) && ((mem_control.opcode == op_lea)||(mem_control.opcode == op_ldr) || (mem_control.opcode == op_ldi) || (mem_control.opcode == op_ldb)))
				sel_A = 2'b11;
			else if((ex_src_A == wb_dest) && ((wb_control.opcode == op_add)||(wb_control.opcode == op_and)||(wb_control.opcode == op_not)||(wb_control.opcode == op_shf)||(wb_control.opcode == op_rti)))
				sel_A = 2'b10;
			else if((ex_src_A == wb_dest) && ((wb_control.opcode == op_ldb) || (wb_control.opcode == op_ldi) || (wb_control.opcode == op_ldr) || (wb_control.opcode == op_lea)))
				sel_A = 2'b10;
			else
				sel_A = 2'b00;
			/* sr2 forwarding */
			if((ex_src_B == mem_dest) && ((mem_control.opcode == op_add)||(mem_control.opcode == op_and)||(mem_control.opcode == op_not)||(mem_control.opcode == op_shf)||(mem_control.opcode == op_rti)))
				sel_B = 2'b01;
			else if((ex_src_B == mem_dest) && ((mem_control.opcode == op_lea)||(mem_control.opcode == op_ldr) || (mem_control.opcode == op_ldi) || (mem_control.opcode == op_ldb)) )
				sel_B = 2'b11;
			else if((ex_src_B == wb_dest) && ((wb_control.opcode == op_add)||(wb_control.opcode == op_and)||(wb_control.opcode == op_not)||(wb_control.opcode == op_shf)||(wb_control.opcode == op_rti)))
				sel_B = 2'b10;
			else if((ex_src_B == wb_dest) && ((wb_control.opcode == op_ldb) || (wb_control.opcode == op_ldi) || (wb_control.opcode == op_ldr) || (wb_control.opcode == op_lea)))
				sel_B = 2'b10;
			else
				sel_B = 2'b00;
		end
		/* ADD or AND (with a single source register) or NOT or SHIFT */
		else if((ex_control.opcode == op_not) || (ex_control.opcode == op_shf) || (((ex_control.opcode == op_add)|| (ex_control.opcode == op_and)) && ex_control.src2mux_sel )) begin
		/* sr1 forwarding */
			if((ex_src_A == mem_dest) && ((mem_control.opcode == op_add)||(mem_control.opcode == op_and)||(mem_control.opcode == op_not)||(mem_control.opcode == op_shf)||(mem_control.opcode == op_rti)))
				sel_A = 2'b01;
			else if((ex_src_A == mem_dest) && ((mem_control.opcode == op_lea)||(mem_control.opcode == op_ldr) || (mem_control.opcode == op_ldi) || (mem_control.opcode == op_ldb)))
				sel_A = 2'b11;
			else if((ex_src_A == wb_dest) && ((wb_control.opcode == op_add)||(wb_control.opcode == op_and)||(wb_control.opcode == op_not)||(wb_control.opcode == op_shf)||(wb_control.opcode == op_rti)))
				sel_A = 2'b10;
			else if((ex_src_A == wb_dest) && ((wb_control.opcode == op_ldb) || (wb_control.opcode == op_ldi) || (wb_control.opcode == op_ldr) || (wb_control.opcode == op_lea)))
				sel_A = 2'b10;
			else
				sel_A = 2'b00;
		end
		/* Branch Adder only instructions */
		else if(((ex_control.opcode == op_jsr) && (ex_control.offmux_sel == 3'b000)) || ((ex_control.opcode == op_ldb) || (ex_control.opcode == op_ldi) || (ex_control.opcode == op_ldr) || (ex_control.opcode == op_jmp))) begin
			/* addr2 forwarding */
			if((ex_src_A == mem_dest) && ((mem_control.opcode == op_add)||(mem_control.opcode == op_and)||(mem_control.opcode == op_not)||(mem_control.opcode == op_shf)||(mem_control.opcode == op_rti)))
				addr2_sel = 2'b01;
			else if((ex_src_A == mem_dest) && ((mem_control.opcode == op_lea)||(mem_control.opcode == op_ldr) || (mem_control.opcode == op_ldi) || (mem_control.opcode == op_ldb)))
				addr2_sel = 2'b11;
			else if((ex_src_A == wb_dest) && ((wb_control.opcode == op_add)||(wb_control.opcode == op_and)||(wb_control.opcode == op_not)||(wb_control.opcode == op_shf)||(wb_control.opcode == op_rti)))
				addr2_sel = 2'b10;
			else if((ex_src_A == wb_dest) && ((wb_control.opcode == op_ldb) || (wb_control.opcode == op_ldi) || (wb_control.opcode == op_ldr) || (wb_control.opcode == op_lea)))
				addr2_sel = 2'b10;
			else
				addr2_sel = 2'b00;
		end
		/* ALU and Branch Adder instructions */
		else if((ex_control.opcode == op_stb) || (ex_control.opcode == op_sti) || (ex_control.opcode == op_str)) begin
			/* addr2 forwarding */
			if((ex_src_A == mem_dest) && ((mem_control.opcode == op_add)||(mem_control.opcode == op_and)||(mem_control.opcode == op_not)||(mem_control.opcode == op_shf)||(mem_control.opcode == op_rti)))
				addr2_sel = 2'b01;
			else if((ex_src_A == mem_dest) && ((mem_control.opcode == op_lea)||(mem_control.opcode == op_ldr) || (mem_control.opcode == op_ldi) || (mem_control.opcode == op_ldb)))
				addr2_sel = 2'b11;
			else if((ex_src_A == wb_dest) && ((wb_control.opcode == op_add)||(wb_control.opcode == op_and)||(wb_control.opcode == op_not)||(wb_control.opcode == op_shf)||(wb_control.opcode == op_rti)))
				addr2_sel = 2'b10;
			else if((ex_src_A == wb_dest) && ((wb_control.opcode == op_ldb) || (wb_control.opcode == op_ldi) || (wb_control.opcode == op_ldr) || (wb_control.opcode == op_lea)))
				addr2_sel = 2'b10;
			else
				addr2_sel = 2'b00;
			/* sr2 forwarding */
			if((ex_src_B == mem_dest) && ((mem_control.opcode == op_add)||(mem_control.opcode == op_and)||(mem_control.opcode == op_not)||(mem_control.opcode == op_shf)||(mem_control.opcode == op_rti)))
				sel_B = 2'b01;
			else if((ex_src_B == mem_dest) && ((mem_control.opcode == op_lea)||(mem_control.opcode == op_ldr) || (mem_control.opcode == op_ldi) || (mem_control.opcode == op_ldb)))
				sel_B = 2'b11;
			else if((ex_src_B == wb_dest) && ((wb_control.opcode == op_add)||(wb_control.opcode == op_and)||(wb_control.opcode == op_not)||(wb_control.opcode == op_shf)||(wb_control.opcode == op_rti)))
				sel_B = 2'b10;
			else if((ex_src_B == wb_dest) && ((wb_control.opcode == op_ldb) || (wb_control.opcode == op_ldi) || (wb_control.opcode == op_ldr) || (wb_control.opcode == op_lea)))
				sel_B = 2'b10;
			else
				sel_B = 2'b00;
		end	

	//Decode SR1	
	if((decode_src_A == wb_dest) && wb_control.load_regfile)
		decode_A = 1'b1;
	else
		decode_A = 1'b0;
	//Decode SR2	
	if((decode_src_B == wb_dest) && wb_control.load_regfile)
		decode_B = 1'b1;
	else
		decode_B = 1'b0;
end

endmodule : forwarding_logic