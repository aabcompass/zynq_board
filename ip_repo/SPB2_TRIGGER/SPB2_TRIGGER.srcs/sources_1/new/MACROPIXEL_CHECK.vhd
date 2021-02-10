----------------------------------------------------------------------------------
-- Company: INFN Torino
-- Engineer: M.Mignone
-- 
-- Create Date: 08/20/2020 10:28:09 AM
-- Design Name: SPB2 TRIGGER
-- Module Name: MACROPIXEL_CHECK - MACROPIXEL_CHECK
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

entity MACROPIXEL_CHECK is
    Port ( clock : in STD_LOGIC;
           ------------------STHR DEBUG---------------------------
--           sthr_debug : out STD_LOGIC_VECTOR (263 downto 0);
--           sthr_ready_debug : out STD_LOGIC := '0';
           -------------------------------------------------------
           nSigma128 : in STD_LOGIC_VECTOR (9 downto 0);
           mp0 : in STD_LOGIC_VECTOR (9 downto 0);
           mp1 : in STD_LOGIC_VECTOR (9 downto 0);
           mp2 : in STD_LOGIC_VECTOR (9 downto 0);
           mp3 : in STD_LOGIC_VECTOR (9 downto 0);
           mp4 : in STD_LOGIC_VECTOR (9 downto 0);
           mp5 : in STD_LOGIC_VECTOR (9 downto 0);
           mp6 : in STD_LOGIC_VECTOR (9 downto 0);
           mp7 : in STD_LOGIC_VECTOR (9 downto 0);
           mp8 : in STD_LOGIC_VECTOR (9 downto 0);
           mp9 : in STD_LOGIC_VECTOR (9 downto 0);
           mp10 : in STD_LOGIC_VECTOR (9 downto 0);
           mp11 : in STD_LOGIC_VECTOR (9 downto 0);
           mp12 : in STD_LOGIC_VECTOR (9 downto 0);
           mp13 : in STD_LOGIC_VECTOR (9 downto 0);
           mp14 : in STD_LOGIC_VECTOR (9 downto 0);
           mp15 : in STD_LOGIC_VECTOR (9 downto 0);
           mp16 : in STD_LOGIC_VECTOR (9 downto 0);
           mp17 : in STD_LOGIC_VECTOR (9 downto 0);
           mp18 : in STD_LOGIC_VECTOR (9 downto 0);
           mp19 : in STD_LOGIC_VECTOR (9 downto 0);
           mp20 : in STD_LOGIC_VECTOR (9 downto 0);
           mp21 : in STD_LOGIC_VECTOR (9 downto 0);
           mp22 : in STD_LOGIC_VECTOR (9 downto 0);
           mp23 : in STD_LOGIC_VECTOR (9 downto 0);
           mp_ready : in STD_LOGIC;
           mpsum0 : in  std_logic_vector (23 downto 0);
           mpsum1 : in  std_logic_vector (23 downto 0);
           mpsum2 : in  std_logic_vector (23 downto 0);
           mpsum3 : in  std_logic_vector (23 downto 0);
           mpsum4 : in  std_logic_vector (23 downto 0);
           mpsum5 : in  std_logic_vector (23 downto 0);
           mpsum6 : in  std_logic_vector (23 downto 0);
           mpsum7 : in  std_logic_vector (23 downto 0);
           mpsum8 : in  std_logic_vector (23 downto 0);
           mpsum9 : in  std_logic_vector (23 downto 0);
           mpsum10 : in  std_logic_vector (23 downto 0);
           mpsum11 : in  std_logic_vector (23 downto 0);
           mpsum12 : in  std_logic_vector (23 downto 0);
           mpsum13 : in  std_logic_vector (23 downto 0);
           mpsum14 : in  std_logic_vector (23 downto 0);
           mpsum15 : in  std_logic_vector (23 downto 0);
           mpsum16 : in  std_logic_vector (23 downto 0);
           mpsum17 : in  std_logic_vector (23 downto 0);
           mpsum18 : in  std_logic_vector (23 downto 0);
           mpsum19 : in  std_logic_vector (23 downto 0);
           mpsum20 : in  std_logic_vector (23 downto 0);
           mpsum21 : in  std_logic_vector (23 downto 0);
           mpsum22 : in  std_logic_vector (23 downto 0);
           mpsum23 : in  std_logic_vector (23 downto 0);
           mpsum_ready : in  std_logic;
           bmp_c     : out STD_LOGIC_VECTOR (23 downto 0) := ( others => '0');--Binary-Macropixel Column
           bmp_ready : out STD_LOGIC := '0';
           MPSthr    : in  std_logic_vector(15 downto 0)
           );
end MACROPIXEL_CHECK;

architecture MACROPIXEL_CHECK of MACROPIXEL_CHECK is

SIGNAL  mem_addr    :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  mem_in      :   std_logic_vector(263 downto 0) := ( others => '0');
SIGNAL  mem_we      :   std_logic := '0';
SIGNAL  mem_out     :   std_logic_vector(263 downto 0) := ( others => '0');

SIGNAL  addr_read   :   std_logic_vector(3 downto 0) := ( others => '0');
SIGNAL  addr_write  :   std_logic_vector(3 downto 0) := "1000";

SIGNAL  s_axis_cartesian_tvalid         :   std_logic := '0';
SIGNAL  s_axis_cartesian_tdata_mpsum0   :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  m_axis_dout_tvalid_mpsum0       :   std_logic;
SIGNAL  m_axis_dout_tdata_mpsum0        :   std_logic_vector(15 downto 0);
SIGNAL  s_axis_cartesian_tdata_mpsum1   :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  m_axis_dout_tvalid_mpsum1       :   std_logic;
SIGNAL  m_axis_dout_tdata_mpsum1        :   std_logic_vector(15 downto 0);
SIGNAL  s_axis_cartesian_tdata_mpsum2   :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  m_axis_dout_tvalid_mpsum2       :   std_logic;
SIGNAL  m_axis_dout_tdata_mpsum2        :   std_logic_vector(15 downto 0);
SIGNAL  s_axis_cartesian_tdata_mpsum3   :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  m_axis_dout_tvalid_mpsum3       :   std_logic;
SIGNAL  m_axis_dout_tdata_mpsum3        :   std_logic_vector(15 downto 0);
SIGNAL  s_axis_cartesian_tdata_mpsum4   :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  m_axis_dout_tvalid_mpsum4       :   std_logic;
SIGNAL  m_axis_dout_tdata_mpsum4        :   std_logic_vector(15 downto 0);
SIGNAL  s_axis_cartesian_tdata_mpsum5   :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  m_axis_dout_tvalid_mpsum5       :   std_logic;
SIGNAL  m_axis_dout_tdata_mpsum5        :   std_logic_vector(15 downto 0);
SIGNAL  s_axis_cartesian_tdata_mpsum6   :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  m_axis_dout_tvalid_mpsum6       :   std_logic;
SIGNAL  m_axis_dout_tdata_mpsum6        :   std_logic_vector(15 downto 0);
SIGNAL  s_axis_cartesian_tdata_mpsum7   :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  m_axis_dout_tvalid_mpsum7       :   std_logic;
SIGNAL  m_axis_dout_tdata_mpsum7        :   std_logic_vector(15 downto 0);
SIGNAL  s_axis_cartesian_tdata_mpsum8   :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  m_axis_dout_tvalid_mpsum8       :   std_logic;
SIGNAL  m_axis_dout_tdata_mpsum8        :   std_logic_vector(15 downto 0);
SIGNAL  s_axis_cartesian_tdata_mpsum9   :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  m_axis_dout_tvalid_mpsum9       :   std_logic;
SIGNAL  m_axis_dout_tdata_mpsum9        :   std_logic_vector(15 downto 0);
SIGNAL  s_axis_cartesian_tdata_mpsum10   :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  m_axis_dout_tvalid_mpsum10       :   std_logic;
SIGNAL  m_axis_dout_tdata_mpsum10        :   std_logic_vector(15 downto 0);
SIGNAL  s_axis_cartesian_tdata_mpsum11   :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  m_axis_dout_tvalid_mpsum11       :   std_logic;
SIGNAL  m_axis_dout_tdata_mpsum11        :   std_logic_vector(15 downto 0);
SIGNAL  s_axis_cartesian_tdata_mpsum12   :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  m_axis_dout_tvalid_mpsum12       :   std_logic;
SIGNAL  m_axis_dout_tdata_mpsum12        :   std_logic_vector(15 downto 0);
SIGNAL  s_axis_cartesian_tdata_mpsum13   :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  m_axis_dout_tvalid_mpsum13       :   std_logic;
SIGNAL  m_axis_dout_tdata_mpsum13        :   std_logic_vector(15 downto 0);
SIGNAL  s_axis_cartesian_tdata_mpsum14   :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  m_axis_dout_tvalid_mpsum14       :   std_logic;
SIGNAL  m_axis_dout_tdata_mpsum14        :   std_logic_vector(15 downto 0);
SIGNAL  s_axis_cartesian_tdata_mpsum15   :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  m_axis_dout_tvalid_mpsum15       :   std_logic;
SIGNAL  m_axis_dout_tdata_mpsum15        :   std_logic_vector(15 downto 0);
SIGNAL  s_axis_cartesian_tdata_mpsum16   :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  m_axis_dout_tvalid_mpsum16       :   std_logic;
SIGNAL  m_axis_dout_tdata_mpsum16        :   std_logic_vector(15 downto 0);
SIGNAL  s_axis_cartesian_tdata_mpsum17   :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  m_axis_dout_tvalid_mpsum17       :   std_logic;
SIGNAL  m_axis_dout_tdata_mpsum17        :   std_logic_vector(15 downto 0);
SIGNAL  s_axis_cartesian_tdata_mpsum18   :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  m_axis_dout_tvalid_mpsum18       :   std_logic;
SIGNAL  m_axis_dout_tdata_mpsum18        :   std_logic_vector(15 downto 0);
SIGNAL  s_axis_cartesian_tdata_mpsum19   :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  m_axis_dout_tvalid_mpsum19       :   std_logic;
SIGNAL  m_axis_dout_tdata_mpsum19        :   std_logic_vector(15 downto 0);
SIGNAL  s_axis_cartesian_tdata_mpsum20   :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  m_axis_dout_tvalid_mpsum20       :   std_logic;
SIGNAL  m_axis_dout_tdata_mpsum20        :   std_logic_vector(15 downto 0);
SIGNAL  s_axis_cartesian_tdata_mpsum21   :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  m_axis_dout_tvalid_mpsum21       :   std_logic;
SIGNAL  m_axis_dout_tdata_mpsum21        :   std_logic_vector(15 downto 0);
SIGNAL  s_axis_cartesian_tdata_mpsum22   :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  m_axis_dout_tvalid_mpsum22       :   std_logic;
SIGNAL  m_axis_dout_tdata_mpsum22        :   std_logic_vector(15 downto 0);
SIGNAL  s_axis_cartesian_tdata_mpsum23   :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  m_axis_dout_tvalid_mpsum23       :   std_logic;
SIGNAL  m_axis_dout_tdata_mpsum23        :   std_logic_vector(15 downto 0);

