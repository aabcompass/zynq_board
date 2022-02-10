----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.01.2022 13:40:21
-- Design Name: 
-- Module Name: clkb_core - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;


Library xpm;
use xpm.vcomponents.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity clkb_core is
    Generic (C_FREQ: integer:= 200000000);
    Port ( 
    -- physical lines from CLKB
    spb_gtu_clk_p : in STD_LOGIC; --ae16
    spb_gtu_clk_n : in STD_LOGIC;
    spb_1pps_p : in STD_LOGIC; --ad16
    spb_1pps_n : in STD_LOGIC; 
    SPB_Trig_L1_out_P : out STD_LOGIC; --ac13
    SPB_Trig_L1_out_N : out STD_LOGIC; 
    SPB_Busy_P : in STD_LOGIC; --ac12
    SPB_Busy_N : in STD_LOGIC; 
    SPB_Ext_trig_IN_P : in STD_LOGIC;  --ae12
    SPB_Ext_trig_IN_N : in STD_LOGIC; 
    SPB_CLK_40_p : in STD_LOGIC;  --ae13
    SPB_CLK_40_n : in STD_LOGIC; 
    SPB_SPARE_2_P : in STD_LOGIC; --ab15 --NC
    SPB_SPARE_2_N : in STD_LOGIC;
    --logical lines 
    gtu_clk: out std_logic;
    spb_1pps: out std_logic;
    SPB_Trig_L1_out: in std_logic;
    SPB_Busy: out std_logic;
    SPB_Ext_trig_IN: out std_logic;
    SPB_CLK_200_out: out std_logic;
    --regs
    axi_clk: in std_logic;
    axi_aresetn: in std_logic;
    force_trg_0: in std_logic;
    force_trg_1: in std_logic;
    freq_40MHz: out std_logic_vector(31 downto 0);
    freq_gtu_clk: out std_logic_vector(31 downto 0);
    cnt_1pps: out std_logic_vector(31 downto 0);
    cnt_Ext_trig: out std_logic_vector(31 downto 0);
    cnt_gtu_clk: out std_logic_vector(31 downto 0);
    status: out std_logic_vector(31 downto 0);
    reset_cnt: in std_logic
    );
end clkb_core;

architecture Behavioral of clkb_core is

	signal spb_gtu_clk_i: std_logic := '0';
	signal gtu_clk_i: std_logic := '0';
	signal clk_wiz_spb_locked: std_logic := '0';
	signal spb_1pps_i: std_logic := '0';
	signal spb_1pps_i_inv: std_logic := '0';
	signal spb_1pps_sync: std_logic := '0';
	signal SPB_Busy_i: std_logic := '0';
	signal SPB_Busy_sync: std_logic := '0';
	signal SPB_Ext_trig_IN_i: std_logic := '0';
	signal SPB_Ext_trig_IN_sync: std_logic := '0';
	signal SPB_CLK_40_i: std_logic := '0';
	signal SPB_CLK_40_locked: std_logic := '0';
	signal SPB_CLK_40_locked_sync: std_logic := '0';
	signal SPB_CLK_40_locked_sync_axi: std_logic := '0';
	signal SPB_Trig_L1_out_i: std_logic := '0';
	signal SPB_CLK_200: std_logic := '0';
	
	signal axi_reset: std_logic := '0';
	signal spb_reset: std_logic := '0';
	
	signal one_sec_imp: std_logic := '0';
	signal one_sec_imp_sync: std_logic := '0';
	signal one_sec_cnt: std_logic_vector(31 downto 0) := (others => '0');
	signal SPB_CLK_200_cnt: std_logic_vector(31 downto 0) := (others => '0');
	signal freq_40MHz_i: std_logic_vector(31 downto 0) := (others => '0');
	signal freq_gtu_clk_cnt: std_logic_vector(31 downto 0) := (others => '0');
	signal cnt_gtu_clk_i: std_logic_vector(31 downto 0) := (others => '0');
	signal cnt_1pps_i: std_logic_vector(31 downto 0) := (others => '0');
	signal cnt_Ext_trig_i: std_logic_vector(31 downto 0) := (others => '0');
	
	component clk_wiz_spb
	port
	 (-- Clock in ports
	  -- Clock out ports
	  clk_out1          : out    std_logic;
	  -- Status and control signals
	  locked            : out    std_logic;
	  clk_in1           : in     std_logic
	 );
	end component;

