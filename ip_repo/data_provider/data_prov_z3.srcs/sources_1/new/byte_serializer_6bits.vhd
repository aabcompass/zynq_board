----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.03.2021 12:14:20
-- Design Name: 
-- Module Name: byte_serializer - Behavioral
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
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity byte_serializer_6bits is
    generic(N_CH: integer := 144);
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           tvalid : in STD_LOGIC;
           tlast : in STD_LOGIC;
           tdata : in STD_LOGIC_VECTOR (8*N_CH-1 downto 0);
           tready : out STD_LOGIC := '1';
           data_out : out STD_LOGIC_VECTOR(N_CH-1 downto 0);
           frame : out STD_LOGIC;
           tlast_out: out std_logic := '0');
end byte_serializer_6bits;

architecture Behavioral of byte_serializer_6bits is

	signal load: std_logic := '0';
	signal tready_i: std_logic := '0';
	signal frame_d0: std_logic := '0';
	signal last_portion: std_logic := '0';
	signal tdata_latched : STD_LOGIC_VECTOR (8*N_CH-1 downto 0);

begin

	tready <= tready_i;

	sm: process(clk)
		--variable state : integer range 0 to 7 := 0;
		variable state : integer range 0 to 5 := 0;
	begin
		if(rising_edge(clk)) then
			if(reset = '1') then
				state := 0;
				load <= '0';
				frame_d0 <= '0';
				tlast_out <= '0';
				tready_i <= '1';
			else
				case state is
					when 0 => if(tvalid = '1') then
												tready_i <= '0';
												frame_d0 <= '1';
												tlast_out <= '0';
												last_portion <= tlast;
												load <= '1';
												state := state + 1;	
										else
												frame_d0 <= '0';		
												load <= '0';
										end if;
					when 1 => load <= '0'; state := state + 1;						
					when 2 => state := state + 1;						
					when 3 => state := state + 1;						
					when 4 => state := state + 1;						
					--when 5 => state := state + 1;						
					--when 6 => state := state + 1;						
					when 5 => tlast_out <= last_portion; 
										tready_i <= '1'; 
										state := 0;					
				end case;
			end if;
		end if;
	end process;
	
	latcher: process(clk)
	begin
		if(rising_edge(clk)) then
			if(tvalid = '1' and tready_i = '1') then
				tdata_latched <= tdata;
			end if;
		end if;
	end process;
	
	frame <= frame_d0 when rising_edge(clk);
	
	channel_gen: for i in 0 to N_CH-1 generate
	
			--signal tdata_sr: std_logic_vector(7 downto 0) := "00000000";
			signal tdata_sr: std_logic_vector(5 downto 0) := "000000";
	
		begin
		
		process(clk)
		begin
			if(rising_edge(clk)) then
				if(load = '1') then
					--tdata_sr <= tdata_latched(8*i+7 downto 8*i);
					tdata_sr <= tdata_latched(8*i+5 downto 8*i);
				else
					--tdata_sr <= '0' & tdata_sr(7 downto 1);
					tdata_sr <= '0' & tdata_sr(5 downto 1);
				end if;
			end if;
		end process;
		
		data_out(i) <= tdata_sr(0);
		
	end generate; 

end Behavioral;