SIGNAL  srst_fifo_mpsum     :   std_logic := '0';
SIGNAL  din_fifo_mpsum      :   std_logic_vector(575 downto 0) := ( others => '0');
SIGNAL  wr_en_fifo_mpsum    :   std_logic := '0';
SIGNAL  rd_en_fifo_mpsum    :   std_logic := '0';
SIGNAL  dout_fifo_mpsum     :   std_logic_vector(575 downto 0) := ( others => '0');
SIGNAL  full_fifo_mpsum     :   std_logic := '0';
SIGNAL  empty_fifo_mpsum    :   std_logic := '0';

SIGNAL  CE_multadd  :   std_logic := '0';
SIGNAL  SCLR_multadd:   std_logic := '0';
SIGNAL  A_multadd0  :   std_logic_vector(9 downto 0) := ( others => '0');
SIGNAL  B_multadd0  :   std_logic_vector(11 downto 0) := ( others => '0');
SIGNAL  C_multadd0  :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  P_multadd0  :   std_logic_vector(24 downto 0) := ( others => '0');
SIGNAL  A_multadd1  :   std_logic_vector(9 downto 0) := ( others => '0');
SIGNAL  B_multadd1  :   std_logic_vector(11 downto 0) := ( others => '0');
SIGNAL  C_multadd1  :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  P_multadd1  :   std_logic_vector(24 downto 0) := ( others => '0');
SIGNAL  A_multadd2  :   std_logic_vector(9 downto 0) := ( others => '0');
SIGNAL  B_multadd2  :   std_logic_vector(11 downto 0) := ( others => '0');
SIGNAL  C_multadd2  :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  P_multadd2  :   std_logic_vector(24 downto 0) := ( others => '0');
SIGNAL  A_multadd3  :   std_logic_vector(9 downto 0) := ( others => '0');
SIGNAL  B_multadd3  :   std_logic_vector(11 downto 0) := ( others => '0');
SIGNAL  C_multadd3  :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  P_multadd3  :   std_logic_vector(24 downto 0) := ( others => '0');
SIGNAL  A_multadd4  :   std_logic_vector(9 downto 0) := ( others => '0');
SIGNAL  B_multadd4  :   std_logic_vector(11 downto 0) := ( others => '0');
SIGNAL  C_multadd4  :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  P_multadd4  :   std_logic_vector(24 downto 0) := ( others => '0');
SIGNAL  A_multadd5  :   std_logic_vector(9 downto 0) := ( others => '0');
SIGNAL  B_multadd5  :   std_logic_vector(11 downto 0) := ( others => '0');
SIGNAL  C_multadd5  :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  P_multadd5  :   std_logic_vector(24 downto 0) := ( others => '0');
SIGNAL  A_multadd6  :   std_logic_vector(9 downto 0) := ( others => '0');
SIGNAL  B_multadd6  :   std_logic_vector(11 downto 0) := ( others => '0');
SIGNAL  C_multadd6  :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  P_multadd6  :   std_logic_vector(24 downto 0) := ( others => '0');
SIGNAL  A_multadd7  :   std_logic_vector(9 downto 0) := ( others => '0');
SIGNAL  B_multadd7  :   std_logic_vector(11 downto 0) := ( others => '0');
SIGNAL  C_multadd7  :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  P_multadd7  :   std_logic_vector(24 downto 0) := ( others => '0');
SIGNAL  A_multadd8  :   std_logic_vector(9 downto 0) := ( others => '0');
SIGNAL  B_multadd8  :   std_logic_vector(11 downto 0) := ( others => '0');
SIGNAL  C_multadd8  :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  P_multadd8  :   std_logic_vector(24 downto 0) := ( others => '0');
SIGNAL  A_multadd9  :   std_logic_vector(9 downto 0) := ( others => '0');
SIGNAL  B_multadd9  :   std_logic_vector(11 downto 0) := ( others => '0');
SIGNAL  C_multadd9  :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  P_multadd9  :   std_logic_vector(24 downto 0) := ( others => '0');
SIGNAL  A_multadd10  :   std_logic_vector(9 downto 0) := ( others => '0');
SIGNAL  B_multadd10  :   std_logic_vector(11 downto 0) := ( others => '0');
SIGNAL  C_multadd10  :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  P_multadd10  :   std_logic_vector(24 downto 0) := ( others => '0');
SIGNAL  A_multadd11  :   std_logic_vector(9 downto 0) := ( others => '0');
SIGNAL  B_multadd11  :   std_logic_vector(11 downto 0) := ( others => '0');
SIGNAL  C_multadd11  :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  P_multadd11  :   std_logic_vector(24 downto 0) := ( others => '0');
SIGNAL  A_multadd12  :   std_logic_vector(9 downto 0) := ( others => '0');
SIGNAL  B_multadd12  :   std_logic_vector(11 downto 0) := ( others => '0');
SIGNAL  C_multadd12  :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  P_multadd12  :   std_logic_vector(24 downto 0) := ( others => '0');
SIGNAL  A_multadd13  :   std_logic_vector(9 downto 0) := ( others => '0');
SIGNAL  B_multadd13  :   std_logic_vector(11 downto 0) := ( others => '0');
SIGNAL  C_multadd13  :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  P_multadd13  :   std_logic_vector(24 downto 0) := ( others => '0');
SIGNAL  A_multadd14  :   std_logic_vector(9 downto 0) := ( others => '0');
SIGNAL  B_multadd14  :   std_logic_vector(11 downto 0) := ( others => '0');
SIGNAL  C_multadd14  :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  P_multadd14  :   std_logic_vector(24 downto 0) := ( others => '0');
SIGNAL  A_multadd15  :   std_logic_vector(9 downto 0) := ( others => '0');
SIGNAL  B_multadd15  :   std_logic_vector(11 downto 0) := ( others => '0');
SIGNAL  C_multadd15  :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  P_multadd15  :   std_logic_vector(24 downto 0) := ( others => '0');
SIGNAL  A_multadd16  :   std_logic_vector(9 downto 0) := ( others => '0');
SIGNAL  B_multadd16  :   std_logic_vector(11 downto 0) := ( others => '0');
SIGNAL  C_multadd16  :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  P_multadd16  :   std_logic_vector(24 downto 0) := ( others => '0');
SIGNAL  A_multadd17 :   std_logic_vector(9 downto 0) := ( others => '0');
SIGNAL  B_multadd17  :   std_logic_vector(11 downto 0) := ( others => '0');
SIGNAL  C_multadd17  :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  P_multadd17  :   std_logic_vector(24 downto 0) := ( others => '0');
SIGNAL  A_multadd18  :   std_logic_vector(9 downto 0) := ( others => '0');
SIGNAL  B_multadd18  :   std_logic_vector(11 downto 0) := ( others => '0');
SIGNAL  C_multadd18  :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  P_multadd18  :   std_logic_vector(24 downto 0) := ( others => '0');
SIGNAL  A_multadd19  :   std_logic_vector(9 downto 0) := ( others => '0');
SIGNAL  B_multadd19  :   std_logic_vector(11 downto 0) := ( others => '0');
SIGNAL  C_multadd19  :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  P_multadd19  :   std_logic_vector(24 downto 0) := ( others => '0');
SIGNAL  A_multadd20  :   std_logic_vector(9 downto 0) := ( others => '0');
SIGNAL  B_multadd20  :   std_logic_vector(11 downto 0) := ( others => '0');
SIGNAL  C_multadd20  :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  P_multadd20  :   std_logic_vector(24 downto 0) := ( others => '0');
SIGNAL  A_multadd21  :   std_logic_vector(9 downto 0) := ( others => '0');
SIGNAL  B_multadd21  :   std_logic_vector(11 downto 0) := ( others => '0');
SIGNAL  C_multadd21  :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  P_multadd21  :   std_logic_vector(24 downto 0) := ( others => '0');
SIGNAL  A_multadd22  :   std_logic_vector(9 downto 0) := ( others => '0');
SIGNAL  B_multadd22  :   std_logic_vector(11 downto 0) := ( others => '0');
SIGNAL  C_multadd22  :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  P_multadd22  :   std_logic_vector(24 downto 0) := ( others => '0');
SIGNAL  A_multadd23  :   std_logic_vector(9 downto 0) := ( others => '0');
SIGNAL  B_multadd23  :   std_logic_vector(11 downto 0) := ( others => '0');
SIGNAL  C_multadd23  :   std_logic_vector(23 downto 0) := ( others => '0');
SIGNAL  P_multadd23  :   std_logic_vector(24 downto 0) := ( others => '0');

