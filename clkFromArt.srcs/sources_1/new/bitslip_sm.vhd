----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/01/2019 04:31:17 PM
-- Design Name: 
-- Module Name: bitslip_sm - Behavioral
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

entity bitslip_sm is
    Generic (C_SERIALIZATION: integer := 8;
    				C_DATA_WIDTH: integer:= 8);
    Port ( clk : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (103 downto 0);
           dataout0: out STD_LOGIC_VECTOR(7 downto 0);
           dataout1: out STD_LOGIC_VECTOR(7 downto 0);
           dataout2: out STD_LOGIC_VECTOR(7 downto 0);
           dataout3: out STD_LOGIC_VECTOR(7 downto 0);
           dataout4: out STD_LOGIC_VECTOR(7 downto 0);
           dataout5: out STD_LOGIC_VECTOR(7 downto 0);
           dataout6: out STD_LOGIC_VECTOR(7 downto 0);
           dataout7: out STD_LOGIC_VECTOR(7 downto 0);
           dataout8: out STD_LOGIC_VECTOR(7 downto 0);
           dataout9: out STD_LOGIC_VECTOR(7 downto 0);
           dataout10: out STD_LOGIC_VECTOR(7 downto 0);
           dataout11: out STD_LOGIC_VECTOR(7 downto 0);
           dataout12: out STD_LOGIC_VECTOR(7 downto 0);
           bitlslip_vector: out STD_LOGIC_VECTOR(12 downto 0)
           );
end bitslip_sm;

architecture Behavioral of bitslip_sm is

	signal frame_data: std_logic_vector(7 downto 0) := (others => '0');
	signal bitslip_cmd: std_logic := '0';

begin

	remix_gen: for i in 0 to C_DATA_WIDTH-1 generate
		remix: process(clk)
		begin
			if(rising_edge(clk)) then
				dataout0(i) <= data_in(0+13*i); 
				dataout1(i) <= data_in(1+13*i); 
				dataout2(i) <= data_in(2+13*i); 
				dataout3(i) <= data_in(3+13*i); 
				dataout4(i) <= data_in(4+13*i); 
				dataout5(i) <= data_in(5+13*i); 
				dataout6(i) <= data_in(6+13*i); 
				dataout7(i) <= data_in(7+13*i); 
				dataout8(i) <= data_in(8+13*i); 
				dataout9(i) <= data_in(9+13*i); 
				dataout10(i) <= data_in(10+13*i); 
				dataout11(i) <= data_in(11+13*i); 
				dataout12(i) <= data_in(12+13*i); 
				frame_data(i) <= data_in(12+13*i);
			end if;
		end process;
	end generate;

	sm: process(clk)
		variable state : integer range 0 to 1 := 0;
	begin
		if(rising_edge(clk)) then
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
		
	bitlslip_vector <= (others => bitslip_cmd);

end Behavioral;
