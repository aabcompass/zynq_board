----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.03.2021 18:41:03
-- Design Name: 
-- Module Name: pixel_remap_v2 - Behavioral
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

entity pixel_remap_v2 is
    Port ( clk : in STD_LOGIC;
           s_axis_tdata : in STD_LOGIC_VECTOR(8*64-1 downto 0);
           s_axis_tvalid : in STD_LOGIC;
           s_axis_tlast : in STD_LOGIC;
           m_axis_tdata : out STD_LOGIC_VECTOR(8*64-1 downto 0);
           m_axis_tvalid : out STD_LOGIC;
           m_axis_tlast : out STD_LOGIC;
           map0 : in STD_LOGIC_VECTOR (8*64-1 downto 0));
end pixel_remap_v2;

architecture Behavioral of pixel_remap_v2 is

	attribute keep_hierarchy : string;
	attribute keep_hierarchy of Behavioral : architecture is "yes";


component pixel_remap_sw is
    Port ( clk : in STD_LOGIC;
           datain : in STD_LOGIC_VECTOR (8*64-1 downto 0);
           dataout : out STD_LOGIC_VECTOR (7 downto 0);
           addr : in STD_LOGIC_VECTOR (7 downto 0));
	end component;

begin

	pix_gen: for i in 0 to 63 generate
		i_pixel_remap_sw: pixel_remap_sw 
		port map(clk => clk,
			datain => s_axis_tdata,
			dataout => m_axis_tdata(i*8+7 downto i*8),
			addr => map0((63-i)*8+7 downto (63-i)*8));
	end generate; 

end Behavioral;
