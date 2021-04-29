----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.03.2021 12:46:33
-- Design Name: 
-- Module Name: data_provider_4trig - Behavioral
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

entity data_provider_4trig is
    Port ( clk : in STD_LOGIC;
           aresetn : in STD_LOGIC;
           s_axis_tdata : in STD_LOGIC_VECTOR (127 downto 0);
           s_axis_tvalid : in STD_LOGIC;
           s_axis_tlast : in STD_LOGIC;
           s_axis_tuser : in std_logic_vector(7 downto 0);
           DATA : out STD_LOGIC_VECTOR (143 downto 0);
           FRAME : out STD_LOGIC);
end data_provider_4trig;

architecture Behavioral of data_provider_4trig is



COMPONENT axis_dwidth_converter_0
  PORT (
    aclk : IN STD_LOGIC;
    aresetn : IN STD_LOGIC;
    s_axis_tvalid : IN STD_LOGIC;
    s_axis_tready : OUT STD_LOGIC;
    s_axis_tdata : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
    s_axis_tlast : IN STD_LOGIC;
    m_axis_tvalid : OUT STD_LOGIC;
    m_axis_tready : IN STD_LOGIC;
    m_axis_tdata : OUT STD_LOGIC_VECTOR(1151 DOWNTO 0);
    m_axis_tkeep : OUT STD_LOGIC_VECTOR(143 DOWNTO 0);
    m_axis_tlast : OUT STD_LOGIC
  );
END COMPONENT;

COMPONENT axis_data_fifo_0
  PORT (
    s_axis_aresetn : IN STD_LOGIC;
    s_axis_aclk : IN STD_LOGIC;
    s_axis_tvalid : IN STD_LOGIC;
    s_axis_tready : OUT STD_LOGIC;
    s_axis_tdata : IN STD_LOGIC_VECTOR(1151 DOWNTO 0);
    s_axis_tlast : IN STD_LOGIC;
    m_axis_tvalid : OUT STD_LOGIC;
    m_axis_tready : IN STD_LOGIC;
    m_axis_tdata : OUT STD_LOGIC_VECTOR(1151 DOWNTO 0);
    m_axis_tlast : OUT STD_LOGIC;
    axis_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    axis_wr_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    axis_rd_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;

	signal s_axis_tlast_pc: std_logic;
	signal s_axis_tvalid_pc: std_logic;
	signal m_axis_tvalid_dwc: std_logic;
	signal m_axis_tready_dwc: std_logic;
	signal m_axis_tdata_dwc: std_logic_vector(144*8-1 downto 0);
	signal m_axis_tdata_fifo: std_logic_vector(144*8-1 downto 0);


COMPONENT byte_serializer is
    generic(N_CH: integer := 144);
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           tvalid : in STD_LOGIC;
           tdata : in STD_LOGIC_VECTOR (8*N_CH-1 downto 0);
           tready : out STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR(N_CH-1 downto 0);
           frame : out STD_LOGIC);
end COMPONENT;

signal reset: std_logic := '0';
signal m_axis_tvalid_fifo: std_logic := '0';
signal m_axis_tready_fifo: std_logic := '0';

begin
	
	s_axis_tlast_pc <= '1' when s_axis_tuser = "10101011" else '0';
	s_axis_tvalid_pc <= s_axis_tvalid and (not s_axis_tuser(6));
	
i_dwc : axis_dwidth_converter_0
  PORT MAP (
    aclk => clk,
    aresetn => aresetn,
    s_axis_tvalid => s_axis_tvalid_pc,
    s_axis_tready => open,
    s_axis_tdata => s_axis_tdata,
    s_axis_tlast => s_axis_tlast_pc,
    m_axis_tvalid => m_axis_tvalid_dwc,
    m_axis_tready => m_axis_tready_dwc,
    m_axis_tdata => m_axis_tdata_dwc,
    m_axis_tkeep => open,
    m_axis_tlast => open
  );

i_fifo : axis_data_fifo_0
  PORT MAP (
    s_axis_aresetn => aresetn,
    s_axis_aclk => clk,
    s_axis_tvalid => m_axis_tvalid_dwc,
    s_axis_tready => m_axis_tready_dwc,
    s_axis_tdata => m_axis_tdata_dwc,
    s_axis_tlast => s_axis_tlast,
    m_axis_tvalid => m_axis_tvalid_fifo,
    m_axis_tready => m_axis_tready_fifo,
    m_axis_tdata => m_axis_tdata_fifo,
    m_axis_tlast => open,
    axis_data_count => open,
    axis_wr_data_count => open,
    axis_rd_data_count => open
  );

	reset <= not aresetn;

	i_byte_serializer : byte_serializer 
    Port map ( clk => clk,--: in STD_LOGIC;
           reset => reset,--: in STD_LOGIC;
           tvalid => m_axis_tvalid_fifo,--: in STD_LOGIC;
           tdata => m_axis_tdata_fifo,--: in STD_LOGIC_VECTOR (8*N_CH-1 downto 0);
           tready => m_axis_tready_fifo,--: out STD_LOGIC;
           data_out => DATA,--: out STD_LOGIC_VECTOR(N_CH-1 downto 0);
           frame => FRAME);--: out STD_LOGIC);

end Behavioral;
