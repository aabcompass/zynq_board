// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
// Version: 2018.1
// Copyright (C) 1986-2018 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

#ifndef _scurve_adder_HH_
#define _scurve_adder_HH_

#include "systemc.h"
#include "AESL_pkg.h"

#include "scurve_adder_sum_bkb.h"
#include "scurve_adder_dub_dEe.h"
#include "scurve_adder_dub_eOg.h"
#include "scurve_adder_dub_fYi.h"
#include "scurve_adder_CTRL_BUS_s_axi.h"

namespace ap_rtl {

template<unsigned int C_S_AXI_CTRL_BUS_ADDR_WIDTH = 5,
         unsigned int C_S_AXI_CTRL_BUS_DATA_WIDTH = 32>
struct scurve_adder : public sc_module {
    // Port declarations 38
    sc_in_clk ap_clk;
    sc_in< sc_logic > ap_rst_n;
    sc_in< sc_lv<16> > in_stream0_TDATA;
    sc_in< sc_logic > in_stream0_TVALID;
    sc_out< sc_logic > in_stream0_TREADY;
    sc_in< sc_lv<2> > in_stream0_TKEEP;
    sc_in< sc_lv<2> > in_stream0_TSTRB;
    sc_in< sc_lv<2> > in_stream0_TUSER;
    sc_in< sc_lv<1> > in_stream0_TLAST;
    sc_in< sc_lv<5> > in_stream0_TID;
    sc_in< sc_lv<6> > in_stream0_TDEST;
    sc_out< sc_lv<64> > out_stream_TDATA;
    sc_out< sc_logic > out_stream_TVALID;
    sc_in< sc_logic > out_stream_TREADY;
    sc_out< sc_lv<8> > out_stream_TKEEP;
    sc_out< sc_lv<8> > out_stream_TSTRB;
    sc_out< sc_lv<2> > out_stream_TUSER;
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
    scurve_adder(sc_module_name name);
    SC_HAS_PROCESS(scurve_adder);

    ~scurve_adder();

    sc_trace_file* mVcdFile;

