
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;


entity data_converter_tb is
  Generic ( N_PIX: integer := 72);
end data_converter_tb;

architecture Behavioral of data_converter_tb is

	component data_converter 
    Generic (
   	 	N_ART: integer := 3;
   	 	N_PMT: integer := 12
    );
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
 
 			s_axis_map0_tdata : in STD_LOGIC_VECTOR (31 downto 0);
    	s_axis_map0_tvalid : in STD_LOGIC;
    	s_axis_map0_tlast : in STD_LOGIC;
    	s_axis_map0_tready : out STD_LOGIC;

    	m_axis_aclk: in std_logic;
    	m_axis_aresetn : in STD_LOGIC;
    	m_axis_tdata : out STD_LOGIC_VECTOR(127 downto 0);
    	m_axis_tuser : out STD_LOGIC_VECTOR(7 downto 0);
    	m_axis_tvalid : out STD_LOGIC;
    	m_axis_tlast : out STD_LOGIC;
    	m_axis_tready : in STD_LOGIC;
    	prog_reset_p: in std_logic;
    	zeros: in std_logic_vector(12*3-1 downto 0)    	    	    	
    	);
	end component;
	
	signal clk_art : std_logic := '0'; --100 MHz
	signal m_axis_aclk : std_logic := '0'; -- 200 MHz
	signal areset_art: std_logic := '0';
	signal m_axis_aresetn: std_logic := '0';
	signal tvalid_art,tlast_art: std_logic_vector(2 downto 0) := "000";
	
	signal clk_art_cnt, m_axis_aclk_cnt: integer  := 0;

	signal tdata_art: std_logic_vector(3*12*8-1 downto 0) := (others => '0');
	signal tdata: std_logic_vector(3*8-1 downto 0) := (others => '0');
	
	component data_provider_4trig is
	    Port ( clk : in STD_LOGIC;
	           aresetn : in STD_LOGIC;
	           s_axis_tdata : in STD_LOGIC_VECTOR (127 downto 0);
	           s_axis_tvalid : in STD_LOGIC;
	           s_axis_tlast : in STD_LOGIC;
	           s_axis_tuser : in std_logic_vector(7 downto 0);
	           DATA : out STD_LOGIC_VECTOR (143 downto 0);
	           FRAME : out STD_LOGIC);
	end component;
	
	signal m_axis_tdata_conv: std_logic_vector(127 downto 0);
	signal m_axis_tuser_conv: std_logic_vector(7 downto 0);
	signal m_axis_tvalid_conv: std_logic;
	signal m_axis_tlast_conv: std_logic;
	
	signal s_axis_map0_tdata :  STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
  signal s_axis_map0_tvalid :  STD_LOGIC := '0';
  signal s_axis_map0_tlast :  STD_LOGIC := '0';
  signal 	s_axis_map0_tready :  STD_LOGIC;
  
  signal cnt_load_remap: STD_LOGIC_VECTOR (5 downto 0) := (others => '0');


begin

	process
	begin
		wait for 5 ns;
		clk_art <= '0';
		wait for 5 ns;
		clk_art <= '1';		
		clk_art_cnt <= clk_art_cnt + 1;
	end process;

	process
	begin
		wait for 2.5 ns;
		m_axis_aclk <= '0';
		wait for 2.5 ns;
		m_axis_aclk <= '1';		
		m_axis_aclk_cnt <= m_axis_aclk_cnt + 1;
	end process;

	reset_process: process(clk_art)
	begin
		if(rising_edge(clk_art)) then
			if(clk_art_cnt = 10) then
				areset_art <= '1';
			end if;
		end if;
	end process;

	maxis_reset_process: process(m_axis_aclk)
	begin
		if(rising_edge(m_axis_aclk)) then
			if(m_axis_aclk_cnt = 10) then
				m_axis_aresetn <= '1';
			end if;
		end if;
	end process;

	

	tvalid_gen: for i in 0 to 2 generate

		signal tvalid_cnt1, tvalid_cnt2: integer  := 0;
		
	begin		
		dut_process: process(clk_art)
			variable state : integer range 0 to 2 := 0;
		begin
			if(rising_edge(clk_art)) then
				case state is
					when 0 =>
						if(tvalid_cnt1 = i*25) then
							state := state + 1;
							tvalid_cnt1 <= 0;
						else
							tvalid_cnt1 <= tvalid_cnt1 + 1;
						end if;
					when 1 => 
						if(tvalid_cnt1 = 35) then
							tvalid_cnt1 <= 0;
							state := state + 1;
						else
							tvalid_cnt1 <= tvalid_cnt1 + 1;
						end if;
						tvalid_art(i) <= '0';
						tlast_art(i) <= '0';
					when 2 => 
						if(tvalid_cnt2 = N_PIX-1) then
							tvalid_cnt2 <= 0;
							tlast_art(i) <= '1';
							state := state - 1;
						else
							tvalid_cnt2 <= tvalid_cnt2 + 1;
							tlast_art(i) <= '0';
						end if;
						tvalid_art(i) <= '1';
				end case;
			end if;
		end process;
		
		tdata_gen: process(clk_art)
		begin
			if(rising_edge(clk_art)) then
				if(tvalid_art(i) = '1') then
					tdata(8*i+7 downto 8*i) <= tdata(8*i+7 downto 8*i) + 1;
				else
					tdata(8*i+7 downto 8*i) <= (others => '0');
				end if;
			end if;
		end process;
		
		tdata_art(8*12*(i+1)-1 downto 8*12*i) <= 
			tdata(8*i+7 downto 8*i) &
			tdata(8*i+7 downto 8*i) &
			tdata(8*i+7 downto 8*i) &
			tdata(8*i+7 downto 8*i) &
			tdata(8*i+7 downto 8*i) &
			tdata(8*i+7 downto 8*i) &
			tdata(8*i+7 downto 8*i) &
			tdata(8*i+7 downto 8*i) &
			tdata(8*i+7 downto 8*i) &
			tdata(8*i+7 downto 8*i) &
			tdata(8*i+7 downto 8*i) &
			tdata(8*i+7 downto 8*i);
		
	end generate;
	
