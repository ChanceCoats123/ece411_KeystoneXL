package lc3b_types;

typedef logic [15:0] lc3b_word;
typedef logic [127:0] lc3b_chunk;
typedef logic [255:0] lc3b_full_chunk;
typedef logic  [7:0] lc3b_byte;

typedef logic  [8:0] lc3b_offset9;
typedef logic  [5:0] lc3b_offset6;
typedef logic  [4:0] lc3b_imm5;
typedef logic  [3:0] lc3b_imm4;
typedef logic  [10:0] lc3b_offset11;
typedef logic  [7:0] lc3b_trapvect8;
typedef logic  [8:0] lc3b_tag;

typedef logic  [2:0] lc3b_reg;
typedef logic  [2:0] lc3b_nzp;
typedef logic  [1:0] lc3b_mem_wmask;
typedef logic 	[1:0] lc3b_mux2sel;
typedef logic  [2:0] lc3b_c_index;
typedef logic  [2:0] lc3b_mux8sel;
typedef logic  [7:0] lc3b_ctrl_in;
typedef logic	[2:0] lc3b_offset;
typedef logic	[2:0] lc3b_set;

typedef enum bit [3:0] {
    op_add  = 4'b0001,
    op_and  = 4'b0101,
    op_br   = 4'b0000,
    op_jmp  = 4'b1100,   /* also RET */
    op_jsr  = 4'b0100,   /* also JSRR */
    op_ldb  = 4'b0010,
    op_ldi  = 4'b1010,
    op_ldr  = 4'b0110,
    op_lea  = 4'b1110,
    op_not  = 4'b1001,
    op_rti  = 4'b1000,
    op_shf  = 4'b1101,
    op_stb  = 4'b0011,
    op_sti  = 4'b1011,
    op_str  = 4'b0111,
    op_trap = 4'b1111
} lc3b_opcode;

typedef enum bit [3:0] {
    alu_add,
    alu_and,
    alu_not,
    alu_pass,
    alu_sll,
    alu_srl,
    alu_sra,
	 alu_or,
	 alu_xor,
	 alu_sub,
	 alu_mult,
	 alu_div
} lc3b_aluop;

/* control word struct definition */

typedef struct packed {

	logic [3:0] opcode;
	lc3b_aluop aluop;
	logic loadcc_mem;
	logic loadcc_ex;
	logic load_regfile;
	logic stb_ind;
	logic ldb_ind;
	logic mem_read;
	logic mem_write;
	lc3b_mem_wmask mem_byte_enable;
	logic src2mux_sel;
	logic drmux_sel;
	logic sr2mux_sel;
	logic ldi_ind;
	logic sti_ind;
	logic trap_ind;
	logic addr1mux_sel;
	logic addr2mux_sel;
	lc3b_mux8sel offmux_sel;
	lc3b_mux2sel data_sel;
	logic nzp_sel;
	logic br_ind;
	logic jsr_ind;
	
} lc3b_control_word;

endpackage : lc3b_types