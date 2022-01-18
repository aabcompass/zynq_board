----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.01.2022 12:56:38
-- Design Name: 
-- Module Name: data_provider_4trig_tb - Behavioral
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

entity data_provider_4trig_tb is
--  Port ( );
end data_provider_4trig_tb;

architecture Behavioral of data_provider_4trig_tb is

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
	
	constant PERIOD : time := 10 ns;
	signal clk_counter: integer  := 0;
	signal tvalid_counter: integer  := 0;
	signal clk: std_logic  := '0';
	signal aresetn: std_logic  := '0';
	signal valid, valid_d1: std_logic  := '0';
	signal last: std_logic  := '0';
	signal tdata: STD_LOGIC_VECTOR (127 downto 0) := (others => '0');
	signal tuser: STD_LOGIC_VECTOR (7 downto 0) := (others => '0');

begin

	clk_process: process
	begin
		clk <= '0';
		wait for PERIOD/2;
		clk <= '1';
		wait for PERIOD/2; 
	end process;

	clk_counter <= clk_counter + 1 when rising_edge(clk);
	
	tvalid_counter_process: process(clk)
	begin
		if(rising_edge(clk)) then
			if(tvalid_counter=480) then	 			
				tvalid_counter <= 271; 
			else
				tvalid_counter <= tvalid_counter + 1;
			end if;
		end if;
	end process;

	dut_proc: process(clk)
	begin
		if(rising_edge(clk)) then
			if(tvalid_counter = 71) then aresetn <= '1'; end if;
			if(tvalid_counter = 271) then valid <= '1'; end if;
			if(tvalid_counter = 331) then valid <= '0'; end if;
			if(tvalid_counter = 332) then valid <= '1'; end if;
			if(tvalid_counter = 392) then valid <= '0'; end if;
			if(tvalid_counter = 393) then valid <= '1'; end if;
			if(tvalid_counter = 452) then valid <= '1'; last <= '1';  end if;
			if(tvalid_counter = 453) then valid <= '0'; last <= '0';  end if;
		end if;
	end process;
	
	valid_d1 <= valid when rising_edge(clk);
	
	tdatauser_process: process(clk)
		variable n_byte: integer := 5;
		variable n_pmt: integer := 0;
		variable n_pmt_mod12: integer := 0;
		variable n_pmt_nat: integer := 0;
	begin
		if(rising_edge(clk)) then
			if(valid = '1') then
				if(n_byte=5) then
					n_byte := 0;
					tuser(5 downto 0) <= conv_std_logic_vector(n_pmt, 6);
					for i in 0 to 15 loop
						tdata(i*8+7 downto i*8) <= conv_std_logic_vector(n_pmt_nat, 8);
					end loop;
					n_pmt := n_pmt + 1;
					n_pmt_nat := n_pmt_nat + 1;
					n_pmt_mod12 := n_pmt_mod12 + 1;
					if(n_pmt_mod12 = 12) then
						n_pmt_mod12 := 0;
						n_pmt := n_pmt + 4;
					end if;
					tuser(7 downto 6) <= "00";
				elsif(n_byte = 3) then	
					tuser(7 downto 6) <= "10";
				elsif(n_byte = 4) then
					tuser(7 downto 6) <= "01";
				end if;
				n_byte := n_byte + 1;	
			else
				tuser(7 downto 6) <= "00";
				if(clk_counter = 455) then
					n_byte := 5;
					n_pmt := 0;
					n_pmt_mod12 := 0;
					n_pmt_nat := 0;
				end if;
			end if;	
		end if;
	end process;
	
	dut: data_provider_4trig 
	Port map( clk => clk,--: in STD_LOGIC;
				 aresetn => aresetn,--: in STD_LOGIC;
				 s_axis_tdata => tdata,--: in STD_LOGIC_VECTOR (127 downto 0);
				 s_axis_tvalid => valid_d1,--: in STD_LOGIC;
				 s_axis_tlast => last,--: in STD_LOGIC;
				 s_axis_tuser => tuser,--: in std_logic_vector(7 downto 0);
				 DATA => open,--: out STD_LOGIC_VECTOR (143 downto 0);
				 FRAME => open);--: out STD_LOGIC);
    
    

end Behavioral;
