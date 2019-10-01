----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/03/2019 07:14:02 PM
-- Design Name: 
-- Module Name: data_provider_z3 - Behavioral
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

Library UNISIM;
use UNISIM.vcomponents.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity data_provider_z3 is
 		generic
		 (-- width of the data for the system
		  SYS_W       : integer := 13;
		  C_DATA_WIDTH       : integer := 8;
 	 -- width of the data for the device
		  DEV_W       : integer := 104);
    Port ( 
			data_in_from_pins_p     : in    std_logic_vector(SYS_W-1 downto 0);
			data_in_from_pins_n     : in    std_logic_vector(SYS_W-1 downto 0);
			clk_in_p                : in    std_logic;                    -- Differential fast clock from IOB
			clk_in_n                : in    std_logic;
			ref_clock                : in    std_logic;
			in_delay_reset                : in    std_logic;
			in_delay_tap_in         : in    std_logic_vector(5*SYS_W -1 downto 0);
			--out
			m_axis_tdata   : out    std_logic_vector(12*8-1 downto 0);
			m_axis_tvalid: out std_logic;
			m_axis_tlast: out std_logic;
			
			
			clk_user: out std_logic
   	);
end data_provider_z3;

architecture Behavioral of data_provider_z3 is

	
component selectio_wiz_1
	generic
	 (-- width of the data for the system
	  SYS_W       : integer := 13;
	  -- width of the data for the device
	  DEV_W       : integer := 104);
	port
	 (
	  -- From the system into the device
	  data_in_from_pins_p     : in    std_logic_vector(SYS_W-1 downto 0);
	  data_in_from_pins_n     : in    std_logic_vector(SYS_W-1 downto 0);
	  data_in_to_device       : out   std_logic_vector(DEV_W-1 downto 0);
	
	-- Input, Output delay control signals
	  in_delay_reset          : in    std_logic;                    -- Active high synchronous reset for input delay
	  in_delay_data_ce        : in    std_logic_vector(SYS_W -1 downto 0);                    -- Enable signal for delay 
	  in_delay_data_inc       : in    std_logic_vector(SYS_W -1 downto 0);                    -- Delay increment (high), decrement (low) signal
	  in_delay_tap_in         : in    std_logic_vector(5*SYS_W -1 downto 0); -- Dynamically loadable delay tap value for input delay
	  in_delay_tap_out        : out   std_logic_vector(5*SYS_W -1 downto 0); -- Delay tap value for monitoring input delay
	  delay_locked            : out   std_logic;                    -- Locked signal from IDELAYCTRL
	  ref_clock               : in    std_logic;                    -- Reference Clock for IDELAYCTRL. Has to come from BUFG.
	  bitslip                 : in    std_logic_vector(SYS_W-1 downto 0);                    -- Bitslip module is enabled in NETWORKING mode
	                                                                -- User should tie it to '0' if not needed
	 
	-- Clock and reset signals
	  clk_in_p                : in    std_logic;                    -- Differential fast clock from IOB
	  clk_in_n                : in    std_logic;
	  clk_div_out             : out   std_logic;                    -- Slow clock output
	  clk_reset               : in    std_logic;                    -- Reset signal for Clock circuit
	  io_reset                : in    std_logic);                   -- Reset signal for IO circuit
	end component;
	
	signal data_in_to_device : std_logic_vector(DEV_W-1 downto 0);
	signal bitslip  :  std_logic_vector(SYS_W-1 downto 0);
	signal bitslip_cmd  :  std_logic := '0';
	signal valid_i  :  std_logic := '0';
	signal clk_div_out, clk_div_out_bg: std_logic;
	
	signal dataout0_i : std_logic_vector(C_DATA_WIDTH-1 downto 0);
	signal dataout1_i : std_logic_vector(C_DATA_WIDTH-1 downto 0);
	signal dataout2_i : std_logic_vector(C_DATA_WIDTH-1 downto 0);
	signal dataout3_i : std_logic_vector(C_DATA_WIDTH-1 downto 0);
	signal dataout4_i : std_logic_vector(C_DATA_WIDTH-1 downto 0);
	signal dataout5_i : std_logic_vector(C_DATA_WIDTH-1 downto 0);
	signal dataout6_i : std_logic_vector(C_DATA_WIDTH-1 downto 0);
	signal dataout7_i : std_logic_vector(C_DATA_WIDTH-1 downto 0);
	signal dataout8_i : std_logic_vector(C_DATA_WIDTH-1 downto 0);
	signal dataout9_i : std_logic_vector(C_DATA_WIDTH-1 downto 0);
	signal dataout10_i : std_logic_vector(C_DATA_WIDTH-1 downto 0);
	signal dataout11_i : std_logic_vector(C_DATA_WIDTH-1 downto 0);
	signal dataout12_i : std_logic_vector(C_DATA_WIDTH-1 downto 0);
	signal frame_data : std_logic_vector(C_DATA_WIDTH-1 downto 0);

	signal tlast_cnt: std_logic_vector(6 downto 0)  := (others => '0');
	signal tlast_allowed: std_logic := '0';

 	signal bitlslip_vector:  STD_LOGIC_VECTOR(12 downto 0);


begin