SIGNAL  multadd_ready   :   std_logic := '0';
SIGNAL  addr_read_ready :   std_logic := '0';
SIGNAL  addr_write_ready:   std_logic := '0';
SIGNAL  write_en        :   std_logic := '0';

TYPE    state_mp_check_type is  (s0,s1);
SIGNAL  state_mp_check  :   state_mp_check_type := s0;

TYPE    state_sthr_calc_type is  (s0,s1,s2,s3,s4,s5,s6,s7,s8);
SIGNAL  state_sthr_calc  :   state_sthr_calc_type := s0;

TYPE    state_addr_mem_type is  (s0,s1,s2);
SIGNAL  state_addr_mem  :   state_addr_mem_type := s0;

COMPONENT STHR_MEMORY
  PORT (
    a : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    d : IN STD_LOGIC_VECTOR(263 DOWNTO 0);
    clk : IN STD_LOGIC;
    we : IN STD_LOGIC;
    spo : OUT STD_LOGIC_VECTOR(263 DOWNTO 0)
  );
END COMPONENT;

COMPONENT fifo_sum_576x16
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

COMPONENT cordic_sqrt24
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_cartesian_tvalid : IN STD_LOGIC;
    s_axis_cartesian_tdata : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    m_axis_dout_tvalid : OUT STD_LOGIC;
    m_axis_dout_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END COMPONENT;

COMPONENT multadd_10a12b24c
  PORT (
    CLK : IN STD_LOGIC;
    CE : IN STD_LOGIC;
    SCLR : IN STD_LOGIC;
    A : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    B : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    C : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    SUBTRACT : IN STD_LOGIC;
    P : OUT STD_LOGIC_VECTOR(24 DOWNTO 0);
    PCOUT : OUT STD_LOGIC_VECTOR(47 DOWNTO 0)
  );
END COMPONENT;

begin

STHR_MATRIX : STHR_MEMORY
port map(
    a =>   mem_addr,
    d =>   mem_in,
    clk => clock,
    we  => mem_we,
    spo => mem_out
);

FIFO_MPSUM : fifo_sum_576x16
PORT MAP (
    clk => clock,
    srst => srst_fifo_mpsum,
    din => din_fifo_mpsum,
    wr_en => wr_en_fifo_mpsum,
    rd_en => rd_en_fifo_mpsum,
    dout => dout_fifo_mpsum,
    full => full_fifo_mpsum,
    empty => empty_fifo_mpsum
);

sqrt_mpsum0 : cordic_sqrt24
  PORT MAP (
    aclk => clock,
    s_axis_cartesian_tvalid => s_axis_cartesian_tvalid,
    s_axis_cartesian_tdata => s_axis_cartesian_tdata_mpsum0,
    m_axis_dout_tvalid => m_axis_dout_tvalid_mpsum0,
    m_axis_dout_tdata => m_axis_dout_tdata_mpsum0
  );
sqrt_mpsum1 : cordic_sqrt24
    PORT MAP (
      aclk => clock,
      s_axis_cartesian_tvalid => s_axis_cartesian_tvalid,
      s_axis_cartesian_tdata => s_axis_cartesian_tdata_mpsum1,
      m_axis_dout_tvalid => m_axis_dout_tvalid_mpsum1,
      m_axis_dout_tdata => m_axis_dout_tdata_mpsum1
    );
sqrt_mpsum2 : cordic_sqrt24
  PORT MAP (
    aclk => clock,
    s_axis_cartesian_tvalid => s_axis_cartesian_tvalid,
    s_axis_cartesian_tdata => s_axis_cartesian_tdata_mpsum2,
    m_axis_dout_tvalid => m_axis_dout_tvalid_mpsum2,
    m_axis_dout_tdata => m_axis_dout_tdata_mpsum2
  );
sqrt_mpsum3 : cordic_sqrt24
    PORT MAP (
      aclk => clock,
      s_axis_cartesian_tvalid => s_axis_cartesian_tvalid,
      s_axis_cartesian_tdata => s_axis_cartesian_tdata_mpsum3,
      m_axis_dout_tvalid => m_axis_dout_tvalid_mpsum3,
      m_axis_dout_tdata => m_axis_dout_tdata_mpsum3
    );
sqrt_mpsum4 : cordic_sqrt24
  PORT MAP (
    aclk => clock,
    s_axis_cartesian_tvalid => s_axis_cartesian_tvalid,
    s_axis_cartesian_tdata => s_axis_cartesian_tdata_mpsum4,
    m_axis_dout_tvalid => m_axis_dout_tvalid_mpsum4,
    m_axis_dout_tdata => m_axis_dout_tdata_mpsum4
  );
