import lc3b_types::*;

module cpu_datapath
(
	/* CLOCK! */
	input clk,
	
	/* Inputs go here! */
	input logic mem_resp,
	input logic instr_mem_resp,
	input lc3b_word mem_rdata,
	input lc3b_word L1I_rdata,
	/* Outputs go here! */
	output lc3b_word mem_address,
	output lc3b_word instr_mem_address,
	output lc3b_word mem_wdata,
	output logic mem_write,
	output logic mem_read,
	output logic instr_mem_read,
	output lc3b_mem_wmask mem_byte_enable
);

/* Internal Signals */
lc3b_word 				pc_in;
lc3b_word 				pc_out;
lc3b_word 				pc_plus2_out;
lc3b_word				id_pc;
lc3b_word				instr_data;
lc3b_word				adj6_out;
lc3b_word				adj9_out;
lc3b_word				adj11_out;
lc3b_word				sext5_out;
lc3b_word				sext6_out;
lc3b_word				zext4_out;
lc3b_word				zext8_out;
lc3b_word				offset_mux_out;
lc3b_word				regfile_mux_out;
logic [2:0]				sr2mux_out;
lc3b_word				sr1_out;
lc3b_word				sr2_out;
logic 					br_pred;
lc3b_reg					dr_mux_out;
lc3b_word				ex_pc;
lc3b_control_word		ex_control;
lc3b_word				operand1;
lc3b_word				operand2;
lc3b_word				sext_value;
lc3b_reg					ex_dr;
lc3b_reg					ex_sr1;
lc3b_reg					ex_sr2;
logic 					ex_pred;
logic						ex_btb_hit;
lc3b_word				src2_mux_out;
lc3b_word				sr1_forward_mux_out;
lc3b_word				sr2_forward_mux_out;
lc3b_word				alu_out;
lc3b_word				addr1_mux_out;
lc3b_word				addr2_mux_out;
lc3b_word				br_adder_out;
lc3b_nzp					ex_nzp;
lc3b_word				adder_alu_mux_out;
lc3b_word				mem_pc;
lc3b_control_word		mem_control;
lc3b_word				mem_branch_addr;
logic						mem_branch_enable;
lc3b_nzp					internal_nzp;
lc3b_word				mem_alu;
lc3b_reg					mem_dr;
lc3b_reg					mem_sr1;
lc3b_reg					mem_sr2;
logic						mem_pred;
logic 					mem_btb_hit;
logic						indirect_counter_out;
logic						sti_counter_out;
logic						byte_sel;
lc3b_word				stb_selector_out;
lc3b_word				ldb_selector_out;
lc3b_nzp					mem_nzp;
lc3b_nzp					branch_enable_mux_out;
lc3b_word				wb_pc;
lc3b_control_word		wb_control;
lc3b_word				wb_branch_addr;
logic						wb_branch_enable;
lc3b_nzp					wb_nzp;
lc3b_word				wb_mem_data;
lc3b_word				wb_alu;
lc3b_reg					wb_dr;
lc3b_reg					wb_sr1;
lc3b_reg					wb_sr2;
logic 					wb_pred;
logic						wb_btb_hit;
lc3b_word				data_mux_out;
lc3b_control_word		control_rom_out;
lc3b_word				branch_pc_mux_out;
lc3b_control_word		interceptor_out;
logic						stall_enable;
lc3b_word				rdata_reg_out;
logic						id_load_enable;
logic						ex_load_enable;
logic						mem_load_enable;
logic						stage_reset;
lc3b_word				trap_mux_out;
logic[1:0]				forward_sel_A;
logic[1:0]				forward_sel_B;
logic						load_dependency_stall;
logic						load_dependency_reset;
lc3b_word				decode_sr1_out;
lc3b_word				decode_sr2_out;
logic						decode_sr1_sel;
logic						decode_sr2_sel;
logic[1:0]				addr2_forward_sel;
lc3b_word				addr2_forward_mux_out;
lc3b_word				forward_from_mem_mux_out;
logic						btb_sig;
lc3b_word				btb_dest;
logic						decode_reset;
logic 					btb_hit;
logic						wrong;
logic						wrong_out;
logic [1:0]				pc_mux_sel;
lc3b_word				mult_div_out;
lc3b_word				mult_div_mux_out;
logic						mult_div_stall;

