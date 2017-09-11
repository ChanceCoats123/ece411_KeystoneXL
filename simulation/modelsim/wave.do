onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clk -radix hexadecimal /testbench/clk
add wave -noupdate -label pc -radix hexadecimal /testbench/DUT/datapath/pc/out
add wave -noupdate -label pcmux_out -radix hexadecimal /testbench/DUT/datapath/pc_mux/out
add wave -noupdate -label L1I_address -radix hexadecimal /testbench/DUT/L1I/mem_address
add wave -noupdate -label L1I_rdata -radix hexadecimal /testbench/DUT/L1I/mem_rdata
add wave -noupdate -label L1I_from_arbiter -radix hexadecimal /testbench/DUT/L1I/pmem_rdata
add wave -noupdate -label way0_wr_enable /testbench/DUT/L1I/cache_datapath/selectlogic/way0_wr_enable
add wave -noupdate -label way1_wr_enable /testbench/DUT/L1I/cache_datapath/selectlogic/way1_wr_enable
add wave -noupdate -label L1I_read -radix hexadecimal /testbench/DUT/L1I/mem_read
add wave -noupdate -label L1I_resp -radix hexadecimal /testbench/DUT/L1I/mem_resp
add wave -noupdate -label L1D_address -radix hexadecimal /testbench/DUT/L1D/mem_address
add wave -noupdate -label L1D_read -radix hexadecimal /testbench/DUT/L1D/mem_read
add wave -noupdate -label L1D_rdata -radix hexadecimal /testbench/DUT/L1D/mem_rdata
add wave -noupdate -label L1D_resp -radix hexadecimal /testbench/DUT/L1D/mem_resp
add wave -noupdate -label L1D_wdata -radix hexadecimal /testbench/DUT/L1D/mem_wdata
add wave -noupdate -label L1D_write -radix hexadecimal /testbench/DUT/L1D/mem_write
add wave -noupdate -label L1D_byte_enable -radix hexadecimal /testbench/DUT/L1D/mem_byte_enable
add wave -noupdate -label regfile -radix hexadecimal -childformat {{{/testbench/DUT/datapath/regfile/data[7]} -radix hexadecimal} {{/testbench/DUT/datapath/regfile/data[6]} -radix hexadecimal} {{/testbench/DUT/datapath/regfile/data[5]} -radix hexadecimal} {{/testbench/DUT/datapath/regfile/data[4]} -radix hexadecimal} {{/testbench/DUT/datapath/regfile/data[3]} -radix hexadecimal} {{/testbench/DUT/datapath/regfile/data[2]} -radix hexadecimal} {{/testbench/DUT/datapath/regfile/data[1]} -radix hexadecimal} {{/testbench/DUT/datapath/regfile/data[0]} -radix hexadecimal}} -expand -subitemconfig {{/testbench/DUT/datapath/regfile/data[7]} {-height 16 -radix hexadecimal} {/testbench/DUT/datapath/regfile/data[6]} {-height 16 -radix hexadecimal} {/testbench/DUT/datapath/regfile/data[5]} {-height 16 -radix hexadecimal} {/testbench/DUT/datapath/regfile/data[4]} {-height 16 -radix hexadecimal} {/testbench/DUT/datapath/regfile/data[3]} {-height 16 -radix hexadecimal} {/testbench/DUT/datapath/regfile/data[2]} {-height 16 -radix hexadecimal} {/testbench/DUT/datapath/regfile/data[1]} {-height 16 -radix hexadecimal} {/testbench/DUT/datapath/regfile/data[0]} {-height 16 -radix hexadecimal}} /testbench/DUT/datapath/regfile/data
add wave -noupdate -label wb_hit /testbench/DUT/datapath/btb/wb_hit
add wave -noupdate -label btb_tag_way0 -radix hexadecimal /testbench/DUT/datapath/btb/tag_way0/data
add wave -noupdate -label btb_data_way0 -radix hexadecimal /testbench/DUT/datapath/btb/data_way0/data
add wave -noupdate -label brpred_way0 -radix hexadecimal /testbench/DUT/datapath/btb/brpred_way0/data
add wave -noupdate -label btb_tag_way1 -radix hexadecimal /testbench/DUT/datapath/btb/tag_way1/data
add wave -noupdate -label btb_data_way1 -radix hexadecimal /testbench/DUT/datapath/btb/data_way1/data
add wave -noupdate -label brpred_way1 -radix hexadecimal /testbench/DUT/datapath/btb/brpred_way1/data
add wave -noupdate -label btb_tag_way2 -radix hexadecimal /testbench/DUT/datapath/btb/tag_way2/data
add wave -noupdate -label btb_data_way2 -radix hexadecimal /testbench/DUT/datapath/btb/data_way2/data
add wave -noupdate -label brpred_way2 -radix hexadecimal /testbench/DUT/datapath/btb/brpred_way2/data
add wave -noupdate -label btb_tag_way3 -radix hexadecimal /testbench/DUT/datapath/btb/tag_way3/data
add wave -noupdate -label btb_data_way3 -radix hexadecimal /testbench/DUT/datapath/btb/data_way3/data
add wave -noupdate -label brpred_way3 -radix hexadecimal /testbench/DUT/datapath/btb/brpred_way3/data
add wave -noupdate -label L1I_State /testbench/DUT/L1I/cache_control/state
add wave -noupdate -label L1D_State /testbench/DUT/L1D/cache_control/state
add wave -noupdate -label Arbiter_state /testbench/DUT/arbitron/control/state
add wave -noupdate -label L2_state /testbench/DUT/L2/cache_control/state
add wave -noupdate -label VC_State /testbench/DUT/VC/victim_cache_controller/state
add wave -noupdate -label L1I_data0_array -radix hexadecimal -childformat {{{/testbench/DUT/L1I/cache_datapath/data0/data[7]} -radix hexadecimal} {{/testbench/DUT/L1I/cache_datapath/data0/data[6]} -radix hexadecimal} {{/testbench/DUT/L1I/cache_datapath/data0/data[5]} -radix hexadecimal} {{/testbench/DUT/L1I/cache_datapath/data0/data[4]} -radix hexadecimal} {{/testbench/DUT/L1I/cache_datapath/data0/data[3]} -radix hexadecimal} {{/testbench/DUT/L1I/cache_datapath/data0/data[2]} -radix hexadecimal} {{/testbench/DUT/L1I/cache_datapath/data0/data[1]} -radix hexadecimal} {{/testbench/DUT/L1I/cache_datapath/data0/data[0]} -radix hexadecimal}} -subitemconfig {{/testbench/DUT/L1I/cache_datapath/data0/data[7]} {-height 16 -radix hexadecimal} {/testbench/DUT/L1I/cache_datapath/data0/data[6]} {-height 16 -radix hexadecimal} {/testbench/DUT/L1I/cache_datapath/data0/data[5]} {-height 16 -radix hexadecimal} {/testbench/DUT/L1I/cache_datapath/data0/data[4]} {-height 16 -radix hexadecimal} {/testbench/DUT/L1I/cache_datapath/data0/data[3]} {-height 16 -radix hexadecimal} {/testbench/DUT/L1I/cache_datapath/data0/data[2]} {-height 16 -radix hexadecimal} {/testbench/DUT/L1I/cache_datapath/data0/data[1]} {-height 16 -radix hexadecimal} {/testbench/DUT/L1I/cache_datapath/data0/data[0]} {-height 16 -radix hexadecimal}} /testbench/DUT/L1I/cache_datapath/data0/data
add wave -noupdate -label L1I_data1_array -radix hexadecimal -childformat {{{/testbench/DUT/L1I/cache_datapath/data1/data[7]} -radix hexadecimal} {{/testbench/DUT/L1I/cache_datapath/data1/data[6]} -radix hexadecimal} {{/testbench/DUT/L1I/cache_datapath/data1/data[5]} -radix hexadecimal} {{/testbench/DUT/L1I/cache_datapath/data1/data[4]} -radix hexadecimal} {{/testbench/DUT/L1I/cache_datapath/data1/data[3]} -radix hexadecimal} {{/testbench/DUT/L1I/cache_datapath/data1/data[2]} -radix hexadecimal} {{/testbench/DUT/L1I/cache_datapath/data1/data[1]} -radix hexadecimal} {{/testbench/DUT/L1I/cache_datapath/data1/data[0]} -radix hexadecimal}} -subitemconfig {{/testbench/DUT/L1I/cache_datapath/data1/data[7]} {-height 16 -radix hexadecimal} {/testbench/DUT/L1I/cache_datapath/data1/data[6]} {-height 16 -radix hexadecimal} {/testbench/DUT/L1I/cache_datapath/data1/data[5]} {-height 16 -radix hexadecimal} {/testbench/DUT/L1I/cache_datapath/data1/data[4]} {-height 16 -radix hexadecimal} {/testbench/DUT/L1I/cache_datapath/data1/data[3]} {-height 16 -radix hexadecimal} {/testbench/DUT/L1I/cache_datapath/data1/data[2]} {-height 16 -radix hexadecimal} {/testbench/DUT/L1I/cache_datapath/data1/data[1]} {-height 16 -radix hexadecimal} {/testbench/DUT/L1I/cache_datapath/data1/data[0]} {-height 16 -radix hexadecimal}} /testbench/DUT/L1I/cache_datapath/data1/data
add wave -noupdate -label L1D_data0_array -radix hexadecimal -childformat {{{/testbench/DUT/L1D/cache_datapath/data0/data[7]} -radix hexadecimal} {{/testbench/DUT/L1D/cache_datapath/data0/data[6]} -radix hexadecimal} {{/testbench/DUT/L1D/cache_datapath/data0/data[5]} -radix hexadecimal} {{/testbench/DUT/L1D/cache_datapath/data0/data[4]} -radix hexadecimal} {{/testbench/DUT/L1D/cache_datapath/data0/data[3]} -radix hexadecimal} {{/testbench/DUT/L1D/cache_datapath/data0/data[2]} -radix hexadecimal} {{/testbench/DUT/L1D/cache_datapath/data0/data[1]} -radix hexadecimal} {{/testbench/DUT/L1D/cache_datapath/data0/data[0]} -radix hexadecimal}} -subitemconfig {{/testbench/DUT/L1D/cache_datapath/data0/data[7]} {-height 16 -radix hexadecimal} {/testbench/DUT/L1D/cache_datapath/data0/data[6]} {-height 16 -radix hexadecimal} {/testbench/DUT/L1D/cache_datapath/data0/data[5]} {-height 16 -radix hexadecimal} {/testbench/DUT/L1D/cache_datapath/data0/data[4]} {-height 16 -radix hexadecimal} {/testbench/DUT/L1D/cache_datapath/data0/data[3]} {-height 16 -radix hexadecimal} {/testbench/DUT/L1D/cache_datapath/data0/data[2]} {-height 16 -radix hexadecimal} {/testbench/DUT/L1D/cache_datapath/data0/data[1]} {-height 16 -radix hexadecimal} {/testbench/DUT/L1D/cache_datapath/data0/data[0]} {-height 16 -radix hexadecimal}} /testbench/DUT/L1D/cache_datapath/data0/data
add wave -noupdate -label L1D_data1_array -radix hexadecimal -childformat {{{/testbench/DUT/L1D/cache_datapath/data1/data[7]} -radix hexadecimal} {{/testbench/DUT/L1D/cache_datapath/data1/data[6]} -radix hexadecimal} {{/testbench/DUT/L1D/cache_datapath/data1/data[5]} -radix hexadecimal} {{/testbench/DUT/L1D/cache_datapath/data1/data[4]} -radix hexadecimal} {{/testbench/DUT/L1D/cache_datapath/data1/data[3]} -radix hexadecimal} {{/testbench/DUT/L1D/cache_datapath/data1/data[2]} -radix hexadecimal} {{/testbench/DUT/L1D/cache_datapath/data1/data[1]} -radix hexadecimal} {{/testbench/DUT/L1D/cache_datapath/data1/data[0]} -radix hexadecimal}} -subitemconfig {{/testbench/DUT/L1D/cache_datapath/data1/data[7]} {-height 16 -radix hexadecimal} {/testbench/DUT/L1D/cache_datapath/data1/data[6]} {-height 16 -radix hexadecimal} {/testbench/DUT/L1D/cache_datapath/data1/data[5]} {-height 16 -radix hexadecimal} {/testbench/DUT/L1D/cache_datapath/data1/data[4]} {-height 16 -radix hexadecimal} {/testbench/DUT/L1D/cache_datapath/data1/data[3]} {-height 16 -radix hexadecimal} {/testbench/DUT/L1D/cache_datapath/data1/data[2]} {-height 16 -radix hexadecimal} {/testbench/DUT/L1D/cache_datapath/data1/data[1]} {-height 16 -radix hexadecimal} {/testbench/DUT/L1D/cache_datapath/data1/data[0]} {-height 16 -radix hexadecimal}} /testbench/DUT/L1D/cache_datapath/data1/data
add wave -noupdate -label L2_address -radix hexadecimal /testbench/DUT/L2/mem_address
add wave -noupdate -label L2_rdata -radix hexadecimal /testbench/DUT/L2/mem_rdata
add wave -noupdate -label L2_LRU_array -radix binary /testbench/DUT/L2/l2_cache_datapath/LRU_array/data
add wave -noupdate -label L2_data0_array -childformat {{{/testbench/DUT/L2/l2_cache_datapath/data0/data[3]} -radix hexadecimal} {{/testbench/DUT/L2/l2_cache_datapath/data0/data[2]} -radix hexadecimal} {{/testbench/DUT/L2/l2_cache_datapath/data0/data[1]} -radix hexadecimal} {{/testbench/DUT/L2/l2_cache_datapath/data0/data[0]} -radix hexadecimal}} -subitemconfig {{/testbench/DUT/L2/l2_cache_datapath/data0/data[3]} {-height 16 -radix hexadecimal} {/testbench/DUT/L2/l2_cache_datapath/data0/data[2]} {-height 16 -radix hexadecimal} {/testbench/DUT/L2/l2_cache_datapath/data0/data[1]} {-height 16 -radix hexadecimal} {/testbench/DUT/L2/l2_cache_datapath/data0/data[0]} {-height 16 -radix hexadecimal}} /testbench/DUT/L2/l2_cache_datapath/data0/data
add wave -noupdate -label {l2 tag0 data} /testbench/DUT/L2/l2_cache_datapath/tag0_array/data
add wave -noupdate -label L2_data1_array -radix hexadecimal -childformat {{{/testbench/DUT/L2/l2_cache_datapath/data1/data[3]} -radix hexadecimal} {{/testbench/DUT/L2/l2_cache_datapath/data1/data[2]} -radix hexadecimal} {{/testbench/DUT/L2/l2_cache_datapath/data1/data[1]} -radix hexadecimal} {{/testbench/DUT/L2/l2_cache_datapath/data1/data[0]} -radix hexadecimal}} -subitemconfig {{/testbench/DUT/L2/l2_cache_datapath/data1/data[3]} {-height 16 -radix hexadecimal} {/testbench/DUT/L2/l2_cache_datapath/data1/data[2]} {-height 16 -radix hexadecimal} {/testbench/DUT/L2/l2_cache_datapath/data1/data[1]} {-height 16 -radix hexadecimal} {/testbench/DUT/L2/l2_cache_datapath/data1/data[0]} {-height 16 -radix hexadecimal}} /testbench/DUT/L2/l2_cache_datapath/data1/data
add wave -noupdate -label {l2 tag1 data} /testbench/DUT/L2/l2_cache_datapath/tag1_array/data
add wave -noupdate -label L2_data2_array -radix hexadecimal -childformat {{{/testbench/DUT/L2/l2_cache_datapath/data2/data[3]} -radix hexadecimal} {{/testbench/DUT/L2/l2_cache_datapath/data2/data[2]} -radix hexadecimal} {{/testbench/DUT/L2/l2_cache_datapath/data2/data[1]} -radix hexadecimal} {{/testbench/DUT/L2/l2_cache_datapath/data2/data[0]} -radix hexadecimal}} -subitemconfig {{/testbench/DUT/L2/l2_cache_datapath/data2/data[3]} {-height 16 -radix hexadecimal} {/testbench/DUT/L2/l2_cache_datapath/data2/data[2]} {-height 16 -radix hexadecimal} {/testbench/DUT/L2/l2_cache_datapath/data2/data[1]} {-height 16 -radix hexadecimal} {/testbench/DUT/L2/l2_cache_datapath/data2/data[0]} {-height 16 -radix hexadecimal}} /testbench/DUT/L2/l2_cache_datapath/data2/data
add wave -noupdate -label {l2 tag2 data} /testbench/DUT/L2/l2_cache_datapath/tag2_array/data
add wave -noupdate -label L2_data3_array -radix hexadecimal -childformat {{{/testbench/DUT/L2/l2_cache_datapath/data3/data[3]} -radix hexadecimal} {{/testbench/DUT/L2/l2_cache_datapath/data3/data[2]} -radix hexadecimal} {{/testbench/DUT/L2/l2_cache_datapath/data3/data[1]} -radix hexadecimal} {{/testbench/DUT/L2/l2_cache_datapath/data3/data[0]} -radix hexadecimal}} -subitemconfig {{/testbench/DUT/L2/l2_cache_datapath/data3/data[3]} {-height 16 -radix hexadecimal} {/testbench/DUT/L2/l2_cache_datapath/data3/data[2]} {-height 16 -radix hexadecimal} {/testbench/DUT/L2/l2_cache_datapath/data3/data[1]} {-height 16 -radix hexadecimal} {/testbench/DUT/L2/l2_cache_datapath/data3/data[0]} {-height 16 -radix hexadecimal}} /testbench/DUT/L2/l2_cache_datapath/data3/data
add wave -noupdate -label {l2 tag3 data} /testbench/DUT/L2/l2_cache_datapath/tag3_array/data
add wave -noupdate -label {l2 valid0 data} -radix hexadecimal /testbench/DUT/L2/l2_cache_datapath/valid0_array/data
add wave -noupdate -label {l2 valid1 data} -radix hexadecimal /testbench/DUT/L2/l2_cache_datapath/valid1_array/data
add wave -noupdate -label {l2 valid2 data} -radix hexadecimal /testbench/DUT/L2/l2_cache_datapath/valid2_array/data
add wave -noupdate -label {l2 valid3 data} -radix hexadecimal /testbench/DUT/L2/l2_cache_datapath/valid3_array/data
add wave -noupdate -label {l2 LRU data} -radix hexadecimal /testbench/DUT/L2/l2_cache_datapath/LRU_array/data
add wave -noupdate -label stage_reset /testbench/DUT/datapath/stage_reset_module/reset
add wave -noupdate -label ID_Opcode -radix hexadecimal /testbench/DUT/datapath/IF_ID_Register/instr_data
add wave -noupdate -label {EX Opcode} -radix hexadecimal /testbench/DUT/datapath/ID_EX_Register/control_data.opcode
add wave -noupdate -label {MEM Opcode} -radix hexadecimal /testbench/DUT/datapath/EX_MEM_Register/control_data.opcode
add wave -noupdate -label {WB Opcode} -radix hexadecimal /testbench/DUT/datapath/MEM_WB_Register/control_data.opcode
add wave -noupdate -label stall_enable /testbench/DUT/datapath/stall_logic/ready
add wave -noupdate -label id_br_stall /testbench/DUT/datapath/id_branch_stall/enable
add wave -noupdate -label ex_br_stall /testbench/DUT/datapath/ex_branch_stall/enable
add wave -noupdate -label mem_br_stall /testbench/DUT/datapath/mem_branch_stall/enable
add wave -noupdate -label L2_to_VC_read -radix hexadecimal /testbench/DUT/L2/cache_control/pmem_read
add wave -noupdate -label L2_to_VC_write -radix hexadecimal /testbench/DUT/L2/cache_control/pmem_write
add wave -noupdate -label pmem_resp -radix hexadecimal /testbench/pmem/resp
add wave -noupdate -label controller_resp -radix hexadecimal /testbench/DUT/VC/controller_resp
add wave -noupdate -label VC_data -radix hexadecimal -childformat {{{/testbench/DUT/VC/victim_cache_datapath/data_array/data[3]} -radix hexadecimal} {{/testbench/DUT/VC/victim_cache_datapath/data_array/data[2]} -radix hexadecimal} {{/testbench/DUT/VC/victim_cache_datapath/data_array/data[1]} -radix hexadecimal} {{/testbench/DUT/VC/victim_cache_datapath/data_array/data[0]} -radix hexadecimal}} -expand -subitemconfig {{/testbench/DUT/VC/victim_cache_datapath/data_array/data[3]} {-height 16 -radix hexadecimal} {/testbench/DUT/VC/victim_cache_datapath/data_array/data[2]} {-height 16 -radix hexadecimal} {/testbench/DUT/VC/victim_cache_datapath/data_array/data[1]} {-height 16 -radix hexadecimal} {/testbench/DUT/VC/victim_cache_datapath/data_array/data[0]} {-height 16 -radix hexadecimal}} /testbench/DUT/VC/victim_cache_datapath/data_array/data
add wave -noupdate -label {vc tag data} -radix hexadecimal -childformat {{{/testbench/DUT/VC/victim_cache_datapath/tag_array/data[3]} -radix hexadecimal} {{/testbench/DUT/VC/victim_cache_datapath/tag_array/data[2]} -radix hexadecimal} {{/testbench/DUT/VC/victim_cache_datapath/tag_array/data[1]} -radix hexadecimal} {{/testbench/DUT/VC/victim_cache_datapath/tag_array/data[0]} -radix hexadecimal}} -expand -subitemconfig {{/testbench/DUT/VC/victim_cache_datapath/tag_array/data[3]} {-height 16 -radix hexadecimal} {/testbench/DUT/VC/victim_cache_datapath/tag_array/data[2]} {-height 16 -radix hexadecimal} {/testbench/DUT/VC/victim_cache_datapath/tag_array/data[1]} {-height 16 -radix hexadecimal} {/testbench/DUT/VC/victim_cache_datapath/tag_array/data[0]} {-height 16 -radix hexadecimal}} /testbench/DUT/VC/victim_cache_datapath/tag_array/data
add wave -noupdate -label LRU_Register_File -radix hexadecimal -childformat {{{/testbench/DUT/VC/victim_cache_datapath/LRU_regfile/data[3]} -radix hexadecimal} {{/testbench/DUT/VC/victim_cache_datapath/LRU_regfile/data[2]} -radix hexadecimal} {{/testbench/DUT/VC/victim_cache_datapath/LRU_regfile/data[1]} -radix hexadecimal} {{/testbench/DUT/VC/victim_cache_datapath/LRU_regfile/data[0]} -radix hexadecimal}} -subitemconfig {{/testbench/DUT/VC/victim_cache_datapath/LRU_regfile/data[3]} {-height 16 -radix hexadecimal} {/testbench/DUT/VC/victim_cache_datapath/LRU_regfile/data[2]} {-height 16 -radix hexadecimal} {/testbench/DUT/VC/victim_cache_datapath/LRU_regfile/data[1]} {-height 16 -radix hexadecimal} {/testbench/DUT/VC/victim_cache_datapath/LRU_regfile/data[0]} {-height 16 -radix hexadecimal}} /testbench/DUT/VC/victim_cache_datapath/LRU_regfile/data
add wave -noupdate -label VC_way_hit -radix hexadecimal /testbench/DUT/VC/victim_cache_datapath/LRU_regfile/way_hit
add wave -noupdate -label Replace_index -radix hexadecimal /testbench/DUT/VC/victim_cache_datapath/LRU_regfile/replace
add wave -noupdate -label VC_dirty_array /testbench/DUT/VC/victim_cache_datapath/dirty_array/data
add wave -noupdate -label L2_dirty0 /testbench/DUT/L2/dirty0_out
add wave -noupdate -label L2_dirty1 /testbench/DUT/L2/dirty1_out
add wave -noupdate -label L2_dirty2 /testbench/DUT/L2/dirty2_out
add wave -noupdate -label L2_dirty3 /testbench/DUT/L2/dirty3_out
add wave -noupdate -label pmem_address -radix hexadecimal /testbench/pmem/address
add wave -noupdate -label aluop /testbench/DUT/datapath/alu/aluop
add wave -noupdate -label a /testbench/DUT/datapath/alu/a
add wave -noupdate -label b /testbench/DUT/datapath/alu/b
add wave -noupdate -label {alu out} /testbench/DUT/datapath/alu/f
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2977225000 ps} 0} {{Cursor 2} {449949 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 161
configure wave -valuecolwidth 239
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {355335 ps} {617835 ps}
