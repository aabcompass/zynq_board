----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/23/2019 03:36:29 PM
-- Design Name: 
-- Module Name: dataconv_switch - Behavioral
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

entity dataconv_switch is
		generic(
			n_bytes: integer := 16;
			n_lines: integer:= 12;
			log_n_lines: integer:= 4
		);
	  PORT (
      aclk : IN STD_LOGIC;
      aresetn : IN STD_LOGIC;
      n_line: IN STD_LOGIC_VECTOR(log_n_lines-1 DOWNTO 0);
      s_axis_tvalid : IN STD_LOGIC_VECTOR(n_lines-1 DOWNTO 0);
      s_axis_tready : OUT STD_LOGIC_VECTOR(n_lines-1 DOWNTO 0) := (others => '1');
      s_axis_tdata : IN STD_LOGIC_VECTOR(8*n_lines*n_bytes-1 DOWNTO 0);
      s_axis_tlast : IN STD_LOGIC_VECTOR(n_lines-1 DOWNTO 0);
      s_axis_tuser : IN STD_LOGIC_VECTOR(n_lines*6-1 DOWNTO 0);
      m_axis_tvalid : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      m_axis_tready : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      m_axis_tdata : OUT STD_LOGIC_VECTOR(n_bytes*8-1 DOWNTO 0);
      m_axis_tlast : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      m_axis_tuser : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
      s_req_suppress : IN STD_LOGIC_VECTOR(n_lines-1 DOWNTO 0);
      s_decode_err : OUT STD_LOGIC_VECTOR(n_lines-1 DOWNTO 0)
    );
end dataconv_switch;

architecture Behavioral of dataconv_switch is

	attribute keep_hierarchy : string;
	attribute keep_hierarchy of Behavioral : architecture is "yes";

begin

	sw: process(aclk)
		variable i : integer range 0 to n_lines-1 := 0;
	begin
		if(rising_edge(aclk)) then
			for i in 0 to n_lines-1 loop
				if(i = conv_integer(n_line)) then
					m_axis_tvalid(0) <= s_axis_tvalid(i);
					m_axis_tlast(0) <= s_axis_tlast((i));
					m_axis_tuser(5 downto 0) <= s_axis_tuser(6*((i)+1)-1 downto 6*(i));
					m_axis_tdata(n_bytes*8-1 DOWNTO 0) <= s_axis_tdata(n_bytes*8*((i)+1)-1  downto  n_bytes*8*(i));
				end if;
			end loop;
		end if;
	end process;

end Behavioral;