--	map_loader: process(m_axis_aclk)
--		variable state: integer range 0 to 2 := 0;
--	begin
--		if(rising_edge(m_axis_aclk)) then
--			case state is
--				when 0 => if cnt_load_remap=10 then
--										state := state + 1;
--										cnt_load_remap <= (others => '0');
--									else
--										cnt_load_remap <= cnt_load_remap + 1;
--									end if;
--				when 1 => s_axis_map0_tvalid <= '1';
--									s_axis_map0_tdata <= "00" & cnt_load_remap(5 downto 3) & (7-cnt_load_remap(2 downto 0));
--									cnt_load_remap <= cnt_load_remap + 1;
--									if(cnt_load_remap=63) then
--										s_axis_map0_tlast <= '1';
--										state := state + 1;
--									end if;
--				when 2 => s_axis_map0_tvalid <= '0';									
--			end case;
--		end if;
--	end process;
	
		
	dut: data_converter 
    Port map( 
    	areset_art => areset_art,--: in std_logic;
    	clk_art0 => clk_art,--: : in STD_LOGIC;
    	clk_art1 => clk_art,--: : in STD_LOGIC;
    	clk_art2 => clk_art,--: : in STD_LOGIC;
    	tvalid_art0 => tvalid_art(0),--: : in STD_LOGIC;
    	tvalid_art1 => tvalid_art(1),--: : in STD_LOGIC;
    	tvalid_art2 => tvalid_art(2),--: : in STD_LOGIC;
    	tlast_art0 => tlast_art(0),--: : in STD_LOGIC;
    	tlast_art1 => tlast_art(1),--: : in STD_LOGIC;
    	tlast_art2 => tlast_art(2),--: : in STD_LOGIC;
    	tdata_art0 => tdata_art(8*12*1-1 downto 8*12*0),--: : in STD_LOGIC_VECTOR(8*12-1 downto 0);
    	tdata_art1 => tdata_art(8*12*2-1 downto 8*12*1),--: : in STD_LOGIC_VECTOR(8*12-1 downto 0);
    	tdata_art2 => tdata_art(8*12*3-1 downto 8*12*2),--: : in STD_LOGIC_VECTOR(8*12-1 downto 0);
 			s_axis_map0_tdata => s_axis_map0_tdata,--: in STD_LOGIC_VECTOR (7 downto 0);
    	s_axis_map0_tvalid => s_axis_map0_tvalid,--: in STD_LOGIC;
    	s_axis_map0_tlast => s_axis_map0_tlast,--: in STD_LOGIC;
    	s_axis_map0_tready => s_axis_map0_tready,--: out STD_LOGIC;

    	m_axis_aclk => m_axis_aclk,--:: in std_logic;
    	m_axis_aresetn => m_axis_aresetn,--: : in STD_LOGIC;
    	m_axis_tdata => m_axis_tdata_conv,--: : out STD_LOGIC_VECTOR(127 downto 0);
    	m_axis_tuser => m_axis_tuser_conv,--: : out STD_LOGIC_VECTOR(5 downto 0);
    	m_axis_tvalid => m_axis_tvalid_conv,--: : out STD_LOGIC;
    	m_axis_tlast => m_axis_tlast_conv,--: : out STD_LOGIC;
    	m_axis_tready => '1', --: : in STD_LOGIC   
    	prog_reset_p => '0',
    	--zeros => (1 to 9 => '1', others => '0')
    	zeros => (others => '0') 	
    	);


	dut2:  data_provider_4trig 
	    Port map( clk => m_axis_aclk,--: in STD_LOGIC;
	           aresetn  => m_axis_aresetn,--: in STD_LOGIC;
	           s_axis_tdata  => m_axis_tdata_conv,--: in STD_LOGIC_VECTOR (127 downto 0);
	           s_axis_tvalid  => m_axis_tvalid_conv,--: in STD_LOGIC;
	           s_axis_tlast  => m_axis_tlast_conv,--: in STD_LOGIC;
	           s_axis_tuser  => m_axis_tuser_conv,--: in std_logic_vector(7 downto 0);
	           DATA  => open,--: out STD_LOGIC_VECTOR (143 downto 0);
	           FRAME  => open);--: out STD_LOGIC);
	           
end Behavioral;
