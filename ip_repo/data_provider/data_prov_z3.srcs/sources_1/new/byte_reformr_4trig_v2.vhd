----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.09.2021 19:57:05
-- Design Name: 
-- Module Name: byte_reformr_4trig - Behavioral
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

entity byte_reformr_4trig_v2 is
    Port ( 
			aclk : IN STD_LOGIC;
			aresetn : IN STD_LOGIC;
			s_axis_tvalid : IN STD_LOGIC;
			s_axis_tdata : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
			s_axis_tuser : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			s_axis_tlast : IN STD_LOGIC;
			m_axis_tvalid : OUT STD_LOGIC;
			m_axis_tready : in STD_LOGIC;
			m_axis_tdata : OUT STD_LOGIC_VECTOR(1151 DOWNTO 0);
			m_axis_tlast : OUT STD_LOGIC
    );
end byte_reformr_4trig_v2;

architecture Behavioral of byte_reformr_4trig_v2 is

	attribute KEEP_HIERARCHY : string;
	attribute KEEP_HIERARCHY of Behavioral: architecture is "TRUE";

	COMPONENT fifo4reform4trig
		PORT (
			s_axis_aresetn : IN STD_LOGIC;
			s_axis_aclk : IN STD_LOGIC;
			s_axis_tvalid : IN STD_LOGIC;
			s_axis_tlast : IN STD_LOGIC;
			s_axis_tready : OUT STD_LOGIC;
			s_axis_tdata : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
			m_axis_tvalid : OUT STD_LOGIC;
			m_axis_tlast : OUT STD_LOGIC;
			m_axis_tready : IN STD_LOGIC;
			m_axis_tdata : OUT STD_LOGIC_VECTOR(127 DOWNTO 0);
			axis_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			axis_wr_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			axis_rd_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT dwc_b_reform4trig
		PORT (
			aclk : IN STD_LOGIC;
			aresetn : IN STD_LOGIC;
			s_axis_tvalid : IN STD_LOGIC;
			s_axis_tlast : IN STD_LOGIC;
			s_axis_tready : OUT STD_LOGIC;
			s_axis_tdata : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
			m_axis_tvalid : OUT STD_LOGIC;
			m_axis_tlast : OUT STD_LOGIC;
			m_axis_tready : IN STD_LOGIC;
			m_axis_tdata : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
		);
	END COMPONENT;

	signal s_axis_tvalid_d1 :  STD_LOGIC := '0';
	signal s_axis_tlast_d1 :  STD_LOGIC:= '0';
	signal m_axis_tvalid1 :  STD_LOGIC:= '0';
	signal m_axis_tready1 :  STD_LOGIC:= '0';
	signal m_axis_tready_dwc :  STD_LOGIC:= '0';
	signal m_axis_tlast_i :  STD_LOGIC:= '0';
	signal pmt_pare_num :  STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '0');
	signal m_axis_tlast1 :  STD_LOGIC:= '0';
	signal m_axis_tlast_dwc_or :  STD_LOGIC:= '0';
	signal pass :  STD_LOGIC:= '0';
	signal m_axis_tvalid_dwc_and :  STD_LOGIC:= '0';
	signal m_axis_tvalid_dwc_or :  STD_LOGIC:= '0';
	signal m_axis_tvalid2: STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal m_axis_tlast2: STD_LOGIC_VECTOR(2 DOWNTO 0);
	
	signal m_axis_tvalid_dwc: std_logic_vector(17 downto 0);
	signal m_axis_tlast_dwc: std_logic_vector(17 downto 0);
	
	signal is_nonzero_value: std_logic_vector(17 downto 0) := (others => '0');
	
	attribute keep : string; 
	attribute keep of m_axis_tvalid_dwc: signal is "true";  
	attribute keep of m_axis_tlast_dwc: signal is "true";  
	attribute keep of is_nonzero_value: signal is "true";  

