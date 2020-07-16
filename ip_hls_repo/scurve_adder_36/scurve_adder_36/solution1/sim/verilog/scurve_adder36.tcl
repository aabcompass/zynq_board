
log_wave -r /
set designtopgroup [add_wave_group "Design Top Signals"]
set cinoutgroup [add_wave_group "C InOuts" -into $designtopgroup]
set N_ADDS__TEST_MODE__return_group [add_wave_group N_ADDS__TEST_MODE__return(axi_slave) -into $cinoutgroup]
add_wave /apatb_scurve_adder36_top/AESL_inst_scurve_adder36/interrupt -into $N_ADDS__TEST_MODE__return_group -color #ffff00 -radix hex
add_wave /apatb_scurve_adder36_top/AESL_inst_scurve_adder36/s_axi_CTRL_BUS_BRESP -into $N_ADDS__TEST_MODE__return_group -radix hex
add_wave /apatb_scurve_adder36_top/AESL_inst_scurve_adder36/s_axi_CTRL_BUS_BREADY -into $N_ADDS__TEST_MODE__return_group -color #ffff00 -radix hex
add_wave /apatb_scurve_adder36_top/AESL_inst_scurve_adder36/s_axi_CTRL_BUS_BVALID -into $N_ADDS__TEST_MODE__return_group -color #ffff00 -radix hex
add_wave /apatb_scurve_adder36_top/AESL_inst_scurve_adder36/s_axi_CTRL_BUS_RRESP -into $N_ADDS__TEST_MODE__return_group -radix hex
add_wave /apatb_scurve_adder36_top/AESL_inst_scurve_adder36/s_axi_CTRL_BUS_RDATA -into $N_ADDS__TEST_MODE__return_group -radix hex
add_wave /apatb_scurve_adder36_top/AESL_inst_scurve_adder36/s_axi_CTRL_BUS_RREADY -into $N_ADDS__TEST_MODE__return_group -color #ffff00 -radix hex
add_wave /apatb_scurve_adder36_top/AESL_inst_scurve_adder36/s_axi_CTRL_BUS_RVALID -into $N_ADDS__TEST_MODE__return_group -color #ffff00 -radix hex
add_wave /apatb_scurve_adder36_top/AESL_inst_scurve_adder36/s_axi_CTRL_BUS_ARREADY -into $N_ADDS__TEST_MODE__return_group -color #ffff00 -radix hex
add_wave /apatb_scurve_adder36_top/AESL_inst_scurve_adder36/s_axi_CTRL_BUS_ARVALID -into $N_ADDS__TEST_MODE__return_group -color #ffff00 -radix hex
add_wave /apatb_scurve_adder36_top/AESL_inst_scurve_adder36/s_axi_CTRL_BUS_ARADDR -into $N_ADDS__TEST_MODE__return_group -radix hex
add_wave /apatb_scurve_adder36_top/AESL_inst_scurve_adder36/s_axi_CTRL_BUS_WSTRB -into $N_ADDS__TEST_MODE__return_group -radix hex
add_wave /apatb_scurve_adder36_top/AESL_inst_scurve_adder36/s_axi_CTRL_BUS_WDATA -into $N_ADDS__TEST_MODE__return_group -radix hex
add_wave /apatb_scurve_adder36_top/AESL_inst_scurve_adder36/s_axi_CTRL_BUS_WREADY -into $N_ADDS__TEST_MODE__return_group -color #ffff00 -radix hex
add_wave /apatb_scurve_adder36_top/AESL_inst_scurve_adder36/s_axi_CTRL_BUS_WVALID -into $N_ADDS__TEST_MODE__return_group -color #ffff00 -radix hex
add_wave /apatb_scurve_adder36_top/AESL_inst_scurve_adder36/s_axi_CTRL_BUS_AWREADY -into $N_ADDS__TEST_MODE__return_group -color #ffff00 -radix hex
add_wave /apatb_scurve_adder36_top/AESL_inst_scurve_adder36/s_axi_CTRL_BUS_AWVALID -into $N_ADDS__TEST_MODE__return_group -color #ffff00 -radix hex
add_wave /apatb_scurve_adder36_top/AESL_inst_scurve_adder36/s_axi_CTRL_BUS_AWADDR -into $N_ADDS__TEST_MODE__return_group -radix hex
set coutputgroup [add_wave_group "C Outputs" -into $designtopgroup]
set out_stream_group [add_wave_group out_stream(axis) -into $coutputgroup]
add_wave /apatb_scurve_adder36_top/AESL_inst_scurve_adder36/out_stream_TDEST -into $out_stream_group -radix hex
add_wave /apatb_scurve_adder36_top/AESL_inst_scurve_adder36/out_stream_TID -into $out_stream_group -radix hex
add_wave /apatb_scurve_adder36_top/AESL_inst_scurve_adder36/out_stream_TLAST -into $out_stream_group -color #ffff00 -radix hex
add_wave /apatb_scurve_adder36_top/AESL_inst_scurve_adder36/out_stream_TUSER -into $out_stream_group -radix hex
add_wave /apatb_scurve_adder36_top/AESL_inst_scurve_adder36/out_stream_TSTRB -into $out_stream_group -radix hex
add_wave /apatb_scurve_adder36_top/AESL_inst_scurve_adder36/out_stream_TKEEP -into $out_stream_group -radix hex
add_wave /apatb_scurve_adder36_top/AESL_inst_scurve_adder36/out_stream_TREADY -into $out_stream_group -color #ffff00 -radix hex
add_wave /apatb_scurve_adder36_top/AESL_inst_scurve_adder36/out_stream_TVALID -into $out_stream_group -color #ffff00 -radix hex
add_wave /apatb_scurve_adder36_top/AESL_inst_scurve_adder36/out_stream_TDATA -into $out_stream_group -radix hex
set cinputgroup [add_wave_group "C Inputs" -into $designtopgroup]
set in_stream0_group [add_wave_group in_stream0(axis) -into $cinputgroup]
add_wave /apatb_scurve_adder36_top/AESL_inst_scurve_adder36/in_stream0_TDEST -into $in_stream0_group -radix hex
add_wave /apatb_scurve_adder36_top/AESL_inst_scurve_adder36/in_stream0_TID -into $in_stream0_group -radix hex
add_wave /apatb_scurve_adder36_top/AESL_inst_scurve_adder36/in_stream0_TLAST -into $in_stream0_group -color #ffff00 -radix hex
add_wave /apatb_scurve_adder36_top/AESL_inst_scurve_adder36/in_stream0_TUSER -into $in_stream0_group -radix hex
add_wave /apatb_scurve_adder36_top/AESL_inst_scurve_adder36/in_stream0_TSTRB -into $in_stream0_group -radix hex
add_wave /apatb_scurve_adder36_top/AESL_inst_scurve_adder36/in_stream0_TKEEP -into $in_stream0_group -radix hex
add_wave /apatb_scurve_adder36_top/AESL_inst_scurve_adder36/in_stream0_TREADY -into $in_stream0_group -color #ffff00 -radix hex
add_wave /apatb_scurve_adder36_top/AESL_inst_scurve_adder36/in_stream0_TVALID -into $in_stream0_group -color #ffff00 -radix hex
add_wave /apatb_scurve_adder36_top/AESL_inst_scurve_adder36/in_stream0_TDATA -into $in_stream0_group -radix hex
set blocksiggroup [add_wave_group "Block-level IO Handshake(internal)" -into $designtopgroup]
add_wave /apatb_scurve_adder36_top/AESL_inst_scurve_adder36/ap_done -into $blocksiggroup
add_wave /apatb_scurve_adder36_top/AESL_inst_scurve_adder36/ap_idle -into $blocksiggroup
add_wave /apatb_scurve_adder36_top/AESL_inst_scurve_adder36/ap_ready -into $blocksiggroup
add_wave /apatb_scurve_adder36_top/AESL_inst_scurve_adder36/ap_start -into $blocksiggroup
set resetgroup [add_wave_group "Reset" -into $designtopgroup]
add_wave /apatb_scurve_adder36_top/AESL_inst_scurve_adder36/ap_rst_n -into $resetgroup
set clockgroup [add_wave_group "Clock" -into $designtopgroup]
add_wave /apatb_scurve_adder36_top/AESL_inst_scurve_adder36/ap_clk -into $clockgroup
set testbenchgroup [add_wave_group "Test Bench Signals"]
set tbinternalsiggroup [add_wave_group "Internal Signals" -into $testbenchgroup]
set tb_simstatus_group [add_wave_group "Simulation Status" -into $tbinternalsiggroup]
set tb_portdepth_group [add_wave_group "Port Depth" -into $tbinternalsiggroup]
add_wave /apatb_scurve_adder36_top/AUTOTB_TRANSACTION_NUM -into $tb_simstatus_group -radix hex
add_wave /apatb_scurve_adder36_top/ready_cnt -into $tb_simstatus_group -radix hex
add_wave /apatb_scurve_adder36_top/done_cnt -into $tb_simstatus_group -radix hex
add_wave /apatb_scurve_adder36_top/LENGTH_in_stream0_V_data_V -into $tb_portdepth_group -radix hex
add_wave /apatb_scurve_adder36_top/LENGTH_in_stream0_V_keep_V -into $tb_portdepth_group -radix hex
add_wave /apatb_scurve_adder36_top/LENGTH_in_stream0_V_strb_V -into $tb_portdepth_group -radix hex
add_wave /apatb_scurve_adder36_top/LENGTH_in_stream0_V_user_V -into $tb_portdepth_group -radix hex
add_wave /apatb_scurve_adder36_top/LENGTH_in_stream0_V_last_V -into $tb_portdepth_group -radix hex
add_wave /apatb_scurve_adder36_top/LENGTH_in_stream0_V_id_V -into $tb_portdepth_group -radix hex
add_wave /apatb_scurve_adder36_top/LENGTH_in_stream0_V_dest_V -into $tb_portdepth_group -radix hex
add_wave /apatb_scurve_adder36_top/LENGTH_out_stream_V_data_V -into $tb_portdepth_group -radix hex
add_wave /apatb_scurve_adder36_top/LENGTH_out_stream_V_keep_V -into $tb_portdepth_group -radix hex
add_wave /apatb_scurve_adder36_top/LENGTH_out_stream_V_strb_V -into $tb_portdepth_group -radix hex
add_wave /apatb_scurve_adder36_top/LENGTH_out_stream_V_user_V -into $tb_portdepth_group -radix hex
add_wave /apatb_scurve_adder36_top/LENGTH_out_stream_V_last_V -into $tb_portdepth_group -radix hex
add_wave /apatb_scurve_adder36_top/LENGTH_out_stream_V_id_V -into $tb_portdepth_group -radix hex
add_wave /apatb_scurve_adder36_top/LENGTH_out_stream_V_dest_V -into $tb_portdepth_group -radix hex
add_wave /apatb_scurve_adder36_top/LENGTH_N_ADDS -into $tb_portdepth_group -radix hex
add_wave /apatb_scurve_adder36_top/LENGTH_TEST_MODE -into $tb_portdepth_group -radix hex
set tbcinoutgroup [add_wave_group "C InOuts" -into $testbenchgroup]
set tb_N_ADDS__TEST_MODE__return_group [add_wave_group N_ADDS__TEST_MODE__return(axi_slave) -into $tbcinoutgroup]
add_wave /apatb_scurve_adder36_top/CTRL_BUS_INTERRUPT -into $tb_N_ADDS__TEST_MODE__return_group -color #ffff00 -radix hex
add_wave /apatb_scurve_adder36_top/CTRL_BUS_BRESP -into $tb_N_ADDS__TEST_MODE__return_group -radix hex
add_wave /apatb_scurve_adder36_top/CTRL_BUS_BREADY -into $tb_N_ADDS__TEST_MODE__return_group -color #ffff00 -radix hex
add_wave /apatb_scurve_adder36_top/CTRL_BUS_BVALID -into $tb_N_ADDS__TEST_MODE__return_group -color #ffff00 -radix hex
add_wave /apatb_scurve_adder36_top/CTRL_BUS_RRESP -into $tb_N_ADDS__TEST_MODE__return_group -radix hex
add_wave /apatb_scurve_adder36_top/CTRL_BUS_RDATA -into $tb_N_ADDS__TEST_MODE__return_group -radix hex
add_wave /apatb_scurve_adder36_top/CTRL_BUS_RREADY -into $tb_N_ADDS__TEST_MODE__return_group -color #ffff00 -radix hex
add_wave /apatb_scurve_adder36_top/CTRL_BUS_RVALID -into $tb_N_ADDS__TEST_MODE__return_group -color #ffff00 -radix hex
add_wave /apatb_scurve_adder36_top/CTRL_BUS_ARREADY -into $tb_N_ADDS__TEST_MODE__return_group -color #ffff00 -radix hex
add_wave /apatb_scurve_adder36_top/CTRL_BUS_ARVALID -into $tb_N_ADDS__TEST_MODE__return_group -color #ffff00 -radix hex
add_wave /apatb_scurve_adder36_top/CTRL_BUS_ARADDR -into $tb_N_ADDS__TEST_MODE__return_group -radix hex
add_wave /apatb_scurve_adder36_top/CTRL_BUS_WSTRB -into $tb_N_ADDS__TEST_MODE__return_group -radix hex
add_wave /apatb_scurve_adder36_top/CTRL_BUS_WDATA -into $tb_N_ADDS__TEST_MODE__return_group -radix hex
add_wave /apatb_scurve_adder36_top/CTRL_BUS_WREADY -into $tb_N_ADDS__TEST_MODE__return_group -color #ffff00 -radix hex
add_wave /apatb_scurve_adder36_top/CTRL_BUS_WVALID -into $tb_N_ADDS__TEST_MODE__return_group -color #ffff00 -radix hex
add_wave /apatb_scurve_adder36_top/CTRL_BUS_AWREADY -into $tb_N_ADDS__TEST_MODE__return_group -color #ffff00 -radix hex
add_wave /apatb_scurve_adder36_top/CTRL_BUS_AWVALID -into $tb_N_ADDS__TEST_MODE__return_group -color #ffff00 -radix hex
add_wave /apatb_scurve_adder36_top/CTRL_BUS_AWADDR -into $tb_N_ADDS__TEST_MODE__return_group -radix hex
set tbcoutputgroup [add_wave_group "C Outputs" -into $testbenchgroup]
set tb_out_stream_group [add_wave_group out_stream(axis) -into $tbcoutputgroup]
add_wave /apatb_scurve_adder36_top/out_stream_TDEST -into $tb_out_stream_group -radix hex
add_wave /apatb_scurve_adder36_top/out_stream_TID -into $tb_out_stream_group -radix hex
add_wave /apatb_scurve_adder36_top/out_stream_TLAST -into $tb_out_stream_group -color #ffff00 -radix hex
add_wave /apatb_scurve_adder36_top/out_stream_TUSER -into $tb_out_stream_group -radix hex
add_wave /apatb_scurve_adder36_top/out_stream_TSTRB -into $tb_out_stream_group -radix hex
add_wave /apatb_scurve_adder36_top/out_stream_TKEEP -into $tb_out_stream_group -radix hex
add_wave /apatb_scurve_adder36_top/out_stream_TREADY -into $tb_out_stream_group -color #ffff00 -radix hex
add_wave /apatb_scurve_adder36_top/out_stream_TVALID -into $tb_out_stream_group -color #ffff00 -radix hex
add_wave /apatb_scurve_adder36_top/out_stream_TDATA -into $tb_out_stream_group -radix hex
set tbcinputgroup [add_wave_group "C Inputs" -into $testbenchgroup]
set tb_in_stream0_group [add_wave_group in_stream0(axis) -into $tbcinputgroup]
add_wave /apatb_scurve_adder36_top/in_stream0_TDEST -into $tb_in_stream0_group -radix hex
add_wave /apatb_scurve_adder36_top/in_stream0_TID -into $tb_in_stream0_group -radix hex
add_wave /apatb_scurve_adder36_top/in_stream0_TLAST -into $tb_in_stream0_group -color #ffff00 -radix hex
add_wave /apatb_scurve_adder36_top/in_stream0_TUSER -into $tb_in_stream0_group -radix hex
add_wave /apatb_scurve_adder36_top/in_stream0_TSTRB -into $tb_in_stream0_group -radix hex
add_wave /apatb_scurve_adder36_top/in_stream0_TKEEP -into $tb_in_stream0_group -radix hex
add_wave /apatb_scurve_adder36_top/in_stream0_TREADY -into $tb_in_stream0_group -color #ffff00 -radix hex
add_wave /apatb_scurve_adder36_top/in_stream0_TVALID -into $tb_in_stream0_group -color #ffff00 -radix hex
add_wave /apatb_scurve_adder36_top/in_stream0_TDATA -into $tb_in_stream0_group -radix hex
save_wave_config scurve_adder36.wcfg
run all
quit

