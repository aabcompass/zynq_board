library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity pixel_remap_sw is
    Port ( clk : in STD_LOGIC;
           datain : in STD_LOGIC_VECTOR (8*64-1 downto 0);
           dataout : out STD_LOGIC_VECTOR (7 downto 0);
           addr : in STD_LOGIC_VECTOR (7 downto 0));
end pixel_remap_sw;

architecture Behavioral of pixel_remap_sw is

begin

	process(clk)
	begin
		if(rising_edge(clk)) then
			sw_loop: for i in 0 to 63 loop
				if(conv_integer(addr) = i) then
					dataout <= datain(i*8+7 downto i*8);
				end if;
			end loop sw_loop;
		end if;
	end process;

end Behavioral;
