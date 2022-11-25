----------------------------------------------------------------------------------
-- Company:INFN Torino 
-- Engineer: M.Mignone
-- 
-- Create Date: 06/26/2020 03:23:11 PM
-- Design Name: 
-- Module Name: SPB2_Trigger - Behavioral
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
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SPB2 is
    generic (SYNTH_BYPASS : std_logic := '0');
    Port ( --CLOCK_133 : in STD_LOGIC;
           clk_100, clk_200: in std_logic;
           DATA_SPB2 : in STD_LOGIC_VECTOR (143 downto 0);
           FRAME : in STD_LOGIC;
           ----------------------STHR DEBUG------------------------------------------------------------------------
--           sthr_debug_ec0ec3ec6 :       out STD_LOGIC_VECTOR (263 downto 0);
--           sthr_ready_debug_ec0ec3ec6 : out STD_LOGIC;
--           sthr_debug_ec1ec4ec7 :       out STD_LOGIC_VECTOR (263 downto 0);
--           sthr_ready_debug_ec1ec4ec7 : out STD_LOGIC;
--           sthr_debug_ec2ec5ec8 :       out STD_LOGIC_VECTOR (263 downto 0);
--           sthr_ready_debug_ec2ec5ec8 : out STD_LOGIC;
           --------------------------------------------------------------------------------------------------------
           --AXI FIFO MACROPIXEL SUM
           m_aclk_sum           :   in  std_logic;
           m_axis_tvalid_sum    :   out std_logic;
           m_axis_tready_sum    :   in  std_logic;
           m_axis_tdata_sum     :   out std_logic_vector(31 downto 0);
           m_axis_tlast_sum     :   out std_logic;
           --AXI FIFO COMMAND
           s_aclk_cmd           :   in  std_logic;
           s_aresetn_cmd        :   in  std_logic;
           s_axis_tvalid_cmd    :   in  std_logic;
           s_axis_tready_cmd    :   out std_logic;
           s_axis_tdata_cmd     :   in  std_logic_vector(31 downto 0);
           s_axis_tdest_cmd     :   in  std_logic_vector(3 downto 0);
           s_axis_tlast_cmd     :   in  std_logic;
           --AXI FIFO TRIGGER OUT
           m_aclk_trg           :   in  std_logic;
           m_axis_tvalid_trg    :   out std_logic;
           m_axis_tready_trg    :   in  std_logic;
           m_axis_tdata_trg     :   out std_logic_vector(31 downto 0);
           m_axis_tlast_trg     :   out std_logic
           
        );
end SPB2;

architecture Behavioral of SPB2 is

	attribute KEEP_HIERARCHY : string;
	attribute KEEP_HIERARCHY of Behavioral: architecture is "TRUE";

CONSTANT    last_frame      : std_logic_vector (18 downto 0) := "1111010000100011111";--499999 Last GTU (500ms) 5000000 GTU Block
--------------------------#TEST#--------------------------------------------------------------------------------------------------
--CONSTANT    last_frame      : std_logic_vector (18 downto 0) := "0000000000000011101";--TEST 29 Last GTU,30 GTU Block
----------------------------------------------------------------------------------------------------------------------------------

SIGNAL  CLOCK               : std_logic;
SIGNAL  CLOCK_133B          : std_logic;

SIGNAL  mp0_ec0ec3ec6        : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp1_ec0ec3ec6        : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp2_ec0ec3ec6        : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp3_ec0ec3ec6        : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp4_ec0ec3ec6        : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp5_ec0ec3ec6        : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp6_ec0ec3ec6        : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp7_ec0ec3ec6        : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp8_ec0ec3ec6        : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp9_ec0ec3ec6        : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp10_ec0ec3ec6       : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp11_ec0ec3ec6       : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp12_ec0ec3ec6       : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp13_ec0ec3ec6       : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp14_ec0ec3ec6       : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp15_ec0ec3ec6       : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp16_ec0ec3ec6       : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp17_ec0ec3ec6       : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp18_ec0ec3ec6       : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp19_ec0ec3ec6       : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp20_ec0ec3ec6       : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp21_ec0ec3ec6       : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp22_ec0ec3ec6       : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp23_ec0ec3ec6       : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp_ready_ec0ec3ec6   : std_logic :='0';

SIGNAL  mp0_ec1ec4ec7        : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp1_ec1ec4ec7        : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp2_ec1ec4ec7        : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp3_ec1ec4ec7        : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp4_ec1ec4ec7        : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp5_ec1ec4ec7        : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp6_ec1ec4ec7        : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp7_ec1ec4ec7        : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp8_ec1ec4ec7        : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp9_ec1ec4ec7        : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp10_ec1ec4ec7       : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp11_ec1ec4ec7       : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp12_ec1ec4ec7       : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp13_ec1ec4ec7       : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp14_ec1ec4ec7       : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp15_ec1ec4ec7       : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp16_ec1ec4ec7       : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp17_ec1ec4ec7       : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp18_ec1ec4ec7       : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp19_ec1ec4ec7       : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp20_ec1ec4ec7       : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp21_ec1ec4ec7       : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp22_ec1ec4ec7       : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp23_ec1ec4ec7       : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp_ready_ec1ec4ec7   : std_logic :='0';

SIGNAL  mp0_ec2ec5ec8        : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp1_ec2ec5ec8        : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp2_ec2ec5ec8        : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp3_ec2ec5ec8        : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp4_ec2ec5ec8        : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp5_ec2ec5ec8        : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp6_ec2ec5ec8        : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp7_ec2ec5ec8        : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp8_ec2ec5ec8        : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp9_ec2ec5ec8        : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp10_ec2ec5ec8       : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp11_ec2ec5ec8       : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp12_ec2ec5ec8       : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp13_ec2ec5ec8       : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp14_ec2ec5ec8       : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp15_ec2ec5ec8       : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp16_ec2ec5ec8       : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp17_ec2ec5ec8       : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp18_ec2ec5ec8       : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp19_ec2ec5ec8       : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp20_ec2ec5ec8       : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp21_ec2ec5ec8       : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp22_ec2ec5ec8       : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp23_ec2ec5ec8       : std_logic_vector (9 downto 0):= ( others => '0');
SIGNAL  mp_ready_ec2ec5ec8   : std_logic :='0';

SIGNAL  mpsum0_ec0ec3ec6    :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum1_ec0ec3ec6    :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum2_ec0ec3ec6    :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum3_ec0ec3ec6    :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum4_ec0ec3ec6    :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum5_ec0ec3ec6    :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum6_ec0ec3ec6    :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum7_ec0ec3ec6    :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum8_ec0ec3ec6    :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum9_ec0ec3ec6    :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum10_ec0ec3ec6   :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum11_ec0ec3ec6   :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum12_ec0ec3ec6   :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum13_ec0ec3ec6   :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum14_ec0ec3ec6   :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum15_ec0ec3ec6   :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum16_ec0ec3ec6   :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum17_ec0ec3ec6   :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum18_ec0ec3ec6   :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum19_ec0ec3ec6   :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum20_ec0ec3ec6   :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum21_ec0ec3ec6   :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum22_ec0ec3ec6   :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum23_ec0ec3ec6   :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum_ready_ec0ec3ec6   :   std_logic := '0';

SIGNAL  mpsum0_ec1ec4ec7    :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum1_ec1ec4ec7    :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum2_ec1ec4ec7    :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum3_ec1ec4ec7    :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum4_ec1ec4ec7    :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum5_ec1ec4ec7    :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum6_ec1ec4ec7    :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum7_ec1ec4ec7    :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum8_ec1ec4ec7    :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum9_ec1ec4ec7    :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum10_ec1ec4ec7   :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum11_ec1ec4ec7   :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum12_ec1ec4ec7   :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum13_ec1ec4ec7   :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum14_ec1ec4ec7   :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum15_ec1ec4ec7   :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum16_ec1ec4ec7   :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum17_ec1ec4ec7   :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum18_ec1ec4ec7   :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum19_ec1ec4ec7   :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum20_ec1ec4ec7   :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum21_ec1ec4ec7   :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum22_ec1ec4ec7   :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum23_ec1ec4ec7   :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum_ready_ec1ec4ec7   :   std_logic := '0';

SIGNAL  mpsum0_ec2ec5ec8    :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum1_ec2ec5ec8    :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum2_ec2ec5ec8    :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum3_ec2ec5ec8    :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum4_ec2ec5ec8    :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum5_ec2ec5ec8    :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum6_ec2ec5ec8    :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum7_ec2ec5ec8    :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum8_ec2ec5ec8    :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum9_ec2ec5ec8    :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum10_ec2ec5ec8   :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum11_ec2ec5ec8   :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum12_ec2ec5ec8   :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum13_ec2ec5ec8   :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum14_ec2ec5ec8   :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum15_ec2ec5ec8   :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum16_ec2ec5ec8   :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum17_ec2ec5ec8   :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum18_ec2ec5ec8   :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum19_ec2ec5ec8   :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum20_ec2ec5ec8   :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum21_ec2ec5ec8   :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum22_ec2ec5ec8   :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum23_ec2ec5ec8   :   std_logic_vector (23 downto 0) := ( others => '0');
SIGNAL  mpsum_ready_ec2ec5ec8   :   std_logic := '0';

SIGNAL  din_fifo_sum_ec0ec3ec6  :   std_logic_vector (575 downto 0) := ( others => '0');
SIGNAL  wr_en_fifo_sum_ec0ec3ec6    :   std_logic := '0';
SIGNAL  rd_en_fifo_sum_ec0ec3ec6    :   std_logic := '0';
SIGNAL  dout_fifo_sum_ec0ec3ec6  :   std_logic_vector (575 downto 0) := ( others => '0');
SIGNAL  empty_fifo_sum_ec0ec3ec6    :   std_logic := '1';

SIGNAL  din_fifo_sum_ec1ec4ec7  :   std_logic_vector (575 downto 0) := ( others => '0');
SIGNAL  wr_en_fifo_sum_ec1ec4ec7    :   std_logic := '0';
SIGNAL  rd_en_fifo_sum_ec1ec4ec7    :   std_logic := '0';
SIGNAL  dout_fifo_sum_ec1ec4ec7  :   std_logic_vector (575 downto 0) := ( others => '0');
SIGNAL  empty_fifo_sum_ec1ec4ec7    :   std_logic := '1';

SIGNAL  din_fifo_sum_ec2ec5ec8  :   std_logic_vector (575 downto 0) := ( others => '0');
SIGNAL  wr_en_fifo_sum_ec2ec5ec8    :   std_logic := '0';
SIGNAL  rd_en_fifo_sum_ec2ec5ec8    :   std_logic := '0';
SIGNAL  dout_fifo_sum_ec2ec5ec8  :   std_logic_vector (575 downto 0) := ( others => '0');
SIGNAL  empty_fifo_sum_ec2ec5ec8    :   std_logic := '1';

SIGNAL  s_aresetn_sum               :   std_logic := '1';
SIGNAL  s_axis_tvalid_sum           :   std_logic := '0';
SIGNAL  s_axis_tready_sum           :   std_logic := '0';
SIGNAL  s_axis_tdata_sum            :   std_logic_vector(31 downto 0) := ( others => '0');
SIGNAL  s_axis_tlast_sum            :   std_logic := '0';

SIGNAL  m_axis_tvalid_cmd           :   std_logic := '0';
SIGNAL  m_axis_tready_cmd           :   std_logic := '0';
SIGNAL  m_axis_tdata_cmd            :   std_logic_vector(31 downto 0) := ( others => '0');
SIGNAL  m_axis_tlast_cmd            :   std_logic := '0';

SIGNAL  s_aresetn_trg               :   std_logic := '1';
SIGNAL  s_axis_tvalid_trg           :   std_logic := '0';
SIGNAL  s_axis_tready_trg           :   std_logic := '0';
SIGNAL  s_axis_tdata_trg            :   std_logic_vector(31 downto 0) := ( others => '0');
SIGNAL  s_axis_tlast_trg            :   std_logic := '0';

SIGNAL  frame_cnt       :   std_logic_vector (18 downto 0) := last_frame;
SIGNAL  frame_cnt_l0    :   std_logic_vector (18 downto 0) := ( others => '0');
SIGNAL  frame_cnt_l1    :   std_logic_vector (18 downto 0) := ( others => '0');

SIGNAL  bmp_c_ec0ec3ec6    :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  bmp_ready_ec0ec3ec6 :   std_logic := '0';
SIGNAL  bmp_c_ec1ec4ec7    :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  bmp_ready_ec1ec4ec7 :   std_logic := '0';
SIGNAL  bmp_c_ec2ec5ec8    :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  bmp_ready_ec2ec5ec8 :   std_logic := '0';

SIGNAL  MPSthr              :   std_logic_vector(15 downto 0) := "1000000000000000";--32768 Default Value

SIGNAL  mc3x1_0_ec0ec3ec6   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_1_ec0ec3ec6   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_2_ec0ec3ec6   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_3_ec0ec3ec6   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_4_ec0ec3ec6   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_5_ec0ec3ec6   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_6_ec0ec3ec6   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_7_ec0ec3ec6   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_8_ec0ec3ec6   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_9_ec0ec3ec6   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_10_ec0ec3ec6  :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_11_ec0ec3ec6  :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_12_ec0ec3ec6  :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_13_ec0ec3ec6  :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_14_ec0ec3ec6  :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_15_ec0ec3ec6  :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_16_ec0ec3ec6  :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_17_ec0ec3ec6  :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_18_ec0ec3ec6  :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_19_ec0ec3ec6  :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_20_ec0ec3ec6  :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_21_ec0ec3ec6  :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_ready_ec0ec3ec6   :   std_logic := '0';

SIGNAL  mc3x1_0_ec1ec4ec7   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_1_ec1ec4ec7   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_2_ec1ec4ec7   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_3_ec1ec4ec7   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_4_ec1ec4ec7   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_5_ec1ec4ec7   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_6_ec1ec4ec7   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_7_ec1ec4ec7   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_8_ec1ec4ec7   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_9_ec1ec4ec7   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_10_ec1ec4ec7  :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_11_ec1ec4ec7  :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_12_ec1ec4ec7  :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_13_ec1ec4ec7  :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_14_ec1ec4ec7  :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_15_ec1ec4ec7  :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_16_ec1ec4ec7  :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_17_ec1ec4ec7  :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_18_ec1ec4ec7  :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_19_ec1ec4ec7  :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_20_ec1ec4ec7  :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_21_ec1ec4ec7  :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_ready_ec1ec4ec7   :   std_logic := '0';

SIGNAL  mc3x1_0_ec2ec5ec8   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_1_ec2ec5ec8   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_2_ec2ec5ec8   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_3_ec2ec5ec8   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_4_ec2ec5ec8   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_5_ec2ec5ec8   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_6_ec2ec5ec8   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_7_ec2ec5ec8   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_8_ec2ec5ec8   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_9_ec2ec5ec8   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_10_ec2ec5ec8  :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_11_ec2ec5ec8  :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_12_ec2ec5ec8  :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_13_ec2ec5ec8  :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_14_ec2ec5ec8  :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_15_ec2ec5ec8  :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_16_ec2ec5ec8  :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_17_ec2ec5ec8  :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_18_ec2ec5ec8  :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_19_ec2ec5ec8  :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_20_ec2ec5ec8  :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_21_ec2ec5ec8  :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  mc3x1_ready_ec2ec5ec8   :   std_logic := '0';

SIGNAL  b0_0_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_1_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_2_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_3_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_4_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_5_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_6_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_7_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_8_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_9_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_10_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_11_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_12_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_13_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_14_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_15_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_16_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_17_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_18_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_19_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_20_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_21_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  sclr0_ec0ec3ec6     :   std_logic := '0';
SIGNAL  mc0_0_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row0
SIGNAL  mc0_1_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row1
SIGNAL  mc0_2_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row2
SIGNAL  mc0_3_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row3
SIGNAL  mc0_4_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row4
SIGNAL  mc0_5_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row5
SIGNAL  mc0_6_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row6
SIGNAL  mc0_7_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row7
SIGNAL  mc0_8_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row8
SIGNAL  mc0_9_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row9
SIGNAL  mc0_10_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row10
SIGNAL  mc0_11_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row11
SIGNAL  mc0_12_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row12
SIGNAL  mc0_13_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row13
SIGNAL  mc0_14_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row14
SIGNAL  mc0_15_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row15
SIGNAL  mc0_16_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row16
SIGNAL  mc0_17_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row17
SIGNAL  mc0_18_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row18
SIGNAL  mc0_19_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row19
SIGNAL  mc0_20_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row20
SIGNAL  mc0_21_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row21

SIGNAL  ce0_ec0ec3ec6       :   std_logic := '0';

SIGNAL  b1_0_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_1_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_2_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_3_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_4_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_5_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_6_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_7_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_8_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_9_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_10_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_11_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_12_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_13_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_14_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_15_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_16_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_17_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_18_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_19_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_20_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_21_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  sclr1_ec0ec3ec6     :   std_logic := '0';
SIGNAL  mc1_0_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row0
SIGNAL  mc1_1_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row1
SIGNAL  mc1_2_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row2
SIGNAL  mc1_3_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row3
SIGNAL  mc1_4_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row4
SIGNAL  mc1_5_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row5
SIGNAL  mc1_6_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row6
SIGNAL  mc1_7_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row7
SIGNAL  mc1_8_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row8
SIGNAL  mc1_9_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row9
SIGNAL  mc1_10_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row10
SIGNAL  mc1_11_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row11
SIGNAL  mc1_12_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row12
SIGNAL  mc1_13_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row13
SIGNAL  mc1_14_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row14
SIGNAL  mc1_15_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row15
SIGNAL  mc1_16_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row16
SIGNAL  mc1_17_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row17
SIGNAL  mc1_18_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row18
SIGNAL  mc1_19_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row19
SIGNAL  mc1_20_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row20
SIGNAL  mc1_21_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row21

SIGNAL  ce1_ec0ec3ec6       :   std_logic := '0';

SIGNAL  b2_0_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_1_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_2_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_3_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_4_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_5_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_6_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_7_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_8_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_9_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_10_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_11_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_12_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_13_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_14_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_15_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_16_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_17_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_18_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_19_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_20_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_21_ec0ec3ec6      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  sclr2_ec0ec3ec6     :   std_logic := '0';
SIGNAL  mc2_0_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row0
SIGNAL  mc2_1_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row1
SIGNAL  mc2_2_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row2
SIGNAL  mc2_3_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row3
SIGNAL  mc2_4_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row4
SIGNAL  mc2_5_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row5
SIGNAL  mc2_6_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row6
SIGNAL  mc2_7_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row7
SIGNAL  mc2_8_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row8
SIGNAL  mc2_9_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row9
SIGNAL  mc2_10_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row10
SIGNAL  mc2_11_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row11
SIGNAL  mc2_12_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row12
SIGNAL  mc2_13_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row13
SIGNAL  mc2_14_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row14
SIGNAL  mc2_15_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row15
SIGNAL  mc2_16_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row16
SIGNAL  mc2_17_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row17
SIGNAL  mc2_18_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row18
SIGNAL  mc2_19_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row19
SIGNAL  mc2_20_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row20
SIGNAL  mc2_21_ec0ec3ec6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row21

SIGNAL  ce2_ec0ec3ec6       :   std_logic := '0';

SIGNAL  b0_0_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_1_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_2_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_3_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_4_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_5_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_6_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_7_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_8_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_9_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_10_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_11_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_12_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_13_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_14_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_15_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_16_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_17_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_18_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_19_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_20_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_21_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  sclr0_ec1ec4ec7     :   std_logic := '0';
SIGNAL  mc0_0_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row0
SIGNAL  mc0_1_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row1
SIGNAL  mc0_2_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row2
SIGNAL  mc0_3_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row3
SIGNAL  mc0_4_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row4
SIGNAL  mc0_5_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row5
SIGNAL  mc0_6_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row6
SIGNAL  mc0_7_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row7
SIGNAL  mc0_8_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row8
SIGNAL  mc0_9_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row9
SIGNAL  mc0_10_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row10
SIGNAL  mc0_11_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row11
SIGNAL  mc0_12_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row12
SIGNAL  mc0_13_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row13
SIGNAL  mc0_14_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row14
SIGNAL  mc0_15_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row15
SIGNAL  mc0_16_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row16
SIGNAL  mc0_17_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row17
SIGNAL  mc0_18_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row18
SIGNAL  mc0_19_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row19
SIGNAL  mc0_20_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row20
SIGNAL  mc0_21_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row21

SIGNAL  ce0_ec1ec4ec7       :   std_logic := '0';

SIGNAL  b1_0_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_1_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_2_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_3_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_4_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_5_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_6_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_7_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_8_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_9_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_10_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_11_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_12_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_13_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_14_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_15_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_16_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_17_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_18_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_19_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_20_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_21_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  sclr1_ec1ec4ec7     :   std_logic := '0';
SIGNAL  mc1_0_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row0
SIGNAL  mc1_1_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row1
SIGNAL  mc1_2_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row2
SIGNAL  mc1_3_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row3
SIGNAL  mc1_4_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row4
SIGNAL  mc1_5_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row5
SIGNAL  mc1_6_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row6
SIGNAL  mc1_7_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row7
SIGNAL  mc1_8_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row8
SIGNAL  mc1_9_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row9
SIGNAL  mc1_10_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row10
SIGNAL  mc1_11_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row11
SIGNAL  mc1_12_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row12
SIGNAL  mc1_13_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row13
SIGNAL  mc1_14_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row14
SIGNAL  mc1_15_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row15
SIGNAL  mc1_16_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row16
SIGNAL  mc1_17_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row17
SIGNAL  mc1_18_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row18
SIGNAL  mc1_19_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row19
SIGNAL  mc1_20_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row20
SIGNAL  mc1_21_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row21

SIGNAL  ce1_ec1ec4ec7       :   std_logic := '0';

SIGNAL  b2_0_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_1_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_2_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_3_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_4_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_5_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_6_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_7_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_8_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_9_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_10_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_11_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_12_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_13_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_14_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_15_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_16_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_17_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_18_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_19_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_20_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_21_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  sclr2_ec1ec4ec7     :   std_logic := '0';
SIGNAL  mc2_0_ec1ec4ec7   :   std_logic_vector(3 downto 0) := ( others => '0');--Row0
SIGNAL  mc2_1_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row1
SIGNAL  mc2_2_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row2
SIGNAL  mc2_3_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row3
SIGNAL  mc2_4_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row4
SIGNAL  mc2_5_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row5
SIGNAL  mc2_6_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row6
SIGNAL  mc2_7_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row7
SIGNAL  mc2_8_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row8
SIGNAL  mc2_9_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row9
SIGNAL  mc2_10_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row10
SIGNAL  mc2_11_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row11
SIGNAL  mc2_12_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row12
SIGNAL  mc2_13_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row13
SIGNAL  mc2_14_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row14
SIGNAL  mc2_15_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row15
SIGNAL  mc2_16_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row16
SIGNAL  mc2_17_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row17
SIGNAL  mc2_18_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row18
SIGNAL  mc2_19_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row19
SIGNAL  mc2_20_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row20
SIGNAL  mc2_21_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row21

SIGNAL  ce2_ec1ec4ec7       :   std_logic := '0';

SIGNAL  b3_0_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b3_1_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b3_2_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b3_3_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b3_4_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b3_5_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b3_6_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b3_7_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b3_8_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b3_9_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b3_10_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b3_11_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b3_12_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b3_13_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b3_14_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b3_15_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b3_16_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b3_17_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b3_18_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b3_19_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b3_20_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b3_21_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  sclr3_ec1ec4ec7     :   std_logic := '0';
SIGNAL  mc3_0_ec1ec4ec7   :   std_logic_vector(3 downto 0) := ( others => '0');--Row0
SIGNAL  mc3_1_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row1
SIGNAL  mc3_2_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row2
SIGNAL  mc3_3_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row3
SIGNAL  mc3_4_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row4
SIGNAL  mc3_5_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row5
SIGNAL  mc3_6_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row6
SIGNAL  mc3_7_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row7
SIGNAL  mc3_8_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row8
SIGNAL  mc3_9_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row9
SIGNAL  mc3_10_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row10
SIGNAL  mc3_11_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row11
SIGNAL  mc3_12_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row12
SIGNAL  mc3_13_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row13
SIGNAL  mc3_14_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row14
SIGNAL  mc3_15_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row15
SIGNAL  mc3_16_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row16
SIGNAL  mc3_17_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row17
SIGNAL  mc3_18_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row18
SIGNAL  mc3_19_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row19
SIGNAL  mc3_20_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row20
SIGNAL  mc3_21_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row21

SIGNAL  ce3_ec1ec4ec7       :   std_logic := '0';

SIGNAL  b4_0_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b4_1_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b4_2_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b4_3_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b4_4_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b4_5_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b4_6_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b4_7_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b4_8_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b4_9_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b4_10_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b4_11_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b4_12_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b4_13_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b4_14_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b4_15_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b4_16_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b4_17_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b4_18_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b4_19_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b4_20_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b4_21_ec1ec4ec7      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  sclr4_ec1ec4ec7     :   std_logic := '0';
SIGNAL  mc4_0_ec1ec4ec7   :   std_logic_vector(3 downto 0) := ( others => '0');--Row0
SIGNAL  mc4_1_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row1
SIGNAL  mc4_2_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row2
SIGNAL  mc4_3_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row3
SIGNAL  mc4_4_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row4
SIGNAL  mc4_5_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row5
SIGNAL  mc4_6_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row6
SIGNAL  mc4_7_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row7
SIGNAL  mc4_8_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row8
SIGNAL  mc4_9_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row9
SIGNAL  mc4_10_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row10
SIGNAL  mc4_11_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row11
SIGNAL  mc4_12_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row12
SIGNAL  mc4_13_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row13
SIGNAL  mc4_14_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row14
SIGNAL  mc4_15_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row15
SIGNAL  mc4_16_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row16
SIGNAL  mc4_17_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row17
SIGNAL  mc4_18_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row18
SIGNAL  mc4_19_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row19
SIGNAL  mc4_20_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row20
SIGNAL  mc4_21_ec1ec4ec7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row21

SIGNAL  ce4_ec1ec4ec7       :   std_logic := '0';

SIGNAL  b0_0_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_1_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_2_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_3_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_4_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_5_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_6_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_7_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_8_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_9_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_10_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_11_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_12_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_13_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_14_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_15_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_16_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_17_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_18_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_19_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_20_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b0_21_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  sclr0_ec2ec5ec8     :   std_logic := '0';
SIGNAL  mc0_0_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row0
SIGNAL  mc0_1_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row1
SIGNAL  mc0_2_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row2
SIGNAL  mc0_3_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row3
SIGNAL  mc0_4_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row4
SIGNAL  mc0_5_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row5
SIGNAL  mc0_6_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row6
SIGNAL  mc0_7_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row7
SIGNAL  mc0_8_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row8
SIGNAL  mc0_9_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row9
SIGNAL  mc0_10_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row10
SIGNAL  mc0_11_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row11
SIGNAL  mc0_12_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row12
SIGNAL  mc0_13_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row13
SIGNAL  mc0_14_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row14
SIGNAL  mc0_15_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row15
SIGNAL  mc0_16_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row16
SIGNAL  mc0_17_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row17
SIGNAL  mc0_18_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row18
SIGNAL  mc0_19_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row19
SIGNAL  mc0_20_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row20
SIGNAL  mc0_21_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row21

SIGNAL  ce0_ec2ec5ec8       :   std_logic := '0';

SIGNAL  b1_0_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_1_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_2_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_3_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_4_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_5_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_6_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_7_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_8_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_9_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_10_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_11_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_12_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_13_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_14_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_15_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_16_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_17_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_18_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_19_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_20_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b1_21_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  sclr1_ec2ec5ec8     :   std_logic := '0';
SIGNAL  mc1_0_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row0
SIGNAL  mc1_1_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row1
SIGNAL  mc1_2_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row2
SIGNAL  mc1_3_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row3
SIGNAL  mc1_4_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row4
SIGNAL  mc1_5_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row5
SIGNAL  mc1_6_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row6
SIGNAL  mc1_7_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row7
SIGNAL  mc1_8_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row8
SIGNAL  mc1_9_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row9
SIGNAL  mc1_10_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row10
SIGNAL  mc1_11_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row11
SIGNAL  mc1_12_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row12
SIGNAL  mc1_13_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row13
SIGNAL  mc1_14_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row14
SIGNAL  mc1_15_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row15
SIGNAL  mc1_16_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row16
SIGNAL  mc1_17_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row17
SIGNAL  mc1_18_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row18
SIGNAL  mc1_19_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row19
SIGNAL  mc1_20_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row20
SIGNAL  mc1_21_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row21

SIGNAL  ce1_ec2ec5ec8       :   std_logic := '0';

SIGNAL  b2_0_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_1_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_2_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_3_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_4_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_5_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_6_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_7_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_8_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_9_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_10_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_11_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_12_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_13_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_14_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_15_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_16_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_17_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_18_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_19_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_20_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b2_21_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  sclr2_ec2ec5ec8     :   std_logic := '0';
SIGNAL  mc2_0_ec2ec5ec8   :   std_logic_vector(3 downto 0) := ( others => '0');--Row0
SIGNAL  mc2_1_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row1
SIGNAL  mc2_2_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row2
SIGNAL  mc2_3_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row3
SIGNAL  mc2_4_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row4
SIGNAL  mc2_5_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row5
SIGNAL  mc2_6_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row6
SIGNAL  mc2_7_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row7
SIGNAL  mc2_8_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row8
SIGNAL  mc2_9_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row9
SIGNAL  mc2_10_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row10
SIGNAL  mc2_11_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row11
SIGNAL  mc2_12_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row12
SIGNAL  mc2_13_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row13
SIGNAL  mc2_14_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row14
SIGNAL  mc2_15_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row15
SIGNAL  mc2_16_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row16
SIGNAL  mc2_17_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row17
SIGNAL  mc2_18_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row18
SIGNAL  mc2_19_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row19
SIGNAL  mc2_20_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row20
SIGNAL  mc2_21_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row21

SIGNAL  ce2_ec2ec5ec8       :   std_logic := '0';

SIGNAL  b3_0_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b3_1_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b3_2_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b3_3_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b3_4_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b3_5_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b3_6_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b3_7_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b3_8_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b3_9_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b3_10_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b3_11_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b3_12_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b3_13_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b3_14_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b3_15_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b3_16_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b3_17_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b3_18_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b3_19_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b3_20_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b3_21_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  sclr3_ec2ec5ec8     :   std_logic := '0';
SIGNAL  mc3_0_ec2ec5ec8   :   std_logic_vector(3 downto 0) := ( others => '0');--Row0
SIGNAL  mc3_1_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row1
SIGNAL  mc3_2_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row2
SIGNAL  mc3_3_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row3
SIGNAL  mc3_4_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row4
SIGNAL  mc3_5_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row5
SIGNAL  mc3_6_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row6
SIGNAL  mc3_7_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row7
SIGNAL  mc3_8_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row8
SIGNAL  mc3_9_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row9
SIGNAL  mc3_10_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row10
SIGNAL  mc3_11_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row11
SIGNAL  mc3_12_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row12
SIGNAL  mc3_13_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row13
SIGNAL  mc3_14_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row14
SIGNAL  mc3_15_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row15
SIGNAL  mc3_16_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row16
SIGNAL  mc3_17_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row17
SIGNAL  mc3_18_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row18
SIGNAL  mc3_19_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row19
SIGNAL  mc3_20_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row20
SIGNAL  mc3_21_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row21

SIGNAL  ce3_ec2ec5ec8       :   std_logic := '0';

SIGNAL  b4_0_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b4_1_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b4_2_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b4_3_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b4_4_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b4_5_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b4_6_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b4_7_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b4_8_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b4_9_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b4_10_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b4_11_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b4_12_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b4_13_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b4_14_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b4_15_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b4_16_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b4_17_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b4_18_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b4_19_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b4_20_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  b4_21_ec2ec5ec8      :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  sclr4_ec2ec5ec8     :   std_logic := '0';
SIGNAL  mc4_0_ec2ec5ec8   :   std_logic_vector(3 downto 0) := ( others => '0');--Row0
SIGNAL  mc4_1_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row1
SIGNAL  mc4_2_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row2
SIGNAL  mc4_3_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row3
SIGNAL  mc4_4_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row4
SIGNAL  mc4_5_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row5
SIGNAL  mc4_6_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row6
SIGNAL  mc4_7_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row7
SIGNAL  mc4_8_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row8
SIGNAL  mc4_9_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row9
SIGNAL  mc4_10_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row10
SIGNAL  mc4_11_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row11
SIGNAL  mc4_12_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row12
SIGNAL  mc4_13_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row13
SIGNAL  mc4_14_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row14
SIGNAL  mc4_15_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row15
SIGNAL  mc4_16_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row16
SIGNAL  mc4_17_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row17
SIGNAL  mc4_18_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row18
SIGNAL  mc4_19_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row19
SIGNAL  mc4_20_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row20
SIGNAL  mc4_21_ec2ec5ec8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row21

SIGNAL  mctmp0_0     :   std_logic_vector(3 downto 0) := ( others => '0');--Row0
SIGNAL  mctmp0_1     :   std_logic_vector(3 downto 0) := ( others => '0');--Row1
SIGNAL  mctmp0_2     :   std_logic_vector(3 downto 0) := ( others => '0');--Row2
SIGNAL  mctmp0_3     :   std_logic_vector(3 downto 0) := ( others => '0');--Row3
SIGNAL  mctmp0_4     :   std_logic_vector(3 downto 0) := ( others => '0');--Row4
SIGNAL  mctmp0_5     :   std_logic_vector(3 downto 0) := ( others => '0');--Row5
SIGNAL  mctmp0_6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row6
SIGNAL  mctmp0_7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row7
SIGNAL  mctmp0_8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row8
SIGNAL  mctmp0_9     :   std_logic_vector(3 downto 0) := ( others => '0');--Row9
SIGNAL  mctmp0_10    :   std_logic_vector(3 downto 0) := ( others => '0');--Row10
SIGNAL  mctmp0_11    :   std_logic_vector(3 downto 0) := ( others => '0');--Row11
SIGNAL  mctmp0_12    :   std_logic_vector(3 downto 0) := ( others => '0');--Row12
SIGNAL  mctmp0_13    :   std_logic_vector(3 downto 0) := ( others => '0');--Row13
SIGNAL  mctmp0_14    :   std_logic_vector(3 downto 0) := ( others => '0');--Row14
SIGNAL  mctmp0_15    :   std_logic_vector(3 downto 0) := ( others => '0');--Row15
SIGNAL  mctmp0_16    :   std_logic_vector(3 downto 0) := ( others => '0');--Row16
SIGNAL  mctmp0_17    :   std_logic_vector(3 downto 0) := ( others => '0');--Row17
SIGNAL  mctmp0_18    :   std_logic_vector(3 downto 0) := ( others => '0');--Row18
SIGNAL  mctmp0_19    :   std_logic_vector(3 downto 0) := ( others => '0');--Row19
SIGNAL  mctmp0_20    :   std_logic_vector(3 downto 0) := ( others => '0');--Row20
SIGNAL  mctmp0_21    :   std_logic_vector(3 downto 0) := ( others => '0');--Row21

SIGNAL  mctmp1_0     :   std_logic_vector(3 downto 0) := ( others => '0');--Row0
SIGNAL  mctmp1_1     :   std_logic_vector(3 downto 0) := ( others => '0');--Row1
SIGNAL  mctmp1_2     :   std_logic_vector(3 downto 0) := ( others => '0');--Row2
SIGNAL  mctmp1_3     :   std_logic_vector(3 downto 0) := ( others => '0');--Row3
SIGNAL  mctmp1_4     :   std_logic_vector(3 downto 0) := ( others => '0');--Row4
SIGNAL  mctmp1_5     :   std_logic_vector(3 downto 0) := ( others => '0');--Row5
SIGNAL  mctmp1_6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row6
SIGNAL  mctmp1_7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row7
SIGNAL  mctmp1_8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row8
SIGNAL  mctmp1_9     :   std_logic_vector(3 downto 0) := ( others => '0');--Row9
SIGNAL  mctmp1_10    :   std_logic_vector(3 downto 0) := ( others => '0');--Row10
SIGNAL  mctmp1_11    :   std_logic_vector(3 downto 0) := ( others => '0');--Row11
SIGNAL  mctmp1_12    :   std_logic_vector(3 downto 0) := ( others => '0');--Row12
SIGNAL  mctmp1_13    :   std_logic_vector(3 downto 0) := ( others => '0');--Row13
SIGNAL  mctmp1_14    :   std_logic_vector(3 downto 0) := ( others => '0');--Row14
SIGNAL  mctmp1_15    :   std_logic_vector(3 downto 0) := ( others => '0');--Row15
SIGNAL  mctmp1_16    :   std_logic_vector(3 downto 0) := ( others => '0');--Row16
SIGNAL  mctmp1_17    :   std_logic_vector(3 downto 0) := ( others => '0');--Row17
SIGNAL  mctmp1_18    :   std_logic_vector(3 downto 0) := ( others => '0');--Row18
SIGNAL  mctmp1_19    :   std_logic_vector(3 downto 0) := ( others => '0');--Row19
SIGNAL  mctmp1_20    :   std_logic_vector(3 downto 0) := ( others => '0');--Row20
SIGNAL  mctmp1_21    :   std_logic_vector(3 downto 0) := ( others => '0');--Row21

SIGNAL  mctmp2_0     :   std_logic_vector(3 downto 0) := ( others => '0');--Row0
SIGNAL  mctmp2_1     :   std_logic_vector(3 downto 0) := ( others => '0');--Row1
SIGNAL  mctmp2_2     :   std_logic_vector(3 downto 0) := ( others => '0');--Row2
SIGNAL  mctmp2_3     :   std_logic_vector(3 downto 0) := ( others => '0');--Row3
SIGNAL  mctmp2_4     :   std_logic_vector(3 downto 0) := ( others => '0');--Row4
SIGNAL  mctmp2_5     :   std_logic_vector(3 downto 0) := ( others => '0');--Row5
SIGNAL  mctmp2_6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row6
SIGNAL  mctmp2_7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row7
SIGNAL  mctmp2_8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row8
SIGNAL  mctmp2_9     :   std_logic_vector(3 downto 0) := ( others => '0');--Row9
SIGNAL  mctmp2_10    :   std_logic_vector(3 downto 0) := ( others => '0');--Row10
SIGNAL  mctmp2_11    :   std_logic_vector(3 downto 0) := ( others => '0');--Row11
SIGNAL  mctmp2_12    :   std_logic_vector(3 downto 0) := ( others => '0');--Row12
SIGNAL  mctmp2_13    :   std_logic_vector(3 downto 0) := ( others => '0');--Row13
SIGNAL  mctmp2_14    :   std_logic_vector(3 downto 0) := ( others => '0');--Row14
SIGNAL  mctmp2_15    :   std_logic_vector(3 downto 0) := ( others => '0');--Row15
SIGNAL  mctmp2_16    :   std_logic_vector(3 downto 0) := ( others => '0');--Row16
SIGNAL  mctmp2_17    :   std_logic_vector(3 downto 0) := ( others => '0');--Row17
SIGNAL  mctmp2_18    :   std_logic_vector(3 downto 0) := ( others => '0');--Row18
SIGNAL  mctmp2_19    :   std_logic_vector(3 downto 0) := ( others => '0');--Row19
SIGNAL  mctmp2_20    :   std_logic_vector(3 downto 0) := ( others => '0');--Row20
SIGNAL  mctmp2_21    :   std_logic_vector(3 downto 0) := ( others => '0');--Row21

SIGNAL  mctmp3_0     :   std_logic_vector(3 downto 0) := ( others => '0');--Row0
SIGNAL  mctmp3_1     :   std_logic_vector(3 downto 0) := ( others => '0');--Row1
SIGNAL  mctmp3_2     :   std_logic_vector(3 downto 0) := ( others => '0');--Row2
SIGNAL  mctmp3_3     :   std_logic_vector(3 downto 0) := ( others => '0');--Row3
SIGNAL  mctmp3_4     :   std_logic_vector(3 downto 0) := ( others => '0');--Row4
SIGNAL  mctmp3_5     :   std_logic_vector(3 downto 0) := ( others => '0');--Row5
SIGNAL  mctmp3_6     :   std_logic_vector(3 downto 0) := ( others => '0');--Row6
SIGNAL  mctmp3_7     :   std_logic_vector(3 downto 0) := ( others => '0');--Row7
SIGNAL  mctmp3_8     :   std_logic_vector(3 downto 0) := ( others => '0');--Row8
SIGNAL  mctmp3_9     :   std_logic_vector(3 downto 0) := ( others => '0');--Row9
SIGNAL  mctmp3_10    :   std_logic_vector(3 downto 0) := ( others => '0');--Row10
SIGNAL  mctmp3_11    :   std_logic_vector(3 downto 0) := ( others => '0');--Row11
SIGNAL  mctmp3_12    :   std_logic_vector(3 downto 0) := ( others => '0');--Row12
SIGNAL  mctmp3_13    :   std_logic_vector(3 downto 0) := ( others => '0');--Row13
SIGNAL  mctmp3_14    :   std_logic_vector(3 downto 0) := ( others => '0');--Row14
SIGNAL  mctmp3_15    :   std_logic_vector(3 downto 0) := ( others => '0');--Row15
SIGNAL  mctmp3_16    :   std_logic_vector(3 downto 0) := ( others => '0');--Row16
SIGNAL  mctmp3_17    :   std_logic_vector(3 downto 0) := ( others => '0');--Row17
SIGNAL  mctmp3_18    :   std_logic_vector(3 downto 0) := ( others => '0');--Row18
SIGNAL  mctmp3_19    :   std_logic_vector(3 downto 0) := ( others => '0');--Row19
SIGNAL  mctmp3_20    :   std_logic_vector(3 downto 0) := ( others => '0');--Row20
SIGNAL  mctmp3_21    :   std_logic_vector(3 downto 0) := ( others => '0');--Row21

SIGNAL  ce4_ec2ec5ec8       :   std_logic := '0';

SIGNAL  mc_ready            :   std_logic := '0';

SIGNAL  nSigma128           :   std_logic_vector(9 downto 0) := "1011000000";--DEFAULT=5.5*128=704

SIGNAL  a_mc_mem            :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  d_mc_mem            :   std_logic_vector(263 downto 0) := ( others => '0');
SIGNAL  we_mc_mem           :   std_logic := '0';
SIGNAL  spo_mc_mem          :   std_logic_vector(263 downto 0) := ( others => '0');

SIGNAL  a_mc_mem_write            :   std_logic_vector(4 downto 0) := "00000";

SIGNAL  mcmem_rden          :   std_logic := '0';

SIGNAL  CE_accum            :   std_logic := '0';
SIGNAL  SCLR_accum          :   std_logic := '0';
SIGNAL  B_accum_mc0_0         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc0_0         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc1_0         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc1_0         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc2_0         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc2_0         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc3_0         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc3_0         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc4_0         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc4_0         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc5_0         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc5_0         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc6_0         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc6_0         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc7_0         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc7_0         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc8_0         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc8_0         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc9_0         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc9_0         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc10_0         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc10_0         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc11_0         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc11_0         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc12_0         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc12_0         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc13_0         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc13_0         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc14_0         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc14_0         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc15_0         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc15_0         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc16_0         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc16_0         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc17_0         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc17_0         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc18_0         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc18_0         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc19_0         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc19_0         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc20_0         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc20_0         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc21_0         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc21_0         :   std_logic_vector(4 downto 0) := ( others => '0');

SIGNAL  B_accum_mc0_1         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc0_1         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc1_1         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc1_1         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc2_1         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc2_1         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc3_1         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc3_1         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc4_1         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc4_1         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc5_1         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc5_1         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc6_1         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc6_1         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc7_1         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc7_1         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc8_1         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc8_1         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc9_1         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc9_1         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc10_1         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc10_1         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc11_1         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc11_1         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc12_1         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc12_1         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc13_1         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc13_1         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc14_1         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc14_1         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc15_1         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc15_1         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc16_1         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc16_1         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc17_1         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc17_1         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc18_1         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc18_1         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc19_1         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc19_1         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc20_1         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc20_1         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc21_1         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc21_1         :   std_logic_vector(4 downto 0) := ( others => '0');

SIGNAL  B_accum_mc0_2         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc0_2         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc1_2         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc1_2         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc2_2         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc2_2         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc3_2         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc3_2         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc4_2         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc4_2         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc5_2         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc5_2         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc6_2         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc6_2         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc7_2         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc7_2         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc8_2         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc8_2         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc9_2         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc9_2         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc10_2         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc10_2         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc11_2         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc11_2         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc12_2         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc12_2         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc13_2         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc13_2         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc14_2         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc14_2         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc15_2         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc15_2         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc16_2         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc16_2         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc17_2         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc17_2         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc18_2         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc18_2         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc19_2         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc19_2         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc20_2         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc20_2         :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  B_accum_mc21_2         :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  Q_accum_mc21_2         :   std_logic_vector(4 downto 0) := ( others => '0');

SIGNAL  bufsum_ready           :   std_logic := '0';

SIGNAL  bufsum_ready_cnt       :   std_logic_vector(2 downto 0) := "000";

SIGNAL  nHot                   :   std_logic_vector(4 downto 0) := "00010";--Default 2
SIGNAL  nHot_l0                :   std_logic_vector(4 downto 0) := "00010";--Default 2

SIGNAL  mc_active_0            :   std_logic_vector(21 downto 0) := ( others => '0');
SIGNAL  mc_active_1            :   std_logic_vector(21 downto 0) := ( others => '0');
SIGNAL  mc_active_2            :   std_logic_vector(21 downto 0) := ( others => '0');
SIGNAL  mc_active_1b           :   std_logic_vector(21 downto 0) := ( others => '0');
SIGNAL  mc_active_2b           :   std_logic_vector(21 downto 0) := ( others => '0');

SIGNAL  mc_active_ready        :   std_logic := '0';

SIGNAL  B_mc_active            :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  CE_mc_active           :   std_logic := '0';
SIGNAL  SCLR_mc_active         :   std_logic := '0';
SIGNAL  Q_mc_active            :   std_logic_vector(8 downto 0) := ( others => '0');

SIGNAL  mc_active_sum_ready    :   std_logic := '0';
SIGNAL  mc_active_col_count    :   std_logic_vector(2 downto 0) := ( others => '0');

SIGNAL  nLenght                :   std_logic_vector(4 downto 0) := "10100";--Default 20
SIGNAL  nLenght_l0             :   std_logic_vector(4 downto 0) := "10100";--Default 20

SIGNAL  a_nl_buffer            :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  d_nl_buffer            :   std_logic_vector(8 downto 0) := ( others => '0');
SIGNAL  we_nl_buffer           :   std_logic := '0';
SIGNAL  spo_nl_buffer          :   std_logic_vector(8 downto 0) := ( others => '0');

SIGNAL  a_nl_buffer_write      :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  a_nl_buffer_read       :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAL  nl_buffer_ready        :   std_logic := '0';

SIGNAL  B_nl_buffer_sum        :   std_logic_vector(8 downto 0) := ( others => '0');
SIGNAL  CE_nl_buffer_sum       :   std_logic := '0';
SIGNAL  SCLR_nl_buffer_sum     :   std_logic := '0';
SIGNAL  Q_nl_buffer_sum        :   std_logic_vector(13 downto 0) := ( others => '0');

SIGNAL  counter_nlpos          :   std_logic_vector(4 downto 0) := ( others => '0');
SIGNAl  nl_buffer_sum_ready    :   std_logic := '0';

SIGNAL  nActive                :   std_logic_vector(10 downto 0) := "00000100010";--Default 34
SIGNAL  nActive_l0             :   std_logic_vector(10 downto 0) := ( others => '0');
SIGNAL  nActive_l1             :   std_logic_vector(10 downto 0) := ( others => '0');
SIGNAL  nActive_l2             :   std_logic_vector(10 downto 0) := ( others => '0');

TYPE    state_frame_type    is  (s0,s1);
SIGNAL  state_frame :   state_frame_type := s0;

TYPE    state_axi_fifo_sum_type is  (s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s17,s18,s19,s20,s21,s22,s23,s24,s25,s26,
                                    s27,s28,s29,s30,s31,s32,s33,s34,s35,s36,s37,s38,s39,s40,s41,s42,s43,s44,s45,s46,s47,s48,s49,s50,s51,
                                    s52,s53,s54,s55,s56,s57,s58,s59,s60,s61,s62,s63,s64,s65,s66,s67,s68,s69,s70,s71,s72,s73,s74,s75);
SIGNAL  state_axi_fifo_sum  :   state_axi_fifo_sum_type := s0;

TYPE    state_macrocell_type    is  (s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s17,s18,s19,s20,s21,s22,s23,s24,s25,s26);
SIGNAL  state_macrocell :  state_macrocell_type := s0;

TYPE    state_read_cmd_type    is  (s0,s1);
SIGNAL  state_read_cmd :   state_read_cmd_type := s0;

TYPE    state_macrocell_buffer_type    is  (s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s17,s18,s19,s20,s21,s22,s23,s24,s25,s26,s27,s28,s29,s30,s31);
SIGNAL  state_macrocell_buffer :   state_macrocell_buffer_type := s0;

TYPE    state_buffer_read_type  is (s0,s1,s2,s3);
SIGNAL  state_buffer_read   :   state_buffer_read_type := s0;

TYPE    state_buffer_check_type  is (s0,s1,s2);
SIGNAL  state_buffer_check   :   state_buffer_check_type := s0;

TYPE    state_bitcounter_type  is (s0,s1,s2,s3);
SIGNAL  state_bitcounter   :   state_bitcounter_type := s0;

TYPE    state_nl_buffer_type  is (s0,s1,s2);
SIGNAL  state_nl_buffer   :   state_nl_buffer_type := s0;

TYPE    state_nl_buffer_sum_type  is (s0,s1,s2);
SIGNAL  state_nl_buffer_sum   :   state_nl_buffer_sum_type := s0;

--CLOCK Manager
component clk_wiz_0
port
 (-- Clock in ports
  -- Clock out ports
  clk_out1          : out    std_logic;
  clk_out2          : out    std_logic;
  clk_in1           : in     std_logic
 );
end component;

--INPUT Pixel to MacroPixel
component IN3EC
port
(
clock_wr    : in    std_logic;
clock_rd    : in    std_logic;
data_in     : in    std_logic_vector(47 downto 0);
frame       : in    std_logic;
mp0         : out   std_logic_vector(9 downto 0);
mp1         : out   std_logic_vector(9 downto 0);
mp2         : out   std_logic_vector(9 downto 0);
mp3         : out   std_logic_vector(9 downto 0);
mp4         : out   std_logic_vector(9 downto 0);
mp5         : out   std_logic_vector(9 downto 0);
mp6         : out   std_logic_vector(9 downto 0);
mp7         : out   std_logic_vector(9 downto 0);
mp8         : out   std_logic_vector(9 downto 0);
mp9         : out   std_logic_vector(9 downto 0);
mp10         : out   std_logic_vector(9 downto 0);
mp11         : out   std_logic_vector(9 downto 0);
mp12         : out   std_logic_vector(9 downto 0);
mp13         : out   std_logic_vector(9 downto 0);
mp14         : out   std_logic_vector(9 downto 0);
mp15         : out   std_logic_vector(9 downto 0);
mp16         : out   std_logic_vector(9 downto 0);
mp17         : out   std_logic_vector(9 downto 0);
mp18         : out   std_logic_vector(9 downto 0);
mp19         : out   std_logic_vector(9 downto 0);
mp20         : out   std_logic_vector(9 downto 0);
mp21         : out   std_logic_vector(9 downto 0);
mp22         : out   std_logic_vector(9 downto 0);
mp23         : out   std_logic_vector(9 downto 0);
mp_ready    : out   std_logic
);
END COMPONENT;

component MACROPIXEL_SUM
port
(
    clock       : in   std_logic;
    frame_count : in   std_logic_vector (18 downto 0);
    mp0         : in   std_logic_vector(9 downto 0);
    mp1         : in   std_logic_vector(9 downto 0);
    mp2         : in   std_logic_vector(9 downto 0);
    mp3         : in   std_logic_vector(9 downto 0);
    mp4         : in   std_logic_vector(9 downto 0);
    mp5         : in   std_logic_vector(9 downto 0);
    mp6         : in   std_logic_vector(9 downto 0);
    mp7         : in   std_logic_vector(9 downto 0);
    mp8         : in   std_logic_vector(9 downto 0);
    mp9         : in   std_logic_vector(9 downto 0);
    mp10        : in   std_logic_vector(9 downto 0);
    mp11        : in   std_logic_vector(9 downto 0);
    mp12        : in   std_logic_vector(9 downto 0);
    mp13        : in   std_logic_vector(9 downto 0);
    mp14        : in   std_logic_vector(9 downto 0);
    mp15        : in   std_logic_vector(9 downto 0);
    mp16        : in   std_logic_vector(9 downto 0);
    mp17        : in   std_logic_vector(9 downto 0);
    mp18        : in   std_logic_vector(9 downto 0);
    mp19        : in   std_logic_vector(9 downto 0);
    mp20        : in   std_logic_vector(9 downto 0);
    mp21        : in   std_logic_vector(9 downto 0);
    mp22        : in   std_logic_vector(9 downto 0);
    mp23        : in   std_logic_vector(9 downto 0);
    mp_ready    : in   std_logic;
    mpsum0      : out  std_logic_vector (23 downto 0);
    mpsum1      : out  std_logic_vector (23 downto 0);
    mpsum2      : out  std_logic_vector (23 downto 0);
    mpsum3      : out  std_logic_vector (23 downto 0);
    mpsum4      : out  std_logic_vector (23 downto 0);
    mpsum5      : out  std_logic_vector (23 downto 0);
    mpsum6      : out  std_logic_vector (23 downto 0);
    mpsum7      : out  std_logic_vector (23 downto 0);
    mpsum8      : out  std_logic_vector (23 downto 0);
    mpsum9      : out  std_logic_vector (23 downto 0);
    mpsum10     : out  std_logic_vector (23 downto 0);
    mpsum11     : out  std_logic_vector (23 downto 0);
    mpsum12     : out  std_logic_vector (23 downto 0);
    mpsum13     : out  std_logic_vector (23 downto 0);
    mpsum14     : out std_logic_vector (23 downto 0);
    mpsum15     : out  std_logic_vector (23 downto 0);
    mpsum16     : out  std_logic_vector (23 downto 0);
    mpsum17     : out  std_logic_vector (23 downto 0);
    mpsum18     : out  std_logic_vector (23 downto 0);
    mpsum19     : out  std_logic_vector (23 downto 0);
    mpsum20     : out  std_logic_vector (23 downto 0);
    mpsum21     : out  std_logic_vector (23 downto 0);
    mpsum22     : out  std_logic_vector (23 downto 0);
    mpsum23     : out  std_logic_vector (23 downto 0);
    mpsum_ready : out   std_logic
);
end component;

COMPONENT fifo_sum_576x32
  PORT (
    clk : IN STD_LOGIC;
    srst : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(575 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(575 DOWNTO 0);
    full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC
  );
END COMPONENT;

COMPONENT AXI_FIFO
  PORT (
    wr_rst_busy : OUT STD_LOGIC;
    rd_rst_busy : OUT STD_LOGIC;
    m_aclk : IN STD_LOGIC;
    s_aclk : IN STD_LOGIC;
    s_aresetn : IN STD_LOGIC;
    s_axis_tvalid : IN STD_LOGIC;
    s_axis_tready : OUT STD_LOGIC;
    s_axis_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axis_tlast : IN STD_LOGIC;
    m_axis_tvalid : OUT STD_LOGIC;
    m_axis_tready : IN STD_LOGIC;
    m_axis_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axis_tlast : OUT STD_LOGIC
  );
END COMPONENT;

COMPONENT MACROPIXEL_CHECK
port
(
clock       : in    std_logic;
----------------------STHR DEBUG-----------------------
--sthr_debug : out STD_LOGIC_VECTOR (263 downto 0);
--sthr_ready_debug : out STD_LOGIC;
-------------------------------------------------------
nSigma128   : in    std_logic_vector(9 downto 0);
mp0         : in    std_logic_vector(9 downto 0);
mp1         : in    std_logic_vector(9 downto 0);
mp2         : in    std_logic_vector(9 downto 0);
mp3         : in    std_logic_vector(9 downto 0);
mp4         : in    std_logic_vector(9 downto 0);
mp5         : in    std_logic_vector(9 downto 0);
mp6         : in    std_logic_vector(9 downto 0);
mp7         : in    std_logic_vector(9 downto 0);
mp8         : in    std_logic_vector(9 downto 0);
mp9         : in    std_logic_vector(9 downto 0);
mp10        : in    std_logic_vector(9 downto 0);
mp11        : in    std_logic_vector(9 downto 0);
mp12        : in    std_logic_vector(9 downto 0);
mp13        : in    std_logic_vector(9 downto 0);
mp14        : in    std_logic_vector(9 downto 0);
mp15        : in    std_logic_vector(9 downto 0);
mp16        : in    std_logic_vector(9 downto 0);
mp17        : in    std_logic_vector(9 downto 0);
mp18        : in    std_logic_vector(9 downto 0);
mp19        : in    std_logic_vector(9 downto 0);
mp20        : in    std_logic_vector(9 downto 0);
mp21        : in    std_logic_vector(9 downto 0);
mp22        : in    std_logic_vector(9 downto 0);
mp23        : in    std_logic_vector(9 downto 0);
mp_ready    : in    std_logic;
mpsum0      : in  std_logic_vector (23 downto 0);
mpsum1      : in  std_logic_vector (23 downto 0);
mpsum2      : in  std_logic_vector (23 downto 0);
mpsum3      : in  std_logic_vector (23 downto 0);
mpsum4      : in  std_logic_vector (23 downto 0);
mpsum5      : in  std_logic_vector (23 downto 0);
mpsum6      : in  std_logic_vector (23 downto 0);
mpsum7      : in  std_logic_vector (23 downto 0);
mpsum8      : in  std_logic_vector (23 downto 0);
mpsum9      : in  std_logic_vector (23 downto 0);
mpsum10     : in  std_logic_vector (23 downto 0);
mpsum11     : in  std_logic_vector (23 downto 0);
mpsum12     : in  std_logic_vector (23 downto 0);
mpsum13     : in  std_logic_vector (23 downto 0);
mpsum14     : in std_logic_vector (23 downto 0);
mpsum15     : in  std_logic_vector (23 downto 0);
mpsum16     : in  std_logic_vector (23 downto 0);
mpsum17     : in  std_logic_vector (23 downto 0);
mpsum18     : in  std_logic_vector (23 downto 0);
mpsum19     : in  std_logic_vector (23 downto 0);
mpsum20     : in  std_logic_vector (23 downto 0);
mpsum21     : in  std_logic_vector (23 downto 0);
mpsum22     : in  std_logic_vector (23 downto 0);
mpsum23     : in  std_logic_vector (23 downto 0);
mpsum_ready : in  std_logic;
bmp_c       : out std_logic_vector(23 downto 0);--Binary-macropixel column
bmp_ready   : out std_logic;
MPSthr      : in  std_logic_vector(15 downto 0)
);
END COMPONENT;

--3X1 MacroCell Calculation
COMPONENT MACROCELL_3X1
port(
    clock       : in    std_logic;
    bmp_c       : in    std_logic_vector(23 downto 0);--Binary-macropixel column
    bmp_ready   : in    std_logic;
    mc3x1_0     : out   std_logic_vector(1 downto 0);--3x1 MacroCell
    mc3x1_1     : out   std_logic_vector(1 downto 0);
    mc3x1_2     : out   std_logic_vector(1 downto 0);
    mc3x1_3     : out   std_logic_vector(1 downto 0);
    mc3x1_4     : out   std_logic_vector(1 downto 0);
    mc3x1_5     : out   std_logic_vector(1 downto 0);
    mc3x1_6     : out   std_logic_vector(1 downto 0);
    mc3x1_7     : out   std_logic_vector(1 downto 0);
    mc3x1_8     : out   std_logic_vector(1 downto 0);
    mc3x1_9     : out   std_logic_vector(1 downto 0);
    mc3x1_10    : out   std_logic_vector(1 downto 0);
    mc3x1_11    : out   std_logic_vector(1 downto 0);
    mc3x1_12    : out   std_logic_vector(1 downto 0);
    mc3x1_13    : out   std_logic_vector(1 downto 0);
    mc3x1_14    : out   std_logic_vector(1 downto 0);
    mc3x1_15    : out   std_logic_vector(1 downto 0);
    mc3x1_16    : out   std_logic_vector(1 downto 0);
    mc3x1_17    : out   std_logic_vector(1 downto 0);
    mc3x1_18    : out   std_logic_vector(1 downto 0);
    mc3x1_19    : out   std_logic_vector(1 downto 0);
    mc3x1_20    : out   std_logic_vector(1 downto 0);
    mc3x1_21 : out STD_LOGIC_VECTOR (1 downto 0);
    mc3x1_ready : out   std_logic
);
END COMPONENT;

COMPONENT MACROCELL_BUFFER
  PORT (
    a : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    d : IN STD_LOGIC_VECTOR(263 DOWNTO 0);
    clk : IN STD_LOGIC;
    we : IN STD_LOGIC;
    spo : OUT STD_LOGIC_VECTOR(263 DOWNTO 0)
  );
END COMPONENT;

--MACROCELL Calculation
COMPONENT accum_2_4
  PORT (
    B : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    CLK : IN STD_LOGIC;
    CE : IN STD_LOGIC;
    SCLR : IN STD_LOGIC;
    Q : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
  );
END COMPONENT;

COMPONENT accum_4_5
  PORT (
    B : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    CLK : IN STD_LOGIC;
    CE : IN STD_LOGIC;
    SCLR : IN STD_LOGIC;
    Q : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
  );
END COMPONENT;

COMPONENT accum_5_9
  PORT (
    B : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    CLK : IN STD_LOGIC;
    CE : IN STD_LOGIC;
    SCLR : IN STD_LOGIC;
    Q : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
  );
END COMPONENT;

COMPONENT NLENGHT_BUFFER
  PORT (
    a : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    d : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    clk : IN STD_LOGIC;
    we : IN STD_LOGIC;
    spo : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
  );
END COMPONENT;

COMPONENT ACCUM_9_14
  PORT (
    B : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    CLK : IN STD_LOGIC;
    CE : IN STD_LOGIC;
    SCLR : IN STD_LOGIC;
    Q : OUT STD_LOGIC_VECTOR(13 DOWNTO 0)
  );
END COMPONENT;

function bitcount (binary_vector : std_logic_vector(21 downto 0))
return std_logic_vector is
    variable sum_vector : std_logic_vector(4 downto 0) := ( others => '0');
begin
    for i in binary_vector'range loop
        if binary_vector(i) = '1' then
            sum_vector := sum_vector + 1;
        end if;
    end loop;
    return sum_vector;
end function bitcount;

	signal s_axis_tvalid_cmd_d0: std_logic := '0';

	attribute keep : string; 
	attribute keep of nSigma128: signal is "true";  
	attribute keep of nHot: signal is "true";  
	attribute keep of nLenght: signal is "true";  
	attribute keep of nActive: signal is "true";  
	attribute keep of MPSthr: signal is "true";  

begin

SYNTH_BYPASS_GEN: if(SYNTH_BYPASS = '0')  generate

----CLOCK Manager
--CLK_MMCM : clk_wiz_0
--   port map ( 
--  -- Clock out ports  
--   clk_out1 => CLOCK,
--   clk_out2 => CLOCK_133B,--CLOCK_133B=CLOCK_133
--   -- Clock in ports
--   clk_in1 => CLOCK_133
-- );
 
 CLOCK <= clk_100;
 CLOCK_133B <= clk_200;
 
--INPUT Pixel to MacroPixel
IN_EC0EC3EC6 : IN3EC
port map (
    clock_wr    => CLOCK_133B,
    clock_rd    => CLOCK,
    data_in     => DATA_SPB2(47 downto 0),
    frame       => FRAME,
    mp0         => mp0_ec0ec3ec6,
    mp1         => mp1_ec0ec3ec6,
    mp2         => mp2_ec0ec3ec6,
    mp3         => mp3_ec0ec3ec6,
    mp4         => mp4_ec0ec3ec6,
    mp5         => mp5_ec0ec3ec6,
    mp6         => mp6_ec0ec3ec6,
    mp7         => mp7_ec0ec3ec6,
    mp8         => mp8_ec0ec3ec6,
    mp9         => mp9_ec0ec3ec6,
    mp10        => mp10_ec0ec3ec6,
    mp11        => mp11_ec0ec3ec6,
    mp12        => mp12_ec0ec3ec6,
    mp13        => mp13_ec0ec3ec6,
    mp14        => mp14_ec0ec3ec6,
    mp15        => mp15_ec0ec3ec6,
    mp16        => mp16_ec0ec3ec6,
    mp17        => mp17_ec0ec3ec6,
    mp18        => mp18_ec0ec3ec6,
    mp19        => mp19_ec0ec3ec6,
    mp20        => mp20_ec0ec3ec6,
    mp21        => mp21_ec0ec3ec6,
    mp22        => mp22_ec0ec3ec6,
    mp23        => mp23_ec0ec3ec6,
    mp_ready    => mp_ready_ec0ec3ec6
);

--INPUT Pixel to MacroPixel
IN_EC1EC4EC7 : IN3EC
port map (
    clock_wr    => CLOCK_133B,
    clock_rd    => CLOCK,
    data_in     => DATA_SPB2(95 downto 48),
    frame       => FRAME,
    mp0         => mp0_ec1ec4ec7,
    mp1         => mp1_ec1ec4ec7,
    mp2         => mp2_ec1ec4ec7,
    mp3         => mp3_ec1ec4ec7,
    mp4         => mp4_ec1ec4ec7,
    mp5         => mp5_ec1ec4ec7,
    mp6         => mp6_ec1ec4ec7,
    mp7         => mp7_ec1ec4ec7,
    mp8         => mp8_ec1ec4ec7,
    mp9         => mp9_ec1ec4ec7,
    mp10        => mp10_ec1ec4ec7,
    mp11        => mp11_ec1ec4ec7,
    mp12        => mp12_ec1ec4ec7,
    mp13        => mp13_ec1ec4ec7,
    mp14        => mp14_ec1ec4ec7,
    mp15        => mp15_ec1ec4ec7,
    mp16        => mp16_ec1ec4ec7,
    mp17        => mp17_ec1ec4ec7,
    mp18        => mp18_ec1ec4ec7,
    mp19        => mp19_ec1ec4ec7,
    mp20        => mp20_ec1ec4ec7,
    mp21        => mp21_ec1ec4ec7,
    mp22        => mp22_ec1ec4ec7,
    mp23        => mp23_ec1ec4ec7,
    mp_ready    => mp_ready_ec1ec4ec7
);

--INPUT Pixel to MacroPixel
IN_EC2EC5EC8 : IN3EC
port map (
    clock_wr    => CLOCK_133B,
    clock_rd    => CLOCK,
    data_in     => DATA_SPB2(143 downto 96),
    frame       => FRAME,
    mp0         => mp0_ec2ec5ec8,
    mp1         => mp1_ec2ec5ec8,
    mp2         => mp2_ec2ec5ec8,
    mp3         => mp3_ec2ec5ec8,
    mp4         => mp4_ec2ec5ec8,
    mp5         => mp5_ec2ec5ec8,
    mp6         => mp6_ec2ec5ec8,
    mp7         => mp7_ec2ec5ec8,
    mp8         => mp8_ec2ec5ec8,
    mp9         => mp9_ec2ec5ec8,
    mp10        => mp10_ec2ec5ec8,
    mp11        => mp11_ec2ec5ec8,
    mp12        => mp12_ec2ec5ec8,
    mp13        => mp13_ec2ec5ec8,
    mp14        => mp14_ec2ec5ec8,
    mp15        => mp15_ec2ec5ec8,
    mp16        => mp16_ec2ec5ec8,
    mp17        => mp17_ec2ec5ec8,
    mp18        => mp18_ec2ec5ec8,
    mp19        => mp19_ec2ec5ec8,
    mp20        => mp20_ec2ec5ec8,
    mp21        => mp21_ec2ec5ec8,
    mp22        => mp22_ec2ec5ec8,
    mp23        => mp23_ec2ec5ec8,
    mp_ready    => mp_ready_ec2ec5ec8
);

--Sum MP calculation over 16384 GTU
MACROPIXEL_SUM_EC0EC3EC6 : MACROPIXEL_SUM
port map(
clock => CLOCK,
frame_count => frame_cnt,
mp0 => mp0_ec0ec3ec6,
mp1 => mp1_ec0ec3ec6,
mp2 => mp2_ec0ec3ec6,
mp3 => mp3_ec0ec3ec6,
mp4 => mp4_ec0ec3ec6,
mp5 => mp5_ec0ec3ec6,
mp6 => mp6_ec0ec3ec6,
mp7 => mp7_ec0ec3ec6,
mp8 => mp8_ec0ec3ec6,
mp9 => mp9_ec0ec3ec6,
mp10 => mp10_ec0ec3ec6,
mp11 => mp11_ec0ec3ec6,
mp12 => mp12_ec0ec3ec6,
mp13 => mp13_ec0ec3ec6,
mp14 => mp14_ec0ec3ec6,
mp15 => mp15_ec0ec3ec6,
mp16 => mp16_ec0ec3ec6,
mp17 => mp17_ec0ec3ec6,
mp18 => mp18_ec0ec3ec6,
mp19 => mp19_ec0ec3ec6,
mp20 => mp20_ec0ec3ec6,
mp21 => mp21_ec0ec3ec6,
mp22 => mp22_ec0ec3ec6,
mp23 => mp23_ec0ec3ec6,
mp_ready => mp_ready_ec0ec3ec6,
mpsum0  => mpsum0_ec0ec3ec6,
mpsum1  => mpsum1_ec0ec3ec6,
mpsum2  => mpsum2_ec0ec3ec6,
mpsum3  => mpsum3_ec0ec3ec6,
mpsum4  => mpsum4_ec0ec3ec6,
mpsum5  => mpsum5_ec0ec3ec6,
mpsum6  => mpsum6_ec0ec3ec6,
mpsum7  => mpsum7_ec0ec3ec6,
mpsum8  => mpsum8_ec0ec3ec6,
mpsum9  => mpsum9_ec0ec3ec6,
mpsum10 => mpsum10_ec0ec3ec6,
mpsum11 => mpsum11_ec0ec3ec6,
mpsum12 => mpsum12_ec0ec3ec6,
mpsum13 => mpsum13_ec0ec3ec6,
mpsum14 => mpsum14_ec0ec3ec6,
mpsum15 => mpsum15_ec0ec3ec6,
mpsum16 => mpsum16_ec0ec3ec6,
mpsum17 => mpsum17_ec0ec3ec6,
mpsum18 => mpsum18_ec0ec3ec6,
mpsum19 => mpsum19_ec0ec3ec6,
mpsum20 => mpsum20_ec0ec3ec6,
mpsum21 => mpsum21_ec0ec3ec6,
mpsum22 => mpsum22_ec0ec3ec6,
mpsum23 => mpsum23_ec0ec3ec6,
mpsum_ready => mpsum_ready_ec0ec3ec6
);

--Sum MP calculation over 16384 GTU
MACROPIXEL_SUM_EC1EC4EC7 : MACROPIXEL_SUM
port map(
clock => CLOCK,
frame_count => frame_cnt,
mp0 => mp0_ec1ec4ec7,
mp1 => mp1_ec1ec4ec7,
mp2 => mp2_ec1ec4ec7,
mp3 => mp3_ec1ec4ec7,
mp4 => mp4_ec1ec4ec7,
mp5 => mp5_ec1ec4ec7,
mp6 => mp6_ec1ec4ec7,
mp7 => mp7_ec1ec4ec7,
mp8 => mp8_ec1ec4ec7,
mp9 => mp9_ec1ec4ec7,
mp10 => mp10_ec1ec4ec7,
mp11 => mp11_ec1ec4ec7,
mp12 => mp12_ec1ec4ec7,
mp13 => mp13_ec1ec4ec7,
mp14 => mp14_ec1ec4ec7,
mp15 => mp15_ec1ec4ec7,
mp16 => mp16_ec1ec4ec7,
mp17 => mp17_ec1ec4ec7,
mp18 => mp18_ec1ec4ec7,
mp19 => mp19_ec1ec4ec7,
mp20 => mp20_ec1ec4ec7,
mp21 => mp21_ec1ec4ec7,
mp22 => mp22_ec1ec4ec7,
mp23 => mp23_ec1ec4ec7,
mp_ready => mp_ready_ec1ec4ec7,
mpsum0  => mpsum0_ec1ec4ec7,
mpsum1  => mpsum1_ec1ec4ec7,
mpsum2  => mpsum2_ec1ec4ec7,
mpsum3  => mpsum3_ec1ec4ec7,
mpsum4  => mpsum4_ec1ec4ec7,
mpsum5  => mpsum5_ec1ec4ec7,
mpsum6  => mpsum6_ec1ec4ec7,
mpsum7  => mpsum7_ec1ec4ec7,
mpsum8  => mpsum8_ec1ec4ec7,
mpsum9  => mpsum9_ec1ec4ec7,
mpsum10 => mpsum10_ec1ec4ec7,
mpsum11 => mpsum11_ec1ec4ec7,
mpsum12 => mpsum12_ec1ec4ec7,
mpsum13 => mpsum13_ec1ec4ec7,
mpsum14 => mpsum14_ec1ec4ec7,
mpsum15 => mpsum15_ec1ec4ec7,
mpsum16 => mpsum16_ec1ec4ec7,
mpsum17 => mpsum17_ec1ec4ec7,
mpsum18 => mpsum18_ec1ec4ec7,
mpsum19 => mpsum19_ec1ec4ec7,
mpsum20 => mpsum20_ec1ec4ec7,
mpsum21 => mpsum21_ec1ec4ec7,
mpsum22 => mpsum22_ec1ec4ec7,
mpsum23 => mpsum23_ec1ec4ec7,
mpsum_ready => mpsum_ready_ec1ec4ec7
);

--Sum MP calculation over 16384 GTU
MACROPIXEL_SUM_EC2EC5EC8 : MACROPIXEL_SUM
port map(
clock => CLOCK,
frame_count => frame_cnt,
mp0 => mp0_ec2ec5ec8,
mp1 => mp1_ec2ec5ec8,
mp2 => mp2_ec2ec5ec8,
mp3 => mp3_ec2ec5ec8,
mp4 => mp4_ec2ec5ec8,
mp5 => mp5_ec2ec5ec8,
mp6 => mp6_ec2ec5ec8,
mp7 => mp7_ec2ec5ec8,
mp8 => mp8_ec2ec5ec8,
mp9 => mp9_ec2ec5ec8,
mp10 => mp10_ec2ec5ec8,
mp11 => mp11_ec2ec5ec8,
mp12 => mp12_ec2ec5ec8,
mp13 => mp13_ec2ec5ec8,
mp14 => mp14_ec2ec5ec8,
mp15 => mp15_ec2ec5ec8,
mp16 => mp16_ec2ec5ec8,
mp17 => mp17_ec2ec5ec8,
mp18 => mp18_ec2ec5ec8,
mp19 => mp19_ec2ec5ec8,
mp20 => mp20_ec2ec5ec8,
mp21 => mp21_ec2ec5ec8,
mp22 => mp22_ec2ec5ec8,
mp23 => mp23_ec2ec5ec8,
mp_ready => mp_ready_ec2ec5ec8,
mpsum0  => mpsum0_ec2ec5ec8,
mpsum1  => mpsum1_ec2ec5ec8,
mpsum2  => mpsum2_ec2ec5ec8,
mpsum3  => mpsum3_ec2ec5ec8,
mpsum4  => mpsum4_ec2ec5ec8,
mpsum5  => mpsum5_ec2ec5ec8,
mpsum6  => mpsum6_ec2ec5ec8,
mpsum7  => mpsum7_ec2ec5ec8,
mpsum8  => mpsum8_ec2ec5ec8,
mpsum9  => mpsum9_ec2ec5ec8,
mpsum10 => mpsum10_ec2ec5ec8,
mpsum11 => mpsum11_ec2ec5ec8,
mpsum12 => mpsum12_ec2ec5ec8,
mpsum13 => mpsum13_ec2ec5ec8,
mpsum14 => mpsum14_ec2ec5ec8,
mpsum15 => mpsum15_ec2ec5ec8,
mpsum16 => mpsum16_ec2ec5ec8,
mpsum17 => mpsum17_ec2ec5ec8,
mpsum18 => mpsum18_ec2ec5ec8,
mpsum19 => mpsum19_ec2ec5ec8,
mpsum20 => mpsum20_ec2ec5ec8,
mpsum21 => mpsum21_ec2ec5ec8,
mpsum22 => mpsum22_ec2ec5ec8,
mpsum23 => mpsum23_ec2ec5ec8,
mpsum_ready => mpsum_ready_ec2ec5ec8
);

FIFO_SUM_EC0EC3EC6 : FIFO_SUM_576x32
PORT MAP (
    clk => CLOCK,
    srst => '0',
    din => din_fifo_sum_ec0ec3ec6,
    wr_en => wr_en_fifo_sum_ec0ec3ec6,
    rd_en => rd_en_fifo_sum_ec0ec3ec6,
    dout => dout_fifo_sum_ec0ec3ec6,
    full => open,
    empty => empty_fifo_sum_ec0ec3ec6
);
  
FIFO_SUM_EC1EC4EC7 : FIFO_SUM_576x32
PORT MAP (
  clk => CLOCK,
  srst => '0',
  din => din_fifo_sum_ec1ec4ec7,
  wr_en => wr_en_fifo_sum_ec1ec4ec7,
  rd_en => rd_en_fifo_sum_ec1ec4ec7,
  dout => dout_fifo_sum_ec1ec4ec7,
  full => open,
  empty => empty_fifo_sum_ec1ec4ec7
);

FIFO_SUM_EC2EC5EC8 : FIFO_SUM_576x32
PORT MAP (
  clk => CLOCK,
  srst => '0',
  din => din_fifo_sum_ec2ec5ec8,
  wr_en => wr_en_fifo_sum_ec2ec5ec8,
  rd_en => rd_en_fifo_sum_ec2ec5ec8,
  dout => dout_fifo_sum_ec2ec5ec8,
  full => open,
  empty => empty_fifo_sum_ec2ec5ec8
);

  
AXI_FIFO_SUM : AXI_FIFO
    PORT MAP (
      wr_rst_busy => open,
      rd_rst_busy => open,
      m_aclk => m_aclk_sum,-->PROC.
      s_aclk => CLOCK,
      s_aresetn => s_aresetn_sum,
      s_axis_tvalid => s_axis_tvalid_sum,
      s_axis_tready => s_axis_tready_sum,
      s_axis_tdata => s_axis_tdata_sum,
      s_axis_tlast => s_axis_tlast_sum,
      m_axis_tvalid => m_axis_tvalid_sum,-->PROC.
      m_axis_tready => m_axis_tready_sum,-->PROC.
      m_axis_tdata => m_axis_tdata_sum,-->PROC.
      m_axis_tlast => m_axis_tlast_sum-->PROC.
    );
    
 s_axis_tvalid_cmd_d0 <= s_axis_tvalid_cmd;-- when s_axis_tdest_cmd = 0;
 
 AXI_FIFO_CMD : AXI_FIFO
    PORT MAP (
      wr_rst_busy => open,
      rd_rst_busy => open,
      m_aclk => CLOCK,
      s_aclk => s_aclk_cmd,-->PROC.
      s_aresetn => s_aresetn_cmd,-->PROC.
      s_axis_tvalid => s_axis_tvalid_cmd_d0,-->PROC.
      s_axis_tready => s_axis_tready_cmd,-->PROC.
      s_axis_tdata => s_axis_tdata_cmd,-->PROC.
      s_axis_tlast => s_axis_tlast_cmd,-->PROC.
      m_axis_tvalid => m_axis_tvalid_cmd,
      m_axis_tready => m_axis_tready_cmd,
      m_axis_tdata => m_axis_tdata_cmd,
      m_axis_tlast => m_axis_tlast_cmd
    );
    
AXI_FIFO_TRIG : AXI_FIFO
    PORT MAP (
      wr_rst_busy => open,
      rd_rst_busy => open,
      m_aclk => m_aclk_trg,-->PROC.
      s_aclk => CLOCK,
      s_aresetn => s_aresetn_trg,
      s_axis_tvalid => s_axis_tvalid_trg,
      s_axis_tready => s_axis_tready_trg,
      s_axis_tdata => s_axis_tdata_trg,
      s_axis_tlast => s_axis_tlast_trg,
      m_axis_tvalid => m_axis_tvalid_trg,-->PROC.
      m_axis_tready => m_axis_tready_trg,-->PROC.
      m_axis_tdata => m_axis_tdata_trg,-->PROC.
      m_axis_tlast => m_axis_tlast_trg-->PROC.
    );
    
--Check if MacroPixel > Sthr    
MACROPIXEL_CHECK_EC0EC3EC6 : MACROPIXEL_CHECK
PORT MAP (
    clock   => CLOCK,
    ----------------------STHR DEBUG------------------------------------------------------------------------
--    sthr_debug => sthr_debug_ec0ec3ec6,
--    sthr_ready_debug => sthr_ready_debug_ec0ec3ec6,
    --------------------------------------------------------------------------------------------------------
    nSigma128 => nSigma128,
    mp0     => mp0_ec0ec3ec6,
    mp1     => mp1_ec0ec3ec6,
    mp2     => mp2_ec0ec3ec6,
    mp3     => mp3_ec0ec3ec6,
    mp4     => mp4_ec0ec3ec6,
    mp5     => mp5_ec0ec3ec6,
    mp6     => mp6_ec0ec3ec6,
    mp7     => mp7_ec0ec3ec6,
    mp8     => mp8_ec0ec3ec6,
    mp9     => mp9_ec0ec3ec6,
    mp10    => mp10_ec0ec3ec6,
    mp11    => mp11_ec0ec3ec6,
    mp12    => mp12_ec0ec3ec6,
    mp13    => mp13_ec0ec3ec6,
    mp14    => mp14_ec0ec3ec6,
    mp15    => mp15_ec0ec3ec6,
    mp16    => mp16_ec0ec3ec6,
    mp17    => mp17_ec0ec3ec6,
    mp18    => mp18_ec0ec3ec6,
    mp19    => mp19_ec0ec3ec6,
    mp20    => mp20_ec0ec3ec6,
    mp21    => mp21_ec0ec3ec6,
    mp22    => mp22_ec0ec3ec6,
    mp23    => mp23_ec0ec3ec6,
    mp_ready    => mp_ready_ec0ec3ec6,
    mpsum0  => mpsum0_ec0ec3ec6,
    mpsum1  => mpsum1_ec0ec3ec6,
    mpsum2  => mpsum2_ec0ec3ec6,
    mpsum3  => mpsum3_ec0ec3ec6,
    mpsum4  => mpsum4_ec0ec3ec6,
    mpsum5  => mpsum5_ec0ec3ec6,
    mpsum6  => mpsum6_ec0ec3ec6,
    mpsum7  => mpsum7_ec0ec3ec6,
    mpsum8  => mpsum8_ec0ec3ec6,
    mpsum9  => mpsum9_ec0ec3ec6,
    mpsum10 => mpsum10_ec0ec3ec6,
    mpsum11 => mpsum11_ec0ec3ec6,
    mpsum12 => mpsum12_ec0ec3ec6,
    mpsum13 => mpsum13_ec0ec3ec6,
    mpsum14 => mpsum14_ec0ec3ec6,
    mpsum15 => mpsum15_ec0ec3ec6,
    mpsum16 => mpsum16_ec0ec3ec6,
    mpsum17 => mpsum17_ec0ec3ec6,
    mpsum18 => mpsum18_ec0ec3ec6,
    mpsum19 => mpsum19_ec0ec3ec6,
    mpsum20 => mpsum20_ec0ec3ec6,
    mpsum21 => mpsum21_ec0ec3ec6,
    mpsum22 => mpsum22_ec0ec3ec6,
    mpsum23 => mpsum23_ec0ec3ec6,
    mpsum_ready => mpsum_ready_ec0ec3ec6,
    bmp_c   => bmp_c_ec0ec3ec6,--Binary-macropixel column
    bmp_ready   => bmp_ready_ec0ec3ec6,
    MPSthr  => MPSthr
);

MACROPIXEL_CHECK_EC1EC4EC7 : MACROPIXEL_CHECK
PORT MAP (
    clock   => CLOCK,
    ----------------------STHR DEBUG------------------------------------------------------------------------
--    sthr_debug => sthr_debug_ec1ec4ec7,
--    sthr_ready_debug => sthr_ready_debug_ec1ec4ec7,
    --------------------------------------------------------------------------------------------------------
    nSigma128 => nSigma128,
    mp0     => mp0_ec1ec4ec7,
    mp1     => mp1_ec1ec4ec7,
    mp2     => mp2_ec1ec4ec7,
    mp3     => mp3_ec1ec4ec7,
    mp4     => mp4_ec1ec4ec7,
    mp5     => mp5_ec1ec4ec7,
    mp6     => mp6_ec1ec4ec7,
    mp7     => mp7_ec1ec4ec7,
    mp8     => mp8_ec1ec4ec7,
    mp9     => mp9_ec1ec4ec7,
    mp10    => mp10_ec1ec4ec7,
    mp11    => mp11_ec1ec4ec7,
    mp12    => mp12_ec1ec4ec7,
    mp13    => mp13_ec1ec4ec7,
    mp14    => mp14_ec1ec4ec7,
    mp15    => mp15_ec1ec4ec7,
    mp16    => mp16_ec1ec4ec7,
    mp17    => mp17_ec1ec4ec7,
    mp18    => mp18_ec1ec4ec7,
    mp19    => mp19_ec1ec4ec7,
    mp20    => mp20_ec1ec4ec7,
    mp21    => mp21_ec1ec4ec7,
    mp22    => mp22_ec1ec4ec7,
    mp23    => mp23_ec1ec4ec7,
    mp_ready    => mp_ready_ec1ec4ec7,
    mpsum0  => mpsum0_ec1ec4ec7,
    mpsum1  => mpsum1_ec1ec4ec7,
    mpsum2  => mpsum2_ec1ec4ec7,
    mpsum3  => mpsum3_ec1ec4ec7,
    mpsum4  => mpsum4_ec1ec4ec7,
    mpsum5  => mpsum5_ec1ec4ec7,
    mpsum6  => mpsum6_ec1ec4ec7,
    mpsum7  => mpsum7_ec1ec4ec7,
    mpsum8  => mpsum8_ec1ec4ec7,
    mpsum9  => mpsum9_ec1ec4ec7,
    mpsum10 => mpsum10_ec1ec4ec7,
    mpsum11 => mpsum11_ec1ec4ec7,
    mpsum12 => mpsum12_ec1ec4ec7,
    mpsum13 => mpsum13_ec1ec4ec7,
    mpsum14 => mpsum14_ec1ec4ec7,
    mpsum15 => mpsum15_ec1ec4ec7,
    mpsum16 => mpsum16_ec1ec4ec7,
    mpsum17 => mpsum17_ec1ec4ec7,
    mpsum18 => mpsum18_ec1ec4ec7,
    mpsum19 => mpsum19_ec1ec4ec7,
    mpsum20 => mpsum20_ec1ec4ec7,
    mpsum21 => mpsum21_ec1ec4ec7,
    mpsum22 => mpsum22_ec1ec4ec7,
    mpsum23 => mpsum23_ec1ec4ec7,
    mpsum_ready => mpsum_ready_ec1ec4ec7,
    bmp_c   => bmp_c_ec1ec4ec7,--Binary-macropixel column
    bmp_ready   => bmp_ready_ec1ec4ec7,
    MPSthr  => MPSthr
);

MACROPIXEL_CHECK_EC2EC5EC8 : MACROPIXEL_CHECK
PORT MAP (
    clock   => CLOCK,
    ----------------------STHR DEBUG------------------------------------------------------------------------
--    sthr_debug => sthr_debug_ec2ec5ec8,
--    sthr_ready_debug => sthr_ready_debug_ec2ec5ec8,
    --------------------------------------------------------------------------------------------------------
    nSigma128 => nSigma128,
    mp0     => mp0_ec2ec5ec8,
    mp1     => mp1_ec2ec5ec8,
    mp2     => mp2_ec2ec5ec8,
    mp3     => mp3_ec2ec5ec8,
    mp4     => mp4_ec2ec5ec8,
    mp5     => mp5_ec2ec5ec8,
    mp6     => mp6_ec2ec5ec8,
    mp7     => mp7_ec2ec5ec8,
    mp8     => mp8_ec2ec5ec8,
    mp9     => mp9_ec2ec5ec8,
    mp10    => mp10_ec2ec5ec8,
    mp11    => mp11_ec2ec5ec8,
    mp12    => mp12_ec2ec5ec8,
    mp13    => mp13_ec2ec5ec8,
    mp14    => mp14_ec2ec5ec8,
    mp15    => mp15_ec2ec5ec8,
    mp16    => mp16_ec2ec5ec8,
    mp17    => mp17_ec2ec5ec8,
    mp18    => mp18_ec2ec5ec8,
    mp19    => mp19_ec2ec5ec8,
    mp20    => mp20_ec2ec5ec8,
    mp21    => mp21_ec2ec5ec8,
    mp22    => mp22_ec2ec5ec8,
    mp23    => mp23_ec2ec5ec8,
    mp_ready    => mp_ready_ec2ec5ec8,
    mpsum0  => mpsum0_ec2ec5ec8,
    mpsum1  => mpsum1_ec2ec5ec8,
    mpsum2  => mpsum2_ec2ec5ec8,
    mpsum3  => mpsum3_ec2ec5ec8,
    mpsum4  => mpsum4_ec2ec5ec8,
    mpsum5  => mpsum5_ec2ec5ec8,
    mpsum6  => mpsum6_ec2ec5ec8,
    mpsum7  => mpsum7_ec2ec5ec8,
    mpsum8  => mpsum8_ec2ec5ec8,
    mpsum9  => mpsum9_ec2ec5ec8,
    mpsum10 => mpsum10_ec2ec5ec8,
    mpsum11 => mpsum11_ec2ec5ec8,
    mpsum12 => mpsum12_ec2ec5ec8,
    mpsum13 => mpsum13_ec2ec5ec8,
    mpsum14 => mpsum14_ec2ec5ec8,
    mpsum15 => mpsum15_ec2ec5ec8,
    mpsum16 => mpsum16_ec2ec5ec8,
    mpsum17 => mpsum17_ec2ec5ec8,
    mpsum18 => mpsum18_ec2ec5ec8,
    mpsum19 => mpsum19_ec2ec5ec8,
    mpsum20 => mpsum20_ec2ec5ec8,
    mpsum21 => mpsum21_ec2ec5ec8,
    mpsum22 => mpsum22_ec2ec5ec8,
    mpsum23 => mpsum23_ec2ec5ec8,
    mpsum_ready => mpsum_ready_ec2ec5ec8,
    bmp_c   => bmp_c_ec2ec5ec8,--Binary-macropixel column
    bmp_ready   => bmp_ready_ec2ec5ec8,
    MPSthr  => MPSthr
);

MACROCELL_3x1_EC0EC3EC6 : MACROCELL_3x1
PORT MAP (
    clock       => CLOCK,
    bmp_c       => bmp_c_ec0ec3ec6,
    bmp_ready   => bmp_ready_ec0ec3ec6,
    mc3x1_0     => mc3x1_0_ec0ec3ec6,
    mc3x1_1     => mc3x1_1_ec0ec3ec6,
    mc3x1_2     => mc3x1_2_ec0ec3ec6,
    mc3x1_3     => mc3x1_3_ec0ec3ec6,
    mc3x1_4     => mc3x1_4_ec0ec3ec6,
    mc3x1_5     => mc3x1_5_ec0ec3ec6,
    mc3x1_6     => mc3x1_6_ec0ec3ec6,
    mc3x1_7     => mc3x1_7_ec0ec3ec6,
    mc3x1_8     => mc3x1_8_ec0ec3ec6,
    mc3x1_9     => mc3x1_9_ec0ec3ec6,
    mc3x1_10    => mc3x1_10_ec0ec3ec6,
    mc3x1_11    => mc3x1_11_ec0ec3ec6,
    mc3x1_12    => mc3x1_12_ec0ec3ec6,
    mc3x1_13    => mc3x1_13_ec0ec3ec6,
    mc3x1_14    => mc3x1_14_ec0ec3ec6,
    mc3x1_15    => mc3x1_15_ec0ec3ec6,
    mc3x1_16    => mc3x1_16_ec0ec3ec6,
    mc3x1_17    => mc3x1_17_ec0ec3ec6,
    mc3x1_18    => mc3x1_18_ec0ec3ec6,
    mc3x1_19    => mc3x1_19_ec0ec3ec6,
    mc3x1_20    => mc3x1_20_ec0ec3ec6,
    mc3x1_21    => mc3x1_21_ec0ec3ec6,
    mc3x1_ready => mc3x1_ready_ec0ec3ec6
);

MACROCELL_3x1_EC1EC4EC7 : MACROCELL_3x1
PORT MAP (
    clock       => CLOCK,
    bmp_c       => bmp_c_ec1ec4ec7,
    bmp_ready   => bmp_ready_ec1ec4ec7,
    mc3x1_0     => mc3x1_0_ec1ec4ec7,
    mc3x1_1     => mc3x1_1_ec1ec4ec7,
    mc3x1_2     => mc3x1_2_ec1ec4ec7,
    mc3x1_3     => mc3x1_3_ec1ec4ec7,
    mc3x1_4     => mc3x1_4_ec1ec4ec7,
    mc3x1_5     => mc3x1_5_ec1ec4ec7,
    mc3x1_6     => mc3x1_6_ec1ec4ec7,
    mc3x1_7     => mc3x1_7_ec1ec4ec7,
    mc3x1_8     => mc3x1_8_ec1ec4ec7,
    mc3x1_9     => mc3x1_9_ec1ec4ec7,
    mc3x1_10    => mc3x1_10_ec1ec4ec7,
    mc3x1_11    => mc3x1_11_ec1ec4ec7,
    mc3x1_12    => mc3x1_12_ec1ec4ec7,
    mc3x1_13    => mc3x1_13_ec1ec4ec7,
    mc3x1_14    => mc3x1_14_ec1ec4ec7,
    mc3x1_15    => mc3x1_15_ec1ec4ec7,
    mc3x1_16    => mc3x1_16_ec1ec4ec7,
    mc3x1_17    => mc3x1_17_ec1ec4ec7,
    mc3x1_18    => mc3x1_18_ec1ec4ec7,
    mc3x1_19    => mc3x1_19_ec1ec4ec7,
    mc3x1_20    => mc3x1_20_ec1ec4ec7,
    mc3x1_21    => mc3x1_21_ec1ec4ec7,
    mc3x1_ready => mc3x1_ready_ec1ec4ec7
);

MACROCELL_3x1_EC2EC5EC8 : MACROCELL_3x1
PORT MAP (
    clock       => CLOCK,
    bmp_c       => bmp_c_ec2ec5ec8,
    bmp_ready   => bmp_ready_ec2ec5ec8,
    mc3x1_0     => mc3x1_0_ec2ec5ec8,
    mc3x1_1     => mc3x1_1_ec2ec5ec8,
    mc3x1_2     => mc3x1_2_ec2ec5ec8,
    mc3x1_3     => mc3x1_3_ec2ec5ec8,
    mc3x1_4     => mc3x1_4_ec2ec5ec8,
    mc3x1_5     => mc3x1_5_ec2ec5ec8,
    mc3x1_6     => mc3x1_6_ec2ec5ec8,
    mc3x1_7     => mc3x1_7_ec2ec5ec8,
    mc3x1_8     => mc3x1_8_ec2ec5ec8,
    mc3x1_9     => mc3x1_9_ec2ec5ec8,
    mc3x1_10    => mc3x1_10_ec2ec5ec8,
    mc3x1_11    => mc3x1_11_ec2ec5ec8,
    mc3x1_12    => mc3x1_12_ec2ec5ec8,
    mc3x1_13    => mc3x1_13_ec2ec5ec8,
    mc3x1_14    => mc3x1_14_ec2ec5ec8,
    mc3x1_15    => mc3x1_15_ec2ec5ec8,
    mc3x1_16    => mc3x1_16_ec2ec5ec8,
    mc3x1_17    => mc3x1_17_ec2ec5ec8,
    mc3x1_18    => mc3x1_18_ec2ec5ec8,
    mc3x1_19    => mc3x1_19_ec2ec5ec8,
    mc3x1_20    => mc3x1_20_ec2ec5ec8,
    mc3x1_21    => mc3x1_21_ec2ec5ec8,
    mc3x1_ready => mc3x1_ready_ec2ec5ec8
);

ACCUM_B0_0_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b0_0_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec0ec3ec6,
    SCLR    =>  sclr0_ec0ec3ec6,
    Q       =>  mc0_0_ec0ec3ec6--Row0
);
ACCUM_B0_1_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b0_1_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec0ec3ec6,
    SCLR    =>  sclr0_ec0ec3ec6,
    Q       =>  mc0_1_ec0ec3ec6--Row1
);

ACCUM_B0_2_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b0_2_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec0ec3ec6,
    SCLR    =>  sclr0_ec0ec3ec6,
    Q       =>  mc0_2_ec0ec3ec6--Row2
);
ACCUM_B0_3_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b0_3_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec0ec3ec6,
    SCLR    =>  sclr0_ec0ec3ec6,
    Q       =>  mc0_3_ec0ec3ec6--Row3
);
ACCUM_B0_4_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b0_4_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec0ec3ec6,
    SCLR    =>  sclr0_ec0ec3ec6,
    Q       =>  mc0_4_ec0ec3ec6--Row4
);
ACCUM_B0_5_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b0_5_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec0ec3ec6,
    SCLR    =>  sclr0_ec0ec3ec6,
    Q       =>  mc0_5_ec0ec3ec6--Row5
);
ACCUM_B0_6_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b0_6_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec0ec3ec6,
    SCLR    =>  sclr0_ec0ec3ec6,
    Q       =>  mc0_6_ec0ec3ec6--Row6
);
ACCUM_B0_7_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b0_7_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec0ec3ec6,
    SCLR    =>  sclr0_ec0ec3ec6,
    Q       =>  mc0_7_ec0ec3ec6--Row7
);
ACCUM_B0_8_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b0_8_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec0ec3ec6,
    SCLR    =>  sclr0_ec0ec3ec6,
    Q       =>  mc0_8_ec0ec3ec6--Row8
);
ACCUM_B0_9_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b0_9_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec0ec3ec6,
    SCLR    =>  sclr0_ec0ec3ec6,
    Q       =>  mc0_9_ec0ec3ec6--Row9
);
ACCUM_B0_10_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b0_10_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec0ec3ec6,
    SCLR    =>  sclr0_ec0ec3ec6,
    Q       =>  mc0_10_ec0ec3ec6--Row10
);
ACCUM_B0_11_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b0_11_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec0ec3ec6,
    SCLR    =>  sclr0_ec0ec3ec6,
    Q       =>  mc0_11_ec0ec3ec6--Row11
);
ACCUM_B0_12_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b0_12_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec0ec3ec6,
    SCLR    =>  sclr0_ec0ec3ec6,
    Q       =>  mc0_12_ec0ec3ec6--Row12
);
ACCUM_B0_13_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b0_13_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec0ec3ec6,
    SCLR    =>  sclr0_ec0ec3ec6,
    Q       =>  mc0_13_ec0ec3ec6--Row13
);
ACCUM_B0_14_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b0_14_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec0ec3ec6,
    SCLR    =>  sclr0_ec0ec3ec6,
    Q       =>  mc0_14_ec0ec3ec6--Row14
);
ACCUM_B0_15_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b0_15_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec0ec3ec6,
    SCLR    =>  sclr0_ec0ec3ec6,
    Q       =>  mc0_15_ec0ec3ec6--Row15
);
ACCUM_B0_16_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b0_16_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec0ec3ec6,
    SCLR    =>  sclr0_ec0ec3ec6,
    Q       =>  mc0_16_ec0ec3ec6--Row16
);
ACCUM_B0_17_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b0_17_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec0ec3ec6,
    SCLR    =>  sclr0_ec0ec3ec6,
    Q       =>  mc0_17_ec0ec3ec6--Row17
);
ACCUM_B0_18_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b0_18_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec0ec3ec6,
    SCLR    =>  sclr0_ec0ec3ec6,
    Q       =>  mc0_18_ec0ec3ec6--Row18
);
ACCUM_B0_19_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b0_19_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec0ec3ec6,
    SCLR    =>  sclr0_ec0ec3ec6,
    Q       =>  mc0_19_ec0ec3ec6--Row19
);
ACCUM_B0_20_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b0_20_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec0ec3ec6,
    SCLR    =>  sclr0_ec0ec3ec6,
    Q       =>  mc0_20_ec0ec3ec6--Row20
);
ACCUM_B0_21_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b0_21_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec0ec3ec6,
    SCLR    =>  sclr0_ec0ec3ec6,
    Q       =>  mc0_21_ec0ec3ec6--Row21
);

ACCUM_B1_0_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b1_0_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec0ec3ec6,
    SCLR    =>  sclr1_ec0ec3ec6,
    Q       =>  mc1_0_ec0ec3ec6--Row0
);
ACCUM_B1_1_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b1_1_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec0ec3ec6,
    SCLR    =>  sclr1_ec0ec3ec6,
    Q       =>  mc1_1_ec0ec3ec6--Row1
);
ACCUM_B1_2_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b1_2_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec0ec3ec6,
    SCLR    =>  sclr1_ec0ec3ec6,
    Q       =>  mc1_2_ec0ec3ec6--Row2
);
ACCUM_B1_3_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b1_3_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec0ec3ec6,
    SCLR    =>  sclr1_ec0ec3ec6,
    Q       =>  mc1_3_ec0ec3ec6--Row3
);
ACCUM_B1_4_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b1_4_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec0ec3ec6,
    SCLR    =>  sclr1_ec0ec3ec6,
    Q       =>  mc1_4_ec0ec3ec6--Row4
);
ACCUM_B1_5_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b1_5_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec0ec3ec6,
    SCLR    =>  sclr1_ec0ec3ec6,
    Q       =>  mc1_5_ec0ec3ec6--Row5
);
ACCUM_B1_6_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b1_6_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec0ec3ec6,
    SCLR    =>  sclr1_ec0ec3ec6,
    Q       =>  mc1_6_ec0ec3ec6--Row6
);
ACCUM_B1_7_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b1_7_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec0ec3ec6,
    SCLR    =>  sclr1_ec0ec3ec6,
    Q       =>  mc1_7_ec0ec3ec6--Row7
);
ACCUM_B1_8_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b1_8_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec0ec3ec6,
    SCLR    =>  sclr1_ec0ec3ec6,
    Q       =>  mc1_8_ec0ec3ec6--Row8
);
ACCUM_B1_9_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b1_9_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec0ec3ec6,
    SCLR    =>  sclr1_ec0ec3ec6,
    Q       =>  mc1_9_ec0ec3ec6--Row9
);
ACCUM_B1_10_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b1_10_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec0ec3ec6,
    SCLR    =>  sclr1_ec0ec3ec6,
    Q       =>  mc1_10_ec0ec3ec6--Row10
);
ACCUM_B1_11_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b1_11_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec0ec3ec6,
    SCLR    =>  sclr1_ec0ec3ec6,
    Q       =>  mc1_11_ec0ec3ec6--Row11
);
ACCUM_B1_12_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b1_12_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec0ec3ec6,
    SCLR    =>  sclr1_ec0ec3ec6,
    Q       =>  mc1_12_ec0ec3ec6--Row12
);
ACCUM_B1_13_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b1_13_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec0ec3ec6,
    SCLR    =>  sclr1_ec0ec3ec6,
    Q       =>  mc1_13_ec0ec3ec6--Row13
);
ACCUM_B1_14_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b1_14_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec0ec3ec6,
    SCLR    =>  sclr1_ec0ec3ec6,
    Q       =>  mc1_14_ec0ec3ec6--Row14
);
ACCUM_B1_15_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b1_15_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec0ec3ec6,
    SCLR    =>  sclr1_ec0ec3ec6,
    Q       =>  mc1_15_ec0ec3ec6--Row15
);
ACCUM_B1_16_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b1_16_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec0ec3ec6,
    SCLR    =>  sclr1_ec0ec3ec6,
    Q       =>  mc1_16_ec0ec3ec6--Row16
);
ACCUM_B1_17_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b1_17_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec0ec3ec6,
    SCLR    =>  sclr1_ec0ec3ec6,
    Q       =>  mc1_17_ec0ec3ec6--Row17
);
ACCUM_B1_18_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b1_18_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec0ec3ec6,
    SCLR    =>  sclr1_ec0ec3ec6,
    Q       =>  mc1_18_ec0ec3ec6--Row18
);
ACCUM_B1_19_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b1_19_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec0ec3ec6,
    SCLR    =>  sclr1_ec0ec3ec6,
    Q       =>  mc1_19_ec0ec3ec6--Row19
);
ACCUM_B1_20_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b1_20_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec0ec3ec6,
    SCLR    =>  sclr1_ec0ec3ec6,
    Q       =>  mc1_20_ec0ec3ec6--Row20
);
ACCUM_B1_21_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b1_21_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec0ec3ec6,
    SCLR    =>  sclr1_ec0ec3ec6,
    Q       =>  mc1_21_ec0ec3ec6--Row21
);

ACCUM_B2_0_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b2_0_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec0ec3ec6,
    SCLR    =>  sclr2_ec0ec3ec6,
    Q       =>  mc2_0_ec0ec3ec6--Row0
);
ACCUM_B2_1_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b2_1_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec0ec3ec6,
    SCLR    =>  sclr2_ec0ec3ec6,
    Q       =>  mc2_1_ec0ec3ec6--Row1
);
ACCUM_B2_2_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b2_2_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec0ec3ec6,
    SCLR    =>  sclr2_ec0ec3ec6,
    Q       =>  mc2_2_ec0ec3ec6--Row2
);
ACCUM_B2_3_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b2_3_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec0ec3ec6,
    SCLR    =>  sclr2_ec0ec3ec6,
    Q       =>  mc2_3_ec0ec3ec6--Row3
);
ACCUM_B2_4_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b2_4_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec0ec3ec6,
    SCLR    =>  sclr2_ec0ec3ec6,
    Q       =>  mc2_4_ec0ec3ec6--Row4
);
ACCUM_B2_5_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b2_5_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec0ec3ec6,
    SCLR    =>  sclr2_ec0ec3ec6,
    Q       =>  mc2_5_ec0ec3ec6--Row5
);
ACCUM_B2_6_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b2_6_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec0ec3ec6,
    SCLR    =>  sclr2_ec0ec3ec6,
    Q       =>  mc2_6_ec0ec3ec6--Row6
);
ACCUM_B2_7_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b2_7_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec0ec3ec6,
    SCLR    =>  sclr2_ec0ec3ec6,
    Q       =>  mc2_7_ec0ec3ec6--Row7
);
ACCUM_B2_8_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b2_8_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec0ec3ec6,
    SCLR    =>  sclr2_ec0ec3ec6,
    Q       =>  mc2_8_ec0ec3ec6--Row8
);
ACCUM_B2_9_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b2_9_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec0ec3ec6,
    SCLR    =>  sclr2_ec0ec3ec6,
    Q       =>  mc2_9_ec0ec3ec6--Row9
);
ACCUM_B2_10_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b2_10_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec0ec3ec6,
    SCLR    =>  sclr2_ec0ec3ec6,
    Q       =>  mc2_10_ec0ec3ec6--Row10
);
ACCUM_B2_11_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b2_11_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec0ec3ec6,
    SCLR    =>  sclr2_ec0ec3ec6,
    Q       =>  mc2_11_ec0ec3ec6--Row11
);
ACCUM_B2_12_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b2_12_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec0ec3ec6,
    SCLR    =>  sclr2_ec0ec3ec6,
    Q       =>  mc2_12_ec0ec3ec6--Row12
);
ACCUM_B2_13_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b2_13_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec0ec3ec6,
    SCLR    =>  sclr2_ec0ec3ec6,
    Q       =>  mc2_13_ec0ec3ec6--Row13
);
ACCUM_B2_14_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b2_14_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec0ec3ec6,
    SCLR    =>  sclr2_ec0ec3ec6,
    Q       =>  mc2_14_ec0ec3ec6--Row14
);
ACCUM_B2_15_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b2_15_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec0ec3ec6,
    SCLR    =>  sclr2_ec0ec3ec6,
    Q       =>  mc2_15_ec0ec3ec6--Row15
);
ACCUM_B2_16_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b2_16_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec0ec3ec6,
    SCLR    =>  sclr2_ec0ec3ec6,
    Q       =>  mc2_16_ec0ec3ec6--Row16
);
ACCUM_B2_17_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b2_17_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec0ec3ec6,
    SCLR    =>  sclr2_ec0ec3ec6,
    Q       =>  mc2_17_ec0ec3ec6--Row17
);
ACCUM_B2_18_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b2_18_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec0ec3ec6,
    SCLR    =>  sclr2_ec0ec3ec6,
    Q       =>  mc2_18_ec0ec3ec6--Row18
);
ACCUM_B2_19_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b2_19_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec0ec3ec6,
    SCLR    =>  sclr2_ec0ec3ec6,
    Q       =>  mc2_19_ec0ec3ec6--Row19
);
ACCUM_B2_20_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b2_20_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec0ec3ec6,
    SCLR    =>  sclr2_ec0ec3ec6,
    Q       =>  mc2_20_ec0ec3ec6--Row20
);
ACCUM_B2_21_EC0EC3EC6 : accum_2_4
PORT MAP(
    B       =>  b2_21_ec0ec3ec6,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec0ec3ec6,
    SCLR    =>  sclr2_ec0ec3ec6,
    Q       =>  mc2_21_ec0ec3ec6--Row21
);

ACCUM_B0_0_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b0_0_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec1ec4ec7,
    SCLR    =>  sclr0_ec1ec4ec7,
    Q       =>  mc0_0_ec1ec4ec7--Row0
);
ACCUM_B0_1_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b0_1_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec1ec4ec7,
    SCLR    =>  sclr0_ec1ec4ec7,
    Q       =>  mc0_1_ec1ec4ec7--Row1
);

ACCUM_B0_2_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b0_2_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec1ec4ec7,
    SCLR    =>  sclr0_ec1ec4ec7,
    Q       =>  mc0_2_ec1ec4ec7--Row2
);
ACCUM_B0_3_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b0_3_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec1ec4ec7,
    SCLR    =>  sclr0_ec1ec4ec7,
    Q       =>  mc0_3_ec1ec4ec7--Row3
);
ACCUM_B0_4_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b0_4_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec1ec4ec7,
    SCLR    =>  sclr0_ec1ec4ec7,
    Q       =>  mc0_4_ec1ec4ec7--Row4
);
ACCUM_B0_5_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b0_5_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec1ec4ec7,
    SCLR    =>  sclr0_ec1ec4ec7,
    Q       =>  mc0_5_ec1ec4ec7--Row5
);
ACCUM_B0_6_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b0_6_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec1ec4ec7,
    SCLR    =>  sclr0_ec1ec4ec7,
    Q       =>  mc0_6_ec1ec4ec7--Row6
);
ACCUM_B0_7_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b0_7_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec1ec4ec7,
    SCLR    =>  sclr0_ec1ec4ec7,
    Q       =>  mc0_7_ec1ec4ec7--Row7
);
ACCUM_B0_8_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b0_8_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec1ec4ec7,
    SCLR    =>  sclr0_ec1ec4ec7,
    Q       =>  mc0_8_ec1ec4ec7--Row8
);
ACCUM_B0_9_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b0_9_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec1ec4ec7,
    SCLR    =>  sclr0_ec1ec4ec7,
    Q       =>  mc0_9_ec1ec4ec7--Row9
);
ACCUM_B0_10_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b0_10_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec1ec4ec7,
    SCLR    =>  sclr0_ec1ec4ec7,
    Q       =>  mc0_10_ec1ec4ec7--Row10
);
ACCUM_B0_11_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b0_11_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec1ec4ec7,
    SCLR    =>  sclr0_ec1ec4ec7,
    Q       =>  mc0_11_ec1ec4ec7--Row11
);
ACCUM_B0_12_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b0_12_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec1ec4ec7,
    SCLR    =>  sclr0_ec1ec4ec7,
    Q       =>  mc0_12_ec1ec4ec7--Row12
);
ACCUM_B0_13_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b0_13_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec1ec4ec7,
    SCLR    =>  sclr0_ec1ec4ec7,
    Q       =>  mc0_13_ec1ec4ec7--Row13
);
ACCUM_B0_14_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b0_14_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec1ec4ec7,
    SCLR    =>  sclr0_ec1ec4ec7,
    Q       =>  mc0_14_ec1ec4ec7--Row14
);
ACCUM_B0_15_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b0_15_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec1ec4ec7,
    SCLR    =>  sclr0_ec1ec4ec7,
    Q       =>  mc0_15_ec1ec4ec7--Row15
);
ACCUM_B0_16_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b0_16_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec1ec4ec7,
    SCLR    =>  sclr0_ec1ec4ec7,
    Q       =>  mc0_16_ec1ec4ec7--Row16
);
ACCUM_B0_17_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b0_17_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec1ec4ec7,
    SCLR    =>  sclr0_ec1ec4ec7,
    Q       =>  mc0_17_ec1ec4ec7--Row17
);
ACCUM_B0_18_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b0_18_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec1ec4ec7,
    SCLR    =>  sclr0_ec1ec4ec7,
    Q       =>  mc0_18_ec1ec4ec7--Row18
);
ACCUM_B0_19_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b0_19_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec1ec4ec7,
    SCLR    =>  sclr0_ec1ec4ec7,
    Q       =>  mc0_19_ec1ec4ec7--Row19
);
ACCUM_B0_20_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b0_20_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec1ec4ec7,
    SCLR    =>  sclr0_ec1ec4ec7,
    Q       =>  mc0_20_ec1ec4ec7--Row20
);
ACCUM_B0_21_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b0_21_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec1ec4ec7,
    SCLR    =>  sclr0_ec1ec4ec7,
    Q       =>  mc0_21_ec1ec4ec7--Row21
);

ACCUM_B1_0_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b1_0_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec1ec4ec7,
    SCLR    =>  sclr1_ec1ec4ec7,
    Q       =>  mc1_0_ec1ec4ec7--Row0
);
ACCUM_B1_1_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b1_1_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec1ec4ec7,
    SCLR    =>  sclr1_ec1ec4ec7,
    Q       =>  mc1_1_ec1ec4ec7--Row1
);
ACCUM_B1_2_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b1_2_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec1ec4ec7,
    SCLR    =>  sclr1_ec1ec4ec7,
    Q       =>  mc1_2_ec1ec4ec7--Row2
);
ACCUM_B1_3_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b1_3_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec1ec4ec7,
    SCLR    =>  sclr1_ec1ec4ec7,
    Q       =>  mc1_3_ec1ec4ec7--Row3
);
ACCUM_B1_4_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b1_4_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec1ec4ec7,
    SCLR    =>  sclr1_ec1ec4ec7,
    Q       =>  mc1_4_ec1ec4ec7--Row4
);
ACCUM_B1_5_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b1_5_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec1ec4ec7,
    SCLR    =>  sclr1_ec1ec4ec7,
    Q       =>  mc1_5_ec1ec4ec7--Row5
);
ACCUM_B1_6_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b1_6_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec1ec4ec7,
    SCLR    =>  sclr1_ec1ec4ec7,
    Q       =>  mc1_6_ec1ec4ec7--Row6
);
ACCUM_B1_7_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b1_7_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec1ec4ec7,
    SCLR    =>  sclr1_ec1ec4ec7,
    Q       =>  mc1_7_ec1ec4ec7--Row7
);
ACCUM_B1_8_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b1_8_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec1ec4ec7,
    SCLR    =>  sclr1_ec1ec4ec7,
    Q       =>  mc1_8_ec1ec4ec7--Row8
);
ACCUM_B1_9_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b1_9_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec1ec4ec7,
    SCLR    =>  sclr1_ec1ec4ec7,
    Q       =>  mc1_9_ec1ec4ec7--Row9
);
ACCUM_B1_10_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b1_10_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec1ec4ec7,
    SCLR    =>  sclr1_ec1ec4ec7,
    Q       =>  mc1_10_ec1ec4ec7--Row10
);
ACCUM_B1_11_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b1_11_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec1ec4ec7,
    SCLR    =>  sclr1_ec1ec4ec7,
    Q       =>  mc1_11_ec1ec4ec7--Row11
);
ACCUM_B1_12_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b1_12_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec1ec4ec7,
    SCLR    =>  sclr1_ec1ec4ec7,
    Q       =>  mc1_12_ec1ec4ec7--Row12
);
ACCUM_B1_13_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b1_13_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec1ec4ec7,
    SCLR    =>  sclr1_ec1ec4ec7,
    Q       =>  mc1_13_ec1ec4ec7--Row13
);
ACCUM_B1_14_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b1_14_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec1ec4ec7,
    SCLR    =>  sclr1_ec1ec4ec7,
    Q       =>  mc1_14_ec1ec4ec7--Row14
);
ACCUM_B1_15_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b1_15_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec1ec4ec7,
    SCLR    =>  sclr1_ec1ec4ec7,
    Q       =>  mc1_15_ec1ec4ec7--Row15
);
ACCUM_B1_16_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b1_16_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec1ec4ec7,
    SCLR    =>  sclr1_ec1ec4ec7,
    Q       =>  mc1_16_ec1ec4ec7--Row16
);
ACCUM_B1_17_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b1_17_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec1ec4ec7,
    SCLR    =>  sclr1_ec1ec4ec7,
    Q       =>  mc1_17_ec1ec4ec7--Row17
);
ACCUM_B1_18_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b1_18_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec1ec4ec7,
    SCLR    =>  sclr1_ec1ec4ec7,
    Q       =>  mc1_18_ec1ec4ec7--Row18
);
ACCUM_B1_19_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b1_19_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec1ec4ec7,
    SCLR    =>  sclr1_ec1ec4ec7,
    Q       =>  mc1_19_ec1ec4ec7--Row19
);
ACCUM_B1_20_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b1_20_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec1ec4ec7,
    SCLR    =>  sclr1_ec1ec4ec7,
    Q       =>  mc1_20_ec1ec4ec7--Row20
);
ACCUM_B1_21_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b1_21_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec1ec4ec7,
    SCLR    =>  sclr1_ec1ec4ec7,
    Q       =>  mc1_21_ec1ec4ec7--Row21
);

ACCUM_B2_0_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b2_0_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec1ec4ec7,
    SCLR    =>  sclr2_ec1ec4ec7,
    Q       =>  mc2_0_ec1ec4ec7--Row0
);
ACCUM_B2_1_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b2_1_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec1ec4ec7,
    SCLR    =>  sclr2_ec1ec4ec7,
    Q       =>  mc2_1_ec1ec4ec7--Row1
);
ACCUM_B2_2_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b2_2_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec1ec4ec7,
    SCLR    =>  sclr2_ec1ec4ec7,
    Q       =>  mc2_2_ec1ec4ec7--Row2
);
ACCUM_B2_3_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b2_3_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec1ec4ec7,
    SCLR    =>  sclr2_ec1ec4ec7,
    Q       =>  mc2_3_ec1ec4ec7--Row3
);
ACCUM_B2_4_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b2_4_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec1ec4ec7,
    SCLR    =>  sclr2_ec1ec4ec7,
    Q       =>  mc2_4_ec1ec4ec7--Row4
);
ACCUM_B2_5_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b2_5_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec1ec4ec7,
    SCLR    =>  sclr2_ec1ec4ec7,
    Q       =>  mc2_5_ec1ec4ec7--Row5
);
ACCUM_B2_6_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b2_6_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec1ec4ec7,
    SCLR    =>  sclr2_ec1ec4ec7,
    Q       =>  mc2_6_ec1ec4ec7--Row6
);
ACCUM_B2_7_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b2_7_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec1ec4ec7,
    SCLR    =>  sclr2_ec1ec4ec7,
    Q       =>  mc2_7_ec1ec4ec7--Row7
);
ACCUM_B2_8_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b2_8_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec1ec4ec7,
    SCLR    =>  sclr2_ec1ec4ec7,
    Q       =>  mc2_8_ec1ec4ec7--Row8
);
ACCUM_B2_9_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b2_9_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec1ec4ec7,
    SCLR    =>  sclr2_ec1ec4ec7,
    Q       =>  mc2_9_ec1ec4ec7--Row9
);
ACCUM_B2_10_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b2_10_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec1ec4ec7,
    SCLR    =>  sclr2_ec1ec4ec7,
    Q       =>  mc2_10_ec1ec4ec7--Row10
);
ACCUM_B2_11_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b2_11_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec1ec4ec7,
    SCLR    =>  sclr2_ec1ec4ec7,
    Q       =>  mc2_11_ec1ec4ec7--Row11
);
ACCUM_B2_12_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b2_12_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec1ec4ec7,
    SCLR    =>  sclr2_ec1ec4ec7,
    Q       =>  mc2_12_ec1ec4ec7--Row12
);
ACCUM_B2_13_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b2_13_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec1ec4ec7,
    SCLR    =>  sclr2_ec1ec4ec7,
    Q       =>  mc2_13_ec1ec4ec7--Row13
);
ACCUM_B2_14_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b2_14_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec1ec4ec7,
    SCLR    =>  sclr2_ec1ec4ec7,
    Q       =>  mc2_14_ec1ec4ec7--Row14
);
ACCUM_B2_15_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b2_15_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec1ec4ec7,
    SCLR    =>  sclr2_ec1ec4ec7,
    Q       =>  mc2_15_ec1ec4ec7--Row15
);
ACCUM_B2_16_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b2_16_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec1ec4ec7,
    SCLR    =>  sclr2_ec1ec4ec7,
    Q       =>  mc2_16_ec1ec4ec7--Row16
);
ACCUM_B2_17_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b2_17_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec1ec4ec7,
    SCLR    =>  sclr2_ec1ec4ec7,
    Q       =>  mc2_17_ec1ec4ec7--Row17
);
ACCUM_B2_18_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b2_18_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec1ec4ec7,
    SCLR    =>  sclr2_ec1ec4ec7,
    Q       =>  mc2_18_ec1ec4ec7--Row18
);
ACCUM_B2_19_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b2_19_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec1ec4ec7,
    SCLR    =>  sclr2_ec1ec4ec7,
    Q       =>  mc2_19_ec1ec4ec7--Row19
);
ACCUM_B2_20_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b2_20_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec1ec4ec7,
    SCLR    =>  sclr2_ec1ec4ec7,
    Q       =>  mc2_20_ec1ec4ec7--Row20
);
ACCUM_B2_21_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b2_21_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec1ec4ec7,
    SCLR    =>  sclr2_ec1ec4ec7,
    Q       =>  mc2_21_ec1ec4ec7--Row21
);

ACCUM_B3_0_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b3_0_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec1ec4ec7,
    SCLR    =>  sclr3_ec1ec4ec7,
    Q       =>  mc3_0_ec1ec4ec7--Row0
);
ACCUM_B3_1_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  B3_1_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec1ec4ec7,
    SCLR    =>  sclr3_ec1ec4ec7,
    Q       =>  mc3_1_ec1ec4ec7--Row1
);
ACCUM_B3_2_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  B3_2_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec1ec4ec7,
    SCLR    =>  sclr3_ec1ec4ec7,
    Q       =>  mc3_2_ec1ec4ec7--Row2
);
ACCUM_B3_3_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  B3_3_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec1ec4ec7,
    SCLR    =>  sclr3_ec1ec4ec7,
    Q       =>  mc3_3_ec1ec4ec7--Row3
);
ACCUM_B3_4_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  B3_4_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec1ec4ec7,
    SCLR    =>  sclr3_ec1ec4ec7,
    Q       =>  mc3_4_ec1ec4ec7--Row4
);
ACCUM_B3_5_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  B3_5_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec1ec4ec7,
    SCLR    =>  sclr3_ec1ec4ec7,
    Q       =>  mc3_5_ec1ec4ec7--Row5
);
ACCUM_B3_6_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  B3_6_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec1ec4ec7,
    SCLR    =>  sclr3_ec1ec4ec7,
    Q       =>  mc3_6_ec1ec4ec7--Row6
);
ACCUM_B3_7_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  B3_7_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec1ec4ec7,
    SCLR    =>  sclr3_ec1ec4ec7,
    Q       =>  mc3_7_ec1ec4ec7--Row7
);
ACCUM_B3_8_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  B3_8_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec1ec4ec7,
    SCLR    =>  sclr3_ec1ec4ec7,
    Q       =>  mc3_8_ec1ec4ec7--Row8
);
ACCUM_B3_9_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  B3_9_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec1ec4ec7,
    SCLR    =>  sclr3_ec1ec4ec7,
    Q       =>  mc3_9_ec1ec4ec7--Row9
);
ACCUM_B3_10_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  B3_10_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec1ec4ec7,
    SCLR    =>  sclr3_ec1ec4ec7,
    Q       =>  mc3_10_ec1ec4ec7--Row10
);
ACCUM_B3_11_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  B3_11_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec1ec4ec7,
    SCLR    =>  sclr3_ec1ec4ec7,
    Q       =>  mc3_11_ec1ec4ec7--Row11
);
ACCUM_B3_12_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  B3_12_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec1ec4ec7,
    SCLR    =>  sclr3_ec1ec4ec7,
    Q       =>  mc3_12_ec1ec4ec7--Row12
);
ACCUM_B3_13_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  B3_13_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec1ec4ec7,
    SCLR    =>  sclr3_ec1ec4ec7,
    Q       =>  mc3_13_ec1ec4ec7--Row13
);
ACCUM_B3_14_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  B3_14_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec1ec4ec7,
    SCLR    =>  sclr3_ec1ec4ec7,
    Q       =>  mc3_14_ec1ec4ec7--Row14
);
ACCUM_B3_15_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  B3_15_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec1ec4ec7,
    SCLR    =>  sclr3_ec1ec4ec7,
    Q       =>  mc3_15_ec1ec4ec7--Row15
);
ACCUM_B3_16_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  B3_16_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec1ec4ec7,
    SCLR    =>  sclr3_ec1ec4ec7,
    Q       =>  mc3_16_ec1ec4ec7--Row16
);
ACCUM_B3_17_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  B3_17_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec1ec4ec7,
    SCLR    =>  sclr3_ec1ec4ec7,
    Q       =>  mc3_17_ec1ec4ec7--Row17
);
ACCUM_B3_18_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  B3_18_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec1ec4ec7,
    SCLR    =>  sclr3_ec1ec4ec7,
    Q       =>  mc3_18_ec1ec4ec7--Row18
);
ACCUM_B3_19_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  B3_19_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec1ec4ec7,
    SCLR    =>  sclr3_ec1ec4ec7,
    Q       =>  mc3_19_ec1ec4ec7--Row19
);
ACCUM_B3_20_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  B3_20_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec1ec4ec7,
    SCLR    =>  sclr3_ec1ec4ec7,
    Q       =>  mc3_20_ec1ec4ec7--Row20
);
ACCUM_B3_21_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  B3_21_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec1ec4ec7,
    SCLR    =>  sclr3_ec1ec4ec7,
    Q       =>  mc3_21_ec1ec4ec7--Row21
);

ACCUM_B4_0_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b4_0_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec1ec4ec7,
    SCLR    =>  sclr4_ec1ec4ec7,
    Q       =>  mc4_0_ec1ec4ec7--Row0
);
ACCUM_b4_1_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b4_1_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec1ec4ec7,
    SCLR    =>  sclr4_ec1ec4ec7,
    Q       =>  mc4_1_ec1ec4ec7--Row1
);
ACCUM_b4_2_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b4_2_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec1ec4ec7,
    SCLR    =>  sclr4_ec1ec4ec7,
    Q       =>  mc4_2_ec1ec4ec7--Row2
);
ACCUM_b4_3_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b4_3_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec1ec4ec7,
    SCLR    =>  sclr4_ec1ec4ec7,
    Q       =>  mc4_3_ec1ec4ec7--Row3
);
ACCUM_b4_4_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b4_4_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec1ec4ec7,
    SCLR    =>  sclr4_ec1ec4ec7,
    Q       =>  mc4_4_ec1ec4ec7--Row4
);
ACCUM_b4_5_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b4_5_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec1ec4ec7,
    SCLR    =>  sclr4_ec1ec4ec7,
    Q       =>  mc4_5_ec1ec4ec7--Row5
);
ACCUM_b4_6_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b4_6_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec1ec4ec7,
    SCLR    =>  sclr4_ec1ec4ec7,
    Q       =>  mc4_6_ec1ec4ec7--Row6
);
ACCUM_b4_7_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b4_7_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec1ec4ec7,
    SCLR    =>  sclr4_ec1ec4ec7,
    Q       =>  mc4_7_ec1ec4ec7--Row7
);
ACCUM_b4_8_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b4_8_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec1ec4ec7,
    SCLR    =>  sclr4_ec1ec4ec7,
    Q       =>  mc4_8_ec1ec4ec7--Row8
);
ACCUM_b4_9_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b4_9_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec1ec4ec7,
    SCLR    =>  sclr4_ec1ec4ec7,
    Q       =>  mc4_9_ec1ec4ec7--Row9
);
ACCUM_b4_10_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b4_10_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec1ec4ec7,
    SCLR    =>  sclr4_ec1ec4ec7,
    Q       =>  mc4_10_ec1ec4ec7--Row10
);
ACCUM_b4_11_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b4_11_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec1ec4ec7,
    SCLR    =>  sclr4_ec1ec4ec7,
    Q       =>  mc4_11_ec1ec4ec7--Row11
);
ACCUM_b4_12_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b4_12_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec1ec4ec7,
    SCLR    =>  sclr4_ec1ec4ec7,
    Q       =>  mc4_12_ec1ec4ec7--Row12
);
ACCUM_b4_13_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b4_13_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec1ec4ec7,
    SCLR    =>  sclr4_ec1ec4ec7,
    Q       =>  mc4_13_ec1ec4ec7--Row13
);
ACCUM_b4_14_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b4_14_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec1ec4ec7,
    SCLR    =>  sclr4_ec1ec4ec7,
    Q       =>  mc4_14_ec1ec4ec7--Row14
);
ACCUM_b4_15_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b4_15_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec1ec4ec7,
    SCLR    =>  sclr4_ec1ec4ec7,
    Q       =>  mc4_15_ec1ec4ec7--Row15
);
ACCUM_b4_16_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b4_16_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec1ec4ec7,
    SCLR    =>  sclr4_ec1ec4ec7,
    Q       =>  mc4_16_ec1ec4ec7--Row16
);
ACCUM_b4_17_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b4_17_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec1ec4ec7,
    SCLR    =>  sclr4_ec1ec4ec7,
    Q       =>  mc4_17_ec1ec4ec7--Row17
);
ACCUM_b4_18_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b4_18_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec1ec4ec7,
    SCLR    =>  sclr4_ec1ec4ec7,
    Q       =>  mc4_18_ec1ec4ec7--Row18
);
ACCUM_b4_19_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b4_19_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec1ec4ec7,
    SCLR    =>  sclr4_ec1ec4ec7,
    Q       =>  mc4_19_ec1ec4ec7--Row19
);
ACCUM_b4_20_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b4_20_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec1ec4ec7,
    SCLR    =>  sclr4_ec1ec4ec7,
    Q       =>  mc4_20_ec1ec4ec7--Row20
);
ACCUM_b4_21_ec1ec4ec7 : accum_2_4
PORT MAP(
    B       =>  b4_21_ec1ec4ec7,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec1ec4ec7,
    SCLR    =>  sclr4_ec1ec4ec7,
    Q       =>  mc4_21_ec1ec4ec7--Row21
);

ACCUM_B0_0_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b0_0_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec2ec5ec8,
    SCLR    =>  sclr0_ec2ec5ec8,
    Q       =>  mc0_0_ec2ec5ec8--Row0
);
ACCUM_B0_1_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b0_1_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec2ec5ec8,
    SCLR    =>  sclr0_ec2ec5ec8,
    Q       =>  mc0_1_ec2ec5ec8--Row1
);

ACCUM_B0_2_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b0_2_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec2ec5ec8,
    SCLR    =>  sclr0_ec2ec5ec8,
    Q       =>  mc0_2_ec2ec5ec8--Row2
);
ACCUM_B0_3_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b0_3_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec2ec5ec8,
    SCLR    =>  sclr0_ec2ec5ec8,
    Q       =>  mc0_3_ec2ec5ec8--Row3
);
ACCUM_B0_4_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b0_4_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec2ec5ec8,
    SCLR    =>  sclr0_ec2ec5ec8,
    Q       =>  mc0_4_ec2ec5ec8--Row4
);
ACCUM_B0_5_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b0_5_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec2ec5ec8,
    SCLR    =>  sclr0_ec2ec5ec8,
    Q       =>  mc0_5_ec2ec5ec8--Row5
);
ACCUM_B0_6_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b0_6_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec2ec5ec8,
    SCLR    =>  sclr0_ec2ec5ec8,
    Q       =>  mc0_6_ec2ec5ec8--Row6
);
ACCUM_B0_7_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b0_7_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec2ec5ec8,
    SCLR    =>  sclr0_ec2ec5ec8,
    Q       =>  mc0_7_ec2ec5ec8--Row7
);
ACCUM_B0_8_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b0_8_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec2ec5ec8,
    SCLR    =>  sclr0_ec2ec5ec8,
    Q       =>  mc0_8_ec2ec5ec8--Row8
);
ACCUM_B0_9_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b0_9_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec2ec5ec8,
    SCLR    =>  sclr0_ec2ec5ec8,
    Q       =>  mc0_9_ec2ec5ec8--Row9
);
ACCUM_B0_10_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b0_10_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec2ec5ec8,
    SCLR    =>  sclr0_ec2ec5ec8,
    Q       =>  mc0_10_ec2ec5ec8--Row10
);
ACCUM_B0_11_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b0_11_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec2ec5ec8,
    SCLR    =>  sclr0_ec2ec5ec8,
    Q       =>  mc0_11_ec2ec5ec8--Row11
);
ACCUM_B0_12_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b0_12_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec2ec5ec8,
    SCLR    =>  sclr0_ec2ec5ec8,
    Q       =>  mc0_12_ec2ec5ec8--Row12
);
ACCUM_B0_13_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b0_13_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec2ec5ec8,
    SCLR    =>  sclr0_ec2ec5ec8,
    Q       =>  mc0_13_ec2ec5ec8--Row13
);
ACCUM_B0_14_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b0_14_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec2ec5ec8,
    SCLR    =>  sclr0_ec2ec5ec8,
    Q       =>  mc0_14_ec2ec5ec8--Row14
);
ACCUM_B0_15_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b0_15_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec2ec5ec8,
    SCLR    =>  sclr0_ec2ec5ec8,
    Q       =>  mc0_15_ec2ec5ec8--Row15
);
ACCUM_B0_16_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b0_16_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec2ec5ec8,
    SCLR    =>  sclr0_ec2ec5ec8,
    Q       =>  mc0_16_ec2ec5ec8--Row16
);
ACCUM_B0_17_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b0_17_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec2ec5ec8,
    SCLR    =>  sclr0_ec2ec5ec8,
    Q       =>  mc0_17_ec2ec5ec8--Row17
);
ACCUM_B0_18_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b0_18_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec2ec5ec8,
    SCLR    =>  sclr0_ec2ec5ec8,
    Q       =>  mc0_18_ec2ec5ec8--Row18
);
ACCUM_B0_19_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b0_19_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec2ec5ec8,
    SCLR    =>  sclr0_ec2ec5ec8,
    Q       =>  mc0_19_ec2ec5ec8--Row19
);
ACCUM_B0_20_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b0_20_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec2ec5ec8,
    SCLR    =>  sclr0_ec2ec5ec8,
    Q       =>  mc0_20_ec2ec5ec8--Row20
);
ACCUM_B0_21_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b0_21_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce0_ec2ec5ec8,
    SCLR    =>  sclr0_ec2ec5ec8,
    Q       =>  mc0_21_ec2ec5ec8--Row21
);

ACCUM_B1_0_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b1_0_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec2ec5ec8,
    SCLR    =>  sclr1_ec2ec5ec8,
    Q       =>  mc1_0_ec2ec5ec8--Row0
);
ACCUM_B1_1_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b1_1_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec2ec5ec8,
    SCLR    =>  sclr1_ec2ec5ec8,
    Q       =>  mc1_1_ec2ec5ec8--Row1
);
ACCUM_B1_2_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b1_2_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec2ec5ec8,
    SCLR    =>  sclr1_ec2ec5ec8,
    Q       =>  mc1_2_ec2ec5ec8--Row2
);
ACCUM_B1_3_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b1_3_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec2ec5ec8,
    SCLR    =>  sclr1_ec2ec5ec8,
    Q       =>  mc1_3_ec2ec5ec8--Row3
);
ACCUM_B1_4_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b1_4_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec2ec5ec8,
    SCLR    =>  sclr1_ec2ec5ec8,
    Q       =>  mc1_4_ec2ec5ec8--Row4
);
ACCUM_B1_5_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b1_5_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec2ec5ec8,
    SCLR    =>  sclr1_ec2ec5ec8,
    Q       =>  mc1_5_ec2ec5ec8--Row5
);
ACCUM_B1_6_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b1_6_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec2ec5ec8,
    SCLR    =>  sclr1_ec2ec5ec8,
    Q       =>  mc1_6_ec2ec5ec8--Row6
);
ACCUM_B1_7_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b1_7_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec2ec5ec8,
    SCLR    =>  sclr1_ec2ec5ec8,
    Q       =>  mc1_7_ec2ec5ec8--Row7
);
ACCUM_B1_8_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b1_8_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec2ec5ec8,
    SCLR    =>  sclr1_ec2ec5ec8,
    Q       =>  mc1_8_ec2ec5ec8--Row8
);
ACCUM_B1_9_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b1_9_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec2ec5ec8,
    SCLR    =>  sclr1_ec2ec5ec8,
    Q       =>  mc1_9_ec2ec5ec8--Row9
);
ACCUM_B1_10_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b1_10_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec2ec5ec8,
    SCLR    =>  sclr1_ec2ec5ec8,
    Q       =>  mc1_10_ec2ec5ec8--Row10
);
ACCUM_B1_11_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b1_11_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec2ec5ec8,
    SCLR    =>  sclr1_ec2ec5ec8,
    Q       =>  mc1_11_ec2ec5ec8--Row11
);
ACCUM_B1_12_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b1_12_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec2ec5ec8,
    SCLR    =>  sclr1_ec2ec5ec8,
    Q       =>  mc1_12_ec2ec5ec8--Row12
);
ACCUM_B1_13_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b1_13_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec2ec5ec8,
    SCLR    =>  sclr1_ec2ec5ec8,
    Q       =>  mc1_13_ec2ec5ec8--Row13
);
ACCUM_B1_14_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b1_14_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec2ec5ec8,
    SCLR    =>  sclr1_ec2ec5ec8,
    Q       =>  mc1_14_ec2ec5ec8--Row14
);
ACCUM_B1_15_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b1_15_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec2ec5ec8,
    SCLR    =>  sclr1_ec2ec5ec8,
    Q       =>  mc1_15_ec2ec5ec8--Row15
);
ACCUM_B1_16_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b1_16_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec2ec5ec8,
    SCLR    =>  sclr1_ec2ec5ec8,
    Q       =>  mc1_16_ec2ec5ec8--Row16
);
ACCUM_B1_17_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b1_17_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec2ec5ec8,
    SCLR    =>  sclr1_ec2ec5ec8,
    Q       =>  mc1_17_ec2ec5ec8--Row17
);
ACCUM_B1_18_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b1_18_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec2ec5ec8,
    SCLR    =>  sclr1_ec2ec5ec8,
    Q       =>  mc1_18_ec2ec5ec8--Row18
);
ACCUM_B1_19_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b1_19_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec2ec5ec8,
    SCLR    =>  sclr1_ec2ec5ec8,
    Q       =>  mc1_19_ec2ec5ec8--Row19
);
ACCUM_B1_20_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b1_20_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec2ec5ec8,
    SCLR    =>  sclr1_ec2ec5ec8,
    Q       =>  mc1_20_ec2ec5ec8--Row20
);
ACCUM_B1_21_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b1_21_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce1_ec2ec5ec8,
    SCLR    =>  sclr1_ec2ec5ec8,
    Q       =>  mc1_21_ec2ec5ec8--Row21
);

ACCUM_B2_0_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b2_0_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec2ec5ec8,
    SCLR    =>  sclr2_ec2ec5ec8,
    Q       =>  mc2_0_ec2ec5ec8--Row0
);
ACCUM_B2_1_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b2_1_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec2ec5ec8,
    SCLR    =>  sclr2_ec2ec5ec8,
    Q       =>  mc2_1_ec2ec5ec8--Row1
);
ACCUM_B2_2_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b2_2_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec2ec5ec8,
    SCLR    =>  sclr2_ec2ec5ec8,
    Q       =>  mc2_2_ec2ec5ec8--Row2
);
ACCUM_B2_3_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b2_3_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec2ec5ec8,
    SCLR    =>  sclr2_ec2ec5ec8,
    Q       =>  mc2_3_ec2ec5ec8--Row3
);
ACCUM_B2_4_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b2_4_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec2ec5ec8,
    SCLR    =>  sclr2_ec2ec5ec8,
    Q       =>  mc2_4_ec2ec5ec8--Row4
);
ACCUM_B2_5_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b2_5_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec2ec5ec8,
    SCLR    =>  sclr2_ec2ec5ec8,
    Q       =>  mc2_5_ec2ec5ec8--Row5
);
ACCUM_B2_6_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b2_6_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec2ec5ec8,
    SCLR    =>  sclr2_ec2ec5ec8,
    Q       =>  mc2_6_ec2ec5ec8--Row6
);
ACCUM_B2_7_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b2_7_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec2ec5ec8,
    SCLR    =>  sclr2_ec2ec5ec8,
    Q       =>  mc2_7_ec2ec5ec8--Row7
);
ACCUM_B2_8_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b2_8_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec2ec5ec8,
    SCLR    =>  sclr2_ec2ec5ec8,
    Q       =>  mc2_8_ec2ec5ec8--Row8
);
ACCUM_B2_9_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b2_9_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec2ec5ec8,
    SCLR    =>  sclr2_ec2ec5ec8,
    Q       =>  mc2_9_ec2ec5ec8--Row9
);
ACCUM_B2_10_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b2_10_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec2ec5ec8,
    SCLR    =>  sclr2_ec2ec5ec8,
    Q       =>  mc2_10_ec2ec5ec8--Row10
);
ACCUM_B2_11_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b2_11_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec2ec5ec8,
    SCLR    =>  sclr2_ec2ec5ec8,
    Q       =>  mc2_11_ec2ec5ec8--Row11
);
ACCUM_B2_12_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b2_12_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec2ec5ec8,
    SCLR    =>  sclr2_ec2ec5ec8,
    Q       =>  mc2_12_ec2ec5ec8--Row12
);
ACCUM_B2_13_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b2_13_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec2ec5ec8,
    SCLR    =>  sclr2_ec2ec5ec8,
    Q       =>  mc2_13_ec2ec5ec8--Row13
);
ACCUM_B2_14_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b2_14_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec2ec5ec8,
    SCLR    =>  sclr2_ec2ec5ec8,
    Q       =>  mc2_14_ec2ec5ec8--Row14
);
ACCUM_B2_15_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b2_15_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec2ec5ec8,
    SCLR    =>  sclr2_ec2ec5ec8,
    Q       =>  mc2_15_ec2ec5ec8--Row15
);
ACCUM_B2_16_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b2_16_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec2ec5ec8,
    SCLR    =>  sclr2_ec2ec5ec8,
    Q       =>  mc2_16_ec2ec5ec8--Row16
);
ACCUM_B2_17_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b2_17_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec2ec5ec8,
    SCLR    =>  sclr2_ec2ec5ec8,
    Q       =>  mc2_17_ec2ec5ec8--Row17
);
ACCUM_B2_18_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b2_18_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec2ec5ec8,
    SCLR    =>  sclr2_ec2ec5ec8,
    Q       =>  mc2_18_ec2ec5ec8--Row18
);
ACCUM_B2_19_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b2_19_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec2ec5ec8,
    SCLR    =>  sclr2_ec2ec5ec8,
    Q       =>  mc2_19_ec2ec5ec8--Row19
);
ACCUM_B2_20_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b2_20_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec2ec5ec8,
    SCLR    =>  sclr2_ec2ec5ec8,
    Q       =>  mc2_20_ec2ec5ec8--Row20
);
ACCUM_B2_21_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b2_21_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce2_ec2ec5ec8,
    SCLR    =>  sclr2_ec2ec5ec8,
    Q       =>  mc2_21_ec2ec5ec8--Row21
);

ACCUM_B3_0_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b3_0_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec2ec5ec8,
    SCLR    =>  sclr3_ec2ec5ec8,
    Q       =>  mc3_0_ec2ec5ec8--Row0
);
ACCUM_B3_1_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  B3_1_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec2ec5ec8,
    SCLR    =>  sclr3_ec2ec5ec8,
    Q       =>  mc3_1_ec2ec5ec8--Row1
);
ACCUM_B3_2_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  B3_2_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec2ec5ec8,
    SCLR    =>  sclr3_ec2ec5ec8,
    Q       =>  mc3_2_ec2ec5ec8--Row2
);
ACCUM_B3_3_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  B3_3_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec2ec5ec8,
    SCLR    =>  sclr3_ec2ec5ec8,
    Q       =>  mc3_3_ec2ec5ec8--Row3
);
ACCUM_B3_4_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  B3_4_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec2ec5ec8,
    SCLR    =>  sclr3_ec2ec5ec8,
    Q       =>  mc3_4_ec2ec5ec8--Row4
);
ACCUM_B3_5_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  B3_5_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec2ec5ec8,
    SCLR    =>  sclr3_ec2ec5ec8,
    Q       =>  mc3_5_ec2ec5ec8--Row5
);
ACCUM_B3_6_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  B3_6_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec2ec5ec8,
    SCLR    =>  sclr3_ec2ec5ec8,
    Q       =>  mc3_6_ec2ec5ec8--Row6
);
ACCUM_B3_7_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  B3_7_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec2ec5ec8,
    SCLR    =>  sclr3_ec2ec5ec8,
    Q       =>  mc3_7_ec2ec5ec8--Row7
);
ACCUM_B3_8_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  B3_8_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec2ec5ec8,
    SCLR    =>  sclr3_ec2ec5ec8,
    Q       =>  mc3_8_ec2ec5ec8--Row8
);
ACCUM_B3_9_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  B3_9_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec2ec5ec8,
    SCLR    =>  sclr3_ec2ec5ec8,
    Q       =>  mc3_9_ec2ec5ec8--Row9
);
ACCUM_B3_10_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  B3_10_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec2ec5ec8,
    SCLR    =>  sclr3_ec2ec5ec8,
    Q       =>  mc3_10_ec2ec5ec8--Row10
);
ACCUM_B3_11_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  B3_11_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec2ec5ec8,
    SCLR    =>  sclr3_ec2ec5ec8,
    Q       =>  mc3_11_ec2ec5ec8--Row11
);
ACCUM_B3_12_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  B3_12_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec2ec5ec8,
    SCLR    =>  sclr3_ec2ec5ec8,
    Q       =>  mc3_12_ec2ec5ec8--Row12
);
ACCUM_B3_13_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  B3_13_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec2ec5ec8,
    SCLR    =>  sclr3_ec2ec5ec8,
    Q       =>  mc3_13_ec2ec5ec8--Row13
);
ACCUM_B3_14_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  B3_14_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec2ec5ec8,
    SCLR    =>  sclr3_ec2ec5ec8,
    Q       =>  mc3_14_ec2ec5ec8--Row14
);
ACCUM_B3_15_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  B3_15_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec2ec5ec8,
    SCLR    =>  sclr3_ec2ec5ec8,
    Q       =>  mc3_15_ec2ec5ec8--Row15
);
ACCUM_B3_16_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  B3_16_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec2ec5ec8,
    SCLR    =>  sclr3_ec2ec5ec8,
    Q       =>  mc3_16_ec2ec5ec8--Row16
);
ACCUM_B3_17_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  B3_17_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec2ec5ec8,
    SCLR    =>  sclr3_ec2ec5ec8,
    Q       =>  mc3_17_ec2ec5ec8--Row17
);
ACCUM_B3_18_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  B3_18_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec2ec5ec8,
    SCLR    =>  sclr3_ec2ec5ec8,
    Q       =>  mc3_18_ec2ec5ec8--Row18
);
ACCUM_B3_19_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  B3_19_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec2ec5ec8,
    SCLR    =>  sclr3_ec2ec5ec8,
    Q       =>  mc3_19_ec2ec5ec8--Row19
);
ACCUM_B3_20_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  B3_20_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec2ec5ec8,
    SCLR    =>  sclr3_ec2ec5ec8,
    Q       =>  mc3_20_ec2ec5ec8--Row20
);
ACCUM_B3_21_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  B3_21_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce3_ec2ec5ec8,
    SCLR    =>  sclr3_ec2ec5ec8,
    Q       =>  mc3_21_ec2ec5ec8--Row21
);

ACCUM_B4_0_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b4_0_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec2ec5ec8,
    SCLR    =>  sclr4_ec2ec5ec8,
    Q       =>  mc4_0_ec2ec5ec8--Row0
);
ACCUM_b4_1_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b4_1_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec2ec5ec8,
    SCLR    =>  sclr4_ec2ec5ec8,
    Q       =>  mc4_1_ec2ec5ec8--Row1
);
ACCUM_b4_2_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b4_2_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec2ec5ec8,
    SCLR    =>  sclr4_ec2ec5ec8,
    Q       =>  mc4_2_ec2ec5ec8--Row2
);
ACCUM_b4_3_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b4_3_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec2ec5ec8,
    SCLR    =>  sclr4_ec2ec5ec8,
    Q       =>  mc4_3_ec2ec5ec8--Row3
);
ACCUM_b4_4_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b4_4_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec2ec5ec8,
    SCLR    =>  sclr4_ec2ec5ec8,
    Q       =>  mc4_4_ec2ec5ec8--Row4
);
ACCUM_b4_5_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b4_5_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec2ec5ec8,
    SCLR    =>  sclr4_ec2ec5ec8,
    Q       =>  mc4_5_ec2ec5ec8--Row5
);
ACCUM_b4_6_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b4_6_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec2ec5ec8,
    SCLR    =>  sclr4_ec2ec5ec8,
    Q       =>  mc4_6_ec2ec5ec8--Row6
);
ACCUM_b4_7_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b4_7_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec2ec5ec8,
    SCLR    =>  sclr4_ec2ec5ec8,
    Q       =>  mc4_7_ec2ec5ec8--Row7
);
ACCUM_b4_8_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b4_8_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec2ec5ec8,
    SCLR    =>  sclr4_ec2ec5ec8,
    Q       =>  mc4_8_ec2ec5ec8--Row8
);
ACCUM_b4_9_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b4_9_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec2ec5ec8,
    SCLR    =>  sclr4_ec2ec5ec8,
    Q       =>  mc4_9_ec2ec5ec8--Row9
);
ACCUM_b4_10_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b4_10_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec2ec5ec8,
    SCLR    =>  sclr4_ec2ec5ec8,
    Q       =>  mc4_10_ec2ec5ec8--Row10
);
ACCUM_b4_11_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b4_11_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec2ec5ec8,
    SCLR    =>  sclr4_ec2ec5ec8,
    Q       =>  mc4_11_ec2ec5ec8--Row11
);
ACCUM_b4_12_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b4_12_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec2ec5ec8,
    SCLR    =>  sclr4_ec2ec5ec8,
    Q       =>  mc4_12_ec2ec5ec8--Row12
);
ACCUM_b4_13_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b4_13_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec2ec5ec8,
    SCLR    =>  sclr4_ec2ec5ec8,
    Q       =>  mc4_13_ec2ec5ec8--Row13
);
ACCUM_b4_14_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b4_14_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec2ec5ec8,
    SCLR    =>  sclr4_ec2ec5ec8,
    Q       =>  mc4_14_ec2ec5ec8--Row14
);
ACCUM_b4_15_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b4_15_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec2ec5ec8,
    SCLR    =>  sclr4_ec2ec5ec8,
    Q       =>  mc4_15_ec2ec5ec8--Row15
);
ACCUM_b4_16_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b4_16_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec2ec5ec8,
    SCLR    =>  sclr4_ec2ec5ec8,
    Q       =>  mc4_16_ec2ec5ec8--Row16
);
ACCUM_b4_17_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b4_17_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec2ec5ec8,
    SCLR    =>  sclr4_ec2ec5ec8,
    Q       =>  mc4_17_ec2ec5ec8--Row17
);
ACCUM_b4_18_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b4_18_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec2ec5ec8,
    SCLR    =>  sclr4_ec2ec5ec8,
    Q       =>  mc4_18_ec2ec5ec8--Row18
);
ACCUM_b4_19_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b4_19_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec2ec5ec8,
    SCLR    =>  sclr4_ec2ec5ec8,
    Q       =>  mc4_19_ec2ec5ec8--Row19
);
ACCUM_b4_20_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b4_20_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec2ec5ec8,
    SCLR    =>  sclr4_ec2ec5ec8,
    Q       =>  mc4_20_ec2ec5ec8--Row20
);
ACCUM_b4_21_ec2ec5ec8 : accum_2_4
PORT MAP(
    B       =>  b4_21_ec2ec5ec8,
    CLK     =>  CLOCK,
    CE      =>  ce4_ec2ec5ec8,
    SCLR    =>  sclr4_ec2ec5ec8,
    Q       =>  mc4_21_ec2ec5ec8--Row21
);

MACROCELL_BUFFER_3GTU : MACROCELL_BUFFER
  PORT MAP (
    a => a_mc_mem,
    d => d_mc_mem,
    clk => clock,
    we => we_mc_mem,
    spo => spo_mc_mem
  );
  
ACCUM3GTU_MC0_0 : accum_4_5
  PORT MAP (
    B => B_accum_mc0_0,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc0_0
  );
ACCUM3GTU_MC1_0 : accum_4_5
  PORT MAP (
    B => B_accum_mc1_0,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc1_0
  );
ACCUM3GTU_MC2_0 : accum_4_5
  PORT MAP (
    B => B_accum_mc2_0,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc2_0
  );
ACCUM3GTU_MC3_0 : accum_4_5
PORT MAP (
  B => B_accum_mc3_0,
  CLK => clock,
  CE => CE_accum,
  SCLR => SCLR_accum,
  Q => Q_accum_mc3_0
);
ACCUM3GTU_MC4_0 : accum_4_5
PORT MAP (
    B => B_accum_mc4_0,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc4_0
);
ACCUM3GTU_MC5_0 : accum_4_5
PORT MAP (
  B => B_accum_mc5_0,
  CLK => clock,
  CE => CE_accum,
  SCLR => SCLR_accum,
  Q => Q_accum_mc5_0
);
ACCUM3GTU_MC6_0 : accum_4_5
PORT MAP (
    B => B_accum_mc6_0,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc6_0
);
ACCUM3GTU_MC7_0 : accum_4_5
PORT MAP (
  B => B_accum_mc7_0,
  CLK => clock,
  CE => CE_accum,
  SCLR => SCLR_accum,
  Q => Q_accum_mc7_0
);
ACCUM3GTU_MC8_0 : accum_4_5
PORT MAP (
    B => B_accum_mc8_0,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc8_0
);
ACCUM3GTU_MC9_0 : accum_4_5
PORT MAP (
    B => B_accum_mc9_0,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc9_0
);
ACCUM3GTU_MC10_0 : accum_4_5
PORT MAP (
    B => B_accum_mc10_0,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc10_0
);
ACCUM3GTU_MC11_0 : accum_4_5
PORT MAP (
    B => B_accum_mc11_0,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc11_0
);
ACCUM3GTU_MC12_0 : accum_4_5
PORT MAP (
    B => B_accum_mc12_0,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc12_0
);
ACCUM3GTU_MC13_0 : accum_4_5
PORT MAP (
    B => B_accum_mc13_0,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc13_0
);
ACCUM3GTU_MC14_0 : accum_4_5
    PORT MAP (
    B => B_accum_mc14_0,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc14_0
);
ACCUM3GTU_MC15_0 : accum_4_5
PORT MAP (
    B => B_accum_mc15_0,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc15_0
);
ACCUM3GTU_MC16_0 : accum_4_5
    PORT MAP (
    B => B_accum_mc16_0,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc16_0
);
ACCUM3GTU_MC17_0 : accum_4_5
    PORT MAP (
    B => B_accum_mc17_0,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc17_0
);
ACCUM3GTU_MC18_0 : accum_4_5
PORT MAP (
    B => B_accum_mc18_0,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc18_0
);
ACCUM3GTU_MC19_0 : accum_4_5
PORT MAP (
    B => B_accum_mc19_0,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc19_0
);
ACCUM3GTU_MC20_0 : accum_4_5
PORT MAP (
    B => B_accum_mc20_0,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc20_0
);
ACCUM3GTU_MC21_0 : accum_4_5
PORT MAP (
    B => B_accum_mc21_0,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc21_0
);

ACCUM3GTU_MC0_1 : accum_4_5
  PORT MAP (
    B => B_accum_mc0_1,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc0_1
  );
ACCUM3GTU_MC1_1 : accum_4_5
  PORT MAP (
    B => B_accum_mc1_1,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc1_1
  );
ACCUM3GTU_MC2_1 : accum_4_5
  PORT MAP (
    B => B_accum_mc2_1,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc2_1
  );
ACCUM3GTU_MC3_1 : accum_4_5
PORT MAP (
  B => B_accum_mc3_1,
  CLK => clock,
  CE => CE_accum,
  SCLR => SCLR_accum,
  Q => Q_accum_mc3_1
);
ACCUM3GTU_MC4_1 : accum_4_5
PORT MAP (
    B => B_accum_mc4_1,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc4_1
);
ACCUM3GTU_MC5_1 : accum_4_5
PORT MAP (
  B => B_accum_mc5_1,
  CLK => clock,
  CE => CE_accum,
  SCLR => SCLR_accum,
  Q => Q_accum_mc5_1
);
ACCUM3GTU_MC6_1 : accum_4_5
PORT MAP (
    B => B_accum_mc6_1,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc6_1
);
ACCUM3GTU_MC7_1 : accum_4_5
PORT MAP (
  B => B_accum_mc7_1,
  CLK => clock,
  CE => CE_accum,
  SCLR => SCLR_accum,
  Q => Q_accum_mc7_1
);
ACCUM3GTU_MC8_1 : accum_4_5
PORT MAP (
    B => B_accum_mc8_1,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc8_1
);
ACCUM3GTU_MC9_1 : accum_4_5
PORT MAP (
    B => B_accum_mc9_1,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc9_1
);
ACCUM3GTU_MC10_1 : accum_4_5
PORT MAP (
    B => B_accum_mc10_1,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc10_1
);
ACCUM3GTU_MC11_1 : accum_4_5
PORT MAP (
    B => B_accum_mc11_1,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc11_1
);
ACCUM3GTU_MC12_1 : accum_4_5
PORT MAP (
    B => B_accum_mc12_1,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc12_1
);
ACCUM3GTU_MC13_1 : accum_4_5
PORT MAP (
    B => B_accum_mc13_1,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc13_1
);
ACCUM3GTU_MC14_1 : accum_4_5
    PORT MAP (
    B => B_accum_mc14_1,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc14_1
);
ACCUM3GTU_MC15_1 : accum_4_5
PORT MAP (
    B => B_accum_mc15_1,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc15_1
);
ACCUM3GTU_MC16_1 : accum_4_5
    PORT MAP (
    B => B_accum_mc16_1,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc16_1
);
ACCUM3GTU_MC17_1 : accum_4_5
    PORT MAP (
    B => B_accum_mc17_1,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc17_1
);
ACCUM3GTU_MC18_1 : accum_4_5
PORT MAP (
    B => B_accum_mc18_1,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc18_1
);
ACCUM3GTU_MC19_1 : accum_4_5
PORT MAP (
    B => B_accum_mc19_1,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc19_1
);
ACCUM3GTU_MC20_1 : accum_4_5
PORT MAP (
    B => B_accum_mc20_1,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc20_1
);
ACCUM3GTU_MC21_1 : accum_4_5
PORT MAP (
    B => B_accum_mc21_1,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc21_1
);

ACCUM3GTU_MC0_2 : accum_4_5
  PORT MAP (
    B => B_accum_mc0_2,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc0_2
  );
ACCUM3GTU_MC1_2 : accum_4_5
  PORT MAP (
    B => B_accum_mc1_2,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc1_2
  );
ACCUM3GTU_MC2_2 : accum_4_5
  PORT MAP (
    B => B_accum_mc2_2,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc2_2
  );
ACCUM3GTU_MC3_2 : accum_4_5
PORT MAP (
  B => B_accum_mc3_2,
  CLK => clock,
  CE => CE_accum,
  SCLR => SCLR_accum,
  Q => Q_accum_mc3_2
);
ACCUM3GTU_MC4_2 : accum_4_5
PORT MAP (
    B => B_accum_mc4_2,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc4_2
);
ACCUM3GTU_MC5_2 : accum_4_5
PORT MAP (
  B => B_accum_mc5_2,
  CLK => clock,
  CE => CE_accum,
  SCLR => SCLR_accum,
  Q => Q_accum_mc5_2
);
ACCUM3GTU_MC6_2 : accum_4_5
PORT MAP (
    B => B_accum_mc6_2,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc6_2
);
ACCUM3GTU_MC7_2 : accum_4_5
PORT MAP (
  B => B_accum_mc7_2,
  CLK => clock,
  CE => CE_accum,
  SCLR => SCLR_accum,
  Q => Q_accum_mc7_2
);
ACCUM3GTU_MC8_2 : accum_4_5
PORT MAP (
    B => B_accum_mc8_2,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc8_2
);
ACCUM3GTU_MC9_2 : accum_4_5
PORT MAP (
    B => B_accum_mc9_2,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc9_2
);
ACCUM3GTU_MC10_2 : accum_4_5
PORT MAP (
    B => B_accum_mc10_2,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc10_2
);
ACCUM3GTU_MC11_2 : accum_4_5
PORT MAP (
    B => B_accum_mc11_2,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc11_2
);
ACCUM3GTU_MC12_2 : accum_4_5
PORT MAP (
    B => B_accum_mc12_2,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc12_2
);
ACCUM3GTU_MC13_2 : accum_4_5
PORT MAP (
    B => B_accum_mc13_2,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc13_2
);
ACCUM3GTU_MC14_2 : accum_4_5
    PORT MAP (
    B => B_accum_mc14_2,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc14_2
);
ACCUM3GTU_MC15_2 : accum_4_5
PORT MAP (
    B => B_accum_mc15_2,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc15_2
);
ACCUM3GTU_MC16_2 : accum_4_5
    PORT MAP (
    B => B_accum_mc16_2,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc16_2
);
ACCUM3GTU_MC17_2 : accum_4_5
    PORT MAP (
    B => B_accum_mc17_2,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc17_2
);
ACCUM3GTU_MC18_2 : accum_4_5
PORT MAP (
    B => B_accum_mc18_2,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc18_2
);
ACCUM3GTU_MC19_2 : accum_4_5
PORT MAP (
    B => B_accum_mc19_2,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc19_2
);
ACCUM3GTU_MC20_2 : accum_4_5
PORT MAP (
    B => B_accum_mc20_2,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc20_2
);
ACCUM3GTU_MC21_2 : accum_4_5
PORT MAP (
    B => B_accum_mc21_2,
    CLK => clock,
    CE => CE_accum,
    SCLR => SCLR_accum,
    Q => Q_accum_mc21_2
);

ACCUM_MC_ACTIVE : accum_5_9
  PORT MAP (
    B => B_mc_active,
    CLK => clock,
    CE => CE_mc_active,
    SCLR => SCLR_mc_active,
    Q => Q_mc_active
  );
  
NLENGHT_MEMORY_BUFFER : NLENGHT_BUFFER
PORT MAP (
  a => a_nl_buffer,
  d => d_nl_buffer,
  clk => clock,
  we => we_nl_buffer,
  spo => spo_nl_buffer
);
    
 NLENGHT_BUFFER_SUM : ACCUM_9_14
  PORT MAP (
    B => B_nl_buffer_sum,
    CLK => clock,
    CE => CE_nl_buffer_sum,
    SCLR => SCLR_nl_buffer_sum,
    Q => Q_nl_buffer_sum
  );   
    
frame_counter : process (CLOCK_133B)
begin 
    if (CLOCK_133B'event and CLOCK_133B = '1') then
        case (state_frame) is
            when s0 =>
                if (FRAME = '1') then
                    if (frame_cnt = last_frame) then
                        s_aresetn_sum <= '0';
                        frame_cnt <= "0000000000000000000";--FIRST GTU
                    else
                        frame_cnt <= frame_cnt + 1;
                        s_aresetn_sum <= '1';
                    end if;
                    state_frame <= s1;
                end if;
            when s1 =>
                if (FRAME = '0') then
                    state_frame <= s0;
                end if;
        end case;
    end if;
end process;

read_command_fifo : process (CLOCK)--Read command string from COMMAND FIFO
begin
    if (CLOCK'event and CLOCK = '1') then
        case (state_read_cmd) is
            when s0 =>
                if ( m_axis_tvalid_cmd = '1' and frame_cnt = "0000000000000000000" ) then --Word in Command FIFO and acquisition start
                    m_axis_tready_cmd <= '1';--Read the word
                    state_read_cmd <= s1;
                end if;
            when s1 =>
                m_axis_tready_cmd <= '0';
                if (m_axis_tdata_cmd(31) = '0' ) then --Command Word for nSigma,nHot,nLenght,nActive
                    if (m_axis_tdata_cmd(9 downto 0) < "0100000000") then--IF nSigma < 2 => nSigma128<256
                        nSigma128 <= "1011000000";--nSigma=5.5 => nSigma128=704 (DEFAULT)
                    else
                        nSigma128 <= m_axis_tdata_cmd(9 downto 0);
                    end if;
                    
                    nHot <= m_axis_tdata_cmd(14 downto 10);
                    
                    if (m_axis_tdata_cmd(19 downto 15) < "00101") then--5
                        nLenght <= "10011";--nLenght default value 20 (index 0-19)
                    else
                        nLenght <= m_axis_tdata_cmd(19 downto 15) - 1;--First element is 0 (index 0 to "nLenght"-1)
                    end if;
                    
                    nActive <= m_axis_tdata_cmd(30 downto 20);
                else--Command Word for MPSthr
                    MPSthr <= m_axis_tdata_cmd(15 downto 0);
                end if;
                
                state_read_cmd <= s0;
        end case;
    end if;
end process;
                    

--Write MacroPixelSum in FIFO_SUM
write_fifo_sum_ec0ec3ec6 : process (CLOCK)
begin 
        if (CLOCK'event and CLOCK = '1') then
        if (mpsum_ready_ec0ec3ec6 = '1') then
            din_fifo_sum_ec0ec3ec6(23 downto 0) <= mpsum0_ec0ec3ec6;
            din_fifo_sum_ec0ec3ec6(47 downto 24) <= mpsum1_ec0ec3ec6;
            din_fifo_sum_ec0ec3ec6(71 downto 48) <= mpsum2_ec0ec3ec6;
            din_fifo_sum_ec0ec3ec6(95 downto 72) <= mpsum3_ec0ec3ec6;
            din_fifo_sum_ec0ec3ec6(119 downto 96) <= mpsum4_ec0ec3ec6;
            din_fifo_sum_ec0ec3ec6(143 downto 120) <= mpsum5_ec0ec3ec6;
            din_fifo_sum_ec0ec3ec6(167 downto 144) <= mpsum6_ec0ec3ec6;
            din_fifo_sum_ec0ec3ec6(191 downto 168) <= mpsum7_ec0ec3ec6;
            din_fifo_sum_ec0ec3ec6(215 downto 192) <= mpsum8_ec0ec3ec6;
            din_fifo_sum_ec0ec3ec6(239 downto 216) <= mpsum9_ec0ec3ec6;
            din_fifo_sum_ec0ec3ec6(263 downto 240) <= mpsum10_ec0ec3ec6;
            din_fifo_sum_ec0ec3ec6(287 downto 264) <= mpsum11_ec0ec3ec6;
            din_fifo_sum_ec0ec3ec6(311 downto 288) <= mpsum12_ec0ec3ec6;
            din_fifo_sum_ec0ec3ec6(335 downto 312) <= mpsum13_ec0ec3ec6;
            din_fifo_sum_ec0ec3ec6(359 downto 336) <= mpsum14_ec0ec3ec6;
            din_fifo_sum_ec0ec3ec6(383 downto 360) <= mpsum15_ec0ec3ec6;
            din_fifo_sum_ec0ec3ec6(407 downto 384) <= mpsum16_ec0ec3ec6;
            din_fifo_sum_ec0ec3ec6(431 downto 408) <= mpsum17_ec0ec3ec6;
            din_fifo_sum_ec0ec3ec6(455 downto 432) <= mpsum18_ec0ec3ec6;
            din_fifo_sum_ec0ec3ec6(479 downto 456) <= mpsum19_ec0ec3ec6;
            din_fifo_sum_ec0ec3ec6(503 downto 480) <= mpsum20_ec0ec3ec6;
            din_fifo_sum_ec0ec3ec6(527 downto 504) <= mpsum21_ec0ec3ec6;
            din_fifo_sum_ec0ec3ec6(551 downto 528) <= mpsum22_ec0ec3ec6;
            din_fifo_sum_ec0ec3ec6(575 downto 552) <= mpsum23_ec0ec3ec6;
            wr_en_fifo_sum_ec0ec3ec6 <= '1';
        else
            wr_en_fifo_sum_ec0ec3ec6 <= '0';
        end if;
    end if;
end process;

write_fifo_sum_ec1ec4ec7 : process (CLOCK)
begin 
    if (CLOCK'event and CLOCK = '1') then
        if (mpsum_ready_ec1ec4ec7 = '1') then
            din_fifo_sum_ec1ec4ec7(23 downto 0) <= mpsum0_ec1ec4ec7;
            din_fifo_sum_ec1ec4ec7(47 downto 24) <= mpsum1_ec1ec4ec7;
            din_fifo_sum_ec1ec4ec7(71 downto 48) <= mpsum2_ec1ec4ec7;
            din_fifo_sum_ec1ec4ec7(95 downto 72) <= mpsum3_ec1ec4ec7;
            din_fifo_sum_ec1ec4ec7(119 downto 96) <= mpsum4_ec1ec4ec7;
            din_fifo_sum_ec1ec4ec7(143 downto 120) <= mpsum5_ec1ec4ec7;
            din_fifo_sum_ec1ec4ec7(167 downto 144) <= mpsum6_ec1ec4ec7;
            din_fifo_sum_ec1ec4ec7(191 downto 168) <= mpsum7_ec1ec4ec7;
            din_fifo_sum_ec1ec4ec7(215 downto 192) <= mpsum8_ec1ec4ec7;
            din_fifo_sum_ec1ec4ec7(239 downto 216) <= mpsum9_ec1ec4ec7;
            din_fifo_sum_ec1ec4ec7(263 downto 240) <= mpsum10_ec1ec4ec7;
            din_fifo_sum_ec1ec4ec7(287 downto 264) <= mpsum11_ec1ec4ec7;
            din_fifo_sum_ec1ec4ec7(311 downto 288) <= mpsum12_ec1ec4ec7;
            din_fifo_sum_ec1ec4ec7(335 downto 312) <= mpsum13_ec1ec4ec7;
            din_fifo_sum_ec1ec4ec7(359 downto 336) <= mpsum14_ec1ec4ec7;
            din_fifo_sum_ec1ec4ec7(383 downto 360) <= mpsum15_ec1ec4ec7;
            din_fifo_sum_ec1ec4ec7(407 downto 384) <= mpsum16_ec1ec4ec7;
            din_fifo_sum_ec1ec4ec7(431 downto 408) <= mpsum17_ec1ec4ec7;
            din_fifo_sum_ec1ec4ec7(455 downto 432) <= mpsum18_ec1ec4ec7;
            din_fifo_sum_ec1ec4ec7(479 downto 456) <= mpsum19_ec1ec4ec7;
            din_fifo_sum_ec1ec4ec7(503 downto 480) <= mpsum20_ec1ec4ec7;
            din_fifo_sum_ec1ec4ec7(527 downto 504) <= mpsum21_ec1ec4ec7;
            din_fifo_sum_ec1ec4ec7(551 downto 528) <= mpsum22_ec1ec4ec7;
            din_fifo_sum_ec1ec4ec7(575 downto 552) <= mpsum23_ec1ec4ec7;
            wr_en_fifo_sum_ec1ec4ec7 <= '1';
        else
            wr_en_fifo_sum_ec1ec4ec7 <= '0';
        end if;
    end if;
end process;

write_fifo_sum_ec2ec5ec8 : process (CLOCK)
begin 
    if (CLOCK'event and CLOCK = '1') then
        if (mpsum_ready_ec2ec5ec8 = '1') then
            din_fifo_sum_ec2ec5ec8(23 downto 0) <= mpsum0_ec2ec5ec8;
            din_fifo_sum_ec2ec5ec8(47 downto 24) <= mpsum1_ec2ec5ec8;
            din_fifo_sum_ec2ec5ec8(71 downto 48) <= mpsum2_ec2ec5ec8;
            din_fifo_sum_ec2ec5ec8(95 downto 72) <= mpsum3_ec2ec5ec8;
            din_fifo_sum_ec2ec5ec8(119 downto 96) <= mpsum4_ec2ec5ec8;
            din_fifo_sum_ec2ec5ec8(143 downto 120) <= mpsum5_ec2ec5ec8;
            din_fifo_sum_ec2ec5ec8(167 downto 144) <= mpsum6_ec2ec5ec8;
            din_fifo_sum_ec2ec5ec8(191 downto 168) <= mpsum7_ec2ec5ec8;
            din_fifo_sum_ec2ec5ec8(215 downto 192) <= mpsum8_ec2ec5ec8;
            din_fifo_sum_ec2ec5ec8(239 downto 216) <= mpsum9_ec2ec5ec8;
            din_fifo_sum_ec2ec5ec8(263 downto 240) <= mpsum10_ec2ec5ec8;
            din_fifo_sum_ec2ec5ec8(287 downto 264) <= mpsum11_ec2ec5ec8;
            din_fifo_sum_ec2ec5ec8(311 downto 288) <= mpsum12_ec2ec5ec8;
            din_fifo_sum_ec2ec5ec8(335 downto 312) <= mpsum13_ec2ec5ec8;
            din_fifo_sum_ec2ec5ec8(359 downto 336) <= mpsum14_ec2ec5ec8;
            din_fifo_sum_ec2ec5ec8(383 downto 360) <= mpsum15_ec2ec5ec8;
            din_fifo_sum_ec2ec5ec8(407 downto 384) <= mpsum16_ec2ec5ec8;
            din_fifo_sum_ec2ec5ec8(431 downto 408) <= mpsum17_ec2ec5ec8;
            din_fifo_sum_ec2ec5ec8(455 downto 432) <= mpsum18_ec2ec5ec8;
            din_fifo_sum_ec2ec5ec8(479 downto 456) <= mpsum19_ec2ec5ec8;
            din_fifo_sum_ec2ec5ec8(503 downto 480) <= mpsum20_ec2ec5ec8;
            din_fifo_sum_ec2ec5ec8(527 downto 504) <= mpsum21_ec2ec5ec8;
            din_fifo_sum_ec2ec5ec8(551 downto 528) <= mpsum22_ec2ec5ec8;
            din_fifo_sum_ec2ec5ec8(575 downto 552) <= mpsum23_ec2ec5ec8;
            wr_en_fifo_sum_ec2ec5ec8 <= '1';
        else
            wr_en_fifo_sum_ec2ec5ec8 <= '0';
        end if;
    end if;
end process;

--Read MacroPixel sum from FIFO_SUM and write value in AXI_FIFO_SUM
write_axi_fifo_sum : process (CLOCK)
begin 
    if (CLOCK'event and CLOCK = '1') then
        case (state_axi_fifo_sum) is
            when s0 =>
                if (empty_fifo_sum_ec0ec3ec6 = '0') then
                    rd_en_fifo_sum_ec0ec3ec6 <= '1';--Enable read FIFO_SUM EC0EC3EC6
                    state_axi_fifo_sum <= s1;
                end if;
                s_axis_tlast_sum <= '0';
                s_axis_tvalid_sum <= '0';
            when s1 =>--FIFO DELAY
                s_axis_tvalid_sum <= '0';
                state_axi_fifo_sum <= s2;
                rd_en_fifo_sum_ec0ec3ec6 <= '0';
            when s2 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec0ec3ec6(23 downto 0);
                s_axis_tvalid_sum <= '1';--Write MACROPIXEL line0 value
                state_axi_fifo_sum <= s3;
            when s3 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec0ec3ec6(47 downto 24);
                state_axi_fifo_sum <= s4;
            when s4 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec0ec3ec6(71 downto 48);
                state_axi_fifo_sum <= s5;
            when s5 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec0ec3ec6(95 downto 72);
                state_axi_fifo_sum <= s6;
            when s6 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec0ec3ec6(119 downto 96);
                state_axi_fifo_sum <= s7;
            when s7 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec0ec3ec6(143 downto 120);
                state_axi_fifo_sum <= s8;
            when s8 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec0ec3ec6(167 downto 144);
                state_axi_fifo_sum <= s9;
            when s9 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec0ec3ec6(191 downto 168);
                state_axi_fifo_sum <= s10;
            when s10 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec0ec3ec6(215 downto 192);
                state_axi_fifo_sum <= s11;
            when s11 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec0ec3ec6(239 downto 216);
                state_axi_fifo_sum <= s12;
            when s12 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec0ec3ec6(263 downto 240);
                state_axi_fifo_sum <= s13;
            when s13 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec0ec3ec6(287 downto 264);
                state_axi_fifo_sum <= s14;
            when s14 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec0ec3ec6(311 downto 288);
                state_axi_fifo_sum <= s15;
            when s15 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec0ec3ec6(335 downto 312);
                state_axi_fifo_sum <= s16;
            when s16 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec0ec3ec6(359 downto 336);
                state_axi_fifo_sum <= s17;
            when s17 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec0ec3ec6(383 downto 360);
                state_axi_fifo_sum <= s18;
            when s18 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec0ec3ec6(407 downto 384);
                state_axi_fifo_sum <= s19;
            when s19 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec0ec3ec6(431 downto 408);
                state_axi_fifo_sum <= s20;
            when s20 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec0ec3ec6(455 downto 432);
                state_axi_fifo_sum <= s21;
            when s21 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec0ec3ec6(479 downto 456);
                state_axi_fifo_sum <= s22;
            when s22 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec0ec3ec6(503 downto 480);
                state_axi_fifo_sum <= s23;
            when s23 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec0ec3ec6(527 downto 504);
                state_axi_fifo_sum <= s24;
            when s24 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec0ec3ec6(551 downto 528);
                state_axi_fifo_sum <= s25;
            when s25 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec0ec3ec6(575 downto 552);
                if (empty_fifo_sum_ec0ec3ec6 = '1') then--Last Column in FIFO_SUM
                    state_axi_fifo_sum <= s26;
                    rd_en_fifo_sum_ec1ec4ec7 <= '1';
                else
                    state_axi_fifo_sum <= s1;
                    rd_en_fifo_sum_ec0ec3ec6 <= '1';
                end if;
            when s26 =>--FIFO DELAY
                s_axis_tvalid_sum <= '0';
                rd_en_fifo_sum_ec1ec4ec7 <= '0';
                state_axi_fifo_sum <= s27;
            when s27 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec1ec4ec7(23 downto 0);
                s_axis_tvalid_sum <= '1';--Write MACROPIXEL line0 value
                state_axi_fifo_sum <= s28;
            when s28 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec1ec4ec7(47 downto 24);
                state_axi_fifo_sum <= s29;
            when s29 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec1ec4ec7(71 downto 48);
                state_axi_fifo_sum <= s30;
            when s30 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec1ec4ec7(95 downto 72);
                state_axi_fifo_sum <= s31;
            when s31 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec1ec4ec7(119 downto 96);
                state_axi_fifo_sum <= s32;
            when s32 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec1ec4ec7(143 downto 120);
                state_axi_fifo_sum <= s33;
            when s33 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec1ec4ec7(167 downto 144);
                state_axi_fifo_sum <= s34;
            when s34 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec1ec4ec7(191 downto 168);
                state_axi_fifo_sum <= s35;
            when s35 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec1ec4ec7(215 downto 192);
                state_axi_fifo_sum <= s36;
            when s36 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec1ec4ec7(239 downto 216);
                state_axi_fifo_sum <= s37;
            when s37 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec1ec4ec7(263 downto 240);
                state_axi_fifo_sum <= s38;
            when s38 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec1ec4ec7(287 downto 264);
                state_axi_fifo_sum <= s39;
            when s39 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec1ec4ec7(311 downto 288);
                state_axi_fifo_sum <= s40;
            when s40 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec1ec4ec7(335 downto 312);
                state_axi_fifo_sum <= s41;
            when s41 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec1ec4ec7(359 downto 336);
                state_axi_fifo_sum <= s42;
            when s42 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec1ec4ec7(383 downto 360);
                state_axi_fifo_sum <= s43;
            when s43 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec1ec4ec7(407 downto 384);
                state_axi_fifo_sum <= s44;
            when s44 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec1ec4ec7(431 downto 408);
                state_axi_fifo_sum <= s45;
            when s45 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec1ec4ec7(455 downto 432);
                state_axi_fifo_sum <= s46;
            when s46 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec1ec4ec7(479 downto 456);
                state_axi_fifo_sum <= s47;
            when s47 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec1ec4ec7(503 downto 480);
                state_axi_fifo_sum <= s48;
            when s48 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec1ec4ec7(527 downto 504);
                state_axi_fifo_sum <= s49;
            when s49 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec1ec4ec7(551 downto 528);
                state_axi_fifo_sum <= s50;
            when s50 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec1ec4ec7(575 downto 552);
                if (empty_fifo_sum_ec1ec4ec7 = '1') then--Last Column in FIFO_SUM
                    rd_en_fifo_sum_ec2ec5ec8 <= '1';
                    state_axi_fifo_sum <= s51;
                else
                    rd_en_fifo_sum_ec1ec4ec7 <= '1';
                    state_axi_fifo_sum <= s26;
                end if;
            when s51 =>--FIFO DELAY
                s_axis_tvalid_sum <= '0';
                rd_en_fifo_sum_ec2ec5ec8 <= '0';
                state_axi_fifo_sum <= s52;
            when s52 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec2ec5ec8(23 downto 0);
                s_axis_tvalid_sum <= '1';--Write MACROPIXEL line0 value
                state_axi_fifo_sum <= s53;
            when s53 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec2ec5ec8(47 downto 24);
                state_axi_fifo_sum <= s54;
            when s54 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec2ec5ec8(71 downto 48);
                state_axi_fifo_sum <= s55;
            when s55 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec2ec5ec8(95 downto 72);
                state_axi_fifo_sum <= s56;
            when s56 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec2ec5ec8(119 downto 96);
                state_axi_fifo_sum <= s57;
            when s57 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec2ec5ec8(143 downto 120);
                state_axi_fifo_sum <= s58;
            when s58 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec2ec5ec8(167 downto 144);
                state_axi_fifo_sum <= s59;
            when s59 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec2ec5ec8(191 downto 168);
                state_axi_fifo_sum <= s60;
            when s60 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec2ec5ec8(215 downto 192);
                state_axi_fifo_sum <= s61;
            when s61 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec2ec5ec8(239 downto 216);
                state_axi_fifo_sum <= s62;
            when s62 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec2ec5ec8(263 downto 240);
                state_axi_fifo_sum <= s63;
            when s63 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec2ec5ec8(287 downto 264);
                state_axi_fifo_sum <= s64;
            when s64 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec2ec5ec8(311 downto 288);
                state_axi_fifo_sum <= s65;
            when s65 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec2ec5ec8(335 downto 312);
                state_axi_fifo_sum <= s66;
            when s66 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec2ec5ec8(359 downto 336);
                state_axi_fifo_sum <= s67;
            when s67 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec2ec5ec8(383 downto 360);
                state_axi_fifo_sum <= s68;
            when s68 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec2ec5ec8(407 downto 384);
                state_axi_fifo_sum <= s69;
            when s69 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec2ec5ec8(431 downto 408);
                state_axi_fifo_sum <= s70;
            when s70 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec2ec5ec8(455 downto 432);
                state_axi_fifo_sum <= s71;
            when s71 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec2ec5ec8(479 downto 456);
                state_axi_fifo_sum <= s72;
            when s72 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec2ec5ec8(503 downto 480);
                state_axi_fifo_sum <= s73;
            when s73 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec2ec5ec8(527 downto 504);
                state_axi_fifo_sum <= s74;
            when s74 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec2ec5ec8(551 downto 528);
                state_axi_fifo_sum <= s75;
            when s75 =>
                s_axis_tdata_sum <= "00000000" & dout_fifo_sum_ec2ec5ec8(575 downto 552);
                if (empty_fifo_sum_ec2ec5ec8 = '1') then--Last Column in FIFO_SUM
                    state_axi_fifo_sum <= s0;
                    s_axis_tlast_sum <= '1';
                else
                    state_axi_fifo_sum <= s51;
                    rd_en_fifo_sum_ec2ec5ec8 <= '1';
                end if;
        end case;
    end if;
end process;

macrocell : process (CLOCK)--From 3x1MacroCell to Macrocell with overlays
begin 
    if (CLOCK'event and CLOCK = '1') then
        case (state_macrocell) is
            when s0 =>
                if (mc3x1_ready_ec0ec3ec6 = '1' and mc3x1_ready_ec1ec4ec7 = '1' and mc3x1_ready_ec2ec5ec8 = '1') then
                    ce0_ec0ec3ec6 <= '1';
                    b0_0_ec0ec3ec6 <= mc3x1_0_ec0ec3ec6;--Macrocell 0 Line 0(1/3)
                    b0_1_ec0ec3ec6 <= mc3x1_1_ec0ec3ec6;--Macrocell 0 Line 1(1/3)
                    b0_2_ec0ec3ec6 <= mc3x1_2_ec0ec3ec6;--Macrocell 0 Line 2(1/3)
                    b0_3_ec0ec3ec6 <= mc3x1_3_ec0ec3ec6;--Macrocell 0 Line 3(1/3)
                    b0_4_ec0ec3ec6 <= mc3x1_4_ec0ec3ec6;--Macrocell 0 Line 4(1/3)
                    b0_5_ec0ec3ec6 <= mc3x1_5_ec0ec3ec6;--Macrocell 0 Line 5(1/3)
                    b0_6_ec0ec3ec6 <= mc3x1_6_ec0ec3ec6;--Macrocell 0 Line 6(1/3)
                    b0_7_ec0ec3ec6 <= mc3x1_7_ec0ec3ec6;--Macrocell 0 Line 7(1/3)
                    b0_8_ec0ec3ec6 <= mc3x1_8_ec0ec3ec6;--Macrocell 0 Line 8(1/3)
                    b0_9_ec0ec3ec6 <= mc3x1_9_ec0ec3ec6;--Macrocell 0 Line 9(1/3)
                    b0_10_ec0ec3ec6 <= mc3x1_10_ec0ec3ec6;--Macrocell 0 Line 10(1/3)
                    b0_11_ec0ec3ec6 <= mc3x1_11_ec0ec3ec6;--Macrocell 0 Line 11(1/3)
                    b0_12_ec0ec3ec6 <= mc3x1_12_ec0ec3ec6;--Macrocell 0 Line 12(1/3)
                    b0_13_ec0ec3ec6 <= mc3x1_13_ec0ec3ec6;--Macrocell 0 Line 13(1/3)
                    b0_14_ec0ec3ec6 <= mc3x1_14_ec0ec3ec6;--Macrocell 0 Line 14(1/3)
                    b0_15_ec0ec3ec6 <= mc3x1_15_ec0ec3ec6;--Macrocell 0 Line 15(1/3)
                    b0_16_ec0ec3ec6 <= mc3x1_16_ec0ec3ec6;--Macrocell 0 Line 16(1/3)
                    b0_17_ec0ec3ec6 <= mc3x1_17_ec0ec3ec6;--Macrocell 0 Line 17(1/3)
                    b0_18_ec0ec3ec6 <= mc3x1_18_ec0ec3ec6;--Macrocell 0 Line 18(1/3)
                    b0_19_ec0ec3ec6 <= mc3x1_19_ec0ec3ec6;--Macrocell 0 Line 19(1/3)
                    b0_20_ec0ec3ec6 <= mc3x1_20_ec0ec3ec6;--Macrocell 0 Line 20(1/3)
                    b0_21_ec0ec3ec6 <= mc3x1_21_ec0ec3ec6;--Macrocell 0 Line 21(1/3)
                    
                    ce0_ec1ec4ec7 <= '1';
                    b0_0_ec1ec4ec7 <= mc3x1_0_ec1ec4ec7;--Macrocell 6 (1/3)
                    b0_1_ec1ec4ec7 <= mc3x1_1_ec1ec4ec7;--Macrocell 6 (1/3)
                    b0_2_ec1ec4ec7 <= mc3x1_2_ec1ec4ec7;--Macrocell 6 (1/3)
                    b0_3_ec1ec4ec7 <= mc3x1_3_ec1ec4ec7;--Macrocell 6 (1/3)
                    b0_4_ec1ec4ec7 <= mc3x1_4_ec1ec4ec7;--Macrocell 6 (1/3)
                    b0_5_ec1ec4ec7 <= mc3x1_5_ec1ec4ec7;--Macrocell 6 (1/3)
                    b0_6_ec1ec4ec7 <= mc3x1_6_ec1ec4ec7;--Macrocell 6 (1/3)
                    b0_7_ec1ec4ec7 <= mc3x1_7_ec1ec4ec7;--Macrocell 6 (1/3)
                    b0_8_ec1ec4ec7 <= mc3x1_8_ec1ec4ec7;--Macrocell 6 (1/3)
                    b0_9_ec1ec4ec7 <= mc3x1_9_ec1ec4ec7;--Macrocell 6 (1/3)
                    b0_10_ec1ec4ec7 <= mc3x1_10_ec1ec4ec7;--Macrocell 6 (1/3)
                    b0_11_ec1ec4ec7 <= mc3x1_11_ec1ec4ec7;--Macrocell 6 (1/3)
                    b0_12_ec1ec4ec7 <= mc3x1_12_ec1ec4ec7;--Macrocell 6 (1/3)
                    b0_13_ec1ec4ec7 <= mc3x1_13_ec1ec4ec7;--Macrocell 6 (1/3)
                    b0_14_ec1ec4ec7 <= mc3x1_14_ec1ec4ec7;--Macrocell 6 (1/3)
                    b0_15_ec1ec4ec7 <= mc3x1_15_ec1ec4ec7;--Macrocell 6 (1/3)
                    b0_16_ec1ec4ec7 <= mc3x1_16_ec1ec4ec7;--Macrocell 6 (1/3)
                    b0_17_ec1ec4ec7 <= mc3x1_17_ec1ec4ec7;--Macrocell 6 (1/3)
                    b0_18_ec1ec4ec7 <= mc3x1_18_ec1ec4ec7;--Macrocell 6 (1/3)
                    b0_19_ec1ec4ec7 <= mc3x1_19_ec1ec4ec7;--Macrocell 6 (1/3)
                    b0_20_ec1ec4ec7 <= mc3x1_20_ec1ec4ec7;--Macrocell 6 (1/3)
                    b0_21_ec1ec4ec7 <= mc3x1_21_ec1ec4ec7;--Macrocell 6 (1/3)
                    ce1_ec1ec4ec7 <= '1';
                    b1_0_ec1ec4ec7 <= mc3x1_0_ec1ec4ec7;--Macrocell 7 (1/3)
                    b1_1_ec1ec4ec7 <= mc3x1_1_ec1ec4ec7;--Macrocell 7 (1/3)
                    b1_2_ec1ec4ec7 <= mc3x1_2_ec1ec4ec7;--Macrocell 7 (1/3)
                    b1_3_ec1ec4ec7 <= mc3x1_3_ec1ec4ec7;--Macrocell 7 (1/3)
                    b1_4_ec1ec4ec7 <= mc3x1_4_ec1ec4ec7;--Macrocell 7 (1/3)
                    b1_5_ec1ec4ec7 <= mc3x1_5_ec1ec4ec7;--Macrocell 7 (1/3)
                    b1_6_ec1ec4ec7 <= mc3x1_6_ec1ec4ec7;--Macrocell 7 (1/3)
                    b1_7_ec1ec4ec7 <= mc3x1_7_ec1ec4ec7;--Macrocell 7 (1/3)
                    b1_8_ec1ec4ec7 <= mc3x1_8_ec1ec4ec7;--Macrocell 7 (1/3)
                    b1_9_ec1ec4ec7 <= mc3x1_9_ec1ec4ec7;--Macrocell 7 (1/3)
                    b1_10_ec1ec4ec7 <= mc3x1_10_ec1ec4ec7;--Macrocell 7 (1/3)
                    b1_11_ec1ec4ec7 <= mc3x1_11_ec1ec4ec7;--Macrocell 7 (1/3)
                    b1_12_ec1ec4ec7 <= mc3x1_12_ec1ec4ec7;--Macrocell 7 (1/3)
                    b1_13_ec1ec4ec7 <= mc3x1_13_ec1ec4ec7;--Macrocell 7 (1/3)
                    b1_14_ec1ec4ec7 <= mc3x1_14_ec1ec4ec7;--Macrocell 7 (1/3)
                    b1_15_ec1ec4ec7 <= mc3x1_15_ec1ec4ec7;--Macrocell 7 (1/3)
                    b1_16_ec1ec4ec7 <= mc3x1_16_ec1ec4ec7;--Macrocell 7 (1/3)
                    b1_17_ec1ec4ec7 <= mc3x1_17_ec1ec4ec7;--Macrocell 7 (1/3)
                    b1_18_ec1ec4ec7 <= mc3x1_18_ec1ec4ec7;--Macrocell 7 (1/3)
                    b1_19_ec1ec4ec7 <= mc3x1_19_ec1ec4ec7;--Macrocell 7 (1/3)
                    b1_20_ec1ec4ec7 <= mc3x1_20_ec1ec4ec7;--Macrocell 7 (1/3)
                    b1_21_ec1ec4ec7 <= mc3x1_21_ec1ec4ec7;--Macrocell 7 (1/3)
                    ce2_ec1ec4ec7 <= '1';
                    b2_0_ec1ec4ec7 <= mc3x1_0_ec1ec4ec7;--Macrocell 8 (1/3)
                    b2_1_ec1ec4ec7 <= mc3x1_1_ec1ec4ec7;--Macrocell 8 (1/3)
                    b2_2_ec1ec4ec7 <= mc3x1_2_ec1ec4ec7;--Macrocell 8 (1/3)
                    b2_3_ec1ec4ec7 <= mc3x1_3_ec1ec4ec7;--Macrocell 8 (1/3)
                    b2_4_ec1ec4ec7 <= mc3x1_4_ec1ec4ec7;--Macrocell 8 (1/3)
                    b2_5_ec1ec4ec7 <= mc3x1_5_ec1ec4ec7;--Macrocell 8 (1/3)
                    b2_6_ec1ec4ec7 <= mc3x1_6_ec1ec4ec7;--Macrocell 8 (1/3)
                    b2_7_ec1ec4ec7 <= mc3x1_7_ec1ec4ec7;--Macrocell 8 (1/3)
                    b2_8_ec1ec4ec7 <= mc3x1_8_ec1ec4ec7;--Macrocell 8 (1/3)
                    b2_9_ec1ec4ec7 <= mc3x1_9_ec1ec4ec7;--Macrocell 8 (1/3)
                    b2_10_ec1ec4ec7 <= mc3x1_10_ec1ec4ec7;--Macrocell 8 (1/3)
                    b2_11_ec1ec4ec7 <= mc3x1_11_ec1ec4ec7;--Macrocell 8 (1/3)
                    b2_12_ec1ec4ec7 <= mc3x1_12_ec1ec4ec7;--Macrocell 8 (1/3)
                    b2_13_ec1ec4ec7 <= mc3x1_13_ec1ec4ec7;--Macrocell 8 (1/3)
                    b2_14_ec1ec4ec7 <= mc3x1_14_ec1ec4ec7;--Macrocell 8 (1/3)
                    b2_15_ec1ec4ec7 <= mc3x1_15_ec1ec4ec7;--Macrocell 8 (1/3)
                    b2_16_ec1ec4ec7 <= mc3x1_16_ec1ec4ec7;--Macrocell 8 (1/3)
                    b2_17_ec1ec4ec7 <= mc3x1_17_ec1ec4ec7;--Macrocell 8 (1/3)
                    b2_18_ec1ec4ec7 <= mc3x1_18_ec1ec4ec7;--Macrocell 8 (1/3)
                    b2_19_ec1ec4ec7 <= mc3x1_19_ec1ec4ec7;--Macrocell 8 (1/3)
                    b2_20_ec1ec4ec7 <= mc3x1_20_ec1ec4ec7;--Macrocell 8 (1/3)
                    b2_21_ec1ec4ec7 <= mc3x1_21_ec1ec4ec7;--Macrocell 8 (1/3)
                    
                    ce0_ec2ec5ec8 <= '1';
                    b0_0_ec2ec5ec8 <= mc3x1_0_ec2ec5ec8;--Macrocell 14 (1/3)
                    b0_1_ec2ec5ec8 <= mc3x1_1_ec2ec5ec8;--Macrocell 14 (1/3)
                    b0_2_ec2ec5ec8 <= mc3x1_2_ec2ec5ec8;--Macrocell 14 (1/3)
                    b0_3_ec2ec5ec8 <= mc3x1_3_ec2ec5ec8;--Macrocell 14 (1/3)
                    b0_4_ec2ec5ec8 <= mc3x1_4_ec2ec5ec8;--Macrocell 14 (1/3)
                    b0_5_ec2ec5ec8 <= mc3x1_5_ec2ec5ec8;--Macrocell 14 (1/3)
                    b0_6_ec2ec5ec8 <= mc3x1_6_ec2ec5ec8;--Macrocell 14 (1/3)
                    b0_7_ec2ec5ec8 <= mc3x1_7_ec2ec5ec8;--Macrocell 14 (1/3)
                    b0_8_ec2ec5ec8 <= mc3x1_8_ec2ec5ec8;--Macrocell 14 (1/3)
                    b0_9_ec2ec5ec8 <= mc3x1_9_ec2ec5ec8;--Macrocell 14 (1/3)
                    b0_10_ec2ec5ec8 <= mc3x1_10_ec2ec5ec8;--Macrocell 14 (1/3)
                    b0_11_ec2ec5ec8 <= mc3x1_11_ec2ec5ec8;--Macrocell 14 (1/3)
                    b0_12_ec2ec5ec8 <= mc3x1_12_ec2ec5ec8;--Macrocell 14 (1/3)
                    b0_13_ec2ec5ec8 <= mc3x1_13_ec2ec5ec8;--Macrocell 14 (1/3)
                    b0_14_ec2ec5ec8 <= mc3x1_14_ec2ec5ec8;--Macrocell 14 (1/3)
                    b0_15_ec2ec5ec8 <= mc3x1_15_ec2ec5ec8;--Macrocell 14 (1/3)
                    b0_16_ec2ec5ec8 <= mc3x1_16_ec2ec5ec8;--Macrocell 14 (1/3)
                    b0_17_ec2ec5ec8 <= mc3x1_17_ec2ec5ec8;--Macrocell 14 (1/3)
                    b0_18_ec2ec5ec8 <= mc3x1_18_ec2ec5ec8;--Macrocell 14 (1/3)
                    b0_19_ec2ec5ec8 <= mc3x1_19_ec2ec5ec8;--Macrocell 14 (1/3)
                    b0_20_ec2ec5ec8 <= mc3x1_20_ec2ec5ec8;--Macrocell 14 (1/3)
                    b0_21_ec2ec5ec8 <= mc3x1_21_ec2ec5ec8;--Macrocell 14 (1/3)
                    ce1_ec2ec5ec8 <= '1';
                    b1_0_ec2ec5ec8 <= mc3x1_0_ec2ec5ec8;--Macrocell 15 (1/3)
                    b1_1_ec2ec5ec8 <= mc3x1_1_ec2ec5ec8;--Macrocell 15 (1/3)
                    b1_2_ec2ec5ec8 <= mc3x1_2_ec2ec5ec8;--Macrocell 15 (1/3)
                    b1_3_ec2ec5ec8 <= mc3x1_3_ec2ec5ec8;--Macrocell 15 (1/3)
                    b1_4_ec2ec5ec8 <= mc3x1_4_ec2ec5ec8;--Macrocell 15 (1/3)
                    b1_5_ec2ec5ec8 <= mc3x1_5_ec2ec5ec8;--Macrocell 15 (1/3)
                    b1_6_ec2ec5ec8 <= mc3x1_6_ec2ec5ec8;--Macrocell 15 (1/3)
                    b1_7_ec2ec5ec8 <= mc3x1_7_ec2ec5ec8;--Macrocell 15 (1/3)
                    b1_8_ec2ec5ec8 <= mc3x1_8_ec2ec5ec8;--Macrocell 15 (1/3)
                    b1_9_ec2ec5ec8 <= mc3x1_9_ec2ec5ec8;--Macrocell 15 (1/3)
                    b1_10_ec2ec5ec8 <= mc3x1_10_ec2ec5ec8;--Macrocell 15 (1/3)
                    b1_11_ec2ec5ec8 <= mc3x1_11_ec2ec5ec8;--Macrocell 15 (1/3)
                    b1_12_ec2ec5ec8 <= mc3x1_12_ec2ec5ec8;--Macrocell 15 (1/3)
                    b1_13_ec2ec5ec8 <= mc3x1_13_ec2ec5ec8;--Macrocell 15 (1/3)
                    b1_14_ec2ec5ec8 <= mc3x1_14_ec2ec5ec8;--Macrocell 15 (1/3)
                    b1_15_ec2ec5ec8 <= mc3x1_15_ec2ec5ec8;--Macrocell 15 (1/3)
                    b1_16_ec2ec5ec8 <= mc3x1_16_ec2ec5ec8;--Macrocell 15 (1/3)
                    b1_17_ec2ec5ec8 <= mc3x1_17_ec2ec5ec8;--Macrocell 15 (1/3)
                    b1_18_ec2ec5ec8 <= mc3x1_18_ec2ec5ec8;--Macrocell 15 (1/3)
                    b1_19_ec2ec5ec8 <= mc3x1_19_ec2ec5ec8;--Macrocell 15 (1/3)
                    b1_20_ec2ec5ec8 <= mc3x1_20_ec2ec5ec8;--Macrocell 15 (1/3)
                    b1_21_ec2ec5ec8 <= mc3x1_21_ec2ec5ec8;--Macrocell 15 (1/3)
                    ce2_ec2ec5ec8 <= '1';
                    b2_0_ec2ec5ec8 <= mc3x1_0_ec2ec5ec8;--Macrocell 16 (1/3)
                    b2_1_ec2ec5ec8 <= mc3x1_1_ec2ec5ec8;--Macrocell 16 (1/3)
                    b2_2_ec2ec5ec8 <= mc3x1_2_ec2ec5ec8;--Macrocell 16 (1/3)
                    b2_3_ec2ec5ec8 <= mc3x1_3_ec2ec5ec8;--Macrocell 16 (1/3)
                    b2_4_ec2ec5ec8 <= mc3x1_4_ec2ec5ec8;--Macrocell 16 (1/3)
                    b2_5_ec2ec5ec8 <= mc3x1_5_ec2ec5ec8;--Macrocell 16 (1/3)
                    b2_6_ec2ec5ec8 <= mc3x1_6_ec2ec5ec8;--Macrocell 16 (1/3)
                    b2_7_ec2ec5ec8 <= mc3x1_7_ec2ec5ec8;--Macrocell 16 (1/3)
                    b2_8_ec2ec5ec8 <= mc3x1_8_ec2ec5ec8;--Macrocell 16 (1/3)
                    b2_9_ec2ec5ec8 <= mc3x1_9_ec2ec5ec8;--Macrocell 16 (1/3)
                    b2_10_ec2ec5ec8 <= mc3x1_10_ec2ec5ec8;--Macrocell 16 (1/3)
                    b2_11_ec2ec5ec8 <= mc3x1_11_ec2ec5ec8;--Macrocell 16 (1/3)
                    b2_12_ec2ec5ec8 <= mc3x1_12_ec2ec5ec8;--Macrocell 16 (1/3)
                    b2_13_ec2ec5ec8 <= mc3x1_13_ec2ec5ec8;--Macrocell 16 (1/3)
                    b2_14_ec2ec5ec8 <= mc3x1_14_ec2ec5ec8;--Macrocell 16 (1/3)
                    b2_15_ec2ec5ec8 <= mc3x1_15_ec2ec5ec8;--Macrocell 16 (1/3)
                    b2_16_ec2ec5ec8 <= mc3x1_16_ec2ec5ec8;--Macrocell 16 (1/3)
                    b2_17_ec2ec5ec8 <= mc3x1_17_ec2ec5ec8;--Macrocell 16 (1/3)
                    b2_18_ec2ec5ec8 <= mc3x1_18_ec2ec5ec8;--Macrocell 16 (1/3)
                    b2_19_ec2ec5ec8 <= mc3x1_19_ec2ec5ec8;--Macrocell 16 (1/3)
                    b2_20_ec2ec5ec8 <= mc3x1_20_ec2ec5ec8;--Macrocell 16 (1/3)
                    b2_21_ec2ec5ec8 <= mc3x1_21_ec2ec5ec8;--Macrocell 16 (1/3)
                    
                    state_macrocell <= s1;
                end if;
                sclr2_ec0ec3ec6 <= '0';--Reset SCLR for "state_macrocell" s26->s0
                sclr0_ec1ec4ec7 <= '0';
                sclr1_ec1ec4ec7 <= '0';
                sclr4_ec1ec4ec7 <= '0';
                sclr0_ec2ec5ec8 <= '0';
                sclr1_ec2ec5ec8 <= '0';
                sclr4_ec2ec5ec8 <= '0';
            when s1 =>
                    ce0_ec0ec3ec6 <= '0';
                    ce1_ec0ec3ec6 <= '0';
                    ce2_ec0ec3ec6 <= '0';
                    
                    ce0_ec1ec4ec7 <= '0';
                    ce1_ec1ec4ec7 <= '0';
                    ce2_ec1ec4ec7 <= '0';
                    ce3_ec1ec4ec7 <= '0';
                    ce4_ec1ec4ec7 <= '0';
                    
                    ce0_ec2ec5ec8 <= '0';
                    ce1_ec2ec5ec8 <= '0';
                    ce2_ec2ec5ec8 <= '0';
                    ce3_ec2ec5ec8 <= '0';
                    ce4_ec2ec5ec8 <= '0';
                    
                    sclr0_ec0ec3ec6 <= '0';
                    sclr1_ec0ec3ec6 <= '0';
                    sclr2_ec0ec3ec6 <= '0';
                    
                    sclr0_ec1ec4ec7 <= '0';
                    sclr1_ec1ec4ec7 <= '0';
                    sclr2_ec1ec4ec7 <= '0';
                    sclr3_ec1ec4ec7 <= '0';
                    sclr4_ec1ec4ec7 <= '0';
                    
                    sclr0_ec2ec5ec8 <= '0';
                    sclr1_ec2ec5ec8 <= '0';
                    sclr2_ec2ec5ec8 <= '0';
                    sclr3_ec2ec5ec8 <= '0';
                    sclr4_ec2ec5ec8 <= '0';
                    
                    state_macrocell <= s2;
            when s2 =>
                if (mc3x1_ready_ec0ec3ec6 = '1' and mc3x1_ready_ec1ec4ec7 = '1' and mc3x1_ready_ec2ec5ec8 = '1') then
                    ce0_ec0ec3ec6 <= '1';
                    b0_0_ec0ec3ec6 <= mc3x1_0_ec0ec3ec6;--Macrocell 0 (2/3)
                    b0_1_ec0ec3ec6 <= mc3x1_1_ec0ec3ec6;--Macrocell 0 (2/3)
                    b0_2_ec0ec3ec6 <= mc3x1_2_ec0ec3ec6;--Macrocell 0 (2/3)
                    b0_3_ec0ec3ec6 <= mc3x1_3_ec0ec3ec6;--Macrocell 0 (2/3)
                    b0_4_ec0ec3ec6 <= mc3x1_4_ec0ec3ec6;--Macrocell 0 (2/3)
                    b0_5_ec0ec3ec6 <= mc3x1_5_ec0ec3ec6;--Macrocell 0 (2/3)
                    b0_6_ec0ec3ec6 <= mc3x1_6_ec0ec3ec6;--Macrocell 0 (2/3)
                    b0_7_ec0ec3ec6 <= mc3x1_7_ec0ec3ec6;--Macrocell 0 (2/3)
                    b0_8_ec0ec3ec6 <= mc3x1_8_ec0ec3ec6;--Macrocell 0 (2/3)
                    b0_9_ec0ec3ec6 <= mc3x1_9_ec0ec3ec6;--Macrocell 0 (2/3)
                    b0_10_ec0ec3ec6 <= mc3x1_10_ec0ec3ec6;--Macrocell 0 (2/3)
                    b0_11_ec0ec3ec6 <= mc3x1_11_ec0ec3ec6;--Macrocell 0 (2/3)
                    b0_12_ec0ec3ec6 <= mc3x1_12_ec0ec3ec6;--Macrocell 0 (2/3)
                    b0_13_ec0ec3ec6 <= mc3x1_13_ec0ec3ec6;--Macrocell 0 (2/3)
                    b0_14_ec0ec3ec6 <= mc3x1_14_ec0ec3ec6;--Macrocell 0 (2/3)
                    b0_15_ec0ec3ec6 <= mc3x1_15_ec0ec3ec6;--Macrocell 0 (2/3)
                    b0_16_ec0ec3ec6 <= mc3x1_16_ec0ec3ec6;--Macrocell 0 (2/3)
                    b0_17_ec0ec3ec6 <= mc3x1_17_ec0ec3ec6;--Macrocell 0 (2/3)
                    b0_18_ec0ec3ec6 <= mc3x1_18_ec0ec3ec6;--Macrocell 0 (2/3)
                    b0_19_ec0ec3ec6 <= mc3x1_19_ec0ec3ec6;--Macrocell 0 (2/3)
                    b0_20_ec0ec3ec6 <= mc3x1_20_ec0ec3ec6;--Macrocell 0 (2/3)
                    b0_21_ec0ec3ec6 <= mc3x1_21_ec0ec3ec6;--Macrocell 0 (2/3)
                    ce1_ec0ec3ec6 <= '1';
                    b1_0_ec0ec3ec6 <= mc3x1_0_ec0ec3ec6;--Macrocell 1 (1/3)
                    b1_1_ec0ec3ec6 <= mc3x1_1_ec0ec3ec6;--Macrocell 1 (1/3)
                    b1_2_ec0ec3ec6 <= mc3x1_2_ec0ec3ec6;--Macrocell 1 (1/3)
                    b1_3_ec0ec3ec6 <= mc3x1_3_ec0ec3ec6;--Macrocell 1 (1/3)
                    b1_4_ec0ec3ec6 <= mc3x1_4_ec0ec3ec6;--Macrocell 1 (1/3)
                    b1_5_ec0ec3ec6 <= mc3x1_5_ec0ec3ec6;--Macrocell 1 (1/3)
                    b1_6_ec0ec3ec6 <= mc3x1_6_ec0ec3ec6;--Macrocell 1 (1/3)
                    b1_7_ec0ec3ec6 <= mc3x1_7_ec0ec3ec6;--Macrocell 1 (1/3)
                    b1_8_ec0ec3ec6 <= mc3x1_8_ec0ec3ec6;--Macrocell 1 (1/3)
                    b1_9_ec0ec3ec6 <= mc3x1_9_ec0ec3ec6;--Macrocell 1 (1/3)
                    b1_10_ec0ec3ec6 <= mc3x1_10_ec0ec3ec6;--Macrocell 1 (1/3)
                    b1_11_ec0ec3ec6 <= mc3x1_11_ec0ec3ec6;--Macrocell 1 (1/3)
                    b1_12_ec0ec3ec6 <= mc3x1_12_ec0ec3ec6;--Macrocell 1 (1/3)
                    b1_13_ec0ec3ec6 <= mc3x1_13_ec0ec3ec6;--Macrocell 1 (1/3)
                    b1_14_ec0ec3ec6 <= mc3x1_14_ec0ec3ec6;--Macrocell 1 (1/3)
                    b1_15_ec0ec3ec6 <= mc3x1_15_ec0ec3ec6;--Macrocell 1 (1/3)
                    b1_16_ec0ec3ec6 <= mc3x1_16_ec0ec3ec6;--Macrocell 1 (1/3)
                    b1_17_ec0ec3ec6 <= mc3x1_17_ec0ec3ec6;--Macrocell 1 (1/3)
                    b1_18_ec0ec3ec6 <= mc3x1_18_ec0ec3ec6;--Macrocell 1 (1/3)
                    b1_19_ec0ec3ec6 <= mc3x1_19_ec0ec3ec6;--Macrocell 1 (1/3)
                    b1_20_ec0ec3ec6 <= mc3x1_20_ec0ec3ec6;--Macrocell 1 (1/3)
                    b1_21_ec0ec3ec6 <= mc3x1_21_ec0ec3ec6;--Macrocell 1 (1/3)
                    
                    ce1_ec1ec4ec7 <= '1';
                    b1_0_ec1ec4ec7 <= mc3x1_0_ec1ec4ec7;--Macrocell 7 (2/3)
                    b1_1_ec1ec4ec7 <= mc3x1_1_ec1ec4ec7;--Macrocell 7 (2/3)
                    b1_2_ec1ec4ec7 <= mc3x1_2_ec1ec4ec7;--Macrocell 7 (2/3)
                    b1_3_ec1ec4ec7 <= mc3x1_3_ec1ec4ec7;--Macrocell 7 (2/3)
                    b1_4_ec1ec4ec7 <= mc3x1_4_ec1ec4ec7;--Macrocell 7 (2/3)
                    b1_5_ec1ec4ec7 <= mc3x1_5_ec1ec4ec7;--Macrocell 7 (2/3)
                    b1_6_ec1ec4ec7 <= mc3x1_6_ec1ec4ec7;--Macrocell 7 (2/3)
                    b1_7_ec1ec4ec7 <= mc3x1_7_ec1ec4ec7;--Macrocell 7 (2/3)
                    b1_8_ec1ec4ec7 <= mc3x1_8_ec1ec4ec7;--Macrocell 7 (2/3)
                    b1_9_ec1ec4ec7 <= mc3x1_9_ec1ec4ec7;--Macrocell 7 (2/3)
                    b1_10_ec1ec4ec7 <= mc3x1_10_ec1ec4ec7;--Macrocell 7 (2/3)
                    b1_11_ec1ec4ec7 <= mc3x1_11_ec1ec4ec7;--Macrocell 7 (2/3)
                    b1_12_ec1ec4ec7 <= mc3x1_12_ec1ec4ec7;--Macrocell 7 (2/3)
                    b1_13_ec1ec4ec7 <= mc3x1_13_ec1ec4ec7;--Macrocell 7 (2/3)
                    b1_14_ec1ec4ec7 <= mc3x1_14_ec1ec4ec7;--Macrocell 7 (2/3)
                    b1_15_ec1ec4ec7 <= mc3x1_15_ec1ec4ec7;--Macrocell 7 (2/3)
                    b1_16_ec1ec4ec7 <= mc3x1_16_ec1ec4ec7;--Macrocell 7 (2/3)
                    b1_17_ec1ec4ec7 <= mc3x1_17_ec1ec4ec7;--Macrocell 7 (2/3)
                    b1_18_ec1ec4ec7 <= mc3x1_18_ec1ec4ec7;--Macrocell 7 (2/3)
                    b1_19_ec1ec4ec7 <= mc3x1_19_ec1ec4ec7;--Macrocell 7 (2/3)
                    b1_20_ec1ec4ec7 <= mc3x1_20_ec1ec4ec7;--Macrocell 7 (2/3)
                    b1_21_ec1ec4ec7 <= mc3x1_21_ec1ec4ec7;--Macrocell 7 (2/3)
                    ce2_ec1ec4ec7 <= '1';
                    b2_0_ec1ec4ec7 <= mc3x1_0_ec1ec4ec7;--Macrocell 8 (2/3)
                    b2_1_ec1ec4ec7 <= mc3x1_1_ec1ec4ec7;--Macrocell 8 (2/3)
                    b2_2_ec1ec4ec7 <= mc3x1_2_ec1ec4ec7;--Macrocell 8 (2/3)
                    b2_3_ec1ec4ec7 <= mc3x1_3_ec1ec4ec7;--Macrocell 8 (2/3)
                    b2_4_ec1ec4ec7 <= mc3x1_4_ec1ec4ec7;--Macrocell 8 (2/3)
                    b2_5_ec1ec4ec7 <= mc3x1_5_ec1ec4ec7;--Macrocell 8 (2/3)
                    b2_6_ec1ec4ec7 <= mc3x1_6_ec1ec4ec7;--Macrocell 8 (2/3)
                    b2_7_ec1ec4ec7 <= mc3x1_7_ec1ec4ec7;--Macrocell 8 (2/3)
                    b2_8_ec1ec4ec7 <= mc3x1_8_ec1ec4ec7;--Macrocell 8 (2/3)
                    b2_9_ec1ec4ec7 <= mc3x1_9_ec1ec4ec7;--Macrocell 8 (2/3)
                    b2_10_ec1ec4ec7 <= mc3x1_10_ec1ec4ec7;--Macrocell 8 (2/3)
                    b2_11_ec1ec4ec7 <= mc3x1_11_ec1ec4ec7;--Macrocell 8 (2/3)
                    b2_12_ec1ec4ec7 <= mc3x1_12_ec1ec4ec7;--Macrocell 8 (2/3)
                    b2_13_ec1ec4ec7 <= mc3x1_13_ec1ec4ec7;--Macrocell 8 (2/3)
                    b2_14_ec1ec4ec7 <= mc3x1_14_ec1ec4ec7;--Macrocell 8 (2/3)
                    b2_15_ec1ec4ec7 <= mc3x1_15_ec1ec4ec7;--Macrocell 8 (2/3)
                    b2_16_ec1ec4ec7 <= mc3x1_16_ec1ec4ec7;--Macrocell 8 (2/3)
                    b2_17_ec1ec4ec7 <= mc3x1_17_ec1ec4ec7;--Macrocell 8 (2/3)
                    b2_18_ec1ec4ec7 <= mc3x1_18_ec1ec4ec7;--Macrocell 8 (2/3)
                    b2_19_ec1ec4ec7 <= mc3x1_19_ec1ec4ec7;--Macrocell 8 (2/3)
                    b2_20_ec1ec4ec7 <= mc3x1_20_ec1ec4ec7;--Macrocell 8 (2/3)
                    b2_21_ec1ec4ec7 <= mc3x1_21_ec1ec4ec7;--Macrocell 8 (2/3)
                    ce3_ec1ec4ec7 <= '1';
                    b3_0_ec1ec4ec7 <= mc3x1_0_ec1ec4ec7;--Macrocell 9 (1/3)
                    b3_1_ec1ec4ec7 <= mc3x1_1_ec1ec4ec7;--Macrocell 9 (1/3)
                    b3_2_ec1ec4ec7 <= mc3x1_2_ec1ec4ec7;--Macrocell 9 (1/3)
                    b3_3_ec1ec4ec7 <= mc3x1_3_ec1ec4ec7;--Macrocell 9 (1/3)
                    b3_4_ec1ec4ec7 <= mc3x1_4_ec1ec4ec7;--Macrocell 9 (1/3)
                    b3_5_ec1ec4ec7 <= mc3x1_5_ec1ec4ec7;--Macrocell 9 (1/3)
                    b3_6_ec1ec4ec7 <= mc3x1_6_ec1ec4ec7;--Macrocell 9 (1/3)
                    b3_7_ec1ec4ec7 <= mc3x1_7_ec1ec4ec7;--Macrocell 9 (1/3)
                    b3_8_ec1ec4ec7 <= mc3x1_8_ec1ec4ec7;--Macrocell 9 (1/3)
                    b3_9_ec1ec4ec7 <= mc3x1_9_ec1ec4ec7;--Macrocell 9 (1/3)
                    b3_10_ec1ec4ec7 <= mc3x1_10_ec1ec4ec7;--Macrocell 9 (1/3)
                    b3_11_ec1ec4ec7 <= mc3x1_11_ec1ec4ec7;--Macrocell 9 (1/3)
                    b3_12_ec1ec4ec7 <= mc3x1_12_ec1ec4ec7;--Macrocell 9 (1/3)
                    b3_13_ec1ec4ec7 <= mc3x1_13_ec1ec4ec7;--Macrocell 9 (1/3)
                    b3_14_ec1ec4ec7 <= mc3x1_14_ec1ec4ec7;--Macrocell 9 (1/3)
                    b3_15_ec1ec4ec7 <= mc3x1_15_ec1ec4ec7;--Macrocell 9 (1/3)
                    b3_16_ec1ec4ec7 <= mc3x1_16_ec1ec4ec7;--Macrocell 9 (1/3)
                    b3_17_ec1ec4ec7 <= mc3x1_17_ec1ec4ec7;--Macrocell 9 (1/3)
                    b3_18_ec1ec4ec7 <= mc3x1_18_ec1ec4ec7;--Macrocell 9 (1/3)
                    b3_19_ec1ec4ec7 <= mc3x1_19_ec1ec4ec7;--Macrocell 9 (1/3)
                    b3_20_ec1ec4ec7 <= mc3x1_20_ec1ec4ec7;--Macrocell 9 (1/3)
                    b3_21_ec1ec4ec7 <= mc3x1_21_ec1ec4ec7;--Macrocell 9 (1/3)
                    
                    ce1_ec2ec5ec8 <= '1';
                    b1_0_ec2ec5ec8 <= mc3x1_0_ec2ec5ec8;--Macrocell 15 (2/3)
                    b1_1_ec2ec5ec8 <= mc3x1_1_ec2ec5ec8;--Macrocell 15 (2/3)
                    b1_2_ec2ec5ec8 <= mc3x1_2_ec2ec5ec8;--Macrocell 15 (2/3)
                    b1_3_ec2ec5ec8 <= mc3x1_3_ec2ec5ec8;--Macrocell 15 (2/3)
                    b1_4_ec2ec5ec8 <= mc3x1_4_ec2ec5ec8;--Macrocell 15 (2/3)
                    b1_5_ec2ec5ec8 <= mc3x1_5_ec2ec5ec8;--Macrocell 15 (2/3)
                    b1_6_ec2ec5ec8 <= mc3x1_6_ec2ec5ec8;--Macrocell 15 (2/3)
                    b1_7_ec2ec5ec8 <= mc3x1_7_ec2ec5ec8;--Macrocell 15 (2/3)
                    b1_8_ec2ec5ec8 <= mc3x1_8_ec2ec5ec8;--Macrocell 15 (2/3)
                    b1_9_ec2ec5ec8 <= mc3x1_9_ec2ec5ec8;--Macrocell 15 (2/3)
                    b1_10_ec2ec5ec8 <= mc3x1_10_ec2ec5ec8;--Macrocell 15 (2/3)
                    b1_11_ec2ec5ec8 <= mc3x1_11_ec2ec5ec8;--Macrocell 15 (2/3)
                    b1_12_ec2ec5ec8 <= mc3x1_12_ec2ec5ec8;--Macrocell 15 (2/3)
                    b1_13_ec2ec5ec8 <= mc3x1_13_ec2ec5ec8;--Macrocell 15 (2/3)
                    b1_14_ec2ec5ec8 <= mc3x1_14_ec2ec5ec8;--Macrocell 15 (2/3)
                    b1_15_ec2ec5ec8 <= mc3x1_15_ec2ec5ec8;--Macrocell 15 (2/3)
                    b1_16_ec2ec5ec8 <= mc3x1_16_ec2ec5ec8;--Macrocell 15 (2/3)
                    b1_17_ec2ec5ec8 <= mc3x1_17_ec2ec5ec8;--Macrocell 15 (2/3)
                    b1_18_ec2ec5ec8 <= mc3x1_18_ec2ec5ec8;--Macrocell 15 (2/3)
                    b1_19_ec2ec5ec8 <= mc3x1_19_ec2ec5ec8;--Macrocell 15 (2/3)
                    b1_20_ec2ec5ec8 <= mc3x1_20_ec2ec5ec8;--Macrocell 15 (2/3)
                    b1_21_ec2ec5ec8 <= mc3x1_21_ec2ec5ec8;--Macrocell 15 (2/3)
                    ce2_ec2ec5ec8 <= '1';
                    b2_0_ec2ec5ec8 <= mc3x1_0_ec2ec5ec8;--Macrocell 16 (2/3)
                    b2_1_ec2ec5ec8 <= mc3x1_1_ec2ec5ec8;--Macrocell 16 (2/3)
                    b2_2_ec2ec5ec8 <= mc3x1_2_ec2ec5ec8;--Macrocell 16 (2/3)
                    b2_3_ec2ec5ec8 <= mc3x1_3_ec2ec5ec8;--Macrocell 16 (2/3)
                    b2_4_ec2ec5ec8 <= mc3x1_4_ec2ec5ec8;--Macrocell 16 (2/3)
                    b2_5_ec2ec5ec8 <= mc3x1_5_ec2ec5ec8;--Macrocell 16 (2/3)
                    b2_6_ec2ec5ec8 <= mc3x1_6_ec2ec5ec8;--Macrocell 16 (2/3)
                    b2_7_ec2ec5ec8 <= mc3x1_7_ec2ec5ec8;--Macrocell 16 (2/3)
                    b2_8_ec2ec5ec8 <= mc3x1_8_ec2ec5ec8;--Macrocell 16 (2/3)
                    b2_9_ec2ec5ec8 <= mc3x1_9_ec2ec5ec8;--Macrocell 16 (2/3)
                    b2_10_ec2ec5ec8 <= mc3x1_10_ec2ec5ec8;--Macrocell 16 (2/3)
                    b2_11_ec2ec5ec8 <= mc3x1_11_ec2ec5ec8;--Macrocell 16 (2/3)
                    b2_12_ec2ec5ec8 <= mc3x1_12_ec2ec5ec8;--Macrocell 16 (2/3)
                    b2_13_ec2ec5ec8 <= mc3x1_13_ec2ec5ec8;--Macrocell 16 (2/3)
                    b2_14_ec2ec5ec8 <= mc3x1_14_ec2ec5ec8;--Macrocell 16 (2/3)
                    b2_15_ec2ec5ec8 <= mc3x1_15_ec2ec5ec8;--Macrocell 16 (2/3)
                    b2_16_ec2ec5ec8 <= mc3x1_16_ec2ec5ec8;--Macrocell 16 (2/3)
                    b2_17_ec2ec5ec8 <= mc3x1_17_ec2ec5ec8;--Macrocell 16 (2/3)
                    b2_18_ec2ec5ec8 <= mc3x1_18_ec2ec5ec8;--Macrocell 16 (2/3)
                    b2_19_ec2ec5ec8 <= mc3x1_19_ec2ec5ec8;--Macrocell 16 (2/3)
                    b2_20_ec2ec5ec8 <= mc3x1_20_ec2ec5ec8;--Macrocell 16 (2/3)
                    b2_21_ec2ec5ec8 <= mc3x1_21_ec2ec5ec8;--Macrocell 16 (2/3)
                    ce3_ec2ec5ec8 <= '1';
                    b3_0_ec2ec5ec8 <= mc3x1_0_ec2ec5ec8;--Macrocell 17 (1/3)
                    b3_1_ec2ec5ec8 <= mc3x1_1_ec2ec5ec8;--Macrocell 17 (1/3)
                    b3_2_ec2ec5ec8 <= mc3x1_2_ec2ec5ec8;--Macrocell 17 (1/3)
                    b3_3_ec2ec5ec8 <= mc3x1_3_ec2ec5ec8;--Macrocell 17 (1/3)
                    b3_4_ec2ec5ec8 <= mc3x1_4_ec2ec5ec8;--Macrocell 17 (1/3)
                    b3_5_ec2ec5ec8 <= mc3x1_5_ec2ec5ec8;--Macrocell 17 (1/3)
                    b3_6_ec2ec5ec8 <= mc3x1_6_ec2ec5ec8;--Macrocell 17 (1/3)
                    b3_7_ec2ec5ec8 <= mc3x1_7_ec2ec5ec8;--Macrocell 17 (1/3)
                    b3_8_ec2ec5ec8 <= mc3x1_8_ec2ec5ec8;--Macrocell 17 (1/3)
                    b3_9_ec2ec5ec8 <= mc3x1_9_ec2ec5ec8;--Macrocell 17 (1/3)
                    b3_10_ec2ec5ec8 <= mc3x1_10_ec2ec5ec8;--Macrocell 17 (1/3)
                    b3_11_ec2ec5ec8 <= mc3x1_11_ec2ec5ec8;--Macrocell 17 (1/3)
                    b3_12_ec2ec5ec8 <= mc3x1_12_ec2ec5ec8;--Macrocell 17 (1/3)
                    b3_13_ec2ec5ec8 <= mc3x1_13_ec2ec5ec8;--Macrocell 17 (1/3)
                    b3_14_ec2ec5ec8 <= mc3x1_14_ec2ec5ec8;--Macrocell 17 (1/3)
                    b3_15_ec2ec5ec8 <= mc3x1_15_ec2ec5ec8;--Macrocell 17 (1/3)
                    b3_16_ec2ec5ec8 <= mc3x1_16_ec2ec5ec8;--Macrocell 17 (1/3)
                    b3_17_ec2ec5ec8 <= mc3x1_17_ec2ec5ec8;--Macrocell 17 (1/3)
                    b3_18_ec2ec5ec8 <= mc3x1_18_ec2ec5ec8;--Macrocell 17 (1/3)
                    b3_19_ec2ec5ec8 <= mc3x1_19_ec2ec5ec8;--Macrocell 17 (1/3)
                    b3_20_ec2ec5ec8 <= mc3x1_20_ec2ec5ec8;--Macrocell 17 (1/3)
                    b3_21_ec2ec5ec8 <= mc3x1_21_ec2ec5ec8;--Macrocell 17 (1/3)
                    
                    state_macrocell <= s3;
                end if;
            when s3 =>
                    ce0_ec0ec3ec6 <= '0';
                    ce1_ec0ec3ec6 <= '0';
                    ce2_ec0ec3ec6 <= '0';
                    
                    ce0_ec1ec4ec7 <= '0';
                    ce1_ec1ec4ec7 <= '0';
                    ce2_ec1ec4ec7 <= '0';
                    ce3_ec1ec4ec7 <= '0';
                    ce4_ec1ec4ec7 <= '0';
                    
                    ce0_ec2ec5ec8 <= '0';
                    ce1_ec2ec5ec8 <= '0';
                    ce2_ec2ec5ec8 <= '0';
                    ce3_ec2ec5ec8 <= '0';
                    ce4_ec2ec5ec8 <= '0';
                    
                    state_macrocell <= s4;
            when s4 =>
                if (mc3x1_ready_ec0ec3ec6 = '1' and mc3x1_ready_ec1ec4ec7 = '1' and mc3x1_ready_ec2ec5ec8 = '1') then
                    ce0_ec0ec3ec6 <= '1';
                    b0_0_ec0ec3ec6 <= mc3x1_0_ec0ec3ec6;--Macrocell 0 (3/3)
                    b0_1_ec0ec3ec6 <= mc3x1_1_ec0ec3ec6;--Macrocell 0 (3/3)
                    b0_2_ec0ec3ec6 <= mc3x1_2_ec0ec3ec6;--Macrocell 0 (3/3)
                    b0_3_ec0ec3ec6 <= mc3x1_3_ec0ec3ec6;--Macrocell 0 (3/3)
                    b0_4_ec0ec3ec6 <= mc3x1_4_ec0ec3ec6;--Macrocell 0 (3/3)
                    b0_5_ec0ec3ec6 <= mc3x1_5_ec0ec3ec6;--Macrocell 0 (3/3)
                    b0_6_ec0ec3ec6 <= mc3x1_6_ec0ec3ec6;--Macrocell 0 (3/3)
                    b0_7_ec0ec3ec6 <= mc3x1_7_ec0ec3ec6;--Macrocell 0 (3/3)
                    b0_8_ec0ec3ec6 <= mc3x1_8_ec0ec3ec6;--Macrocell 0 (3/3)
                    b0_9_ec0ec3ec6 <= mc3x1_9_ec0ec3ec6;--Macrocell 0 (3/3)
                    b0_10_ec0ec3ec6 <= mc3x1_10_ec0ec3ec6;--Macrocell 0 (3/3)
                    b0_11_ec0ec3ec6 <= mc3x1_11_ec0ec3ec6;--Macrocell 0 (3/3)
                    b0_12_ec0ec3ec6 <= mc3x1_12_ec0ec3ec6;--Macrocell 0 (3/3)
                    b0_13_ec0ec3ec6 <= mc3x1_13_ec0ec3ec6;--Macrocell 0 (3/3)
                    b0_14_ec0ec3ec6 <= mc3x1_14_ec0ec3ec6;--Macrocell 0 (3/3)
                    b0_15_ec0ec3ec6 <= mc3x1_15_ec0ec3ec6;--Macrocell 0 (3/3)
                    b0_16_ec0ec3ec6 <= mc3x1_16_ec0ec3ec6;--Macrocell 0 (3/3)
                    b0_17_ec0ec3ec6 <= mc3x1_17_ec0ec3ec6;--Macrocell 0 (3/3)
                    b0_18_ec0ec3ec6 <= mc3x1_18_ec0ec3ec6;--Macrocell 0 (3/3)
                    b0_19_ec0ec3ec6 <= mc3x1_19_ec0ec3ec6;--Macrocell 0 (3/3)
                    b0_20_ec0ec3ec6 <= mc3x1_20_ec0ec3ec6;--Macrocell 0 (3/3)
                    b0_21_ec0ec3ec6 <= mc3x1_21_ec0ec3ec6;--Macrocell 0 (3/3)
                    ce1_ec0ec3ec6 <= '1';
                    b1_0_ec0ec3ec6 <= mc3x1_0_ec0ec3ec6;--Macrocell 1 (2/3)
                    b1_1_ec0ec3ec6 <= mc3x1_1_ec0ec3ec6;--Macrocell 1 (2/3)
                    b1_2_ec0ec3ec6 <= mc3x1_2_ec0ec3ec6;--Macrocell 1 (2/3)
                    b1_3_ec0ec3ec6 <= mc3x1_3_ec0ec3ec6;--Macrocell 1 (2/3)
                    b1_4_ec0ec3ec6 <= mc3x1_4_ec0ec3ec6;--Macrocell 1 (2/3)
                    b1_5_ec0ec3ec6 <= mc3x1_5_ec0ec3ec6;--Macrocell 1 (2/3)
                    b1_6_ec0ec3ec6 <= mc3x1_6_ec0ec3ec6;--Macrocell 1 (2/3)
                    b1_7_ec0ec3ec6 <= mc3x1_7_ec0ec3ec6;--Macrocell 1 (2/3)
                    b1_8_ec0ec3ec6 <= mc3x1_8_ec0ec3ec6;--Macrocell 1 (2/3)
                    b1_9_ec0ec3ec6 <= mc3x1_9_ec0ec3ec6;--Macrocell 1 (2/3)
                    b1_10_ec0ec3ec6 <= mc3x1_10_ec0ec3ec6;--Macrocell 1 (2/3)
                    b1_11_ec0ec3ec6 <= mc3x1_11_ec0ec3ec6;--Macrocell 1 (2/3)
                    b1_12_ec0ec3ec6 <= mc3x1_12_ec0ec3ec6;--Macrocell 1 (2/3)
                    b1_13_ec0ec3ec6 <= mc3x1_13_ec0ec3ec6;--Macrocell 1 (2/3)
                    b1_14_ec0ec3ec6 <= mc3x1_14_ec0ec3ec6;--Macrocell 1 (2/3)
                    b1_15_ec0ec3ec6 <= mc3x1_15_ec0ec3ec6;--Macrocell 1 (2/3)
                    b1_16_ec0ec3ec6 <= mc3x1_16_ec0ec3ec6;--Macrocell 1 (2/3)
                    b1_17_ec0ec3ec6 <= mc3x1_17_ec0ec3ec6;--Macrocell 1 (2/3)
                    b1_18_ec0ec3ec6 <= mc3x1_18_ec0ec3ec6;--Macrocell 1 (2/3)
                    b1_19_ec0ec3ec6 <= mc3x1_19_ec0ec3ec6;--Macrocell 1 (2/3)
                    b1_20_ec0ec3ec6 <= mc3x1_20_ec0ec3ec6;--Macrocell 1 (2/3)
                    b1_21_ec0ec3ec6 <= mc3x1_21_ec0ec3ec6;--Macrocell 1 (2/3)
                    ce2_ec0ec3ec6 <= '1';
                    b2_0_ec0ec3ec6 <= mc3x1_0_ec0ec3ec6;--Macrocell 2 (1/3)
                    b2_1_ec0ec3ec6 <= mc3x1_1_ec0ec3ec6;--Macrocell 2 (1/3)
                    b2_2_ec0ec3ec6 <= mc3x1_2_ec0ec3ec6;--Macrocell 2 (1/3)
                    b2_3_ec0ec3ec6 <= mc3x1_3_ec0ec3ec6;--Macrocell 2 (1/3)
                    b2_4_ec0ec3ec6 <= mc3x1_4_ec0ec3ec6;--Macrocell 2 (1/3)
                    b2_5_ec0ec3ec6 <= mc3x1_5_ec0ec3ec6;--Macrocell 2 (1/3)
                    b2_6_ec0ec3ec6 <= mc3x1_6_ec0ec3ec6;--Macrocell 2 (1/3)
                    b2_7_ec0ec3ec6 <= mc3x1_7_ec0ec3ec6;--Macrocell 2 (1/3)
                    b2_8_ec0ec3ec6 <= mc3x1_8_ec0ec3ec6;--Macrocell 2 (1/3)
                    b2_9_ec0ec3ec6 <= mc3x1_9_ec0ec3ec6;--Macrocell 2 (1/3)
                    b2_10_ec0ec3ec6 <= mc3x1_10_ec0ec3ec6;--Macrocell 2 (1/3)
                    b2_11_ec0ec3ec6 <= mc3x1_11_ec0ec3ec6;--Macrocell 2 (1/3)
                    b2_12_ec0ec3ec6 <= mc3x1_12_ec0ec3ec6;--Macrocell 2 (1/3)
                    b2_13_ec0ec3ec6 <= mc3x1_13_ec0ec3ec6;--Macrocell 2 (1/3)
                    b2_14_ec0ec3ec6 <= mc3x1_14_ec0ec3ec6;--Macrocell 2 (1/3)
                    b2_15_ec0ec3ec6 <= mc3x1_15_ec0ec3ec6;--Macrocell 2 (1/3)
                    b2_16_ec0ec3ec6 <= mc3x1_16_ec0ec3ec6;--Macrocell 2 (1/3)
                    b2_17_ec0ec3ec6 <= mc3x1_17_ec0ec3ec6;--Macrocell 2 (1/3)
                    b2_18_ec0ec3ec6 <= mc3x1_18_ec0ec3ec6;--Macrocell 2 (1/3)
                    b2_19_ec0ec3ec6 <= mc3x1_19_ec0ec3ec6;--Macrocell 2 (1/3)
                    b2_20_ec0ec3ec6 <= mc3x1_20_ec0ec3ec6;--Macrocell 2 (1/3)
                    b2_21_ec0ec3ec6 <= mc3x1_21_ec0ec3ec6;--Macrocell 2 (1/3)
                    
                    ce2_ec1ec4ec7 <= '1';
                    b2_0_ec1ec4ec7 <= mc3x1_0_ec1ec4ec7;--Macrocell 8 (3/3)
                    b2_1_ec1ec4ec7 <= mc3x1_1_ec1ec4ec7;--Macrocell 8 (3/3)
                    b2_2_ec1ec4ec7 <= mc3x1_2_ec1ec4ec7;--Macrocell 8 (3/3)
                    b2_3_ec1ec4ec7 <= mc3x1_3_ec1ec4ec7;--Macrocell 8 (3/3)
                    b2_4_ec1ec4ec7 <= mc3x1_4_ec1ec4ec7;--Macrocell 8 (3/3)
                    b2_5_ec1ec4ec7 <= mc3x1_5_ec1ec4ec7;--Macrocell 8 (3/3)
                    b2_6_ec1ec4ec7 <= mc3x1_6_ec1ec4ec7;--Macrocell 8 (3/3)
                    b2_7_ec1ec4ec7 <= mc3x1_7_ec1ec4ec7;--Macrocell 8 (3/3)
                    b2_8_ec1ec4ec7 <= mc3x1_8_ec1ec4ec7;--Macrocell 8 (3/3)
                    b2_9_ec1ec4ec7 <= mc3x1_9_ec1ec4ec7;--Macrocell 8 (3/3)
                    b2_10_ec1ec4ec7 <= mc3x1_10_ec1ec4ec7;--Macrocell 8 (3/3)
                    b2_11_ec1ec4ec7 <= mc3x1_11_ec1ec4ec7;--Macrocell 8 (3/3)
                    b2_12_ec1ec4ec7 <= mc3x1_12_ec1ec4ec7;--Macrocell 8 (3/3)
                    b2_13_ec1ec4ec7 <= mc3x1_13_ec1ec4ec7;--Macrocell 8 (3/3)
                    b2_14_ec1ec4ec7 <= mc3x1_14_ec1ec4ec7;--Macrocell 8 (3/3)
                    b2_15_ec1ec4ec7 <= mc3x1_15_ec1ec4ec7;--Macrocell 8 (3/3)
                    b2_16_ec1ec4ec7 <= mc3x1_16_ec1ec4ec7;--Macrocell 8 (3/3)
                    b2_17_ec1ec4ec7 <= mc3x1_17_ec1ec4ec7;--Macrocell 8 (3/3)
                    b2_18_ec1ec4ec7 <= mc3x1_18_ec1ec4ec7;--Macrocell 8 (3/3)
                    b2_19_ec1ec4ec7 <= mc3x1_19_ec1ec4ec7;--Macrocell 8 (3/3)
                    b2_20_ec1ec4ec7 <= mc3x1_20_ec1ec4ec7;--Macrocell 8 (3/3)
                    b2_21_ec1ec4ec7 <= mc3x1_21_ec1ec4ec7;--Macrocell 8 (3/3)
                    ce3_ec1ec4ec7 <= '1';
                    b3_0_ec1ec4ec7 <= mc3x1_0_ec1ec4ec7;--Macrocell 9 (2/3)
                    b3_1_ec1ec4ec7 <= mc3x1_1_ec1ec4ec7;--Macrocell 9 (2/3)
                    b3_2_ec1ec4ec7 <= mc3x1_2_ec1ec4ec7;--Macrocell 9 (2/3)
                    b3_3_ec1ec4ec7 <= mc3x1_3_ec1ec4ec7;--Macrocell 9 (2/3)
                    b3_4_ec1ec4ec7 <= mc3x1_4_ec1ec4ec7;--Macrocell 9 (2/3)
                    b3_5_ec1ec4ec7 <= mc3x1_5_ec1ec4ec7;--Macrocell 9 (2/3)
                    b3_6_ec1ec4ec7 <= mc3x1_6_ec1ec4ec7;--Macrocell 9 (2/3)
                    b3_7_ec1ec4ec7 <= mc3x1_7_ec1ec4ec7;--Macrocell 9 (2/3)
                    b3_8_ec1ec4ec7 <= mc3x1_8_ec1ec4ec7;--Macrocell 9 (2/3)
                    b3_9_ec1ec4ec7 <= mc3x1_9_ec1ec4ec7;--Macrocell 9 (2/3)
                    b3_10_ec1ec4ec7 <= mc3x1_10_ec1ec4ec7;--Macrocell 9 (2/3)
                    b3_11_ec1ec4ec7 <= mc3x1_11_ec1ec4ec7;--Macrocell 9 (2/3)
                    b3_12_ec1ec4ec7 <= mc3x1_12_ec1ec4ec7;--Macrocell 9 (2/3)
                    b3_13_ec1ec4ec7 <= mc3x1_13_ec1ec4ec7;--Macrocell 9 (2/3)
                    b3_14_ec1ec4ec7 <= mc3x1_14_ec1ec4ec7;--Macrocell 9 (2/3)
                    b3_15_ec1ec4ec7 <= mc3x1_15_ec1ec4ec7;--Macrocell 9 (2/3)
                    b3_16_ec1ec4ec7 <= mc3x1_16_ec1ec4ec7;--Macrocell 9 (2/3)
                    b3_17_ec1ec4ec7 <= mc3x1_17_ec1ec4ec7;--Macrocell 9 (2/3)
                    b3_18_ec1ec4ec7 <= mc3x1_18_ec1ec4ec7;--Macrocell 9 (2/3)
                    b3_19_ec1ec4ec7 <= mc3x1_19_ec1ec4ec7;--Macrocell 9 (2/3)
                    b3_20_ec1ec4ec7 <= mc3x1_20_ec1ec4ec7;--Macrocell 9 (2/3)
                    b3_21_ec1ec4ec7 <= mc3x1_21_ec1ec4ec7;--Macrocell 9 (2/3)
                    ce4_ec1ec4ec7 <= '1';
                    b4_0_ec1ec4ec7 <= mc3x1_0_ec1ec4ec7;--Macrocell 10 (1/3)
                    b4_1_ec1ec4ec7 <= mc3x1_1_ec1ec4ec7;--Macrocell 10 (1/3)
                    b4_2_ec1ec4ec7 <= mc3x1_2_ec1ec4ec7;--Macrocell 10 (1/3)
                    b4_3_ec1ec4ec7 <= mc3x1_3_ec1ec4ec7;--Macrocell 10 (1/3)
                    b4_4_ec1ec4ec7 <= mc3x1_4_ec1ec4ec7;--Macrocell 10 (1/3)
                    b4_5_ec1ec4ec7 <= mc3x1_5_ec1ec4ec7;--Macrocell 10 (1/3)
                    b4_6_ec1ec4ec7 <= mc3x1_6_ec1ec4ec7;--Macrocell 10 (1/3)
                    b4_7_ec1ec4ec7 <= mc3x1_7_ec1ec4ec7;--Macrocell 10 (1/3)
                    b4_8_ec1ec4ec7 <= mc3x1_8_ec1ec4ec7;--Macrocell 10 (1/3)
                    b4_9_ec1ec4ec7 <= mc3x1_9_ec1ec4ec7;--Macrocell 10 (1/3)
                    b4_10_ec1ec4ec7 <= mc3x1_10_ec1ec4ec7;--Macrocell 10 (1/3)
                    b4_11_ec1ec4ec7 <= mc3x1_11_ec1ec4ec7;--Macrocell 10 (1/3)
                    b4_12_ec1ec4ec7 <= mc3x1_12_ec1ec4ec7;--Macrocell 10 (1/3)
                    b4_13_ec1ec4ec7 <= mc3x1_13_ec1ec4ec7;--Macrocell 10 (1/3)
                    b4_14_ec1ec4ec7 <= mc3x1_14_ec1ec4ec7;--Macrocell 10 (1/3)
                    b4_15_ec1ec4ec7 <= mc3x1_15_ec1ec4ec7;--Macrocell 10 (1/3)
                    b4_16_ec1ec4ec7 <= mc3x1_16_ec1ec4ec7;--Macrocell 10 (1/3)
                    b4_17_ec1ec4ec7 <= mc3x1_17_ec1ec4ec7;--Macrocell 10 (1/3)
                    b4_18_ec1ec4ec7 <= mc3x1_18_ec1ec4ec7;--Macrocell 10 (1/3)
                    b4_19_ec1ec4ec7 <= mc3x1_19_ec1ec4ec7;--Macrocell 10 (1/3)
                    b4_20_ec1ec4ec7 <= mc3x1_20_ec1ec4ec7;--Macrocell 10 (1/3)
                    b4_21_ec1ec4ec7 <= mc3x1_21_ec1ec4ec7;--Macrocell 10 (1/3)
                    
                    ce2_ec2ec5ec8 <= '1';
                    b2_0_ec2ec5ec8 <= mc3x1_0_ec2ec5ec8;--Macrocell 16 (3/3)
                    b2_1_ec2ec5ec8 <= mc3x1_1_ec2ec5ec8;--Macrocell 16 (3/3)
                    b2_2_ec2ec5ec8 <= mc3x1_2_ec2ec5ec8;--Macrocell 16 (3/3)
                    b2_3_ec2ec5ec8 <= mc3x1_3_ec2ec5ec8;--Macrocell 16 (3/3)
                    b2_4_ec2ec5ec8 <= mc3x1_4_ec2ec5ec8;--Macrocell 16 (3/3)
                    b2_5_ec2ec5ec8 <= mc3x1_5_ec2ec5ec8;--Macrocell 16 (3/3)
                    b2_6_ec2ec5ec8 <= mc3x1_6_ec2ec5ec8;--Macrocell 16 (3/3)
                    b2_7_ec2ec5ec8 <= mc3x1_7_ec2ec5ec8;--Macrocell 16 (3/3)
                    b2_8_ec2ec5ec8 <= mc3x1_8_ec2ec5ec8;--Macrocell 16 (3/3)
                    b2_9_ec2ec5ec8 <= mc3x1_9_ec2ec5ec8;--Macrocell 16 (3/3)
                    b2_10_ec2ec5ec8 <= mc3x1_10_ec2ec5ec8;--Macrocell 16 (3/3)
                    b2_11_ec2ec5ec8 <= mc3x1_11_ec2ec5ec8;--Macrocell 16 (3/3)
                    b2_12_ec2ec5ec8 <= mc3x1_12_ec2ec5ec8;--Macrocell 16 (3/3)
                    b2_13_ec2ec5ec8 <= mc3x1_13_ec2ec5ec8;--Macrocell 16 (3/3)
                    b2_14_ec2ec5ec8 <= mc3x1_14_ec2ec5ec8;--Macrocell 16 (3/3)
                    b2_15_ec2ec5ec8 <= mc3x1_15_ec2ec5ec8;--Macrocell 16 (3/3)
                    b2_16_ec2ec5ec8 <= mc3x1_16_ec2ec5ec8;--Macrocell 16 (3/3)
                    b2_17_ec2ec5ec8 <= mc3x1_17_ec2ec5ec8;--Macrocell 16 (3/3)
                    b2_18_ec2ec5ec8 <= mc3x1_18_ec2ec5ec8;--Macrocell 16 (3/3)
                    b2_19_ec2ec5ec8 <= mc3x1_19_ec2ec5ec8;--Macrocell 16 (3/3)
                    b2_20_ec2ec5ec8 <= mc3x1_20_ec2ec5ec8;--Macrocell 16 (3/3)
                    b2_21_ec2ec5ec8 <= mc3x1_21_ec2ec5ec8;--Macrocell 16 (3/3)
                    ce3_ec2ec5ec8 <= '1';
                    b3_0_ec2ec5ec8 <= mc3x1_0_ec2ec5ec8;--Macrocell 17 (2/3)
                    b3_1_ec2ec5ec8 <= mc3x1_1_ec2ec5ec8;--Macrocell 17 (2/3)
                    b3_2_ec2ec5ec8 <= mc3x1_2_ec2ec5ec8;--Macrocell 17 (2/3)
                    b3_3_ec2ec5ec8 <= mc3x1_3_ec2ec5ec8;--Macrocell 17 (2/3)
                    b3_4_ec2ec5ec8 <= mc3x1_4_ec2ec5ec8;--Macrocell 17 (2/3)
                    b3_5_ec2ec5ec8 <= mc3x1_5_ec2ec5ec8;--Macrocell 17 (2/3)
                    b3_6_ec2ec5ec8 <= mc3x1_6_ec2ec5ec8;--Macrocell 17 (2/3)
                    b3_7_ec2ec5ec8 <= mc3x1_7_ec2ec5ec8;--Macrocell 17 (2/3)
                    b3_8_ec2ec5ec8 <= mc3x1_8_ec2ec5ec8;--Macrocell 17 (2/3)
                    b3_9_ec2ec5ec8 <= mc3x1_9_ec2ec5ec8;--Macrocell 17 (2/3)
                    b3_10_ec2ec5ec8 <= mc3x1_10_ec2ec5ec8;--Macrocell 17 (2/3)
                    b3_11_ec2ec5ec8 <= mc3x1_11_ec2ec5ec8;--Macrocell 17 (2/3)
                    b3_12_ec2ec5ec8 <= mc3x1_12_ec2ec5ec8;--Macrocell 17 (2/3)
                    b3_13_ec2ec5ec8 <= mc3x1_13_ec2ec5ec8;--Macrocell 17 (2/3)
                    b3_14_ec2ec5ec8 <= mc3x1_14_ec2ec5ec8;--Macrocell 17 (2/3)
                    b3_15_ec2ec5ec8 <= mc3x1_15_ec2ec5ec8;--Macrocell 17 (2/3)
                    b3_16_ec2ec5ec8 <= mc3x1_16_ec2ec5ec8;--Macrocell 17 (2/3)
                    b3_17_ec2ec5ec8 <= mc3x1_17_ec2ec5ec8;--Macrocell 17 (2/3)
                    b3_18_ec2ec5ec8 <= mc3x1_18_ec2ec5ec8;--Macrocell 17 (2/3)
                    b3_19_ec2ec5ec8 <= mc3x1_19_ec2ec5ec8;--Macrocell 17 (2/3)
                    b3_20_ec2ec5ec8 <= mc3x1_20_ec2ec5ec8;--Macrocell 17 (2/3)
                    b3_21_ec2ec5ec8 <= mc3x1_21_ec2ec5ec8;--Macrocell 17 (2/3)
                    ce4_ec2ec5ec8 <= '1';
                    b4_0_ec2ec5ec8 <= mc3x1_0_ec2ec5ec8;--Macrocell 18 (1/3)
                    b4_1_ec2ec5ec8 <= mc3x1_1_ec2ec5ec8;--Macrocell 18 (1/3)
                    b4_2_ec2ec5ec8 <= mc3x1_2_ec2ec5ec8;--Macrocell 18 (1/3)
                    b4_3_ec2ec5ec8 <= mc3x1_3_ec2ec5ec8;--Macrocell 18 (1/3)
                    b4_4_ec2ec5ec8 <= mc3x1_4_ec2ec5ec8;--Macrocell 18 (1/3)
                    b4_5_ec2ec5ec8 <= mc3x1_5_ec2ec5ec8;--Macrocell 18 (1/3)
                    b4_6_ec2ec5ec8 <= mc3x1_6_ec2ec5ec8;--Macrocell 18 (1/3)
                    b4_7_ec2ec5ec8 <= mc3x1_7_ec2ec5ec8;--Macrocell 18 (1/3)
                    b4_8_ec2ec5ec8 <= mc3x1_8_ec2ec5ec8;--Macrocell 18 (1/3)
                    b4_9_ec2ec5ec8 <= mc3x1_9_ec2ec5ec8;--Macrocell 18 (1/3)
                    b4_10_ec2ec5ec8 <= mc3x1_10_ec2ec5ec8;--Macrocell 18 (1/3)
                    b4_11_ec2ec5ec8 <= mc3x1_11_ec2ec5ec8;--Macrocell 18 (1/3)
                    b4_12_ec2ec5ec8 <= mc3x1_12_ec2ec5ec8;--Macrocell 18 (1/3)
                    b4_13_ec2ec5ec8 <= mc3x1_13_ec2ec5ec8;--Macrocell 18 (1/3)
                    b4_14_ec2ec5ec8 <= mc3x1_14_ec2ec5ec8;--Macrocell 18 (1/3)
                    b4_15_ec2ec5ec8 <= mc3x1_15_ec2ec5ec8;--Macrocell 18 (1/3)
                    b4_16_ec2ec5ec8 <= mc3x1_16_ec2ec5ec8;--Macrocell 18 (1/3)
                    b4_17_ec2ec5ec8 <= mc3x1_17_ec2ec5ec8;--Macrocell 18 (1/3)
                    b4_18_ec2ec5ec8 <= mc3x1_18_ec2ec5ec8;--Macrocell 18 (1/3)
                    b4_19_ec2ec5ec8 <= mc3x1_19_ec2ec5ec8;--Macrocell 18 (1/3)
                    b4_20_ec2ec5ec8 <= mc3x1_20_ec2ec5ec8;--Macrocell 18 (1/3)
                    b4_21_ec2ec5ec8 <= mc3x1_21_ec2ec5ec8;--Macrocell 18 (1/3)
                    
                    state_macrocell <= s5;
                end if;
            when s5 =>
                    ce0_ec0ec3ec6 <= '0';
                    ce1_ec0ec3ec6 <= '0';
                    ce2_ec0ec3ec6 <= '0';
                    
                    ce0_ec1ec4ec7 <= '0';
                    ce1_ec1ec4ec7 <= '0';
                    ce2_ec1ec4ec7 <= '0';
                    ce3_ec1ec4ec7 <= '0';
                    ce4_ec1ec4ec7 <= '0';
                    
                    ce0_ec2ec5ec8 <= '0';
                    ce1_ec2ec5ec8 <= '0';
                    ce2_ec2ec5ec8 <= '0';
                    ce3_ec2ec5ec8 <= '0';
                    ce4_ec2ec5ec8 <= '0';
                    
                    mc_ready <= '1';
                    state_macrocell <= s6;
            when s6 =>
                    mc_ready <= '0';
                    sclr0_ec0ec3ec6 <= '1';
                    sclr2_ec1ec4ec7 <= '1';
                    sclr2_ec2ec5ec8 <= '1';
                    state_macrocell <= s7;
            when s7 =>
                    sclr0_ec0ec3ec6 <= '0';
                    sclr2_ec1ec4ec7 <= '0';
                    sclr2_ec2ec5ec8 <= '0';
                    state_macrocell <= s8;
            when s8 =>
                if (mc3x1_ready_ec0ec3ec6 = '1' and mc3x1_ready_ec1ec4ec7 = '1' and mc3x1_ready_ec2ec5ec8 = '1') then
                    ce1_ec0ec3ec6 <= '1';
                    b1_0_ec0ec3ec6 <= mc3x1_0_ec0ec3ec6;--Macrocell 1 (3/3)
                    b1_1_ec0ec3ec6 <= mc3x1_1_ec0ec3ec6;--Macrocell 1 (3/3)
                    b1_2_ec0ec3ec6 <= mc3x1_2_ec0ec3ec6;--Macrocell 1 (3/3)
                    b1_3_ec0ec3ec6 <= mc3x1_3_ec0ec3ec6;--Macrocell 1 (3/3)
                    b1_4_ec0ec3ec6 <= mc3x1_4_ec0ec3ec6;--Macrocell 1 (3/3)
                    b1_5_ec0ec3ec6 <= mc3x1_5_ec0ec3ec6;--Macrocell 1 (3/3)
                    b1_6_ec0ec3ec6 <= mc3x1_6_ec0ec3ec6;--Macrocell 1 (3/3)
                    b1_7_ec0ec3ec6 <= mc3x1_7_ec0ec3ec6;--Macrocell 1 (3/3)
                    b1_8_ec0ec3ec6 <= mc3x1_8_ec0ec3ec6;--Macrocell 1 (3/3)
                    b1_9_ec0ec3ec6 <= mc3x1_9_ec0ec3ec6;--Macrocell 1 (3/3)
                    b1_10_ec0ec3ec6 <= mc3x1_10_ec0ec3ec6;--Macrocell 1 (3/3)
                    b1_11_ec0ec3ec6 <= mc3x1_11_ec0ec3ec6;--Macrocell 1 (3/3)
                    b1_12_ec0ec3ec6 <= mc3x1_12_ec0ec3ec6;--Macrocell 1 (3/3)
                    b1_13_ec0ec3ec6 <= mc3x1_13_ec0ec3ec6;--Macrocell 1 (3/3)
                    b1_14_ec0ec3ec6 <= mc3x1_14_ec0ec3ec6;--Macrocell 1 (3/3)
                    b1_15_ec0ec3ec6 <= mc3x1_15_ec0ec3ec6;--Macrocell 1 (3/3)
                    b1_16_ec0ec3ec6 <= mc3x1_16_ec0ec3ec6;--Macrocell 1 (3/3)
                    b1_17_ec0ec3ec6 <= mc3x1_17_ec0ec3ec6;--Macrocell 1 (3/3)
                    b1_18_ec0ec3ec6 <= mc3x1_18_ec0ec3ec6;--Macrocell 1 (3/3)
                    b1_19_ec0ec3ec6 <= mc3x1_19_ec0ec3ec6;--Macrocell 1 (3/3)
                    b1_20_ec0ec3ec6 <= mc3x1_20_ec0ec3ec6;--Macrocell 1 (3/3)
                    b1_21_ec0ec3ec6 <= mc3x1_21_ec0ec3ec6;--Macrocell 1 (3/3)
                    ce2_ec0ec3ec6 <= '1';
                    b2_0_ec0ec3ec6 <= mc3x1_0_ec0ec3ec6;--Macrocell 2 (2/3)
                    b2_1_ec0ec3ec6 <= mc3x1_1_ec0ec3ec6;--Macrocell 2 (2/3)
                    b2_2_ec0ec3ec6 <= mc3x1_2_ec0ec3ec6;--Macrocell 2 (2/3)
                    b2_3_ec0ec3ec6 <= mc3x1_3_ec0ec3ec6;--Macrocell 2 (2/3)
                    b2_4_ec0ec3ec6 <= mc3x1_4_ec0ec3ec6;--Macrocell 2 (2/3)
                    b2_5_ec0ec3ec6 <= mc3x1_5_ec0ec3ec6;--Macrocell 2 (2/3)
                    b2_6_ec0ec3ec6 <= mc3x1_6_ec0ec3ec6;--Macrocell 2 (2/3)
                    b2_7_ec0ec3ec6 <= mc3x1_7_ec0ec3ec6;--Macrocell 2 (2/3)
                    b2_8_ec0ec3ec6 <= mc3x1_8_ec0ec3ec6;--Macrocell 2 (2/3)
                    b2_9_ec0ec3ec6 <= mc3x1_9_ec0ec3ec6;--Macrocell 2 (2/3)
                    b2_10_ec0ec3ec6 <= mc3x1_10_ec0ec3ec6;--Macrocell 2 (2/3)
                    b2_11_ec0ec3ec6 <= mc3x1_11_ec0ec3ec6;--Macrocell 2 (2/3)
                    b2_12_ec0ec3ec6 <= mc3x1_12_ec0ec3ec6;--Macrocell 2 (2/3)
                    b2_13_ec0ec3ec6 <= mc3x1_13_ec0ec3ec6;--Macrocell 2 (2/3)
                    b2_14_ec0ec3ec6 <= mc3x1_14_ec0ec3ec6;--Macrocell 2 (2/3)
                    b2_15_ec0ec3ec6 <= mc3x1_15_ec0ec3ec6;--Macrocell 2 (2/3)
                    b2_16_ec0ec3ec6 <= mc3x1_16_ec0ec3ec6;--Macrocell 2 (2/3)
                    b2_17_ec0ec3ec6 <= mc3x1_17_ec0ec3ec6;--Macrocell 2 (2/3)
                    b2_18_ec0ec3ec6 <= mc3x1_18_ec0ec3ec6;--Macrocell 2 (2/3)
                    b2_19_ec0ec3ec6 <= mc3x1_19_ec0ec3ec6;--Macrocell 2 (2/3)
                    b2_20_ec0ec3ec6 <= mc3x1_20_ec0ec3ec6;--Macrocell 2 (2/3)
                    b2_21_ec0ec3ec6 <= mc3x1_21_ec0ec3ec6;--Macrocell 2 (2/3)
                    ce0_ec0ec3ec6 <= '1';
                    b0_0_ec0ec3ec6 <= mc3x1_0_ec0ec3ec6;--Macrocell 3 (1/3)
                    b0_1_ec0ec3ec6 <= mc3x1_1_ec0ec3ec6;--Macrocell 3 (1/3)
                    b0_2_ec0ec3ec6 <= mc3x1_2_ec0ec3ec6;--Macrocell 3 (1/3)
                    b0_3_ec0ec3ec6 <= mc3x1_3_ec0ec3ec6;--Macrocell 3 (1/3)
                    b0_4_ec0ec3ec6 <= mc3x1_4_ec0ec3ec6;--Macrocell 3 (1/3)
                    b0_5_ec0ec3ec6 <= mc3x1_5_ec0ec3ec6;--Macrocell 3 (1/3)
                    b0_6_ec0ec3ec6 <= mc3x1_6_ec0ec3ec6;--Macrocell 3 (1/3)
                    b0_7_ec0ec3ec6 <= mc3x1_7_ec0ec3ec6;--Macrocell 3 (1/3)
                    b0_8_ec0ec3ec6 <= mc3x1_8_ec0ec3ec6;--Macrocell 3 (1/3)
                    b0_9_ec0ec3ec6 <= mc3x1_9_ec0ec3ec6;--Macrocell 3 (1/3)
                    b0_10_ec0ec3ec6 <= mc3x1_10_ec0ec3ec6;--Macrocell 3 (1/3)
                    b0_11_ec0ec3ec6 <= mc3x1_11_ec0ec3ec6;--Macrocell 3 (1/3)
                    b0_12_ec0ec3ec6 <= mc3x1_12_ec0ec3ec6;--Macrocell 3 (1/3)
                    b0_13_ec0ec3ec6 <= mc3x1_13_ec0ec3ec6;--Macrocell 3 (1/3)
                    b0_14_ec0ec3ec6 <= mc3x1_14_ec0ec3ec6;--Macrocell 3 (1/3)
                    b0_15_ec0ec3ec6 <= mc3x1_15_ec0ec3ec6;--Macrocell 3 (1/3)
                    b0_16_ec0ec3ec6 <= mc3x1_16_ec0ec3ec6;--Macrocell 3 (1/3)
                    b0_17_ec0ec3ec6 <= mc3x1_17_ec0ec3ec6;--Macrocell 3 (1/3)
                    b0_18_ec0ec3ec6 <= mc3x1_18_ec0ec3ec6;--Macrocell 3 (1/3)
                    b0_19_ec0ec3ec6 <= mc3x1_19_ec0ec3ec6;--Macrocell 3 (1/3)
                    b0_20_ec0ec3ec6 <= mc3x1_20_ec0ec3ec6;--Macrocell 3 (1/3)
                    b0_21_ec0ec3ec6 <= mc3x1_21_ec0ec3ec6;--Macrocell 3 (1/3)
                    
                    ce3_ec1ec4ec7 <= '1';
                    b3_0_ec1ec4ec7 <= mc3x1_0_ec1ec4ec7;--Macrocell 9 (3/3)
                    b3_1_ec1ec4ec7 <= mc3x1_1_ec1ec4ec7;--Macrocell 9 (3/3)
                    b3_2_ec1ec4ec7 <= mc3x1_2_ec1ec4ec7;--Macrocell 9 (3/3)
                    b3_3_ec1ec4ec7 <= mc3x1_3_ec1ec4ec7;--Macrocell 9 (3/3)
                    b3_4_ec1ec4ec7 <= mc3x1_4_ec1ec4ec7;--Macrocell 9 (3/3)
                    b3_5_ec1ec4ec7 <= mc3x1_5_ec1ec4ec7;--Macrocell 9 (3/3)
                    b3_6_ec1ec4ec7 <= mc3x1_6_ec1ec4ec7;--Macrocell 9 (3/3)
                    b3_7_ec1ec4ec7 <= mc3x1_7_ec1ec4ec7;--Macrocell 9 (3/3)
                    b3_8_ec1ec4ec7 <= mc3x1_8_ec1ec4ec7;--Macrocell 9 (3/3)
                    b3_9_ec1ec4ec7 <= mc3x1_9_ec1ec4ec7;--Macrocell 9 (3/3)
                    b3_10_ec1ec4ec7 <= mc3x1_10_ec1ec4ec7;--Macrocell 9 (3/3)
                    b3_11_ec1ec4ec7 <= mc3x1_11_ec1ec4ec7;--Macrocell 9 (3/3)
                    b3_12_ec1ec4ec7 <= mc3x1_12_ec1ec4ec7;--Macrocell 9 (3/3)
                    b3_13_ec1ec4ec7 <= mc3x1_13_ec1ec4ec7;--Macrocell 9 (3/3)
                    b3_14_ec1ec4ec7 <= mc3x1_14_ec1ec4ec7;--Macrocell 9 (3/3)
                    b3_15_ec1ec4ec7 <= mc3x1_15_ec1ec4ec7;--Macrocell 9 (3/3)
                    b3_16_ec1ec4ec7 <= mc3x1_16_ec1ec4ec7;--Macrocell 9 (3/3)
                    b3_17_ec1ec4ec7 <= mc3x1_17_ec1ec4ec7;--Macrocell 9 (3/3)
                    b3_18_ec1ec4ec7 <= mc3x1_18_ec1ec4ec7;--Macrocell 9 (3/3)
                    b3_19_ec1ec4ec7 <= mc3x1_19_ec1ec4ec7;--Macrocell 9 (3/3)
                    b3_20_ec1ec4ec7 <= mc3x1_20_ec1ec4ec7;--Macrocell 9 (3/3)
                    b3_21_ec1ec4ec7 <= mc3x1_21_ec1ec4ec7;--Macrocell 9 (3/3)
                    ce4_ec1ec4ec7 <= '1';
                    b4_0_ec1ec4ec7 <= mc3x1_0_ec1ec4ec7;--Macrocell 10 (2/3)
                    b4_1_ec1ec4ec7 <= mc3x1_1_ec1ec4ec7;--Macrocell 10 (2/3)
                    b4_2_ec1ec4ec7 <= mc3x1_2_ec1ec4ec7;--Macrocell 10 (2/3)
                    b4_3_ec1ec4ec7 <= mc3x1_3_ec1ec4ec7;--Macrocell 10 (2/3)
                    b4_4_ec1ec4ec7 <= mc3x1_4_ec1ec4ec7;--Macrocell 10 (2/3)
                    b4_5_ec1ec4ec7 <= mc3x1_5_ec1ec4ec7;--Macrocell 10 (2/3)
                    b4_6_ec1ec4ec7 <= mc3x1_6_ec1ec4ec7;--Macrocell 10 (2/3)
                    b4_7_ec1ec4ec7 <= mc3x1_7_ec1ec4ec7;--Macrocell 10 (2/3)
                    b4_8_ec1ec4ec7 <= mc3x1_8_ec1ec4ec7;--Macrocell 10 (2/3)
                    b4_9_ec1ec4ec7 <= mc3x1_9_ec1ec4ec7;--Macrocell 10 (2/3)
                    b4_10_ec1ec4ec7 <= mc3x1_10_ec1ec4ec7;--Macrocell 10 (2/3)
                    b4_11_ec1ec4ec7 <= mc3x1_11_ec1ec4ec7;--Macrocell 10 (2/3)
                    b4_12_ec1ec4ec7 <= mc3x1_12_ec1ec4ec7;--Macrocell 10 (2/3)
                    b4_13_ec1ec4ec7 <= mc3x1_13_ec1ec4ec7;--Macrocell 10 (2/3)
                    b4_14_ec1ec4ec7 <= mc3x1_14_ec1ec4ec7;--Macrocell 10 (2/3)
                    b4_15_ec1ec4ec7 <= mc3x1_15_ec1ec4ec7;--Macrocell 10 (2/3)
                    b4_16_ec1ec4ec7 <= mc3x1_16_ec1ec4ec7;--Macrocell 10 (2/3)
                    b4_17_ec1ec4ec7 <= mc3x1_17_ec1ec4ec7;--Macrocell 10 (2/3)
                    b4_18_ec1ec4ec7 <= mc3x1_18_ec1ec4ec7;--Macrocell 10 (2/3)
                    b4_19_ec1ec4ec7 <= mc3x1_19_ec1ec4ec7;--Macrocell 10 (2/3)
                    b4_20_ec1ec4ec7 <= mc3x1_20_ec1ec4ec7;--Macrocell 10 (2/3)
                    b4_21_ec1ec4ec7 <= mc3x1_21_ec1ec4ec7;--Macrocell 10 (2/3)
                    ce2_ec1ec4ec7 <= '1';
                    b2_0_ec1ec4ec7 <= mc3x1_0_ec1ec4ec7;--Macrocell 11 (1/3)
                    b2_1_ec1ec4ec7 <= mc3x1_1_ec1ec4ec7;--Macrocell 11 (1/3)
                    b2_2_ec1ec4ec7 <= mc3x1_2_ec1ec4ec7;--Macrocell 11 (1/3)
                    b2_3_ec1ec4ec7 <= mc3x1_3_ec1ec4ec7;--Macrocell 11 (1/3)
                    b2_4_ec1ec4ec7 <= mc3x1_4_ec1ec4ec7;--Macrocell 11 (1/3)
                    b2_5_ec1ec4ec7 <= mc3x1_5_ec1ec4ec7;--Macrocell 11 (1/3)
                    b2_6_ec1ec4ec7 <= mc3x1_6_ec1ec4ec7;--Macrocell 11 (1/3)
                    b2_7_ec1ec4ec7 <= mc3x1_7_ec1ec4ec7;--Macrocell 11 (1/3)
                    b2_8_ec1ec4ec7 <= mc3x1_8_ec1ec4ec7;--Macrocell 11 (1/3)
                    b2_9_ec1ec4ec7 <= mc3x1_9_ec1ec4ec7;--Macrocell 11 (1/3)
                    b2_10_ec1ec4ec7 <= mc3x1_10_ec1ec4ec7;--Macrocell 11 (1/3)
                    b2_11_ec1ec4ec7 <= mc3x1_11_ec1ec4ec7;--Macrocell 11 (1/3)
                    b2_12_ec1ec4ec7 <= mc3x1_12_ec1ec4ec7;--Macrocell 11 (1/3)
                    b2_13_ec1ec4ec7 <= mc3x1_13_ec1ec4ec7;--Macrocell 11 (1/3)
                    b2_14_ec1ec4ec7 <= mc3x1_14_ec1ec4ec7;--Macrocell 11 (1/3)
                    b2_15_ec1ec4ec7 <= mc3x1_15_ec1ec4ec7;--Macrocell 11 (1/3)
                    b2_16_ec1ec4ec7 <= mc3x1_16_ec1ec4ec7;--Macrocell 11 (1/3)
                    b2_17_ec1ec4ec7 <= mc3x1_17_ec1ec4ec7;--Macrocell 11 (1/3)
                    b2_18_ec1ec4ec7 <= mc3x1_18_ec1ec4ec7;--Macrocell 11 (1/3)
                    b2_19_ec1ec4ec7 <= mc3x1_19_ec1ec4ec7;--Macrocell 11 (1/3)
                    b2_20_ec1ec4ec7 <= mc3x1_20_ec1ec4ec7;--Macrocell 11 (1/3)
                    b2_21_ec1ec4ec7 <= mc3x1_21_ec1ec4ec7;--Macrocell 11 (1/3)
                    
                    ce3_ec2ec5ec8 <= '1';
                    b3_0_ec2ec5ec8 <= mc3x1_0_ec2ec5ec8;--Macrocell 17 (3/3)
                    b3_1_ec2ec5ec8 <= mc3x1_1_ec2ec5ec8;--Macrocell 17 (3/3)
                    b3_2_ec2ec5ec8 <= mc3x1_2_ec2ec5ec8;--Macrocell 17 (3/3)
                    b3_3_ec2ec5ec8 <= mc3x1_3_ec2ec5ec8;--Macrocell 17 (3/3)
                    b3_4_ec2ec5ec8 <= mc3x1_4_ec2ec5ec8;--Macrocell 17 (3/3)
                    b3_5_ec2ec5ec8 <= mc3x1_5_ec2ec5ec8;--Macrocell 17 (3/3)
                    b3_6_ec2ec5ec8 <= mc3x1_6_ec2ec5ec8;--Macrocell 17 (3/3)
                    b3_7_ec2ec5ec8 <= mc3x1_7_ec2ec5ec8;--Macrocell 17 (3/3)
                    b3_8_ec2ec5ec8 <= mc3x1_8_ec2ec5ec8;--Macrocell 17 (3/3)
                    b3_9_ec2ec5ec8 <= mc3x1_9_ec2ec5ec8;--Macrocell 17 (3/3)
                    b3_10_ec2ec5ec8 <= mc3x1_10_ec2ec5ec8;--Macrocell 17 (3/3)
                    b3_11_ec2ec5ec8 <= mc3x1_11_ec2ec5ec8;--Macrocell 17 (3/3)
                    b3_12_ec2ec5ec8 <= mc3x1_12_ec2ec5ec8;--Macrocell 17 (3/3)
                    b3_13_ec2ec5ec8 <= mc3x1_13_ec2ec5ec8;--Macrocell 17 (3/3)
                    b3_14_ec2ec5ec8 <= mc3x1_14_ec2ec5ec8;--Macrocell 17 (3/3)
                    b3_15_ec2ec5ec8 <= mc3x1_15_ec2ec5ec8;--Macrocell 17 (3/3)
                    b3_16_ec2ec5ec8 <= mc3x1_16_ec2ec5ec8;--Macrocell 17 (3/3)
                    b3_17_ec2ec5ec8 <= mc3x1_17_ec2ec5ec8;--Macrocell 17 (3/3)
                    b3_18_ec2ec5ec8 <= mc3x1_18_ec2ec5ec8;--Macrocell 17 (3/3)
                    b3_19_ec2ec5ec8 <= mc3x1_19_ec2ec5ec8;--Macrocell 17 (3/3)
                    b3_20_ec2ec5ec8 <= mc3x1_20_ec2ec5ec8;--Macrocell 17 (3/3)
                    b3_21_ec2ec5ec8 <= mc3x1_21_ec2ec5ec8;--Macrocell 17 (3/3)
                    ce4_ec2ec5ec8 <= '1';
                    b4_0_ec2ec5ec8 <= mc3x1_0_ec2ec5ec8;--Macrocell 18 (2/3)
                    b4_1_ec2ec5ec8 <= mc3x1_1_ec2ec5ec8;--Macrocell 18 (2/3)
                    b4_2_ec2ec5ec8 <= mc3x1_2_ec2ec5ec8;--Macrocell 18 (2/3)
                    b4_3_ec2ec5ec8 <= mc3x1_3_ec2ec5ec8;--Macrocell 18 (2/3)
                    b4_4_ec2ec5ec8 <= mc3x1_4_ec2ec5ec8;--Macrocell 18 (2/3)
                    b4_5_ec2ec5ec8 <= mc3x1_5_ec2ec5ec8;--Macrocell 18 (2/3)
                    b4_6_ec2ec5ec8 <= mc3x1_6_ec2ec5ec8;--Macrocell 18 (2/3)
                    b4_7_ec2ec5ec8 <= mc3x1_7_ec2ec5ec8;--Macrocell 18 (2/3)
                    b4_8_ec2ec5ec8 <= mc3x1_8_ec2ec5ec8;--Macrocell 18 (2/3)
                    b4_9_ec2ec5ec8 <= mc3x1_9_ec2ec5ec8;--Macrocell 18 (2/3)
                    b4_10_ec2ec5ec8 <= mc3x1_10_ec2ec5ec8;--Macrocell 18 (2/3)
                    b4_11_ec2ec5ec8 <= mc3x1_11_ec2ec5ec8;--Macrocell 18 (2/3)
                    b4_12_ec2ec5ec8 <= mc3x1_12_ec2ec5ec8;--Macrocell 18 (2/3)
                    b4_13_ec2ec5ec8 <= mc3x1_13_ec2ec5ec8;--Macrocell 18 (2/3)
                    b4_14_ec2ec5ec8 <= mc3x1_14_ec2ec5ec8;--Macrocell 18 (2/3)
                    b4_15_ec2ec5ec8 <= mc3x1_15_ec2ec5ec8;--Macrocell 18 (2/3)
                    b4_16_ec2ec5ec8 <= mc3x1_16_ec2ec5ec8;--Macrocell 18 (2/3)
                    b4_17_ec2ec5ec8 <= mc3x1_17_ec2ec5ec8;--Macrocell 18 (2/3)
                    b4_18_ec2ec5ec8 <= mc3x1_18_ec2ec5ec8;--Macrocell 18 (2/3)
                    b4_19_ec2ec5ec8 <= mc3x1_19_ec2ec5ec8;--Macrocell 18 (2/3)
                    b4_20_ec2ec5ec8 <= mc3x1_20_ec2ec5ec8;--Macrocell 18 (2/3)
                    b4_21_ec2ec5ec8 <= mc3x1_21_ec2ec5ec8;--Macrocell 18 (2/3)
                    ce2_ec2ec5ec8 <= '1';
                    b2_0_ec2ec5ec8 <= mc3x1_0_ec2ec5ec8;--Macrocell 19 (1/3)
                    b2_1_ec2ec5ec8 <= mc3x1_1_ec2ec5ec8;--Macrocell 19 (1/3)
                    b2_2_ec2ec5ec8 <= mc3x1_2_ec2ec5ec8;--Macrocell 19 (1/3)
                    b2_3_ec2ec5ec8 <= mc3x1_3_ec2ec5ec8;--Macrocell 19 (1/3)
                    b2_4_ec2ec5ec8 <= mc3x1_4_ec2ec5ec8;--Macrocell 19 (1/3)
                    b2_5_ec2ec5ec8 <= mc3x1_5_ec2ec5ec8;--Macrocell 19 (1/3)
                    b2_6_ec2ec5ec8 <= mc3x1_6_ec2ec5ec8;--Macrocell 19 (1/3)
                    b2_7_ec2ec5ec8 <= mc3x1_7_ec2ec5ec8;--Macrocell 19 (1/3)
                    b2_8_ec2ec5ec8 <= mc3x1_8_ec2ec5ec8;--Macrocell 19 (1/3)
                    b2_9_ec2ec5ec8 <= mc3x1_9_ec2ec5ec8;--Macrocell 19 (1/3)
                    b2_10_ec2ec5ec8 <= mc3x1_10_ec2ec5ec8;--Macrocell 19 (1/3)
                    b2_11_ec2ec5ec8 <= mc3x1_11_ec2ec5ec8;--Macrocell 19 (1/3)
                    b2_12_ec2ec5ec8 <= mc3x1_12_ec2ec5ec8;--Macrocell 19 (1/3)
                    b2_13_ec2ec5ec8 <= mc3x1_13_ec2ec5ec8;--Macrocell 19 (1/3)
                    b2_14_ec2ec5ec8 <= mc3x1_14_ec2ec5ec8;--Macrocell 19 (1/3)
                    b2_15_ec2ec5ec8 <= mc3x1_15_ec2ec5ec8;--Macrocell 19 (1/3)
                    b2_16_ec2ec5ec8 <= mc3x1_16_ec2ec5ec8;--Macrocell 19 (1/3)
                    b2_17_ec2ec5ec8 <= mc3x1_17_ec2ec5ec8;--Macrocell 19 (1/3)
                    b2_18_ec2ec5ec8 <= mc3x1_18_ec2ec5ec8;--Macrocell 19 (1/3)
                    b2_19_ec2ec5ec8 <= mc3x1_19_ec2ec5ec8;--Macrocell 19 (1/3)
                    b2_20_ec2ec5ec8 <= mc3x1_20_ec2ec5ec8;--Macrocell 19 (1/3)
                    b2_21_ec2ec5ec8 <= mc3x1_21_ec2ec5ec8;--Macrocell 19 (1/3)
                    
                    state_macrocell <= s9;
                end if;
            when s9 =>
                    ce0_ec0ec3ec6 <= '0';
                    ce1_ec0ec3ec6 <= '0';
                    ce2_ec0ec3ec6 <= '0';
                    
                    ce0_ec1ec4ec7 <= '0';
                    ce1_ec1ec4ec7 <= '0';
                    ce2_ec1ec4ec7 <= '0';
                    ce3_ec1ec4ec7 <= '0';
                    ce4_ec1ec4ec7 <= '0';
                    
                    ce0_ec2ec5ec8 <= '0';
                    ce1_ec2ec5ec8 <= '0';
                    ce2_ec2ec5ec8 <= '0';
                    ce3_ec2ec5ec8 <= '0';
                    ce4_ec2ec5ec8 <= '0';
                    
                    mc_ready <= '1';
                    state_macrocell <= s10;
            when s10 =>
                    mc_ready <= '0';
                    sclr1_ec0ec3ec6 <= '1';
                    sclr3_ec1ec4ec7 <= '1';
                    sclr3_ec2ec5ec8 <= '1';
                    state_macrocell <= s11;
            when s11 =>
                    sclr1_ec0ec3ec6 <= '0';
                    sclr3_ec1ec4ec7 <= '0';
                    sclr3_ec2ec5ec8 <= '0';
                    state_macrocell <= s12;
            when s12 =>
                if (mc3x1_ready_ec0ec3ec6 = '1' and mc3x1_ready_ec1ec4ec7 = '1' and mc3x1_ready_ec2ec5ec8 = '1') then
                    ce2_ec0ec3ec6 <= '1';
                    b2_0_ec0ec3ec6 <= mc3x1_0_ec0ec3ec6;--Macrocell 2 (3/3)
                    b2_1_ec0ec3ec6 <= mc3x1_1_ec0ec3ec6;--Macrocell 2 (3/3)
                    b2_2_ec0ec3ec6 <= mc3x1_2_ec0ec3ec6;--Macrocell 2 (3/3)
                    b2_3_ec0ec3ec6 <= mc3x1_3_ec0ec3ec6;--Macrocell 2 (3/3)
                    b2_4_ec0ec3ec6 <= mc3x1_4_ec0ec3ec6;--Macrocell 2 (3/3)
                    b2_5_ec0ec3ec6 <= mc3x1_5_ec0ec3ec6;--Macrocell 2 (3/3)
                    b2_6_ec0ec3ec6 <= mc3x1_6_ec0ec3ec6;--Macrocell 2 (3/3)
                    b2_7_ec0ec3ec6 <= mc3x1_7_ec0ec3ec6;--Macrocell 2 (3/3)
                    b2_8_ec0ec3ec6 <= mc3x1_8_ec0ec3ec6;--Macrocell 2 (3/3)
                    b2_9_ec0ec3ec6 <= mc3x1_9_ec0ec3ec6;--Macrocell 2 (3/3)
                    b2_10_ec0ec3ec6 <= mc3x1_10_ec0ec3ec6;--Macrocell 2 (3/3)
                    b2_11_ec0ec3ec6 <= mc3x1_11_ec0ec3ec6;--Macrocell 2 (3/3)
                    b2_12_ec0ec3ec6 <= mc3x1_12_ec0ec3ec6;--Macrocell 2 (3/3)
                    b2_13_ec0ec3ec6 <= mc3x1_13_ec0ec3ec6;--Macrocell 2 (3/3)
                    b2_14_ec0ec3ec6 <= mc3x1_14_ec0ec3ec6;--Macrocell 2 (3/3)
                    b2_15_ec0ec3ec6 <= mc3x1_15_ec0ec3ec6;--Macrocell 2 (3/3)
                    b2_16_ec0ec3ec6 <= mc3x1_16_ec0ec3ec6;--Macrocell 2 (3/3)
                    b2_17_ec0ec3ec6 <= mc3x1_17_ec0ec3ec6;--Macrocell 2 (3/3)
                    b2_18_ec0ec3ec6 <= mc3x1_18_ec0ec3ec6;--Macrocell 2 (3/3)
                    b2_19_ec0ec3ec6 <= mc3x1_19_ec0ec3ec6;--Macrocell 2 (3/3)
                    b2_20_ec0ec3ec6 <= mc3x1_20_ec0ec3ec6;--Macrocell 2 (3/3)
                    b2_21_ec0ec3ec6 <= mc3x1_21_ec0ec3ec6;--Macrocell 2 (3/3)
                    ce0_ec0ec3ec6 <= '1';
                    b0_0_ec0ec3ec6 <= mc3x1_0_ec0ec3ec6;--Macrocell 3 (2/3)
                    b0_1_ec0ec3ec6 <= mc3x1_1_ec0ec3ec6;--Macrocell 3 (2/3)
                    b0_2_ec0ec3ec6 <= mc3x1_2_ec0ec3ec6;--Macrocell 3 (2/3)
                    b0_3_ec0ec3ec6 <= mc3x1_3_ec0ec3ec6;--Macrocell 3 (2/3)
                    b0_4_ec0ec3ec6 <= mc3x1_4_ec0ec3ec6;--Macrocell 3 (2/3)
                    b0_5_ec0ec3ec6 <= mc3x1_5_ec0ec3ec6;--Macrocell 3 (2/3)
                    b0_6_ec0ec3ec6 <= mc3x1_6_ec0ec3ec6;--Macrocell 3 (2/3)
                    b0_7_ec0ec3ec6 <= mc3x1_7_ec0ec3ec6;--Macrocell 3 (2/3)
                    b0_8_ec0ec3ec6 <= mc3x1_8_ec0ec3ec6;--Macrocell 3 (2/3)
                    b0_9_ec0ec3ec6 <= mc3x1_9_ec0ec3ec6;--Macrocell 3 (2/3)
                    b0_10_ec0ec3ec6 <= mc3x1_10_ec0ec3ec6;--Macrocell 3 (2/3)
                    b0_11_ec0ec3ec6 <= mc3x1_11_ec0ec3ec6;--Macrocell 3 (2/3)
                    b0_12_ec0ec3ec6 <= mc3x1_12_ec0ec3ec6;--Macrocell 3 (2/3)
                    b0_13_ec0ec3ec6 <= mc3x1_13_ec0ec3ec6;--Macrocell 3 (2/3)
                    b0_14_ec0ec3ec6 <= mc3x1_14_ec0ec3ec6;--Macrocell 3 (2/3)
                    b0_15_ec0ec3ec6 <= mc3x1_15_ec0ec3ec6;--Macrocell 3 (2/3)
                    b0_16_ec0ec3ec6 <= mc3x1_16_ec0ec3ec6;--Macrocell 3 (2/3)
                    b0_17_ec0ec3ec6 <= mc3x1_17_ec0ec3ec6;--Macrocell 3 (2/3)
                    b0_18_ec0ec3ec6 <= mc3x1_18_ec0ec3ec6;--Macrocell 3 (2/3)
                    b0_19_ec0ec3ec6 <= mc3x1_19_ec0ec3ec6;--Macrocell 3 (2/3)
                    b0_20_ec0ec3ec6 <= mc3x1_20_ec0ec3ec6;--Macrocell 3 (2/3)
                    b0_21_ec0ec3ec6 <= mc3x1_21_ec0ec3ec6;--Macrocell 3 (2/3)
                    ce1_ec0ec3ec6 <= '1';
                    b1_0_ec0ec3ec6 <= mc3x1_0_ec0ec3ec6;--Macrocell 4 (1/3)
                    b1_1_ec0ec3ec6 <= mc3x1_1_ec0ec3ec6;--Macrocell 4 (1/3)
                    b1_2_ec0ec3ec6 <= mc3x1_2_ec0ec3ec6;--Macrocell 4 (1/3)
                    b1_3_ec0ec3ec6 <= mc3x1_3_ec0ec3ec6;--Macrocell 4 (1/3)
                    b1_4_ec0ec3ec6 <= mc3x1_4_ec0ec3ec6;--Macrocell 4 (1/3)
                    b1_5_ec0ec3ec6 <= mc3x1_5_ec0ec3ec6;--Macrocell 4 (1/3)
                    b1_6_ec0ec3ec6 <= mc3x1_6_ec0ec3ec6;--Macrocell 4 (1/3)
                    b1_7_ec0ec3ec6 <= mc3x1_7_ec0ec3ec6;--Macrocell 4 (1/3)
                    b1_8_ec0ec3ec6 <= mc3x1_8_ec0ec3ec6;--Macrocell 4 (1/3)
                    b1_9_ec0ec3ec6 <= mc3x1_9_ec0ec3ec6;--Macrocell 4 (1/3)
                    b1_10_ec0ec3ec6 <= mc3x1_10_ec0ec3ec6;--Macrocell 4 (1/3)
                    b1_11_ec0ec3ec6 <= mc3x1_11_ec0ec3ec6;--Macrocell 4 (1/3)
                    b1_12_ec0ec3ec6 <= mc3x1_12_ec0ec3ec6;--Macrocell 4 (1/3)
                    b1_13_ec0ec3ec6 <= mc3x1_13_ec0ec3ec6;--Macrocell 4 (1/3)
                    b1_14_ec0ec3ec6 <= mc3x1_14_ec0ec3ec6;--Macrocell 4 (1/3)
                    b1_15_ec0ec3ec6 <= mc3x1_15_ec0ec3ec6;--Macrocell 4 (1/3)
                    b1_16_ec0ec3ec6 <= mc3x1_16_ec0ec3ec6;--Macrocell 4 (1/3)
                    b1_17_ec0ec3ec6 <= mc3x1_17_ec0ec3ec6;--Macrocell 4 (1/3)
                    b1_18_ec0ec3ec6 <= mc3x1_18_ec0ec3ec6;--Macrocell 4 (1/3)
                    b1_19_ec0ec3ec6 <= mc3x1_19_ec0ec3ec6;--Macrocell 4 (1/3)
                    b1_20_ec0ec3ec6 <= mc3x1_20_ec0ec3ec6;--Macrocell 4 (1/3)
                    b1_21_ec0ec3ec6 <= mc3x1_21_ec0ec3ec6;--Macrocell 4 (1/3)
                    
                    ce4_ec1ec4ec7 <= '1';
                    b4_0_ec1ec4ec7 <= mc3x1_0_ec1ec4ec7;--Macrocell 10 (3/3)
                    b4_1_ec1ec4ec7 <= mc3x1_1_ec1ec4ec7;--Macrocell 10 (3/3)
                    b4_2_ec1ec4ec7 <= mc3x1_2_ec1ec4ec7;--Macrocell 10 (3/3)
                    b4_3_ec1ec4ec7 <= mc3x1_3_ec1ec4ec7;--Macrocell 10 (3/3)
                    b4_4_ec1ec4ec7 <= mc3x1_4_ec1ec4ec7;--Macrocell 10 (3/3)
                    b4_5_ec1ec4ec7 <= mc3x1_5_ec1ec4ec7;--Macrocell 10 (3/3)
                    b4_6_ec1ec4ec7 <= mc3x1_6_ec1ec4ec7;--Macrocell 10 (3/3)
                    b4_7_ec1ec4ec7 <= mc3x1_7_ec1ec4ec7;--Macrocell 10 (3/3)
                    b4_8_ec1ec4ec7 <= mc3x1_8_ec1ec4ec7;--Macrocell 10 (3/3)
                    b4_9_ec1ec4ec7 <= mc3x1_9_ec1ec4ec7;--Macrocell 10 (3/3)
                    b4_10_ec1ec4ec7 <= mc3x1_10_ec1ec4ec7;--Macrocell 10 (3/3)
                    b4_11_ec1ec4ec7 <= mc3x1_11_ec1ec4ec7;--Macrocell 10 (3/3)
                    b4_12_ec1ec4ec7 <= mc3x1_12_ec1ec4ec7;--Macrocell 10 (3/3)
                    b4_13_ec1ec4ec7 <= mc3x1_13_ec1ec4ec7;--Macrocell 10 (3/3)
                    b4_14_ec1ec4ec7 <= mc3x1_14_ec1ec4ec7;--Macrocell 10 (3/3)
                    b4_15_ec1ec4ec7 <= mc3x1_15_ec1ec4ec7;--Macrocell 10 (3/3)
                    b4_16_ec1ec4ec7 <= mc3x1_16_ec1ec4ec7;--Macrocell 10 (3/3)
                    b4_17_ec1ec4ec7 <= mc3x1_17_ec1ec4ec7;--Macrocell 10 (3/3)
                    b4_18_ec1ec4ec7 <= mc3x1_18_ec1ec4ec7;--Macrocell 10 (3/3)
                    b4_19_ec1ec4ec7 <= mc3x1_19_ec1ec4ec7;--Macrocell 10 (3/3)
                    b4_20_ec1ec4ec7 <= mc3x1_20_ec1ec4ec7;--Macrocell 10 (3/3)
                    b4_21_ec1ec4ec7 <= mc3x1_21_ec1ec4ec7;--Macrocell 10 (3/3)
                    ce2_ec1ec4ec7 <= '1';
                    b2_0_ec1ec4ec7 <= mc3x1_0_ec1ec4ec7;--Macrocell 11 (2/3)
                    b2_1_ec1ec4ec7 <= mc3x1_1_ec1ec4ec7;--Macrocell 11 (2/3)
                    b2_2_ec1ec4ec7 <= mc3x1_2_ec1ec4ec7;--Macrocell 11 (2/3)
                    b2_3_ec1ec4ec7 <= mc3x1_3_ec1ec4ec7;--Macrocell 11 (2/3)
                    b2_4_ec1ec4ec7 <= mc3x1_4_ec1ec4ec7;--Macrocell 11 (2/3)
                    b2_5_ec1ec4ec7 <= mc3x1_5_ec1ec4ec7;--Macrocell 11 (2/3)
                    b2_6_ec1ec4ec7 <= mc3x1_6_ec1ec4ec7;--Macrocell 11 (2/3)
                    b2_7_ec1ec4ec7 <= mc3x1_7_ec1ec4ec7;--Macrocell 11 (2/3)
                    b2_8_ec1ec4ec7 <= mc3x1_8_ec1ec4ec7;--Macrocell 11 (2/3)
                    b2_9_ec1ec4ec7 <= mc3x1_9_ec1ec4ec7;--Macrocell 11 (2/3)
                    b2_10_ec1ec4ec7 <= mc3x1_10_ec1ec4ec7;--Macrocell 11 (2/3)
                    b2_11_ec1ec4ec7 <= mc3x1_11_ec1ec4ec7;--Macrocell 11 (2/3)
                    b2_12_ec1ec4ec7 <= mc3x1_12_ec1ec4ec7;--Macrocell 11 (2/3)
                    b2_13_ec1ec4ec7 <= mc3x1_13_ec1ec4ec7;--Macrocell 11 (2/3)
                    b2_14_ec1ec4ec7 <= mc3x1_14_ec1ec4ec7;--Macrocell 11 (2/3)
                    b2_15_ec1ec4ec7 <= mc3x1_15_ec1ec4ec7;--Macrocell 11 (2/3)
                    b2_16_ec1ec4ec7 <= mc3x1_16_ec1ec4ec7;--Macrocell 11 (2/3)
                    b2_17_ec1ec4ec7 <= mc3x1_17_ec1ec4ec7;--Macrocell 11 (2/3)
                    b2_18_ec1ec4ec7 <= mc3x1_18_ec1ec4ec7;--Macrocell 11 (2/3)
                    b2_19_ec1ec4ec7 <= mc3x1_19_ec1ec4ec7;--Macrocell 11 (2/3)
                    b2_20_ec1ec4ec7 <= mc3x1_20_ec1ec4ec7;--Macrocell 11 (2/3)
                    b2_21_ec1ec4ec7 <= mc3x1_21_ec1ec4ec7;--Macrocell 11 (2/3)
                    ce3_ec1ec4ec7 <= '1';
                    b3_0_ec1ec4ec7 <= mc3x1_0_ec1ec4ec7;--Macrocell 12 (1/3)
                    b3_1_ec1ec4ec7 <= mc3x1_1_ec1ec4ec7;--Macrocell 12 (1/3)
                    b3_2_ec1ec4ec7 <= mc3x1_2_ec1ec4ec7;--Macrocell 12 (1/3)
                    b3_3_ec1ec4ec7 <= mc3x1_3_ec1ec4ec7;--Macrocell 12 (1/3)
                    b3_4_ec1ec4ec7 <= mc3x1_4_ec1ec4ec7;--Macrocell 12 (1/3)
                    b3_5_ec1ec4ec7 <= mc3x1_5_ec1ec4ec7;--Macrocell 12 (1/3)
                    b3_6_ec1ec4ec7 <= mc3x1_6_ec1ec4ec7;--Macrocell 12 (1/3)
                    b3_7_ec1ec4ec7 <= mc3x1_7_ec1ec4ec7;--Macrocell 12 (1/3)
                    b3_8_ec1ec4ec7 <= mc3x1_8_ec1ec4ec7;--Macrocell 12 (1/3)
                    b3_9_ec1ec4ec7 <= mc3x1_9_ec1ec4ec7;--Macrocell 12 (1/3)
                    b3_10_ec1ec4ec7 <= mc3x1_10_ec1ec4ec7;--Macrocell 12 (1/3)
                    b3_11_ec1ec4ec7 <= mc3x1_11_ec1ec4ec7;--Macrocell 12 (1/3)
                    b3_12_ec1ec4ec7 <= mc3x1_12_ec1ec4ec7;--Macrocell 12 (1/3)
                    b3_13_ec1ec4ec7 <= mc3x1_13_ec1ec4ec7;--Macrocell 12 (1/3)
                    b3_14_ec1ec4ec7 <= mc3x1_14_ec1ec4ec7;--Macrocell 12 (1/3)
                    b3_15_ec1ec4ec7 <= mc3x1_15_ec1ec4ec7;--Macrocell 12 (1/3)
                    b3_16_ec1ec4ec7 <= mc3x1_16_ec1ec4ec7;--Macrocell 12 (1/3)
                    b3_17_ec1ec4ec7 <= mc3x1_17_ec1ec4ec7;--Macrocell 12 (1/3)
                    b3_18_ec1ec4ec7 <= mc3x1_18_ec1ec4ec7;--Macrocell 12 (1/3)
                    b3_19_ec1ec4ec7 <= mc3x1_19_ec1ec4ec7;--Macrocell 12 (1/3)
                    b3_20_ec1ec4ec7 <= mc3x1_20_ec1ec4ec7;--Macrocell 12 (1/3)
                    b3_21_ec1ec4ec7 <= mc3x1_21_ec1ec4ec7;--Macrocell 12 (1/3)
                    
                    ce4_ec2ec5ec8 <= '1';
                    b4_0_ec2ec5ec8 <= mc3x1_0_ec2ec5ec8;--Macrocell 18 (3/3)
                    b4_1_ec2ec5ec8 <= mc3x1_1_ec2ec5ec8;--Macrocell 18 (3/3)
                    b4_2_ec2ec5ec8 <= mc3x1_2_ec2ec5ec8;--Macrocell 18 (3/3)
                    b4_3_ec2ec5ec8 <= mc3x1_3_ec2ec5ec8;--Macrocell 18 (3/3)
                    b4_4_ec2ec5ec8 <= mc3x1_4_ec2ec5ec8;--Macrocell 18 (3/3)
                    b4_5_ec2ec5ec8 <= mc3x1_5_ec2ec5ec8;--Macrocell 18 (3/3)
                    b4_6_ec2ec5ec8 <= mc3x1_6_ec2ec5ec8;--Macrocell 18 (3/3)
                    b4_7_ec2ec5ec8 <= mc3x1_7_ec2ec5ec8;--Macrocell 18 (3/3)
                    b4_8_ec2ec5ec8 <= mc3x1_8_ec2ec5ec8;--Macrocell 18 (3/3)
                    b4_9_ec2ec5ec8 <= mc3x1_9_ec2ec5ec8;--Macrocell 18 (3/3)
                    b4_10_ec2ec5ec8 <= mc3x1_10_ec2ec5ec8;--Macrocell 18 (3/3)
                    b4_11_ec2ec5ec8 <= mc3x1_11_ec2ec5ec8;--Macrocell 18 (3/3)
                    b4_12_ec2ec5ec8 <= mc3x1_12_ec2ec5ec8;--Macrocell 18 (3/3)
                    b4_13_ec2ec5ec8 <= mc3x1_13_ec2ec5ec8;--Macrocell 18 (3/3)
                    b4_14_ec2ec5ec8 <= mc3x1_14_ec2ec5ec8;--Macrocell 18 (3/3)
                    b4_15_ec2ec5ec8 <= mc3x1_15_ec2ec5ec8;--Macrocell 18 (3/3)
                    b4_16_ec2ec5ec8 <= mc3x1_16_ec2ec5ec8;--Macrocell 18 (3/3)
                    b4_17_ec2ec5ec8 <= mc3x1_17_ec2ec5ec8;--Macrocell 18 (3/3)
                    b4_18_ec2ec5ec8 <= mc3x1_18_ec2ec5ec8;--Macrocell 18 (3/3)
                    b4_19_ec2ec5ec8 <= mc3x1_19_ec2ec5ec8;--Macrocell 18 (3/3)
                    b4_20_ec2ec5ec8 <= mc3x1_20_ec2ec5ec8;--Macrocell 18 (3/3)
                    b4_21_ec2ec5ec8 <= mc3x1_21_ec2ec5ec8;--Macrocell 18 (3/3)
                    ce2_ec2ec5ec8 <= '1';
                    b2_0_ec2ec5ec8 <= mc3x1_0_ec2ec5ec8;--Macrocell 19 (2/3)
                    b2_1_ec2ec5ec8 <= mc3x1_1_ec2ec5ec8;--Macrocell 19 (2/3)
                    b2_2_ec2ec5ec8 <= mc3x1_2_ec2ec5ec8;--Macrocell 19 (2/3)
                    b2_3_ec2ec5ec8 <= mc3x1_3_ec2ec5ec8;--Macrocell 19 (2/3)
                    b2_4_ec2ec5ec8 <= mc3x1_4_ec2ec5ec8;--Macrocell 19 (2/3)
                    b2_5_ec2ec5ec8 <= mc3x1_5_ec2ec5ec8;--Macrocell 19 (2/3)
                    b2_6_ec2ec5ec8 <= mc3x1_6_ec2ec5ec8;--Macrocell 19 (2/3)
                    b2_7_ec2ec5ec8 <= mc3x1_7_ec2ec5ec8;--Macrocell 19 (2/3)
                    b2_8_ec2ec5ec8 <= mc3x1_8_ec2ec5ec8;--Macrocell 19 (2/3)
                    b2_9_ec2ec5ec8 <= mc3x1_9_ec2ec5ec8;--Macrocell 19 (2/3)
                    b2_10_ec2ec5ec8 <= mc3x1_10_ec2ec5ec8;--Macrocell 19 (2/3)
                    b2_11_ec2ec5ec8 <= mc3x1_11_ec2ec5ec8;--Macrocell 19 (2/3)
                    b2_12_ec2ec5ec8 <= mc3x1_12_ec2ec5ec8;--Macrocell 19 (2/3)
                    b2_13_ec2ec5ec8 <= mc3x1_13_ec2ec5ec8;--Macrocell 19 (2/3)
                    b2_14_ec2ec5ec8 <= mc3x1_14_ec2ec5ec8;--Macrocell 19 (2/3)
                    b2_15_ec2ec5ec8 <= mc3x1_15_ec2ec5ec8;--Macrocell 19 (2/3)
                    b2_16_ec2ec5ec8 <= mc3x1_16_ec2ec5ec8;--Macrocell 19 (2/3)
                    b2_17_ec2ec5ec8 <= mc3x1_17_ec2ec5ec8;--Macrocell 19 (2/3)
                    b2_18_ec2ec5ec8 <= mc3x1_18_ec2ec5ec8;--Macrocell 19 (2/3)
                    b2_19_ec2ec5ec8 <= mc3x1_19_ec2ec5ec8;--Macrocell 19 (2/3)
                    b2_20_ec2ec5ec8 <= mc3x1_20_ec2ec5ec8;--Macrocell 19 (2/3)
                    b2_21_ec2ec5ec8 <= mc3x1_21_ec2ec5ec8;--Macrocell 19 (2/3)
                    ce3_ec2ec5ec8 <= '1';
                    b3_0_ec2ec5ec8 <= mc3x1_0_ec2ec5ec8;--Macrocell 20 (1/3)
                    b3_1_ec2ec5ec8 <= mc3x1_1_ec2ec5ec8;--Macrocell 20 (1/3)
                    b3_2_ec2ec5ec8 <= mc3x1_2_ec2ec5ec8;--Macrocell 20 (1/3)
                    b3_3_ec2ec5ec8 <= mc3x1_3_ec2ec5ec8;--Macrocell 20 (1/3)
                    b3_4_ec2ec5ec8 <= mc3x1_4_ec2ec5ec8;--Macrocell 20 (1/3)
                    b3_5_ec2ec5ec8 <= mc3x1_5_ec2ec5ec8;--Macrocell 20 (1/3)
                    b3_6_ec2ec5ec8 <= mc3x1_6_ec2ec5ec8;--Macrocell 20 (1/3)
                    b3_7_ec2ec5ec8 <= mc3x1_7_ec2ec5ec8;--Macrocell 20 (1/3)
                    b3_8_ec2ec5ec8 <= mc3x1_8_ec2ec5ec8;--Macrocell 20 (1/3)
                    b3_9_ec2ec5ec8 <= mc3x1_9_ec2ec5ec8;--Macrocell 20 (1/3)
                    b3_10_ec2ec5ec8 <= mc3x1_10_ec2ec5ec8;--Macrocell 20 (1/3)
                    b3_11_ec2ec5ec8 <= mc3x1_11_ec2ec5ec8;--Macrocell 20 (1/3)
                    b3_12_ec2ec5ec8 <= mc3x1_12_ec2ec5ec8;--Macrocell 20 (1/3)
                    b3_13_ec2ec5ec8 <= mc3x1_13_ec2ec5ec8;--Macrocell 20 (1/3)
                    b3_14_ec2ec5ec8 <= mc3x1_14_ec2ec5ec8;--Macrocell 20 (1/3)
                    b3_15_ec2ec5ec8 <= mc3x1_15_ec2ec5ec8;--Macrocell 20 (1/3)
                    b3_16_ec2ec5ec8 <= mc3x1_16_ec2ec5ec8;--Macrocell 20 (1/3)
                    b3_17_ec2ec5ec8 <= mc3x1_17_ec2ec5ec8;--Macrocell 20 (1/3)
                    b3_18_ec2ec5ec8 <= mc3x1_18_ec2ec5ec8;--Macrocell 20 (1/3)
                    b3_19_ec2ec5ec8 <= mc3x1_19_ec2ec5ec8;--Macrocell 20 (1/3)
                    b3_20_ec2ec5ec8 <= mc3x1_20_ec2ec5ec8;--Macrocell 20 (1/3)
                    b3_21_ec2ec5ec8 <= mc3x1_21_ec2ec5ec8;--Macrocell 20 (1/3)
                    
                    state_macrocell <= s13;
                end if;
            when s13=>
                    ce0_ec0ec3ec6 <= '0';
                    ce1_ec0ec3ec6 <= '0';
                    ce2_ec0ec3ec6 <= '0';
                    
                    ce0_ec1ec4ec7 <= '0';
                    ce1_ec1ec4ec7 <= '0';
                    ce2_ec1ec4ec7 <= '0';
                    ce3_ec1ec4ec7 <= '0';
                    ce4_ec1ec4ec7 <= '0';
                    
                    ce0_ec2ec5ec8 <= '0';
                    ce1_ec2ec5ec8 <= '0';
                    ce2_ec2ec5ec8 <= '0';
                    ce3_ec2ec5ec8 <= '0';
                    ce4_ec2ec5ec8 <= '0';
                    
                    mc_ready <= '1';
                    state_macrocell <= s14;
            when s14 =>
                    mc_ready <= '0';
                    sclr2_ec0ec3ec6 <= '1';
                    sclr4_ec1ec4ec7 <= '1';
                    sclr4_ec2ec5ec8 <= '1';
                    state_macrocell <= s15;
            when s15 =>
                    sclr2_ec0ec3ec6 <= '0';
                    sclr4_ec1ec4ec7 <= '0';
                    sclr4_ec2ec5ec8 <= '0';
                    state_macrocell <= s16;
            when s16 =>
                if (mc3x1_ready_ec0ec3ec6 = '1' and mc3x1_ready_ec1ec4ec7 = '1' and mc3x1_ready_ec2ec5ec8 = '1') then
                    ce0_ec0ec3ec6 <= '1';
                    b0_0_ec0ec3ec6 <= mc3x1_0_ec0ec3ec6;--Macrocell 3 (3/3)
                    b0_1_ec0ec3ec6 <= mc3x1_1_ec0ec3ec6;--Macrocell 3 (3/3)
                    b0_2_ec0ec3ec6 <= mc3x1_2_ec0ec3ec6;--Macrocell 3 (3/3)
                    b0_3_ec0ec3ec6 <= mc3x1_3_ec0ec3ec6;--Macrocell 3 (3/3)
                    b0_4_ec0ec3ec6 <= mc3x1_4_ec0ec3ec6;--Macrocell 3 (3/3)
                    b0_5_ec0ec3ec6 <= mc3x1_5_ec0ec3ec6;--Macrocell 3 (3/3)
                    b0_6_ec0ec3ec6 <= mc3x1_6_ec0ec3ec6;--Macrocell 3 (3/3)
                    b0_7_ec0ec3ec6 <= mc3x1_7_ec0ec3ec6;--Macrocell 3 (3/3)
                    b0_8_ec0ec3ec6 <= mc3x1_8_ec0ec3ec6;--Macrocell 3 (3/3)
                    b0_9_ec0ec3ec6 <= mc3x1_9_ec0ec3ec6;--Macrocell 3 (3/3)
                    b0_10_ec0ec3ec6 <= mc3x1_10_ec0ec3ec6;--Macrocell 3 (3/3)
                    b0_11_ec0ec3ec6 <= mc3x1_11_ec0ec3ec6;--Macrocell 3 (3/3)
                    b0_12_ec0ec3ec6 <= mc3x1_12_ec0ec3ec6;--Macrocell 3 (3/3)
                    b0_13_ec0ec3ec6 <= mc3x1_13_ec0ec3ec6;--Macrocell 3 (3/3)
                    b0_14_ec0ec3ec6 <= mc3x1_14_ec0ec3ec6;--Macrocell 3 (3/3)
                    b0_15_ec0ec3ec6 <= mc3x1_15_ec0ec3ec6;--Macrocell 3 (3/3)
                    b0_16_ec0ec3ec6 <= mc3x1_16_ec0ec3ec6;--Macrocell 3 (3/3)
                    b0_17_ec0ec3ec6 <= mc3x1_17_ec0ec3ec6;--Macrocell 3 (3/3)
                    b0_18_ec0ec3ec6 <= mc3x1_18_ec0ec3ec6;--Macrocell 3 (3/3)
                    b0_19_ec0ec3ec6 <= mc3x1_19_ec0ec3ec6;--Macrocell 3 (3/3)
                    b0_20_ec0ec3ec6 <= mc3x1_20_ec0ec3ec6;--Macrocell 3 (3/3)
                    b0_21_ec0ec3ec6 <= mc3x1_21_ec0ec3ec6;--Macrocell 3 (3/3)
                    ce1_ec0ec3ec6 <= '1';
                    b1_0_ec0ec3ec6 <= mc3x1_0_ec0ec3ec6;--Macrocell 4 (2/3)
                    b1_1_ec0ec3ec6 <= mc3x1_1_ec0ec3ec6;--Macrocell 4 (2/3)
                    b1_2_ec0ec3ec6 <= mc3x1_2_ec0ec3ec6;--Macrocell 4 (2/3)
                    b1_3_ec0ec3ec6 <= mc3x1_3_ec0ec3ec6;--Macrocell 4 (2/3)
                    b1_4_ec0ec3ec6 <= mc3x1_4_ec0ec3ec6;--Macrocell 4 (2/3)
                    b1_5_ec0ec3ec6 <= mc3x1_5_ec0ec3ec6;--Macrocell 4 (2/3)
                    b1_6_ec0ec3ec6 <= mc3x1_6_ec0ec3ec6;--Macrocell 4 (2/3)
                    b1_7_ec0ec3ec6 <= mc3x1_7_ec0ec3ec6;--Macrocell 4 (2/3)
                    b1_8_ec0ec3ec6 <= mc3x1_8_ec0ec3ec6;--Macrocell 4 (2/3)
                    b1_9_ec0ec3ec6 <= mc3x1_9_ec0ec3ec6;--Macrocell 4 (2/3)
                    b1_10_ec0ec3ec6 <= mc3x1_10_ec0ec3ec6;--Macrocell 4 (2/3)
                    b1_11_ec0ec3ec6 <= mc3x1_11_ec0ec3ec6;--Macrocell 4 (2/3)
                    b1_12_ec0ec3ec6 <= mc3x1_12_ec0ec3ec6;--Macrocell 4 (2/3)
                    b1_13_ec0ec3ec6 <= mc3x1_13_ec0ec3ec6;--Macrocell 4 (2/3)
                    b1_14_ec0ec3ec6 <= mc3x1_14_ec0ec3ec6;--Macrocell 4 (2/3)
                    b1_15_ec0ec3ec6 <= mc3x1_15_ec0ec3ec6;--Macrocell 4 (2/3)
                    b1_16_ec0ec3ec6 <= mc3x1_16_ec0ec3ec6;--Macrocell 4 (2/3)
                    b1_17_ec0ec3ec6 <= mc3x1_17_ec0ec3ec6;--Macrocell 4 (2/3)
                    b1_18_ec0ec3ec6 <= mc3x1_18_ec0ec3ec6;--Macrocell 4 (2/3)
                    b1_19_ec0ec3ec6 <= mc3x1_19_ec0ec3ec6;--Macrocell 4 (2/3)
                    b1_20_ec0ec3ec6 <= mc3x1_20_ec0ec3ec6;--Macrocell 4 (2/3)
                    b1_21_ec0ec3ec6 <= mc3x1_21_ec0ec3ec6;--Macrocell 4 (2/3)
                    ce2_ec0ec3ec6 <= '1';
                    b2_0_ec0ec3ec6 <= mc3x1_0_ec0ec3ec6;--Macrocell 5 (1/3)
                    b2_1_ec0ec3ec6 <= mc3x1_1_ec0ec3ec6;--Macrocell 5 (1/3)
                    b2_2_ec0ec3ec6 <= mc3x1_2_ec0ec3ec6;--Macrocell 5 (1/3)
                    b2_3_ec0ec3ec6 <= mc3x1_3_ec0ec3ec6;--Macrocell 5 (1/3)
                    b2_4_ec0ec3ec6 <= mc3x1_4_ec0ec3ec6;--Macrocell 5 (1/3)
                    b2_5_ec0ec3ec6 <= mc3x1_5_ec0ec3ec6;--Macrocell 5 (1/3)
                    b2_6_ec0ec3ec6 <= mc3x1_6_ec0ec3ec6;--Macrocell 5 (1/3)
                    b2_7_ec0ec3ec6 <= mc3x1_7_ec0ec3ec6;--Macrocell 5 (1/3)
                    b2_8_ec0ec3ec6 <= mc3x1_8_ec0ec3ec6;--Macrocell 5 (1/3)
                    b2_9_ec0ec3ec6 <= mc3x1_9_ec0ec3ec6;--Macrocell 5 (1/3)
                    b2_10_ec0ec3ec6 <= mc3x1_10_ec0ec3ec6;--Macrocell 5 (1/3)
                    b2_11_ec0ec3ec6 <= mc3x1_11_ec0ec3ec6;--Macrocell 5 (1/3)
                    b2_12_ec0ec3ec6 <= mc3x1_12_ec0ec3ec6;--Macrocell 5 (1/3)
                    b2_13_ec0ec3ec6 <= mc3x1_13_ec0ec3ec6;--Macrocell 5 (1/3)
                    b2_14_ec0ec3ec6 <= mc3x1_14_ec0ec3ec6;--Macrocell 5 (1/3)
                    b2_15_ec0ec3ec6 <= mc3x1_15_ec0ec3ec6;--Macrocell 5 (1/3)
                    b2_16_ec0ec3ec6 <= mc3x1_16_ec0ec3ec6;--Macrocell 5 (1/3)
                    b2_17_ec0ec3ec6 <= mc3x1_17_ec0ec3ec6;--Macrocell 5 (1/3)
                    b2_18_ec0ec3ec6 <= mc3x1_18_ec0ec3ec6;--Macrocell 5 (1/3)
                    b2_19_ec0ec3ec6 <= mc3x1_19_ec0ec3ec6;--Macrocell 5 (1/3)
                    b2_20_ec0ec3ec6 <= mc3x1_20_ec0ec3ec6;--Macrocell 5 (1/3)
                    b2_21_ec0ec3ec6 <= mc3x1_21_ec0ec3ec6;--Macrocell 5 (1/3)
                    
                    ce2_ec1ec4ec7 <= '1';
                    b2_0_ec1ec4ec7 <= mc3x1_0_ec1ec4ec7;--Macrocell 11 (3/3)
                    b2_1_ec1ec4ec7 <= mc3x1_1_ec1ec4ec7;--Macrocell 11 (3/3)
                    b2_2_ec1ec4ec7 <= mc3x1_2_ec1ec4ec7;--Macrocell 11 (3/3)
                    b2_3_ec1ec4ec7 <= mc3x1_3_ec1ec4ec7;--Macrocell 11 (3/3)
                    b2_4_ec1ec4ec7 <= mc3x1_4_ec1ec4ec7;--Macrocell 11 (3/3)
                    b2_5_ec1ec4ec7 <= mc3x1_5_ec1ec4ec7;--Macrocell 11 (3/3)
                    b2_6_ec1ec4ec7 <= mc3x1_6_ec1ec4ec7;--Macrocell 11 (3/3)
                    b2_7_ec1ec4ec7 <= mc3x1_7_ec1ec4ec7;--Macrocell 11 (3/3)
                    b2_8_ec1ec4ec7 <= mc3x1_8_ec1ec4ec7;--Macrocell 11 (3/3)
                    b2_9_ec1ec4ec7 <= mc3x1_9_ec1ec4ec7;--Macrocell 11 (3/3)
                    b2_10_ec1ec4ec7 <= mc3x1_10_ec1ec4ec7;--Macrocell 11 (3/3)
                    b2_11_ec1ec4ec7 <= mc3x1_11_ec1ec4ec7;--Macrocell 11 (3/3)
                    b2_12_ec1ec4ec7 <= mc3x1_12_ec1ec4ec7;--Macrocell 11 (3/3)
                    b2_13_ec1ec4ec7 <= mc3x1_13_ec1ec4ec7;--Macrocell 11 (3/3)
                    b2_14_ec1ec4ec7 <= mc3x1_14_ec1ec4ec7;--Macrocell 11 (3/3)
                    b2_15_ec1ec4ec7 <= mc3x1_15_ec1ec4ec7;--Macrocell 11 (3/3)
                    b2_16_ec1ec4ec7 <= mc3x1_16_ec1ec4ec7;--Macrocell 11 (3/3)
                    b2_17_ec1ec4ec7 <= mc3x1_17_ec1ec4ec7;--Macrocell 11 (3/3)
                    b2_18_ec1ec4ec7 <= mc3x1_18_ec1ec4ec7;--Macrocell 11 (3/3)
                    b2_19_ec1ec4ec7 <= mc3x1_19_ec1ec4ec7;--Macrocell 11 (3/3)
                    b2_20_ec1ec4ec7 <= mc3x1_20_ec1ec4ec7;--Macrocell 11 (3/3)
                    b2_21_ec1ec4ec7 <= mc3x1_21_ec1ec4ec7;--Macrocell 11 (3/3)
                    ce3_ec1ec4ec7 <= '1';
                    b3_0_ec1ec4ec7 <= mc3x1_0_ec1ec4ec7;--Macrocell 12 (2/3)
                    b3_1_ec1ec4ec7 <= mc3x1_1_ec1ec4ec7;--Macrocell 12 (2/3)
                    b3_2_ec1ec4ec7 <= mc3x1_2_ec1ec4ec7;--Macrocell 12 (2/3)
                    b3_3_ec1ec4ec7 <= mc3x1_3_ec1ec4ec7;--Macrocell 12 (2/3)
                    b3_4_ec1ec4ec7 <= mc3x1_4_ec1ec4ec7;--Macrocell 12 (2/3)
                    b3_5_ec1ec4ec7 <= mc3x1_5_ec1ec4ec7;--Macrocell 12 (2/3)
                    b3_6_ec1ec4ec7 <= mc3x1_6_ec1ec4ec7;--Macrocell 12 (2/3)
                    b3_7_ec1ec4ec7 <= mc3x1_7_ec1ec4ec7;--Macrocell 12 (2/3)
                    b3_8_ec1ec4ec7 <= mc3x1_8_ec1ec4ec7;--Macrocell 12 (2/3)
                    b3_9_ec1ec4ec7 <= mc3x1_9_ec1ec4ec7;--Macrocell 12 (2/3)
                    b3_10_ec1ec4ec7 <= mc3x1_10_ec1ec4ec7;--Macrocell 12 (2/3)
                    b3_11_ec1ec4ec7 <= mc3x1_11_ec1ec4ec7;--Macrocell 12 (2/3)
                    b3_12_ec1ec4ec7 <= mc3x1_12_ec1ec4ec7;--Macrocell 12 (2/3)
                    b3_13_ec1ec4ec7 <= mc3x1_13_ec1ec4ec7;--Macrocell 12 (2/3)
                    b3_14_ec1ec4ec7 <= mc3x1_14_ec1ec4ec7;--Macrocell 12 (2/3)
                    b3_15_ec1ec4ec7 <= mc3x1_15_ec1ec4ec7;--Macrocell 12 (2/3)
                    b3_16_ec1ec4ec7 <= mc3x1_16_ec1ec4ec7;--Macrocell 12 (2/3)
                    b3_17_ec1ec4ec7 <= mc3x1_17_ec1ec4ec7;--Macrocell 12 (2/3)
                    b3_18_ec1ec4ec7 <= mc3x1_18_ec1ec4ec7;--Macrocell 12 (2/3)
                    b3_19_ec1ec4ec7 <= mc3x1_19_ec1ec4ec7;--Macrocell 12 (2/3)
                    b3_20_ec1ec4ec7 <= mc3x1_20_ec1ec4ec7;--Macrocell 12 (2/3)
                    b3_21_ec1ec4ec7 <= mc3x1_21_ec1ec4ec7;--Macrocell 12 (2/3)
                    ce4_ec1ec4ec7 <= '1';
                    b4_0_ec1ec4ec7 <= mc3x1_0_ec1ec4ec7;--Macrocell 13 (1/3)
                    b4_1_ec1ec4ec7 <= mc3x1_1_ec1ec4ec7;--Macrocell 13 (1/3)
                    b4_2_ec1ec4ec7 <= mc3x1_2_ec1ec4ec7;--Macrocell 13 (1/3)
                    b4_3_ec1ec4ec7 <= mc3x1_3_ec1ec4ec7;--Macrocell 13 (1/3)
                    b4_4_ec1ec4ec7 <= mc3x1_4_ec1ec4ec7;--Macrocell 13 (1/3)
                    b4_5_ec1ec4ec7 <= mc3x1_5_ec1ec4ec7;--Macrocell 13 (1/3)
                    b4_6_ec1ec4ec7 <= mc3x1_6_ec1ec4ec7;--Macrocell 13 (1/3)
                    b4_7_ec1ec4ec7 <= mc3x1_7_ec1ec4ec7;--Macrocell 13 (1/3)
                    b4_8_ec1ec4ec7 <= mc3x1_8_ec1ec4ec7;--Macrocell 13 (1/3)
                    b4_9_ec1ec4ec7 <= mc3x1_9_ec1ec4ec7;--Macrocell 13 (1/3)
                    b4_10_ec1ec4ec7 <= mc3x1_10_ec1ec4ec7;--Macrocell 13 (1/3)
                    b4_11_ec1ec4ec7 <= mc3x1_11_ec1ec4ec7;--Macrocell 13 (1/3)
                    b4_12_ec1ec4ec7 <= mc3x1_12_ec1ec4ec7;--Macrocell 13 (1/3)
                    b4_13_ec1ec4ec7 <= mc3x1_13_ec1ec4ec7;--Macrocell 13 (1/3)
                    b4_14_ec1ec4ec7 <= mc3x1_14_ec1ec4ec7;--Macrocell 13 (1/3)
                    b4_15_ec1ec4ec7 <= mc3x1_15_ec1ec4ec7;--Macrocell 13 (1/3)
                    b4_16_ec1ec4ec7 <= mc3x1_16_ec1ec4ec7;--Macrocell 13 (1/3)
                    b4_17_ec1ec4ec7 <= mc3x1_17_ec1ec4ec7;--Macrocell 13 (1/3)
                    b4_18_ec1ec4ec7 <= mc3x1_18_ec1ec4ec7;--Macrocell 13 (1/3)
                    b4_19_ec1ec4ec7 <= mc3x1_19_ec1ec4ec7;--Macrocell 13 (1/3)
                    b4_20_ec1ec4ec7 <= mc3x1_20_ec1ec4ec7;--Macrocell 13 (1/3)
                    b4_21_ec1ec4ec7 <= mc3x1_21_ec1ec4ec7;--Macrocell 13 (1/3)
                    
                    ce2_ec2ec5ec8 <= '1';
                    b2_0_ec2ec5ec8 <= mc3x1_0_ec2ec5ec8;--Macrocell 19 (3/3)
                    b2_1_ec2ec5ec8 <= mc3x1_1_ec2ec5ec8;--Macrocell 19 (3/3)
                    b2_2_ec2ec5ec8 <= mc3x1_2_ec2ec5ec8;--Macrocell 19 (3/3)
                    b2_3_ec2ec5ec8 <= mc3x1_3_ec2ec5ec8;--Macrocell 19 (3/3)
                    b2_4_ec2ec5ec8 <= mc3x1_4_ec2ec5ec8;--Macrocell 19 (3/3)
                    b2_5_ec2ec5ec8 <= mc3x1_5_ec2ec5ec8;--Macrocell 19 (3/3)
                    b2_6_ec2ec5ec8 <= mc3x1_6_ec2ec5ec8;--Macrocell 19 (3/3)
                    b2_7_ec2ec5ec8 <= mc3x1_7_ec2ec5ec8;--Macrocell 19 (3/3)
                    b2_8_ec2ec5ec8 <= mc3x1_8_ec2ec5ec8;--Macrocell 19 (3/3)
                    b2_9_ec2ec5ec8 <= mc3x1_9_ec2ec5ec8;--Macrocell 19 (3/3)
                    b2_10_ec2ec5ec8 <= mc3x1_10_ec2ec5ec8;--Macrocell 19 (3/3)
                    b2_11_ec2ec5ec8 <= mc3x1_11_ec2ec5ec8;--Macrocell 19 (3/3)
                    b2_12_ec2ec5ec8 <= mc3x1_12_ec2ec5ec8;--Macrocell 19 (3/3)
                    b2_13_ec2ec5ec8 <= mc3x1_13_ec2ec5ec8;--Macrocell 19 (3/3)
                    b2_14_ec2ec5ec8 <= mc3x1_14_ec2ec5ec8;--Macrocell 19 (3/3)
                    b2_15_ec2ec5ec8 <= mc3x1_15_ec2ec5ec8;--Macrocell 19 (3/3)
                    b2_16_ec2ec5ec8 <= mc3x1_16_ec2ec5ec8;--Macrocell 19 (3/3)
                    b2_17_ec2ec5ec8 <= mc3x1_17_ec2ec5ec8;--Macrocell 19 (3/3)
                    b2_18_ec2ec5ec8 <= mc3x1_18_ec2ec5ec8;--Macrocell 19 (3/3)
                    b2_19_ec2ec5ec8 <= mc3x1_19_ec2ec5ec8;--Macrocell 19 (3/3)
                    b2_20_ec2ec5ec8 <= mc3x1_20_ec2ec5ec8;--Macrocell 19 (3/3)
                    b2_21_ec2ec5ec8 <= mc3x1_21_ec2ec5ec8;--Macrocell 19 (3/3)
                    ce3_ec2ec5ec8 <= '1';
                    b3_0_ec2ec5ec8 <= mc3x1_0_ec2ec5ec8;--Macrocell 20 (2/3)
                    b3_1_ec2ec5ec8 <= mc3x1_1_ec2ec5ec8;--Macrocell 20 (2/3)
                    b3_2_ec2ec5ec8 <= mc3x1_2_ec2ec5ec8;--Macrocell 20 (2/3)
                    b3_3_ec2ec5ec8 <= mc3x1_3_ec2ec5ec8;--Macrocell 20 (2/3)
                    b3_4_ec2ec5ec8 <= mc3x1_4_ec2ec5ec8;--Macrocell 20 (2/3)
                    b3_5_ec2ec5ec8 <= mc3x1_5_ec2ec5ec8;--Macrocell 20 (2/3)
                    b3_6_ec2ec5ec8 <= mc3x1_6_ec2ec5ec8;--Macrocell 20 (2/3)
                    b3_7_ec2ec5ec8 <= mc3x1_7_ec2ec5ec8;--Macrocell 20 (2/3)
                    b3_8_ec2ec5ec8 <= mc3x1_8_ec2ec5ec8;--Macrocell 20 (2/3)
                    b3_9_ec2ec5ec8 <= mc3x1_9_ec2ec5ec8;--Macrocell 20 (2/3)
                    b3_10_ec2ec5ec8 <= mc3x1_10_ec2ec5ec8;--Macrocell 20 (2/3)
                    b3_11_ec2ec5ec8 <= mc3x1_11_ec2ec5ec8;--Macrocell 20 (2/3)
                    b3_12_ec2ec5ec8 <= mc3x1_12_ec2ec5ec8;--Macrocell 20 (2/3)
                    b3_13_ec2ec5ec8 <= mc3x1_13_ec2ec5ec8;--Macrocell 20 (2/3)
                    b3_14_ec2ec5ec8 <= mc3x1_14_ec2ec5ec8;--Macrocell 20 (2/3)
                    b3_15_ec2ec5ec8 <= mc3x1_15_ec2ec5ec8;--Macrocell 20 (2/3)
                    b3_16_ec2ec5ec8 <= mc3x1_16_ec2ec5ec8;--Macrocell 20 (2/3)
                    b3_17_ec2ec5ec8 <= mc3x1_17_ec2ec5ec8;--Macrocell 20 (2/3)
                    b3_18_ec2ec5ec8 <= mc3x1_18_ec2ec5ec8;--Macrocell 20 (2/3)
                    b3_19_ec2ec5ec8 <= mc3x1_19_ec2ec5ec8;--Macrocell 20 (2/3)
                    b3_20_ec2ec5ec8 <= mc3x1_20_ec2ec5ec8;--Macrocell 20 (2/3)
                    b3_21_ec2ec5ec8 <= mc3x1_21_ec2ec5ec8;--Macrocell 20 (2/3)
                    ce4_ec2ec5ec8 <= '1';
                    b4_0_ec2ec5ec8 <= mc3x1_0_ec2ec5ec8;--Macrocell 21 (1/3)
                    b4_1_ec2ec5ec8 <= mc3x1_1_ec2ec5ec8;--Macrocell 21 (1/3)
                    b4_2_ec2ec5ec8 <= mc3x1_2_ec2ec5ec8;--Macrocell 21 (1/3)
                    b4_3_ec2ec5ec8 <= mc3x1_3_ec2ec5ec8;--Macrocell 21 (1/3)
                    b4_4_ec2ec5ec8 <= mc3x1_4_ec2ec5ec8;--Macrocell 21 (1/3)
                    b4_5_ec2ec5ec8 <= mc3x1_5_ec2ec5ec8;--Macrocell 21 (1/3)
                    b4_6_ec2ec5ec8 <= mc3x1_6_ec2ec5ec8;--Macrocell 21 (1/3)
                    b4_7_ec2ec5ec8 <= mc3x1_7_ec2ec5ec8;--Macrocell 21 (1/3)
                    b4_8_ec2ec5ec8 <= mc3x1_8_ec2ec5ec8;--Macrocell 21 (1/3)
                    b4_9_ec2ec5ec8 <= mc3x1_9_ec2ec5ec8;--Macrocell 21 (1/3)
                    b4_10_ec2ec5ec8 <= mc3x1_10_ec2ec5ec8;--Macrocell 21 (1/3)
                    b4_11_ec2ec5ec8 <= mc3x1_11_ec2ec5ec8;--Macrocell 21 (1/3)
                    b4_12_ec2ec5ec8 <= mc3x1_12_ec2ec5ec8;--Macrocell 21 (1/3)
                    b4_13_ec2ec5ec8 <= mc3x1_13_ec2ec5ec8;--Macrocell 21 (1/3)
                    b4_14_ec2ec5ec8 <= mc3x1_14_ec2ec5ec8;--Macrocell 21 (1/3)
                    b4_15_ec2ec5ec8 <= mc3x1_15_ec2ec5ec8;--Macrocell 21 (1/3)
                    b4_16_ec2ec5ec8 <= mc3x1_16_ec2ec5ec8;--Macrocell 21 (1/3)
                    b4_17_ec2ec5ec8 <= mc3x1_17_ec2ec5ec8;--Macrocell 21 (1/3)
                    b4_18_ec2ec5ec8 <= mc3x1_18_ec2ec5ec8;--Macrocell 21 (1/3)
                    b4_19_ec2ec5ec8 <= mc3x1_19_ec2ec5ec8;--Macrocell 21 (1/3)
                    b4_20_ec2ec5ec8 <= mc3x1_20_ec2ec5ec8;--Macrocell 21 (1/3)
                    b4_21_ec2ec5ec8 <= mc3x1_21_ec2ec5ec8;--Macrocell 21 (1/3)
                    
                    state_macrocell <= s17;
                end if;
            when s17 =>
                ce0_ec0ec3ec6 <= '0';
                ce1_ec0ec3ec6 <= '0';
                ce2_ec0ec3ec6 <= '0';
                
                ce0_ec1ec4ec7 <= '0';
                ce1_ec1ec4ec7 <= '0';
                ce2_ec1ec4ec7 <= '0';
                ce3_ec1ec4ec7 <= '0';
                ce4_ec1ec4ec7 <= '0';
                
                ce0_ec2ec5ec8 <= '0';
                ce1_ec2ec5ec8 <= '0';
                ce2_ec2ec5ec8 <= '0';
                ce3_ec2ec5ec8 <= '0';
                ce4_ec2ec5ec8 <= '0';
                
                mc_ready <= '1';
                state_macrocell <= s18;
            when s18 =>
                mc_ready <= '0';
                sclr0_ec0ec3ec6 <= '1';
                sclr2_ec1ec4ec7 <= '1';
                sclr2_ec2ec5ec8 <= '1';
                state_macrocell <= s19;
            when s19 =>
                sclr0_ec0ec3ec6 <= '0';
                sclr2_ec1ec4ec7 <= '0';
                sclr2_ec2ec5ec8 <= '0';
                state_macrocell <= s20;
            when s20 =>
                if (mc3x1_ready_ec0ec3ec6 = '1' and mc3x1_ready_ec1ec4ec7 = '1' and mc3x1_ready_ec2ec5ec8 = '1') then
                    ce1_ec0ec3ec6 <= '1';
                    b1_0_ec0ec3ec6 <= mc3x1_0_ec0ec3ec6;--Macrocell 4 (3/3)
                    b1_1_ec0ec3ec6 <= mc3x1_1_ec0ec3ec6;--Macrocell 4 (3/3)
                    b1_2_ec0ec3ec6 <= mc3x1_2_ec0ec3ec6;--Macrocell 4 (3/3)
                    b1_3_ec0ec3ec6 <= mc3x1_3_ec0ec3ec6;--Macrocell 4 (3/3)
                    b1_4_ec0ec3ec6 <= mc3x1_4_ec0ec3ec6;--Macrocell 4 (3/3)
                    b1_5_ec0ec3ec6 <= mc3x1_5_ec0ec3ec6;--Macrocell 4 (3/3)
                    b1_6_ec0ec3ec6 <= mc3x1_6_ec0ec3ec6;--Macrocell 4 (3/3)
                    b1_7_ec0ec3ec6 <= mc3x1_7_ec0ec3ec6;--Macrocell 4 (3/3)
                    b1_8_ec0ec3ec6 <= mc3x1_8_ec0ec3ec6;--Macrocell 4 (3/3)
                    b1_9_ec0ec3ec6 <= mc3x1_9_ec0ec3ec6;--Macrocell 4 (3/3)
                    b1_10_ec0ec3ec6 <= mc3x1_10_ec0ec3ec6;--Macrocell 4 (3/3)
                    b1_11_ec0ec3ec6 <= mc3x1_11_ec0ec3ec6;--Macrocell 4 (3/3)
                    b1_12_ec0ec3ec6 <= mc3x1_12_ec0ec3ec6;--Macrocell 4 (3/3)
                    b1_13_ec0ec3ec6 <= mc3x1_13_ec0ec3ec6;--Macrocell 4 (3/3)
                    b1_14_ec0ec3ec6 <= mc3x1_14_ec0ec3ec6;--Macrocell 4 (3/3)
                    b1_15_ec0ec3ec6 <= mc3x1_15_ec0ec3ec6;--Macrocell 4 (3/3)
                    b1_16_ec0ec3ec6 <= mc3x1_16_ec0ec3ec6;--Macrocell 4 (3/3)
                    b1_17_ec0ec3ec6 <= mc3x1_17_ec0ec3ec6;--Macrocell 4 (3/3)
                    b1_18_ec0ec3ec6 <= mc3x1_18_ec0ec3ec6;--Macrocell 4 (3/3)
                    b1_19_ec0ec3ec6 <= mc3x1_19_ec0ec3ec6;--Macrocell 4 (3/3)
                    b1_20_ec0ec3ec6 <= mc3x1_20_ec0ec3ec6;--Macrocell 4 (3/3)
                    b1_21_ec0ec3ec6 <= mc3x1_21_ec0ec3ec6;--Macrocell 4 (3/3)
                    ce2_ec0ec3ec6 <= '1';
                    b2_0_ec0ec3ec6 <= mc3x1_0_ec0ec3ec6;--Macrocell 5 (2/3)
                    b2_1_ec0ec3ec6 <= mc3x1_1_ec0ec3ec6;--Macrocell 5 (2/3)
                    b2_2_ec0ec3ec6 <= mc3x1_2_ec0ec3ec6;--Macrocell 5 (2/3)
                    b2_3_ec0ec3ec6 <= mc3x1_3_ec0ec3ec6;--Macrocell 5 (2/3)
                    b2_4_ec0ec3ec6 <= mc3x1_4_ec0ec3ec6;--Macrocell 5 (2/3)
                    b2_5_ec0ec3ec6 <= mc3x1_5_ec0ec3ec6;--Macrocell 5 (2/3)
                    b2_6_ec0ec3ec6 <= mc3x1_6_ec0ec3ec6;--Macrocell 5 (2/3)
                    b2_7_ec0ec3ec6 <= mc3x1_7_ec0ec3ec6;--Macrocell 5 (2/3)
                    b2_8_ec0ec3ec6 <= mc3x1_8_ec0ec3ec6;--Macrocell 5 (2/3)
                    b2_9_ec0ec3ec6 <= mc3x1_9_ec0ec3ec6;--Macrocell 5 (2/3)
                    b2_10_ec0ec3ec6 <= mc3x1_10_ec0ec3ec6;--Macrocell 5 (2/3)
                    b2_11_ec0ec3ec6 <= mc3x1_11_ec0ec3ec6;--Macrocell 5 (2/3)
                    b2_12_ec0ec3ec6 <= mc3x1_12_ec0ec3ec6;--Macrocell 5 (2/3)
                    b2_13_ec0ec3ec6 <= mc3x1_13_ec0ec3ec6;--Macrocell 5 (2/3)
                    b2_14_ec0ec3ec6 <= mc3x1_14_ec0ec3ec6;--Macrocell 5 (2/3)
                    b2_15_ec0ec3ec6 <= mc3x1_15_ec0ec3ec6;--Macrocell 5 (2/3)
                    b2_16_ec0ec3ec6 <= mc3x1_16_ec0ec3ec6;--Macrocell 5 (2/3)
                    b2_17_ec0ec3ec6 <= mc3x1_17_ec0ec3ec6;--Macrocell 5 (2/3)
                    b2_18_ec0ec3ec6 <= mc3x1_18_ec0ec3ec6;--Macrocell 5 (2/3)
                    b2_19_ec0ec3ec6 <= mc3x1_19_ec0ec3ec6;--Macrocell 5 (2/3)
                    b2_20_ec0ec3ec6 <= mc3x1_20_ec0ec3ec6;--Macrocell 5 (2/3)
                    b2_21_ec0ec3ec6 <= mc3x1_21_ec0ec3ec6;--Macrocell 5 (2/3)
                    
                    ce0_ec1ec4ec7 <= '1';
                    b0_0_ec1ec4ec7 <= mc3x1_0_ec0ec3ec6;--Macrocell 6 (2/3)--Data from EC0EC3EC6
                    b0_1_ec1ec4ec7 <= mc3x1_1_ec0ec3ec6;--Macrocell 6 (2/3)--Data from EC0EC3EC6
                    b0_2_ec1ec4ec7 <= mc3x1_2_ec0ec3ec6;--Macrocell 6 (2/3)--Data from EC0EC3EC6
                    b0_3_ec1ec4ec7 <= mc3x1_3_ec0ec3ec6;--Macrocell 6 (2/3)--Data from EC0EC3EC6
                    b0_4_ec1ec4ec7 <= mc3x1_4_ec0ec3ec6;--Macrocell 6 (2/3)--Data from EC0EC3EC6
                    b0_5_ec1ec4ec7 <= mc3x1_5_ec0ec3ec6;--Macrocell 6 (2/3)--Data from EC0EC3EC6
                    b0_6_ec1ec4ec7 <= mc3x1_6_ec0ec3ec6;--Macrocell 6 (2/3)--Data from EC0EC3EC6
                    b0_7_ec1ec4ec7 <= mc3x1_7_ec0ec3ec6;--Macrocell 6 (2/3)--Data from EC0EC3EC6
                    b0_8_ec1ec4ec7 <= mc3x1_8_ec0ec3ec6;--Macrocell 6 (2/3)--Data from EC0EC3EC6
                    b0_9_ec1ec4ec7 <= mc3x1_9_ec0ec3ec6;--Macrocell 6 (2/3)--Data from EC0EC3EC6
                    b0_10_ec1ec4ec7 <= mc3x1_10_ec0ec3ec6;--Macrocell 6 (2/3)--Data from EC0EC3EC6
                    b0_11_ec1ec4ec7 <= mc3x1_11_ec0ec3ec6;--Macrocell 6 (2/3)--Data from EC0EC3EC6
                    b0_12_ec1ec4ec7 <= mc3x1_12_ec0ec3ec6;--Macrocell 6 (2/3)--Data from EC0EC3EC6
                    b0_13_ec1ec4ec7 <= mc3x1_13_ec0ec3ec6;--Macrocell 6 (2/3)--Data from EC0EC3EC6
                    b0_14_ec1ec4ec7 <= mc3x1_14_ec0ec3ec6;--Macrocell 6 (2/3)--Data from EC0EC3EC6
                    b0_15_ec1ec4ec7 <= mc3x1_15_ec0ec3ec6;--Macrocell 6 (2/3)--Data from EC0EC3EC6
                    b0_16_ec1ec4ec7 <= mc3x1_16_ec0ec3ec6;--Macrocell 6 (2/3)--Data from EC0EC3EC6
                    b0_17_ec1ec4ec7 <= mc3x1_17_ec0ec3ec6;--Macrocell 6 (2/3)--Data from EC0EC3EC6
                    b0_18_ec1ec4ec7 <= mc3x1_18_ec0ec3ec6;--Macrocell 6 (2/3)--Data from EC0EC3EC6
                    b0_19_ec1ec4ec7 <= mc3x1_19_ec0ec3ec6;--Macrocell 6 (2/3)--Data from EC0EC3EC6
                    b0_20_ec1ec4ec7 <= mc3x1_20_ec0ec3ec6;--Macrocell 6 (2/3)--Data from EC0EC3EC6
                    b0_21_ec1ec4ec7 <= mc3x1_21_ec0ec3ec6;--Macrocell 6 (2/3)--Data from EC0EC3EC6
                    ce3_ec1ec4ec7 <= '1';
                    b3_0_ec1ec4ec7 <= mc3x1_0_ec1ec4ec7;--Macrocell 12 (3/3)
                    b3_1_ec1ec4ec7 <= mc3x1_1_ec1ec4ec7;--Macrocell 12 (3/3)
                    b3_2_ec1ec4ec7 <= mc3x1_2_ec1ec4ec7;--Macrocell 12 (3/3)
                    b3_3_ec1ec4ec7 <= mc3x1_3_ec1ec4ec7;--Macrocell 12 (3/3)
                    b3_4_ec1ec4ec7 <= mc3x1_4_ec1ec4ec7;--Macrocell 12 (3/3)
                    b3_5_ec1ec4ec7 <= mc3x1_5_ec1ec4ec7;--Macrocell 12 (3/3)
                    b3_6_ec1ec4ec7 <= mc3x1_6_ec1ec4ec7;--Macrocell 12 (3/3)
                    b3_7_ec1ec4ec7 <= mc3x1_7_ec1ec4ec7;--Macrocell 12 (3/3)
                    b3_8_ec1ec4ec7 <= mc3x1_8_ec1ec4ec7;--Macrocell 12 (3/3)
                    b3_9_ec1ec4ec7 <= mc3x1_9_ec1ec4ec7;--Macrocell 12 (3/3)
                    b3_10_ec1ec4ec7 <= mc3x1_10_ec1ec4ec7;--Macrocell 12 (3/3)
                    b3_11_ec1ec4ec7 <= mc3x1_11_ec1ec4ec7;--Macrocell 12 (3/3)
                    b3_12_ec1ec4ec7 <= mc3x1_12_ec1ec4ec7;--Macrocell 12 (3/3)
                    b3_13_ec1ec4ec7 <= mc3x1_13_ec1ec4ec7;--Macrocell 12 (3/3)
                    b3_14_ec1ec4ec7 <= mc3x1_14_ec1ec4ec7;--Macrocell 12 (3/3)
                    b3_15_ec1ec4ec7 <= mc3x1_15_ec1ec4ec7;--Macrocell 12 (3/3)
                    b3_16_ec1ec4ec7 <= mc3x1_16_ec1ec4ec7;--Macrocell 12 (3/3)
                    b3_17_ec1ec4ec7 <= mc3x1_17_ec1ec4ec7;--Macrocell 12 (3/3)
                    b3_18_ec1ec4ec7 <= mc3x1_18_ec1ec4ec7;--Macrocell 12 (3/3)
                    b3_19_ec1ec4ec7 <= mc3x1_19_ec1ec4ec7;--Macrocell 12 (3/3)
                    b3_20_ec1ec4ec7 <= mc3x1_20_ec1ec4ec7;--Macrocell 12 (3/3)
                    b3_21_ec1ec4ec7 <= mc3x1_21_ec1ec4ec7;--Macrocell 12 (3/3)
                    ce4_ec1ec4ec7 <= '1';
                    b4_0_ec1ec4ec7 <= mc3x1_0_ec1ec4ec7;--Macrocell 13 (2/3)
                    b4_1_ec1ec4ec7 <= mc3x1_1_ec1ec4ec7;--Macrocell 13 (2/3)
                    b4_2_ec1ec4ec7 <= mc3x1_2_ec1ec4ec7;--Macrocell 13 (2/3)
                    b4_3_ec1ec4ec7 <= mc3x1_3_ec1ec4ec7;--Macrocell 13 (2/3)
                    b4_4_ec1ec4ec7 <= mc3x1_4_ec1ec4ec7;--Macrocell 13 (2/3)
                    b4_5_ec1ec4ec7 <= mc3x1_5_ec1ec4ec7;--Macrocell 13 (2/3)
                    b4_6_ec1ec4ec7 <= mc3x1_6_ec1ec4ec7;--Macrocell 13 (2/3)
                    b4_7_ec1ec4ec7 <= mc3x1_7_ec1ec4ec7;--Macrocell 13 (2/3)
                    b4_8_ec1ec4ec7 <= mc3x1_8_ec1ec4ec7;--Macrocell 13 (2/3)
                    b4_9_ec1ec4ec7 <= mc3x1_9_ec1ec4ec7;--Macrocell 13 (2/3)
                    b4_10_ec1ec4ec7 <= mc3x1_10_ec1ec4ec7;--Macrocell 13 (2/3)
                    b4_11_ec1ec4ec7 <= mc3x1_11_ec1ec4ec7;--Macrocell 13 (2/3)
                    b4_12_ec1ec4ec7 <= mc3x1_12_ec1ec4ec7;--Macrocell 13 (2/3)
                    b4_13_ec1ec4ec7 <= mc3x1_13_ec1ec4ec7;--Macrocell 13 (2/3)
                    b4_14_ec1ec4ec7 <= mc3x1_14_ec1ec4ec7;--Macrocell 13 (2/3)
                    b4_15_ec1ec4ec7 <= mc3x1_15_ec1ec4ec7;--Macrocell 13 (2/3)
                    b4_16_ec1ec4ec7 <= mc3x1_16_ec1ec4ec7;--Macrocell 13 (2/3)
                    b4_17_ec1ec4ec7 <= mc3x1_17_ec1ec4ec7;--Macrocell 13 (2/3)
                    b4_18_ec1ec4ec7 <= mc3x1_18_ec1ec4ec7;--Macrocell 13 (2/3)
                    b4_19_ec1ec4ec7 <= mc3x1_19_ec1ec4ec7;--Macrocell 13 (2/3)
                    b4_20_ec1ec4ec7 <= mc3x1_20_ec1ec4ec7;--Macrocell 13 (2/3)
                    b4_21_ec1ec4ec7 <= mc3x1_21_ec1ec4ec7;--Macrocell 13 (2/3)
                    
                    ce3_ec2ec5ec8 <= '1';
                    b3_0_ec2ec5ec8 <= mc3x1_0_ec2ec5ec8;--Macrocell 20 (3/3)
                    b3_1_ec2ec5ec8 <= mc3x1_1_ec2ec5ec8;--Macrocell 20 (3/3)
                    b3_2_ec2ec5ec8 <= mc3x1_2_ec2ec5ec8;--Macrocell 20 (3/3)
                    b3_3_ec2ec5ec8 <= mc3x1_3_ec2ec5ec8;--Macrocell 20 (3/3)
                    b3_4_ec2ec5ec8 <= mc3x1_4_ec2ec5ec8;--Macrocell 20 (3/3)
                    b3_5_ec2ec5ec8 <= mc3x1_5_ec2ec5ec8;--Macrocell 20 (3/3)
                    b3_6_ec2ec5ec8 <= mc3x1_6_ec2ec5ec8;--Macrocell 20 (3/3)
                    b3_7_ec2ec5ec8 <= mc3x1_7_ec2ec5ec8;--Macrocell 20 (3/3)
                    b3_8_ec2ec5ec8 <= mc3x1_8_ec2ec5ec8;--Macrocell 20 (3/3)
                    b3_9_ec2ec5ec8 <= mc3x1_9_ec2ec5ec8;--Macrocell 20 (3/3)
                    b3_10_ec2ec5ec8 <= mc3x1_10_ec2ec5ec8;--Macrocell 20 (3/3)
                    b3_11_ec2ec5ec8 <= mc3x1_11_ec2ec5ec8;--Macrocell 20 (3/3)
                    b3_12_ec2ec5ec8 <= mc3x1_12_ec2ec5ec8;--Macrocell 20 (3/3)
                    b3_13_ec2ec5ec8 <= mc3x1_13_ec2ec5ec8;--Macrocell 20 (3/3)
                    b3_14_ec2ec5ec8 <= mc3x1_14_ec2ec5ec8;--Macrocell 20 (3/3)
                    b3_15_ec2ec5ec8 <= mc3x1_15_ec2ec5ec8;--Macrocell 20 (3/3)
                    b3_16_ec2ec5ec8 <= mc3x1_16_ec2ec5ec8;--Macrocell 20 (3/3)
                    b3_17_ec2ec5ec8 <= mc3x1_17_ec2ec5ec8;--Macrocell 20 (3/3)
                    b3_18_ec2ec5ec8 <= mc3x1_18_ec2ec5ec8;--Macrocell 20 (3/3)
                    b3_19_ec2ec5ec8 <= mc3x1_19_ec2ec5ec8;--Macrocell 20 (3/3)
                    b3_20_ec2ec5ec8 <= mc3x1_20_ec2ec5ec8;--Macrocell 20 (3/3)
                    b3_21_ec2ec5ec8 <= mc3x1_21_ec2ec5ec8;--Macrocell 20 (3/3)
                    ce4_ec2ec5ec8 <= '1';
                    b4_0_ec2ec5ec8 <= mc3x1_0_ec2ec5ec8;--Macrocell 21 (2/3)
                    b4_1_ec2ec5ec8 <= mc3x1_1_ec2ec5ec8;--Macrocell 21 (2/3)
                    b4_2_ec2ec5ec8 <= mc3x1_2_ec2ec5ec8;--Macrocell 21 (2/3)
                    b4_3_ec2ec5ec8 <= mc3x1_3_ec2ec5ec8;--Macrocell 21 (2/3)
                    b4_4_ec2ec5ec8 <= mc3x1_4_ec2ec5ec8;--Macrocell 21 (2/3)
                    b4_5_ec2ec5ec8 <= mc3x1_5_ec2ec5ec8;--Macrocell 21 (2/3)
                    b4_6_ec2ec5ec8 <= mc3x1_6_ec2ec5ec8;--Macrocell 21 (2/3)
                    b4_7_ec2ec5ec8 <= mc3x1_7_ec2ec5ec8;--Macrocell 21 (2/3)
                    b4_8_ec2ec5ec8 <= mc3x1_8_ec2ec5ec8;--Macrocell 21 (2/3)
                    b4_9_ec2ec5ec8 <= mc3x1_9_ec2ec5ec8;--Macrocell 21 (2/3)
                    b4_10_ec2ec5ec8 <= mc3x1_10_ec2ec5ec8;--Macrocell 21 (2/3)
                    b4_11_ec2ec5ec8 <= mc3x1_11_ec2ec5ec8;--Macrocell 21 (2/3)
                    b4_12_ec2ec5ec8 <= mc3x1_12_ec2ec5ec8;--Macrocell 21 (2/3)
                    b4_13_ec2ec5ec8 <= mc3x1_13_ec2ec5ec8;--Macrocell 21 (2/3)
                    b4_14_ec2ec5ec8 <= mc3x1_14_ec2ec5ec8;--Macrocell 21 (2/3)
                    b4_15_ec2ec5ec8 <= mc3x1_15_ec2ec5ec8;--Macrocell 21 (2/3)
                    b4_16_ec2ec5ec8 <= mc3x1_16_ec2ec5ec8;--Macrocell 21 (2/3)
                    b4_17_ec2ec5ec8 <= mc3x1_17_ec2ec5ec8;--Macrocell 21 (2/3)
                    b4_18_ec2ec5ec8 <= mc3x1_18_ec2ec5ec8;--Macrocell 21 (2/3)
                    b4_19_ec2ec5ec8 <= mc3x1_19_ec2ec5ec8;--Macrocell 21 (2/3)
                    b4_20_ec2ec5ec8 <= mc3x1_20_ec2ec5ec8;--Macrocell 21 (2/3)
                    b4_21_ec2ec5ec8 <= mc3x1_21_ec2ec5ec8;--Macrocell 21 (2/3)
                    ce0_ec2ec5ec8 <= '1';
                    b0_0_ec2ec5ec8 <= mc3x1_0_ec1ec4ec7;--Macrocell 14 (2/3)
                    b0_1_ec2ec5ec8 <= mc3x1_1_ec1ec4ec7;--Macrocell 14 (2/3)
                    b0_2_ec2ec5ec8 <= mc3x1_2_ec1ec4ec7;--Macrocell 14 (2/3)
                    b0_3_ec2ec5ec8 <= mc3x1_3_ec1ec4ec7;--Macrocell 14 (2/3)
                    b0_4_ec2ec5ec8 <= mc3x1_4_ec1ec4ec7;--Macrocell 14 (2/3)
                    b0_5_ec2ec5ec8 <= mc3x1_5_ec1ec4ec7;--Macrocell 14 (2/3)
                    b0_6_ec2ec5ec8 <= mc3x1_6_ec1ec4ec7;--Macrocell 14 (2/3)
                    b0_7_ec2ec5ec8 <= mc3x1_7_ec1ec4ec7;--Macrocell 14 (2/3)
                    b0_8_ec2ec5ec8 <= mc3x1_8_ec1ec4ec7;--Macrocell 14 (2/3)
                    b0_9_ec2ec5ec8 <= mc3x1_9_ec1ec4ec7;--Macrocell 14 (2/3)
                    b0_10_ec2ec5ec8 <= mc3x1_10_ec1ec4ec7;--Macrocell 14 (2/3)
                    b0_11_ec2ec5ec8 <= mc3x1_11_ec1ec4ec7;--Macrocell 14 (2/3)
                    b0_12_ec2ec5ec8 <= mc3x1_12_ec1ec4ec7;--Macrocell 14 (2/3)
                    b0_13_ec2ec5ec8 <= mc3x1_13_ec1ec4ec7;--Macrocell 14 (2/3)
                    b0_14_ec2ec5ec8 <= mc3x1_14_ec1ec4ec7;--Macrocell 14 (2/3)
                    b0_15_ec2ec5ec8 <= mc3x1_15_ec1ec4ec7;--Macrocell 14 (2/3)
                    b0_16_ec2ec5ec8 <= mc3x1_16_ec1ec4ec7;--Macrocell 14 (2/3)
                    b0_17_ec2ec5ec8 <= mc3x1_17_ec1ec4ec7;--Macrocell 14 (2/3)
                    b0_18_ec2ec5ec8 <= mc3x1_18_ec1ec4ec7;--Macrocell 14 (2/3)
                    b0_19_ec2ec5ec8 <= mc3x1_19_ec1ec4ec7;--Macrocell 14 (2/3)
                    b0_20_ec2ec5ec8 <= mc3x1_20_ec1ec4ec7;--Macrocell 14 (2/3)
                    b0_21_ec2ec5ec8 <= mc3x1_21_ec1ec4ec7;--Macrocell 14 (2/3)
                    
                    state_macrocell <= s21;
                end if;
            when s21 =>
                ce0_ec0ec3ec6 <= '0';
                ce1_ec0ec3ec6 <= '0';
                ce2_ec0ec3ec6 <= '0';
                
                ce0_ec1ec4ec7 <= '0';
                ce1_ec1ec4ec7 <= '0';
                ce2_ec1ec4ec7 <= '0';
                ce3_ec1ec4ec7 <= '0';
                ce4_ec1ec4ec7 <= '0';
                
                ce0_ec2ec5ec8 <= '0';
                ce1_ec2ec5ec8 <= '0';
                ce2_ec2ec5ec8 <= '0';
                ce3_ec2ec5ec8 <= '0';
                ce4_ec2ec5ec8 <= '0';
                
                mc_ready <= '1';
                state_macrocell <= s22;
            when s22 =>
                mc_ready <= '0';
                sclr1_ec0ec3ec6 <= '1';
                sclr3_ec1ec4ec7 <= '1';
                sclr3_ec2ec5ec8 <= '1';
                state_macrocell <= s23;
            when s23 =>
                sclr1_ec0ec3ec6 <= '0';
                sclr3_ec1ec4ec7 <= '0';
                sclr3_ec2ec5ec8 <= '0';
                state_macrocell <= s24;
            when s24 =>
                if (mc3x1_ready_ec0ec3ec6 = '1' and mc3x1_ready_ec1ec4ec7 = '1' and mc3x1_ready_ec2ec5ec8 = '1') then
                    ce2_ec0ec3ec6 <= '1';
                    b2_0_ec0ec3ec6 <= mc3x1_0_ec0ec3ec6;--Macrocell 5 (3/3)
                    b2_1_ec0ec3ec6 <= mc3x1_1_ec0ec3ec6;--Macrocell 5 (3/3)
                    b2_2_ec0ec3ec6 <= mc3x1_2_ec0ec3ec6;--Macrocell 5 (3/3)
                    b2_3_ec0ec3ec6 <= mc3x1_3_ec0ec3ec6;--Macrocell 5 (3/3)
                    b2_4_ec0ec3ec6 <= mc3x1_4_ec0ec3ec6;--Macrocell 5 (3/3)
                    b2_5_ec0ec3ec6 <= mc3x1_5_ec0ec3ec6;--Macrocell 5 (3/3)
                    b2_6_ec0ec3ec6 <= mc3x1_6_ec0ec3ec6;--Macrocell 5 (3/3)
                    b2_7_ec0ec3ec6 <= mc3x1_7_ec0ec3ec6;--Macrocell 5 (3/3)
                    b2_8_ec0ec3ec6 <= mc3x1_8_ec0ec3ec6;--Macrocell 5 (3/3)
                    b2_9_ec0ec3ec6 <= mc3x1_9_ec0ec3ec6;--Macrocell 5 (3/3)
                    b2_10_ec0ec3ec6 <= mc3x1_10_ec0ec3ec6;--Macrocell 5 (3/3)
                    b2_11_ec0ec3ec6 <= mc3x1_11_ec0ec3ec6;--Macrocell 5 (3/3)
                    b2_12_ec0ec3ec6 <= mc3x1_12_ec0ec3ec6;--Macrocell 5 (3/3)
                    b2_13_ec0ec3ec6 <= mc3x1_13_ec0ec3ec6;--Macrocell 5 (3/3)
                    b2_14_ec0ec3ec6 <= mc3x1_14_ec0ec3ec6;--Macrocell 5 (3/3)
                    b2_15_ec0ec3ec6 <= mc3x1_15_ec0ec3ec6;--Macrocell 5 (3/3)
                    b2_16_ec0ec3ec6 <= mc3x1_16_ec0ec3ec6;--Macrocell 5 (3/3)
                    b2_17_ec0ec3ec6 <= mc3x1_17_ec0ec3ec6;--Macrocell 5 (3/3)
                    b2_18_ec0ec3ec6 <= mc3x1_18_ec0ec3ec6;--Macrocell 5 (3/3)
                    b2_19_ec0ec3ec6 <= mc3x1_19_ec0ec3ec6;--Macrocell 5 (3/3)
                    b2_20_ec0ec3ec6 <= mc3x1_20_ec0ec3ec6;--Macrocell 5 (3/3)
                    b2_21_ec0ec3ec6 <= mc3x1_21_ec0ec3ec6;--Macrocell 5 (3/3)
                                        
                    ce0_ec1ec4ec7 <= '1';
                    b0_0_ec1ec4ec7 <= mc3x1_0_ec0ec3ec6;--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    b0_1_ec1ec4ec7 <= mc3x1_1_ec0ec3ec6;--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    b0_2_ec1ec4ec7 <= mc3x1_2_ec0ec3ec6;--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    b0_3_ec1ec4ec7 <= mc3x1_3_ec0ec3ec6;--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    b0_4_ec1ec4ec7 <= mc3x1_4_ec0ec3ec6;--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    b0_5_ec1ec4ec7 <= mc3x1_5_ec0ec3ec6;--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    b0_6_ec1ec4ec7 <= mc3x1_6_ec0ec3ec6;--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    b0_7_ec1ec4ec7 <= mc3x1_7_ec0ec3ec6;--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    b0_8_ec1ec4ec7 <= mc3x1_8_ec0ec3ec6;--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    b0_9_ec1ec4ec7 <= mc3x1_9_ec0ec3ec6;--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    b0_10_ec1ec4ec7 <= mc3x1_10_ec0ec3ec6;--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    b0_11_ec1ec4ec7 <= mc3x1_11_ec0ec3ec6;--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    b0_12_ec1ec4ec7 <= mc3x1_12_ec0ec3ec6;--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    b0_13_ec1ec4ec7 <= mc3x1_13_ec0ec3ec6;--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    b0_14_ec1ec4ec7 <= mc3x1_14_ec0ec3ec6;--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    b0_15_ec1ec4ec7 <= mc3x1_15_ec0ec3ec6;--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    b0_16_ec1ec4ec7 <= mc3x1_16_ec0ec3ec6;--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    b0_17_ec1ec4ec7 <= mc3x1_17_ec0ec3ec6;--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    b0_18_ec1ec4ec7 <= mc3x1_18_ec0ec3ec6;--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    b0_19_ec1ec4ec7 <= mc3x1_19_ec0ec3ec6;--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    b0_20_ec1ec4ec7 <= mc3x1_20_ec0ec3ec6;--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    b0_21_ec1ec4ec7 <= mc3x1_21_ec0ec3ec6;--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    ce1_ec1ec4ec7 <= '1';
                    b1_0_ec1ec4ec7 <= mc3x1_0_ec0ec3ec6;--Macrocell 7 (3/3)--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    b1_1_ec1ec4ec7 <= mc3x1_1_ec0ec3ec6;--Macrocell 7 (3/3)--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    b1_2_ec1ec4ec7 <= mc3x1_2_ec0ec3ec6;--Macrocell 7 (3/3)--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    b1_3_ec1ec4ec7 <= mc3x1_3_ec0ec3ec6;--Macrocell 7 (3/3)--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    b1_4_ec1ec4ec7 <= mc3x1_4_ec0ec3ec6;--Macrocell 7 (3/3)--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    b1_5_ec1ec4ec7 <= mc3x1_5_ec0ec3ec6;--Macrocell 7 (3/3)--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    b1_6_ec1ec4ec7 <= mc3x1_6_ec0ec3ec6;--Macrocell 7 (3/3)--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    b1_7_ec1ec4ec7 <= mc3x1_7_ec0ec3ec6;--Macrocell 7 (3/3)--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    b1_8_ec1ec4ec7 <= mc3x1_8_ec0ec3ec6;--Macrocell 7 (3/3)--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    b1_9_ec1ec4ec7 <= mc3x1_9_ec0ec3ec6;--Macrocell 7 (3/3)--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    b1_10_ec1ec4ec7 <= mc3x1_10_ec0ec3ec6;--Macrocell 7 (3/3)--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    b1_11_ec1ec4ec7 <= mc3x1_11_ec0ec3ec6;--Macrocell 7 (3/3)--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    b1_12_ec1ec4ec7 <= mc3x1_12_ec0ec3ec6;--Macrocell 7 (3/3)--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    b1_13_ec1ec4ec7 <= mc3x1_13_ec0ec3ec6;--Macrocell 7 (3/3)--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    b1_14_ec1ec4ec7 <= mc3x1_14_ec0ec3ec6;--Macrocell 7 (3/3)--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    b1_15_ec1ec4ec7 <= mc3x1_15_ec0ec3ec6;--Macrocell 7 (3/3)--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    b1_16_ec1ec4ec7 <= mc3x1_16_ec0ec3ec6;--Macrocell 7 (3/3)--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    b1_17_ec1ec4ec7 <= mc3x1_17_ec0ec3ec6;--Macrocell 7 (3/3)--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    b1_18_ec1ec4ec7 <= mc3x1_18_ec0ec3ec6;--Macrocell 7 (3/3)--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    b1_19_ec1ec4ec7 <= mc3x1_19_ec0ec3ec6;--Macrocell 7 (3/3)--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    b1_20_ec1ec4ec7 <= mc3x1_20_ec0ec3ec6;--Macrocell 7 (3/3)--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    b1_21_ec1ec4ec7 <= mc3x1_21_ec0ec3ec6;--Macrocell 7 (3/3)--Macrocell 6 (3/3)--Data from EC0EC3EC6
                    ce4_ec1ec4ec7 <= '1';
                    b4_0_ec1ec4ec7 <= mc3x1_0_ec1ec4ec7;--Macrocell 13 (3/3)
                    b4_1_ec1ec4ec7 <= mc3x1_1_ec1ec4ec7;--Macrocell 13 (3/3)
                    b4_2_ec1ec4ec7 <= mc3x1_2_ec1ec4ec7;--Macrocell 13 (3/3)
                    b4_3_ec1ec4ec7 <= mc3x1_3_ec1ec4ec7;--Macrocell 13 (3/3)
                    b4_4_ec1ec4ec7 <= mc3x1_4_ec1ec4ec7;--Macrocell 13 (3/3)
                    b4_5_ec1ec4ec7 <= mc3x1_5_ec1ec4ec7;--Macrocell 13 (3/3)
                    b4_6_ec1ec4ec7 <= mc3x1_6_ec1ec4ec7;--Macrocell 13 (3/3)
                    b4_7_ec1ec4ec7 <= mc3x1_7_ec1ec4ec7;--Macrocell 13 (3/3)
                    b4_8_ec1ec4ec7 <= mc3x1_8_ec1ec4ec7;--Macrocell 13 (3/3)
                    b4_9_ec1ec4ec7 <= mc3x1_9_ec1ec4ec7;--Macrocell 13 (3/3)
                    b4_10_ec1ec4ec7 <= mc3x1_10_ec1ec4ec7;--Macrocell 13 (3/3)
                    b4_11_ec1ec4ec7 <= mc3x1_11_ec1ec4ec7;--Macrocell 13 (3/3)
                    b4_12_ec1ec4ec7 <= mc3x1_12_ec1ec4ec7;--Macrocell 13 (3/3)
                    b4_13_ec1ec4ec7 <= mc3x1_13_ec1ec4ec7;--Macrocell 13 (3/3)
                    b4_14_ec1ec4ec7 <= mc3x1_14_ec1ec4ec7;--Macrocell 13 (3/3)
                    b4_15_ec1ec4ec7 <= mc3x1_15_ec1ec4ec7;--Macrocell 13 (3/3)
                    b4_16_ec1ec4ec7 <= mc3x1_16_ec1ec4ec7;--Macrocell 13 (3/3)
                    b4_17_ec1ec4ec7 <= mc3x1_17_ec1ec4ec7;--Macrocell 13 (3/3)
                    b4_18_ec1ec4ec7 <= mc3x1_18_ec1ec4ec7;--Macrocell 13 (3/3)
                    b4_19_ec1ec4ec7 <= mc3x1_19_ec1ec4ec7;--Macrocell 13 (3/3)
                    b4_20_ec1ec4ec7 <= mc3x1_20_ec1ec4ec7;--Macrocell 13 (3/3)
                    b4_21_ec1ec4ec7 <= mc3x1_21_ec1ec4ec7;--Macrocell 13 (3/3)
                    
                    ce0_ec2ec5ec8 <= '1';
                    b0_0_ec2ec5ec8 <= mc3x1_0_ec1ec4ec7;--Macrocell 14 (3/3)--Data from EC1EC4EC7
                    b0_1_ec2ec5ec8 <= mc3x1_1_ec1ec4ec7;--Macrocell 14 (3/3)--Data from EC1EC4EC7
                    b0_2_ec2ec5ec8 <= mc3x1_2_ec1ec4ec7;--Macrocell 14 (3/3)--Data from EC1EC4EC7
                    b0_3_ec2ec5ec8 <= mc3x1_3_ec1ec4ec7;--Macrocell 14 (3/3)--Data from EC1EC4EC7
                    b0_4_ec2ec5ec8 <= mc3x1_4_ec1ec4ec7;--Macrocell 14 (3/3)--Data from EC1EC4EC7
                    b0_5_ec2ec5ec8 <= mc3x1_5_ec1ec4ec7;--Macrocell 14 (3/3)--Data from EC1EC4EC7
                    b0_6_ec2ec5ec8 <= mc3x1_6_ec1ec4ec7;--Macrocell 14 (3/3)--Data from EC1EC4EC7
                    b0_7_ec2ec5ec8 <= mc3x1_7_ec1ec4ec7;--Macrocell 14 (3/3)--Data from EC1EC4EC7
                    b0_8_ec2ec5ec8 <= mc3x1_8_ec1ec4ec7;--Macrocell 14 (3/3)--Data from EC1EC4EC7
                    b0_9_ec2ec5ec8 <= mc3x1_9_ec1ec4ec7;--Macrocell 14 (3/3)--Data from EC1EC4EC7
                    b0_10_ec2ec5ec8 <= mc3x1_10_ec1ec4ec7;--Macrocell 14 (3/3)--Data from EC1EC4EC7
                    b0_11_ec2ec5ec8 <= mc3x1_11_ec1ec4ec7;--Macrocell 14 (3/3)--Data from EC1EC4EC7
                    b0_12_ec2ec5ec8 <= mc3x1_12_ec1ec4ec7;--Macrocell 14 (3/3)--Data from EC1EC4EC7
                    b0_13_ec2ec5ec8 <= mc3x1_13_ec1ec4ec7;--Macrocell 14 (3/3)--Data from EC1EC4EC7
                    b0_14_ec2ec5ec8 <= mc3x1_14_ec1ec4ec7;--Macrocell 14 (3/3)--Data from EC1EC4EC7
                    b0_15_ec2ec5ec8 <= mc3x1_15_ec1ec4ec7;--Macrocell 14 (3/3)--Data from EC1EC4EC7
                    b0_16_ec2ec5ec8 <= mc3x1_16_ec1ec4ec7;--Macrocell 14 (3/3)--Data from EC1EC4EC7
                    b0_17_ec2ec5ec8 <= mc3x1_17_ec1ec4ec7;--Macrocell 14 (3/3)--Data from EC1EC4EC7
                    b0_18_ec2ec5ec8 <= mc3x1_18_ec1ec4ec7;--Macrocell 14 (3/3)--Data from EC1EC4EC7
                    b0_19_ec2ec5ec8 <= mc3x1_19_ec1ec4ec7;--Macrocell 14 (3/3)--Data from EC1EC4EC7
                    b0_20_ec2ec5ec8 <= mc3x1_20_ec1ec4ec7;--Macrocell 14 (3/3)--Data from EC1EC4EC7
                    b0_21_ec2ec5ec8 <= mc3x1_21_ec1ec4ec7;--Macrocell 14 (3/3)--Data from EC1EC4EC7
                    ce1_ec2ec5ec8 <= '1';
                    b1_0_ec2ec5ec8 <= mc3x1_0_ec1ec4ec7;--Macrocell 15 (3/3)--Data from EC1EC4EC7
                    b1_1_ec2ec5ec8 <= mc3x1_1_ec1ec4ec7;--Macrocell 15 (3/3)--Data from EC1EC4EC7
                    b1_2_ec2ec5ec8 <= mc3x1_2_ec1ec4ec7;--Macrocell 15 (3/3)--Data from EC1EC4EC7
                    b1_3_ec2ec5ec8 <= mc3x1_3_ec1ec4ec7;--Macrocell 15 (3/3)--Data from EC1EC4EC7
                    b1_4_ec2ec5ec8 <= mc3x1_4_ec1ec4ec7;--Macrocell 15 (3/3)--Data from EC1EC4EC7
                    b1_5_ec2ec5ec8 <= mc3x1_5_ec1ec4ec7;--Macrocell 15 (3/3)--Data from EC1EC4EC7
                    b1_6_ec2ec5ec8 <= mc3x1_6_ec1ec4ec7;--Macrocell 15 (3/3)--Data from EC1EC4EC7
                    b1_7_ec2ec5ec8 <= mc3x1_7_ec1ec4ec7;--Macrocell 15 (3/3)--Data from EC1EC4EC7
                    b1_8_ec2ec5ec8 <= mc3x1_8_ec1ec4ec7;--Macrocell 15 (3/3)--Data from EC1EC4EC7
                    b1_9_ec2ec5ec8 <= mc3x1_9_ec1ec4ec7;--Macrocell 15 (3/3)--Data from EC1EC4EC7
                    b1_10_ec2ec5ec8 <= mc3x1_10_ec1ec4ec7;--Macrocell 15 (3/3)--Data from EC1EC4EC7
                    b1_11_ec2ec5ec8 <= mc3x1_11_ec1ec4ec7;--Macrocell 15 (3/3)--Data from EC1EC4EC7
                    b1_12_ec2ec5ec8 <= mc3x1_12_ec1ec4ec7;--Macrocell 15 (3/3)--Data from EC1EC4EC7
                    b1_13_ec2ec5ec8 <= mc3x1_13_ec1ec4ec7;--Macrocell 15 (3/3)--Data from EC1EC4EC7
                    b1_14_ec2ec5ec8 <= mc3x1_14_ec1ec4ec7;--Macrocell 15 (3/3)--Data from EC1EC4EC7
                    b1_15_ec2ec5ec8 <= mc3x1_15_ec1ec4ec7;--Macrocell 15 (3/3)--Data from EC1EC4EC7
                    b1_16_ec2ec5ec8 <= mc3x1_16_ec1ec4ec7;--Macrocell 15 (3/3)--Data from EC1EC4EC7
                    b1_17_ec2ec5ec8 <= mc3x1_17_ec1ec4ec7;--Macrocell 15 (3/3)--Data from EC1EC4EC7
                    b1_18_ec2ec5ec8 <= mc3x1_18_ec1ec4ec7;--Macrocell 15 (3/3)--Data from EC1EC4EC7
                    b1_19_ec2ec5ec8 <= mc3x1_19_ec1ec4ec7;--Macrocell 15 (3/3)--Data from EC1EC4EC7
                    b1_20_ec2ec5ec8 <= mc3x1_20_ec1ec4ec7;--Macrocell 15 (3/3)--Data from EC1EC4EC7
                    b1_21_ec2ec5ec8 <= mc3x1_21_ec1ec4ec7;--Macrocell 15 (3/3)--Data from EC1EC4EC7
                    ce4_ec2ec5ec8 <= '1';
                    b4_0_ec2ec5ec8 <= mc3x1_0_ec2ec5ec8;--Macrocell 21 (3/3)
                    b4_1_ec2ec5ec8 <= mc3x1_1_ec2ec5ec8;--Macrocell 21 (3/3)
                    b4_2_ec2ec5ec8 <= mc3x1_2_ec2ec5ec8;--Macrocell 21 (3/3)
                    b4_3_ec2ec5ec8 <= mc3x1_3_ec2ec5ec8;--Macrocell 21 (3/3)
                    b4_4_ec2ec5ec8 <= mc3x1_4_ec2ec5ec8;--Macrocell 21 (3/3)
                    b4_5_ec2ec5ec8 <= mc3x1_5_ec2ec5ec8;--Macrocell 21 (3/3)
                    b4_6_ec2ec5ec8 <= mc3x1_6_ec2ec5ec8;--Macrocell 21 (3/3)
                    b4_7_ec2ec5ec8 <= mc3x1_7_ec2ec5ec8;--Macrocell 21 (3/3)
                    b4_8_ec2ec5ec8 <= mc3x1_8_ec2ec5ec8;--Macrocell 21 (3/3)
                    b4_9_ec2ec5ec8 <= mc3x1_9_ec2ec5ec8;--Macrocell 21 (3/3)
                    b4_10_ec2ec5ec8 <= mc3x1_10_ec2ec5ec8;--Macrocell 21 (3/3)
                    b4_11_ec2ec5ec8 <= mc3x1_11_ec2ec5ec8;--Macrocell 21 (3/3)
                    b4_12_ec2ec5ec8 <= mc3x1_12_ec2ec5ec8;--Macrocell 21 (3/3)
                    b4_13_ec2ec5ec8 <= mc3x1_13_ec2ec5ec8;--Macrocell 21 (3/3)
                    b4_14_ec2ec5ec8 <= mc3x1_14_ec2ec5ec8;--Macrocell 21 (3/3)
                    b4_15_ec2ec5ec8 <= mc3x1_15_ec2ec5ec8;--Macrocell 21 (3/3)
                    b4_16_ec2ec5ec8 <= mc3x1_16_ec2ec5ec8;--Macrocell 21 (3/3)
                    b4_17_ec2ec5ec8 <= mc3x1_17_ec2ec5ec8;--Macrocell 21 (3/3)
                    b4_18_ec2ec5ec8 <= mc3x1_18_ec2ec5ec8;--Macrocell 21 (3/3)
                    b4_19_ec2ec5ec8 <= mc3x1_19_ec2ec5ec8;--Macrocell 21 (3/3)
                    b4_20_ec2ec5ec8 <= mc3x1_20_ec2ec5ec8;--Macrocell 21 (3/3)
                    b4_21_ec2ec5ec8 <= mc3x1_21_ec2ec5ec8;--Macrocell 21 (3/3)
                    
                    state_macrocell <= s25;
                end if;
            when s25 =>
                ce0_ec0ec3ec6 <= '0';
                ce1_ec0ec3ec6 <= '0';
                ce2_ec0ec3ec6 <= '0';
                    
                ce0_ec1ec4ec7 <= '0';
                ce1_ec1ec4ec7 <= '0';
                ce2_ec1ec4ec7 <= '0';
                ce3_ec1ec4ec7 <= '0';
                ce4_ec1ec4ec7 <= '0';
                
                ce0_ec2ec5ec8 <= '0';
                ce1_ec2ec5ec8 <= '0';
                ce2_ec2ec5ec8 <= '0';
                ce3_ec2ec5ec8 <= '0';
                ce4_ec2ec5ec8 <= '0';
                
                mc_ready <= '1';
                state_macrocell <= s26;
            when s26 =>
                mc_ready <= '0';
                sclr2_ec0ec3ec6 <= '1';
                sclr0_ec1ec4ec7 <= '1';
                sclr1_ec1ec4ec7 <= '1';
                sclr4_ec1ec4ec7 <= '1';
                sclr0_ec2ec5ec8 <= '1';
                sclr1_ec2ec5ec8 <= '1';
                sclr4_ec2ec5ec8 <= '1';
                state_macrocell <= s0;
            end case;
    end if;
end process;

macrocell_buffer_rdwr : process (CLOCK)--Read/Write Macrocell buffer for 3GTU
begin 
    if (CLOCK'event and CLOCK = '1') then
        case (state_macrocell_buffer) is
            when s0 =>
                mcmem_rden <= '0';
                if (mc_ready = '1') then--Macrocell column READY
                    a_mc_mem <= a_mc_mem_write;
                    we_mc_mem <= '1';--Write in MACROCELL_MEMORY
                    d_mc_mem(3 downto 0) <= mc0_0_ec0ec3ec6;--Write Column 0
                    d_mc_mem(7 downto 4) <= mc0_1_ec0ec3ec6;
                    d_mc_mem(11 downto 8) <= mc0_2_ec0ec3ec6;
                    d_mc_mem(15 downto 12) <= mc0_3_ec0ec3ec6;
                    d_mc_mem(19 downto 16) <= mc0_4_ec0ec3ec6;
                    d_mc_mem(23 downto 20) <= mc0_5_ec0ec3ec6;
                    d_mc_mem(27 downto 24) <= mc0_6_ec0ec3ec6;
                    d_mc_mem(31 downto 28) <= mc0_7_ec0ec3ec6;
                    d_mc_mem(35 downto 32) <= mc0_8_ec0ec3ec6;
                    d_mc_mem(39 downto 36) <= mc0_9_ec0ec3ec6;
                    d_mc_mem(43 downto 40) <= mc0_10_ec0ec3ec6;
                    d_mc_mem(47 downto 44) <= mc0_11_ec0ec3ec6;
                    d_mc_mem(51 downto 48) <= mc0_12_ec0ec3ec6;
                    d_mc_mem(55 downto 52) <= mc0_13_ec0ec3ec6;
                    d_mc_mem(59 downto 56) <= mc0_14_ec0ec3ec6;
                    d_mc_mem(63 downto 60) <= mc0_15_ec0ec3ec6;
                    d_mc_mem(67 downto 64) <= mc0_16_ec0ec3ec6;
                    d_mc_mem(71 downto 68) <= mc0_17_ec0ec3ec6;
                    d_mc_mem(75 downto 72) <= mc0_18_ec0ec3ec6;
                    d_mc_mem(79 downto 76) <= mc0_19_ec0ec3ec6;
                    d_mc_mem(83 downto 80) <= mc0_20_ec0ec3ec6;
                    d_mc_mem(87 downto 84) <= mc0_21_ec0ec3ec6;
                    
                    d_mc_mem(91 downto 88) <= mc2_0_ec1ec4ec7;--Write Column 8
                    d_mc_mem(95 downto 92) <= mc2_1_ec1ec4ec7;
                    d_mc_mem(99 downto 96) <= mc2_2_ec1ec4ec7;
                    d_mc_mem(103 downto 100) <= mc2_3_ec1ec4ec7;
                    d_mc_mem(107 downto 104) <= mc2_4_ec1ec4ec7;
                    d_mc_mem(111 downto 108) <= mc2_5_ec1ec4ec7;
                    d_mc_mem(115 downto 112) <= mc2_6_ec1ec4ec7;
                    d_mc_mem(119 downto 116) <= mc2_7_ec1ec4ec7;
                    d_mc_mem(123 downto 120) <= mc2_8_ec1ec4ec7;
                    d_mc_mem(127 downto 124) <= mc2_9_ec1ec4ec7;
                    d_mc_mem(131 downto 128) <= mc2_10_ec1ec4ec7;
                    d_mc_mem(135 downto 132) <= mc2_11_ec1ec4ec7;
                    d_mc_mem(139 downto 136) <= mc2_12_ec1ec4ec7;
                    d_mc_mem(143 downto 140) <= mc2_13_ec1ec4ec7;
                    d_mc_mem(147 downto 144) <= mc2_14_ec1ec4ec7;
                    d_mc_mem(151 downto 148) <= mc2_15_ec1ec4ec7;
                    d_mc_mem(155 downto 152) <= mc2_16_ec1ec4ec7;
                    d_mc_mem(159 downto 156) <= mc2_17_ec1ec4ec7;
                    d_mc_mem(163 downto 160) <= mc2_18_ec1ec4ec7;
                    d_mc_mem(167 downto 164) <= mc2_19_ec1ec4ec7;
                    d_mc_mem(171 downto 168) <= mc2_20_ec1ec4ec7;
                    d_mc_mem(175 downto 172) <= mc2_21_ec1ec4ec7;
                    
                    d_mc_mem(179 downto 176) <= mc2_0_ec2ec5ec8;--Write Column 16
                    d_mc_mem(183 downto 180) <= mc2_1_ec2ec5ec8;
                    d_mc_mem(187 downto 184) <= mc2_2_ec2ec5ec8;
                    d_mc_mem(191 downto 188) <= mc2_3_ec2ec5ec8;
                    d_mc_mem(195 downto 192) <= mc2_4_ec2ec5ec8;
                    d_mc_mem(199 downto 196) <= mc2_5_ec2ec5ec8;
                    d_mc_mem(203 downto 200) <= mc2_6_ec2ec5ec8;
                    d_mc_mem(207 downto 204) <= mc2_7_ec2ec5ec8;
                    d_mc_mem(211 downto 208) <= mc2_8_ec2ec5ec8;
                    d_mc_mem(215 downto 212) <= mc2_9_ec2ec5ec8;
                    d_mc_mem(219 downto 216) <= mc2_10_ec2ec5ec8;
                    d_mc_mem(223 downto 220) <= mc2_11_ec2ec5ec8;
                    d_mc_mem(227 downto 224) <= mc2_12_ec2ec5ec8;
                    d_mc_mem(231 downto 228) <= mc2_13_ec2ec5ec8;
                    d_mc_mem(235 downto 232) <= mc2_14_ec2ec5ec8;
                    d_mc_mem(239 downto 236) <= mc2_15_ec2ec5ec8;
                    d_mc_mem(243 downto 240) <= mc2_16_ec2ec5ec8;
                    d_mc_mem(247 downto 244) <= mc2_17_ec2ec5ec8;
                    d_mc_mem(251 downto 248) <= mc2_18_ec2ec5ec8;
                    d_mc_mem(255 downto 252) <= mc2_19_ec2ec5ec8;
                    d_mc_mem(259 downto 256) <= mc2_20_ec2ec5ec8;
                    d_mc_mem(263 downto 260) <= mc2_21_ec2ec5ec8;
                    
                    state_macrocell_buffer <= s1;
                end if;
            when s1 =>
                we_mc_mem <= '0';
                mcmem_rden <= '1';--Enable memory read
                a_mc_mem <= "00000";--GTU0
                a_mc_mem_write <= a_mc_mem_write + 1;
                state_macrocell_buffer <= s2;
            when s2 =>
                mcmem_rden <= '0';
                a_mc_mem <= "01000";--GTU1
                state_macrocell_buffer <= s3;
            when s3 =>
                a_mc_mem <= "10000";--GTU2
                state_macrocell_buffer <= s4;
            when s4 =>
                if (mc_ready = '1') then--Macrocell column READY
                    a_mc_mem <= a_mc_mem_write;
                    we_mc_mem <= '1';--Write in MACROCELL_MEMORY
                    d_mc_mem(3 downto 0) <= mc1_0_ec0ec3ec6;--Write Column 1
                    d_mc_mem(7 downto 4) <= mc1_1_ec0ec3ec6;
                    d_mc_mem(11 downto 8) <= mc1_2_ec0ec3ec6;
                    d_mc_mem(15 downto 12) <= mc1_3_ec0ec3ec6;
                    d_mc_mem(19 downto 16) <= mc1_4_ec0ec3ec6;
                    d_mc_mem(23 downto 20) <= mc1_5_ec0ec3ec6;
                    d_mc_mem(27 downto 24) <= mc1_6_ec0ec3ec6;
                    d_mc_mem(31 downto 28) <= mc1_7_ec0ec3ec6;
                    d_mc_mem(35 downto 32) <= mc1_8_ec0ec3ec6;
                    d_mc_mem(39 downto 36) <= mc1_9_ec0ec3ec6;
                    d_mc_mem(43 downto 40) <= mc1_10_ec0ec3ec6;
                    d_mc_mem(47 downto 44) <= mc1_11_ec0ec3ec6;
                    d_mc_mem(51 downto 48) <= mc1_12_ec0ec3ec6;
                    d_mc_mem(55 downto 52) <= mc1_13_ec0ec3ec6;
                    d_mc_mem(59 downto 56) <= mc1_14_ec0ec3ec6;
                    d_mc_mem(63 downto 60) <= mc1_15_ec0ec3ec6;
                    d_mc_mem(67 downto 64) <= mc1_16_ec0ec3ec6;
                    d_mc_mem(71 downto 68) <= mc1_17_ec0ec3ec6;
                    d_mc_mem(75 downto 72) <= mc1_18_ec0ec3ec6;
                    d_mc_mem(79 downto 76) <= mc1_19_ec0ec3ec6;
                    d_mc_mem(83 downto 80) <= mc1_20_ec0ec3ec6;
                    d_mc_mem(87 downto 84) <= mc1_21_ec0ec3ec6;
                    
                    d_mc_mem(91 downto 88) <= mc3_0_ec1ec4ec7;--Write Column 9
                    d_mc_mem(95 downto 92) <= mc3_1_ec1ec4ec7;
                    d_mc_mem(99 downto 96) <= mc3_2_ec1ec4ec7;
                    d_mc_mem(103 downto 100) <= mc3_3_ec1ec4ec7;
                    d_mc_mem(107 downto 104) <= mc3_4_ec1ec4ec7;
                    d_mc_mem(111 downto 108) <= mc3_5_ec1ec4ec7;
                    d_mc_mem(115 downto 112) <= mc3_6_ec1ec4ec7;
                    d_mc_mem(119 downto 116) <= mc3_7_ec1ec4ec7;
                    d_mc_mem(123 downto 120) <= mc3_8_ec1ec4ec7;
                    d_mc_mem(127 downto 124) <= mc3_9_ec1ec4ec7;
                    d_mc_mem(131 downto 128) <= mc3_10_ec1ec4ec7;
                    d_mc_mem(135 downto 132) <= mc3_11_ec1ec4ec7;
                    d_mc_mem(139 downto 136) <= mc3_12_ec1ec4ec7;
                    d_mc_mem(143 downto 140) <= mc3_13_ec1ec4ec7;
                    d_mc_mem(147 downto 144) <= mc3_14_ec1ec4ec7;
                    d_mc_mem(151 downto 148) <= mc3_15_ec1ec4ec7;
                    d_mc_mem(155 downto 152) <= mc3_16_ec1ec4ec7;
                    d_mc_mem(159 downto 156) <= mc3_17_ec1ec4ec7;
                    d_mc_mem(163 downto 160) <= mc3_18_ec1ec4ec7;
                    d_mc_mem(167 downto 164) <= mc3_19_ec1ec4ec7;
                    d_mc_mem(171 downto 168) <= mc3_20_ec1ec4ec7;
                    d_mc_mem(175 downto 172) <= mc3_21_ec1ec4ec7;
                    
                    d_mc_mem(179 downto 176) <= mc3_0_ec2ec5ec8;--Write Column 17
                    d_mc_mem(183 downto 180) <= mc3_1_ec2ec5ec8;
                    d_mc_mem(187 downto 184) <= mc3_2_ec2ec5ec8;
                    d_mc_mem(191 downto 188) <= mc3_3_ec2ec5ec8;
                    d_mc_mem(195 downto 192) <= mc3_4_ec2ec5ec8;
                    d_mc_mem(199 downto 196) <= mc3_5_ec2ec5ec8;
                    d_mc_mem(203 downto 200) <= mc3_6_ec2ec5ec8;
                    d_mc_mem(207 downto 204) <= mc3_7_ec2ec5ec8;
                    d_mc_mem(211 downto 208) <= mc3_8_ec2ec5ec8;
                    d_mc_mem(215 downto 212) <= mc3_9_ec2ec5ec8;
                    d_mc_mem(219 downto 216) <= mc3_10_ec2ec5ec8;
                    d_mc_mem(223 downto 220) <= mc3_11_ec2ec5ec8;
                    d_mc_mem(227 downto 224) <= mc3_12_ec2ec5ec8;
                    d_mc_mem(231 downto 228) <= mc3_13_ec2ec5ec8;
                    d_mc_mem(235 downto 232) <= mc3_14_ec2ec5ec8;
                    d_mc_mem(239 downto 236) <= mc3_15_ec2ec5ec8;
                    d_mc_mem(243 downto 240) <= mc3_16_ec2ec5ec8;
                    d_mc_mem(247 downto 244) <= mc3_17_ec2ec5ec8;
                    d_mc_mem(251 downto 248) <= mc3_18_ec2ec5ec8;
                    d_mc_mem(255 downto 252) <= mc3_19_ec2ec5ec8;
                    d_mc_mem(259 downto 256) <= mc3_20_ec2ec5ec8;
                    d_mc_mem(263 downto 260) <= mc3_21_ec2ec5ec8;
                                        
                    state_macrocell_buffer <= s5;
                end if;
            when s5 =>
                we_mc_mem <= '0';
                mcmem_rden <= '1';--Enable memory read
                a_mc_mem <= "00001";--GTU0
                a_mc_mem_write <= a_mc_mem_write + 1;
                state_macrocell_buffer <= s6;
            when s6 =>
                mcmem_rden <= '0';
                a_mc_mem <= "01001";--GTU1
                state_macrocell_buffer <= s7;
            when s7 =>
                a_mc_mem <= "10001";--GTU2
                state_macrocell_buffer <= s8;
            when s8 =>
                if (mc_ready = '1') then--Macrocell column READY
                    a_mc_mem <= a_mc_mem_write;
                    we_mc_mem <= '1';--Write in MACROCELL_MEMORY
                    d_mc_mem(3 downto 0) <= mc2_0_ec0ec3ec6;--Write Column 2
                    d_mc_mem(7 downto 4) <= mc2_1_ec0ec3ec6;
                    d_mc_mem(11 downto 8) <= mc2_2_ec0ec3ec6;
                    d_mc_mem(15 downto 12) <= mc2_3_ec0ec3ec6;
                    d_mc_mem(19 downto 16) <= mc2_4_ec0ec3ec6;
                    d_mc_mem(23 downto 20) <= mc2_5_ec0ec3ec6;
                    d_mc_mem(27 downto 24) <= mc2_6_ec0ec3ec6;
                    d_mc_mem(31 downto 28) <= mc2_7_ec0ec3ec6;
                    d_mc_mem(35 downto 32) <= mc2_8_ec0ec3ec6;
                    d_mc_mem(39 downto 36) <= mc2_9_ec0ec3ec6;
                    d_mc_mem(43 downto 40) <= mc2_10_ec0ec3ec6;
                    d_mc_mem(47 downto 44) <= mc2_11_ec0ec3ec6;
                    d_mc_mem(51 downto 48) <= mc2_12_ec0ec3ec6;
                    d_mc_mem(55 downto 52) <= mc2_13_ec0ec3ec6;
                    d_mc_mem(59 downto 56) <= mc2_14_ec0ec3ec6;
                    d_mc_mem(63 downto 60) <= mc2_15_ec0ec3ec6;
                    d_mc_mem(67 downto 64) <= mc2_16_ec0ec3ec6;
                    d_mc_mem(71 downto 68) <= mc2_17_ec0ec3ec6;
                    d_mc_mem(75 downto 72) <= mc2_18_ec0ec3ec6;
                    d_mc_mem(79 downto 76) <= mc2_19_ec0ec3ec6;
                    d_mc_mem(83 downto 80) <= mc2_20_ec0ec3ec6;
                    d_mc_mem(87 downto 84) <= mc2_21_ec0ec3ec6;
                    
                    d_mc_mem(91 downto 88) <= mc4_0_ec1ec4ec7;--Write Column 10
                    d_mc_mem(95 downto 92) <= mc4_1_ec1ec4ec7;
                    d_mc_mem(99 downto 96) <= mc4_2_ec1ec4ec7;
                    d_mc_mem(103 downto 100) <= mc4_3_ec1ec4ec7;
                    d_mc_mem(107 downto 104) <= mc4_4_ec1ec4ec7;
                    d_mc_mem(111 downto 108) <= mc4_5_ec1ec4ec7;
                    d_mc_mem(115 downto 112) <= mc4_6_ec1ec4ec7;
                    d_mc_mem(119 downto 116) <= mc4_7_ec1ec4ec7;
                    d_mc_mem(123 downto 120) <= mc4_8_ec1ec4ec7;
                    d_mc_mem(127 downto 124) <= mc4_9_ec1ec4ec7;
                    d_mc_mem(131 downto 128) <= mc4_10_ec1ec4ec7;
                    d_mc_mem(135 downto 132) <= mc4_11_ec1ec4ec7;
                    d_mc_mem(139 downto 136) <= mc4_12_ec1ec4ec7;
                    d_mc_mem(143 downto 140) <= mc4_13_ec1ec4ec7;
                    d_mc_mem(147 downto 144) <= mc4_14_ec1ec4ec7;
                    d_mc_mem(151 downto 148) <= mc4_15_ec1ec4ec7;
                    d_mc_mem(155 downto 152) <= mc4_16_ec1ec4ec7;
                    d_mc_mem(159 downto 156) <= mc4_17_ec1ec4ec7;
                    d_mc_mem(163 downto 160) <= mc4_18_ec1ec4ec7;
                    d_mc_mem(167 downto 164) <= mc4_19_ec1ec4ec7;
                    d_mc_mem(171 downto 168) <= mc4_20_ec1ec4ec7;
                    d_mc_mem(175 downto 172) <= mc4_21_ec1ec4ec7;
                    
                    d_mc_mem(179 downto 176) <= mc4_0_ec2ec5ec8;--Write Column 18
                    d_mc_mem(183 downto 180) <= mc4_1_ec2ec5ec8;
                    d_mc_mem(187 downto 184) <= mc4_2_ec2ec5ec8;
                    d_mc_mem(191 downto 188) <= mc4_3_ec2ec5ec8;
                    d_mc_mem(195 downto 192) <= mc4_4_ec2ec5ec8;
                    d_mc_mem(199 downto 196) <= mc4_5_ec2ec5ec8;
                    d_mc_mem(203 downto 200) <= mc4_6_ec2ec5ec8;
                    d_mc_mem(207 downto 204) <= mc4_7_ec2ec5ec8;
                    d_mc_mem(211 downto 208) <= mc4_8_ec2ec5ec8;
                    d_mc_mem(215 downto 212) <= mc4_9_ec2ec5ec8;
                    d_mc_mem(219 downto 216) <= mc4_10_ec2ec5ec8;
                    d_mc_mem(223 downto 220) <= mc4_11_ec2ec5ec8;
                    d_mc_mem(227 downto 224) <= mc4_12_ec2ec5ec8;
                    d_mc_mem(231 downto 228) <= mc4_13_ec2ec5ec8;
                    d_mc_mem(235 downto 232) <= mc4_14_ec2ec5ec8;
                    d_mc_mem(239 downto 236) <= mc4_15_ec2ec5ec8;
                    d_mc_mem(243 downto 240) <= mc4_16_ec2ec5ec8;
                    d_mc_mem(247 downto 244) <= mc4_17_ec2ec5ec8;
                    d_mc_mem(251 downto 248) <= mc4_18_ec2ec5ec8;
                    d_mc_mem(255 downto 252) <= mc4_19_ec2ec5ec8;
                    d_mc_mem(259 downto 256) <= mc4_20_ec2ec5ec8;
                    d_mc_mem(263 downto 260) <= mc4_21_ec2ec5ec8;
                                        
                    state_macrocell_buffer <= s9;
                end if;
            when s9 =>
                we_mc_mem <= '0';
                mcmem_rden <= '1';--Enable memory read
                a_mc_mem_write <= a_mc_mem_write + 1;
                a_mc_mem <= "00010";--GTU0
                state_macrocell_buffer <= s10;
            when s10 =>
                mcmem_rden <= '0';
                a_mc_mem <= "01010";--GTU1
                state_macrocell_buffer <= s11;
            when s11 =>
                a_mc_mem <= "10010";--GTU2
                state_macrocell_buffer <= s12;
            when s12 =>
                if (mc_ready = '1') then--Macrocell column READY
                    a_mc_mem <= a_mc_mem_write;
                    we_mc_mem <= '1';--Write in MACROCELL_MEMORY
                    d_mc_mem(3 downto 0) <= mc0_0_ec0ec3ec6;--Write Column 3
                    d_mc_mem(7 downto 4) <= mc0_1_ec0ec3ec6;
                    d_mc_mem(11 downto 8) <= mc0_2_ec0ec3ec6;
                    d_mc_mem(15 downto 12) <= mc0_3_ec0ec3ec6;
                    d_mc_mem(19 downto 16) <= mc0_4_ec0ec3ec6;
                    d_mc_mem(23 downto 20) <= mc0_5_ec0ec3ec6;
                    d_mc_mem(27 downto 24) <= mc0_6_ec0ec3ec6;
                    d_mc_mem(31 downto 28) <= mc0_7_ec0ec3ec6;
                    d_mc_mem(35 downto 32) <= mc0_8_ec0ec3ec6;
                    d_mc_mem(39 downto 36) <= mc0_9_ec0ec3ec6;
                    d_mc_mem(43 downto 40) <= mc0_10_ec0ec3ec6;
                    d_mc_mem(47 downto 44) <= mc0_11_ec0ec3ec6;
                    d_mc_mem(51 downto 48) <= mc0_12_ec0ec3ec6;
                    d_mc_mem(55 downto 52) <= mc0_13_ec0ec3ec6;
                    d_mc_mem(59 downto 56) <= mc0_14_ec0ec3ec6;
                    d_mc_mem(63 downto 60) <= mc0_15_ec0ec3ec6;
                    d_mc_mem(67 downto 64) <= mc0_16_ec0ec3ec6;
                    d_mc_mem(71 downto 68) <= mc0_17_ec0ec3ec6;
                    d_mc_mem(75 downto 72) <= mc0_18_ec0ec3ec6;
                    d_mc_mem(79 downto 76) <= mc0_19_ec0ec3ec6;
                    d_mc_mem(83 downto 80) <= mc0_20_ec0ec3ec6;
                    d_mc_mem(87 downto 84) <= mc0_21_ec0ec3ec6;
                    
                    d_mc_mem(91 downto 88) <= mc2_0_ec1ec4ec7;--Write Column 11
                    d_mc_mem(95 downto 92) <= mc2_1_ec1ec4ec7;
                    d_mc_mem(99 downto 96) <= mc2_2_ec1ec4ec7;
                    d_mc_mem(103 downto 100) <= mc2_3_ec1ec4ec7;
                    d_mc_mem(107 downto 104) <= mc2_4_ec1ec4ec7;
                    d_mc_mem(111 downto 108) <= mc2_5_ec1ec4ec7;
                    d_mc_mem(115 downto 112) <= mc2_6_ec1ec4ec7;
                    d_mc_mem(119 downto 116) <= mc2_7_ec1ec4ec7;
                    d_mc_mem(123 downto 120) <= mc2_8_ec1ec4ec7;
                    d_mc_mem(127 downto 124) <= mc2_9_ec1ec4ec7;
                    d_mc_mem(131 downto 128) <= mc2_10_ec1ec4ec7;
                    d_mc_mem(135 downto 132) <= mc2_11_ec1ec4ec7;
                    d_mc_mem(139 downto 136) <= mc2_12_ec1ec4ec7;
                    d_mc_mem(143 downto 140) <= mc2_13_ec1ec4ec7;
                    d_mc_mem(147 downto 144) <= mc2_14_ec1ec4ec7;
                    d_mc_mem(151 downto 148) <= mc2_15_ec1ec4ec7;
                    d_mc_mem(155 downto 152) <= mc2_16_ec1ec4ec7;
                    d_mc_mem(159 downto 156) <= mc2_17_ec1ec4ec7;
                    d_mc_mem(163 downto 160) <= mc2_18_ec1ec4ec7;
                    d_mc_mem(167 downto 164) <= mc2_19_ec1ec4ec7;
                    d_mc_mem(171 downto 168) <= mc2_20_ec1ec4ec7;
                    d_mc_mem(175 downto 172) <= mc2_21_ec1ec4ec7;
                    
                    d_mc_mem(179 downto 176) <= mc2_0_ec2ec5ec8;--Write Column 19
                    d_mc_mem(183 downto 180) <= mc2_1_ec2ec5ec8;
                    d_mc_mem(187 downto 184) <= mc2_2_ec2ec5ec8;
                    d_mc_mem(191 downto 188) <= mc2_3_ec2ec5ec8;
                    d_mc_mem(195 downto 192) <= mc2_4_ec2ec5ec8;
                    d_mc_mem(199 downto 196) <= mc2_5_ec2ec5ec8;
                    d_mc_mem(203 downto 200) <= mc2_6_ec2ec5ec8;
                    d_mc_mem(207 downto 204) <= mc2_7_ec2ec5ec8;
                    d_mc_mem(211 downto 208) <= mc2_8_ec2ec5ec8;
                    d_mc_mem(215 downto 212) <= mc2_9_ec2ec5ec8;
                    d_mc_mem(219 downto 216) <= mc2_10_ec2ec5ec8;
                    d_mc_mem(223 downto 220) <= mc2_11_ec2ec5ec8;
                    d_mc_mem(227 downto 224) <= mc2_12_ec2ec5ec8;
                    d_mc_mem(231 downto 228) <= mc2_13_ec2ec5ec8;
                    d_mc_mem(235 downto 232) <= mc2_14_ec2ec5ec8;
                    d_mc_mem(239 downto 236) <= mc2_15_ec2ec5ec8;
                    d_mc_mem(243 downto 240) <= mc2_16_ec2ec5ec8;
                    d_mc_mem(247 downto 244) <= mc2_17_ec2ec5ec8;
                    d_mc_mem(251 downto 248) <= mc2_18_ec2ec5ec8;
                    d_mc_mem(255 downto 252) <= mc2_19_ec2ec5ec8;
                    d_mc_mem(259 downto 256) <= mc2_20_ec2ec5ec8;
                    d_mc_mem(263 downto 260) <= mc2_21_ec2ec5ec8;
                    
                    state_macrocell_buffer <= s13;
                end if;
            when s13 =>
                we_mc_mem <= '0';
                mcmem_rden <= '1';--Enable memory read
                a_mc_mem <= "00011";--GTU0
                a_mc_mem_write <= a_mc_mem_write + 1;
                state_macrocell_buffer <= s14;
            when s14 =>
                mcmem_rden <= '0';
                a_mc_mem <= "01011";--GTU1
                state_macrocell_buffer <= s15;
            when s15 =>
                a_mc_mem <= "10011";--GTU2
                state_macrocell_buffer <= s16;
            when s16 =>
                if (mc_ready = '1') then--Macrocell column READY
                    a_mc_mem <= a_mc_mem_write;
                    we_mc_mem <= '1';--Write in MACROCELL_MEMORY
                    d_mc_mem(3 downto 0) <= mc1_0_ec0ec3ec6;--Write Column 4
                    d_mc_mem(7 downto 4) <= mc1_1_ec0ec3ec6;
                    d_mc_mem(11 downto 8) <= mc1_2_ec0ec3ec6;
                    d_mc_mem(15 downto 12) <= mc1_3_ec0ec3ec6;
                    d_mc_mem(19 downto 16) <= mc1_4_ec0ec3ec6;
                    d_mc_mem(23 downto 20) <= mc1_5_ec0ec3ec6;
                    d_mc_mem(27 downto 24) <= mc1_6_ec0ec3ec6;
                    d_mc_mem(31 downto 28) <= mc1_7_ec0ec3ec6;
                    d_mc_mem(35 downto 32) <= mc1_8_ec0ec3ec6;
                    d_mc_mem(39 downto 36) <= mc1_9_ec0ec3ec6;
                    d_mc_mem(43 downto 40) <= mc1_10_ec0ec3ec6;
                    d_mc_mem(47 downto 44) <= mc1_11_ec0ec3ec6;
                    d_mc_mem(51 downto 48) <= mc1_12_ec0ec3ec6;
                    d_mc_mem(55 downto 52) <= mc1_13_ec0ec3ec6;
                    d_mc_mem(59 downto 56) <= mc1_14_ec0ec3ec6;
                    d_mc_mem(63 downto 60) <= mc1_15_ec0ec3ec6;
                    d_mc_mem(67 downto 64) <= mc1_16_ec0ec3ec6;
                    d_mc_mem(71 downto 68) <= mc1_17_ec0ec3ec6;
                    d_mc_mem(75 downto 72) <= mc1_18_ec0ec3ec6;
                    d_mc_mem(79 downto 76) <= mc1_19_ec0ec3ec6;
                    d_mc_mem(83 downto 80) <= mc1_20_ec0ec3ec6;
                    d_mc_mem(87 downto 84) <= mc1_21_ec0ec3ec6;
                    
                    d_mc_mem(91 downto 88) <= mc3_0_ec1ec4ec7;--Write Column 12
                    d_mc_mem(95 downto 92) <= mc3_1_ec1ec4ec7;
                    d_mc_mem(99 downto 96) <= mc3_2_ec1ec4ec7;
                    d_mc_mem(103 downto 100) <= mc3_3_ec1ec4ec7;
                    d_mc_mem(107 downto 104) <= mc3_4_ec1ec4ec7;
                    d_mc_mem(111 downto 108) <= mc3_5_ec1ec4ec7;
                    d_mc_mem(115 downto 112) <= mc3_6_ec1ec4ec7;
                    d_mc_mem(119 downto 116) <= mc3_7_ec1ec4ec7;
                    d_mc_mem(123 downto 120) <= mc3_8_ec1ec4ec7;
                    d_mc_mem(127 downto 124) <= mc3_9_ec1ec4ec7;
                    d_mc_mem(131 downto 128) <= mc3_10_ec1ec4ec7;
                    d_mc_mem(135 downto 132) <= mc3_11_ec1ec4ec7;
                    d_mc_mem(139 downto 136) <= mc3_12_ec1ec4ec7;
                    d_mc_mem(143 downto 140) <= mc3_13_ec1ec4ec7;
                    d_mc_mem(147 downto 144) <= mc3_14_ec1ec4ec7;
                    d_mc_mem(151 downto 148) <= mc3_15_ec1ec4ec7;
                    d_mc_mem(155 downto 152) <= mc3_16_ec1ec4ec7;
                    d_mc_mem(159 downto 156) <= mc3_17_ec1ec4ec7;
                    d_mc_mem(163 downto 160) <= mc3_18_ec1ec4ec7;
                    d_mc_mem(167 downto 164) <= mc3_19_ec1ec4ec7;
                    d_mc_mem(171 downto 168) <= mc3_20_ec1ec4ec7;
                    d_mc_mem(175 downto 172) <= mc3_21_ec1ec4ec7;
                    
                    d_mc_mem(179 downto 176) <= mc3_0_ec2ec5ec8;--Write Column 20
                    d_mc_mem(183 downto 180) <= mc3_1_ec2ec5ec8;
                    d_mc_mem(187 downto 184) <= mc3_2_ec2ec5ec8;
                    d_mc_mem(191 downto 188) <= mc3_3_ec2ec5ec8;
                    d_mc_mem(195 downto 192) <= mc3_4_ec2ec5ec8;
                    d_mc_mem(199 downto 196) <= mc3_5_ec2ec5ec8;
                    d_mc_mem(203 downto 200) <= mc3_6_ec2ec5ec8;
                    d_mc_mem(207 downto 204) <= mc3_7_ec2ec5ec8;
                    d_mc_mem(211 downto 208) <= mc3_8_ec2ec5ec8;
                    d_mc_mem(215 downto 212) <= mc3_9_ec2ec5ec8;
                    d_mc_mem(219 downto 216) <= mc3_10_ec2ec5ec8;
                    d_mc_mem(223 downto 220) <= mc3_11_ec2ec5ec8;
                    d_mc_mem(227 downto 224) <= mc3_12_ec2ec5ec8;
                    d_mc_mem(231 downto 228) <= mc3_13_ec2ec5ec8;
                    d_mc_mem(235 downto 232) <= mc3_14_ec2ec5ec8;
                    d_mc_mem(239 downto 236) <= mc3_15_ec2ec5ec8;
                    d_mc_mem(243 downto 240) <= mc3_16_ec2ec5ec8;
                    d_mc_mem(247 downto 244) <= mc3_17_ec2ec5ec8;
                    d_mc_mem(251 downto 248) <= mc3_18_ec2ec5ec8;
                    d_mc_mem(255 downto 252) <= mc3_19_ec2ec5ec8;
                    d_mc_mem(259 downto 256) <= mc3_20_ec2ec5ec8;
                    d_mc_mem(263 downto 260) <= mc3_21_ec2ec5ec8;
                    
                    state_macrocell_buffer <= s17;
                end if;
            when s17 =>
                we_mc_mem <= '0';
                mcmem_rden <= '1';--Enable memory read
                a_mc_mem <= "00100";--GTU0
                a_mc_mem_write <= a_mc_mem_write + 1;
                state_macrocell_buffer <= s18;
            when s18 =>
                mcmem_rden <= '0';
                a_mc_mem <= "01100";--GTU1
                state_macrocell_buffer <= s19;
            when s19 =>
                a_mc_mem <= "10100";--GTU2
                state_macrocell_buffer <= s20;
            when s20 =>
                if (mc_ready = '1') then--Macrocell column READY
                    a_mc_mem <= a_mc_mem_write;
                    we_mc_mem <= '1';--Write in MACROCELL_MEMORY
                    d_mc_mem(3 downto 0) <= mc2_0_ec0ec3ec6;--Write Column 5
                    d_mc_mem(7 downto 4) <= mc2_1_ec0ec3ec6;
                    d_mc_mem(11 downto 8) <= mc2_2_ec0ec3ec6;
                    d_mc_mem(15 downto 12) <= mc2_3_ec0ec3ec6;
                    d_mc_mem(19 downto 16) <= mc2_4_ec0ec3ec6;
                    d_mc_mem(23 downto 20) <= mc2_5_ec0ec3ec6;
                    d_mc_mem(27 downto 24) <= mc2_6_ec0ec3ec6;
                    d_mc_mem(31 downto 28) <= mc2_7_ec0ec3ec6;
                    d_mc_mem(35 downto 32) <= mc2_8_ec0ec3ec6;
                    d_mc_mem(39 downto 36) <= mc2_9_ec0ec3ec6;
                    d_mc_mem(43 downto 40) <= mc2_10_ec0ec3ec6;
                    d_mc_mem(47 downto 44) <= mc2_11_ec0ec3ec6;
                    d_mc_mem(51 downto 48) <= mc2_12_ec0ec3ec6;
                    d_mc_mem(55 downto 52) <= mc2_13_ec0ec3ec6;
                    d_mc_mem(59 downto 56) <= mc2_14_ec0ec3ec6;
                    d_mc_mem(63 downto 60) <= mc2_15_ec0ec3ec6;
                    d_mc_mem(67 downto 64) <= mc2_16_ec0ec3ec6;
                    d_mc_mem(71 downto 68) <= mc2_17_ec0ec3ec6;
                    d_mc_mem(75 downto 72) <= mc2_18_ec0ec3ec6;
                    d_mc_mem(79 downto 76) <= mc2_19_ec0ec3ec6;
                    d_mc_mem(83 downto 80) <= mc2_20_ec0ec3ec6;
                    d_mc_mem(87 downto 84) <= mc2_21_ec0ec3ec6;
                    
                    d_mc_mem(91 downto 88) <= mc0_0_ec1ec4ec7;--Write Column 6
                    d_mc_mem(95 downto 92) <= mc0_1_ec1ec4ec7;
                    d_mc_mem(99 downto 96) <= mc0_2_ec1ec4ec7;
                    d_mc_mem(103 downto 100) <= mc0_3_ec1ec4ec7;
                    d_mc_mem(107 downto 104) <= mc0_4_ec1ec4ec7;
                    d_mc_mem(111 downto 108) <= mc0_5_ec1ec4ec7;
                    d_mc_mem(115 downto 112) <= mc0_6_ec1ec4ec7;
                    d_mc_mem(119 downto 116) <= mc0_7_ec1ec4ec7;
                    d_mc_mem(123 downto 120) <= mc0_8_ec1ec4ec7;
                    d_mc_mem(127 downto 124) <= mc0_9_ec1ec4ec7;
                    d_mc_mem(131 downto 128) <= mc0_10_ec1ec4ec7;
                    d_mc_mem(135 downto 132) <= mc0_11_ec1ec4ec7;
                    d_mc_mem(139 downto 136) <= mc0_12_ec1ec4ec7;
                    d_mc_mem(143 downto 140) <= mc0_13_ec1ec4ec7;
                    d_mc_mem(147 downto 144) <= mc0_14_ec1ec4ec7;
                    d_mc_mem(151 downto 148) <= mc0_15_ec1ec4ec7;
                    d_mc_mem(155 downto 152) <= mc0_16_ec1ec4ec7;
                    d_mc_mem(159 downto 156) <= mc0_17_ec1ec4ec7;
                    d_mc_mem(163 downto 160) <= mc0_18_ec1ec4ec7;
                    d_mc_mem(167 downto 164) <= mc0_19_ec1ec4ec7;
                    d_mc_mem(171 downto 168) <= mc0_20_ec1ec4ec7;
                    d_mc_mem(175 downto 172) <= mc0_21_ec1ec4ec7;
                    
                    d_mc_mem(179 downto 176) <= mc1_0_ec1ec4ec7;--Write Column 7
                    d_mc_mem(183 downto 180) <= mc1_1_ec1ec4ec7;
                    d_mc_mem(187 downto 184) <= mc1_2_ec1ec4ec7;
                    d_mc_mem(191 downto 188) <= mc1_3_ec1ec4ec7;
                    d_mc_mem(195 downto 192) <= mc1_4_ec1ec4ec7;
                    d_mc_mem(199 downto 196) <= mc1_5_ec1ec4ec7;
                    d_mc_mem(203 downto 200) <= mc1_6_ec1ec4ec7;
                    d_mc_mem(207 downto 204) <= mc1_7_ec1ec4ec7;
                    d_mc_mem(211 downto 208) <= mc1_8_ec1ec4ec7;
                    d_mc_mem(215 downto 212) <= mc1_9_ec1ec4ec7;
                    d_mc_mem(219 downto 216) <= mc1_10_ec1ec4ec7;
                    d_mc_mem(223 downto 220) <= mc1_11_ec1ec4ec7;
                    d_mc_mem(227 downto 224) <= mc1_12_ec1ec4ec7;
                    d_mc_mem(231 downto 228) <= mc1_13_ec1ec4ec7;
                    d_mc_mem(235 downto 232) <= mc1_14_ec1ec4ec7;
                    d_mc_mem(239 downto 236) <= mc1_15_ec1ec4ec7;
                    d_mc_mem(243 downto 240) <= mc1_16_ec1ec4ec7;
                    d_mc_mem(247 downto 244) <= mc1_17_ec1ec4ec7;
                    d_mc_mem(251 downto 248) <= mc1_18_ec1ec4ec7;
                    d_mc_mem(255 downto 252) <= mc1_19_ec1ec4ec7;
                    d_mc_mem(259 downto 256) <= mc1_20_ec1ec4ec7;
                    d_mc_mem(263 downto 260) <= mc1_21_ec1ec4ec7;
                                        
                    mctmp0_0 <= mc4_0_ec1ec4ec7;--Save Column 13
                    mctmp0_1 <= mc4_1_ec1ec4ec7;
                    mctmp0_2 <= mc4_2_ec1ec4ec7;
                    mctmp0_3 <= mc4_3_ec1ec4ec7;
                    mctmp0_4 <= mc4_4_ec1ec4ec7;
                    mctmp0_5 <= mc4_5_ec1ec4ec7;
                    mctmp0_6 <= mc4_6_ec1ec4ec7;
                    mctmp0_7 <= mc4_7_ec1ec4ec7;
                    mctmp0_8 <= mc4_8_ec1ec4ec7;
                    mctmp0_9 <= mc4_9_ec1ec4ec7;
                    mctmp0_10 <= mc4_10_ec1ec4ec7;
                    mctmp0_11 <= mc4_11_ec1ec4ec7;
                    mctmp0_12 <= mc4_12_ec1ec4ec7;
                    mctmp0_13 <= mc4_13_ec1ec4ec7;
                    mctmp0_14 <= mc4_14_ec1ec4ec7;
                    mctmp0_15 <= mc4_15_ec1ec4ec7;
                    mctmp0_16 <= mc4_16_ec1ec4ec7;
                    mctmp0_17 <= mc4_17_ec1ec4ec7;
                    mctmp0_18 <= mc4_18_ec1ec4ec7;
                    mctmp0_19 <= mc4_19_ec1ec4ec7;
                    mctmp0_20 <= mc4_20_ec1ec4ec7;
                    mctmp0_21 <= mc4_21_ec1ec4ec7;
                    
                    mctmp1_0 <= mc0_0_ec2ec5ec8;--Save Column 14
                    mctmp1_1 <= mc0_1_ec2ec5ec8;
                    mctmp1_2 <= mc0_2_ec2ec5ec8;
                    mctmp1_3 <= mc0_3_ec2ec5ec8;
                    mctmp1_4 <= mc0_4_ec2ec5ec8;
                    mctmp1_5 <= mc0_5_ec2ec5ec8;
                    mctmp1_6 <= mc0_6_ec2ec5ec8;
                    mctmp1_7 <= mc0_7_ec2ec5ec8;
                    mctmp1_8 <= mc0_8_ec2ec5ec8;
                    mctmp1_9 <= mc0_9_ec2ec5ec8;
                    mctmp1_10 <= mc0_10_ec2ec5ec8;
                    mctmp1_11 <= mc0_11_ec2ec5ec8;
                    mctmp1_12 <= mc0_12_ec2ec5ec8;
                    mctmp1_13 <= mc0_13_ec2ec5ec8;
                    mctmp1_14 <= mc0_14_ec2ec5ec8;
                    mctmp1_15 <= mc0_15_ec2ec5ec8;
                    mctmp1_16 <= mc0_16_ec2ec5ec8;
                    mctmp1_17 <= mc0_17_ec2ec5ec8;
                    mctmp1_18 <= mc0_18_ec2ec5ec8;
                    mctmp1_19 <= mc0_19_ec2ec5ec8;
                    mctmp1_20 <= mc0_20_ec2ec5ec8;
                    mctmp1_21 <= mc0_21_ec2ec5ec8;
                    
                    mctmp2_0 <= mc1_0_ec2ec5ec8;--Save Column 15
                    mctmp2_1 <= mc1_1_ec2ec5ec8;
                    mctmp2_2 <= mc1_2_ec2ec5ec8;
                    mctmp2_3 <= mc1_3_ec2ec5ec8;
                    mctmp2_4 <= mc1_4_ec2ec5ec8;
                    mctmp2_5 <= mc1_5_ec2ec5ec8;
                    mctmp2_6 <= mc1_6_ec2ec5ec8;
                    mctmp2_7 <= mc1_7_ec2ec5ec8;
                    mctmp2_8 <= mc1_8_ec2ec5ec8;
                    mctmp2_9 <= mc1_9_ec2ec5ec8;
                    mctmp2_10 <= mc1_10_ec2ec5ec8;
                    mctmp2_11 <= mc1_11_ec2ec5ec8;
                    mctmp2_12 <= mc1_12_ec2ec5ec8;
                    mctmp2_13 <= mc1_13_ec2ec5ec8;
                    mctmp2_14 <= mc1_14_ec2ec5ec8;
                    mctmp2_15 <= mc1_15_ec2ec5ec8;
                    mctmp2_16 <= mc1_16_ec2ec5ec8;
                    mctmp2_17 <= mc1_17_ec2ec5ec8;
                    mctmp2_18 <= mc1_18_ec2ec5ec8;
                    mctmp2_19 <= mc1_19_ec2ec5ec8;
                    mctmp2_20 <= mc1_20_ec2ec5ec8;
                    mctmp2_21 <= mc1_21_ec2ec5ec8;
                    
                    mctmp3_0 <= mc4_0_ec2ec5ec8;--Save Column 21
                    mctmp3_1 <= mc4_1_ec2ec5ec8;
                    mctmp3_2 <= mc4_2_ec2ec5ec8;
                    mctmp3_3 <= mc4_3_ec2ec5ec8;
                    mctmp3_4 <= mc4_4_ec2ec5ec8;
                    mctmp3_5 <= mc4_5_ec2ec5ec8;
                    mctmp3_6 <= mc4_6_ec2ec5ec8;
                    mctmp3_7 <= mc4_7_ec2ec5ec8;
                    mctmp3_8 <= mc4_8_ec2ec5ec8;
                    mctmp3_9 <= mc4_9_ec2ec5ec8;
                    mctmp3_10 <= mc4_10_ec2ec5ec8;
                    mctmp3_11 <= mc4_11_ec2ec5ec8;
                    mctmp3_12 <= mc4_12_ec2ec5ec8;
                    mctmp3_13 <= mc4_13_ec2ec5ec8;
                    mctmp3_14 <= mc4_14_ec2ec5ec8;
                    mctmp3_15 <= mc4_15_ec2ec5ec8;
                    mctmp3_16 <= mc4_16_ec2ec5ec8;
                    mctmp3_17 <= mc4_17_ec2ec5ec8;
                    mctmp3_18 <= mc4_18_ec2ec5ec8;
                    mctmp3_19 <= mc4_19_ec2ec5ec8;
                    mctmp3_20 <= mc4_20_ec2ec5ec8;
                    mctmp3_21 <= mc4_21_ec2ec5ec8;
                    
                    state_macrocell_buffer <= s21;
                end if;
            when s21 =>
                we_mc_mem <= '0';
                mcmem_rden <= '1';--Enable memory read
                a_mc_mem <= "00101";--GTU0
                a_mc_mem_write <= a_mc_mem_write + 1;
                state_macrocell_buffer <= s22;
            when s22 =>
                mcmem_rden <= '0';
                a_mc_mem <= "01101";--GTU1
                state_macrocell_buffer <= s23;
            when s23 =>
                a_mc_mem <= "10101";--GTU2
                state_macrocell_buffer <= s24;
            when s24 =>
                a_mc_mem <= a_mc_mem_write;
                we_mc_mem <= '1';--Write in MACROCELL_MEMORY
                d_mc_mem(3 downto 0) <= mctmp0_0;--Write Column 13
                d_mc_mem(7 downto 4) <= mctmp0_1;
                d_mc_mem(11 downto 8) <= mctmp0_2;
                d_mc_mem(15 downto 12) <= mctmp0_3;
                d_mc_mem(19 downto 16) <= mctmp0_4;
                d_mc_mem(23 downto 20) <= mctmp0_5;
                d_mc_mem(27 downto 24) <= mctmp0_6;
                d_mc_mem(31 downto 28) <= mctmp0_7;
                d_mc_mem(35 downto 32) <= mctmp0_8;
                d_mc_mem(39 downto 36) <= mctmp0_9;
                d_mc_mem(43 downto 40) <= mctmp0_10;
                d_mc_mem(47 downto 44) <= mctmp0_11;
                d_mc_mem(51 downto 48) <= mctmp0_12;
                d_mc_mem(55 downto 52) <= mctmp0_13;
                d_mc_mem(59 downto 56) <= mctmp0_14;
                d_mc_mem(63 downto 60) <= mctmp0_15;
                d_mc_mem(67 downto 64) <= mctmp0_16;
                d_mc_mem(71 downto 68) <= mctmp0_17;
                d_mc_mem(75 downto 72) <= mctmp0_18;
                d_mc_mem(79 downto 76) <= mctmp0_19;
                d_mc_mem(83 downto 80) <= mctmp0_20;
                d_mc_mem(87 downto 84) <= mctmp0_21;
                
                d_mc_mem(91 downto 88) <= mctmp1_0;--Write Column 14
                d_mc_mem(95 downto 92) <= mctmp1_1;
                d_mc_mem(99 downto 96) <= mctmp1_2;
                d_mc_mem(103 downto 100) <= mctmp1_3;
                d_mc_mem(107 downto 104) <= mctmp1_4;
                d_mc_mem(111 downto 108) <= mctmp1_5;
                d_mc_mem(115 downto 112) <= mctmp1_6;
                d_mc_mem(119 downto 116) <= mctmp1_7;
                d_mc_mem(123 downto 120) <= mctmp1_8;
                d_mc_mem(127 downto 124) <= mctmp1_9;
                d_mc_mem(131 downto 128) <= mctmp1_10;
                d_mc_mem(135 downto 132) <= mctmp1_11;
                d_mc_mem(139 downto 136) <= mctmp1_12;
                d_mc_mem(143 downto 140) <= mctmp1_13;
                d_mc_mem(147 downto 144) <= mctmp1_14;
                d_mc_mem(151 downto 148) <= mctmp1_15;
                d_mc_mem(155 downto 152) <= mctmp1_16;
                d_mc_mem(159 downto 156) <= mctmp1_17;
                d_mc_mem(163 downto 160) <= mctmp1_18;
                d_mc_mem(167 downto 164) <= mctmp1_19;
                d_mc_mem(171 downto 168) <= mctmp1_20;
                d_mc_mem(175 downto 172) <= mctmp1_21;
                
                d_mc_mem(179 downto 176) <= mctmp2_0;--Write Column 15
                d_mc_mem(183 downto 180) <= mctmp2_1;
                d_mc_mem(187 downto 184) <= mctmp2_2;
                d_mc_mem(191 downto 188) <= mctmp2_3;
                d_mc_mem(195 downto 192) <= mctmp2_4;
                d_mc_mem(199 downto 196) <= mctmp2_5;
                d_mc_mem(203 downto 200) <= mctmp2_6;
                d_mc_mem(207 downto 204) <= mctmp2_7;
                d_mc_mem(211 downto 208) <= mctmp2_8;
                d_mc_mem(215 downto 212) <= mctmp2_9;
                d_mc_mem(219 downto 216) <= mctmp2_10;
                d_mc_mem(223 downto 220) <= mctmp2_11;
                d_mc_mem(227 downto 224) <= mctmp2_12;
                d_mc_mem(231 downto 228) <= mctmp2_13;
                d_mc_mem(235 downto 232) <= mctmp2_14;
                d_mc_mem(239 downto 236) <= mctmp2_15;
                d_mc_mem(243 downto 240) <= mctmp2_16;
                d_mc_mem(247 downto 244) <= mctmp2_17;
                d_mc_mem(251 downto 248) <= mctmp2_18;
                d_mc_mem(255 downto 252) <= mctmp2_19;
                d_mc_mem(259 downto 256) <= mctmp2_20;
                d_mc_mem(263 downto 260) <= mctmp2_21;
                
                state_macrocell_buffer <= s25;
            when s25 =>
                mcmem_rden <= '1';--Enable memory read
                we_mc_mem <= '0';
                a_mc_mem <= "00110";--GTU0
                a_mc_mem_write <= a_mc_mem_write + 1;
                state_macrocell_buffer <= s26;
            when s26 =>
                mcmem_rden <= '0';
                a_mc_mem <= "01110";--GTU1
                state_macrocell_buffer <= s27;
            when s27 =>
                a_mc_mem <= "10110";--GTU2
                state_macrocell_buffer <= s28;
            when s28 =>
                we_mc_mem <= '1';
                a_mc_mem <= a_mc_mem_write;
                            
                d_mc_mem(3 downto 0) <= mctmp3_0;--Write Column 21
                d_mc_mem(7 downto 4) <= mctmp3_1;
                d_mc_mem(11 downto 8) <= mctmp3_2;
                d_mc_mem(15 downto 12) <= mctmp3_3;
                d_mc_mem(19 downto 16) <= mctmp3_4;
                d_mc_mem(23 downto 20) <= mctmp3_5;
                d_mc_mem(27 downto 24) <= mctmp3_6;
                d_mc_mem(31 downto 28) <= mctmp3_7;
                d_mc_mem(35 downto 32) <= mctmp3_8;
                d_mc_mem(39 downto 36) <= mctmp3_9;
                d_mc_mem(43 downto 40) <= mctmp3_10;
                d_mc_mem(47 downto 44) <= mctmp3_11;
                d_mc_mem(51 downto 48) <= mctmp3_12;
                d_mc_mem(55 downto 52) <= mctmp3_13;
                d_mc_mem(59 downto 56) <= mctmp3_14;
                d_mc_mem(63 downto 60) <= mctmp3_15;
                d_mc_mem(67 downto 64) <= mctmp3_16;
                d_mc_mem(71 downto 68) <= mctmp3_17;
                d_mc_mem(75 downto 72) <= mctmp3_18;
                d_mc_mem(79 downto 76) <= mctmp3_19;
                d_mc_mem(83 downto 80) <= mctmp3_20;
                d_mc_mem(87 downto 84) <= mctmp3_21;
                
                state_macrocell_buffer <= s29;
            when s29 =>
                mcmem_rden <= '1';--Enable memory read
                we_mc_mem <= '0';
                a_mc_mem <= "00111";--GTU0
                state_macrocell_buffer <= s30;
            when s30 =>
                mcmem_rden <= '0';
                a_mc_mem <= "01111";--GTU1
                state_macrocell_buffer <= s31;
            when s31 =>
                a_mc_mem <= "10111";--GTU2
                if (a_mc_mem_write = "10111") then
                    a_mc_mem_write <= "00000";
                else
                    a_mc_mem_write <= a_mc_mem_write + 1;
                end if;
                state_macrocell_buffer <= s0;
        end case;
    end if;
end process;

macrocell_buffer_sum : process (CLOCK)--Read Macrocell buffer and SUM calculation over 3GTU
begin 
    if (CLOCK'event and CLOCK = '1') then
        case (state_buffer_read) is
            when s0 =>
                if (mcmem_rden = '1') then--Start memory read for 3GTU position in buffer
                    B_accum_mc0_0 <= spo_mc_mem(3 downto 0);--GTU0
                    B_accum_mc1_0 <= spo_mc_mem(7 downto 4);--GTU0
                    B_accum_mc2_0 <= spo_mc_mem(11 downto 8);--GTU0
                    B_accum_mc3_0 <= spo_mc_mem(15 downto 12);--GTU0
                    B_accum_mc4_0 <= spo_mc_mem(19 downto 16);--GTU0
                    B_accum_mc5_0 <= spo_mc_mem(23 downto 20);--GTU0
                    B_accum_mc6_0 <= spo_mc_mem(27 downto 24);--GTU0
                    B_accum_mc7_0 <= spo_mc_mem(31 downto 28);--GTU0
                    B_accum_mc8_0 <= spo_mc_mem(35 downto 32);--GTU0
                    B_accum_mc9_0 <= spo_mc_mem(39 downto 36);--GTU0
                    B_accum_mc10_0 <= spo_mc_mem(43 downto 40);--GTU0
                    B_accum_mc11_0 <= spo_mc_mem(47 downto 44);--GTU0
                    B_accum_mc12_0 <= spo_mc_mem(51 downto 48);--GTU0
                    B_accum_mc13_0 <= spo_mc_mem(55 downto 52);--GTU0
                    B_accum_mc14_0 <= spo_mc_mem(59 downto 56);--GTU0
                    B_accum_mc15_0 <= spo_mc_mem(63 downto 60);--GTU0
                    B_accum_mc16_0 <= spo_mc_mem(67 downto 64);--GTU0
                    B_accum_mc17_0 <= spo_mc_mem(71 downto 68);--GTU0
                    B_accum_mc18_0 <= spo_mc_mem(75 downto 72);--GTU0
                    B_accum_mc19_0 <= spo_mc_mem(79 downto 76);--GTU0
                    B_accum_mc20_0 <= spo_mc_mem(83 downto 80);--GTU0
                    B_accum_mc21_0 <= spo_mc_mem(87 downto 84);--GTU0
                    
                    B_accum_mc0_1 <= spo_mc_mem(91 downto 88);--GTU0
                    B_accum_mc1_1 <= spo_mc_mem(95 downto 92);--GTU0
                    B_accum_mc2_1 <= spo_mc_mem(99 downto 96);--GTU0
                    B_accum_mc3_1 <= spo_mc_mem(103 downto 100);--GTU0
                    B_accum_mc4_1 <= spo_mc_mem(107 downto 104);--GTU0
                    B_accum_mc5_1 <= spo_mc_mem(111 downto 108);--GTU0
                    B_accum_mc6_1 <= spo_mc_mem(115 downto 112);--GTU0
                    B_accum_mc7_1 <= spo_mc_mem(119 downto 116);--GTU0
                    B_accum_mc8_1 <= spo_mc_mem(123 downto 120);--GTU0
                    B_accum_mc9_1 <= spo_mc_mem(127 downto 124);--GTU0
                    B_accum_mc10_1 <= spo_mc_mem(131 downto 128);--GTU0
                    B_accum_mc11_1 <= spo_mc_mem(135 downto 132);--GTU0
                    B_accum_mc12_1 <= spo_mc_mem(139 downto 136);--GTU0
                    B_accum_mc13_1 <= spo_mc_mem(143 downto 140);--GTU0
                    B_accum_mc14_1 <= spo_mc_mem(147 downto 144);--GTU0
                    B_accum_mc15_1 <= spo_mc_mem(151 downto 148);--GTU0
                    B_accum_mc16_1 <= spo_mc_mem(155 downto 152);--GTU0
                    B_accum_mc17_1 <= spo_mc_mem(159 downto 156);--GTU0
                    B_accum_mc18_1 <= spo_mc_mem(163 downto 160);--GTU0
                    B_accum_mc19_1 <= spo_mc_mem(167 downto 164);--GTU0
                    B_accum_mc20_1 <= spo_mc_mem(171 downto 168);--GTU0
                    B_accum_mc21_1 <= spo_mc_mem(175 downto 172);--GTU0
                    
                    B_accum_mc0_2 <= spo_mc_mem(179 downto 176);--GTU0
                    B_accum_mc1_2 <= spo_mc_mem(183 downto 180);--GTU0
                    B_accum_mc2_2 <= spo_mc_mem(187 downto 184);--GTU0
                    B_accum_mc3_2 <= spo_mc_mem(191 downto 188);--GTU0
                    B_accum_mc4_2 <= spo_mc_mem(195 downto 192);--GTU0
                    B_accum_mc5_2 <= spo_mc_mem(199 downto 196);--GTU0
                    B_accum_mc6_2 <= spo_mc_mem(203 downto 200);--GTU0
                    B_accum_mc7_2 <= spo_mc_mem(207 downto 204);--GTU0
                    B_accum_mc8_2 <= spo_mc_mem(211 downto 208);--GTU0
                    B_accum_mc9_2 <= spo_mc_mem(215 downto 212);--GTU0
                    B_accum_mc10_2 <= spo_mc_mem(219 downto 216);--GTU0
                    B_accum_mc11_2 <= spo_mc_mem(223 downto 220);--GTU0
                    B_accum_mc12_2 <= spo_mc_mem(227 downto 224);--GTU0
                    B_accum_mc13_2 <= spo_mc_mem(231 downto 228);--GTU0
                    B_accum_mc14_2 <= spo_mc_mem(235 downto 232);--GTU0
                    B_accum_mc15_2 <= spo_mc_mem(239 downto 236);--GTU0
                    B_accum_mc16_2 <= spo_mc_mem(243 downto 240);--GTU0
                    B_accum_mc17_2 <= spo_mc_mem(247 downto 244);--GTU0
                    B_accum_mc18_2 <= spo_mc_mem(251 downto 248);--GTU0
                    B_accum_mc19_2 <= spo_mc_mem(255 downto 252);--GTU0
                    B_accum_mc20_2 <= spo_mc_mem(259 downto 256);--GTU0
                    B_accum_mc21_2 <= spo_mc_mem(263 downto 260);--GTU0
                    
                    CE_accum <= '1';
                    state_buffer_read <= s1;
                end if;
                SCLR_accum <= '0';
                bufsum_ready <= '0';
            when s1 =>
                B_accum_mc0_0 <= spo_mc_mem(3 downto 0);--GTU1
                B_accum_mc1_0 <= spo_mc_mem(7 downto 4);--GTU1
                B_accum_mc2_0 <= spo_mc_mem(11 downto 8);--GTU1
                B_accum_mc3_0 <= spo_mc_mem(15 downto 12);--GTU1
                B_accum_mc4_0 <= spo_mc_mem(19 downto 16);--GTU1
                B_accum_mc5_0 <= spo_mc_mem(23 downto 20);--GTU1
                B_accum_mc6_0 <= spo_mc_mem(27 downto 24);--GTU1
                B_accum_mc7_0 <= spo_mc_mem(31 downto 28);--GTU1
                B_accum_mc8_0 <= spo_mc_mem(35 downto 32);--GTU1
                B_accum_mc9_0 <= spo_mc_mem(39 downto 36);--GTU1
                B_accum_mc10_0 <= spo_mc_mem(43 downto 40);--GTU1
                B_accum_mc11_0 <= spo_mc_mem(47 downto 44);--GTU1
                B_accum_mc12_0 <= spo_mc_mem(51 downto 48);--GTU1
                B_accum_mc13_0 <= spo_mc_mem(55 downto 52);--GTU1
                B_accum_mc14_0 <= spo_mc_mem(59 downto 56);--GTU1
                B_accum_mc15_0 <= spo_mc_mem(63 downto 60);--GTU1
                B_accum_mc16_0 <= spo_mc_mem(67 downto 64);--GTU1
                B_accum_mc17_0 <= spo_mc_mem(71 downto 68);--GTU1
                B_accum_mc18_0 <= spo_mc_mem(75 downto 72);--GTU1
                B_accum_mc19_0 <= spo_mc_mem(79 downto 76);--GTU1
                B_accum_mc20_0 <= spo_mc_mem(83 downto 80);--GTU1
                B_accum_mc21_0 <= spo_mc_mem(87 downto 84);--GTU1
                
                B_accum_mc0_1 <= spo_mc_mem(91 downto 88);--GTU1
                B_accum_mc1_1 <= spo_mc_mem(95 downto 92);--GTU1
                B_accum_mc2_1 <= spo_mc_mem(99 downto 96);--GTU1
                B_accum_mc3_1 <= spo_mc_mem(103 downto 100);--GTU1
                B_accum_mc4_1 <= spo_mc_mem(107 downto 104);--GTU1
                B_accum_mc5_1 <= spo_mc_mem(111 downto 108);--GTU1
                B_accum_mc6_1 <= spo_mc_mem(115 downto 112);--GTU1
                B_accum_mc7_1 <= spo_mc_mem(119 downto 116);--GTU1
                B_accum_mc8_1 <= spo_mc_mem(123 downto 120);--GTU1
                B_accum_mc9_1 <= spo_mc_mem(127 downto 124);--GTU1
                B_accum_mc10_1 <= spo_mc_mem(131 downto 128);--GTU1
                B_accum_mc11_1 <= spo_mc_mem(135 downto 132);--GTU1
                B_accum_mc12_1 <= spo_mc_mem(139 downto 136);--GTU1
                B_accum_mc13_1 <= spo_mc_mem(143 downto 140);--GTU1
                B_accum_mc14_1 <= spo_mc_mem(147 downto 144);--GTU1
                B_accum_mc15_1 <= spo_mc_mem(151 downto 148);--GTU1
                B_accum_mc16_1 <= spo_mc_mem(155 downto 152);--GTU1
                B_accum_mc17_1 <= spo_mc_mem(159 downto 156);--GTU1
                B_accum_mc18_1 <= spo_mc_mem(163 downto 160);--GTU1
                B_accum_mc19_1 <= spo_mc_mem(167 downto 164);--GTU1
                B_accum_mc20_1 <= spo_mc_mem(171 downto 168);--GTU1
                B_accum_mc21_1 <= spo_mc_mem(175 downto 172);--GTU1
                
                B_accum_mc0_2 <= spo_mc_mem(179 downto 176);--GTU1
                B_accum_mc1_2 <= spo_mc_mem(183 downto 180);--GTU1
                B_accum_mc2_2 <= spo_mc_mem(187 downto 184);--GTU1
                B_accum_mc3_2 <= spo_mc_mem(191 downto 188);--GTU1
                B_accum_mc4_2 <= spo_mc_mem(195 downto 192);--GTU1
                B_accum_mc5_2 <= spo_mc_mem(199 downto 196);--GTU1
                B_accum_mc6_2 <= spo_mc_mem(203 downto 200);--GTU1
                B_accum_mc7_2 <= spo_mc_mem(207 downto 204);--GTU1
                B_accum_mc8_2 <= spo_mc_mem(211 downto 208);--GTU1
                B_accum_mc9_2 <= spo_mc_mem(215 downto 212);--GTU1
                B_accum_mc10_2 <= spo_mc_mem(219 downto 216);--GTU1
                B_accum_mc11_2 <= spo_mc_mem(223 downto 220);--GTU1
                B_accum_mc12_2 <= spo_mc_mem(227 downto 224);--GTU1
                B_accum_mc13_2 <= spo_mc_mem(231 downto 228);--GTU1
                B_accum_mc14_2 <= spo_mc_mem(235 downto 232);--GTU1
                B_accum_mc15_2 <= spo_mc_mem(239 downto 236);--GTU1
                B_accum_mc16_2 <= spo_mc_mem(243 downto 240);--GTU1
                B_accum_mc17_2 <= spo_mc_mem(247 downto 244);--GTU1
                B_accum_mc18_2 <= spo_mc_mem(251 downto 248);--GTU1
                B_accum_mc19_2 <= spo_mc_mem(255 downto 252);--GTU1
                B_accum_mc20_2 <= spo_mc_mem(259 downto 256);--GTU1
                B_accum_mc21_2 <= spo_mc_mem(263 downto 260);--GTU1
                
                state_buffer_read <= s2;
            when s2 =>
                B_accum_mc0_0 <= spo_mc_mem(3 downto 0);--GTU2
                B_accum_mc1_0 <= spo_mc_mem(7 downto 4);--GTU2
                B_accum_mc2_0 <= spo_mc_mem(11 downto 8);--GTU2
                B_accum_mc3_0 <= spo_mc_mem(15 downto 12);--GTU2
                B_accum_mc4_0 <= spo_mc_mem(19 downto 16);--GTU2
                B_accum_mc5_0 <= spo_mc_mem(23 downto 20);--GTU2
                B_accum_mc6_0 <= spo_mc_mem(27 downto 24);--GTU2
                B_accum_mc7_0 <= spo_mc_mem(31 downto 28);--GTU2
                B_accum_mc8_0 <= spo_mc_mem(35 downto 32);--GTU2
                B_accum_mc9_0 <= spo_mc_mem(39 downto 36);--GTU2
                B_accum_mc10_0 <= spo_mc_mem(43 downto 40);--GTU2
                B_accum_mc11_0 <= spo_mc_mem(47 downto 44);--GTU2
                B_accum_mc12_0 <= spo_mc_mem(51 downto 48);--GTU2
                B_accum_mc13_0 <= spo_mc_mem(55 downto 52);--GTU2
                B_accum_mc14_0 <= spo_mc_mem(59 downto 56);--GTU2
                B_accum_mc15_0 <= spo_mc_mem(63 downto 60);--GTU2
                B_accum_mc16_0 <= spo_mc_mem(67 downto 64);--GTU2
                B_accum_mc17_0 <= spo_mc_mem(71 downto 68);--GTU2
                B_accum_mc18_0 <= spo_mc_mem(75 downto 72);--GTU2
                B_accum_mc19_0 <= spo_mc_mem(79 downto 76);--GTU2
                B_accum_mc20_0 <= spo_mc_mem(83 downto 80);--GTU2
                B_accum_mc21_0 <= spo_mc_mem(87 downto 84);--GTU2
                
                B_accum_mc0_1 <= spo_mc_mem(91 downto 88);--GTU2
                B_accum_mc1_1 <= spo_mc_mem(95 downto 92);--GTU2
                B_accum_mc2_1 <= spo_mc_mem(99 downto 96);--GTU2
                B_accum_mc3_1 <= spo_mc_mem(103 downto 100);--GTU2
                B_accum_mc4_1 <= spo_mc_mem(107 downto 104);--GTU2
                B_accum_mc5_1 <= spo_mc_mem(111 downto 108);--GTU2
                B_accum_mc6_1 <= spo_mc_mem(115 downto 112);--GTU2
                B_accum_mc7_1 <= spo_mc_mem(119 downto 116);--GTU2
                B_accum_mc8_1 <= spo_mc_mem(123 downto 120);--GTU2
                B_accum_mc9_1 <= spo_mc_mem(127 downto 124);--GTU2
                B_accum_mc10_1 <= spo_mc_mem(131 downto 128);--GTU2
                B_accum_mc11_1 <= spo_mc_mem(135 downto 132);--GTU2
                B_accum_mc12_1 <= spo_mc_mem(139 downto 136);--GTU2
                B_accum_mc13_1 <= spo_mc_mem(143 downto 140);--GTU2
                B_accum_mc14_1 <= spo_mc_mem(147 downto 144);--GTU2
                B_accum_mc15_1 <= spo_mc_mem(151 downto 148);--GTU2
                B_accum_mc16_1 <= spo_mc_mem(155 downto 152);--GTU2
                B_accum_mc17_1 <= spo_mc_mem(159 downto 156);--GTU2
                B_accum_mc18_1 <= spo_mc_mem(163 downto 160);--GTU2
                B_accum_mc19_1 <= spo_mc_mem(167 downto 164);--GTU2
                B_accum_mc20_1 <= spo_mc_mem(171 downto 168);--GTU2
                B_accum_mc21_1 <= spo_mc_mem(175 downto 172);--GTU2
                
                B_accum_mc0_2 <= spo_mc_mem(179 downto 176);--GTU2
                B_accum_mc1_2 <= spo_mc_mem(183 downto 180);--GTU2
                B_accum_mc2_2 <= spo_mc_mem(187 downto 184);--GTU2
                B_accum_mc3_2 <= spo_mc_mem(191 downto 188);--GTU2
                B_accum_mc4_2 <= spo_mc_mem(195 downto 192);--GTU2
                B_accum_mc5_2 <= spo_mc_mem(199 downto 196);--GTU2
                B_accum_mc6_2 <= spo_mc_mem(203 downto 200);--GTU2
                B_accum_mc7_2 <= spo_mc_mem(207 downto 204);--GTU2
                B_accum_mc8_2 <= spo_mc_mem(211 downto 208);--GTU2
                B_accum_mc9_2 <= spo_mc_mem(215 downto 212);--GTU2
                B_accum_mc10_2 <= spo_mc_mem(219 downto 216);--GTU2
                B_accum_mc11_2 <= spo_mc_mem(223 downto 220);--GTU2
                B_accum_mc12_2 <= spo_mc_mem(227 downto 224);--GTU2
                B_accum_mc13_2 <= spo_mc_mem(231 downto 228);--GTU2
                B_accum_mc14_2 <= spo_mc_mem(235 downto 232);--GTU2
                B_accum_mc15_2 <= spo_mc_mem(239 downto 236);--GTU2
                B_accum_mc16_2 <= spo_mc_mem(243 downto 240);--GTU2
                B_accum_mc17_2 <= spo_mc_mem(247 downto 244);--GTU2
                B_accum_mc18_2 <= spo_mc_mem(251 downto 248);--GTU2
                B_accum_mc19_2 <= spo_mc_mem(255 downto 252);--GTU2
                B_accum_mc20_2 <= spo_mc_mem(259 downto 256);--GTU2
                B_accum_mc21_2 <= spo_mc_mem(263 downto 260);--GTU2
                
                state_buffer_read <= s3;
            when s3 =>
                CE_accum <= '0';
                SCLR_accum <= '1';
                bufsum_ready <= '1';
                state_buffer_read <= s0;
        end case;
    end if;
end process;

macrocell_buffer_check : process (CLOCK)--Check if MacroCell sum over 3GTU is >= Nhot
begin 
    if (CLOCK'event and CLOCK = '1') then
        case (state_buffer_check) is
            when s0 =>
                Nhot_l0 <= Nhot;--Save Nhot value (for process delay compensation between 2GTU 0->1)
                Nlenght_l0 <= Nlenght;--Save Nlenght value (for process delay compensation between 2GTU 0->1)
                Nactive_l0 <= Nactive;--Save Nactive value (for process delay compensation between 2GTU 0->1)
                state_buffer_check <= s1;
            when s1 =>
                if (bufsum_ready = '1') then
                    if (Q_accum_mc0_0 >= Nhot_l0) then
                        mc_active_0(0) <= '1';
                    end if;
                    if (Q_accum_mc1_0 >= Nhot_l0) then
                        mc_active_0(1) <= '1';
                    end if;
                    if (Q_accum_mc2_0 >= Nhot_l0) then
                        mc_active_0(2) <= '1';
                    end if;
                    if (Q_accum_mc3_0 >= Nhot_l0) then
                        mc_active_0(3) <= '1';
                    end if;
                    if (Q_accum_mc4_0 >= Nhot_l0) then
                        mc_active_0(4) <= '1';
                    end if;
                    if (Q_accum_mc5_0 >= Nhot_l0) then
                        mc_active_0(5) <= '1';
                    end if;
                    if (Q_accum_mc6_0 >= Nhot_l0) then
                        mc_active_0(6) <= '1';
                    end if;
                    if (Q_accum_mc7_0 >= Nhot_l0) then
                        mc_active_0(7) <= '1';
                    end if;
                    if (Q_accum_mc8_0 >= Nhot_l0) then
                        mc_active_0(8) <= '1';
                    end if;
                    if (Q_accum_mc9_0 >= Nhot_l0) then
                        mc_active_0(9) <= '1';
                    end if;
                    if (Q_accum_mc10_0 >= Nhot_l0) then
                        mc_active_0(10) <= '1';
                    end if;
                    if (Q_accum_mc11_0 >= Nhot_l0) then
                        mc_active_0(11) <= '1';
                    end if;
                    if (Q_accum_mc12_0 >= Nhot_l0) then
                        mc_active_0(12) <= '1';
                    end if;
                    if (Q_accum_mc13_0 >= Nhot_l0) then
                        mc_active_0(13) <= '1';
                    end if;
                    if (Q_accum_mc14_0 >= Nhot_l0) then
                        mc_active_0(14) <= '1';
                    end if;
                    if (Q_accum_mc15_0 >= Nhot_l0) then
                        mc_active_0(15) <= '1';
                    end if;
                    if (Q_accum_mc16_0 >= Nhot_l0) then
                        mc_active_0(16) <= '1';
                    end if;
                    if (Q_accum_mc17_0 >= Nhot_l0) then
                        mc_active_0(17) <= '1';
                    end if;
                    if (Q_accum_mc18_0 >= Nhot_l0) then
                        mc_active_0(18) <= '1';
                    end if;
                    if (Q_accum_mc19_0 >= Nhot_l0) then
                        mc_active_0(19) <= '1';
                    end if;
                    if (Q_accum_mc20_0 >= Nhot_l0) then
                        mc_active_0(20) <= '1';
                    end if;
                    if (Q_accum_mc21_0 >= Nhot_l0) then
                        mc_active_0(21) <= '1';
                    end if;
                    
                    if (Q_accum_mc0_1 >= Nhot_l0) then
                        mc_active_1(0) <= '1';
                    end if;
                    if (Q_accum_mc1_1 >= Nhot_l0) then
                        mc_active_1(1) <= '1';
                    end if;
                    if (Q_accum_mc2_1 >= Nhot_l0) then
                        mc_active_1(2) <= '1';
                    end if;
                    if (Q_accum_mc3_1 >= Nhot_l0) then
                        mc_active_1(3) <= '1';
                    end if;
                    if (Q_accum_mc4_1 >= Nhot_l0) then
                        mc_active_1(4) <= '1';
                    end if;
                    if (Q_accum_mc5_1 >= Nhot_l0) then
                        mc_active_1(5) <= '1';
                    end if;
                    if (Q_accum_mc6_1 >= Nhot_l0) then
                        mc_active_1(6) <= '1';
                    end if;
                    if (Q_accum_mc7_1 >= Nhot_l0) then
                        mc_active_1(7) <= '1';
                    end if;
                    if (Q_accum_mc8_1 >= Nhot_l0) then
                        mc_active_1(8) <= '1';
                    end if;
                    if (Q_accum_mc9_1 >= Nhot_l0) then
                        mc_active_1(9) <= '1';
                    end if;
                    if (Q_accum_mc10_1 >= Nhot_l0) then
                        mc_active_1(10) <= '1';
                    end if;
                    if (Q_accum_mc11_1 >= Nhot_l0) then
                        mc_active_1(11) <= '1';
                    end if;
                    if (Q_accum_mc12_1 >= Nhot_l0) then
                        mc_active_1(12) <= '1';
                    end if;
                    if (Q_accum_mc13_1 >= Nhot_l0) then
                        mc_active_1(13) <= '1';
                    end if;
                    if (Q_accum_mc14_1 >= Nhot_l0) then
                        mc_active_1(14) <= '1';
                    end if;
                    if (Q_accum_mc15_1 >= Nhot_l0) then
                        mc_active_1(15) <= '1';
                    end if;
                    if (Q_accum_mc16_1 >= Nhot_l0) then
                        mc_active_1(16) <= '1';
                    end if;
                    if (Q_accum_mc17_1 >= Nhot_l0) then
                        mc_active_1(17) <= '1';
                    end if;
                    if (Q_accum_mc18_1 >= Nhot_l0) then
                        mc_active_1(18) <= '1';
                    end if;
                    if (Q_accum_mc19_1 >= Nhot_l0) then
                        mc_active_1(19) <= '1';
                    end if;
                    if (Q_accum_mc20_1 >= Nhot_l0) then
                        mc_active_1(20) <= '1';
                    end if;
                    if (Q_accum_mc21_1 >= Nhot_l0) then
                        mc_active_1(21) <= '1';
                    end if;
                    
                    if (Q_accum_mc0_2 >= Nhot_l0) then
                        mc_active_2(0) <= '1';
                    end if;
                    if (Q_accum_mc1_2 >= Nhot_l0) then
                        mc_active_2(1) <= '1';
                    end if;
                    if (Q_accum_mc2_2 >= Nhot_l0) then
                        mc_active_2(2) <= '1';
                    end if;
                    if (Q_accum_mc3_2 >= Nhot_l0) then
                        mc_active_2(3) <= '1';
                    end if;
                    if (Q_accum_mc4_2 >= Nhot_l0) then
                        mc_active_2(4) <= '1';
                    end if;
                    if (Q_accum_mc5_2 >= Nhot_l0) then
                        mc_active_2(5) <= '1';
                    end if;
                    if (Q_accum_mc6_2 >= Nhot_l0) then
                        mc_active_2(6) <= '1';
                    end if;
                    if (Q_accum_mc7_2 >= Nhot_l0) then
                        mc_active_2(7) <= '1';
                    end if;
                    if (Q_accum_mc8_2 >= Nhot_l0) then
                        mc_active_2(8) <= '1';
                    end if;
                    if (Q_accum_mc9_2 >= Nhot_l0) then
                        mc_active_2(9) <= '1';
                    end if;
                    if (Q_accum_mc10_2 >= Nhot_l0) then
                        mc_active_2(10) <= '1';
                    end if;
                    if (Q_accum_mc11_2 >= Nhot_l0) then
                        mc_active_2(11) <= '1';
                    end if;
                    if (Q_accum_mc12_2 >= Nhot_l0) then
                        mc_active_2(12) <= '1';
                    end if;
                    if (Q_accum_mc13_2 >= Nhot_l0) then
                        mc_active_2(13) <= '1';
                    end if;
                    if (Q_accum_mc14_2 >= Nhot_l0) then
                        mc_active_2(14) <= '1';
                    end if;
                    if (Q_accum_mc15_2 >= Nhot_l0) then
                        mc_active_2(15) <= '1';
                    end if;
                    if (Q_accum_mc16_2 >= Nhot_l0) then
                        mc_active_2(16) <= '1';
                    end if;
                    if (Q_accum_mc17_2 >= Nhot_l0) then
                        mc_active_2(17) <= '1';
                    end if;
                    if (Q_accum_mc18_2 >= Nhot_l0) then
                        mc_active_2(18) <= '1';
                    end if;
                    if (Q_accum_mc19_2 >= Nhot_l0) then
                        mc_active_2(19) <= '1';
                    end if;
                    if (Q_accum_mc20_2 >= Nhot_l0) then
                        mc_active_2(20) <= '1';
                    end if;
                    if (Q_accum_mc21_2 >= Nhot_l0) then
                        mc_active_2(21) <= '1';
                    end if;
                    mc_active_ready <= '1';
                    state_buffer_check <= s2;
                end if;
            when s2 =>
                if (bufsum_ready_cnt = "111") then--Last column
                    state_buffer_check <= s0;--update nHot-nLenght
                    bufsum_ready_cnt <= "000";
                else
                    state_buffer_check <= s1;--NO nHot-nLenght update
                    bufsum_ready_cnt <= bufsum_ready_cnt + 1;
                end if;
                mc_active_ready <= '0';
                mc_active_0 <= ( others => '0');
                mc_active_1 <= ( others => '0');
                mc_active_2 <= ( others => '0');
        end case;
    end if;
end process;

mc_active_bitcounter : process (clock)--Sum Active MacroCell over 3GTU
begin 
    if (clock'event and clock = '1') then
        case (state_bitcounter) is
            when s0 =>
                if (mc_active_ready = '1') then
                    B_mc_active <= bitcount(mc_active_0);--Function bit-count in vector
                    mc_active_1b <= mc_active_1;--Signal copy
                    mc_active_2b <= mc_active_2;--Signal_copy
                    CE_mc_active <= '1';--Enable 3GTU SUM
                    state_bitcounter <= s1;
                end if;
                if (mc_active_col_count = "000") then
                    frame_cnt_l0 <= frame_cnt;--frame_cnt delay propagation
                    nActive_l1 <= nActive_l0;--nActive delay propagation
                end if;
                mc_active_sum_ready <= '0';
                SCLR_mc_active <= '0';
            when s1 =>
                if (mc_active_col_count = "111") then--Last group of 3 columns (there is only the MacroCell #21)
                    CE_mc_active <= '0';--Disable SUM for the columns 1,2
                    mc_active_sum_ready <= '1';--SUM Ready
                    frame_cnt_l1 <= frame_cnt_l0;--frame_cnt delay propagation
                    SCLR_mc_active <= '1';
                    mc_active_col_count <= "000";
                    state_bitcounter <= s0;
                else
                    B_mc_active <= bitcount(mc_active_1b);--Function bit-count in vector
                    state_bitcounter <= s2;
                end if;
            when s2 =>
                B_mc_active <= bitcount(mc_active_2b);--Function bit-count in vector
                state_bitcounter <= s3;
            when s3 =>
                CE_mc_active <= '0';
                mc_active_col_count <= mc_active_col_count + 1;
                state_bitcounter <= s0;
        end case;
    end if;
end process;

nLenght_buffer_ReadWrite : process (clock)--Sum ActiveMacrocell buffer
begin 
    if (clock'event and clock = '1') then
        case (state_nl_buffer) is
            when s0 =>
                if (mc_active_sum_ready = '1') then--GTU active macrocell sum is ready
                    a_nl_buffer <= a_nl_buffer_write;
                    if (a_nl_buffer_write = nLenght_l0) then
                        a_nl_buffer_write <= "00000";
                    else
                        a_nl_buffer_write <= a_nl_buffer_write + 1;
                    end if;
                    d_nl_buffer <= Q_mc_active;
                    we_nl_buffer <= '1';--Write buffer
                    
                    nActive_l2 <= nActive_l1;--nActive delay propagation
                    
                    state_nl_buffer <= s1;
                end if;
            when s1 =>
                we_nl_buffer <= '0';
                a_nl_buffer <= a_nl_buffer_read;--Read buffer
                nl_buffer_ready <= '1';--ENABLE buffer read
                state_nl_buffer <= s2;
            when s2 =>
                nl_buffer_ready <= '0';
                if (a_nl_buffer_read = nLenght_l0) then
                    a_nl_buffer_read <= "00000";
                    state_nl_buffer <= s0;
                else
                    a_nl_buffer_read <= a_nl_buffer_read + 1;
                    state_nl_buffer <= s1;
                end if;
        end case;
    end if;
end process;

nLenght_memory_buffer_SUM : process (clock)--Sum ActiveMacrocell buffer
begin 
    if (clock'event and clock = '1') then
        case (state_nl_buffer_sum) is
            when s0 =>
                if (nl_buffer_ready = '1') then
                    CE_nl_buffer_sum <= '1';
                    B_nl_buffer_sum <= spo_nl_buffer;
                    state_nl_buffer_sum <= s1;
                end if;
                SCLR_nl_buffer_sum <= '0';
            when s1 =>
                CE_nl_buffer_sum <= '0';
                if (counter_nlpos = nLenght_l0) then
                    counter_nlpos <= "00000";
                    nl_buffer_sum_ready <= '1';--Now SUM is ready
                    state_nl_buffer_sum <= s2;
                else
                    counter_nlpos <= counter_nlpos + 1;
                    state_nl_buffer_sum <= s0;
                end if;
            when s2 =>
                nl_buffer_sum_ready <= '0';
                SCLR_nl_buffer_sum <= '1';
                state_nl_buffer_sum <= s0;
        end case;
    end if;
end process;

trigger_check : process (clock)--Check if active-macrocell buffer SUM >= nActive
begin 
    if (clock'event and clock = '1') then
        if (nl_buffer_sum_ready = '1') then
            if (Q_nl_buffer_sum >= "000" & nActive_l2) then --TRIGGER EVENT
                s_axis_tlast_trg <= '1';--Mark Special PACKET as TRIGGER WORD
            end if;
            s_axis_tdata_trg(8 downto 0) <= d_nl_buffer;--WRITE ACTIVE MacroCell in the GTU
            s_axis_tdata_trg(27 downto 9) <= frame_cnt_l1;--WRITE GTU number
            s_axis_tvalid_trg <= '1';
        else
            s_axis_tvalid_trg <= '0';
            s_axis_tlast_trg <= '0';
        end if;
    end if;
end process;
                        
end generate;          
                    
end Behavioral;