i_selectio_wiz_1 : selectio_wiz_1
	port map
	 (
	  -- From the system into the device
	  data_in_from_pins_p   => data_in_from_pins_p,--  : in    std_logic_vector(SYS_W-1 downto 0);
	  data_in_from_pins_n => data_in_from_pins_n,--     : in    std_logic_vector(SYS_W-1 downto 0);
	  data_in_to_device => data_in_to_device,--       : out   std_logic_vector(DEV_W-1 downto 0);
	
	-- Input, Output delay control signals
	  in_delay_reset => in_delay_reset,--          : in    std_logic;                    -- Active high synchronous reset for input delay
	  in_delay_data_ce => (others => '0'),--        : in    std_logic_vector(SYS_W -1 downto 0);                    -- Enable signal for delay 
	  in_delay_data_inc => (others => '0'),--       : in    std_logic_vector(SYS_W -1 downto 0);                    -- Delay increment (high), decrement (low) signal
	  in_delay_tap_in => in_delay_tap_in,--         : in    std_logic_vector(5*SYS_W -1 downto 0); -- Dynamically loadable delay tap value for input delay
	  in_delay_tap_out => open,--        : out   std_logic_vector(5*SYS_W -1 downto 0); -- Delay tap value for monitoring input delay
	  delay_locked => open,--            : out   std_logic;                    -- Locked signal from IDELAYCTRL
	  ref_clock => ref_clock,--               : in    std_logic;                    -- Reference Clock for IDELAYCTRL. Has to come from BUFG.
	  bitslip => bitlslip_vector,--                 : in    std_logic_vector(SYS_W-1 downto 0);                    -- Bitslip module is enabled in NETWORKING mode
	                                                                -- User should tie it to '0' if not needed
	 
	-- Clock and reset signals
	  clk_in_p => clk_in_p,--                : in    std_logic;                    -- Differential fast clock from IOB
	  clk_in_n => clk_in_n,--                : in    std_logic;
	  clk_div_out => clk_div_out,--             : out   std_logic;                    -- Slow clock output
	  clk_reset => '0',--               : in    std_logic;                    -- Reset signal for Clock circuit
	  io_reset => '0');--                : in    std_logic);                   -- Reset signal for IO circuit


   BUFG_inst : BUFG
   port map (
      O => clk_div_out_bg, -- 1-bit output: Clock output
      I => clk_div_out  -- 1-bit input: Clock input
   );


	remix_gen: for i in 0 to C_DATA_WIDTH-1 generate
		remix: process(clk_div_out_bg)
		begin
			if(rising_edge(clk_div_out_bg)) then
				dataout0_i(i) <= data_in_to_device(0+13*i); 
				dataout1_i(i) <= data_in_to_device(1+13*i); 
				dataout2_i(i) <= data_in_to_device(2+13*i); 
				dataout3_i(i) <= data_in_to_device(3+13*i); 
				dataout4_i(i) <= data_in_to_device(4+13*i); 
				dataout5_i(i) <= data_in_to_device(5+13*i); 
				dataout6_i(i) <= data_in_to_device(6+13*i); 
				dataout7_i(i) <= data_in_to_device(7+13*i); 
				dataout8_i(i) <= data_in_to_device(8+13*i); 
				dataout9_i(i) <= data_in_to_device(9+13*i); 
				dataout10_i(i) <= data_in_to_device(10+13*i); 
				dataout11_i(i) <= data_in_to_device(11+13*i); 
				dataout12_i(i) <= data_in_to_device(12+13*i); 
				frame_data(i) <= data_in_to_device(12+13*i);
			end if;
		end process;
	end generate;

	sm: process(clk_div_out_bg)
		variable state : integer range 0 to 1 := 0;
	begin
		if(rising_edge(clk_div_out_bg)) then
			case state is
				when -0 => 
									if(frame_data = 0) then
										state := state + 1;
										end if;
									bitslip_cmd <= '0';
				when 1 => if(frame_data /= 0 and  frame_data /= X"FF") then
										bitslip_cmd <= '1';
									else
										bitslip_cmd <= '0';
									end if;
									state := 0;	
			end case;
		end if;
	end process;
	
	tlast_counter: process(clk_div_out_bg)
	begin
		if(rising_edge(clk_div_out_bg)) then
			if(valid_i = '1' and dataout12_i(0) = '0') then
				tlast_cnt <= tlast_cnt + 1;
				if(tlast_cnt = "1111111") then
					tlast_allowed <= '1';
				else
					tlast_allowed <= '0';
				end if;
			end if;
		end if;
	end process;
		
	bitlslip_vector <= (others => bitslip_cmd);
	
	m_axis_tdata <= 
		dataout11_i &
		dataout10_i &
		dataout9_i &
		dataout8_i &
		dataout7_i &
		dataout6_i &
		dataout5_i &
		dataout4_i &
		dataout3_i &
		dataout2_i &
		dataout1_i & 
		dataout0_i when rising_edge(clk_div_out_bg);
	
	valid_i <= dataout12_i(0) when rising_edge(clk_div_out_bg);
	m_axis_tvalid <= valid_i;
	m_axis_tlast <= valid_i and not dataout12_i(0) and tlast_allowed;
	clk_user <= clk_div_out_bg;


end Behavioral;