    ofstream mHdltvinHandle;
    ofstream mHdltvoutHandle;
    scurve_adder_CTRL_BUS_s_axi<C_S_AXI_CTRL_BUS_ADDR_WIDTH,C_S_AXI_CTRL_BUS_DATA_WIDTH>* scurve_adder_CTRL_BUS_s_axi_U;
    scurve_adder_sum_bkb* sum_pix1_ch0_U;
    scurve_adder_sum_bkb* sum_pix2_ch0_U;
    scurve_adder_dub_dEe* dub_pix_ch0_user_V_U;
    scurve_adder_dub_eOg* dub_pix_ch0_id_V_U;
    scurve_adder_dub_fYi* dub_pix_ch0_dest_V_U;
    sc_signal< sc_logic > ap_rst_n_inv;
    sc_signal< sc_logic > ap_start;
    sc_signal< sc_logic > ap_done;
    sc_signal< sc_logic > ap_idle;
    sc_signal< sc_lv<8> > ap_CS_fsm;
    sc_signal< sc_logic > ap_CS_fsm_state1;
    sc_signal< sc_logic > ap_ready;
    sc_signal< sc_lv<16> > in_stream0_V_data_V_0_data_out;
    sc_signal< sc_logic > in_stream0_V_data_V_0_vld_in;
    sc_signal< sc_logic > in_stream0_V_data_V_0_vld_out;
    sc_signal< sc_logic > in_stream0_V_data_V_0_ack_in;
    sc_signal< sc_logic > in_stream0_V_data_V_0_ack_out;
    sc_signal< sc_lv<16> > in_stream0_V_data_V_0_payload_A;
    sc_signal< sc_lv<16> > in_stream0_V_data_V_0_payload_B;
    sc_signal< sc_logic > in_stream0_V_data_V_0_sel_rd;
    sc_signal< sc_logic > in_stream0_V_data_V_0_sel_wr;
    sc_signal< sc_logic > in_stream0_V_data_V_0_sel;
    sc_signal< sc_logic > in_stream0_V_data_V_0_load_A;
    sc_signal< sc_logic > in_stream0_V_data_V_0_load_B;
    sc_signal< sc_lv<2> > in_stream0_V_data_V_0_state;
    sc_signal< sc_logic > in_stream0_V_data_V_0_state_cmp_full;
    sc_signal< sc_lv<2> > in_stream0_V_user_V_0_data_out;
    sc_signal< sc_logic > in_stream0_V_user_V_0_vld_in;
    sc_signal< sc_logic > in_stream0_V_user_V_0_vld_out;
    sc_signal< sc_logic > in_stream0_V_user_V_0_ack_in;
    sc_signal< sc_logic > in_stream0_V_user_V_0_ack_out;
    sc_signal< sc_lv<2> > in_stream0_V_user_V_0_payload_A;
    sc_signal< sc_lv<2> > in_stream0_V_user_V_0_payload_B;
    sc_signal< sc_logic > in_stream0_V_user_V_0_sel_rd;
    sc_signal< sc_logic > in_stream0_V_user_V_0_sel_wr;
    sc_signal< sc_logic > in_stream0_V_user_V_0_sel;
    sc_signal< sc_logic > in_stream0_V_user_V_0_load_A;
    sc_signal< sc_logic > in_stream0_V_user_V_0_load_B;
    sc_signal< sc_lv<2> > in_stream0_V_user_V_0_state;
    sc_signal< sc_logic > in_stream0_V_user_V_0_state_cmp_full;
    sc_signal< sc_lv<5> > in_stream0_V_id_V_0_data_out;
    sc_signal< sc_logic > in_stream0_V_id_V_0_vld_in;
    sc_signal< sc_logic > in_stream0_V_id_V_0_vld_out;
    sc_signal< sc_logic > in_stream0_V_id_V_0_ack_in;
    sc_signal< sc_logic > in_stream0_V_id_V_0_ack_out;
    sc_signal< sc_lv<5> > in_stream0_V_id_V_0_payload_A;
    sc_signal< sc_lv<5> > in_stream0_V_id_V_0_payload_B;
    sc_signal< sc_logic > in_stream0_V_id_V_0_sel_rd;
    sc_signal< sc_logic > in_stream0_V_id_V_0_sel_wr;
    sc_signal< sc_logic > in_stream0_V_id_V_0_sel;
    sc_signal< sc_logic > in_stream0_V_id_V_0_load_A;
    sc_signal< sc_logic > in_stream0_V_id_V_0_load_B;
    sc_signal< sc_lv<2> > in_stream0_V_id_V_0_state;
    sc_signal< sc_logic > in_stream0_V_id_V_0_state_cmp_full;
    sc_signal< sc_lv<6> > in_stream0_V_dest_V_0_data_out;
    sc_signal< sc_logic > in_stream0_V_dest_V_0_vld_in;
    sc_signal< sc_logic > in_stream0_V_dest_V_0_vld_out;
    sc_signal< sc_logic > in_stream0_V_dest_V_0_ack_in;
    sc_signal< sc_logic > in_stream0_V_dest_V_0_ack_out;
    sc_signal< sc_lv<6> > in_stream0_V_dest_V_0_payload_A;
    sc_signal< sc_lv<6> > in_stream0_V_dest_V_0_payload_B;
    sc_signal< sc_logic > in_stream0_V_dest_V_0_sel_rd;
    sc_signal< sc_logic > in_stream0_V_dest_V_0_sel_wr;
    sc_signal< sc_logic > in_stream0_V_dest_V_0_sel;
    sc_signal< sc_logic > in_stream0_V_dest_V_0_load_A;
    sc_signal< sc_logic > in_stream0_V_dest_V_0_load_B;
    sc_signal< sc_lv<2> > in_stream0_V_dest_V_0_state;
    sc_signal< sc_logic > in_stream0_V_dest_V_0_state_cmp_full;
    sc_signal< sc_lv<64> > out_stream_V_data_V_1_data_out;
    sc_signal< sc_logic > out_stream_V_data_V_1_vld_in;
    sc_signal< sc_logic > out_stream_V_data_V_1_vld_out;
    sc_signal< sc_logic > out_stream_V_data_V_1_ack_in;
    sc_signal< sc_logic > out_stream_V_data_V_1_ack_out;
    sc_signal< sc_lv<64> > out_stream_V_data_V_1_payload_A;
    sc_signal< sc_lv<64> > out_stream_V_data_V_1_payload_B;
    sc_signal< sc_logic > out_stream_V_data_V_1_sel_rd;
    sc_signal< sc_logic > out_stream_V_data_V_1_sel_wr;
    sc_signal< sc_logic > out_stream_V_data_V_1_sel;
    sc_signal< sc_logic > out_stream_V_data_V_1_load_A;
    sc_signal< sc_logic > out_stream_V_data_V_1_load_B;
    sc_signal< sc_lv<2> > out_stream_V_data_V_1_state;
    sc_signal< sc_logic > out_stream_V_data_V_1_state_cmp_full;
    sc_signal< sc_lv<8> > out_stream_V_keep_V_1_data_out;
    sc_signal< sc_logic > out_stream_V_keep_V_1_vld_in;
    sc_signal< sc_logic > out_stream_V_keep_V_1_vld_out;
    sc_signal< sc_logic > out_stream_V_keep_V_1_ack_in;
    sc_signal< sc_logic > out_stream_V_keep_V_1_ack_out;
    sc_signal< sc_logic > out_stream_V_keep_V_1_sel_rd;
    sc_signal< sc_logic > out_stream_V_keep_V_1_sel;
    sc_signal< sc_lv<2> > out_stream_V_keep_V_1_state;
    sc_signal< sc_lv<8> > out_stream_V_strb_V_1_data_out;
    sc_signal< sc_logic > out_stream_V_strb_V_1_vld_in;
    sc_signal< sc_logic > out_stream_V_strb_V_1_vld_out;
    sc_signal< sc_logic > out_stream_V_strb_V_1_ack_in;
    sc_signal< sc_logic > out_stream_V_strb_V_1_ack_out;
    sc_signal< sc_logic > out_stream_V_strb_V_1_sel_rd;
    sc_signal< sc_logic > out_stream_V_strb_V_1_sel;
    sc_signal< sc_lv<2> > out_stream_V_strb_V_1_state;
    sc_signal< sc_lv<2> > out_stream_V_user_V_1_data_out;
    sc_signal< sc_logic > out_stream_V_user_V_1_vld_in;
    sc_signal< sc_logic > out_stream_V_user_V_1_vld_out;
    sc_signal< sc_logic > out_stream_V_user_V_1_ack_in;
    sc_signal< sc_logic > out_stream_V_user_V_1_ack_out;
    sc_signal< sc_lv<2> > out_stream_V_user_V_1_payload_A;
    sc_signal< sc_lv<2> > out_stream_V_user_V_1_payload_B;
    sc_signal< sc_logic > out_stream_V_user_V_1_sel_rd;
    sc_signal< sc_logic > out_stream_V_user_V_1_sel_wr;
    sc_signal< sc_logic > out_stream_V_user_V_1_sel;
    sc_signal< sc_logic > out_stream_V_user_V_1_load_A;
    sc_signal< sc_logic > out_stream_V_user_V_1_load_B;
    sc_signal< sc_lv<2> > out_stream_V_user_V_1_state;
    sc_signal< sc_logic > out_stream_V_user_V_1_state_cmp_full;
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
    sc_signal< sc_lv<5> > out_stream_V_id_V_1_payload_A;
    sc_signal< sc_lv<5> > out_stream_V_id_V_1_payload_B;
    sc_signal< sc_logic > out_stream_V_id_V_1_sel_rd;
    sc_signal< sc_logic > out_stream_V_id_V_1_sel_wr;
    sc_signal< sc_logic > out_stream_V_id_V_1_sel;
    sc_signal< sc_logic > out_stream_V_id_V_1_load_A;
    sc_signal< sc_logic > out_stream_V_id_V_1_load_B;
    sc_signal< sc_lv<2> > out_stream_V_id_V_1_state;
    sc_signal< sc_logic > out_stream_V_id_V_1_state_cmp_full;
    sc_signal< sc_lv<6> > out_stream_V_dest_V_1_data_out;
    sc_signal< sc_logic > out_stream_V_dest_V_1_vld_in;
    sc_signal< sc_logic > out_stream_V_dest_V_1_vld_out;
    sc_signal< sc_logic > out_stream_V_dest_V_1_ack_in;
    sc_signal< sc_logic > out_stream_V_dest_V_1_ack_out;
    sc_signal< sc_lv<6> > out_stream_V_dest_V_1_payload_A;
    sc_signal< sc_lv<6> > out_stream_V_dest_V_1_payload_B;
    sc_signal< sc_logic > out_stream_V_dest_V_1_sel_rd;
    sc_signal< sc_logic > out_stream_V_dest_V_1_sel_wr;
    sc_signal< sc_logic > out_stream_V_dest_V_1_sel;
    sc_signal< sc_logic > out_stream_V_dest_V_1_load_A;
    sc_signal< sc_logic > out_stream_V_dest_V_1_load_B;
    sc_signal< sc_lv<2> > out_stream_V_dest_V_1_state;
    sc_signal< sc_logic > out_stream_V_dest_V_1_state_cmp_full;
    sc_signal< sc_lv<16> > N_ADDS;
    sc_signal< sc_logic > in_stream0_TDATA_blk_n;
    sc_signal< sc_logic > ap_CS_fsm_pp1_stage0;
    sc_signal< sc_logic > ap_enable_reg_pp1_iter1;
    sc_signal< bool > ap_block_pp1_stage0;
    sc_signal< sc_lv<1> > exitcond_flatten_reg_522;
    sc_signal< sc_logic > out_stream_TDATA_blk_n;
    sc_signal< sc_logic > ap_enable_reg_pp2_iter2;
    sc_signal< bool > ap_block_pp2_stage0;
    sc_signal< sc_lv<1> > exitcond_reg_603;
    sc_signal< sc_lv<1> > exitcond_reg_603_pp2_iter1_reg;
    sc_signal< sc_logic > ap_enable_reg_pp2_iter3;
    sc_signal< sc_lv<1> > exitcond_reg_603_pp2_iter2_reg;
    sc_signal< sc_lv<21> > indvar_flatten_reg_303;
    sc_signal< sc_lv<6> > i_1_reg_314;
    sc_signal< sc_lv<6> > i_2_reg_325;
    sc_signal< sc_lv<32> > sum_pix1_ch0_q0;
    sc_signal< sc_lv<32> > reg_336;
    sc_signal< sc_logic > ap_enable_reg_pp1_iter2;
    sc_signal< bool > ap_block_state4_pp1_stage0_iter0;
    sc_signal< bool > ap_block_state5_pp1_stage0_iter1;
    sc_signal< bool > ap_block_state6_pp1_stage0_iter2;
    sc_signal< bool > ap_block_state7_pp1_stage0_iter3;
    sc_signal< bool > ap_block_state8_pp1_stage0_iter4;
    sc_signal< bool > ap_block_pp1_stage0_11001;
    sc_signal< sc_lv<1> > exitcond_flatten_reg_522_pp1_iter1_reg;
    sc_signal< sc_lv<32> > sum_pix1_ch0_q1;
    sc_signal< sc_logic > ap_CS_fsm_pp2_stage0;
    sc_signal< sc_logic > ap_enable_reg_pp2_iter1;
    sc_signal< bool > ap_block_state11_pp2_stage0_iter0;
    sc_signal< bool > ap_block_state12_pp2_stage0_iter1;
    sc_signal< bool > ap_block_state13_pp2_stage0_iter2;
    sc_signal< bool > ap_block_state13_io;
    sc_signal< bool > ap_block_state14_pp2_stage0_iter3;
    sc_signal< bool > ap_block_state14_io;
    sc_signal< bool > ap_block_pp2_stage0_11001;
    sc_signal< sc_lv<32> > sum_pix2_ch0_q0;
    sc_signal< sc_lv<32> > reg_341;
    sc_signal< sc_lv<32> > sum_pix2_ch0_q1;
    sc_signal< sc_lv<16> > N_ADDS_read_reg_504;
    sc_signal< sc_lv<6> > i_3_fu_352_p2;
    sc_signal< sc_logic > ap_CS_fsm_state2;
    sc_signal< sc_lv<21> > tmp_fu_364_p3;
    sc_signal< sc_lv<21> > tmp_reg_517;
    sc_signal< sc_logic > ap_CS_fsm_state3;
    sc_signal< sc_lv<1> > exitcond_flatten_fu_371_p2;
    sc_signal< sc_lv<1> > exitcond_flatten_reg_522_pp1_iter2_reg;
    sc_signal< sc_lv<1> > exitcond_flatten_reg_522_pp1_iter3_reg;
    sc_signal< sc_lv<21> > indvar_flatten_next_fu_376_p2;
    sc_signal< sc_logic > ap_enable_reg_pp1_iter0;
    sc_signal< sc_lv<6> > i_1_mid2_fu_388_p3;
    sc_signal< sc_lv<6> > i_1_mid2_reg_531;
    sc_signal< sc_lv<6> > i_5_fu_396_p2;
    sc_signal< sc_lv<8> > tmp_2_fu_429_p1;
    sc_signal< sc_lv<8> > tmp_2_reg_541;
    sc_signal< sc_lv<8> > tmp_2_reg_541_pp1_iter2_reg;
    sc_signal< sc_lv<8> > phitmp_reg_546;
    sc_signal< sc_lv<8> > phitmp_reg_546_pp1_iter2_reg;
    sc_signal< sc_lv<5> > sum_pix1_ch0_addr_2_reg_551;
    sc_signal< sc_lv<5> > sum_pix1_ch0_addr_2_reg_551_pp1_iter2_reg;
    sc_signal< sc_lv<5> > sum_pix1_ch0_addr_2_reg_551_pp1_iter3_reg;
    sc_signal< sc_lv<5> > sum_pix2_ch0_addr_2_reg_557;
    sc_signal< sc_lv<5> > sum_pix2_ch0_addr_2_reg_557_pp1_iter2_reg;
    sc_signal< sc_lv<5> > sum_pix2_ch0_addr_2_reg_557_pp1_iter3_reg;
    sc_signal< sc_lv<32> > tmp_8_fu_446_p2;
    sc_signal< sc_lv<32> > tmp_8_reg_563;
    sc_signal< sc_lv<32> > tmp_11_fu_455_p2;
    sc_signal< sc_lv<32> > tmp_11_reg_568;
    sc_signal< sc_logic > ap_CS_fsm_state9;
    sc_signal< sc_lv<2> > dub_pix_ch0_user_V_q0;
    sc_signal< sc_lv<2> > sum_pix_tot_user_V_reg_588;
    sc_signal< sc_logic > ap_CS_fsm_state10;
    sc_signal< sc_lv<5> > dub_pix_ch0_id_V_q0;
    sc_signal< sc_lv<5> > sum_pix_tot_id_V_reg_593;
    sc_signal< sc_lv<6> > dub_pix_ch0_dest_V_q0;
    sc_signal< sc_lv<6> > sum_pix_tot_dest_V_reg_598;
    sc_signal< sc_lv<1> > exitcond_fu_461_p2;
    sc_signal< sc_lv<6> > i_4_fu_467_p2;
    sc_signal< sc_logic > ap_enable_reg_pp2_iter0;
    sc_signal< sc_lv<1> > tmp_last_V_fu_479_p2;
    sc_signal< sc_lv<1> > tmp_last_V_reg_622;
    sc_signal< sc_lv<1> > tmp_last_V_reg_622_pp2_iter1_reg;
    sc_signal< sc_lv<64> > tmp_data_V_1_fu_497_p2;
    sc_signal< bool > ap_block_pp1_stage0_subdone;
    sc_signal< sc_logic > ap_condition_pp1_exit_iter0_state4;
    sc_signal< sc_logic > ap_enable_reg_pp1_iter3;
    sc_signal< sc_logic > ap_enable_reg_pp1_iter4;
    sc_signal< bool > ap_block_pp2_stage0_subdone;
    sc_signal< sc_logic > ap_condition_pp2_exit_iter0_state11;
    sc_signal< sc_lv<5> > sum_pix1_ch0_address0;
    sc_signal< sc_logic > sum_pix1_ch0_ce0;
    sc_signal< sc_logic > sum_pix1_ch0_we0;
    sc_signal< sc_lv<5> > sum_pix1_ch0_address1;
    sc_signal< sc_logic > sum_pix1_ch0_ce1;
    sc_signal< sc_logic > sum_pix1_ch0_we1;
    sc_signal< sc_lv<5> > sum_pix2_ch0_address0;
    sc_signal< sc_logic > sum_pix2_ch0_ce0;
    sc_signal< sc_logic > sum_pix2_ch0_we0;
    sc_signal< sc_lv<5> > sum_pix2_ch0_address1;
    sc_signal< sc_logic > sum_pix2_ch0_ce1;
    sc_signal< sc_logic > sum_pix2_ch0_we1;
    sc_signal< sc_lv<5> > dub_pix_ch0_user_V_address0;
    sc_signal< sc_logic > dub_pix_ch0_user_V_ce0;
    sc_signal< sc_logic > dub_pix_ch0_user_V_we0;
    sc_signal< sc_lv<5> > dub_pix_ch0_id_V_address0;
    sc_signal< sc_logic > dub_pix_ch0_id_V_ce0;
    sc_signal< sc_logic > dub_pix_ch0_id_V_we0;
    sc_signal< sc_lv<5> > dub_pix_ch0_dest_V_address0;
    sc_signal< sc_logic > dub_pix_ch0_dest_V_ce0;
    sc_signal< sc_logic > dub_pix_ch0_dest_V_we0;
    sc_signal< sc_lv<6> > i_reg_292;
    sc_signal< sc_lv<1> > exitcond1_fu_346_p2;
    sc_signal< sc_lv<64> > tmp_1_fu_358_p1;
    sc_signal< sc_lv<64> > tmp_s_fu_402_p1;
    sc_signal< sc_lv<64> > tmp_3_fu_473_p1;
    sc_signal< bool > ap_block_pp2_stage0_01001;
    sc_signal< sc_lv<1> > exitcond2_fu_382_p2;
    sc_signal< sc_lv<32> > tmp_9_fu_443_p1;
    sc_signal< sc_lv<32> > tmp_10_fu_452_p1;
    sc_signal< sc_lv<64> > tmp_5_fu_485_p3;
    sc_signal< sc_lv<64> > tmp_6_fu_493_p1;
    sc_signal< sc_logic > ap_CS_fsm_state15;
    sc_signal< bool > ap_block_state15;
    sc_signal< sc_lv<8> > ap_NS_fsm;
    sc_signal< sc_logic > ap_idle_pp1;
    sc_signal< sc_logic > ap_enable_pp1;
    sc_signal< sc_logic > ap_idle_pp2;
    sc_signal< sc_logic > ap_enable_pp2;
    static const sc_logic ap_const_logic_1;
    static const sc_logic ap_const_logic_0;
    static const sc_lv<8> ap_ST_fsm_state1;
    static const sc_lv<8> ap_ST_fsm_state2;
    static const sc_lv<8> ap_ST_fsm_state3;
    static const sc_lv<8> ap_ST_fsm_pp1_stage0;
    static const sc_lv<8> ap_ST_fsm_state9;
    static const sc_lv<8> ap_ST_fsm_state10;
    static const sc_lv<8> ap_ST_fsm_pp2_stage0;
    static const sc_lv<8> ap_ST_fsm_state15;
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
    static const int C_S_AXI_DATA_WIDTH;
    static const sc_lv<32> ap_const_lv32_6;
    static const sc_lv<32> ap_const_lv32_1;
    static const sc_lv<32> ap_const_lv32_2;
    static const sc_lv<32> ap_const_lv32_4;
    static const sc_lv<32> ap_const_lv32_5;
    static const sc_lv<6> ap_const_lv6_0;
    static const sc_lv<21> ap_const_lv21_0;
    static const sc_lv<64> ap_const_lv64_0;
    static const sc_lv<8> ap_const_lv8_3F;
    static const sc_lv<6> ap_const_lv6_20;
    static const sc_lv<6> ap_const_lv6_1;
    static const sc_lv<5> ap_const_lv5_0;
    static const sc_lv<21> ap_const_lv21_1;
    static const sc_lv<32> ap_const_lv32_8;
    static const sc_lv<32> ap_const_lv32_F;
    static const sc_lv<6> ap_const_lv6_1F;
    static const sc_lv<32> ap_const_lv32_7;
    // Thread declarations
    void thread_ap_var_for_const0();
    void thread_ap_var_for_const1();
    void thread_ap_clk_no_reset_();
    void thread_ap_CS_fsm_pp1_stage0();
    void thread_ap_CS_fsm_pp2_stage0();
    void thread_ap_CS_fsm_state1();
    void thread_ap_CS_fsm_state10();
    void thread_ap_CS_fsm_state15();
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
    void thread_ap_block_state11_pp2_stage0_iter0();
    void thread_ap_block_state12_pp2_stage0_iter1();
    void thread_ap_block_state13_io();
    void thread_ap_block_state13_pp2_stage0_iter2();
    void thread_ap_block_state14_io();
    void thread_ap_block_state14_pp2_stage0_iter3();
    void thread_ap_block_state15();
    void thread_ap_block_state4_pp1_stage0_iter0();
    void thread_ap_block_state5_pp1_stage0_iter1();
    void thread_ap_block_state6_pp1_stage0_iter2();
    void thread_ap_block_state7_pp1_stage0_iter3();
    void thread_ap_block_state8_pp1_stage0_iter4();
    void thread_ap_condition_pp1_exit_iter0_state4();
    void thread_ap_condition_pp2_exit_iter0_state11();
    void thread_ap_done();
    void thread_ap_enable_pp1();
    void thread_ap_enable_pp2();
    void thread_ap_idle();
    void thread_ap_idle_pp1();
    void thread_ap_idle_pp2();
    void thread_ap_ready();
    void thread_ap_rst_n_inv();
    void thread_dub_pix_ch0_dest_V_address0();
    void thread_dub_pix_ch0_dest_V_ce0();
    void thread_dub_pix_ch0_dest_V_we0();
    void thread_dub_pix_ch0_id_V_address0();
    void thread_dub_pix_ch0_id_V_ce0();
    void thread_dub_pix_ch0_id_V_we0();
    void thread_dub_pix_ch0_user_V_address0();
    void thread_dub_pix_ch0_user_V_ce0();
    void thread_dub_pix_ch0_user_V_we0();
    void thread_exitcond1_fu_346_p2();
    void thread_exitcond2_fu_382_p2();
    void thread_exitcond_flatten_fu_371_p2();
    void thread_exitcond_fu_461_p2();
    void thread_i_1_mid2_fu_388_p3();
    void thread_i_3_fu_352_p2();
    void thread_i_4_fu_467_p2();
    void thread_i_5_fu_396_p2();
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
    void thread_in_stream0_V_dest_V_0_ack_in();
    void thread_in_stream0_V_dest_V_0_ack_out();
    void thread_in_stream0_V_dest_V_0_data_out();
    void thread_in_stream0_V_dest_V_0_load_A();
    void thread_in_stream0_V_dest_V_0_load_B();
    void thread_in_stream0_V_dest_V_0_sel();
    void thread_in_stream0_V_dest_V_0_state_cmp_full();
    void thread_in_stream0_V_dest_V_0_vld_in();
    void thread_in_stream0_V_dest_V_0_vld_out();
    void thread_in_stream0_V_id_V_0_ack_in();
    void thread_in_stream0_V_id_V_0_ack_out();
    void thread_in_stream0_V_id_V_0_data_out();
    void thread_in_stream0_V_id_V_0_load_A();
    void thread_in_stream0_V_id_V_0_load_B();
    void thread_in_stream0_V_id_V_0_sel();
    void thread_in_stream0_V_id_V_0_state_cmp_full();
    void thread_in_stream0_V_id_V_0_vld_in();
    void thread_in_stream0_V_id_V_0_vld_out();
    void thread_in_stream0_V_user_V_0_ack_in();
    void thread_in_stream0_V_user_V_0_ack_out();
    void thread_in_stream0_V_user_V_0_data_out();
    void thread_in_stream0_V_user_V_0_load_A();
    void thread_in_stream0_V_user_V_0_load_B();
    void thread_in_stream0_V_user_V_0_sel();
    void thread_in_stream0_V_user_V_0_state_cmp_full();
    void thread_in_stream0_V_user_V_0_vld_in();
    void thread_in_stream0_V_user_V_0_vld_out();
    void thread_indvar_flatten_next_fu_376_p2();
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
    void thread_out_stream_V_dest_V_1_load_A();
    void thread_out_stream_V_dest_V_1_load_B();
    void thread_out_stream_V_dest_V_1_sel();
    void thread_out_stream_V_dest_V_1_state_cmp_full();
    void thread_out_stream_V_dest_V_1_vld_in();
    void thread_out_stream_V_dest_V_1_vld_out();
    void thread_out_stream_V_id_V_1_ack_in();
    void thread_out_stream_V_id_V_1_ack_out();
    void thread_out_stream_V_id_V_1_data_out();
    void thread_out_stream_V_id_V_1_load_A();
    void thread_out_stream_V_id_V_1_load_B();
    void thread_out_stream_V_id_V_1_sel();
    void thread_out_stream_V_id_V_1_state_cmp_full();
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
    void thread_out_stream_V_user_V_1_load_A();
    void thread_out_stream_V_user_V_1_load_B();
    void thread_out_stream_V_user_V_1_sel();
    void thread_out_stream_V_user_V_1_state_cmp_full();
    void thread_out_stream_V_user_V_1_vld_in();
    void thread_out_stream_V_user_V_1_vld_out();
    void thread_sum_pix1_ch0_address0();
    void thread_sum_pix1_ch0_address1();
    void thread_sum_pix1_ch0_ce0();
    void thread_sum_pix1_ch0_ce1();
    void thread_sum_pix1_ch0_we0();
    void thread_sum_pix1_ch0_we1();
    void thread_sum_pix2_ch0_address0();
    void thread_sum_pix2_ch0_address1();
    void thread_sum_pix2_ch0_ce0();
    void thread_sum_pix2_ch0_ce1();
    void thread_sum_pix2_ch0_we0();
    void thread_sum_pix2_ch0_we1();
    void thread_tmp_10_fu_452_p1();
    void thread_tmp_11_fu_455_p2();
    void thread_tmp_1_fu_358_p1();
    void thread_tmp_2_fu_429_p1();
    void thread_tmp_3_fu_473_p1();
    void thread_tmp_5_fu_485_p3();
    void thread_tmp_6_fu_493_p1();
    void thread_tmp_8_fu_446_p2();
    void thread_tmp_9_fu_443_p1();
    void thread_tmp_data_V_1_fu_497_p2();
    void thread_tmp_fu_364_p3();
    void thread_tmp_last_V_fu_479_p2();
    void thread_tmp_s_fu_402_p1();
    void thread_ap_NS_fsm();
    void thread_hdltv_gen();
};

}

using namespace ap_rtl;

#endif
