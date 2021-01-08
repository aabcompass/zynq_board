
#set_property MARK_DEBUG true [get_nets design_1_i/spaciroc3_sc_0/U0/spaciroc3_sc_v1_0_S00_AXI_inst/i_spaciroc3_sc_top/readback_fifo_wr_en]
#set_property MARK_DEBUG true [get_nets {sr_out_pc_0_IBUF[0]}]
#set_property MARK_DEBUG true [get_nets {sr_out_pc_0_IBUF[1]}]
#set_property MARK_DEBUG true [get_nets {sr_out_pc_0_IBUF[2]}]
#set_property MARK_DEBUG true [get_nets {sr_out_pc_0_IBUF[3]}]
#set_property MARK_DEBUG true [get_nets {sr_out_pc_0_IBUF[4]}]
#set_property MARK_DEBUG true [get_nets {sr_out_pc_0_IBUF[5]}]


#set_property MARK_DEBUG true [get_nets {design_1_i/sr_in_pc_0[0]}]
#set_property MARK_DEBUG true [get_nets {design_1_i/sr_in_pc_0[1]}]
#set_property MARK_DEBUG true [get_nets {design_1_i/sr_in_pc_0[2]}]
#set_property MARK_DEBUG true [get_nets {design_1_i/sr_in_pc_0[3]}]
#set_property MARK_DEBUG true [get_nets {design_1_i/sr_in_pc_0[4]}]
#set_property MARK_DEBUG true [get_nets {design_1_i/sr_in_pc_0[5]}]
#set_property MARK_DEBUG true [get_nets design_1_i/sr_ck_pc_2]
#set_property MARK_DEBUG true [get_nets design_1_i/sr_rstb_pc_0]
#set_property MARK_DEBUG true [get_nets design_1_i/select_sc_probe_pc_0]
#set_property MARK_DEBUG true [get_nets design_1_i/select_din_pc_0]
#set_property MARK_DEBUG true [get_nets design_1_i/resetb_pc_0]
#set_property MARK_DEBUG true [get_nets design_1_i/loadb_sc_pc_0]
#create_debug_core u_ila_0 ila
#set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
#set_property ALL_PROBE_SAME_MU_CNT 4 [get_debug_cores u_ila_0]
#set_property C_ADV_TRIGGER true [get_debug_cores u_ila_0]
#set_property C_DATA_DEPTH 8192 [get_debug_cores u_ila_0]
#set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_0]
#set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
#set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
#set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
#set_property port_width 1 [get_debug_ports u_ila_0/clk]
#connect_debug_port u_ila_0/clk [get_nets [list design_1_i/clk_wiz_0/inst/clk_out1]]
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
#set_property port_width 6 [get_debug_ports u_ila_0/probe0]
#connect_debug_port u_ila_0/probe0 [get_nets [list {design_1_i/sr_in_pc_0[0]} {design_1_i/sr_in_pc_0[1]} {design_1_i/sr_in_pc_0[2]} {design_1_i/sr_in_pc_0[3]} {design_1_i/sr_in_pc_0[4]} {design_1_i/sr_in_pc_0[5]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
#set_property port_width 6 [get_debug_ports u_ila_0/probe1]
#connect_debug_port u_ila_0/probe1 [get_nets [list {sr_out_pc_0_IBUF[0]} {sr_out_pc_0_IBUF[1]} {sr_out_pc_0_IBUF[2]} {sr_out_pc_0_IBUF[3]} {sr_out_pc_0_IBUF[4]} {sr_out_pc_0_IBUF[5]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
#set_property port_width 1 [get_debug_ports u_ila_0/probe2]
#connect_debug_port u_ila_0/probe2 [get_nets [list design_1_i/loadb_sc_pc_0]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
#set_property port_width 1 [get_debug_ports u_ila_0/probe3]
#connect_debug_port u_ila_0/probe3 [get_nets [list design_1_i/spaciroc3_sc_0/U0/spaciroc3_sc_v1_0_S00_AXI_inst/i_spaciroc3_sc_top/readback_fifo_wr_en]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
#set_property port_width 1 [get_debug_ports u_ila_0/probe4]
#connect_debug_port u_ila_0/probe4 [get_nets [list design_1_i/resetb_pc_0]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
#set_property port_width 1 [get_debug_ports u_ila_0/probe5]
#connect_debug_port u_ila_0/probe5 [get_nets [list design_1_i/select_din_pc_0]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
#set_property port_width 1 [get_debug_ports u_ila_0/probe6]
#connect_debug_port u_ila_0/probe6 [get_nets [list design_1_i/select_sc_probe_pc_0]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
#set_property port_width 1 [get_debug_ports u_ila_0/probe7]
#connect_debug_port u_ila_0/probe7 [get_nets [list design_1_i/sr_ck_pc_2]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
#set_property port_width 1 [get_debug_ports u_ila_0/probe8]
#connect_debug_port u_ila_0/probe8 [get_nets [list design_1_i/sr_rstb_pc_0]]
#set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
#set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
#set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
#connect_debug_port dbg_hub/clk [get_nets u_ila_0_clk_out1]

#set_property MARK_DEBUG true [get_nets design_1_i/data_converter_1_m_axis_TLAST]
#set_property MARK_DEBUG true [get_nets design_1_i/data_converter_1_m_axis_TVALID]
#set_property MARK_DEBUG true [get_nets {design_1_i/data_converter_1_m_axis_TUSER[0]}]
#set_property MARK_DEBUG true [get_nets {design_1_i/data_converter_1_m_axis_TUSER[1]}]
#set_property MARK_DEBUG true [get_nets {design_1_i/data_converter_1_m_axis_TUSER[2]}]
#set_property MARK_DEBUG true [get_nets {design_1_i/data_converter_1_m_axis_TUSER[3]}]
#set_property MARK_DEBUG true [get_nets {design_1_i/data_converter_1_m_axis_TUSER[4]}]
#set_property MARK_DEBUG true [get_nets {design_1_i/data_converter_1_m_axis_TUSER[5]}]
#create_debug_core u_ila_0 ila
#set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
#set_property ALL_PROBE_SAME_MU_CNT 4 [get_debug_cores u_ila_0]
#set_property C_ADV_TRIGGER true [get_debug_cores u_ila_0]
#set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
#set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_0]
#set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
#set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
#set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
#set_property port_width 1 [get_debug_ports u_ila_0/clk]
#connect_debug_port u_ila_0/clk [get_nets [list design_1_i/processing_system7_0/inst/FCLK_CLK1]]
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
#set_property port_width 6 [get_debug_ports u_ila_0/probe0]
#connect_debug_port u_ila_0/probe0 [get_nets [list {design_1_i/data_converter_1_m_axis_TUSER[0]} {design_1_i/data_converter_1_m_axis_TUSER[1]} {design_1_i/data_converter_1_m_axis_TUSER[2]} {design_1_i/data_converter_1_m_axis_TUSER[3]} {design_1_i/data_converter_1_m_axis_TUSER[4]} {design_1_i/data_converter_1_m_axis_TUSER[5]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
#set_property port_width 1 [get_debug_ports u_ila_0/probe1]
#connect_debug_port u_ila_0/probe1 [get_nets [list design_1_i/data_converter_1_m_axis_TLAST]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
#set_property port_width 1 [get_debug_ports u_ila_0/probe2]
#connect_debug_port u_ila_0/probe2 [get_nets [list design_1_i/data_converter_1_m_axis_TVALID]]
#set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
#set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
#set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
#connect_debug_port dbg_hub/clk [get_nets u_ila_0_FCLK_CLK1]
