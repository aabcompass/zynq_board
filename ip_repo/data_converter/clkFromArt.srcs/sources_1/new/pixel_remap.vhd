Library xpm;
use xpm.vcomponents.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity pixel_remap is
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
end pixel_remap;

architecture Behavioral of pixel_remap is

COMPONENT dist_mem_gen_1
  PORT (
    a : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
    d : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
    dpra : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
    clk : IN STD_LOGIC;
    we : IN STD_LOGIC;
    qdpo : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
  );
END COMPONENT;

COMPONENT dist_mem_gen_0
  PORT (
    a : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    d : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    dpra : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    clk : IN STD_LOGIC;
    we : IN STD_LOGIC;
    qdpo : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END COMPONENT;



	signal counter, counter_d1 : std_logic_vector(6 downto 0) := (others => '0');
	signal dpo : std_logic_vector(5 downto 0) := (others => '0');
	signal dpra : std_logic_vector(6 downto 0) := (others => '0');
	signal datain_dv_d1, datain_dv_d2, datain_dv_d3 : std_logic := '0';
	signal datain_tlast_d1, datain_tlast_d2, datain_tlast_d3 : std_logic := '0';
	
	


begin

	counter_proc: process(clk)
	begin
		if(rising_edge(clk)) then
			if(datain_dv = '1') then
				counter <= counter + 1;
			end if;
		end if;
	end process;
	
	counter_d1 <= counter when rising_edge(clk);

	addr_store : dist_mem_gen_1
  PORT MAP (
    a => map_table_addr,
    d => map_table_data,
    dpra => counter(5 downto 0),
    clk => clk,
    we => '1',
    qdpo => dpo
  );
  
	dpra <= (not counter_d1(6)) & dpo when rising_edge(clk);


	main_remap : dist_mem_gen_0
  PORT MAP (
    a => counter,
    d => datain,
    dpra => dpra,
    clk => clk,
    we => datain_dv,
    qdpo => dataout
  );

	datain_dv_d1 <= datain_dv when rising_edge(clk);
	datain_dv_d2 <= datain_dv_d1 when rising_edge(clk);
	datain_dv_d3 <= datain_dv_d2 when rising_edge(clk);
	dataout_dv <= datain_dv_d3 when rising_edge(clk);
	
	datain_tlast_d1 <= datain_tlast when rising_edge(clk);
	datain_tlast_d2 <= datain_tlast_d1 when rising_edge(clk);
	datain_tlast_d3 <= datain_tlast_d2 when rising_edge(clk);
	dataout_tlast <= datain_tlast_d3 when rising_edge(clk);


end Behavioral;