sqrt_mpsum5 : cordic_sqrt24
PORT MAP (
  aclk => clock,
  s_axis_cartesian_tvalid => s_axis_cartesian_tvalid,
  s_axis_cartesian_tdata => s_axis_cartesian_tdata_mpsum5,
  m_axis_dout_tvalid => m_axis_dout_tvalid_mpsum5,
  m_axis_dout_tdata => m_axis_dout_tdata_mpsum5
);
sqrt_mpsum6 : cordic_sqrt24
PORT MAP (
  aclk => clock,
  s_axis_cartesian_tvalid => s_axis_cartesian_tvalid,
  s_axis_cartesian_tdata => s_axis_cartesian_tdata_mpsum6,
  m_axis_dout_tvalid => m_axis_dout_tvalid_mpsum6,
  m_axis_dout_tdata => m_axis_dout_tdata_mpsum6
);
sqrt_mpsum7 : cordic_sqrt24
PORT MAP (
  aclk => clock,
  s_axis_cartesian_tvalid => s_axis_cartesian_tvalid,
  s_axis_cartesian_tdata => s_axis_cartesian_tdata_mpsum7,
  m_axis_dout_tvalid => m_axis_dout_tvalid_mpsum7,
  m_axis_dout_tdata => m_axis_dout_tdata_mpsum7
);
sqrt_mpsum8 : cordic_sqrt24
PORT MAP (
  aclk => clock,
  s_axis_cartesian_tvalid => s_axis_cartesian_tvalid,
  s_axis_cartesian_tdata => s_axis_cartesian_tdata_mpsum8,
  m_axis_dout_tvalid => m_axis_dout_tvalid_mpsum8,
  m_axis_dout_tdata => m_axis_dout_tdata_mpsum8
);
sqrt_mpsum9 : cordic_sqrt24
PORT MAP (
  aclk => clock,
  s_axis_cartesian_tvalid => s_axis_cartesian_tvalid,
  s_axis_cartesian_tdata => s_axis_cartesian_tdata_mpsum9,
  m_axis_dout_tvalid => m_axis_dout_tvalid_mpsum9,
  m_axis_dout_tdata => m_axis_dout_tdata_mpsum9
);
sqrt_mpsum10 : cordic_sqrt24
PORT MAP (
  aclk => clock,
  s_axis_cartesian_tvalid => s_axis_cartesian_tvalid,
  s_axis_cartesian_tdata => s_axis_cartesian_tdata_mpsum10,
  m_axis_dout_tvalid => m_axis_dout_tvalid_mpsum10,
  m_axis_dout_tdata => m_axis_dout_tdata_mpsum10
);
sqrt_mpsum11 : cordic_sqrt24
PORT MAP (
  aclk => clock,
  s_axis_cartesian_tvalid => s_axis_cartesian_tvalid,
  s_axis_cartesian_tdata => s_axis_cartesian_tdata_mpsum11,
  m_axis_dout_tvalid => m_axis_dout_tvalid_mpsum11,
  m_axis_dout_tdata => m_axis_dout_tdata_mpsum11
);
sqrt_mpsum12 : cordic_sqrt24
PORT MAP (
  aclk => clock,
  s_axis_cartesian_tvalid => s_axis_cartesian_tvalid,
  s_axis_cartesian_tdata => s_axis_cartesian_tdata_mpsum12,
  m_axis_dout_tvalid => m_axis_dout_tvalid_mpsum12,
  m_axis_dout_tdata => m_axis_dout_tdata_mpsum12
);
sqrt_mpsum13 : cordic_sqrt24
PORT MAP (
  aclk => clock,
  s_axis_cartesian_tvalid => s_axis_cartesian_tvalid,
  s_axis_cartesian_tdata => s_axis_cartesian_tdata_mpsum13,
  m_axis_dout_tvalid => m_axis_dout_tvalid_mpsum13,
  m_axis_dout_tdata => m_axis_dout_tdata_mpsum13
);
sqrt_mpsum14 : cordic_sqrt24
PORT MAP (
  aclk => clock,
  s_axis_cartesian_tvalid => s_axis_cartesian_tvalid,
  s_axis_cartesian_tdata => s_axis_cartesian_tdata_mpsum14,
  m_axis_dout_tvalid => m_axis_dout_tvalid_mpsum14,
  m_axis_dout_tdata => m_axis_dout_tdata_mpsum14
);
sqrt_mpsum15 : cordic_sqrt24
PORT MAP (
  aclk => clock,
  s_axis_cartesian_tvalid => s_axis_cartesian_tvalid,
  s_axis_cartesian_tdata => s_axis_cartesian_tdata_mpsum15,
  m_axis_dout_tvalid => m_axis_dout_tvalid_mpsum15,
  m_axis_dout_tdata => m_axis_dout_tdata_mpsum15
);
sqrt_mpsum16 : cordic_sqrt24
PORT MAP (
  aclk => clock,
  s_axis_cartesian_tvalid => s_axis_cartesian_tvalid,
  s_axis_cartesian_tdata => s_axis_cartesian_tdata_mpsum16,
  m_axis_dout_tvalid => m_axis_dout_tvalid_mpsum16,
  m_axis_dout_tdata => m_axis_dout_tdata_mpsum16
);
sqrt_mpsum17 : cordic_sqrt24
PORT MAP (
  aclk => clock,
  s_axis_cartesian_tvalid => s_axis_cartesian_tvalid,
  s_axis_cartesian_tdata => s_axis_cartesian_tdata_mpsum17,
  m_axis_dout_tvalid => m_axis_dout_tvalid_mpsum17,
  m_axis_dout_tdata => m_axis_dout_tdata_mpsum17
);
sqrt_mpsum18 : cordic_sqrt24
PORT MAP (
  aclk => clock,
  s_axis_cartesian_tvalid => s_axis_cartesian_tvalid,
  s_axis_cartesian_tdata => s_axis_cartesian_tdata_mpsum18,
  m_axis_dout_tvalid => m_axis_dout_tvalid_mpsum18,
  m_axis_dout_tdata => m_axis_dout_tdata_mpsum18
);
sqrt_mpsum19 : cordic_sqrt24
PORT MAP (
  aclk => clock,
  s_axis_cartesian_tvalid => s_axis_cartesian_tvalid,
  s_axis_cartesian_tdata => s_axis_cartesian_tdata_mpsum19,
  m_axis_dout_tvalid => m_axis_dout_tvalid_mpsum19,
  m_axis_dout_tdata => m_axis_dout_tdata_mpsum19
);
sqrt_mpsum20 : cordic_sqrt24
PORT MAP (
  aclk => clock,
  s_axis_cartesian_tvalid => s_axis_cartesian_tvalid,
  s_axis_cartesian_tdata => s_axis_cartesian_tdata_mpsum20,
  m_axis_dout_tvalid => m_axis_dout_tvalid_mpsum20,
  m_axis_dout_tdata => m_axis_dout_tdata_mpsum20
);
sqrt_mpsum21 : cordic_sqrt24
PORT MAP (
  aclk => clock,
  s_axis_cartesian_tvalid => s_axis_cartesian_tvalid,
  s_axis_cartesian_tdata => s_axis_cartesian_tdata_mpsum21,
  m_axis_dout_tvalid => m_axis_dout_tvalid_mpsum21,
  m_axis_dout_tdata => m_axis_dout_tdata_mpsum21
);
sqrt_mpsum22 : cordic_sqrt24
PORT MAP (
  aclk => clock,
  s_axis_cartesian_tvalid => s_axis_cartesian_tvalid,
  s_axis_cartesian_tdata => s_axis_cartesian_tdata_mpsum22,
  m_axis_dout_tvalid => m_axis_dout_tvalid_mpsum22,
  m_axis_dout_tdata => m_axis_dout_tdata_mpsum22
);
sqrt_mpsum23 : cordic_sqrt24
PORT MAP (
  aclk => clock,
  s_axis_cartesian_tvalid => s_axis_cartesian_tvalid,
  s_axis_cartesian_tdata => s_axis_cartesian_tdata_mpsum23,
  m_axis_dout_tvalid => m_axis_dout_tvalid_mpsum23,
  m_axis_dout_tdata => m_axis_dout_tdata_mpsum23
);
  
