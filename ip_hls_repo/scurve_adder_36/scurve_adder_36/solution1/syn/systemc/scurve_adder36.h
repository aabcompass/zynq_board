// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
// Version: 2018.1
// Copyright (C) 1986-2018 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

#ifndef _scurve_adder36_HH_
#define _scurve_adder36_HH_

#include "systemc.h"
#include "AESL_pkg.h"

#include "scurve_adder36_subkb.h"
#include "scurve_adder36_CTRL_BUS_s_axi.h"

namespace ap_rtl {

template<unsigned int C_S_AXI_CTRL_BUS_ADDR_WIDTH = 5,
         unsigned int C_S_AXI_CTRL_BUS_DATA_WIDTH = 32>
struct scurve_adder36 : public sc_module {
    // Port declarations 38
    sc_in_clk ap_clk;
    sc_in< sc_logic > ap_rst_n;
    sc_in< sc_lv<128> > in_stream0_TDATA;
    sc_in< sc_logic > in_stream0_TVALID;
    sc_out< sc_logic > in_stream0_TREADY;
    sc_in< sc_lv<16> > in_stream0_TKEEP;
    sc_in< sc_lv<16> > in_stream0_TSTRB;
    sc_in< sc_lv<6> > in_stream0_TUSER;
    sc_in< sc_lv<1> > in_stream0_TLAST;
    sc_in< sc_lv<5> > in_stream0_TID;
    sc_in< sc_lv<6> > in_stream0_TDEST;
    sc_out< sc_lv<512> > out_stream_TDATA;
    sc_out< sc_logic > out_stream_TVALID;
    sc_in< sc_logic > out_stream_TREADY;
    sc_out< sc_lv<64> > out_stream_TKEEP;
    sc_out< sc_lv<64> > out_stream_TSTRB;
    sc_out< sc_lv<6> > out_stream_TUSER;
    sc_out< sc_lv<1> > out_stream_TLAST;
    sc_out< sc_lv<5> > out_stream_TID;
    sc_out< sc_lv<6> > out_stream_TDEST;
    sc_in< sc_logic > s_axi_CTRL_BUS_AWVALID;
    sc_out< sc_logic > s_axi_CTRL_BUS_AWREADY;
    sc_in< sc_uint<C_S_AXI_CTRL_BUS_ADDR_WIDTH> > s_axi_CTRL_BUS_AWADDR;
    sc_in< sc_logic > s_axi_CTRL_BUS_WVALID;
    sc_out< sc_logic > s_axi_CTRL_BUS_WREADY;
    sc_in< sc_uint<C_S_AXI_CTRL_BUS_DATA_WIDTH> > s_axi_CTRL_BUS_WDATA;
    sc_in< sc_uint<C_S_AXI_CTRL_BUS_DATA_WIDTH/8> > s_axi_CTRL_BUS_WSTRB;
    sc_in< sc_logic > s_axi_CTRL_BUS_ARVALID;
    sc_out< sc_logic > s_axi_CTRL_BUS_ARREADY;
    sc_in< sc_uint<C_S_AXI_CTRL_BUS_ADDR_WIDTH> > s_axi_CTRL_BUS_ARADDR;
    sc_out< sc_logic > s_axi_CTRL_BUS_RVALID;
    sc_in< sc_logic > s_axi_CTRL_BUS_RREADY;
    sc_out< sc_uint<C_S_AXI_CTRL_BUS_DATA_WIDTH> > s_axi_CTRL_BUS_RDATA;
    sc_out< sc_lv<2> > s_axi_CTRL_BUS_RRESP;
    sc_out< sc_logic > s_axi_CTRL_BUS_BVALID;
    sc_in< sc_logic > s_axi_CTRL_BUS_BREADY;
    sc_out< sc_lv<2> > s_axi_CTRL_BUS_BRESP;
    sc_out< sc_logic > interrupt;
    sc_signal< sc_logic > ap_var_for_const0;
    sc_signal< sc_lv<32> > ap_var_for_const1;


    // Module declarations
    scurve_adder36(sc_module_name name);
    SC_HAS_PROCESS(scurve_adder36);

    ~scurve_adder36();

    sc_trace_file* mVcdFile;

