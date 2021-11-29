--Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2018.1 (lin64) Build 2188600 Wed Apr  4 18:39:19 MDT 2018
--Date        : Wed Nov 24 13:40:26 2021
--Host        : alx-laptop running 64-bit Ubuntu 18.04.5 LTS
--Command     : generate_target design_1_wrapper.bd
--Design      : design_1_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_wrapper is
  port (
    CLK_HV_n_0 : out STD_LOGIC;
    CLK_HV_p_0 : out STD_LOGIC;
    CLK_IN_D_0_clk_n : in STD_LOGIC;
    CLK_IN_D_0_clk_p : in STD_LOGIC;
    DATA_HV_n_0 : out STD_LOGIC;
    DATA_HV_p_0 : out STD_LOGIC;
    DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_cas_n : inout STD_LOGIC;
    DDR_ck_n : inout STD_LOGIC;
    DDR_ck_p : inout STD_LOGIC;
    DDR_cke : inout STD_LOGIC;
    DDR_cs_n : inout STD_LOGIC;
    DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_odt : inout STD_LOGIC;
    DDR_ras_n : inout STD_LOGIC;
    DDR_reset_n : inout STD_LOGIC;
    DDR_we_n : inout STD_LOGIC;
    Dout_0 : out STD_LOGIC_VECTOR ( 0 to 0 );
    Dout_1 : out STD_LOGIC_VECTOR ( 0 to 0 );
    Dout_2 : out STD_LOGIC_VECTOR ( 0 to 0 );
    Dout_4 : out STD_LOGIC_VECTOR ( 0 to 0 );
    FIXED_IO_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ps_clk : inout STD_LOGIC;
    FIXED_IO_ps_porb : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC;
    GTU_HV_n_0 : out STD_LOGIC;
    GTU_HV_p_0 : out STD_LOGIC;
    art_gtu_0 : out STD_LOGIC;
    art_gtu_1 : out STD_LOGIC;
    art_gtu_2 : out STD_LOGIC;
    artx_done_0 : in STD_LOGIC;
    artx_initb : out STD_LOGIC_VECTOR ( 0 to 0 );
    artx_latch_0 : out STD_LOGIC_VECTOR ( 0 to 0 );
    artx_latch_1 : out STD_LOGIC_VECTOR ( 0 to 0 );
    artx_latch_2 : out STD_LOGIC_VECTOR ( 0 to 0 );
    artx_programb : out STD_LOGIC_VECTOR ( 0 to 0 );
    cs_dac_n_0 : out STD_LOGIC;
    cs_dac_p_0 : out STD_LOGIC;
    cs_exp_n_0 : out STD_LOGIC;
    cs_exp_p_0 : out STD_LOGIC;
    data_in_from_pins_n_0 : in STD_LOGIC_VECTOR ( 12 downto 0 );
    data_in_from_pins_n_1 : in STD_LOGIC_VECTOR ( 12 downto 0 );
    data_in_from_pins_n_2 : in STD_LOGIC_VECTOR ( 12 downto 0 );
    data_in_from_pins_p_0 : in STD_LOGIC_VECTOR ( 12 downto 0 );
    data_in_from_pins_p_1 : in STD_LOGIC_VECTOR ( 12 downto 0 );
    data_in_from_pins_p_2 : in STD_LOGIC_VECTOR ( 12 downto 0 );
    diff_clk_in_0_clk_n : in STD_LOGIC;
    diff_clk_in_0_clk_p : in STD_LOGIC;
    diff_clk_in_1_clk_n : in STD_LOGIC;
    diff_clk_in_1_clk_p : in STD_LOGIC;
    intr_n_0 : in STD_LOGIC;
    intr_p_0 : in STD_LOGIC;
    io0_o_0 : out STD_LOGIC;
    io0_o_1 : out STD_LOGIC;
    io0_o_2 : out STD_LOGIC;
    io0_o_3 : out STD_LOGIC;
    loadb_sc_pc_0 : out STD_LOGIC;
    m_axis_tlast_trg : out STD_LOGIC;
    miso_n_0 : in STD_LOGIC;
    miso_p_0 : in STD_LOGIC;
    mosi_n_0 : out STD_LOGIC;
    mosi_p_0 : out STD_LOGIC;
    resetb_pc_0 : out STD_LOGIC;
    sck_n_0 : out STD_LOGIC;
    sck_o_0 : out STD_LOGIC;
    sck_o_1 : out STD_LOGIC_VECTOR ( 0 to 0 );
    sck_o_2 : out STD_LOGIC_VECTOR ( 0 to 0 );
    sck_o_3 : out STD_LOGIC_VECTOR ( 0 to 0 );
    sck_p_0 : out STD_LOGIC;
    select_din_pc_0 : out STD_LOGIC;
    select_sc_probe_pc_0 : out STD_LOGIC;
    sr_ck_pc_0 : out STD_LOGIC;
    sr_ck_pc_1 : out STD_LOGIC;
    sr_ck_pc_2 : out STD_LOGIC;
    sr_in_pc_0 : out STD_LOGIC_VECTOR ( 5 downto 0 );
    sr_out_pc_0 : in STD_LOGIC_VECTOR ( 5 downto 0 );
    sr_rstb_pc_0 : out STD_LOGIC
  );
