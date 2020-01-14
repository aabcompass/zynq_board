----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/16/2019 12:50:20 PM
-- Design Name: 
-- Module Name: data_converter_ins - Behavioral
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
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity data_converter_ins is
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
    	m_axis_aclk: in std_logic;
    	m_axis_aresetn : in STD_LOGIC;
    	m_axis_tdata : out STD_LOGIC_VECTOR(127 downto 0);
    	m_axis_tuser : out STD_LOGIC_VECTOR(5 downto 0);
    	m_axis_tvalid : out STD_LOGIC;
    	m_axis_tlast : out STD_LOGIC;
    	m_axis_tready : in STD_LOGIC    	 
  );
end data_converter_ins;

architecture Behavioral of data_converter_ins is

	component data_converter is
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

    signal	tdata_art0 : STD_LOGIC_VECTOR(8*12-1 downto 0) := (others => '0');
    signal	tdata_art1 : STD_LOGIC_VECTOR(8*12-1 downto 0) := (others => '0');
    signal	tdata_art2 : STD_LOGIC_VECTOR(8*12-1 downto 0) := (others => '0');

begin

		
		tdata_art0 <= tdata_art0 + 1 when rising_edge(clk_art0);
		tdata_art1 <= tdata_art1 + 1 when rising_edge(clk_art1);
		tdata_art2 <= tdata_art2 + 1 when rising_edge(clk_art2);

		i_data_converter : data_converter 
		Port map( 
				areset_art => areset_art,--: in std_logic;
				clk_art0 => clk_art0,-- : in STD_LOGIC;
				clk_art1 => clk_art1,-- : in STD_LOGIC;
				clk_art2 => clk_art2,-- : in STD_LOGIC;
				tvalid_art0 => tvalid_art0,-- : in STD_LOGIC;
				tvalid_art1 => tvalid_art1,-- : in STD_LOGIC;
				tvalid_art2 => tvalid_art2,-- : in STD_LOGIC;
				tlast_art0 => tlast_art0,-- : in STD_LOGIC;
				tlast_art1 => tlast_art1,-- : in STD_LOGIC;
				tlast_art2 => tlast_art2,-- : in STD_LOGIC;
				tdata_art0 => tdata_art0,-- : in STD_LOGIC_VECTOR(8*12-1 downto 0);
				tdata_art1 => tdata_art1,-- : in STD_LOGIC_VECTOR(8*12-1 downto 0);
				tdata_art2  => tdata_art2,--: in STD_LOGIC_VECTOR(8*12-1 downto 0);
				m_axis_aclk => m_axis_aclk,--: in std_logic;
				m_axis_aresetn => m_axis_aresetn,-- : in STD_LOGIC;
				m_axis_tdata => m_axis_tdata,-- : out STD_LOGIC_VECTOR(127 downto 0);
				m_axis_tuser => m_axis_tuser,-- : out STD_LOGIC_VECTOR(5 downto 0);
				m_axis_tvalid => m_axis_tvalid,-- : out STD_LOGIC;
				m_axis_tlast => m_axis_tlast,-- : out STD_LOGIC;
				m_axis_tready => m_axis_tready-- : in STD_LOGIC    	 
		);

end Behavioral;