    ofstream mHdltvinHandle;
    ofstream mHdltvoutHandle;
    scurve_adder36_CTRL_BUS_s_axi<C_S_AXI_CTRL_BUS_ADDR_WIDTH,C_S_AXI_CTRL_BUS_DATA_WIDTH>* scurve_adder36_CTRL_BUS_s_axi_U;
    scurve_adder36_subkb* sum_pix_ch0_0_U;
    scurve_adder36_subkb* sum_pix_ch0_1_U;
    scurve_adder36_subkb* sum_pix_ch0_2_U;
    scurve_adder36_subkb* sum_pix_ch0_3_U;
    scurve_adder36_subkb* sum_pix_ch0_4_U;
    scurve_adder36_subkb* sum_pix_ch0_5_U;
    scurve_adder36_subkb* sum_pix_ch0_6_U;
    scurve_adder36_subkb* sum_pix_ch0_7_U;
    scurve_adder36_subkb* sum_pix_ch0_8_U;
    scurve_adder36_subkb* sum_pix_ch0_9_U;
    scurve_adder36_subkb* sum_pix_ch0_10_U;
    scurve_adder36_subkb* sum_pix_ch0_11_U;
    scurve_adder36_subkb* sum_pix_ch0_12_U;
    scurve_adder36_subkb* sum_pix_ch0_13_U;
    scurve_adder36_subkb* sum_pix_ch0_14_U;
    scurve_adder36_subkb* sum_pix_ch0_15_U;
    sc_signal< sc_logic > ap_rst_n_inv;
    sc_signal< sc_logic > ap_start;
    sc_signal< sc_logic > ap_done;
    sc_signal< sc_logic > ap_idle;
    sc_signal< sc_lv<7> > ap_CS_fsm;
    sc_signal< sc_logic > ap_CS_fsm_state1;
    sc_signal< sc_logic > ap_ready;
    sc_signal< sc_lv<128> > in_stream0_V_data_V_0_data_out;
    sc_signal< sc_logic > in_stream0_V_data_V_0_vld_in;
    sc_signal< sc_logic > in_stream0_V_data_V_0_vld_out;
    sc_signal< sc_logic > in_stream0_V_data_V_0_ack_in;
    sc_signal< sc_logic > in_stream0_V_data_V_0_ack_out;
    sc_signal< sc_lv<128> > in_stream0_V_data_V_0_payload_A;
    sc_signal< sc_lv<128> > in_stream0_V_data_V_0_payload_B;
    sc_signal< sc_logic > in_stream0_V_data_V_0_sel_rd;
    sc_signal< sc_logic > in_stream0_V_data_V_0_sel_wr;
    sc_signal< sc_logic > in_stream0_V_data_V_0_sel;
    sc_signal< sc_logic > in_stream0_V_data_V_0_load_A;
    sc_signal< sc_logic > in_stream0_V_data_V_0_load_B;
    sc_signal< sc_lv<2> > in_stream0_V_data_V_0_state;
    sc_signal< sc_logic > in_stream0_V_data_V_0_state_cmp_full;
    sc_signal< sc_logic > in_stream0_V_dest_V_0_vld_in;
    sc_signal< sc_logic > in_stream0_V_dest_V_0_ack_out;
    sc_signal< sc_lv<2> > in_stream0_V_dest_V_0_state;
    sc_signal< sc_lv<512> > out_stream_V_data_V_1_data_out;
    sc_signal< sc_logic > out_stream_V_data_V_1_vld_in;
    sc_signal< sc_logic > out_stream_V_data_V_1_vld_out;
    sc_signal< sc_logic > out_stream_V_data_V_1_ack_in;
    sc_signal< sc_logic > out_stream_V_data_V_1_ack_out;
    sc_signal< sc_lv<512> > out_stream_V_data_V_1_payload_A;
    sc_signal< sc_lv<512> > out_stream_V_data_V_1_payload_B;
    sc_signal< sc_logic > out_stream_V_data_V_1_sel_rd;
    sc_signal< sc_logic > out_stream_V_data_V_1_sel_wr;
    sc_signal< sc_logic > out_stream_V_data_V_1_sel;
    sc_signal< sc_logic > out_stream_V_data_V_1_load_A;
    sc_signal< sc_logic > out_stream_V_data_V_1_load_B;
    sc_signal< sc_lv<2> > out_stream_V_data_V_1_state;
    sc_signal< sc_logic > out_stream_V_data_V_1_state_cmp_full;
    sc_signal< sc_lv<64> > out_stream_V_keep_V_1_data_out;
    sc_signal< sc_logic > out_stream_V_keep_V_1_vld_in;
    sc_signal< sc_logic > out_stream_V_keep_V_1_vld_out;
    sc_signal< sc_logic > out_stream_V_keep_V_1_ack_in;
    sc_signal< sc_logic > out_stream_V_keep_V_1_ack_out;
    sc_signal< sc_logic > out_stream_V_keep_V_1_sel_rd;
    sc_signal< sc_logic > out_stream_V_keep_V_1_sel;
    sc_signal< sc_lv<2> > out_stream_V_keep_V_1_state;
    sc_signal< sc_lv<64> > out_stream_V_strb_V_1_data_out;
    sc_signal< sc_logic > out_stream_V_strb_V_1_vld_in;
    sc_signal< sc_logic > out_stream_V_strb_V_1_vld_out;
    sc_signal< sc_logic > out_stream_V_strb_V_1_ack_in;
    sc_signal< sc_logic > out_stream_V_strb_V_1_ack_out;
    sc_signal< sc_logic > out_stream_V_strb_V_1_sel_rd;
    sc_signal< sc_logic > out_stream_V_strb_V_1_sel;
    sc_signal< sc_lv<2> > out_stream_V_strb_V_1_state;
    sc_signal< sc_lv<6> > out_stream_V_user_V_1_data_out;
    sc_signal< sc_logic > out_stream_V_user_V_1_vld_in;
    sc_signal< sc_logic > out_stream_V_user_V_1_vld_out;
    sc_signal< sc_logic > out_stream_V_user_V_1_ack_in;
    sc_signal< sc_logic > out_stream_V_user_V_1_ack_out;
    sc_signal< sc_logic > out_stream_V_user_V_1_sel_rd;
    sc_signal< sc_logic > out_stream_V_user_V_1_sel;
    sc_signal< sc_lv<2> > out_stream_V_user_V_1_state;
    sc_signal< sc_lv<1> > out_stream_V_last_V_1_data_out;
    sc_signal< sc_logic > out_stream_V_last_V_1_vld_in;
    sc_signal< sc_logic > out_stream_V_last_V_1_vld_out;
    sc_signal< sc_logic > out_stream_V_last_V_1_ack_in;
    sc_signal< sc_logic > out_stream_V_last_V_1_ack_out;
    sc_signal< sc_lv<1> > out_stream_V_last_V_1_payload_A;
    sc_signal< sc_lv<1> > out_stream_V_last_V_1_payload_B;
    sc_signal< sc_logic > out_stream_V_last_V_1_sel_rd;
    sc_signal< sc_logic > out_stream_V_last_V_1_sel_wr;
    sc_signal< sc_logic > out_stream_V_last_V_1_sel;
    sc_signal< sc_logic > out_stream_V_last_V_1_load_A;
    sc_signal< sc_logic > out_stream_V_last_V_1_load_B;
    sc_signal< sc_lv<2> > out_stream_V_last_V_1_state;
    sc_signal< sc_logic > out_stream_V_last_V_1_state_cmp_full;
    sc_signal< sc_lv<5> > out_stream_V_id_V_1_data_out;
    sc_signal< sc_logic > out_stream_V_id_V_1_vld_in;
    sc_signal< sc_logic > out_stream_V_id_V_1_vld_out;
    sc_signal< sc_logic > out_stream_V_id_V_1_ack_in;
    sc_signal< sc_logic > out_stream_V_id_V_1_ack_out;
    sc_signal< sc_logic > out_stream_V_id_V_1_sel_rd;
    sc_signal< sc_logic > out_stream_V_id_V_1_sel;
    sc_signal< sc_lv<2> > out_stream_V_id_V_1_state;
    sc_signal< sc_lv<6> > out_stream_V_dest_V_1_data_out;
    sc_signal< sc_logic > out_stream_V_dest_V_1_vld_in;
    sc_signal< sc_logic > out_stream_V_dest_V_1_vld_out;
    sc_signal< sc_logic > out_stream_V_dest_V_1_ack_in;
    sc_signal< sc_logic > out_stream_V_dest_V_1_ack_out;
    sc_signal< sc_logic > out_stream_V_dest_V_1_sel_rd;
    sc_signal< sc_logic > out_stream_V_dest_V_1_sel;
    sc_signal< sc_lv<2> > out_stream_V_dest_V_1_state;
    sc_signal< sc_lv<16> > N_ADDS;
    sc_signal< sc_logic > in_stream0_TDATA_blk_n;
    sc_signal< sc_logic > ap_CS_fsm_pp1_stage0;
    sc_signal< sc_logic > ap_enable_reg_pp1_iter1;
    sc_signal< bool > ap_block_pp1_stage0;
    sc_signal< sc_lv<1> > exitcond_flatten_reg_1286;
    sc_signal< sc_logic > out_stream_TDATA_blk_n;
    sc_signal< sc_logic > ap_CS_fsm_pp2_stage0;
    sc_signal< sc_logic > ap_enable_reg_pp2_iter1;
    sc_signal< bool > ap_block_pp2_stage0;
    sc_signal< sc_lv<1> > exitcond4_reg_1641;
    sc_signal< sc_logic > ap_enable_reg_pp2_iter2;
    sc_signal< sc_lv<1> > exitcond4_reg_1641_pp2_iter1_reg;
    sc_signal< sc_lv<24> > indvar_flatten_reg_763;
    sc_signal< sc_lv<8> > i_1_reg_774;
    sc_signal< sc_lv<8> > i_2_reg_785;
    sc_signal< sc_lv<16> > N_ADDS_read_reg_1267;
    sc_signal< sc_lv<8> > i_3_fu_802_p2;
    sc_signal< sc_logic > ap_CS_fsm_state2;
    sc_signal< sc_lv<24> > bound_fu_850_p2;
    sc_signal< sc_lv<24> > bound_reg_1281;
    sc_signal< sc_logic > ap_CS_fsm_state3;
    sc_signal< sc_lv<1> > exitcond_flatten_fu_856_p2;
    sc_signal< bool > ap_block_state4_pp1_stage0_iter0;
    sc_signal< bool > ap_block_state5_pp1_stage0_iter1;
    sc_signal< bool > ap_block_state6_pp1_stage0_iter2;
    sc_signal< bool > ap_block_state7_pp1_stage0_iter3;
    sc_signal< bool > ap_block_state8_pp1_stage0_iter4;
    sc_signal< bool > ap_block_pp1_stage0_11001;
    sc_signal< sc_lv<1> > exitcond_flatten_reg_1286_pp1_iter1_reg;
    sc_signal< sc_lv<1> > exitcond_flatten_reg_1286_pp1_iter2_reg;
    sc_signal< sc_lv<1> > exitcond_flatten_reg_1286_pp1_iter3_reg;
    sc_signal< sc_lv<24> > indvar_flatten_next_fu_861_p2;
    sc_signal< sc_logic > ap_enable_reg_pp1_iter0;
    sc_signal< sc_lv<8> > i_1_mid2_fu_873_p3;
    sc_signal< sc_lv<8> > i_1_mid2_reg_1295;
    sc_signal< sc_lv<8> > i_5_fu_881_p2;
    sc_signal< sc_lv<8> > tmp_9_fu_910_p1;
    sc_signal< sc_lv<8> > tmp_9_reg_1305;
    sc_signal< sc_lv<8> > tmp_9_reg_1305_pp1_iter2_reg;
    sc_signal< sc_lv<8> > sum_pix_ch0_0_addr_2_reg_1310;
    sc_signal< sc_lv<8> > sum_pix_ch0_0_addr_2_reg_1310_pp1_iter2_reg;
    sc_signal< sc_lv<8> > sum_pix_ch0_0_addr_2_reg_1310_pp1_iter3_reg;
    sc_signal< sc_lv<8> > phitmp_1_reg_1316;
    sc_signal< sc_lv<8> > phitmp_1_reg_1316_pp1_iter2_reg;
    sc_signal< sc_lv<8> > sum_pix_ch0_1_addr_2_reg_1321;
    sc_signal< sc_lv<8> > sum_pix_ch0_1_addr_2_reg_1321_pp1_iter2_reg;
    sc_signal< sc_lv<8> > sum_pix_ch0_1_addr_2_reg_1321_pp1_iter3_reg;
    sc_signal< sc_lv<8> > phitmp_2_reg_1327;
    sc_signal< sc_lv<8> > phitmp_2_reg_1327_pp1_iter2_reg;
    sc_signal< sc_lv<8> > sum_pix_ch0_2_addr_2_reg_1332;
    sc_signal< sc_lv<8> > sum_pix_ch0_2_addr_2_reg_1332_pp1_iter2_reg;
    sc_signal< sc_lv<8> > sum_pix_ch0_2_addr_2_reg_1332_pp1_iter3_reg;
    sc_signal< sc_lv<8> > phitmp_3_reg_1338;
    sc_signal< sc_lv<8> > phitmp_3_reg_1338_pp1_iter2_reg;
    sc_signal< sc_lv<8> > sum_pix_ch0_3_addr_2_reg_1343;
    sc_signal< sc_lv<8> > sum_pix_ch0_3_addr_2_reg_1343_pp1_iter2_reg;
    sc_signal< sc_lv<8> > sum_pix_ch0_3_addr_2_reg_1343_pp1_iter3_reg;
    sc_signal< sc_lv<8> > phitmp_4_reg_1349;
    sc_signal< sc_lv<8> > phitmp_4_reg_1349_pp1_iter2_reg;
    sc_signal< sc_lv<8> > sum_pix_ch0_4_addr_2_reg_1354;
    sc_signal< sc_lv<8> > sum_pix_ch0_4_addr_2_reg_1354_pp1_iter2_reg;
    sc_signal< sc_lv<8> > sum_pix_ch0_4_addr_2_reg_1354_pp1_iter3_reg;
    sc_signal< sc_lv<8> > phitmp_5_reg_1360;
    sc_signal< sc_lv<8> > phitmp_5_reg_1360_pp1_iter2_reg;
    sc_signal< sc_lv<8> > sum_pix_ch0_5_addr_2_reg_1365;
    sc_signal< sc_lv<8> > sum_pix_ch0_5_addr_2_reg_1365_pp1_iter2_reg;
    sc_signal< sc_lv<8> > sum_pix_ch0_5_addr_2_reg_1365_pp1_iter3_reg;
    sc_signal< sc_lv<8> > phitmp_6_reg_1371;
    sc_signal< sc_lv<8> > phitmp_6_reg_1371_pp1_iter2_reg;
    sc_signal< sc_lv<8> > sum_pix_ch0_6_addr_2_reg_1376;
    sc_signal< sc_lv<8> > sum_pix_ch0_6_addr_2_reg_1376_pp1_iter2_reg;
    sc_signal< sc_lv<8> > sum_pix_ch0_6_addr_2_reg_1376_pp1_iter3_reg;
    sc_signal< sc_lv<8> > phitmp_7_reg_1382;
    sc_signal< sc_lv<8> > phitmp_7_reg_1382_pp1_iter2_reg;
    sc_signal< sc_lv<8> > sum_pix_ch0_7_addr_2_reg_1387;
    sc_signal< sc_lv<8> > sum_pix_ch0_7_addr_2_reg_1387_pp1_iter2_reg;
    sc_signal< sc_lv<8> > sum_pix_ch0_7_addr_2_reg_1387_pp1_iter3_reg;
    sc_signal< sc_lv<8> > phitmp_8_reg_1393;
    sc_signal< sc_lv<8> > phitmp_8_reg_1393_pp1_iter2_reg;
    sc_signal< sc_lv<8> > sum_pix_ch0_8_addr_2_reg_1398;
    sc_signal< sc_lv<8> > sum_pix_ch0_8_addr_2_reg_1398_pp1_iter2_reg;
    sc_signal< sc_lv<8> > sum_pix_ch0_8_addr_2_reg_1398_pp1_iter3_reg;
    sc_signal< sc_lv<8> > phitmp_9_reg_1404;
    sc_signal< sc_lv<8> > phitmp_9_reg_1404_pp1_iter2_reg;
    sc_signal< sc_lv<8> > sum_pix_ch0_9_addr_2_reg_1409;
    sc_signal< sc_lv<8> > sum_pix_ch0_9_addr_2_reg_1409_pp1_iter2_reg;
    sc_signal< sc_lv<8> > sum_pix_ch0_9_addr_2_reg_1409_pp1_iter3_reg;
    sc_signal< sc_lv<8> > phitmp_s_reg_1415;
    sc_signal< sc_lv<8> > phitmp_s_reg_1415_pp1_iter2_reg;
    sc_signal< sc_lv<8> > sum_pix_ch0_10_addr_2_reg_1420;
    sc_signal< sc_lv<8> > sum_pix_ch0_10_addr_2_reg_1420_pp1_iter2_reg;
    sc_signal< sc_lv<8> > sum_pix_ch0_10_addr_2_reg_1420_pp1_iter3_reg;
    sc_signal< sc_lv<8> > phitmp_10_reg_1426;
    sc_signal< sc_lv<8> > phitmp_10_reg_1426_pp1_iter2_reg;
    sc_signal< sc_lv<8> > sum_pix_ch0_11_addr_2_reg_1431;
    sc_signal< sc_lv<8> > sum_pix_ch0_11_addr_2_reg_1431_pp1_iter2_reg;
    sc_signal< sc_lv<8> > sum_pix_ch0_11_addr_2_reg_1431_pp1_iter3_reg;
    sc_signal< sc_lv<8> > phitmp_11_reg_1437;
    sc_signal< sc_lv<8> > phitmp_11_reg_1437_pp1_iter2_reg;
    sc_signal< sc_lv<8> > sum_pix_ch0_12_addr_2_reg_1442;
    sc_signal< sc_lv<8> > sum_pix_ch0_12_addr_2_reg_1442_pp1_iter2_reg;
    sc_signal< sc_lv<8> > sum_pix_ch0_12_addr_2_reg_1442_pp1_iter3_reg;
    sc_signal< sc_lv<8> > phitmp_12_reg_1448;
    sc_signal< sc_lv<8> > phitmp_12_reg_1448_pp1_iter2_reg;
    sc_signal< sc_lv<8> > sum_pix_ch0_13_addr_2_reg_1453;
    sc_signal< sc_lv<8> > sum_pix_ch0_13_addr_2_reg_1453_pp1_iter2_reg;
    sc_signal< sc_lv<8> > sum_pix_ch0_13_addr_2_reg_1453_pp1_iter3_reg;
    sc_signal< sc_lv<8> > phitmp_13_reg_1459;
    sc_signal< sc_lv<8> > phitmp_13_reg_1459_pp1_iter2_reg;
    sc_signal< sc_lv<8> > sum_pix_ch0_14_addr_2_reg_1464;
    sc_signal< sc_lv<8> > sum_pix_ch0_14_addr_2_reg_1464_pp1_iter2_reg;
    sc_signal< sc_lv<8> > sum_pix_ch0_14_addr_2_reg_1464_pp1_iter3_reg;
    sc_signal< sc_lv<8> > phitmp_14_reg_1470;
    sc_signal< sc_lv<8> > phitmp_14_reg_1470_pp1_iter2_reg;
    sc_signal< sc_lv<8> > sum_pix_ch0_15_addr_2_reg_1475;
    sc_signal< sc_lv<8> > sum_pix_ch0_15_addr_2_reg_1475_pp1_iter2_reg;
    sc_signal< sc_lv<8> > sum_pix_ch0_15_addr_2_reg_1475_pp1_iter3_reg;
    sc_signal< sc_lv<32> > sum_pix_ch0_0_q0;
    sc_signal< sc_lv<32> > sum_pix_ch0_0_load_1_reg_1481;
    sc_signal< sc_logic > ap_enable_reg_pp1_iter2;
    sc_signal< sc_lv<32> > sum_pix_ch0_1_q0;
    sc_signal< sc_lv<32> > sum_pix_ch0_1_load_1_reg_1486;
    sc_signal< sc_lv<32> > sum_pix_ch0_2_q0;
    sc_signal< sc_lv<32> > sum_pix_ch0_2_load_1_reg_1491;
    sc_signal< sc_lv<32> > sum_pix_ch0_3_q0;
    sc_signal< sc_lv<32> > sum_pix_ch0_3_load_1_reg_1496;
    sc_signal< sc_lv<32> > sum_pix_ch0_4_q0;
    sc_signal< sc_lv<32> > sum_pix_ch0_4_load_1_reg_1501;
    sc_signal< sc_lv<32> > sum_pix_ch0_5_q0;
    sc_signal< sc_lv<32> > sum_pix_ch0_5_load_1_reg_1506;
    sc_signal< sc_lv<32> > sum_pix_ch0_6_q0;
    sc_signal< sc_lv<32> > sum_pix_ch0_6_load_1_reg_1511;
    sc_signal< sc_lv<32> > sum_pix_ch0_7_q0;
    sc_signal< sc_lv<32> > sum_pix_ch0_7_load_1_reg_1516;
    sc_signal< sc_lv<32> > sum_pix_ch0_8_q0;
    sc_signal< sc_lv<32> > sum_pix_ch0_8_load_1_reg_1521;
    sc_signal< sc_lv<32> > sum_pix_ch0_9_q0;
    sc_signal< sc_lv<32> > sum_pix_ch0_9_load_1_reg_1526;
    sc_signal< sc_lv<32> > sum_pix_ch0_10_q0;
    sc_signal< sc_lv<32> > sum_pix_ch0_10_load_1_reg_1531;
    sc_signal< sc_lv<32> > sum_pix_ch0_11_q0;
    sc_signal< sc_lv<32> > sum_pix_ch0_11_load_1_reg_1536;
    sc_signal< sc_lv<32> > sum_pix_ch0_12_q0;
    sc_signal< sc_lv<32> > sum_pix_ch0_12_load_1_reg_1541;
    sc_signal< sc_lv<32> > sum_pix_ch0_13_q0;
    sc_signal< sc_lv<32> > sum_pix_ch0_13_load_1_reg_1546;
    sc_signal< sc_lv<32> > sum_pix_ch0_14_q0;
    sc_signal< sc_lv<32> > sum_pix_ch0_14_load_1_reg_1551;
    sc_signal< sc_lv<32> > sum_pix_ch0_15_q0;
    sc_signal< sc_lv<32> > sum_pix_ch0_15_load_1_reg_1556;
    sc_signal< sc_lv<32> > tmp_5_fu_1067_p2;
    sc_signal< sc_lv<32> > tmp_5_reg_1561;
    sc_signal< sc_lv<32> > tmp_21_1_fu_1075_p2;
    sc_signal< sc_lv<32> > tmp_21_1_reg_1566;
    sc_signal< sc_lv<32> > tmp_21_2_fu_1083_p2;
    sc_signal< sc_lv<32> > tmp_21_2_reg_1571;
    sc_signal< sc_lv<32> > tmp_21_3_fu_1091_p2;
    sc_signal< sc_lv<32> > tmp_21_3_reg_1576;
    sc_signal< sc_lv<32> > tmp_21_4_fu_1099_p2;
    sc_signal< sc_lv<32> > tmp_21_4_reg_1581;
    sc_signal< sc_lv<32> > tmp_21_5_fu_1107_p2;
    sc_signal< sc_lv<32> > tmp_21_5_reg_1586;
    sc_signal< sc_lv<32> > tmp_21_6_fu_1115_p2;
    sc_signal< sc_lv<32> > tmp_21_6_reg_1591;
    sc_signal< sc_lv<32> > tmp_21_7_fu_1123_p2;
    sc_signal< sc_lv<32> > tmp_21_7_reg_1596;
    sc_signal< sc_lv<32> > tmp_21_8_fu_1131_p2;
    sc_signal< sc_lv<32> > tmp_21_8_reg_1601;
    sc_signal< sc_lv<32> > tmp_21_9_fu_1139_p2;
    sc_signal< sc_lv<32> > tmp_21_9_reg_1606;
    sc_signal< sc_lv<32> > tmp_21_s_fu_1147_p2;
    sc_signal< sc_lv<32> > tmp_21_s_reg_1611;
    sc_signal< sc_lv<32> > tmp_21_10_fu_1155_p2;
    sc_signal< sc_lv<32> > tmp_21_10_reg_1616;
    sc_signal< sc_lv<32> > tmp_21_11_fu_1163_p2;
    sc_signal< sc_lv<32> > tmp_21_11_reg_1621;
    sc_signal< sc_lv<32> > tmp_21_12_fu_1171_p2;
    sc_signal< sc_lv<32> > tmp_21_12_reg_1626;
    sc_signal< sc_lv<32> > tmp_21_13_fu_1179_p2;
    sc_signal< sc_lv<32> > tmp_21_13_reg_1631;
    sc_signal< sc_lv<32> > tmp_21_14_fu_1187_p2;
    sc_signal< sc_lv<32> > tmp_21_14_reg_1636;
    sc_signal< sc_lv<1> > exitcond4_fu_1192_p2;
    sc_signal< bool > ap_block_state10_pp2_stage0_iter0;
    sc_signal< bool > ap_block_state11_pp2_stage0_iter1;
    sc_signal< bool > ap_block_state11_io;
    sc_signal< bool > ap_block_state12_pp2_stage0_iter2;
    sc_signal< bool > ap_block_state12_io;
    sc_signal< bool > ap_block_pp2_stage0_11001;
    sc_signal< sc_lv<8> > i_4_fu_1198_p2;
    sc_signal< sc_logic > ap_enable_reg_pp2_iter0;
    sc_signal< sc_lv<1> > tmp_last_V_fu_1204_p2;
    sc_signal< sc_lv<1> > tmp_last_V_reg_1650;
    sc_signal< sc_lv<512> > tmp_data_V_1_fu_1230_p17;
    sc_signal< bool > ap_block_pp1_stage0_subdone;
    sc_signal< sc_logic > ap_condition_pp1_exit_iter0_state4;
    sc_signal< sc_logic > ap_enable_reg_pp1_iter3;
    sc_signal< sc_logic > ap_enable_reg_pp1_iter4;
    sc_signal< sc_logic > ap_CS_fsm_state9;
    sc_signal< bool > ap_block_pp2_stage0_subdone;
    sc_signal< sc_logic > ap_condition_pp2_exit_iter0_state10;
    sc_signal< sc_lv<8> > sum_pix_ch0_0_address0;
    sc_signal< sc_logic > sum_pix_ch0_0_ce0;
    sc_signal< sc_logic > sum_pix_ch0_0_we0;
    sc_signal< sc_lv<8> > sum_pix_ch0_0_address1;
    sc_signal< sc_logic > sum_pix_ch0_0_ce1;
    sc_signal< sc_logic > sum_pix_ch0_0_we1;
    sc_signal< sc_lv<32> > sum_pix_ch0_0_q1;
    sc_signal< sc_lv<8> > sum_pix_ch0_1_address0;
    sc_signal< sc_logic > sum_pix_ch0_1_ce0;
    sc_signal< sc_logic > sum_pix_ch0_1_we0;
    sc_signal< sc_lv<8> > sum_pix_ch0_1_address1;
    sc_signal< sc_logic > sum_pix_ch0_1_ce1;
    sc_signal< sc_logic > sum_pix_ch0_1_we1;
    sc_signal< sc_lv<32> > sum_pix_ch0_1_q1;
    sc_signal< sc_lv<8> > sum_pix_ch0_2_address0;
    sc_signal< sc_logic > sum_pix_ch0_2_ce0;
    sc_signal< sc_logic > sum_pix_ch0_2_we0;
    sc_signal< sc_lv<8> > sum_pix_ch0_2_address1;
    sc_signal< sc_logic > sum_pix_ch0_2_ce1;
    sc_signal< sc_logic > sum_pix_ch0_2_we1;
    sc_signal< sc_lv<32> > sum_pix_ch0_2_q1;
    sc_signal< sc_lv<8> > sum_pix_ch0_3_address0;
    sc_signal< sc_logic > sum_pix_ch0_3_ce0;
    sc_signal< sc_logic > sum_pix_ch0_3_we0;
    sc_signal< sc_lv<8> > sum_pix_ch0_3_address1;
    sc_signal< sc_logic > sum_pix_ch0_3_ce1;
    sc_signal< sc_logic > sum_pix_ch0_3_we1;
    sc_signal< sc_lv<32> > sum_pix_ch0_3_q1;
    sc_signal< sc_lv<8> > sum_pix_ch0_4_address0;
    sc_signal< sc_logic > sum_pix_ch0_4_ce0;
    sc_signal< sc_logic > sum_pix_ch0_4_we0;
    sc_signal< sc_lv<8> > sum_pix_ch0_4_address1;
    sc_signal< sc_logic > sum_pix_ch0_4_ce1;
    sc_signal< sc_logic > sum_pix_ch0_4_we1;
    sc_signal< sc_lv<32> > sum_pix_ch0_4_q1;
    sc_signal< sc_lv<8> > sum_pix_ch0_5_address0;
    sc_signal< sc_logic > sum_pix_ch0_5_ce0;
    sc_signal< sc_logic > sum_pix_ch0_5_we0;
    sc_signal< sc_lv<8> > sum_pix_ch0_5_address1;
    sc_signal< sc_logic > sum_pix_ch0_5_ce1;
    sc_signal< sc_logic > sum_pix_ch0_5_we1;
    sc_signal< sc_lv<32> > sum_pix_ch0_5_q1;
    sc_signal< sc_lv<8> > sum_pix_ch0_6_address0;
    sc_signal< sc_logic > sum_pix_ch0_6_ce0;
    sc_signal< sc_logic > sum_pix_ch0_6_we0;
    sc_signal< sc_lv<8> > sum_pix_ch0_6_address1;
    sc_signal< sc_logic > sum_pix_ch0_6_ce1;
    sc_signal< sc_logic > sum_pix_ch0_6_we1;
    sc_signal< sc_lv<32> > sum_pix_ch0_6_q1;
    sc_signal< sc_lv<8> > sum_pix_ch0_7_address0;
    sc_signal< sc_logic > sum_pix_ch0_7_ce0;
    sc_signal< sc_logic > sum_pix_ch0_7_we0;
    sc_signal< sc_lv<8> > sum_pix_ch0_7_address1;
    sc_signal< sc_logic > sum_pix_ch0_7_ce1;
    sc_signal< sc_logic > sum_pix_ch0_7_we1;
    sc_signal< sc_lv<32> > sum_pix_ch0_7_q1;
    sc_signal< sc_lv<8> > sum_pix_ch0_8_address0;
    sc_signal< sc_logic > sum_pix_ch0_8_ce0;
    sc_signal< sc_logic > sum_pix_ch0_8_we0;
    sc_signal< sc_lv<8> > sum_pix_ch0_8_address1;
    sc_signal< sc_logic > sum_pix_ch0_8_ce1;
    sc_signal< sc_logic > sum_pix_ch0_8_we1;
    sc_signal< sc_lv<32> > sum_pix_ch0_8_q1;
    sc_signal< sc_lv<8> > sum_pix_ch0_9_address0;
    sc_signal< sc_logic > sum_pix_ch0_9_ce0;
    sc_signal< sc_logic > sum_pix_ch0_9_we0;
    sc_signal< sc_lv<8> > sum_pix_ch0_9_address1;
    sc_signal< sc_logic > sum_pix_ch0_9_ce1;
    sc_signal< sc_logic > sum_pix_ch0_9_we1;
    sc_signal< sc_lv<32> > sum_pix_ch0_9_q1;
    sc_signal< sc_lv<8> > sum_pix_ch0_10_address0;
    sc_signal< sc_logic > sum_pix_ch0_10_ce0;
    sc_signal< sc_logic > sum_pix_ch0_10_we0;
    sc_signal< sc_lv<8> > sum_pix_ch0_10_address1;
    sc_signal< sc_logic > sum_pix_ch0_10_ce1;
    sc_signal< sc_logic > sum_pix_ch0_10_we1;
    sc_signal< sc_lv<32> > sum_pix_ch0_10_q1;
    sc_signal< sc_lv<8> > sum_pix_ch0_11_address0;
    sc_signal< sc_logic > sum_pix_ch0_11_ce0;
    sc_signal< sc_logic > sum_pix_ch0_11_we0;
    sc_signal< sc_lv<8> > sum_pix_ch0_11_address1;
    sc_signal< sc_logic > sum_pix_ch0_11_ce1;
    sc_signal< sc_logic > sum_pix_ch0_11_we1;
    sc_signal< sc_lv<32> > sum_pix_ch0_11_q1;
    sc_signal< sc_lv<8> > sum_pix_ch0_12_address0;
    sc_signal< sc_logic > sum_pix_ch0_12_ce0;
    sc_signal< sc_logic > sum_pix_ch0_12_we0;
    sc_signal< sc_lv<8> > sum_pix_ch0_12_address1;
    sc_signal< sc_logic > sum_pix_ch0_12_ce1;
    sc_signal< sc_logic > sum_pix_ch0_12_we1;
    sc_signal< sc_lv<32> > sum_pix_ch0_12_q1;
    sc_signal< sc_lv<8> > sum_pix_ch0_13_address0;
    sc_signal< sc_logic > sum_pix_ch0_13_ce0;
    sc_signal< sc_logic > sum_pix_ch0_13_we0;
    sc_signal< sc_lv<8> > sum_pix_ch0_13_address1;
    sc_signal< sc_logic > sum_pix_ch0_13_ce1;
    sc_signal< sc_logic > sum_pix_ch0_13_we1;
    sc_signal< sc_lv<32> > sum_pix_ch0_13_q1;
    sc_signal< sc_lv<8> > sum_pix_ch0_14_address0;
    sc_signal< sc_logic > sum_pix_ch0_14_ce0;
    sc_signal< sc_logic > sum_pix_ch0_14_we0;
    sc_signal< sc_lv<8> > sum_pix_ch0_14_address1;
    sc_signal< sc_logic > sum_pix_ch0_14_ce1;
    sc_signal< sc_logic > sum_pix_ch0_14_we1;
    sc_signal< sc_lv<32> > sum_pix_ch0_14_q1;
    sc_signal< sc_lv<8> > sum_pix_ch0_15_address0;
    sc_signal< sc_logic > sum_pix_ch0_15_ce0;
    sc_signal< sc_logic > sum_pix_ch0_15_we0;
    sc_signal< sc_lv<8> > sum_pix_ch0_15_address1;
    sc_signal< sc_logic > sum_pix_ch0_15_ce1;
    sc_signal< sc_logic > sum_pix_ch0_15_we1;
    sc_signal< sc_lv<32> > sum_pix_ch0_15_q1;
    sc_signal< sc_lv<8> > i_reg_752;
    sc_signal< sc_lv<1> > exitcond1_fu_796_p2;
    sc_signal< sc_lv<64> > tmp_1_fu_808_p1;
    sc_signal< sc_lv<64> > tmp_8_fu_887_p1;
    sc_signal< sc_lv<64> > tmp_6_fu_1210_p1;
    sc_signal< bool > ap_block_pp2_stage0_01001;
    sc_signal< sc_lv<23> > tmp_fu_828_p3;
    sc_signal< sc_lv<20> > tmp_7_fu_839_p3;
    sc_signal< sc_lv<24> > p_shl_fu_835_p1;
    sc_signal< sc_lv<24> > p_shl2_fu_846_p1;
    sc_signal< sc_lv<1> > exitcond_fu_867_p2;
    sc_signal< sc_lv<32> > tmp_s_fu_1064_p1;
    sc_signal< sc_lv<32> > tmp_20_1_fu_1072_p1;
    sc_signal< sc_lv<32> > tmp_20_2_fu_1080_p1;
    sc_signal< sc_lv<32> > tmp_20_3_fu_1088_p1;
    sc_signal< sc_lv<32> > tmp_20_4_fu_1096_p1;
    sc_signal< sc_lv<32> > tmp_20_5_fu_1104_p1;
    sc_signal< sc_lv<32> > tmp_20_6_fu_1112_p1;
    sc_signal< sc_lv<32> > tmp_20_7_fu_1120_p1;
    sc_signal< sc_lv<32> > tmp_20_8_fu_1128_p1;
    sc_signal< sc_lv<32> > tmp_20_9_fu_1136_p1;
    sc_signal< sc_lv<32> > tmp_20_s_fu_1144_p1;
    sc_signal< sc_lv<32> > tmp_20_10_fu_1152_p1;
    sc_signal< sc_lv<32> > tmp_20_11_fu_1160_p1;
    sc_signal< sc_lv<32> > tmp_20_12_fu_1168_p1;
    sc_signal< sc_lv<32> > tmp_20_13_fu_1176_p1;
    sc_signal< sc_lv<32> > tmp_20_14_fu_1184_p1;
    sc_signal< sc_logic > ap_CS_fsm_state13;
    sc_signal< bool > ap_block_state13;
    sc_signal< sc_lv<7> > ap_NS_fsm;
    sc_signal< sc_logic > ap_idle_pp1;
    sc_signal< sc_logic > ap_enable_pp1;
    sc_signal< sc_logic > ap_idle_pp2;
    sc_signal< sc_logic > ap_enable_pp2;
    static const sc_logic ap_const_logic_1;
    static const sc_logic ap_const_logic_0;
    static const sc_lv<7> ap_ST_fsm_state1;
    static const sc_lv<7> ap_ST_fsm_state2;
    static const sc_lv<7> ap_ST_fsm_state3;
    static const sc_lv<7> ap_ST_fsm_pp1_stage0;
    static const sc_lv<7> ap_ST_fsm_state9;
    static const sc_lv<7> ap_ST_fsm_pp2_stage0;
    static const sc_lv<7> ap_ST_fsm_state13;
    static const sc_lv<32> ap_const_lv32_0;
    static const bool ap_const_boolean_1;
    static const sc_lv<1> ap_const_lv1_0;
    static const sc_lv<1> ap_const_lv1_1;
    static const sc_lv<2> ap_const_lv2_0;
    static const sc_lv<2> ap_const_lv2_2;
    static const sc_lv<2> ap_const_lv2_3;
    static const sc_lv<2> ap_const_lv2_1;
    static const sc_lv<32> ap_const_lv32_3;
    static const bool ap_const_boolean_0;
    static const sc_lv<32> ap_const_lv32_5;
    static const int C_S_AXI_DATA_WIDTH;
    static const sc_lv<32> ap_const_lv32_1;
    static const sc_lv<32> ap_const_lv32_2;
    static const sc_lv<32> ap_const_lv32_4;
    static const sc_lv<8> ap_const_lv8_0;
    static const sc_lv<24> ap_const_lv24_0;
    static const sc_lv<64> ap_const_lv64_FFFFFFFFFFFFFFFF;
    static const sc_lv<6> ap_const_lv6_0;
    static const sc_lv<5> ap_const_lv5_0;
    static const sc_lv<8> ap_const_lv8_90;
    static const sc_lv<8> ap_const_lv8_1;
    static const sc_lv<7> ap_const_lv7_0;
    static const sc_lv<4> ap_const_lv4_0;
    static const sc_lv<24> ap_const_lv24_1;
    static const sc_lv<32> ap_const_lv32_8;
    static const sc_lv<32> ap_const_lv32_F;
    static const sc_lv<32> ap_const_lv32_10;
    static const sc_lv<32> ap_const_lv32_17;
    static const sc_lv<32> ap_const_lv32_18;
    static const sc_lv<32> ap_const_lv32_1F;
    static const sc_lv<32> ap_const_lv32_20;
    static const sc_lv<32> ap_const_lv32_27;
    static const sc_lv<32> ap_const_lv32_28;
    static const sc_lv<32> ap_const_lv32_2F;
    static const sc_lv<32> ap_const_lv32_30;
    static const sc_lv<32> ap_const_lv32_37;
    static const sc_lv<32> ap_const_lv32_38;
    static const sc_lv<32> ap_const_lv32_3F;
    static const sc_lv<32> ap_const_lv32_40;
    static const sc_lv<32> ap_const_lv32_47;
    static const sc_lv<32> ap_const_lv32_48;
    static const sc_lv<32> ap_const_lv32_4F;
    static const sc_lv<32> ap_const_lv32_50;
    static const sc_lv<32> ap_const_lv32_57;
    static const sc_lv<32> ap_const_lv32_58;
    static const sc_lv<32> ap_const_lv32_5F;
    static const sc_lv<32> ap_const_lv32_60;
    static const sc_lv<32> ap_const_lv32_67;
    static const sc_lv<32> ap_const_lv32_68;
    static const sc_lv<32> ap_const_lv32_6F;
    static const sc_lv<32> ap_const_lv32_70;
    static const sc_lv<32> ap_const_lv32_77;
    static const sc_lv<32> ap_const_lv32_78;
    static const sc_lv<32> ap_const_lv32_7F;
    static const sc_lv<8> ap_const_lv8_8F;
    static const sc_lv<32> ap_const_lv32_6;
    // Thread declarations
    void thread_ap_var_for_const0();
    void thread_ap_var_for_const1();
    void thread_ap_clk_no_reset_();
    void thread_ap_CS_fsm_pp1_stage0();
    void thread_ap_CS_fsm_pp2_stage0();
    void thread_ap_CS_fsm_state1();
    void thread_ap_CS_fsm_state13();
    void thread_ap_CS_fsm_state2();
    void thread_ap_CS_fsm_state3();
    void thread_ap_CS_fsm_state9();
    void thread_ap_block_pp1_stage0();
    void thread_ap_block_pp1_stage0_11001();
    void thread_ap_block_pp1_stage0_subdone();
    void thread_ap_block_pp2_stage0();
    void thread_ap_block_pp2_stage0_01001();
    void thread_ap_block_pp2_stage0_11001();
    void thread_ap_block_pp2_stage0_subdone();
    void thread_ap_block_state10_pp2_stage0_iter0();
    void thread_ap_block_state11_io();
    void thread_ap_block_state11_pp2_stage0_iter1();
    void thread_ap_block_state12_io();
    void thread_ap_block_state12_pp2_stage0_iter2();
    void thread_ap_block_state13();
    void thread_ap_block_state4_pp1_stage0_iter0();
    void thread_ap_block_state5_pp1_stage0_iter1();
    void thread_ap_block_state6_pp1_stage0_iter2();
    void thread_ap_block_state7_pp1_stage0_iter3();
    void thread_ap_block_state8_pp1_stage0_iter4();
    void thread_ap_condition_pp1_exit_iter0_state4();
    void thread_ap_condition_pp2_exit_iter0_state10();
    void thread_ap_done();
    void thread_ap_enable_pp1();
    void thread_ap_enable_pp2();
    void thread_ap_idle();
    void thread_ap_idle_pp1();
    void thread_ap_idle_pp2();
    void thread_ap_ready();
    void thread_ap_rst_n_inv();
    void thread_bound_fu_850_p2();
    void thread_exitcond1_fu_796_p2();
    void thread_exitcond4_fu_1192_p2();
    void thread_exitcond_flatten_fu_856_p2();
    void thread_exitcond_fu_867_p2();
    void thread_i_1_mid2_fu_873_p3();
    void thread_i_3_fu_802_p2();
    void thread_i_4_fu_1198_p2();
    void thread_i_5_fu_881_p2();
    void thread_in_stream0_TDATA_blk_n();
    void thread_in_stream0_TREADY();
    void thread_in_stream0_V_data_V_0_ack_in();
    void thread_in_stream0_V_data_V_0_ack_out();
    void thread_in_stream0_V_data_V_0_data_out();
    void thread_in_stream0_V_data_V_0_load_A();
    void thread_in_stream0_V_data_V_0_load_B();
    void thread_in_stream0_V_data_V_0_sel();
    void thread_in_stream0_V_data_V_0_state_cmp_full();
    void thread_in_stream0_V_data_V_0_vld_in();
    void thread_in_stream0_V_data_V_0_vld_out();
    void thread_in_stream0_V_dest_V_0_ack_out();
    void thread_in_stream0_V_dest_V_0_vld_in();
    void thread_indvar_flatten_next_fu_861_p2();
    void thread_out_stream_TDATA();
    void thread_out_stream_TDATA_blk_n();
    void thread_out_stream_TDEST();
    void thread_out_stream_TID();
    void thread_out_stream_TKEEP();
    void thread_out_stream_TLAST();
    void thread_out_stream_TSTRB();
    void thread_out_stream_TUSER();
    void thread_out_stream_TVALID();
    void thread_out_stream_V_data_V_1_ack_in();
    void thread_out_stream_V_data_V_1_ack_out();
    void thread_out_stream_V_data_V_1_data_out();
    void thread_out_stream_V_data_V_1_load_A();
    void thread_out_stream_V_data_V_1_load_B();
    void thread_out_stream_V_data_V_1_sel();
    void thread_out_stream_V_data_V_1_state_cmp_full();
    void thread_out_stream_V_data_V_1_vld_in();
    void thread_out_stream_V_data_V_1_vld_out();
    void thread_out_stream_V_dest_V_1_ack_in();
    void thread_out_stream_V_dest_V_1_ack_out();
    void thread_out_stream_V_dest_V_1_data_out();
    void thread_out_stream_V_dest_V_1_sel();
    void thread_out_stream_V_dest_V_1_vld_in();
    void thread_out_stream_V_dest_V_1_vld_out();
    void thread_out_stream_V_id_V_1_ack_in();
    void thread_out_stream_V_id_V_1_ack_out();
    void thread_out_stream_V_id_V_1_data_out();
    void thread_out_stream_V_id_V_1_sel();
    void thread_out_stream_V_id_V_1_vld_in();
    void thread_out_stream_V_id_V_1_vld_out();
    void thread_out_stream_V_keep_V_1_ack_in();
    void thread_out_stream_V_keep_V_1_ack_out();
    void thread_out_stream_V_keep_V_1_data_out();
    void thread_out_stream_V_keep_V_1_sel();
    void thread_out_stream_V_keep_V_1_vld_in();
    void thread_out_stream_V_keep_V_1_vld_out();
    void thread_out_stream_V_last_V_1_ack_in();
    void thread_out_stream_V_last_V_1_ack_out();
    void thread_out_stream_V_last_V_1_data_out();
    void thread_out_stream_V_last_V_1_load_A();
    void thread_out_stream_V_last_V_1_load_B();
    void thread_out_stream_V_last_V_1_sel();
    void thread_out_stream_V_last_V_1_state_cmp_full();
    void thread_out_stream_V_last_V_1_vld_in();
    void thread_out_stream_V_last_V_1_vld_out();
    void thread_out_stream_V_strb_V_1_ack_in();
    void thread_out_stream_V_strb_V_1_ack_out();
    void thread_out_stream_V_strb_V_1_data_out();
    void thread_out_stream_V_strb_V_1_sel();
    void thread_out_stream_V_strb_V_1_vld_in();
    void thread_out_stream_V_strb_V_1_vld_out();
    void thread_out_stream_V_user_V_1_ack_in();
    void thread_out_stream_V_user_V_1_ack_out();
    void thread_out_stream_V_user_V_1_data_out();
    void thread_out_stream_V_user_V_1_sel();
    void thread_out_stream_V_user_V_1_vld_in();
    void thread_out_stream_V_user_V_1_vld_out();
    void thread_p_shl2_fu_846_p1();
    void thread_p_shl_fu_835_p1();
    void thread_sum_pix_ch0_0_address0();
    void thread_sum_pix_ch0_0_address1();
    void thread_sum_pix_ch0_0_ce0();
    void thread_sum_pix_ch0_0_ce1();
    void thread_sum_pix_ch0_0_we0();
    void thread_sum_pix_ch0_0_we1();
    void thread_sum_pix_ch0_10_address0();
    void thread_sum_pix_ch0_10_address1();
    void thread_sum_pix_ch0_10_ce0();
    void thread_sum_pix_ch0_10_ce1();
    void thread_sum_pix_ch0_10_we0();
    void thread_sum_pix_ch0_10_we1();
    void thread_sum_pix_ch0_11_address0();
    void thread_sum_pix_ch0_11_address1();
    void thread_sum_pix_ch0_11_ce0();
    void thread_sum_pix_ch0_11_ce1();
    void thread_sum_pix_ch0_11_we0();
    void thread_sum_pix_ch0_11_we1();
    void thread_sum_pix_ch0_12_address0();
    void thread_sum_pix_ch0_12_address1();
    void thread_sum_pix_ch0_12_ce0();
    void thread_sum_pix_ch0_12_ce1();
    void thread_sum_pix_ch0_12_we0();
    void thread_sum_pix_ch0_12_we1();
    void thread_sum_pix_ch0_13_address0();
    void thread_sum_pix_ch0_13_address1();
    void thread_sum_pix_ch0_13_ce0();
    void thread_sum_pix_ch0_13_ce1();
    void thread_sum_pix_ch0_13_we0();
    void thread_sum_pix_ch0_13_we1();
    void thread_sum_pix_ch0_14_address0();
    void thread_sum_pix_ch0_14_address1();
    void thread_sum_pix_ch0_14_ce0();
    void thread_sum_pix_ch0_14_ce1();
    void thread_sum_pix_ch0_14_we0();
    void thread_sum_pix_ch0_14_we1();
    void thread_sum_pix_ch0_15_address0();
    void thread_sum_pix_ch0_15_address1();
    void thread_sum_pix_ch0_15_ce0();
    void thread_sum_pix_ch0_15_ce1();
    void thread_sum_pix_ch0_15_we0();
    void thread_sum_pix_ch0_15_we1();
    void thread_sum_pix_ch0_1_address0();
    void thread_sum_pix_ch0_1_address1();
    void thread_sum_pix_ch0_1_ce0();
    void thread_sum_pix_ch0_1_ce1();
    void thread_sum_pix_ch0_1_we0();
    void thread_sum_pix_ch0_1_we1();
    void thread_sum_pix_ch0_2_address0();
    void thread_sum_pix_ch0_2_address1();
    void thread_sum_pix_ch0_2_ce0();
    void thread_sum_pix_ch0_2_ce1();
    void thread_sum_pix_ch0_2_we0();
    void thread_sum_pix_ch0_2_we1();
    void thread_sum_pix_ch0_3_address0();
    void thread_sum_pix_ch0_3_address1();
    void thread_sum_pix_ch0_3_ce0();
    void thread_sum_pix_ch0_3_ce1();
    void thread_sum_pix_ch0_3_we0();
    void thread_sum_pix_ch0_3_we1();
    void thread_sum_pix_ch0_4_address0();
    void thread_sum_pix_ch0_4_address1();
    void thread_sum_pix_ch0_4_ce0();
    void thread_sum_pix_ch0_4_ce1();
    void thread_sum_pix_ch0_4_we0();
    void thread_sum_pix_ch0_4_we1();
    void thread_sum_pix_ch0_5_address0();
    void thread_sum_pix_ch0_5_address1();
    void thread_sum_pix_ch0_5_ce0();
    void thread_sum_pix_ch0_5_ce1();
    void thread_sum_pix_ch0_5_we0();
    void thread_sum_pix_ch0_5_we1();
    void thread_sum_pix_ch0_6_address0();
    void thread_sum_pix_ch0_6_address1();
    void thread_sum_pix_ch0_6_ce0();
    void thread_sum_pix_ch0_6_ce1();
    void thread_sum_pix_ch0_6_we0();
    void thread_sum_pix_ch0_6_we1();
    void thread_sum_pix_ch0_7_address0();
    void thread_sum_pix_ch0_7_address1();
    void thread_sum_pix_ch0_7_ce0();
    void thread_sum_pix_ch0_7_ce1();
    void thread_sum_pix_ch0_7_we0();
    void thread_sum_pix_ch0_7_we1();
    void thread_sum_pix_ch0_8_address0();
    void thread_sum_pix_ch0_8_address1();
    void thread_sum_pix_ch0_8_ce0();
    void thread_sum_pix_ch0_8_ce1();
    void thread_sum_pix_ch0_8_we0();
    void thread_sum_pix_ch0_8_we1();
    void thread_sum_pix_ch0_9_address0();
    void thread_sum_pix_ch0_9_address1();
    void thread_sum_pix_ch0_9_ce0();
    void thread_sum_pix_ch0_9_ce1();
    void thread_sum_pix_ch0_9_we0();
    void thread_sum_pix_ch0_9_we1();
    void thread_tmp_1_fu_808_p1();
    void thread_tmp_20_10_fu_1152_p1();
    void thread_tmp_20_11_fu_1160_p1();
    void thread_tmp_20_12_fu_1168_p1();
    void thread_tmp_20_13_fu_1176_p1();
    void thread_tmp_20_14_fu_1184_p1();
    void thread_tmp_20_1_fu_1072_p1();
    void thread_tmp_20_2_fu_1080_p1();
    void thread_tmp_20_3_fu_1088_p1();
    void thread_tmp_20_4_fu_1096_p1();
    void thread_tmp_20_5_fu_1104_p1();
    void thread_tmp_20_6_fu_1112_p1();
    void thread_tmp_20_7_fu_1120_p1();
    void thread_tmp_20_8_fu_1128_p1();
    void thread_tmp_20_9_fu_1136_p1();
    void thread_tmp_20_s_fu_1144_p1();
    void thread_tmp_21_10_fu_1155_p2();
    void thread_tmp_21_11_fu_1163_p2();
    void thread_tmp_21_12_fu_1171_p2();
    void thread_tmp_21_13_fu_1179_p2();
    void thread_tmp_21_14_fu_1187_p2();
    void thread_tmp_21_1_fu_1075_p2();
    void thread_tmp_21_2_fu_1083_p2();
    void thread_tmp_21_3_fu_1091_p2();
    void thread_tmp_21_4_fu_1099_p2();
    void thread_tmp_21_5_fu_1107_p2();
    void thread_tmp_21_6_fu_1115_p2();
    void thread_tmp_21_7_fu_1123_p2();
    void thread_tmp_21_8_fu_1131_p2();
    void thread_tmp_21_9_fu_1139_p2();
    void thread_tmp_21_s_fu_1147_p2();
    void thread_tmp_5_fu_1067_p2();
    void thread_tmp_6_fu_1210_p1();
    void thread_tmp_7_fu_839_p3();
    void thread_tmp_8_fu_887_p1();
    void thread_tmp_9_fu_910_p1();
    void thread_tmp_data_V_1_fu_1230_p17();
    void thread_tmp_fu_828_p3();
    void thread_tmp_last_V_fu_1204_p2();
    void thread_tmp_s_fu_1064_p1();
    void thread_ap_NS_fsm();
    void thread_hdltv_gen();
};

}

using namespace ap_rtl;

#endif