begin

	tuser_conv: process(aclk)
	begin
		if(rising_edge(aclk)) then
			if(s_axis_tvalid = '1') then
				case conv_integer(s_axis_tuser(5 downto 0)) is 					
					when 0 => pmt_pare_num <= conv_std_logic_vector(0, 8);
					when 1 => pmt_pare_num <= conv_std_logic_vector(0, 8);
					when 6 => pmt_pare_num <= conv_std_logic_vector(1, 8);
					when 7 => pmt_pare_num <= conv_std_logic_vector(1, 8);
					when 2 => pmt_pare_num <= conv_std_logic_vector(2, 8);
					when 3 => pmt_pare_num <= conv_std_logic_vector(2, 8);
					when 8 => pmt_pare_num <= conv_std_logic_vector(3, 8);
					when 9 => pmt_pare_num <= conv_std_logic_vector(3, 8);
					when 4 => pmt_pare_num <= conv_std_logic_vector(4, 8);
					when 5 => pmt_pare_num <= conv_std_logic_vector(4, 8);
					when 10 => pmt_pare_num <= conv_std_logic_vector(5, 8);
					when 11 => pmt_pare_num <= conv_std_logic_vector(5, 8);
					
					when 16 => pmt_pare_num <= conv_std_logic_vector(6, 8);
					when 17 => pmt_pare_num <= conv_std_logic_vector(6, 8);
					when 22 => pmt_pare_num <= conv_std_logic_vector(7, 8);
					when 23 => pmt_pare_num <= conv_std_logic_vector(7, 8);
					when 18 => pmt_pare_num <= conv_std_logic_vector(8, 8);
					when 19 => pmt_pare_num <= conv_std_logic_vector(8, 8);
					when 24 => pmt_pare_num <= conv_std_logic_vector(9, 8);
					when 25 => pmt_pare_num <= conv_std_logic_vector(9, 8);
					when 20 => pmt_pare_num <= conv_std_logic_vector(10, 8);
					when 21 => pmt_pare_num <= conv_std_logic_vector(10, 8);
					when 26 => pmt_pare_num <= conv_std_logic_vector(11, 8);
					when 27 => pmt_pare_num <= conv_std_logic_vector(11, 8);
					
					when 32 => pmt_pare_num <= conv_std_logic_vector(12, 8);
					when 33 => pmt_pare_num <= conv_std_logic_vector(12, 8);
					when 38 => pmt_pare_num <= conv_std_logic_vector(13, 8);
					when 39 => pmt_pare_num <= conv_std_logic_vector(13, 8);
					when 34 => pmt_pare_num <= conv_std_logic_vector(14, 8);
					when 35 => pmt_pare_num <= conv_std_logic_vector(14, 8);
					when 40 => pmt_pare_num <= conv_std_logic_vector(15, 8);
					when 41 => pmt_pare_num <= conv_std_logic_vector(15, 8);
					when 36 => pmt_pare_num <= conv_std_logic_vector(16, 8);
					when 37 => pmt_pare_num <= conv_std_logic_vector(16, 8);
					when 42 => pmt_pare_num <= conv_std_logic_vector(17, 8);
					when 43 => pmt_pare_num <= conv_std_logic_vector(17, 8);
					
					when others => pmt_pare_num <= conv_std_logic_vector(18, 8); 					
				end case;
			end if;
		end if;
	end process;

g_fifo4reform4trig: for i in 0 to 17 generate	
	
	signal s_axis_tdata_d1: std_logic_vector(127 downto 0);
	signal s_axis_tdata_fifo: std_logic_vector(127 downto 0);
	signal m_axis_tdata_fifo: std_logic_vector(127 downto 0);

	signal s_axis_tvalid_fifo: std_logic := '0';
	signal s_axis_tlast_fifo: std_logic := '0';
	signal m_axis_tvalid_fifo: std_logic := '0';
	signal m_axis_tlast_fifo: std_logic := '0';
	signal m_axis_tready_fifo: std_logic := '0';

	
	--attribute keep : string; 
	--attribute keep of is_nonzero_value: signal is "true";  
	--attribute DONT_TOUCH : string; 
	--attribute DONT_TOUCH of is_nonzero_value: signal is "true";  

