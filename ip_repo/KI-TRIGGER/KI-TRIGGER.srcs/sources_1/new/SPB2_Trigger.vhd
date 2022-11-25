------------------------------------------------------------------------------------
---- Company:INFN Torino 
---- Engineer: M.Mignone
---- 
---- Create Date: 16/11/2022 03:23:11 PM
---- Design Name: 
---- Module Name: SPB2_Trigger - Behavioral
---- Project Name: 
---- Target Devices: 
---- Tool Versions: 
---- Description: 
---- 
---- Dependencies: 
---- 
---- Revision:
---- Revision 0.01 - File Created
---- Additional Comments:
---- 
------------------------------------------------------------------------------------


--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--USE ieee.std_logic_arith.ALL;
--USE ieee.std_logic_unsigned.ALL;

---- Uncomment the following library declaration if using
---- arithmetic functions with Signed or Unsigned values
----use IEEE.NUMERIC_STD.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx leaf cells in this code.
----library UNISIM;
----use UNISIM.VComponents.all;

--entity SPB2 is
--    Port ( CLOCK_133    : in STD_LOGIC;
--           --DATA KI Input
--           DATA_SPB2_KI : in STD_LOGIC_VECTOR (17 downto 0);
--           FRAME_KI     : in STD_LOGIC;
--           --AXI FIFO KI COMMAND
--           s_aclk_cmd_ki        :   in  std_logic;
--           s_aresetn_cmd_ki     :   in  std_logic;
--           s_axis_tvalid_cmd_ki :   in  std_logic;
--           s_axis_tready_cmd_ki :   out std_logic;
--           s_axis_tdata_cmd_ki  :   in  std_logic_vector(31 downto 0);
--           s_axis_tlast_cmd_ki  :   in  std_logic;
--           --AXI FIFO KI TRIGGER OUT
--           m_aclk_trg_ki           :   in  std_logic;
--           m_axis_tvalid_trg_ki    :   out std_logic;
--           m_axis_tready_trg_ki    :   in  std_logic;
--           m_axis_tdata_trg_ki     :   out std_logic_vector(31 downto 0);
--           m_axis_tlast_trg_ki     :   out std_logic
           
--        );
--end SPB2;

--architecture Behavioral of SPB2 is

--CONSTANT    last_frame      : std_logic_vector (18 downto 0) := "1111010000100011111";--499999 Last GTU (500ms) 5000000 GTU Block
----------------------------#TEST#--------------------------------------------------------------------------------------------------
----CONSTANT    last_frame      : std_logic_vector (18 downto 0) := "0000000000000011101";--TEST 29 Last GTU,30 GTU Block
------------------------------------------------------------------------------------------------------------------------------------

--SIGNAL  CLOCK               : std_logic;
--SIGNAL  CLOCK_133B          : std_logic;

----CLOCK Manager
--component clk_wiz_0
--port
-- (-- Clock in ports
--  -- Clock out ports
--  clk_out1          : out    std_logic;
--  clk_out2          : out    std_logic;
--  clk_in1           : in     std_logic
-- );
--end component;

--COMPONENT AXI_FIFO
--  PORT (
--    wr_rst_busy : OUT STD_LOGIC;
--    rd_rst_busy : OUT STD_LOGIC;
--    m_aclk : IN STD_LOGIC;
--    s_aclk : IN STD_LOGIC;
--    s_aresetn : IN STD_LOGIC;
--    s_axis_tvalid : IN STD_LOGIC;
--    s_axis_tready : OUT STD_LOGIC;
--    s_axis_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
--    s_axis_tlast : IN STD_LOGIC;
--    m_axis_tvalid : OUT STD_LOGIC;
--    m_axis_tready : IN STD_LOGIC;
--    m_axis_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
--    m_axis_tlast : OUT STD_LOGIC
--  );
--END COMPONENT;

--COMPONENT KI_Trigger
--    PORT (
--       clk_133            : in STD_LOGIC;
--       clock                : in STD_LOGIC;
--       data_spb2_ki       : in STD_LOGIC_VECTOR (17 downto 0);
--       frame_ki           : in STD_LOGIC;
--       --AXI FIFO KI COMMAND
--       s_aclk_cmd_ki        :   in  std_logic;
--       s_aresetn_cmd_ki     :   in  std_logic;
--       s_axis_tvalid_cmd_ki :   in  std_logic;
--       s_axis_tready_cmd_ki :   out std_logic;
--       s_axis_tdata_cmd_ki  :   in  std_logic_vector(31 downto 0);
--       s_axis_tlast_cmd_ki  :   in  std_logic;
--       --AXI FIFO KI TRIGGER OUT
--       m_aclk_trg_ki           :   in  std_logic;
--       m_axis_tvalid_trg_ki    :   out std_logic;
--       m_axis_tready_trg_ki    :   in  std_logic;
--       m_axis_tdata_trg_ki     :   out std_logic_vector(31 downto 0);
--       m_axis_tlast_trg_ki     :   out std_logic
--       );
--END COMPONENT;

--begin

----CLOCK Manager
--CLK_MMCM : clk_wiz_0
--   port map ( 
--  -- Clock out ports  
--   clk_out1 => CLOCK,
--   clk_out2 => CLOCK_133B,--CLOCK_133B=CLOCK_133
--   -- Clock in ports
--   clk_in1 => CLOCK_133
-- );
  
--  SPB2_KI_TRIGGER : KI_Trigger
--    PORT MAP (
--        clk_133             => CLOCK_133B,
--        clock               => CLOCK,
--        data_spb2_ki        => DATA_SPB2_KI,
--        frame_ki            => FRAME_KI,
--        --AXI-FIFO THR COMMAND
--        s_aclk_cmd_ki         => s_aclk_cmd_ki,
--        s_aresetn_cmd_ki      => s_aresetn_cmd_ki,
--        s_axis_tvalid_cmd_ki  => s_axis_tvalid_cmd_ki,
--        s_axis_tready_cmd_ki  => s_axis_tready_cmd_ki,
--        s_axis_tdata_cmd_ki   => s_axis_tdata_cmd_ki,
--        s_axis_tlast_cmd_ki   => s_axis_tlast_cmd_ki,
--        --AXI FIFO KI TRIGGER OUT
--        m_aclk_trg_ki         => m_aclk_trg_ki,
--        m_axis_tvalid_trg_ki  => m_axis_tvalid_trg_ki,
--        m_axis_tready_trg_ki  => m_axis_tready_trg_ki,
--        m_axis_tdata_trg_ki   => m_axis_tdata_trg_ki,
--        m_axis_tlast_trg_ki   => m_axis_tlast_trg_ki
--    );
                    
--end Behavioral;
