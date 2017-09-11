import lc3b_types::*;

/* TO DO:: Decide ctrl word size */

module control_rom
(
	input lc3b_ctrl_in info,
	output lc3b_control_word ctrl
);

always_comb
begin
	/* Default assignments */
	ctrl.opcode = info[3:0];
	ctrl.aluop = alu_add;
	ctrl.loadcc_ex = 1'b0;
	ctrl.loadcc_mem = 1'b0;
	ctrl.load_regfile = 1'b0;
	ctrl.stb_ind = 1'b0;
	ctrl.ldb_ind = 1'b0;
	ctrl.mem_read = 1'b0;
	ctrl.mem_write = 1'b0;
	ctrl.mem_byte_enable = 2'b11;
	ctrl.src2mux_sel = 1'b0;
	ctrl.drmux_sel = 1'b0;
	ctrl.sr2mux_sel = 1'b0;
	ctrl.ldi_ind = 1'b0;
	ctrl.sti_ind = 1'b0;
	ctrl.trap_ind = 1'b0;
	ctrl.addr1mux_sel = 1'b0;
	ctrl.addr2mux_sel = 1'b0;
	ctrl.offmux_sel = 3'b000;
	ctrl.data_sel = 2'b00;
	ctrl.nzp_sel = 1'b0;
	ctrl.br_ind = 1'b0;
	ctrl.jsr_ind = 1'b0;
	
	/* Control signal assignments based on opcode */
	
	case(ctrl.opcode)
		op_add: begin
			ctrl.loadcc_ex = 1'b1;
			ctrl.load_regfile = 1'b1;
			ctrl.data_sel = 2'b01;
			if (info[5])
				ctrl.src2mux_sel = 1'b1;
		end
		
		op_and: begin
			ctrl.aluop = alu_and;
			ctrl.loadcc_ex = 1'b1;
			ctrl.load_regfile = 1'b1;
			ctrl.data_sel = 2'b01;
			if (info[5])
				ctrl.src2mux_sel = 1'b1;
		end
	
		op_br: begin
			ctrl.offmux_sel = 3'b001;
			ctrl.addr1mux_sel = 1'b1;
			ctrl.addr2mux_sel = 1'b1;
			ctrl.br_ind = 1'b1;
		end
	
		op_jmp: begin
			ctrl.addr1mux_sel = 1'b0;
			ctrl.addr2mux_sel = 1'b0;
			ctrl.jsr_ind = 1'b1;
		end
	
		op_jsr: begin
			ctrl.load_regfile = 1'b1;
			ctrl.drmux_sel = 1'b1;
			ctrl.data_sel = 2'b11;
			ctrl.jsr_ind = 1'b1;
			if (info[6]) begin
				ctrl.offmux_sel = 3'b010;
				ctrl.addr1mux_sel = 1'b1;
				ctrl.addr2mux_sel = 1'b1;
				end
			else begin
				ctrl.addr1mux_sel = 1'b0;
				ctrl.addr2mux_sel = 1'b0;
				end
		end
	
		op_ldb: begin
			ctrl.load_regfile = 1'b1;
			ctrl.ldb_ind = 1'b1;
			ctrl.mem_read = 1'b1;
			ctrl.addr1mux_sel = 1'b1;
			ctrl.offmux_sel = 3'b011;
			ctrl.nzp_sel = 1'b1;
			ctrl.loadcc_mem = 1'b1;
		end
	
		op_ldi: begin
			ctrl.load_regfile = 1'b1;
			ctrl.mem_read = 1'b1;
			ctrl.addr1mux_sel = 1'b1;
			ctrl.offmux_sel = 3'b100;
			ctrl.nzp_sel = 1'b1;
			ctrl.loadcc_mem = 1'b1;
			ctrl.ldi_ind = 1'b1;
		end
	
		op_ldr: begin
			ctrl.load_regfile = 1'b1;	
			ctrl.mem_read = 1'b1;
			ctrl.addr1mux_sel = 1'b1;
			ctrl.offmux_sel = 3'b100;
			ctrl.nzp_sel = 1'b1;		
			ctrl.loadcc_mem = 1'b1;
		end
	
		op_lea: begin
			ctrl.load_regfile = 1'b1;
			ctrl.offmux_sel = 3'b001;
			ctrl.addr1mux_sel = 1'b1;
			ctrl.addr2mux_sel = 1'b1;
			ctrl.data_sel = 2'b10;
			ctrl.nzp_sel = 1'b1;
			ctrl.loadcc_ex = 1'b1;
		end
		
		op_not: begin
			ctrl.aluop = alu_not;
			ctrl.loadcc_ex = 1'b1;
			ctrl.load_regfile = 1'b1;
			ctrl.data_sel = 2'b01;
		end
		
		op_rti: begin
			case ({info[5:4], info[7]})
				3'b000: ctrl.aluop = alu_sub;
				3'b001: ctrl.aluop = alu_or;
				3'b010: ctrl.aluop = alu_xor;
				3'b011: ctrl.aluop = alu_mult;
				3'b100: ctrl.aluop = alu_div;
				default: /* not possible */ ;
			endcase
			ctrl.loadcc_ex = 1'b1;
			ctrl.load_regfile = 1'b1;
			ctrl.data_sel = 2'b01;
		end
		
		op_shf: begin
			ctrl.loadcc_ex = 1'b1;
			ctrl.load_regfile = 1'b1;
			ctrl.src2mux_sel = 1'b1;
			ctrl.offmux_sel = 3'b101;
			ctrl.data_sel = 2'b01;
			if (!info[4])
				ctrl.aluop = alu_sll;
			else
				if (!info[5])
					ctrl.aluop = alu_srl;
				else
					ctrl.aluop = alu_sra;
		end
		
		op_stb: begin
			ctrl.mem_write = 1'b1;
			ctrl.stb_ind = 1'b1;
			ctrl.sr2mux_sel = 1'b1;
			ctrl.offmux_sel = 3'b011;
			ctrl.addr1mux_sel = 1'b1;
			ctrl.aluop = alu_pass;
		end
		
		op_sti: begin
			ctrl.mem_read = 1'b1;
			ctrl.sr2mux_sel = 1'b1;
			ctrl.offmux_sel = 3'b100;
			ctrl.sti_ind = 1'b1;
			ctrl.addr1mux_sel = 1'b1;
			ctrl.aluop = alu_pass;
		end
	
		op_str: begin
			ctrl.mem_write = 1'b1;
			ctrl.sr2mux_sel = 1'b1;
			ctrl.offmux_sel = 3'b100;
			ctrl.addr1mux_sel = 1'b1;
			ctrl.aluop = alu_pass;
		end
		
		op_trap: begin
			ctrl.load_regfile = 1'b1;
			ctrl.drmux_sel = 1'b1;
			ctrl.data_sel = 2'b00;
			ctrl.offmux_sel = 3'b110;
			ctrl.trap_ind = 1'b1;
			ctrl.aluop = alu_pass;
			ctrl.src2mux_sel = 1'b1;
			ctrl.mem_read = 1'b1;
		end
		
		default: begin
		/* Unknown opcode, set control word to zero */
			ctrl = 0;
		end	
	
	endcase

end

endmodule : control_rom