end design_1_wrapper;

architecture STRUCTURE of design_1_wrapper is
  component design_1 is
  port (
    DDR_cas_n : inout STD_LOGIC;
    DDR_cke : inout STD_LOGIC;
    DDR_ck_n : inout STD_LOGIC;
    DDR_ck_p : inout STD_LOGIC;
    DDR_cs_n : inout STD_LOGIC;
    DDR_reset_n : inout STD_LOGIC;
    DDR_odt : inout STD_LOGIC;
    DDR_ras_n : inout STD_LOGIC;
    DDR_we_n : inout STD_LOGIC;
    DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC;
    FIXED_IO_ps_clk : inout STD_LOGIC;
    FIXED_IO_ps_porb : inout STD_LOGIC;
    CLK_IN_D_0_clk_n : in STD_LOGIC;
    CLK_IN_D_0_clk_p : in STD_LOGIC;
    diff_clk_in_0_clk_n : in STD_LOGIC;
    diff_clk_in_0_clk_p : in STD_LOGIC;
    diff_clk_in_1_clk_n : in STD_LOGIC;
    diff_clk_in_1_clk_p : in STD_LOGIC;
    Dout_2 : out STD_LOGIC_VECTOR ( 0 to 0 );
    Dout_1 : out STD_LOGIC_VECTOR ( 0 to 0 );
    Dout_0 : out STD_LOGIC_VECTOR ( 0 to 0 );
    data_in_from_pins_p_0 : in STD_LOGIC_VECTOR ( 12 downto 0 );
    data_in_from_pins_n_0 : in STD_LOGIC_VECTOR ( 12 downto 0 );
    sck_p_0 : out STD_LOGIC;
    sck_n_0 : out STD_LOGIC;
    mosi_p_0 : out STD_LOGIC;
    mosi_n_0 : out STD_LOGIC;
    cs_exp_p_0 : out STD_LOGIC;
    cs_exp_n_0 : out STD_LOGIC;
    cs_dac_p_0 : out STD_LOGIC;
    cs_dac_n_0 : out STD_LOGIC;
    miso_p_0 : in STD_LOGIC;
    miso_n_0 : in STD_LOGIC;
    intr_p_0 : in STD_LOGIC;
    intr_n_0 : in STD_LOGIC;
    sr_in_pc_0 : out STD_LOGIC_VECTOR ( 5 downto 0 );
    loadb_sc_pc_0 : out STD_LOGIC;
    select_din_pc_0 : out STD_LOGIC;
    resetb_pc_0 : out STD_LOGIC;
    select_sc_probe_pc_0 : out STD_LOGIC;
    sr_rstb_pc_0 : out STD_LOGIC;
    sr_ck_pc_1 : out STD_LOGIC;
    sr_ck_pc_2 : out STD_LOGIC;
    sr_ck_pc_0 : out STD_LOGIC;
    GTU_HV_p_0 : out STD_LOGIC;
    GTU_HV_n_0 : out STD_LOGIC;
    CLK_HV_p_0 : out STD_LOGIC;
    CLK_HV_n_0 : out STD_LOGIC;
    DATA_HV_p_0 : out STD_LOGIC;
    DATA_HV_n_0 : out STD_LOGIC;
    io0_o_0 : out STD_LOGIC;
    io0_o_1 : out STD_LOGIC;
    io0_o_2 : out STD_LOGIC;
    io0_o_3 : out STD_LOGIC;
    sck_o_0 : out STD_LOGIC;
    sck_o_1 : out STD_LOGIC_VECTOR ( 0 to 0 );
    sck_o_2 : out STD_LOGIC_VECTOR ( 0 to 0 );
    sck_o_3 : out STD_LOGIC_VECTOR ( 0 to 0 );
    artx_done_0 : in STD_LOGIC;
    data_in_from_pins_p_1 : in STD_LOGIC_VECTOR ( 12 downto 0 );
    data_in_from_pins_n_1 : in STD_LOGIC_VECTOR ( 12 downto 0 );
    data_in_from_pins_p_2 : in STD_LOGIC_VECTOR ( 12 downto 0 );
    data_in_from_pins_n_2 : in STD_LOGIC_VECTOR ( 12 downto 0 );
    Dout_4 : out STD_LOGIC_VECTOR ( 0 to 0 );
    artx_latch_0 : out STD_LOGIC_VECTOR ( 0 to 0 );
    artx_latch_1 : out STD_LOGIC_VECTOR ( 0 to 0 );
    artx_latch_2 : out STD_LOGIC_VECTOR ( 0 to 0 );
    artx_programb : out STD_LOGIC_VECTOR ( 0 to 0 );
    artx_initb : out STD_LOGIC_VECTOR ( 0 to 0 );
    sr_out_pc_0 : in STD_LOGIC_VECTOR ( 5 downto 0 );
    art_gtu_0 : out STD_LOGIC;
    art_gtu_1 : out STD_LOGIC;
    art_gtu_2 : out STD_LOGIC;
    m_axis_tlast_trg : out STD_LOGIC
  );
  end component design_1;
