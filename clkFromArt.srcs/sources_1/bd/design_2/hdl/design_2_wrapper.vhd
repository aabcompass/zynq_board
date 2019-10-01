--Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2018.1 (lin64) Build 2188600 Wed Apr  4 18:39:19 MDT 2018
--Date        : Tue Sep  3 18:56:44 2019
--Host        : alx-hp-envy-notebook running 64-bit Ubuntu 16.04.6 LTS
--Command     : generate_target design_2_wrapper.bd
--Design      : design_2_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_2_wrapper is
  port (
    CLK_IN_D_0_clk_n : in STD_LOGIC;
    CLK_IN_D_0_clk_p : in STD_LOGIC;
    clk_reset_0 : in STD_LOGIC;
    data_in_from_pins_n_0 : in STD_LOGIC_VECTOR ( 12 downto 0 );
    data_in_from_pins_p_0 : in STD_LOGIC_VECTOR ( 12 downto 0 );
    dataout0_0 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    dataout10_0 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    dataout11_0 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    dataout12_0 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    dataout1_0 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    dataout2_0 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    dataout3_0 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    dataout4_0 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    dataout5_0 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    dataout6_0 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    dataout7_0 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    dataout8_0 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    dataout9_0 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    dataout_last_0 : out STD_LOGIC;
    dataout_valid_0 : out STD_LOGIC;
    in_delay_reset_0 : in STD_LOGIC;
    in_delay_tap_in_0 : in STD_LOGIC_VECTOR ( 64 downto 0 );
    io_reset_0 : in STD_LOGIC;
    ref_clock_0 : in STD_LOGIC
  );
end design_2_wrapper;

architecture STRUCTURE of design_2_wrapper is
  component design_2 is
  port (
    CLK_IN_D_0_clk_n : in STD_LOGIC;
    CLK_IN_D_0_clk_p : in STD_LOGIC;
    data_in_from_pins_p_0 : in STD_LOGIC_VECTOR ( 12 downto 0 );
    data_in_from_pins_n_0 : in STD_LOGIC_VECTOR ( 12 downto 0 );
    dataout0_0 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    dataout1_0 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    dataout2_0 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    dataout3_0 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    dataout4_0 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    dataout5_0 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    dataout6_0 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    dataout7_0 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    dataout8_0 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    dataout9_0 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    dataout10_0 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    dataout11_0 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    dataout12_0 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    dataout_valid_0 : out STD_LOGIC;
    dataout_last_0 : out STD_LOGIC;
    in_delay_tap_in_0 : in STD_LOGIC_VECTOR ( 64 downto 0 );
    in_delay_reset_0 : in STD_LOGIC;
    io_reset_0 : in STD_LOGIC;
    clk_reset_0 : in STD_LOGIC;
    ref_clock_0 : in STD_LOGIC
  );
  end component design_2;
begin
design_2_i: component design_2
     port map (
      CLK_IN_D_0_clk_n => CLK_IN_D_0_clk_n,
      CLK_IN_D_0_clk_p => CLK_IN_D_0_clk_p,
      clk_reset_0 => clk_reset_0,
      data_in_from_pins_n_0(12 downto 0) => data_in_from_pins_n_0(12 downto 0),
      data_in_from_pins_p_0(12 downto 0) => data_in_from_pins_p_0(12 downto 0),
      dataout0_0(7 downto 0) => dataout0_0(7 downto 0),
      dataout10_0(7 downto 0) => dataout10_0(7 downto 0),
      dataout11_0(7 downto 0) => dataout11_0(7 downto 0),
      dataout12_0(7 downto 0) => dataout12_0(7 downto 0),
      dataout1_0(7 downto 0) => dataout1_0(7 downto 0),
      dataout2_0(7 downto 0) => dataout2_0(7 downto 0),
      dataout3_0(7 downto 0) => dataout3_0(7 downto 0),
      dataout4_0(7 downto 0) => dataout4_0(7 downto 0),
      dataout5_0(7 downto 0) => dataout5_0(7 downto 0),
      dataout6_0(7 downto 0) => dataout6_0(7 downto 0),
      dataout7_0(7 downto 0) => dataout7_0(7 downto 0),
      dataout8_0(7 downto 0) => dataout8_0(7 downto 0),
      dataout9_0(7 downto 0) => dataout9_0(7 downto 0),
      dataout_last_0 => dataout_last_0,
      dataout_valid_0 => dataout_valid_0,
      in_delay_reset_0 => in_delay_reset_0,
      in_delay_tap_in_0(64 downto 0) => in_delay_tap_in_0(64 downto 0),
      io_reset_0 => io_reset_0,
      ref_clock_0 => ref_clock_0
    );
end STRUCTURE;
