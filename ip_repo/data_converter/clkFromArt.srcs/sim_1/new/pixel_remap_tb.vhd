

Library xpm;
use xpm.vcomponents.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;



entity pixel_remap_tb is
--  Port ( );
end pixel_remap_tb;

architecture Behavioral of pixel_remap_tb is


	component pixel_remap is
    Port ( clk : in STD_LOGIC;
           reset: in STD_LOGIC;
           map_table_data : in STD_LOGIC_VECTOR (5 downto 0);
           map_table_addr : in STD_LOGIC_VECTOR (5 downto 0);
           datain : in STD_LOGIC_VECTOR (7 downto 0);
           datain_dv : in STD_LOGIC;
           datain_tlast : in STD_LOGIC;
           dataout : out STD_LOGIC_VECTOR (7 downto 0);
           dataout_dv : out STD_LOGIC;
           dataout_tlast : out STD_LOGIC);
	end component;

	signal clk : std_logic := '0';
	signal loaded : std_logic := '0';
	signal map_table_addr, map_table_data: std_logic_vector(5 downto 0) := (others => '0');
	signal datain: std_logic_vector(7 downto 0) := conv_std_logic_vector(0, 8);

begin

	clk_process: process
	begin
		wait for 5 ns;
		clk <= '1';
		wait for 5 ns;
		clk <= '0';	
	end process;
	
	load_process: process(clk)
	begin
		if(rising_edge(clk)) then
			if(map_table_addr /= "111111") then
				map_table_addr <= map_table_addr + 1;
			else
				loaded <= '1';
			end if;
		end if;
	end process;
	
	map_table_data <= not map_table_addr;
	
	data_gen: process(clk)
	begin
		if(rising_edge(clk)) then
			if(loaded = '1') then
				datain <= datain + 1;
			end if;
		end if;
	end process;

	dut: pixel_remap 
    Port map( clk => clk, --: in STD_LOGIC;
           reset => '0', --: in STD_LOGIC;
           map_table_data => map_table_data, -- : in STD_LOGIC_VECTOR (5 downto 0);
           map_table_addr => map_table_addr, -- : in STD_LOGIC_VECTOR (5 downto 0);
           datain => datain, -- : in STD_LOGIC_VECTOR (95 downto 0);
           datain_dv => loaded, -- : in STD_LOGIC;
           datain_tlast => '0', -- : in STD_LOGIC;
           dataout => open, -- : out STD_LOGIC_VECTOR (95 downto 0);
           dataout_dv => open, -- : out STD_LOGIC;
           dataout_tlast => open); -- : out STD_LOGIC);
	

end Behavioral;
