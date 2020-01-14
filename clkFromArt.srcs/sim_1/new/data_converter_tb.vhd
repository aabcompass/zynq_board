----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/12/2019 06:02:05 PM
-- Design Name: 
-- Module Name: data_converter_tb - Behavioral
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
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity data_converter_tb is
--  Port ( );
end data_converter_tb;

architecture Behavioral of data_converter_tb is

	component data_converter 
    Generic (
   	 	N_ART: integer := 3;
   	 	N_PMT: integer := 12
    );
    Port ( 
    	areset_art: in std_logic;
    	clk_art0 : in STD_LOGIC;
    	clk_art1 : in STD_LOGIC;
    	clk_art2 : in STD_LOGIC;
    	tvalid_art0 : in STD_LOGIC;
    	tvalid_art1 : in STD_LOGIC;
    	tvalid_art2 : in STD_LOGIC;
    	tlast_art0 : in STD_LOGIC;
    	tlast_art1 : in STD_LOGIC;
    	tlast_art2 : in STD_LOGIC;
    	tdata_art0 : in STD_LOGIC_VECTOR(8*12-1 downto 0);
    	tdata_art1 : in STD_LOGIC_VECTOR(8*12-1 downto 0);
    	tdata_art2 : in STD_LOGIC_VECTOR(8*12-1 downto 0);
    	m_axis_aclk: in std_logic;
    	m_axis_aresetn : in STD_LOGIC;
    	m_axis_tdata : out STD_LOGIC_VECTOR(127 downto 0);
    	m_axis_tuser : out STD_LOGIC_VECTOR(5 downto 0);
    	m_axis_tvalid : out STD_LOGIC;
    	m_axis_tlast : out STD_LOGIC;
    	m_axis_tready : in STD_LOGIC    	
    	);
	end component;
	
	signal clk_art : std_logic := '0'; --100 MHz
	signal m_axis_aclk : std_logic := '0'; -- 200 MHz
	signal areset_art: std_logic := '0';
	signal m_axis_aresetn: std_logic := '0';
	signal tvalid_art: std_logic := '0';
	signal tlast_art: std_logic := '0';
	
	signal tvalid_cnt1, tvalid_cnt2, clk_art_cnt, m_axis_aclk_cnt: integer  := 0;


begin

	process
	begin
		wait for 5 ns;
		clk_art <= '0';
		wait for 5 ns;
		clk_art <= '1';		
		clk_art_cnt <= clk_art_cnt + 1;
	end process;

	process
	begin
		wait for 2.5 ns;
		m_axis_aclk <= '0';
		wait for 2.5 ns;
		m_axis_aclk <= '1';		
		m_axis_aclk_cnt <= m_axis_aclk_cnt + 1;
	end process;

	reset_process: process(clk_art)
	begin
		if(rising_edge(clk_art)) then
			if(clk_art_cnt = 10) then
				areset_art <= '1';
			end if;
		end if;
	end process;

	maxis_reset_process: process(m_axis_aclk)
	begin
		if(rising_edge(m_axis_aclk)) then
			if(m_axis_aclk_cnt = 10) then
				m_axis_aresetn <= '1';
			end if;
		end if;
	end process;

	
	dut_process: process(clk_art)
		variable state : integer range 0 to 1 := 0;
	begin
		if(rising_edge(clk_art)) then
			case state is
				when 0 => 
					if(tvalid_cnt1 = 35) then
						tvalid_cnt1 <= 0;
						state := state + 1;
					else
						tvalid_cnt1 <= tvalid_cnt1 + 1;
					end if;
					tvalid_art <= '0';
					tlast_art <= '0';
				when 1 => 
					if(tvalid_cnt2 = 63) then
						tvalid_cnt2 <= 0;
						tlast_art <= '1';
						state := 0;
					else
						tvalid_cnt2 <= tvalid_cnt2 + 1;
						tlast_art <= '0';
					end if;
					tvalid_art <= '1';
			end case;
		end if;
	end process;

	dut: data_converter 
    Port map( 
    	areset_art => areset_art,--: in std_logic;
    	clk_art0 => clk_art,--: : in STD_LOGIC;
    	clk_art1 => clk_art,--: : in STD_LOGIC;
    	clk_art2 => clk_art,--: : in STD_LOGIC;
    	tvalid_art0 => tvalid_art,--: : in STD_LOGIC;
    	tvalid_art1 => tvalid_art,--: : in STD_LOGIC;
    	tvalid_art2 => tvalid_art,--: : in STD_LOGIC;
    	tlast_art0 => tlast_art,--: : in STD_LOGIC;
    	tlast_art1 => tlast_art,--: : in STD_LOGIC;
    	tlast_art2 => tlast_art,--: : in STD_LOGIC;
    	tdata_art0 => (others => '0'),--: : in STD_LOGIC_VECTOR(8*12-1 downto 0);
    	tdata_art1 => (others => '0'),--: : in STD_LOGIC_VECTOR(8*12-1 downto 0);
    	tdata_art2 => (others => '0'),--: : in STD_LOGIC_VECTOR(8*12-1 downto 0);
    	m_axis_aclk => m_axis_aclk,--:: in std_logic;
    	m_axis_aresetn => m_axis_aresetn,--: : in STD_LOGIC;
    	m_axis_tdata => open,--: : out STD_LOGIC_VECTOR(127 downto 0);
    	m_axis_tuser => open,--: : out STD_LOGIC_VECTOR(5 downto 0);
    	m_axis_tvalid => open,--: : out STD_LOGIC;
    	m_axis_tlast => open,--: : out STD_LOGIC;
    	m_axis_tready => '1' --: : in STD_LOGIC    	
    	);

end Behavioral;
