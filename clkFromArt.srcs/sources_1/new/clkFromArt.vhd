----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2019 04:38:20 PM
-- Design Name: 
-- Module Name: clkFromArt - Behavioral
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

			
			

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clkFromArt is
    Port ( 
    	clk_in1_p, clk_in1_n : in STD_LOGIC;
    	led: out std_logic
    	);
end clkFromArt;

architecture Behavioral of clkFromArt is

	component clk_wiz_0
	port
	 (-- Clock in ports
		-- Clock out ports
		clk_out1          : out    std_logic;
		-- Status and control signals
		reset             : in     std_logic;
		locked            : out    std_logic;
		clk_in1_p         : in     std_logic;
		clk_in1_n         : in     std_logic
	 );
	end component;
	
	signal clk: std_logic;
	signal locked: std_logic;
	signal counter: std_logic_vector(28 downto 0);

attribute KEEP : string;
attribute KEEP of counter: signal is "TRUE";
attribute KEEP of locked: signal is "TRUE";


begin

	i_clk_wiz_0 : clk_wiz_0
   port map ( 
  -- Clock out ports  
   clk_out1 => clk,
  -- Status and control signals                
   reset => '0',
   locked => locked,
   -- Clock in ports
   clk_in1_p => clk_in1_p,
   clk_in1_n => clk_in1_n
 );
 
 	process(clk)
 	begin
 		if(rising_edge(clk)) then
 			counter <= counter + 1;
 		end if;
 	end process;

	led <= counter(28);
end Behavioral;