/* Assignments */
assign instr_mem_address = pc_out;
assign mem_read = mem_control.mem_read & ~sti_counter_out;
assign mem_write = (mem_control.mem_write | sti_counter_out) & ~(wb_control.br_ind & mem_control.mem_write);
assign wrong = wrong_out & wb_btb_hit;

/* IF Stage */

register #(.width(16)) pc
(
	.clk(clk),
   .load(stall_enable & mult_div_stall),
   .in(pc_in),
   .out(pc_out)
);

plus2 #(.width(16)) pc_plus2
(
	.in(pc_out),
	.out(pc_plus2_out)
);

mux2 #(.width(16)) branch_pc_mux
(
	.sel((wb_control.br_ind && wrong_out) || (wb_pred & wrong)),
	.a(pc_plus2_out),
	.b(wb_pc),
	.f(branch_pc_mux_out)
);

pc_input_selector pc_sel_select
(
	.trap_ind(wb_control.trap_ind),
	.br_ind(wb_control.br_ind),
	.jsr_ind(wb_control.jsr_ind),
	.wb_btb_hit(wb_btb_hit),
	.wb_pred(wb_pred),
	.decode_btb_hit(btb_sig),
	.wb_branch_enable(wb_branch_enable),
	.wrong_in(wrong),
	.pc_mux_sel(pc_mux_sel)
);
	
mux4 pc_mux
(
	.sel(pc_mux_sel),
	.a(branch_pc_mux_out),
	.b(wb_branch_addr),
	.c(data_mux_out),
	.d(btb_dest),
	.out(pc_in)
);

IF_ID_Register IF_ID_Register
(
	.clk(clk),
	.load(stall_enable & id_load_enable & mult_div_stall),
	.reset(stage_reset | (stall_enable && decode_reset)),
	/* Data inputs */
	.pc(pc_plus2_out),
	.instr(L1I_rdata),
	/* Data outputs */
	.pc_data(id_pc),
	.instr_data(instr_data)
);

instr_read_stall read_stall
(
	.clk(clk),
	.mem_resp(instr_mem_resp),
	.reset(stage_reset || decode_reset),
	.opcode(L1I_rdata[15:12]),
	.nzp(L1I_rdata[11:9]),
	.read(instr_mem_read)
);

/* End of IF Stage */

/* ID Stage */

