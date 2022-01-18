library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity test_data_provider is
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
end test_data_provider;

architecture Behavioral of test_data_provider is

	attribute KEEP_HIERARCHY : string;
	attribute KEEP_HIERARCHY of Behavioral: architecture is "TRUE";
	
	signal patt : std_logic_vector(7 downto 0) := (others => '0');
	signal trans_cnt : std_logic_vector(31 downto 0) := (others => '0');

begin

	process(clk)
		variable state : integer range 0 to 3 := 0;
	begin
		if(rising_edge(clk)) then
			if(aresetn = '0') then
				state := 0;
			else
				status <= conv_std_logic_vector(state, 8);
				case state is	
					when 0 => if(started = '1') then 
											state := state + 1; 
											patt <= patt_init; 
											trans_cnt <= (others => '0'); 
										end if;
										m_axis_tvalid <= '0';
										m_axis_tlast <= '0';										
					when 1 => if(s_axis_tvalid = '1' and s_axis_tlast = '1' ) then
											state := state + 1;
										end if;
					when 2 => if(s_axis_tvalid = '1') then
											if(trans_cnt = incr_period) then
												if(patt = patt_max) then
													patt <= patt_init;
												else
													patt <= patt + 1;
												end if;
												trans_cnt <= (0 => '1', others => '0');
											else
												trans_cnt <= trans_cnt + 1;
											end if;
											m_axis_tvalid <= s_axis_tvalid;
											m_axis_tlast <= s_axis_tlast;
										else
											m_axis_tvalid <= '0';
											m_axis_tlast <= '0';										
										end if;
										if(started = '0') then state := state + 1; end if;
					when 3 => if(s_axis_tvalid = '1') then
											m_axis_tvalid <= s_axis_tvalid;
											m_axis_tlast <= s_axis_tlast;
											if(s_axis_tlast = '1') then
												state := 0;
												m_axis_tvalid <= '0';
												m_axis_tlast <= '0';										
											end if; 
										else
											m_axis_tvalid <= '0';
											m_axis_tlast <= '0';										
										end if;
				end case;
			end if;
		end if;
	end process;
	
	m_axis_tdata <= patt & patt & patt & patt & 
									patt & patt & patt & patt & 
									patt & patt & patt & patt & 
									patt & patt & patt & patt;

end Behavioral;