multadd0 : multadd_10a12b24c
PORT MAP (
  CLK => clock,
  CE => CE_multadd,
  SCLR => SCLR_multadd,
  A => A_multadd0,
  B => B_multadd0,
  C => C_multadd0,
  SUBTRACT => '0',
  P => P_multadd0,
  PCOUT => open
);
multadd1 : multadd_10a12b24c
PORT MAP (
  CLK => clock,
  CE => CE_multadd,
  SCLR => SCLR_multadd,
  A => A_multadd1,
  B => B_multadd1,
  C => C_multadd1,
  SUBTRACT => '0',
  P => P_multadd1,
  PCOUT => open
);
multadd2 : multadd_10a12b24c
PORT MAP (
  CLK => clock,
  CE => CE_multadd,
  SCLR => SCLR_multadd,
  A => A_multadd2,
  B => B_multadd2,
  C => C_multadd2,
  SUBTRACT => '0',
  P => P_multadd2,
  PCOUT => open
);
multadd3 : multadd_10a12b24c
PORT MAP (
  CLK => clock,
  CE => CE_multadd,
  SCLR => SCLR_multadd,
  A => A_multadd3,
  B => B_multadd3,
  C => C_multadd3,
  SUBTRACT => '0',
  P => P_multadd3,
  PCOUT => open
);
multadd4 : multadd_10a12b24c
PORT MAP (
  CLK => clock,
  CE => CE_multadd,
  SCLR => SCLR_multadd,
  A => A_multadd4,
  B => B_multadd4,
  C => C_multadd4,
  SUBTRACT => '0',
  P => P_multadd4,
  PCOUT => open
);
multadd5 : multadd_10a12b24c
PORT MAP (
  CLK => clock,
  CE => CE_multadd,
  SCLR => SCLR_multadd,
  A => A_multadd5,
  B => B_multadd5,
  C => C_multadd5,
  SUBTRACT => '0',
  P => P_multadd5,
  PCOUT => open
);
multadd6 : multadd_10a12b24c
PORT MAP (
  CLK => clock,
  CE => CE_multadd,
  SCLR => SCLR_multadd,
  A => A_multadd6,
  B => B_multadd6,
  C => C_multadd6,
  SUBTRACT => '0',
  P => P_multadd6,
  PCOUT => open
);
multadd7 : multadd_10a12b24c
PORT MAP (
  CLK => clock,
  CE => CE_multadd,
  SCLR => SCLR_multadd,
  A => A_multadd7,
  B => B_multadd7,
  C => C_multadd7,
  SUBTRACT => '0',
  P => P_multadd7,
  PCOUT => open
);
multadd8 : multadd_10a12b24c
PORT MAP (
  CLK => clock,
  CE => CE_multadd,
  SCLR => SCLR_multadd,
  A => A_multadd8,
  B => B_multadd8,
  C => C_multadd8,
  SUBTRACT => '0',
  P => P_multadd8,
  PCOUT => open
);
multadd9 : multadd_10a12b24c
PORT MAP (
  CLK => clock,
  CE => CE_multadd,
  SCLR => SCLR_multadd,
  A => A_multadd9,
  B => B_multadd9,
  C => C_multadd9,
  SUBTRACT => '0',
  P => P_multadd9,
  PCOUT => open
);
multadd10 : multadd_10a12b24c
PORT MAP (
  CLK => clock,
  CE => CE_multadd,
  SCLR => SCLR_multadd,
  A => A_multadd10,
  B => B_multadd10,
  C => C_multadd10,
  SUBTRACT => '0',
  P => P_multadd10,
  PCOUT => open
);
multadd11 : multadd_10a12b24c
PORT MAP (
  CLK => clock,
  CE => CE_multadd,
  SCLR => SCLR_multadd,
  A => A_multadd11,
  B => B_multadd11,
  C => C_multadd11,
  SUBTRACT => '0',
  P => P_multadd11,
  PCOUT => open
);
multadd12 : multadd_10a12b24c
PORT MAP (
  CLK => clock,
  CE => CE_multadd,
  SCLR => SCLR_multadd,
  A => A_multadd12,
  B => B_multadd12,
  C => C_multadd12,
  SUBTRACT => '0',
  P => P_multadd12,
  PCOUT => open
);
multadd13 : multadd_10a12b24c
PORT MAP (
  CLK => clock,
  CE => CE_multadd,
  SCLR => SCLR_multadd,
  A => A_multadd13,
  B => B_multadd13,
  C => C_multadd13,
  SUBTRACT => '0',
  P => P_multadd13,
  PCOUT => open
);
multadd14 : multadd_10a12b24c
PORT MAP (
  CLK => clock,
  CE => CE_multadd,
  SCLR => SCLR_multadd,
  A => A_multadd14,
  B => B_multadd14,
  C => C_multadd14,
  SUBTRACT => '0',
  P => P_multadd14,
  PCOUT => open
);
multadd15 : multadd_10a12b24c
PORT MAP (
  CLK => clock,
  CE => CE_multadd,
  SCLR => SCLR_multadd,
  A => A_multadd15,
  B => B_multadd15,
  C => C_multadd15,
  SUBTRACT => '0',
  P => P_multadd15,
  PCOUT => open
);
multadd16 : multadd_10a12b24c
PORT MAP (
  CLK => clock,
  CE => CE_multadd,
  SCLR => SCLR_multadd,
  A => A_multadd16,
  B => B_multadd16,
  C => C_multadd16,
  SUBTRACT => '0',
  P => P_multadd16,
  PCOUT => open
);
multadd17 : multadd_10a12b24c
PORT MAP (
  CLK => clock,
  CE => CE_multadd,
  SCLR => SCLR_multadd,
  A => A_multadd17,
  B => B_multadd17,
  C => C_multadd17,
  SUBTRACT => '0',
  P => P_multadd17,
  PCOUT => open
);
multadd18 : multadd_10a12b24c
PORT MAP (
  CLK => clock,
  CE => CE_multadd,
  SCLR => SCLR_multadd,
  A => A_multadd18,
  B => B_multadd18,
  C => C_multadd18,
  SUBTRACT => '0',
  P => P_multadd18,
  PCOUT => open
);
multadd19 : multadd_10a12b24c
PORT MAP (
  CLK => clock,
  CE => CE_multadd,
  SCLR => SCLR_multadd,
  A => A_multadd19,
  B => B_multadd19,
  C => C_multadd19,
  SUBTRACT => '0',
  P => P_multadd19,
  PCOUT => open
);
multadd20 : multadd_10a12b24c
PORT MAP (
  CLK => clock,
  CE => CE_multadd,
  SCLR => SCLR_multadd,
  A => A_multadd20,
  B => B_multadd20,
  C => C_multadd20,
  SUBTRACT => '0',
  P => P_multadd20,
  PCOUT => open
);
multadd21 : multadd_10a12b24c
PORT MAP (
  CLK => clock,
  CE => CE_multadd,
  SCLR => SCLR_multadd,
  A => A_multadd21,
  B => B_multadd21,
  C => C_multadd21,
  SUBTRACT => '0',
  P => P_multadd21,
  PCOUT => open
);
multadd22 : multadd_10a12b24c
PORT MAP (
  CLK => clock,
  CE => CE_multadd,
  SCLR => SCLR_multadd,
  A => A_multadd22,
  B => B_multadd22,
  C => C_multadd22,
  SUBTRACT => '0',
  P => P_multadd22,
  PCOUT => open
);
multadd23 : multadd_10a12b24c
PORT MAP (
  CLK => clock,
  CE => CE_multadd,
  SCLR => SCLR_multadd,
  A => A_multadd23,
  B => B_multadd23,
  C => C_multadd23,
  SUBTRACT => '0',
  P => P_multadd23,
  PCOUT => open
);

  
 
