----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.03.2021 20:13:48
-- Design Name: 
-- Module Name: axis_pixel_remap - Behavioral
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

entity axis_pixel_remap is
    Port ( 
			aclk : IN STD_LOGIC;
			aresetn : IN STD_LOGIC;
			s_axis_tvalid : IN STD_LOGIC;
			s_axis_tready : OUT STD_LOGIC;
			s_axis_tdata : IN STD_LOGIC_VECTOR(4*4*8-1 DOWNTO 0);
			s_axis_tlast : IN STD_LOGIC;
			s_axis_tuser : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			m_axis_tvalid : OUT STD_LOGIC;
			m_axis_tready : in STD_LOGIC;
			m_axis_tdata : OUT STD_LOGIC_VECTOR(4*4*8-1 DOWNTO 0);
			m_axis_tlast : OUT STD_LOGIC;
			m_axis_tuser : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			s_axis_map0_tdata : in STD_LOGIC_VECTOR (31 downto 0);
			s_axis_map0_tvalid : in STD_LOGIC;
			s_axis_map0_tlast : in STD_LOGIC;
			s_axis_map0_tready : out STD_LOGIC
    );
end axis_pixel_remap;

architecture Behavioral of axis_pixel_remap is

	attribute keep_hierarchy : string;
	attribute keep_hierarchy of Behavioral : architecture is "yes";

COMPONENT axis_remap_dwc_1_64
  PORT (
    aclk : IN STD_LOGIC;
    aresetn : IN STD_LOGIC;
    s_axis_tvalid : IN STD_LOGIC;
    s_axis_tready : OUT STD_LOGIC;
    s_axis_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axis_tlast : IN STD_LOGIC;
    m_axis_tvalid : OUT STD_LOGIC;
    m_axis_tready : IN STD_LOGIC;
    m_axis_tdata : OUT STD_LOGIC_VECTOR(511 DOWNTO 0);
    m_axis_tkeep : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    m_axis_tlast : OUT STD_LOGIC
  );
END COMPONENT;

COMPONENT axis_DWC_4_256
  PORT (
    aclk : IN STD_LOGIC;
    aresetn : IN STD_LOGIC;
    s_axis_tvalid : IN STD_LOGIC;
    s_axis_tready : OUT STD_LOGIC;
    s_axis_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axis_tlast : IN STD_LOGIC;
    m_axis_tvalid : OUT STD_LOGIC;
    m_axis_tready : IN STD_LOGIC;
    m_axis_tdata : OUT STD_LOGIC_VECTOR(2047 DOWNTO 0);
    m_axis_tkeep : OUT STD_LOGIC_VECTOR(255 DOWNTO 0);
    m_axis_tlast : OUT STD_LOGIC
  );
END COMPONENT;


COMPONENT axis_remap_dwc16_64
  PORT (
    aclk : IN STD_LOGIC;
    aresetn : IN STD_LOGIC;
    s_axis_tvalid : IN STD_LOGIC;
    s_axis_tready : OUT STD_LOGIC;
    s_axis_tdata : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
    s_axis_tlast : IN STD_LOGIC;
    s_axis_tuser : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    m_axis_tvalid : OUT STD_LOGIC;
    m_axis_tready : IN STD_LOGIC;
    m_axis_tdata : OUT STD_LOGIC_VECTOR(639 DOWNTO 0);
    m_axis_tkeep : OUT STD_LOGIC_VECTOR(79 DOWNTO 0);
    m_axis_tlast : OUT STD_LOGIC;
    m_axis_tuser : OUT STD_LOGIC_VECTOR(79 DOWNTO 0)
  );
END COMPONENT;

COMPONENT axis_remap_slice
  PORT (
    aclk : IN STD_LOGIC;
    aresetn : IN STD_LOGIC;
    s_axis_tvalid : IN STD_LOGIC;
    s_axis_tready : OUT STD_LOGIC;
    s_axis_tdata : IN STD_LOGIC_VECTOR(639 DOWNTO 0);
    s_axis_tlast : IN STD_LOGIC;
    s_axis_tuser : IN STD_LOGIC_VECTOR(79 DOWNTO 0);
    m_axis_tvalid : OUT STD_LOGIC;
    m_axis_tready : IN STD_LOGIC;
    m_axis_tdata : OUT STD_LOGIC_VECTOR(639 DOWNTO 0);
    m_axis_tlast : OUT STD_LOGIC;
    m_axis_tuser : OUT STD_LOGIC_VECTOR(79 DOWNTO 0)
  );
