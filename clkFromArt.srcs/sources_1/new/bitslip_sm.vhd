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


Library xpm;
use xpm.vcomponents.all;
			

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
    				run : in STD_LOGIC;
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
           dataout: out STD_LOGIC_VECTOR(8*12-1 downto 0);
           dataout12: out STD_LOGIC_VECTOR(7 downto 0);
           bitlslip_vector: out STD_LOGIC_VECTOR(12 downto 0);
           dataout_valid: out std_logic;
           dataout_last: out std_logic;
           rst_selectio: out std_logic := '1'
           );
end bitslip_sm;

architecture Behavioral of bitslip_sm is

	signal dataout_d0: STD_LOGIC_VECTOR(8*12-1 downto 0) := (others => '0');

	signal frame_data: std_logic_vector(7 downto 0) := (others => '0');
	signal bitslip_cmd: std_logic := '0';
	
	signal dataout0_i: std_logic_vector(7 downto 0);
	signal dataout1_i: std_logic_vector(7 downto 0);
	signal dataout2_i: std_logic_vector(7 downto 0);
	signal dataout3_i: std_logic_vector(7 downto 0);
	signal dataout4_i: std_logic_vector(7 downto 0);
	signal dataout5_i: std_logic_vector(7 downto 0);
	signal dataout6_i: std_logic_vector(7 downto 0);
	signal dataout7_i: std_logic_vector(7 downto 0);
	signal dataout8_i: std_logic_vector(7 downto 0);
	signal dataout9_i: std_logic_vector(7 downto 0);
	signal dataout10_i: std_logic_vector(7 downto 0);
	signal dataout11_i: std_logic_vector(7 downto 0);
	signal dataout12_i: std_logic_vector(7 downto 0);
	
	signal valid_i: std_logic := '0';
	
	signal tlast_cnt: std_logic_vector(6 downto 0)  := (others => '0');
	signal tlast_allowed: std_logic := '0';
	
	signal dataout_last_d0: std_logic := '0';
	signal run_d1: std_logic := '0';
	
	attribute keep : string;
	attribute keep of frame_data : signal is "true";

begin

		
	


   xpm_cdc_single_inst : xpm_cdc_single
   generic map (
      DEST_SYNC_FF => 4,   -- DECIMAL; range: 2-10
      INIT_SYNC_FF => 0,   -- DECIMAL; integer; 0=disable simulation init values, 1=enable simulation init
                           -- values
      SIM_ASSERT_CHK => 0, -- DECIMAL; integer; 0=disable simulation messages, 1=enable simulation messages
      SRC_INPUT_REG => 0   -- DECIMAL; integer; 0=do not register input, 1=register input
   )
   port map (
      dest_out => run_d1, -- 1-bit output: src_in synchronized to the destination clock domain. This output
                            -- is registered.

      dest_clk => clk, -- 1-bit input: Clock signal for the destination clock domain.
      src_clk => '0',   -- 1-bit input: optional; required when SRC_INPUT_REG = 1
      src_in => run      -- 1-bit input: Input signal to be synchronized to dest_clk domain.
   );

	selectio_rst_process: process(clk)
	begin
		if(rising_edge(clk)) then
			if(run_d1 = '1') then
				rst_selectio <= '0';
			end if;
		end if;
	end process;

	remix_gen: for i in 0 to C_DATA_WIDTH-1 generate
		remix: process(clk)
		begin
			if(rising_edge(clk)) then
				dataout0_i(i) <= data_in(0+13*i); 
				dataout1_i(i) <= data_in(1+13*i); 
				dataout2_i(i) <= data_in(2+13*i); 
				dataout3_i(i) <= data_in(3+13*i); 
				dataout4_i(i) <= data_in(4+13*i); 
				dataout5_i(i) <= data_in(5+13*i); 
				dataout6_i(i) <= data_in(6+13*i); 
				dataout7_i(i) <= data_in(7+13*i); 
				dataout8_i(i) <= data_in(8+13*i); 
				dataout9_i(i) <= data_in(9+13*i); 
				dataout10_i(i) <= data_in(10+13*i); 
				dataout11_i(i) <= data_in(11+13*i); 
				dataout12_i(i) <= data_in(12+13*i); 
				frame_data(i) <= data_in(12+13*i);
			end if;
		end process;
	end generate;

	sm: process(clk)
	--	variable state : integer range 0 to 1 := 0;
	begin
		if(rising_edge(clk)) then
			--case state is
			--	when 0 => 
			--						if(frame_data = 0) then
			--							state := state + 1;
			--							end if;
			--						bitslip_cmd <= '0';
			--	when 1 => 
			if((frame_data = 0) or (frame_data = X"FF")) then
				bitslip_cmd <= '0';
			else
				bitslip_cmd <= '1';
			end if;
			--state := 0;	
			--end case;
		end if;
	end process;
	
	tlast_counter: process(clk)
	begin
		if(rising_edge(clk)) then
			if(valid_i = '1' and dataout12_i(0) = '0') then
				tlast_cnt <= tlast_cnt + 1;
				if(tlast_cnt = "1111111") then
					tlast_allowed <= '1';
				else
					tlast_allowed <= '0';
				end if;
			end if;
		end if;
	end process;
		
	bitlslip_vector <= (others => bitslip_cmd);
	
	dataout0 <= dataout0_i when rising_edge(clk);
	dataout1 <= dataout1_i when rising_edge(clk);
	dataout2 <= dataout2_i when rising_edge(clk);
	dataout3 <= dataout3_i when rising_edge(clk);
	dataout4 <= dataout4_i when rising_edge(clk);
	dataout5 <= dataout5_i when rising_edge(clk);
	dataout6 <= dataout6_i when rising_edge(clk);
	dataout7 <= dataout7_i when rising_edge(clk);
	dataout8 <= dataout8_i when rising_edge(clk);
	dataout9 <= dataout9_i when rising_edge(clk);
	dataout10 <= dataout10_i when rising_edge(clk);
	dataout11 <= dataout11_i when rising_edge(clk);
	dataout12 <= dataout12_i when rising_edge(clk);
	dataout_d0 <= dataout11_i & 
						dataout10_i & 
						dataout9_i & 
						dataout8_i & 
						dataout7_i & 
						dataout6_i & 
						dataout5_i & 
						dataout4_i & 
						dataout3_i & 
						dataout2_i & 
						dataout1_i & 
						dataout0_i when rising_edge(clk); 
						
	dataout <= dataout_d0 when rising_edge(clk); 
						
	valid_i <= dataout12_i(0) when rising_edge(clk);
	
	dataout_last_d0 <= valid_i and not dataout12_i(0);-- and tlast_allowed;
	
	data_en_process: process(clk)
		variable state : integer range 0 to 1  := 0;
	begin
		if(rising_edge(clk)) then
			case state is
				when 0 => if(run_d1 = '1') then
										if(dataout_last_d0 = '1' and valid_i = '1') then
											state := state + 1;
										end if;
									end if;
				when 1 => dataout_valid <= valid_i;
									dataout_last <= dataout_last_d0;
									if(run_d1 = '0') then
										if(valid_i = '0') then
											state := 0;
										end if;
									end if;
			end case;
		end if;
	end process;
	

end Behavioral;