/*	BTB */
btb_datapath btb
(
	.clk(clk),
	.pc_address((id_pc - 4'h2)),
	.wb_pred_addr(wb_branch_addr),
	.opcode(interceptor_out.br_ind),
	.wb_sel(wb_control.br_ind & stall_enable),
	.wb_pc(wb_pc),
	.wb_btb_hit(wb_btb_hit),
	.branch_enable(wb_branch_enable),
	.btb_sig(btb_sig),
	.btb_dest(btb_dest),
	.pred_to_datapath(br_pred),
	.decode_reset(decode_reset),
	.hit(btb_hit)
);

adj #(.width(6)) adj6
(
	.in(instr_data[5:0]),
	.out(adj6_out)
);

adj #(.width(9)) adj9
(
	.in(instr_data[8:0]),
	.out(adj9_out)
);

adj #(.width(11)) adj11
(
	.in(instr_data[10:0]),
	.out(adj11_out)
);

sext #(.width(5)) sext5
(
	.in(instr_data[4:0]),
	.out(sext5_out)
);

sext #(.width(6)) sext6
(
	.in(instr_data[5:0]),
	.out(sext6_out)
);

zext #(.width(4)) zext4
(
	.in(instr_data[3:0]),
	.out(zext4_out)
);

zext #(.width(8)) zext8
(
	.in(instr_data[7:0]),
	.out(zext8_out)
);

mux8 offset_mux
(
	.sel(control_rom_out.offmux_sel),
	.a(sext5_out),
	.b(adj9_out),
	.c(adj11_out),
	.d(sext6_out),
	.e(adj6_out),
	.f(zext4_out),
	.g(zext8_out << 1),
	.h(),
	.out(offset_mux_out)
);

mux2 #(.width(3)) sr2_mux
(
	.sel(control_rom_out.sr2mux_sel),
	.a(instr_data[2:0]),
	.b(instr_data[11:9]),
	.f(sr2mux_out)
);

mux2 #(.width(3)) dr_mux
(
	.sel(control_rom_out.drmux_sel),
	.a(instr_data[11:9]),
	.b(3'b111),
	.f(dr_mux_out)
);

mux2 #(.width(16)) trap_store_pc
(
	.sel(wb_control.trap_ind),
	.a(data_mux_out),
	.b(wb_pc),
	.f(trap_mux_out)
);

regfile regfile
(
	.clk(clk),
	.load(wb_control.load_regfile),
	.in(trap_mux_out),
   .src_a(instr_data[8:6]),
	.src_b(sr2mux_out), 
	.dest(wb_dr),
   .reg_a(sr1_out),
	.reg_b(sr2_out)
);

mux2 #(.width(16)) decode_forward_sr1
(
	.sel(decode_sr1_sel),
	.a(sr1_out),
	.b(data_mux_out),
	.f(decode_sr1_out)
);

mux2 #(.width(16)) decode_forward_sr2
(
	.sel(decode_sr2_sel),
	.a(sr2_out),
	.b(data_mux_out),
	.f(decode_sr2_out)
);

control_rom control_rom
(
	.info({instr_data[3],instr_data[11],instr_data[5:4],instr_data[15:12]}),
	.ctrl(control_rom_out)
);

branch_intercept branch_int
(
	.control_in(control_rom_out),
	.nzp(instr_data[11:9]),
	.control_out(interceptor_out)
);

branch_stall_logic id_branch_stall
(
	.control_in(interceptor_out),
	.btb_hit(btb_hit),
	.enable(id_load_enable)
);

ID_EX_Register ID_EX_Register
(
	.clk(clk),
	.load(stall_enable & ex_load_enable & mult_div_stall),
	.reset(stage_reset),
	/* Data inputs */
	.control(interceptor_out),
	.pc(id_pc),
	.sr1_out(decode_sr1_out),
	.sr2_out(decode_sr2_out),
	.sext_value(offset_mux_out),
	.dr(dr_mux_out),
	.sr1(instr_data[8:6]),
	.sr2(sr2mux_out),
	.pred(br_pred),
	.btb_hit(btb_hit),
	/* Data outputs */
	.pc_data(ex_pc),
	.control_data(ex_control),
	.sr1_out_data(operand1),
	.sr2_out_data(operand2),
	.sext_value_data(sext_value),
	.dr_data(ex_dr),
	.sr1_data(ex_sr1),
	.sr2_data(ex_sr2),
	.pred_data(ex_pred),
	.btb_hit_data(ex_btb_hit)
);

/* End of ID Stage */

/* EX Stage */

mux2 #(.width(16)) src2_mux
(
	.sel(ex_control.src2mux_sel),
	.a(operand2),
	.b(sext_value),
	.f(src2_mux_out)
);

/* This is Ryan's edit for the issue we were having on 4/4.
	The issue was that we were not forwarding data dependencies for
	ldr, ldi, or ldb */
mux2 forward_from_mem_mux
(
	.sel(mem_control.opcode == op_lea),
	.a(ldb_selector_out), //ldr, ldb, ldi
	.b(mem_branch_addr), //lea
	.f(forward_from_mem_mux_out)
);

mux4 sr1_forward_mux
(
	.sel(forward_sel_A),
	.a(operand1),
	.b(mem_alu),
	.c(data_mux_out),
	.d(forward_from_mem_mux_out),
	.out(sr1_forward_mux_out)
);

/* Ryan also made changes here. All the cases where 2'b11 would be the select
	signals have been changed */
mux4 sr2_forward_mux
(
	.sel(forward_sel_B),
	.a(src2_mux_out),
	.b(mem_alu),
	.c(data_mux_out),
	.d(forward_from_mem_mux_out),
	.out(sr2_forward_mux_out)
);

alu alu
(
	.aluop(ex_control.aluop),
   .a(sr1_forward_mux_out),
	.b(sr2_forward_mux_out),
   .f(alu_out)
);

mux2 #(.width(16)) addr1_mux
(
	.sel(ex_control.addr1mux_sel),
	.a(16'b0),
	.b(sext_value),
	.f(addr1_mux_out)
);

mux2 #(.width(16)) addr2_mux
(
	.sel(ex_control.addr2mux_sel),
	.a(operand1),
	.b(ex_pc),
	.f(addr2_mux_out)
);

mux4 addr2_forward_mux
(
	.sel(addr2_forward_sel),
	.a(addr2_mux_out),
	.b(mem_alu),
	.c(data_mux_out),
	.d(forward_from_mem_mux_out),
	.out(addr2_forward_mux_out)
);

adder #(.width(16)) br_adder
(
	.a(addr1_mux_out),
	.b(addr2_forward_mux_out),
	.result(br_adder_out)
);

mux2 #(.width(16)) adder_alu_mux
(
	.sel(ex_control.nzp_sel),
	.a(alu_out),
	.b(br_adder_out),
	.f(adder_alu_mux_out)
);

gencc ex_gencc
(
	.in(adder_alu_mux_out),
	.out(ex_nzp)
);

/* Add forwarding unit here */
forwarding_logic forward_logic_unit
(
	.ex_control(ex_control),
	.mem_control(mem_control),
	.wb_control(wb_control),
	.mem_dest(mem_dr),
	.wb_dest(wb_dr),
	.ex_src_A(ex_sr1),
	.ex_src_B(ex_sr2),
	.decode_src_A(instr_data[8:6]),
	.decode_src_B(sr2mux_out),
	.sel_A(forward_sel_A),
	.sel_B(forward_sel_B),
	.decode_A(decode_sr1_sel),
	.decode_B(decode_sr2_sel),
	.addr2_sel(addr2_forward_sel)
);

branch_stall_logic ex_branch_stall
(
	.control_in(ex_control),
	.btb_hit(ex_btb_hit),
	.enable(ex_load_enable)
);

/* LC-3X Hardware */
mult_div_alu mult_div_unit
(
	.clk(clk),
	.multi_en((ex_control.aluop == alu_mult)),
	.div_en((ex_control.aluop == alu_div)),
	.a(sr1_forward_mux_out),
	.b(sr2_forward_mux_out),
	.result(mult_div_out)
);

mux2 #(.width(16)) mult_div_mux
(
	.sel((ex_control.aluop == alu_div) || (ex_control.aluop == alu_mult)),
	.a(alu_out),
	.b(mult_div_out),
	.f(mult_div_mux_out)
);

mult_div_stall mult_div_stall_unit
(
	.clk(clk),
	.load((ex_control.aluop == alu_div) || (ex_control.aluop == alu_mult)),
	.stalled(stall_enable),
	.enable(mult_div_stall)
);

EX_MEM_Register EX_MEM_Register
(	
	.clk(clk),
	.load(stall_enable & mem_load_enable & mult_div_stall),
	.load_cc(ex_control.loadcc_ex),
	.reset(stage_reset ),
	/* Data inputs */
	.control(ex_control),
	.pc(ex_pc),
	.branch_addr(br_adder_out),
	.nzp(ex_nzp),
	.alu(mult_div_mux_out),
	.dr(ex_dr),
	.sr1(ex_sr1),
	.sr2(ex_sr2),
	.pred(ex_pred),
	.btb_hit(ex_btb_hit),
	/* Data outputs */
	.pc_data(mem_pc),
	.control_data(mem_control),
	.branch_addr_data(mem_branch_addr),
	.nzp_data(internal_nzp),
	.alu_data(mem_alu),
	.dr_data(mem_dr),
	.sr1_data(mem_sr1),
	.sr2_data(mem_sr2),
	.pred_data(mem_pred),
	.btb_hit_data(mem_btb_hit)
);

/* End of EX Stage */

/* Start of Mem Stage */

mux4 address_mux
(
	.sel({mem_control.trap_ind,indirect_counter_out}),
	.a(mem_branch_addr),
	.b(rdata_reg_out),
	.c(mem_alu),
	.d(mem_alu),
	.out(mem_address)
);

register #(.width(16)) rdata_reg
(
	.clk(clk),
	.load(mem_resp),
	.in(mem_rdata),
	.out(rdata_reg_out)
);

counter indirect_counter
(
	.clk(clk),
	.load((mem_control.sti_ind | mem_control.ldi_ind) & mem_resp),
	.out(indirect_counter_out)
);

counter sti_counter
(
	.clk(clk),
	.load(mem_control.sti_ind & mem_resp),
	.out(sti_counter_out)
);

stall_logic stall_logic
(
	.clk(clk),
	.mem_control(mem_control),
	.count_in(indirect_counter_out),
	.instr_resp(instr_mem_resp),
	.mem_resp(mem_resp),
	.instr_mem_read(instr_mem_read),
	.indirect_load(mem_resp),
	.mem_write(mem_write),
	.enable(stall_enable)
);

byte_select_logic byte_select_logic
(
	.low_addr_bit(mem_address[0]),
	.stb_ind(mem_control.stb_ind),
	.ldb_ind(mem_control.ldb_ind),
	.mem_byte_enable(mem_byte_enable),
	.byte_sel(byte_sel)
);

stb_selector stb_selector
(
	.in(mem_alu),
	.sel(byte_sel),
	.out(mem_wdata)
);

ldb_selector #(.width(16)) ldb_selector
(
	.in(mem_rdata),
	.sel({mem_control.ldb_ind,byte_sel}),
	.out(ldb_selector_out)
);

gencc mem_gencc
(
	.in(ldb_selector_out),
	.out(mem_nzp)
);

mux2 #(.width(3)) branch_enable_mux
(
	.sel(mem_control.mem_read),
	.a(internal_nzp),
	.b(mem_nzp),
	.f(branch_enable_mux_out)
);

branch_stall_logic mem_branch_stall
(
	.control_in(mem_control),
	.btb_hit(mem_btb_hit),
	.enable(mem_load_enable)
);

MEM_WB_Register MEM_WB_Register
(
	.clk(clk),
	.load(stall_enable & mult_div_stall),
	.load_cc(mem_control.loadcc_mem | mem_control.loadcc_ex),
	.reset(wb_control.br_ind & mem_control.mem_write),
	/* Data inputs */
	.control(mem_control),
	.pc(mem_pc),
	.branch_addr(mem_branch_addr),
	.branch_enable(branch_enable_mux_out),
	.mem_data(ldb_selector_out),
	.alu(mem_alu),
	.dr(mem_dr),
	.sr1(mem_sr1),
	.sr2(mem_sr2),
	.pred(mem_pred),
	.btb_hit(mem_btb_hit),
	/* Data outputs */
	.pc_data(wb_pc),
	.control_data(wb_control),
	.branch_addr_data(wb_branch_addr),
	.branch_enable_data(wb_nzp),
	.mem_data_data(wb_mem_data),
	.alu_data(wb_alu),
	.dr_data(wb_dr),
	.sr1_data(wb_sr1),
	.sr2_data(wb_sr2),
	.pred_data(wb_pred),
	.btb_hit_data(wb_btb_hit)
);

/* End of Mem Stage */

/* Beginning of WB Stage */

nzp_comparator nzp_comparator
(
	.a(wb_dr),
	.b(wb_nzp),
	.z(wb_branch_enable)
);

mux4 data_mux
(
	.sel(wb_control.data_sel),
	.a(wb_mem_data),
	.b(wb_alu),
	.c(wb_branch_addr),
	.d(wb_pc),
	.out(data_mux_out)
);

stage_reset_logic stage_reset_module
(
	.control_in(wb_control),
	.btb_hit(wb_btb_hit),
	.pred(wb_pred),
	.branch_enable(wb_branch_enable),
	.reset(stage_reset)
);

stage_reset_logic wrong_module
(
	.control_in(wb_control),
	.btb_hit(wb_btb_hit),
	.pred(wb_pred),
	.branch_enable(wb_branch_enable),
	.reset(wrong_out)
);

/* End of WB Stage */

endmodule : cpu_datapath
