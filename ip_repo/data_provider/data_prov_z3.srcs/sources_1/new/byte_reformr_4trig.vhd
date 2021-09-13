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
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity byte_reformr_4trig is
    Port ( 
			aclk : IN STD_LOGIC;
			aresetn : IN STD_LOGIC;
			s_axis_tvalid : IN STD_LOGIC;
			s_axis_tdata : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
			s_axis_tlast : IN STD_LOGIC;
			m_axis_tvalid : OUT STD_LOGIC;
			m_axis_tdata : OUT STD_LOGIC_VECTOR(1151 DOWNTO 0);
			m_axis_tlast : OUT STD_LOGIC
    );
end byte_reformr_4trig;

architecture Behavioral of byte_reformr_4trig is

	COMPONENT dwc_b_reform4trig
		PORT (
			aclk : IN STD_LOGIC;
			aresetn : IN STD_LOGIC;
			s_axis_tvalid : IN STD_LOGIC;
			s_axis_tready : OUT STD_LOGIC;
			s_axis_tdata : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
			s_axis_tlast : IN STD_LOGIC;
			m_axis_tvalid : OUT STD_LOGIC;
			m_axis_tready : IN STD_LOGIC;
			m_axis_tdata : OUT STD_LOGIC_VECTOR(2303 DOWNTO 0);
			m_axis_tkeep : OUT STD_LOGIC_VECTOR(287 DOWNTO 0);
			m_axis_tlast : OUT STD_LOGIC
		);
	END COMPONENT;
	
	COMPONENT dwc_b_reform4trig2
		PORT (
			aclk : IN STD_LOGIC;
			aresetn : IN STD_LOGIC;
			s_axis_tvalid : IN STD_LOGIC;
			s_axis_tready : OUT STD_LOGIC;
			s_axis_tdata : IN STD_LOGIC_VECTOR(767 DOWNTO 0);
			s_axis_tlast : IN STD_LOGIC;
			m_axis_tvalid : OUT STD_LOGIC;
			m_axis_tready : IN STD_LOGIC;
			m_axis_tdata : OUT STD_LOGIC_VECTOR(383 DOWNTO 0);
			m_axis_tlast : OUT STD_LOGIC
		);
	END COMPONENT;
	
	signal m_axis_tvalid1 :  STD_LOGIC;
	signal m_axis_tready1 :  STD_LOGIC;
	signal m_axis_tdata1 :  STD_LOGIC_VECTOR(2303 DOWNTO 0);
	signal m_axis_tlast1 :  STD_LOGIC;
	signal m_axis_tvalid2: STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal m_axis_tlast2: STD_LOGIC_VECTOR(2 DOWNTO 0);

begin

	i_dwc_b_reform4trig : dwc_b_reform4trig
  PORT MAP (
    aclk => aclk,
    aresetn => aresetn,
    s_axis_tvalid => s_axis_tvalid,
    s_axis_tready => open,
    s_axis_tdata => s_axis_tdata,
    s_axis_tlast => s_axis_tlast,
    m_axis_tvalid => m_axis_tvalid1,
    m_axis_tready => '1',
    m_axis_tdata => m_axis_tdata1,
    m_axis_tkeep => open,
    m_axis_tlast => m_axis_tlast1
  );

	
	gen: for i in 0 to 2 generate
		i_dwc_b_reform4trig2 : dwc_b_reform4trig2
			PORT MAP (
				aclk => aclk,
				aresetn => aresetn,
				s_axis_tvalid => m_axis_tvalid1,
				s_axis_tready => open,
				s_axis_tdata => m_axis_tdata1(768*i+767 downto 768*i),
				s_axis_tlast => m_axis_tlast1,
				m_axis_tvalid => m_axis_tvalid2(i),
				m_axis_tready => '1',
				m_axis_tdata => m_axis_tdata(384*i+383 downto 384*i),
				m_axis_tlast => m_axis_tlast2(i)
			);		
	end generate;
	
	m_axis_tvalid <= m_axis_tvalid2(0);
	m_axis_tlast <= m_axis_tlast2(0);

end Behavioral;