begin
design_1_i: component design_1
     port map (
      CLK_HV_n_0 => CLK_HV_n_0,
      CLK_HV_p_0 => CLK_HV_p_0,
      CLK_IN_D_0_clk_n => CLK_IN_D_0_clk_n,
      CLK_IN_D_0_clk_p => CLK_IN_D_0_clk_p,
      DATA_HV_n_0 => DATA_HV_n_0,
      DATA_HV_p_0 => DATA_HV_p_0,
      DDR_addr(14 downto 0) => DDR_addr(14 downto 0),
      DDR_ba(2 downto 0) => DDR_ba(2 downto 0),
      DDR_cas_n => DDR_cas_n,
      DDR_ck_n => DDR_ck_n,
      DDR_ck_p => DDR_ck_p,
      DDR_cke => DDR_cke,
      DDR_cs_n => DDR_cs_n,
      DDR_dm(3 downto 0) => DDR_dm(3 downto 0),
      DDR_dq(31 downto 0) => DDR_dq(31 downto 0),
      DDR_dqs_n(3 downto 0) => DDR_dqs_n(3 downto 0),
      DDR_dqs_p(3 downto 0) => DDR_dqs_p(3 downto 0),
      DDR_odt => DDR_odt,
      DDR_ras_n => DDR_ras_n,
      DDR_reset_n => DDR_reset_n,
      DDR_we_n => DDR_we_n,
      Dout_0(0) => Dout_0(0),
      Dout_1(0) => Dout_1(0),
      Dout_2(0) => Dout_2(0),
      Dout_4(0) => Dout_4(0),
      FIXED_IO_ddr_vrn => FIXED_IO_ddr_vrn,
      FIXED_IO_ddr_vrp => FIXED_IO_ddr_vrp,
      FIXED_IO_mio(53 downto 0) => FIXED_IO_mio(53 downto 0),
      FIXED_IO_ps_clk => FIXED_IO_ps_clk,
      FIXED_IO_ps_porb => FIXED_IO_ps_porb,
      FIXED_IO_ps_srstb => FIXED_IO_ps_srstb,
      GTU_HV_n_0 => GTU_HV_n_0,
      GTU_HV_p_0 => GTU_HV_p_0,
      art_gtu_0 => art_gtu_0,
      art_gtu_1 => art_gtu_1,
      art_gtu_2 => art_gtu_2,
      artx_done_0 => artx_done_0,
      artx_initb(0) => artx_initb(0),
      artx_latch_0(0) => artx_latch_0(0),
      artx_latch_1(0) => artx_latch_1(0),
      artx_latch_2(0) => artx_latch_2(0),
      artx_programb(0) => artx_programb(0),
      cs_dac_n_0 => cs_dac_n_0,
      cs_dac_p_0 => cs_dac_p_0,
      cs_exp_n_0 => cs_exp_n_0,
      cs_exp_p_0 => cs_exp_p_0,
      data_in_from_pins_n_0(12 downto 0) => data_in_from_pins_n_0(12 downto 0),
      data_in_from_pins_n_1(12 downto 0) => data_in_from_pins_n_1(12 downto 0),
      data_in_from_pins_n_2(12 downto 0) => data_in_from_pins_n_2(12 downto 0),
      data_in_from_pins_p_0(12 downto 0) => data_in_from_pins_p_0(12 downto 0),
      data_in_from_pins_p_1(12 downto 0) => data_in_from_pins_p_1(12 downto 0),
      data_in_from_pins_p_2(12 downto 0) => data_in_from_pins_p_2(12 downto 0),
      diff_clk_in_0_clk_n => diff_clk_in_0_clk_n,
      diff_clk_in_0_clk_p => diff_clk_in_0_clk_p,
      diff_clk_in_1_clk_n => diff_clk_in_1_clk_n,
      diff_clk_in_1_clk_p => diff_clk_in_1_clk_p,
      intr_n_0 => intr_n_0,
      intr_p_0 => intr_p_0,
      io0_o_0 => io0_o_0,
      io0_o_1 => io0_o_1,
      io0_o_2 => io0_o_2,
      io0_o_3 => io0_o_3,
      loadb_sc_pc_0 => loadb_sc_pc_0,
      m_axis_tlast_trg => m_axis_tlast_trg,
      miso_n_0 => miso_n_0,
      miso_p_0 => miso_p_0,
      mosi_n_0 => mosi_n_0,
      mosi_p_0 => mosi_p_0,
      resetb_pc_0 => resetb_pc_0,
      sck_n_0 => sck_n_0,
      sck_o_0 => sck_o_0,
      sck_o_1(0) => sck_o_1(0),
      sck_o_2(0) => sck_o_2(0),
      sck_o_3(0) => sck_o_3(0),
      sck_p_0 => sck_p_0,
      select_din_pc_0 => select_din_pc_0,
      select_sc_probe_pc_0 => select_sc_probe_pc_0,
      sr_ck_pc_0 => sr_ck_pc_0,
      sr_ck_pc_1 => sr_ck_pc_1,
      sr_ck_pc_2 => sr_ck_pc_2,
      sr_in_pc_0(5 downto 0) => sr_in_pc_0(5 downto 0),
      sr_out_pc_0(5 downto 0) => sr_out_pc_0(5 downto 0),
      sr_rstb_pc_0 => sr_rstb_pc_0
    );
end STRUCTURE;