END COMPONENT;

COMPONENT axis_remap_dwc64_16
  PORT (
    aclk : IN STD_LOGIC;
    aresetn : IN STD_LOGIC;
    s_axis_tvalid : IN STD_LOGIC;
    s_axis_tready : OUT STD_LOGIC;
    s_axis_tdata : IN STD_LOGIC_VECTOR(639 DOWNTO 0);
    s_axis_tlast : IN STD_LOGIC;
    s_axis_tuser : IN STD_LOGIC_VECTOR(79 DOWNTO 0);
    m_axis_tvalid : OUT STD_LOGIC;
    m_axis_tready : IN STD_LOGIC;
    m_axis_tdata : OUT STD_LOGIC_VECTOR(127 DOWNTO 0);
    m_axis_tlast : OUT STD_LOGIC;
    m_axis_tuser : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END COMPONENT;

	signal s_axis_tuser_i: std_logic_vector(15 downto 0) := (others => '0');
	signal m_axis_tvalid_dwc1: std_logic;
	signal m_axis_tready_dwc1: std_logic;
	signal m_axis_tlast_dwc1: std_logic;
	signal m_axis_tvalid_slc: std_logic;
	signal m_axis_tready_slc: std_logic;
	signal m_axis_tlast_slc: std_logic;
	signal m_axis_tdata_slc: std_logic_vector(639 DOWNTO 0);
	signal m_axis_tdata_dwc1: std_logic_vector(639 DOWNTO 0);
	signal m_axis_tuser_slc: std_logic_vector(79 DOWNTO 0);
	signal m_axis_tuser_dwc1: std_logic_vector(79 DOWNTO 0);
	signal m_axis_tuser_i: std_logic_vector(15 DOWNTO 0);
	
	COMPONENT pixel_remap_v2 is
	    Port ( clk : in STD_LOGIC;
	           s_axis_tdata : in STD_LOGIC_VECTOR(8*64-1 downto 0);
	           s_axis_tvalid : in STD_LOGIC;
	           s_axis_tlast : in STD_LOGIC;
	           m_axis_tdata : out STD_LOGIC_VECTOR(8*64-1 downto 0);
	           m_axis_tvalid : out STD_LOGIC;
	           m_axis_tlast : out STD_LOGIC;
	           map0 : in STD_LOGIC_VECTOR (8*64-1 downto 0));
	end COMPONENT;
	
	signal m_axis_tdata_remap: STD_LOGIC_VECTOR(8*64-1 downto 0);
	--signal s_axis_tdata_dwc1: STD_LOGIC_VECTOR(8*80-1 downto 0);
	signal m_axis_tdata_slc_remap: STD_LOGIC_VECTOR(8*80-1 downto 0);
	signal map_all: STD_LOGIC_VECTOR(8*256-1 downto 0);
	signal map0, map1, map2, map3: STD_LOGIC_VECTOR(8*64-1 downto 0);
	signal map_curr: STD_LOGIC_VECTOR(8*64-1 downto 0);
	signal map_curr_n: STD_LOGIC_VECTOR(3 downto 0);
	
	signal s_axis_tvalid_remap: std_logic;

	attribute KEEP : string;
	attribute KEEP of map_curr_n: signal is "TRUE";


begin

	map0 <= map_all(8*64*4-1 downto 8*64*3);
	map1 <= map_all(8*64*3-1 downto 8*64*2);
	map2 <= map_all(8*64*2-1 downto 8*64*1);
	map3 <= map_all(8*64*1-1 downto 0);

	i_axis_DWC_4_256 : axis_DWC_4_256
		PORT MAP (
			aclk => aclk,
			aresetn => aresetn,
			s_axis_tvalid => s_axis_map0_tvalid,
			s_axis_tready => s_axis_map0_tready,
			s_axis_tdata => s_axis_map0_tdata,
			s_axis_tlast => s_axis_map0_tlast,
			m_axis_tvalid => open,
			m_axis_tready => '1',
			m_axis_tdata => map_all,
			m_axis_tkeep => open,
			m_axis_tlast => open
		);


	s_axis_tuser_i <= "00000000" & s_axis_tuser;

	i_axis_rem : axis_remap_dwc16_64
  PORT MAP (
    aclk => aclk,
    aresetn => aresetn,
    s_axis_tvalid => s_axis_tvalid,
    s_axis_tready => s_axis_tready,
    s_axis_tdata => s_axis_tdata,
    s_axis_tlast => s_axis_tlast,
    s_axis_tuser => s_axis_tuser_i,
    m_axis_tvalid => m_axis_tvalid_dwc1,
    m_axis_tready => m_axis_tready_dwc1,
    m_axis_tdata => m_axis_tdata_dwc1,
    m_axis_tkeep => open,
    m_axis_tlast => m_axis_tlast_dwc1,
    m_axis_tuser => m_axis_tuser_dwc1
  );

	map_select: process(aclk)
	begin
		if(rising_edge(aclk)) then
			case conv_integer(s_axis_tuser(3 downto 0)) is
				when 0 => map_curr <= map0; map_curr_n <= X"0";
				when 1 => map_curr <= map1; map_curr_n <= X"1";
				when 2 => map_curr <= map0; map_curr_n <= X"0";
				when 3 => map_curr <= map1; map_curr_n <= X"1";
				when 4 => map_curr <= map0; map_curr_n <= X"0";
				when 5 => map_curr <= map1; map_curr_n <= X"1";
				when 6 => map_curr <=  map2; map_curr_n <= X"2";
				when 7 => map_curr <=  map3; map_curr_n <= X"3";
				when 8 => map_curr <=  map2; map_curr_n <= X"2";
				when 9 => map_curr <=  map3; map_curr_n <= X"3";
				when 10 => map_curr <= map2; map_curr_n <= X"2";
				when 11 => map_curr <= map3; map_curr_n <= X"3";
				when others => map_curr <= map_curr; map_curr_n <= X"4";
			end case;
		end if;
	end process;


	s_axis_tvalid_remap <= m_axis_tvalid_dwc1 and m_axis_tready_dwc1;
i_pixel_remap_v2 : pixel_remap_v2 
    Port map( clk => aclk,--: in STD_LOGIC;
           s_axis_tdata => m_axis_tdata_dwc1(8*64-1 downto 0),--: in STD_LOGIC_VECTOR(8*64-1 downto 0);
           s_axis_tvalid => s_axis_tvalid_remap,--: in STD_LOGIC;
           s_axis_tlast => m_axis_tlast_dwc1,--: in STD_LOGIC;
           m_axis_tdata => m_axis_tdata_remap,--: out STD_LOGIC_VECTOR(8*64-1 downto 0);
           m_axis_tvalid => open,--: out STD_LOGIC;
           m_axis_tlast => open,--: out STD_LOGIC;
           map0 => map_curr);--: in STD_LOGIC_VECTOR (6*64-1 downto 0));


