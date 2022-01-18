library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity test_data_provider_tb is
--  Port ( );
end test_data_provider_tb;

architecture Behavioral of test_data_provider_tb is

	signal clk : std_logic := '0';

	component test_data_provider is
    Port ( 
    clk : in STD_LOGIC;
    aresetn: in std_logic;
    started: in std_logic;
    status : out std_logic_vector(7 downto 0);
    incr_period: in std_logic_vector(31 downto 0);
    patt_init: in std_logic_vector(7 downto 0);
    patt_max: in std_logic_vector(7 downto 0);
    s_axis_tvalid: in std_logic;
    s_axis_tlast: in std_logic;
    m_axis_tvalid: out std_logic;
    m_axis_tlast: out std_logic;
    m_axis_tdata: out std_logic_vector(127 downto 0)
    );
	end component;

	constant PERIOD : time := 10 ns;
	signal clk_counter: integer  := 0;
	signal cnt_gen: integer  := 250;
	signal resetn : std_logic := '0';
	signal started : std_logic := '0';
	signal s_axis_tvalid : std_logic := '0';
	signal s_axis_tlast : std_logic := '0';

begin
	
	clk_process: process
	begin
		clk <= '0';
		wait for PERIOD/2;
		clk <= '1';
		wait for PERIOD/2; 
	end process;
	
	dut_proc: process(clk)
	begin
		if(rising_edge(clk)) then
			if(clk_counter = 10) then resetn <= '1'; end if;
			if(clk_counter = 20) then started <= '1'; end if;
			if(cnt_gen = 300) then
				cnt_gen <= 0;
			else
				cnt_gen <= cnt_gen + 1;
			end if;
		end if;
	end process;
	
	input_gen: process(clk)
	begin
		if(rising_edge(clk)) then
			case cnt_gen is
				when 1 to 60 => s_axis_tvalid <= '1';
				when 61 to 70 => s_axis_tvalid <= '0';
				when 71 to 130 => s_axis_tvalid <= '1';
				when 131 to 140 => s_axis_tvalid <= '0';
				when 141 to 199 => s_axis_tvalid <= '1';
				when 200 => s_axis_tvalid <= '1';  s_axis_tlast <= '1';
				when others => s_axis_tvalid <= '0';  s_axis_tlast <= '0';
			end case;
		end if;
	end process;
	
	clk_counter <= clk_counter + 1 when rising_edge(clk);
	
		dut: test_data_provider 
    Port map ( 
    clk => clk,--: in STD_LOGIC;
    aresetn => resetn,--: in std_logic;
    started => started,--: in std_logic;
    status => open,
    incr_period => conv_std_logic_vector(2, 32),--: in std_logic_vector(31 downto 0);
    patt_init => X"00",--: in std_logic_vector(7 downto 0);
    patt_max => X"0A",--: in std_logic_vector(7 downto 0);
    s_axis_tvalid => s_axis_tvalid,--: in std_logic;
    s_axis_tlast => s_axis_tlast,--: in std_logic;
    m_axis_tvalid => open,--: out std_logic;
    m_axis_tlast => open,--: out std_logic;
    m_axis_tdata => open--: out std_logic_vector(127 downto 0)
    );

	

end Behavioral;
