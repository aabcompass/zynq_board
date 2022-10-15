library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity adcv_pmt_sum is
    Generic(
    	N_VIRT_PMT: integer := 48;
    	N_LANES: integer := 16;
    	N_EC: integer := 9);
    Port ( 
    	clk : in STD_LOGIC;
    	s_axis_tdata: in std_logic_vector(127 downto 0);
    	s_axis_tuser: in std_logic_vector(7 downto 0);
    	s_axis_tvalid: in std_logic;
    	s_axis_tlast: in std_logic;
    	
			adcv_max_asic_cnts: in std_logic_vector(7 downto 0);
    	adcv_max_pixel_num: in std_logic_vector(15 downto 0); 
    	
    	ec_sig_out: out std_logic_vector(8 downto 0)    	
    	);
end adcv_pmt_sum;

architecture Behavioral of adcv_pmt_sum is
	
	signal s_axis_tuser_7_d1: std_logic := '0';
	signal sum_pmt_lanes : std_logic_vector(8*N_LANES-1 downto 0);
	signal sum_pmt_valid: std_logic := '0';
	signal sum_pmt: std_logic_vector(7 downto 0);
	
	signal sum_pmts: std_logic_vector(8*N_VIRT_PMT-1 downto 0);
	signal s_axis_tuser_latch: std_logic_vector(7 downto 0) := (others => '0');
	
	--signal sum_pmts_valid: std_logic_vector(N_VIRT_PMT-1 downto 0);
	
	signal sum_ecs: std_logic_vector(N_EC*16-1 downto 0) := (others => '0');
	
	signal s_axis_tlast_d1: std_logic := '0';

begin

	s_axis_tuser_7_d1 <= s_axis_tuser(7) and s_axis_tlast when rising_edge(clk);

	increment_process: process(clk)
	begin
		if(rising_edge(clk)) then				
			if(s_axis_tvalid = '1') then	
				for j in 0 to N_LANES-1 loop
					if(s_axis_tdata(j*8+7 downto j*8) >= adcv_max_asic_cnts) then
						sum_pmt_lanes(j*8+7 downto j*8) <= sum_pmt_lanes(j*8+7 downto j*8) + 1;
					end if; 
					sum_pmt_valid <= '0';
				end loop;
				s_axis_tuser_latch <= s_axis_tuser;
			elsif(s_axis_tuser_7_d1 = '1') then
				sum_pmt <= 
					sum_pmt_lanes(7 downto 0) +
					sum_pmt_lanes(8*1+7 downto 8*1+0) +
					sum_pmt_lanes(8*2+7 downto 8*2+0) +
					sum_pmt_lanes(8*3+7 downto 8*3+0) +
					sum_pmt_lanes(8*4+7 downto 8*4+0) +
					sum_pmt_lanes(8*5+7 downto 8*5+0) +
					sum_pmt_lanes(8*6+7 downto 8*6+0) +
					sum_pmt_lanes(8*7+7 downto 8*7+0);
				sum_pmt_lanes <= (others => '0');
				sum_pmt_valid <= '1';
			end if;
		end if;
	end process;


	n_pmt_gen: for i in 0 to N_VIRT_PMT-1 generate
	begin	
		
		distribute: process(clk)
		begin
			if(rising_edge(clk)) then
				if(i = s_axis_tuser_latch) then
					if(sum_pmt_valid = '1') then
						sum_pmts(i*8+7 downto i*8) <= sum_pmt;
						--sum_pmts_valid(i) <= '1';
					else
						--sum_pmts_valid(i) <= '0';
					end if;
				end if;
			end if;
		end process;
		
	end generate;

	ec_sum: process(clk)
	begin
		if(rising_edge(clk)) then
			if(s_axis_tlast = '1') then
				s_axis_tlast_d1 <= s_axis_tlast;
				
				sum_ecs(15 downto 0) <= 				conv_std_logic_vector(0, 16) + 
																				sum_pmts(0*8+7 downto 0*8) +
																				sum_pmts(1*8+7 downto 1*8) +
																				sum_pmts(6*8+7 downto 6*8) +
																				sum_pmts(7*8+7 downto 7*8);

				sum_ecs(1*16+15 downto 1*16) <= conv_std_logic_vector(0, 16) + 
																				sum_pmts(2*8+7 downto 2*8) +
																				sum_pmts(3*8+7 downto 3*8) +
																				sum_pmts(8*8+7 downto 8*8) +
																				sum_pmts(9*8+7 downto 9*8);

				sum_ecs(2*16+15 downto 2*16) <= conv_std_logic_vector(0, 16) + 
																				sum_pmts(4*8+7 downto 4*8) +
																				sum_pmts(5*8+7 downto 5*8) +
																				sum_pmts(10*8+7 downto 10*8) +
																				sum_pmts(11*8+7 downto 11*8);

				sum_ecs(3*16+15 downto 3*16) <= conv_std_logic_vector(0, 16) + 
																				sum_pmts(16*8+7 downto 16*8) +
																				sum_pmts(17*8+7 downto 17*8) +
																				sum_pmts(24*8+7 downto 24*8) +
																				sum_pmts(25*8+7 downto 25*8);

				sum_ecs(4*16+15 downto 4*16) <= conv_std_logic_vector(0, 16) + 
																				sum_pmts(18*8+7 downto 18*8) +
																				sum_pmts(19*8+7 downto 19*8) +
																				sum_pmts(26*8+7 downto 26*8) +
																				sum_pmts(27*8+7 downto 27*8);

				sum_ecs(5*16+15 downto 5*16) <= conv_std_logic_vector(0, 16) + 
																				sum_pmts(20*8+7 downto 20*8) +
																				sum_pmts(21*8+7 downto 21*8) +
																				sum_pmts(28*8+7 downto 28*8) +
																				sum_pmts(29*8+7 downto 29*8);

				sum_ecs(6*16+15 downto 6*16) <= conv_std_logic_vector(0, 16) + 
																				sum_pmts(32*8+7 downto 32*8) +
																				sum_pmts(33*8+7 downto 33*8) +
																				sum_pmts(40*8+7 downto 40*8) +
																				sum_pmts(41*8+7 downto 41*8);

				sum_ecs(7*16+15 downto 7*16) <= conv_std_logic_vector(0, 16) + 
																				sum_pmts(34*8+7 downto 34*8) +
																				sum_pmts(35*8+7 downto 35*8) +
																				sum_pmts(42*8+7 downto 42*8) +
																				sum_pmts(43*8+7 downto 43*8);

				sum_ecs(8*16+15 downto 8*16) <= conv_std_logic_vector(0, 16) + 
																				sum_pmts(36*8+7 downto 36*8) +
																				sum_pmts(37*8+7 downto 37*8) +
																				sum_pmts(44*8+7 downto 44*8) +
																				sum_pmts(45*8+7 downto 45*8);
			end if;
		end if;
	end process;

	cmp_process_gen: for i in 0 to N_EC-1 generate

		cmp_process: process(clk)
		begin
			if(rising_edge(clk)) then
				if(s_axis_tlast_d1 = '1') then
					if(sum_ecs(i*16+15 downto i*16) >= adcv_max_pixel_num) then
						ec_sig_out(i) <= '1';
					else
						ec_sig_out(i) <= '0';
					end if;
				end if;			
			end if;
		end process;
		
	end generate;

end Behavioral;