begin

	
	select_process: process(aclk)
	begin
		if(rising_edge(aclk)) then
			
			s_axis_tdata_d1 <= s_axis_tdata;
			s_axis_tdata_fifo <= s_axis_tdata_d1;
			
			s_axis_tvalid_d1 <= s_axis_tvalid;
			s_axis_tlast_d1 <= s_axis_tlast;
			
			if(pmt_pare_num = conv_std_logic_vector(i,8)) then
				s_axis_tvalid_fifo <= s_axis_tvalid_d1;
				s_axis_tlast_fifo <= s_axis_tlast_d1;
				if(s_axis_tvalid_d1 = '1') then
					if(s_axis_tdata_d1 = X"00000000000000000000000000000000") then
						is_nonzero_value(i) <= '0';
					else
						is_nonzero_value(i) <= '1';
					end if;
				end if;
			end if;
			
		end if;
	end process;
	
	i_fifo4reform4trig : fifo4reform4trig
		PORT MAP (
			s_axis_aresetn => aresetn,
			s_axis_aclk => aclk,
			s_axis_tvalid => s_axis_tvalid_fifo,
			s_axis_tlast => s_axis_tlast_fifo,
			s_axis_tready => open,
			s_axis_tdata => s_axis_tdata_fifo,
			m_axis_tvalid => m_axis_tvalid_fifo,
			m_axis_tlast => m_axis_tlast_fifo,
			m_axis_tready => m_axis_tready_fifo,
			m_axis_tdata => m_axis_tdata_fifo,
			axis_data_count => open,
			axis_wr_data_count => open,
			axis_rd_data_count => open
		);
	
	i_dwc_b_reform4trig : dwc_b_reform4trig
		PORT MAP (
			aclk => aclk,
			aresetn => aresetn,
			s_axis_tvalid => m_axis_tvalid_fifo,
			s_axis_tlast => m_axis_tlast_fifo,
			s_axis_tready => m_axis_tready_fifo,
			s_axis_tdata => m_axis_tdata_fifo,
			m_axis_tvalid => m_axis_tvalid_dwc(i),
			m_axis_tlast => m_axis_tlast_dwc(i),
			m_axis_tready => m_axis_tready_dwc,
			m_axis_tdata => m_axis_tdata(64*i+63 downto 64*i)
		);
	
	end generate;
	
	--m_axis_tready_dwc <= 
		m_axis_tvalid_dwc_and <=
		m_axis_tvalid_dwc(0) and 
		m_axis_tvalid_dwc(1) and 
		m_axis_tvalid_dwc(2) and 
		m_axis_tvalid_dwc(3) and 
		m_axis_tvalid_dwc(4) and 
		m_axis_tvalid_dwc(5) and 
		m_axis_tvalid_dwc(6) and 
		m_axis_tvalid_dwc(7) and 
		m_axis_tvalid_dwc(8) and 
		m_axis_tvalid_dwc(9) and 
		m_axis_tvalid_dwc(10) and 
		m_axis_tvalid_dwc(11) and 
		m_axis_tvalid_dwc(12) and 
		m_axis_tvalid_dwc(13) and 
		m_axis_tvalid_dwc(14) and 
		m_axis_tvalid_dwc(15) and 
		m_axis_tvalid_dwc(16) and 
		m_axis_tvalid_dwc(17); 

		m_axis_tvalid_dwc_or <=
		m_axis_tvalid_dwc(0) or 
		m_axis_tvalid_dwc(1) or 
		m_axis_tvalid_dwc(2) or 
		m_axis_tvalid_dwc(3) or 
		m_axis_tvalid_dwc(4) or 
		m_axis_tvalid_dwc(5) or 
		m_axis_tvalid_dwc(6) or 
		m_axis_tvalid_dwc(7) or 
		m_axis_tvalid_dwc(8) or 
		m_axis_tvalid_dwc(9) or 
		m_axis_tvalid_dwc(10) or 
		m_axis_tvalid_dwc(11) or 
		m_axis_tvalid_dwc(12) or 
		m_axis_tvalid_dwc(13) or 
		m_axis_tvalid_dwc(14) or 
		m_axis_tvalid_dwc(15) or 
		m_axis_tvalid_dwc(16) or 
		m_axis_tvalid_dwc(17); 
		
		m_axis_tlast_dwc_or <= 
		m_axis_tlast_dwc(0) or 
		m_axis_tlast_dwc(1) or 
		m_axis_tlast_dwc(2) or 
		m_axis_tlast_dwc(3) or 
		m_axis_tlast_dwc(4) or 
		m_axis_tlast_dwc(5) or 
		m_axis_tlast_dwc(6) or 
		m_axis_tlast_dwc(7) or 
		m_axis_tlast_dwc(8) or 
		m_axis_tlast_dwc(9) or 
		m_axis_tlast_dwc(10) or 
		m_axis_tlast_dwc(11) or 
		m_axis_tlast_dwc(12) or 
		m_axis_tlast_dwc(13) or 
		m_axis_tlast_dwc(14) or 
		m_axis_tlast_dwc(15) or 
		m_axis_tlast_dwc(16) or 
		m_axis_tlast_dwc(17);
		
		m_axis_tlast_i <= m_axis_tlast_dwc(17);
		
		pass_process: process(aclk)
			variable state : integer range 0 to 1 := 0;
		begin
			if(rising_edge(aclk)) then
				if(aresetn = '0') then
					state := 0;
					pass <= '0';
				else
					case state is
						when 0 =>
							if(m_axis_tvalid_dwc_and = '1') then
								pass <= '1';
								state := state + 1;
							end if;
						when 1 =>
							if(m_axis_tlast_dwc_or = '1' and m_axis_tready = '1' and m_axis_tvalid_dwc_or = '1') then
								pass <= '0';
								state := 0;
							end if;
					end case;
				end if;
			end if;
		end process;
	
	m_axis_tvalid <= m_axis_tvalid_dwc_and and pass;
	m_axis_tready_dwc <= m_axis_tready and pass;
	m_axis_tlast <= m_axis_tlast_i;
	
end Behavioral;