begin
	
	-- PRIMITIVES

	IBUFDS_gtu_clk : IBUFDS
	generic map (
		DIFF_TERM => TRUE, -- Differential Termination 
		IBUF_LOW_PWR => TRUE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
		IOSTANDARD => "DEFAULT")
	port map (
		O => spb_gtu_clk_i,  -- Buffer output
		I => spb_gtu_clk_p,  -- Diff_p buffer input (connect directly to top-level port)
		IB => spb_gtu_clk_n -- Diff_n buffer input (connect directly to top-level port)
	);

	xpm_cdc_gtu_clk : xpm_cdc_single
	generic map (
		DEST_SYNC_FF => 4,   -- DECIMAL; range: 2-10
		INIT_SYNC_FF => 0,   -- DECIMAL; integer; 0=disable simulation init values, 1=enable simulation init
		SIM_ASSERT_CHK => 0, -- DECIMAL; integer; 0=disable simulation messages, 1=enable simulation messages
		SRC_INPUT_REG => 0   -- DECIMAL; integer; 0=do not register input, 1=register input
	)
	port map (
		dest_out => gtu_clk_i, -- 1-bit output: src_in synchronized to the destination clock domain. This output
		dest_clk => axi_clk, -- 1-bit input: Clock signal for the destination clock domain.
		src_clk => '0',   -- 1-bit input: optional; required when SRC_INPUT_REG = 1
		src_in => spb_gtu_clk_i      -- 1-bit input: Input signal to be synchronized to dest_clk domain.
	);
	
	gtu_clk <= gtu_clk_i;

	IBUFDS_1pps : IBUFDS
	generic map (
		DIFF_TERM => TRUE, -- Differential Termination 
		IBUF_LOW_PWR => TRUE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
		IOSTANDARD => "DEFAULT")
	port map (
		O => spb_1pps_i,  -- Buffer output
		I => spb_1pps_p,  -- Diff_p buffer input (connect directly to top-level port)
		IB => spb_1pps_n -- Diff_n buffer input (connect directly to top-level port)
	);
	
	spb_1pps_i_inv <= not spb_1pps_i;
	
	xpm_cdc_spb_1pps : xpm_cdc_single
	generic map (
		DEST_SYNC_FF => 4,   -- DECIMAL; range: 2-10
		INIT_SYNC_FF => 0,   -- DECIMAL; integer; 0=disable simulation init values, 1=enable simulation init
		SIM_ASSERT_CHK => 0, -- DECIMAL; integer; 0=disable simulation messages, 1=enable simulation messages
		SRC_INPUT_REG => 0   -- DECIMAL; integer; 0=do not register input, 1=register input
	)
	port map (
		dest_out => spb_1pps_sync, -- 1-bit output: src_in synchronized to the destination clock domain. This output
		dest_clk => axi_clk, -- 1-bit input: Clock signal for the destination clock domain.
		src_clk => '0',   -- 1-bit input: optional; required when SRC_INPUT_REG = 1
		src_in => spb_1pps_i_inv      -- 1-bit input: Input signal to be synchronized to dest_clk domain.
	);
	
	OBUFDS_Trig_L1_out : OBUFDS
	generic map (
	   IOSTANDARD => "DEFAULT", -- Specify the output I/O standard
	   SLEW => "SLOW")          -- Specify the output slew rate
	port map (
	   O => SPB_Trig_L1_out_P,     -- Diff_p output (connect directly to top-level port)
	   OB => SPB_Trig_L1_out_N,   -- Diff_n output (connect directly to top-level port)
	   I => SPB_Trig_L1_out_i      -- Buffer input 
	);

	IBUFDS_SPB_Busy : IBUFDS
	generic map (
		DIFF_TERM => TRUE, -- Differential Termination 
		IBUF_LOW_PWR => TRUE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
		IOSTANDARD => "DEFAULT")
	port map (
		O => SPB_Busy_i,  -- Buffer output
		I => SPB_Busy_P,  -- Diff_p buffer input (connect directly to top-level port)
		IB => SPB_Busy_N -- Diff_n buffer input (connect directly to top-level port)
	);
	
	xpm_cdc_SPB_Busy : xpm_cdc_single
	generic map (
		DEST_SYNC_FF => 4,   -- DECIMAL; range: 2-10
		INIT_SYNC_FF => 0,   -- DECIMAL; integer; 0=disable simulation init values, 1=enable simulation init
		SIM_ASSERT_CHK => 0, -- DECIMAL; integer; 0=disable simulation messages, 1=enable simulation messages
		SRC_INPUT_REG => 0   -- DECIMAL; integer; 0=do not register input, 1=register input
	)
	port map (
		dest_out => SPB_Busy_sync, -- 1-bit output: src_in synchronized to the destination clock domain. This output
		dest_clk => axi_clk, -- 1-bit input: Clock signal for the destination clock domain.
		src_clk => '0',   -- 1-bit input: optional; required when SRC_INPUT_REG = 1
		src_in => SPB_Busy_i      -- 1-bit input: Input signal to be synchronized to dest_clk domain.
	);
	
	SPB_Busy <= SPB_Busy_sync;
	
	IBUFDS_Ext_trig_IN : IBUFDS
	generic map (
		DIFF_TERM => TRUE, -- Differential Termination 
		IBUF_LOW_PWR => TRUE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
		IOSTANDARD => "DEFAULT")
	port map (
		O => SPB_Ext_trig_IN_i,  -- Buffer output
		I => SPB_Ext_trig_IN_P,  -- Diff_p buffer input (connect directly to top-level port)
		IB => SPB_Ext_trig_IN_N -- Diff_n buffer input (connect directly to top-level port)
	);
	
	xpm_cdc_SPB_Ext_trig : xpm_cdc_single
	generic map (
		DEST_SYNC_FF => 4,   -- DECIMAL; range: 2-10
		INIT_SYNC_FF => 0,   -- DECIMAL; integer; 0=disable simulation init values, 1=enable simulation init
		SIM_ASSERT_CHK => 0, -- DECIMAL; integer; 0=disable simulation messages, 1=enable simulation messages
		SRC_INPUT_REG => 0   -- DECIMAL; integer; 0=do not register input, 1=register input
	)
	port map (
		dest_out => SPB_Ext_trig_IN_sync, -- 1-bit output: src_in synchronized to the destination clock domain. This output
		dest_clk => axi_clk, -- 1-bit input: Clock signal for the destination clock domain.
		src_clk => '0',   -- 1-bit input: optional; required when SRC_INPUT_REG = 1
		src_in => SPB_Ext_trig_IN_i      -- 1-bit input: Input signal to be synchronized to dest_clk domain.
	);
	
	SPB_Ext_trig_IN <= SPB_Ext_trig_IN_sync;

	IBUFDS_SPB_CLK_40 : IBUFDS
	generic map (
		DIFF_TERM => TRUE, -- Differential Termination 
		IBUF_LOW_PWR => TRUE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
		IOSTANDARD => "DEFAULT")
	port map (
		O => SPB_CLK_40_i,  -- Buffer output
		I => SPB_CLK_40_p,  -- Diff_p buffer input (connect directly to top-level port)
		IB => SPB_CLK_40_n -- Diff_n buffer input (connect directly to top-level port)
	);
	
	i_clk_wiz_spb : clk_wiz_spb
   port map ( 
  -- Clock out ports  
   clk_out1 => SPB_CLK_200,
  -- Status and control signals                
   locked => SPB_CLK_40_locked,
   -- Clock in ports
   clk_in1 => SPB_CLK_40_i
 );
 
 SPB_CLK_200_out <= SPB_CLK_200;
 
 xpm_cdc_async_rst_inst : xpm_cdc_async_rst
 generic map (
    DEST_SYNC_FF => 4,    -- DECIMAL; range: 2-10
    INIT_SYNC_FF => 0,    -- DECIMAL; 0=disable simulation init values, 1=enable simulation init values
    RST_ACTIVE_HIGH => 0  -- DECIMAL; 0=active low reset, 1=active high reset
 )
 port map (
    dest_arst => SPB_CLK_40_locked_sync, -- 1-bit output: src_arst asynchronous reset signal synchronized to destination
                            -- clock domain. This output is registered. NOTE: Signal asserts asynchronously
                            -- but deasserts synchronously to dest_clk. Width of the reset signal is at least
                            -- (DEST_SYNC_FF*dest_clk) period.

    dest_clk => SPB_CLK_40_i,   -- 1-bit input: Destination clock.
    src_arst => SPB_CLK_40_locked    -- 1-bit input: Source asynchronous reset signal.
 );
 
 spb_reset <= not SPB_CLK_40_locked_sync;
 
 xpm_cdc_async_rst_axi : xpm_cdc_async_rst
 generic map (
    DEST_SYNC_FF => 4,    -- DECIMAL; range: 2-10
    INIT_SYNC_FF => 0,    -- DECIMAL; 0=disable simulation init values, 1=enable simulation init values
    RST_ACTIVE_HIGH => 0  -- DECIMAL; 0=active low reset, 1=active high reset
 )
 port map (
    dest_arst => SPB_CLK_40_locked_sync_axi, -- 1-bit output: src_arst asynchronous reset signal synchronized to destination
                            -- clock domain. This output is registered. NOTE: Signal asserts asynchronously
                            -- but deasserts synchronously to dest_clk. Width of the reset signal is at least
                            -- (DEST_SYNC_FF*dest_clk) period.

    dest_clk => axi_clk,   -- 1-bit input: Destination clock.
    src_arst => SPB_CLK_40_locked    -- 1-bit input: Source asynchronous reset signal.
 );

	-- logic
	SPB_Trig_L1_out_proc: process(axi_clk)
	begin
		if(rising_edge(axi_clk)) then
			if(force_trg_1 = '0') then
				SPB_Trig_L1_out_i <= '0';
			elsif(force_trg_1 = '1') then
				SPB_Trig_L1_out_i <= '1';
			else
				SPB_Trig_L1_out_i <= SPB_Trig_L1_out;
			end if;
		end if;
	end process;
	
	one_sec_pulse_former: process(axi_clk)
	begin
		if(rising_edge(axi_clk)) then
			if(one_sec_cnt = C_FREQ) then
				one_sec_cnt <= conv_std_logic_vector(1, 32);
				one_sec_imp <= '1';
			else
				one_sec_cnt <= one_sec_cnt + 1;
				one_sec_imp <= '0';
			end if;
		end if;
	end process;
 
 axi_reset <= not axi_aresetn;
 
  xpm_cdc_pulse_inst : xpm_cdc_pulse
	generic map (
	   DEST_SYNC_FF => 4,   -- DECIMAL; range: 2-10
	   INIT_SYNC_FF => 0,   -- DECIMAL; 0=disable simulation init values, 1=enable simulation init values
	   REG_OUTPUT => 1,     -- DECIMAL; 0=disable registered output, 1=enable registered output
	   RST_USED => 1,       -- DECIMAL; 0=no reset, 1=implement reset
	   SIM_ASSERT_CHK => 0  -- DECIMAL; 0=disable simulation messages, 1=enable simulation messages
	)
	port map (
	   dest_pulse => one_sec_imp_sync, -- 1-bit output: Outputs a pulse the size of one dest_clk period when a pulse
	                             -- transfer is correctly initiated on src_pulse input. This output is
	                             -- combinatorial unless REG_OUTPUT is set to 1.

	   dest_clk => SPB_CLK_200,     -- 1-bit input: Destination clock.
	   dest_rst => spb_reset,     -- 1-bit input: optional; required when RST_USED = 1
	   src_clk => axi_clk,       -- 1-bit input: Source clock.
	   src_pulse => one_sec_imp,   -- 1-bit input: Rising edge of this signal initiates a pulse transfer to the
	                             -- destination clock domain. The minimum gap between each pulse transfer must
	                             -- be at the minimum 2*(larger(src_clk period, dest_clk period)). This is
	                             -- measured between the falling edge of a src_pulse to the rising edge of the
	                             -- next src_pulse. This minimum gap will guarantee that each rising edge of
	                             -- src_pulse will generate a pulse the size of one dest_clk period in the
	                             -- destination clock domain. When RST_USED = 1, pulse transfers will not be
	                             -- guaranteed while src_rst and/or dest_rst are asserted.

	   src_rst => axi_reset        -- 1-bit input: optional; required when RST_USED = 1
	);

 	
 
	freq_40_MHz_meter: process(SPB_CLK_200)
	begin
		if(rising_edge(SPB_CLK_200)) then
			if(one_sec_imp_sync = '1') then
				freq_40MHz_i <= SPB_CLK_200_cnt;
				SPB_CLK_200_cnt <= (others => '0');
			else
				SPB_CLK_200_cnt <= SPB_CLK_200_cnt + 1;
			end if;
		end if;
	end process; 
	
	xpm_cdc_array_single_inst : xpm_cdc_array_single
	generic map (
	   DEST_SYNC_FF => 4,   -- DECIMAL; range: 2-10
	   INIT_SYNC_FF => 0,   -- DECIMAL; integer; 0=disable simulation init values, 1=enable simulation init
	   SIM_ASSERT_CHK => 0, -- DECIMAL; integer; 0=disable simulation messages, 1=enable simulation messages
	   SRC_INPUT_REG => 0,  -- DECIMAL; 0=do not register input, 1=register input
	   WIDTH => 32           -- DECIMAL; range: 1-1024
	)
	port map (
	   dest_out => freq_40MHz, -- WIDTH-bit output: src_in synchronized to the destination clock domain. This
	   dest_clk => axi_clk, -- 1-bit input: Clock signal for the destination clock domain.
	   src_clk => '0',   -- 1-bit input: optional; required when SRC_INPUT_REG = 1
	   src_in => freq_40MHz_i      -- WIDTH-bit input: Input single-bit array to be synchronized to destination clock
	);
	
	freq_gtu_clk_meter: process(axi_clk)
		variable state : integer range 0 to 1 := 0;
	begin
		if(rising_edge(axi_clk)) then
			if(one_sec_imp = '1') then
				freq_gtu_clk <= freq_gtu_clk_cnt;
				freq_gtu_clk_cnt <= (others => '0');
			else
				case state is
					when 0 => if(gtu_clk_i = '1') then
											freq_gtu_clk_cnt <= freq_gtu_clk_cnt + 1;
											state := state + 1;
										end if;
					when 1 => if(gtu_clk_i = '0') then
											state := 0;
										end if;
				end case;
			end if;
		end if;
	end process; 

	cnt_gtu_clk_meter: process(axi_clk)
	begin
		if(rising_edge(axi_clk)) then
			if(reset_cnt = '1') then
				cnt_gtu_clk_i <= (others => '0');
			elsif(gtu_clk_i = '1') then
				cnt_gtu_clk_i <= cnt_gtu_clk_i + 1;
			end if;
		end if;
	end process; 
	
	cnt_gtu_clk <= cnt_gtu_clk_i;

	cnt_1pps_meter: process(axi_clk)
		variable state : integer range 0 to 1 := 0;
	begin
		if(rising_edge(axi_clk)) then
			if(reset_cnt = '1') then
				cnt_1pps_i <= (others => '0');
				state := 0;
			else
				case state is
					when 0 => if(spb_1pps_sync = '1') then
											cnt_1pps_i <= cnt_1pps_i + 1;
											state := state + 1;
										end if;
					when 1 => if(spb_1pps_sync = '0') then
											state := 0;	
										end if;
				end case;
				
			end if;
		end if;
	end process; 	
	
	cnt_1pps <= cnt_1pps_i;
	
	cnt_Ext_trig_meter: process(axi_clk)
		variable state : integer range 0 to 1 := 0;
	begin
		if(rising_edge(axi_clk)) then
			if(reset_cnt = '1') then
				cnt_Ext_trig_i <= (others => '0');
				state := 0;
			else
				case state is
					when 0 => if(SPB_Ext_trig_IN_sync = '1') then
											cnt_Ext_trig_i <= cnt_Ext_trig_i + 1;
											state := state + 1;
										end if;
					when 1 => if(SPB_Ext_trig_IN_sync = '0') then
											state := 0;
										end if;
				end case;
			end if;
		end if;
	end process; 	
	
	cnt_Ext_trig <= cnt_Ext_trig_i;
	
	status(0) <= SPB_CLK_40_locked_sync_axi;
	status(1) <= gtu_clk_i;
	status(2) <= spb_1pps_sync;
	status(3) <= SPB_Busy_sync;
	status(4) <= SPB_Ext_trig_IN_sync;
	 
end Behavioral;