check_macropixel : process(clock)
begin
    if (clock'event and clock = '1') then
        case (state_mp_check) is
            when s0 =>
                if (mp_ready = '1') then
                    if ("0" & mp0 > mem_out(10 downto 0)) then
                        bmp_c(0) <= '1';
                    end if;
                    if ("0" & mp1 > mem_out(21 downto 11)) then
                        bmp_c(1) <= '1';
                    end if;
                    if ("0" & mp2 > mem_out(32 downto 22)) then
                        bmp_c(2) <= '1';
                    end if;
                    if ("0" & mp3 > mem_out(43 downto 33)) then
                        bmp_c(3) <= '1';
                    end if;
                    if ("0" & mp4 > mem_out(54 downto 44)) then
                        bmp_c(4) <= '1';
                    end if;
                    if ("0" & mp5 > mem_out(65 downto 55)) then
                        bmp_c(5) <= '1';
                    end if;
                    if ("0" & mp6 > mem_out(76 downto 66)) then
                        bmp_c(6) <= '1';
                    end if;
                    if ("0" & mp7 > mem_out(87 downto 77)) then
                        bmp_c(7) <= '1';
                    end if;
                    if ("0" & mp8 > mem_out(98 downto 88)) then
                        bmp_c(8) <= '1';
                    end if;
                    if ("0" & mp9 > mem_out(109 downto 99)) then
                        bmp_c(9) <= '1';
                    end if;
                    if ("0" & mp10 > mem_out(120 downto 110)) then
                        bmp_c(10) <= '1';
                    end if;
                    if ("0" & mp11 > mem_out(131 downto 121)) then
                        bmp_c(11) <= '1';
                    end if;
                    if ("0" & mp12 > mem_out(142 downto 132)) then
                        bmp_c(12) <= '1';
                    end if;
                    if ("0" & mp13 > mem_out(153 downto 143)) then
                        bmp_c(13) <= '1';
                    end if;
                    if ("0" & mp14 > mem_out(164 downto 154)) then
                        bmp_c(14) <= '1';
                    end if;
                    if ("0" & mp15 > mem_out(175 downto 165)) then
                        bmp_c(15) <= '1';
                    end if;
                    if ("0" & mp16 > mem_out(186 downto 176)) then
                        bmp_c(16) <= '1';
                    end if;
                    if ("0" & mp17 > mem_out(197 downto 187)) then
                        bmp_c(17) <= '1';
                    end if;
                    if ("0" & mp18 > mem_out(208 downto 198)) then
                        bmp_c(18) <= '1';
                    end if;
                    if ("0" & mp19 > mem_out(219 downto 209)) then
                        bmp_c(19) <= '1';
                    end if;
                    if ("0" & mp20 > mem_out(230 downto 220)) then
                        bmp_c(20) <= '1';
                    end if;
                    if ("0" & mp21 > mem_out(241 downto 231)) then
                        bmp_c(21) <= '1';
                    end if;
                    if ("0" & mp22 > mem_out(252 downto 242)) then
                        bmp_c(22) <= '1';
                    end if;
                    if ("0" & mp23 > mem_out(263 downto 253)) then
                        bmp_c(23) <= '1';
                    end if;
                    
                    bmp_ready <= '1';
                    state_mp_check <= s1;
                end if;
            when s1 =>
                bmp_ready <= '0';
                state_mp_check <= s0;
                bmp_c <= "000000000000000000000000";
        end case;
    end if;
end process;

addr_memory_read : process(clock)--Manage address Memory for read operation
begin
    if (clock'event and clock = '1') then
        if (mp_ready = '1' ) then
            if (addr_read = "0111" or addr_read = "1111") then--Last position in 0-7 memory or 8-15 memory
                if (addr_write > "0111") then
                    addr_read <= "0000";
                else
                    addr_read <= "1000";
                end if;
            else
                addr_read <= addr_read + 1;
            end if;
        end if;
    end if;
end process;

addr_memory_write : process(clock)--Manage address Memory for write operation
begin
    if (clock'event and clock = '1') then
        if (write_en = '1') then
            if (addr_write = "1111") then
                addr_write <= "0000";
            else
                addr_write <= addr_write + 1;
            end if;
        end if;
    end if;
end process;

addr_memory : process(clock)--Manage address Memory for read/write operation
begin
    if (clock'event and clock = '1') then
        case (state_addr_mem) is
            when s0 =>
                if (mp_ready = '1' ) then
                    state_addr_mem <= s1;
                end if;
                mem_addr <= addr_read;
            when s1 =>
                if (multadd_ready = '1') then--The MULT-ADD value is ready
                    mem_addr <= addr_write;
                    write_en <= '1';--Enable memory write
                end if;
                state_addr_mem <= s2;
            when s2 =>
                write_en <= '0';
                state_addr_mem <= s0;
        end case;
    end if;
end process;

Sthr_calc_input : process(clock)-- Write MPSUM value in FIFO_MPSUM (And Check MPSUM value aganist MPSthr)
begin
    if (clock'event and clock = '1') then
        if ( mpsum_ready = '1' ) then
            wr_en_fifo_mpsum <= '1';-- Write MPSUM
            if (mpsum0 < "00000000" & MPSthr) then--IF MacroPixelSum < MPSthr
                din_fifo_mpsum(23 downto 0) <=  "00000000" & MPSthr;--mpsum=MPSthr
            else
                din_fifo_mpsum(23 downto 0) <= mpsum0;
            end if;
            if (mpsum1 < "00000000" & MPSthr) then--IF MacroPixelSum < MPSthr
                din_fifo_mpsum(47 downto 24) <=  "00000000" & MPSthr;--mpsum=MPSthr
            else
                din_fifo_mpsum(47 downto 24) <= mpsum1;
            end if;
            if (mpsum2 < "00000000" & MPSthr) then--IF MacroPixelSum < MPSthr
                din_fifo_mpsum(71 downto 48) <=  "00000000" & MPSthr;--mpsum=MPSthr
            else
                din_fifo_mpsum(71 downto 48) <= mpsum2;
            end if;
            if (mpsum3 < "00000000" & MPSthr) then--IF MacroPixelSum < MPSthr
                din_fifo_mpsum(95 downto 72) <=  "00000000" & MPSthr;--mpsum=MPSthr
            else
                din_fifo_mpsum(95 downto 72) <= mpsum3;
            end if;
            if (mpsum4 < "00000000" & MPSthr) then--IF MacroPixelSum < MPSthr
                din_fifo_mpsum(119 downto 96) <=  "00000000" & MPSthr;--mpsum=MPSthr
            else
                din_fifo_mpsum(119 downto 96) <= mpsum4;
            end if;
            if (mpsum5 < "00000000" & MPSthr) then--IF MacroPixelSum < MPSthr
                din_fifo_mpsum(143 downto 120) <=  "00000000" & MPSthr;--mpsum=MPSthr
            else
                din_fifo_mpsum(143 downto 120) <= mpsum5;
            end if;
            if (mpsum6 < "00000000" & MPSthr) then--IF MacroPixelSum < MPSthr
                din_fifo_mpsum(167 downto 144) <=  "00000000" & MPSthr;--mpsum=MPSthr
            else
                din_fifo_mpsum(167 downto 144) <= mpsum6;
            end if;
            if (mpsum7 < "00000000" & MPSthr) then--IF MacroPixelSum < MPSthr
                din_fifo_mpsum(191 downto 168) <=  "00000000" & MPSthr;--mpsum=MPSthr
            else
                din_fifo_mpsum(191 downto 168) <= mpsum7;
            end if;
            if (mpsum8 < "00000000" & MPSthr) then--IF MacroPixelSum < MPSthr
                din_fifo_mpsum(215 downto 192) <=  "00000000" & MPSthr;--mpsum=MPSthr
            else
                din_fifo_mpsum(215 downto 192) <= mpsum8;
            end if;
            if (mpsum9 < "00000000" & MPSthr) then--IF MacroPixelSum < MPSthr
                din_fifo_mpsum(239 downto 216) <=  "00000000" & MPSthr;--mpsum=MPSthr
            else
                din_fifo_mpsum(239 downto 216) <= mpsum9;
            end if;
            if (mpsum10 < "00000000" & MPSthr) then--IF MacroPixelSum < MPSthr
                din_fifo_mpsum(263 downto 240) <=  "00000000" & MPSthr;--mpsum=MPSthr
            else
                din_fifo_mpsum(263 downto 240) <= mpsum10;
            end if;
            if (mpsum11 < "00000000" & MPSthr) then--IF MacroPixelSum < MPSthr
                din_fifo_mpsum(287 downto 264) <=  "00000000" & MPSthr;--mpsum=MPSthr
            else
                din_fifo_mpsum(287 downto 264) <= mpsum11;
            end if;
            if (mpsum12 < "00000000" & MPSthr) then--IF MacroPixelSum < MPSthr
                din_fifo_mpsum(311 downto 288) <=  "00000000" & MPSthr;--mpsum=MPSthr
            else
                din_fifo_mpsum(311 downto 288) <= mpsum12;
            end if;
            if (mpsum13 < "00000000" & MPSthr) then--IF MacroPixelSum < MPSthr
                din_fifo_mpsum(335 downto 312) <=  "00000000" & MPSthr;--mpsum=MPSthr
            else
                din_fifo_mpsum(335 downto 312) <= mpsum13;
            end if;
            if (mpsum14 < "00000000" & MPSthr) then--IF MacroPixelSum < MPSthr
                din_fifo_mpsum(359 downto 336) <=  "00000000" & MPSthr;--mpsum=MPSthr
            else
                din_fifo_mpsum(359 downto 336) <= mpsum14;
            end if;
            if (mpsum15 < "00000000" & MPSthr) then--IF MacroPixelSum < MPSthr
                din_fifo_mpsum(383 downto 360) <=  "00000000" & MPSthr;--mpsum=MPSthr
            else
                din_fifo_mpsum(383 downto 360) <= mpsum15;
            end if;
            if (mpsum16 < "00000000" & MPSthr) then--IF MacroPixelSum < MPSthr
                din_fifo_mpsum(407 downto 384) <=  "00000000" & MPSthr;--mpsum=MPSthr
            else
                din_fifo_mpsum(407 downto 384) <= mpsum16;
            end if;
            if (mpsum17 < "00000000" & MPSthr) then--IF MacroPixelSum < MPSthr
                din_fifo_mpsum(431 downto 408) <=  "00000000" & MPSthr;--mpsum=MPSthr
            else
                din_fifo_mpsum(431 downto 408) <= mpsum17;
            end if;
            if (mpsum18 < "00000000" & MPSthr) then--IF MacroPixelSum < MPSthr
                din_fifo_mpsum(455 downto 432) <=  "00000000" & MPSthr;--mpsum=MPSthr
            else
                din_fifo_mpsum(455 downto 432) <= mpsum18;
            end if;
            if (mpsum19 < "00000000" & MPSthr) then--IF MacroPixelSum < MPSthr
                din_fifo_mpsum(479 downto 456) <=  "00000000" & MPSthr;--mpsum=MPSthr
            else
                din_fifo_mpsum(479 downto 456) <= mpsum19;
            end if;
            if (mpsum20 < "00000000" & MPSthr) then--IF MacroPixelSum < MPSthr
                din_fifo_mpsum(503 downto 480) <=  "00000000" & MPSthr;--mpsum=MPSthr
            else
                din_fifo_mpsum(503 downto 480) <= mpsum20;
            end if;
            if (mpsum21 < "00000000" & MPSthr) then--IF MacroPixelSum < MPSthr
                din_fifo_mpsum(527 downto 504) <=  "00000000" & MPSthr;--mpsum=MPSthr
            else
                din_fifo_mpsum(527 downto 504) <= mpsum21;
            end if;
            if (mpsum22 < "00000000" & MPSthr) then--IF MacroPixelSum < MPSthr
                din_fifo_mpsum(551 downto 528) <=  "00000000" & MPSthr;--mpsum=MPSthr
            else
                din_fifo_mpsum(551 downto 528) <= mpsum22;
            end if;
            if (mpsum23 < "00000000" & MPSthr) then--IF MacroPixelSum < MPSthr
                din_fifo_mpsum(575 downto 552) <=  "00000000" & MPSthr;--mpsum=MPSthr
            else
                din_fifo_mpsum(575 downto 552) <= mpsum23;
            end if;
        else
            wr_en_fifo_mpsum <= '0';
        end if;
    end if;
end process;

Sthr_calc   : process(clock)--Sthr Calculation
begin
    if (clock'event and clock = '1') then
        case (state_sthr_calc) is
            when s0 =>
                if ( empty_fifo_mpsum = '0') then
                    rd_en_fifo_mpsum <= '1';--Read FIFO_SUM
                    state_sthr_calc <= s1;
                end if;
                mem_we <= '0';
                -----------STHR DEBUG---------------------------------------------------------------------------------------
--                sthr_ready_debug <= '0';
                ------------------------------------------------------------------------------------------------------------
            when s1 =>--FIFO_SUM Delay
                rd_en_fifo_mpsum <= '0';
                state_sthr_calc <= s2;
            when s2 =>
                s_axis_cartesian_tvalid <= '1';--Start Root Calc SQRT(SUM)
                s_axis_cartesian_tdata_mpsum0 <= dout_fifo_mpsum(23 downto 0);--SUM16384
                s_axis_cartesian_tdata_mpsum1 <= dout_fifo_mpsum(47 downto 24);--SUM16384
                s_axis_cartesian_tdata_mpsum2 <= dout_fifo_mpsum(71 downto 48);--SUM16384
                s_axis_cartesian_tdata_mpsum3 <= dout_fifo_mpsum(95 downto 72);--SUM16384
                s_axis_cartesian_tdata_mpsum4 <= dout_fifo_mpsum(119 downto 96);--SUM16384
                s_axis_cartesian_tdata_mpsum5 <= dout_fifo_mpsum(143 downto 120);--SUM16384
                s_axis_cartesian_tdata_mpsum6 <= dout_fifo_mpsum(167 downto 144);--SUM16384
                s_axis_cartesian_tdata_mpsum7 <= dout_fifo_mpsum(191 downto 168);--SUM16384
                s_axis_cartesian_tdata_mpsum8 <= dout_fifo_mpsum(215 downto 192);--SUM16384
                s_axis_cartesian_tdata_mpsum9 <= dout_fifo_mpsum(239 downto 216);--SUM16384
                s_axis_cartesian_tdata_mpsum10 <= dout_fifo_mpsum(263 downto 240);--SUM16384
                s_axis_cartesian_tdata_mpsum11 <= dout_fifo_mpsum(287 downto 264);--SUM16384
                s_axis_cartesian_tdata_mpsum12 <= dout_fifo_mpsum(311 downto 288);--SUM16384
                s_axis_cartesian_tdata_mpsum13 <= dout_fifo_mpsum(335 downto 312);--SUM16384
                s_axis_cartesian_tdata_mpsum14 <= dout_fifo_mpsum(359 downto 336);--SUM16384
                s_axis_cartesian_tdata_mpsum15 <= dout_fifo_mpsum(383 downto 360);--SUM16384
                s_axis_cartesian_tdata_mpsum16 <= dout_fifo_mpsum(407 downto 384);--SUM16384
                s_axis_cartesian_tdata_mpsum17 <= dout_fifo_mpsum(431 downto 408);--SUM16384
                s_axis_cartesian_tdata_mpsum18 <= dout_fifo_mpsum(455 downto 432);--SUM16384
                s_axis_cartesian_tdata_mpsum19 <= dout_fifo_mpsum(479 downto 456);--SUM16384
                s_axis_cartesian_tdata_mpsum20 <= dout_fifo_mpsum(503 downto 480);--SUM16384
                s_axis_cartesian_tdata_mpsum21 <= dout_fifo_mpsum(527 downto 504);--SUM16384
                s_axis_cartesian_tdata_mpsum22 <= dout_fifo_mpsum(551 downto 528);--SUM16384
                s_axis_cartesian_tdata_mpsum23 <= dout_fifo_mpsum(575 downto 552);--SUM16384
                state_sthr_calc <= s3;
            when s3 =>
                s_axis_cartesian_tvalid <= '0';
                if ( m_axis_dout_tvalid_mpsum0 = '1' and m_axis_dout_tvalid_mpsum1 = '1' and m_axis_dout_tvalid_mpsum2 = '1'
                and m_axis_dout_tvalid_mpsum3 = '1' and m_axis_dout_tvalid_mpsum4 = '1' and m_axis_dout_tvalid_mpsum5 = '1'
                and m_axis_dout_tvalid_mpsum6 = '1' and m_axis_dout_tvalid_mpsum7 = '1' and m_axis_dout_tvalid_mpsum8 = '1'
                and m_axis_dout_tvalid_mpsum9 = '1' and m_axis_dout_tvalid_mpsum10 = '1' and m_axis_dout_tvalid_mpsum11 = '1'
                and m_axis_dout_tvalid_mpsum12 = '1' and m_axis_dout_tvalid_mpsum13 = '1' and m_axis_dout_tvalid_mpsum14 = '1'
                and m_axis_dout_tvalid_mpsum15 = '1' and m_axis_dout_tvalid_mpsum16 = '1' and m_axis_dout_tvalid_mpsum17 = '1'
                and m_axis_dout_tvalid_mpsum18 = '1' and m_axis_dout_tvalid_mpsum19 = '1' and m_axis_dout_tvalid_mpsum20 = '1'
                and m_axis_dout_tvalid_mpsum21 = '1' and m_axis_dout_tvalid_mpsum22 = '1' and m_axis_dout_tvalid_mpsum23 = '1'
                ) then --SQRT(SUM16384) Ready
                    state_sthr_calc <= s4;
                end if;
            when s4 =>
                --Sthr=(SUM16384+nSigma128*SQRT(SUM16384)/16384
                A_multadd0 <= nSigma128;
                B_multadd0 <= m_axis_dout_tdata_mpsum0(11 downto 0);--SQRT(SUM16384)
                C_multadd0 <= dout_fifo_mpsum(23 downto 0);--SUM16384
                A_multadd1 <= nSigma128;
                B_multadd1 <= m_axis_dout_tdata_mpsum1(11 downto 0);--SQRT(SUM16384)
                C_multadd1 <= dout_fifo_mpsum(47 downto 24);--SUM16384
                A_multadd2 <= nSigma128;
                B_multadd2 <= m_axis_dout_tdata_mpsum2(11 downto 0);--SQRT(SUM16384)
                C_multadd2 <= dout_fifo_mpsum(71 downto 48);--SUM16384
                A_multadd3 <= nSigma128;
                B_multadd3 <= m_axis_dout_tdata_mpsum3(11 downto 0);--SQRT(SUM16384)
                C_multadd3 <= dout_fifo_mpsum(95 downto 72);--SUM16384
                A_multadd4 <= nSigma128;
                B_multadd4 <= m_axis_dout_tdata_mpsum4(11 downto 0);--SQRT(SUM16384)
                C_multadd4 <= dout_fifo_mpsum(119 downto 96);--SUM16384
                A_multadd5 <= nSigma128;
                B_multadd5 <= m_axis_dout_tdata_mpsum5(11 downto 0);--SQRT(SUM16384)
                C_multadd5 <= dout_fifo_mpsum(143 downto 120);--SUM16384
                A_multadd6 <= nSigma128;
                B_multadd6 <= m_axis_dout_tdata_mpsum6(11 downto 0);--SQRT(SUM16384)
                C_multadd6 <= dout_fifo_mpsum(167 downto 144);--SUM16384
                A_multadd7 <= nSigma128;
                B_multadd7 <= m_axis_dout_tdata_mpsum7(11 downto 0);--SQRT(SUM16384)
                C_multadd7 <= dout_fifo_mpsum(191 downto 168);--SUM16384
                A_multadd8 <= nSigma128;
                B_multadd8 <= m_axis_dout_tdata_mpsum8(11 downto 0);--SQRT(SUM16384)
                C_multadd8 <= dout_fifo_mpsum(215 downto 192);--SUM16384
                A_multadd9 <= nSigma128;
                B_multadd9 <= m_axis_dout_tdata_mpsum9(11 downto 0);--SQRT(SUM16384)
                C_multadd9 <= dout_fifo_mpsum(239 downto 216);--SUM16384
                A_multadd10 <= nSigma128;
                B_multadd10 <= m_axis_dout_tdata_mpsum10(11 downto 0);--SQRT(SUM16384)
                C_multadd10 <= dout_fifo_mpsum(263 downto 240);--SUM16384
                A_multadd11 <= nSigma128;
                B_multadd11 <= m_axis_dout_tdata_mpsum11(11 downto 0);--SQRT(SUM16384)
                C_multadd11 <= dout_fifo_mpsum(287 downto 264);--SUM16384
                A_multadd12 <= nSigma128;
                B_multadd12 <= m_axis_dout_tdata_mpsum12(11 downto 0);--SQRT(SUM16384)
                C_multadd12 <= dout_fifo_mpsum(311 downto 288);--SUM16384
                A_multadd13 <= nSigma128;
                B_multadd13 <= m_axis_dout_tdata_mpsum13(11 downto 0);--SQRT(SUM16384)
                C_multadd13 <= dout_fifo_mpsum(335 downto 312);--SUM16384
                A_multadd14 <= nSigma128;
                B_multadd14 <= m_axis_dout_tdata_mpsum14(11 downto 0);--SQRT(SUM16384)
                C_multadd14 <= dout_fifo_mpsum(359 downto 336);--SUM16384
                A_multadd15 <= nSigma128;
                B_multadd15 <= m_axis_dout_tdata_mpsum15(11 downto 0);--SQRT(SUM16384)
                C_multadd15 <= dout_fifo_mpsum(383 downto 360);--SUM16384
                A_multadd16 <= nSigma128;
                B_multadd16 <= m_axis_dout_tdata_mpsum16(11 downto 0);--SQRT(SUM16384)
                C_multadd16 <= dout_fifo_mpsum(407 downto 384);--SUM16384
                A_multadd17 <= nSigma128;
                B_multadd17 <= m_axis_dout_tdata_mpsum17(11 downto 0);--SQRT(SUM16384)
                C_multadd17 <= dout_fifo_mpsum(431 downto 408);--SUM16384
                A_multadd18 <= nSigma128;
                B_multadd18 <= m_axis_dout_tdata_mpsum18(11 downto 0);--SQRT(SUM16384)
                C_multadd18 <= dout_fifo_mpsum(455 downto 432);--SUM16384
                A_multadd19 <= nSigma128;
                B_multadd19 <= m_axis_dout_tdata_mpsum19(11 downto 0);--SQRT(SUM16384)
                C_multadd19 <= dout_fifo_mpsum(479 downto 456);--SUM16384
                A_multadd20 <= nSigma128;
                B_multadd20 <= m_axis_dout_tdata_mpsum20(11 downto 0);--SQRT(SUM16384)
                C_multadd20 <= dout_fifo_mpsum(503 downto 480);--SUM16384
                A_multadd21 <= nSigma128;
                B_multadd21 <= m_axis_dout_tdata_mpsum21(11 downto 0);--SQRT(SUM16384)
                C_multadd21 <= dout_fifo_mpsum(527 downto 504);--SUM16384
                A_multadd22 <= nSigma128;
                B_multadd22 <= m_axis_dout_tdata_mpsum22(11 downto 0);--SQRT(SUM16384)
                C_multadd22 <= dout_fifo_mpsum(551 downto 528);--SUM16384
                A_multadd23 <= nSigma128;
                B_multadd23 <= m_axis_dout_tdata_mpsum23(11 downto 0);--SQRT(SUM16384)
                C_multadd23 <= dout_fifo_mpsum(575 downto 552);--SUM16384
                
                CE_multadd <= '1';--Enable MULT-ADD
                state_sthr_calc <= s5;
            when s5 =>--MultAdd Delay
                state_sthr_calc <= s6;
            when s6 =>--MultAdd Delay
                state_sthr_calc <= s7;
            when s7 =>
                CE_multadd <= '0';
                state_sthr_calc <= s8;
                multadd_ready <= '1';--MULTADD Value Ready
            when s8 =>
                if (write_en = '1') then--Write memory is now enabled
                    mem_we <= '1';--Write Sthr in memory (multadd/16384)
                    mem_in(10 downto 0) <= P_multadd0(24 downto 14);--(Div. 16384)
                    mem_in(21 downto 11) <= P_multadd1(24 downto 14);--(Div. 16384)
                    mem_in(32 downto 22) <= P_multadd2(24 downto 14);--(Div. 16384)
                    mem_in(43 downto 33) <= P_multadd3(24 downto 14);--(Div. 16384)
                    mem_in(54 downto 44) <= P_multadd4(24 downto 14);--(Div. 16384)
                    mem_in(65 downto 55) <= P_multadd5(24 downto 14);--(Div. 16384)
                    mem_in(76 downto 66) <= P_multadd6(24 downto 14);--(Div. 16384)
                    mem_in(87 downto 77) <= P_multadd7(24 downto 14);--(Div. 16384)
                    mem_in(98 downto 88) <= P_multadd8(24 downto 14);--(Div. 16384)
                    mem_in(109 downto 99) <= P_multadd9(24 downto 14);--(Div. 16384)
                    mem_in(120 downto 110) <= P_multadd10(24 downto 14);--(Div. 16384)
                    mem_in(131 downto 121) <= P_multadd11(24 downto 14);--(Div. 16384)
                    mem_in(142 downto 132) <= P_multadd12(24 downto 14);--(Div. 16384)
                    mem_in(153 downto 143) <= P_multadd13(24 downto 14);--(Div. 16384)
                    mem_in(164 downto 154) <= P_multadd14(24 downto 14);--(Div. 16384)
                    mem_in(175 downto 165) <= P_multadd15(24 downto 14);--(Div. 16384)
                    mem_in(186 downto 176) <= P_multadd16(24 downto 14);--(Div. 16384)
                    mem_in(197 downto 187) <= P_multadd17(24 downto 14);--(Div. 16384)
                    mem_in(208 downto 198) <= P_multadd18(24 downto 14);--(Div. 16384)
                    mem_in(219 downto 209) <= P_multadd19(24 downto 14);--(Div. 16384)
                    mem_in(230 downto 220) <= P_multadd20(24 downto 14);--(Div. 16384)
                    mem_in(241 downto 231) <= P_multadd21(24 downto 14);--(Div. 16384)
                    mem_in(252 downto 242) <= P_multadd22(24 downto 14);--(Div. 16384)
                    mem_in(263 downto 253) <= P_multadd23(24 downto 14);--(Div. 16384)
                    --STHR DEBUG---------------------------------------------------------------------------------
--                    sthr_ready_debug <= '1';
--                    sthr_debug(10 downto 0) <= P_multadd0(24 downto 14);--(Div. 16384)
--                    sthr_debug(21 downto 11) <= P_multadd1(24 downto 14);--(Div. 16384)
--                    sthr_debug(32 downto 22) <= P_multadd2(24 downto 14);--(Div. 16384)
--                    sthr_debug(43 downto 33) <= P_multadd3(24 downto 14);--(Div. 16384)
--                    sthr_debug(54 downto 44) <= P_multadd4(24 downto 14);--(Div. 16384)
--                    sthr_debug(65 downto 55) <= P_multadd5(24 downto 14);--(Div. 16384)
--                    sthr_debug(76 downto 66) <= P_multadd6(24 downto 14);--(Div. 16384)
--                    sthr_debug(87 downto 77) <= P_multadd7(24 downto 14);--(Div. 16384)
--                    sthr_debug(98 downto 88) <= P_multadd8(24 downto 14);--(Div. 16384)
--                    sthr_debug(109 downto 99) <= P_multadd9(24 downto 14);--(Div. 16384)
--                    sthr_debug(120 downto 110) <= P_multadd10(24 downto 14);--(Div. 16384)
--                    sthr_debug(131 downto 121) <= P_multadd11(24 downto 14);--(Div. 16384)
--                    sthr_debug(142 downto 132) <= P_multadd12(24 downto 14);--(Div. 16384)
--                    sthr_debug(153 downto 143) <= P_multadd13(24 downto 14);--(Div. 16384)
--                    sthr_debug(164 downto 154) <= P_multadd14(24 downto 14);--(Div. 16384)
--                    sthr_debug(175 downto 165) <= P_multadd15(24 downto 14);--(Div. 16384)
--                    sthr_debug(186 downto 176) <= P_multadd16(24 downto 14);--(Div. 16384)
--                    sthr_debug(197 downto 187) <= P_multadd17(24 downto 14);--(Div. 16384)
--                    sthr_debug(208 downto 198) <= P_multadd18(24 downto 14);--(Div. 16384)
--                    sthr_debug(219 downto 209) <= P_multadd19(24 downto 14);--(Div. 16384)
--                    sthr_debug(230 downto 220) <= P_multadd20(24 downto 14);--(Div. 16384)
--                    sthr_debug(241 downto 231) <= P_multadd21(24 downto 14);--(Div. 16384)
--                    sthr_debug(252 downto 242) <= P_multadd22(24 downto 14);--(Div. 16384)
--                    sthr_debug(263 downto 253) <= P_multadd23(24 downto 14);--(Div. 16384)
                    ----------------------------------------------------------------------------------------------
                    multadd_ready <= '0';
                    state_sthr_calc <= s0;
                end if;
        end case;
    end if;
end process;

               
end MACROPIXEL_CHECK;