i_axis_remap_slice : axis_remap_slice
  PORT MAP (
    aclk => aclk,
    aresetn => aresetn,
    s_axis_tvalid => m_axis_tvalid_dwc1,
    s_axis_tready => m_axis_tready_dwc1,
    s_axis_tdata => m_axis_tdata_dwc1,
    s_axis_tlast => m_axis_tlast_dwc1,
    s_axis_tuser => m_axis_tuser_dwc1,
    m_axis_tvalid => m_axis_tvalid_slc,
    m_axis_tready => m_axis_tready_slc,
    m_axis_tdata => m_axis_tdata_slc,
    m_axis_tlast => m_axis_tlast_slc,
    m_axis_tuser => m_axis_tuser_slc
  );
 
	m_axis_tdata_slc_remap <= m_axis_tdata_slc(8*80-1 downto 8*64) & m_axis_tdata_remap; 
 
  
i_axis_remap_dwc64_16 : axis_remap_dwc64_16
    PORT MAP (
      aclk => aclk,
      aresetn => aresetn,
      s_axis_tvalid => m_axis_tvalid_slc,
      s_axis_tready => m_axis_tready_slc,
      s_axis_tdata => m_axis_tdata_slc_remap,
      s_axis_tlast => m_axis_tlast_slc,
      s_axis_tuser => m_axis_tuser_slc,
      m_axis_tvalid => m_axis_tvalid,
      m_axis_tready => m_axis_tready,
      m_axis_tdata => m_axis_tdata,
      m_axis_tlast => m_axis_tlast,
      m_axis_tuser => m_axis_tuser_i
    );  
    
    m_axis_tuser <= m_axis_tuser_i(7 downto 0);
end Behavioral;
