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
use IEEE.STD_LOGIC_1164.ALL;

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
	signal map0: STD_LOGIC_VECTOR(8*64-1 downto 0);
	
	signal s_axis_tvalid_remap: std_logic;

begin

	i_axis_remap_dwc_1_64 : axis_remap_dwc_1_64
		PORT MAP (
			aclk => aclk,
			aresetn => aresetn,
			s_axis_tvalid => s_axis_map0_tvalid,
			s_axis_tready => s_axis_map0_tready,
			s_axis_tdata => s_axis_map0_tdata,
			s_axis_tlast => s_axis_map0_tlast,
			m_axis_tvalid => open,
			m_axis_tready => '1',
			m_axis_tdata => map0,
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

	s_axis_tvalid_remap <= m_axis_tvalid_dwc1 and m_axis_tready_dwc1;
i_pixel_remap_v2 : pixel_remap_v2 
    Port map( clk => aclk,--: in STD_LOGIC;
           s_axis_tdata => m_axis_tdata_dwc1(8*64-1 downto 0),--: in STD_LOGIC_VECTOR(8*64-1 downto 0);
           s_axis_tvalid => s_axis_tvalid_remap,--: in STD_LOGIC;
           s_axis_tlast => m_axis_tlast_dwc1,--: in STD_LOGIC;
           m_axis_tdata => m_axis_tdata_remap,--: out STD_LOGIC_VECTOR(8*64-1 downto 0);
           m_axis_tvalid => open,--: out STD_LOGIC;
           m_axis_tlast => open,--: out STD_LOGIC;
           map0 => map0);--: in STD_LOGIC_VECTOR (6*64-1 downto 0));


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
