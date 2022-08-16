----------------------------------------------------------------------------------
-- Company: INFN Torino
-- Engineer: M.Mignone
-- 
-- Create Date: 12.08.2020 13:46:40
-- Design Name: 
-- Module Name: MACROPIXEL_MATH - Behavioral
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

entity MACROPIXEL_SUM is Port (
clock       : in STD_LOGIC;
frame_count : in STD_LOGIC_VECTOR (18 downto 0);
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
mpsum0      : out  std_logic_vector (23 downto 0) := ( others => '0');
mpsum1      : out  std_logic_vector (23 downto 0) := ( others => '0');
mpsum2      : out  std_logic_vector (23 downto 0) := ( others => '0');
mpsum3      : out  std_logic_vector (23 downto 0) := ( others => '0');
mpsum4      : out  std_logic_vector (23 downto 0) := ( others => '0');
mpsum5      : out  std_logic_vector (23 downto 0) := ( others => '0');
mpsum6      : out  std_logic_vector (23 downto 0) := ( others => '0');
mpsum7      : out  std_logic_vector (23 downto 0) := ( others => '0');
mpsum8      : out  std_logic_vector (23 downto 0) := ( others => '0');
mpsum9      : out  std_logic_vector (23 downto 0) := ( others => '0');
mpsum10      : out  std_logic_vector (23 downto 0) := ( others => '0');
mpsum11      : out  std_logic_vector (23 downto 0) := ( others => '0');
mpsum12      : out  std_logic_vector (23 downto 0) := ( others => '0');
mpsum13      : out  std_logic_vector (23 downto 0) := ( others => '0');
mpsum14      : out  std_logic_vector (23 downto 0) := ( others => '0');
mpsum15      : out  std_logic_vector (23 downto 0) := ( others => '0');
mpsum16      : out  std_logic_vector (23 downto 0) := ( others => '0');
mpsum17      : out  std_logic_vector (23 downto 0) := ( others => '0');
mpsum18      : out  std_logic_vector (23 downto 0) := ( others => '0');
mpsum19      : out  std_logic_vector (23 downto 0) := ( others => '0');
mpsum20      : out  std_logic_vector (23 downto 0) := ( others => '0');
mpsum21      : out  std_logic_vector (23 downto 0) := ( others => '0');
mpsum22      : out  std_logic_vector (23 downto 0) := ( others => '0');
mpsum23      : out  std_logic_vector (23 downto 0) := ( others => '0');
mpsum_ready : out   std_logic := '0'
);
end MACROPIXEL_SUM;

architecture arch_MACROPIXEL_SUM of MACROPIXEL_SUM is

--------------------------#TEST#--------------------------------------------------------------------------------------
--CONSTANT    last_frame_sum      : std_logic_vector (18 downto 0) := "0000011111111111111";--16383,SUM over 16384 GTU
CONSTANT    last_frame_sum      : std_logic_vector (18 downto 0) := "0000100000000000000";--16384,SUM over 16384 GTU --07/2022
--CONSTANT    last_frame_sum      : std_logic_vector (18 downto 0) := "0000000000000001010";--TEST 10,SUM over 10 GTU
----------------------------------------------------------------------------------------------------------------------

SIGNAL  CE_0    :   std_logic := '0';--Clock ENABLE Colum0
SIGNAL  CE_1    :   std_logic := '0';
SIGNAL  CE_2    :   std_logic := '0';
SIGNAL  CE_3    :   std_logic := '0';
SIGNAL  CE_4    :   std_logic := '0';
SIGNAL  CE_5    :   std_logic := '0';
SIGNAL  CE_6    :   std_logic := '0';
SIGNAL  CE_7    :   std_logic := '0';

SIGNAL  SCLR    :   std_logic := '0';

SIGNAL  sum0_0  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum1_0  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum2_0  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum3_0  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum4_0  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum5_0  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum6_0  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum7_0  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum8_0  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum9_0  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum10_0  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum11_0  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum12_0  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum13_0  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum14_0  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum15_0  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum16_0  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum17_0  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum18_0  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum19_0  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum20_0  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum21_0  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum22_0  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum23_0  :   std_logic_vector (23 downto 0):= ( others => '0');

SIGNAL  sum0_1  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum1_1  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum2_1  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum3_1  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum4_1  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum5_1  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum6_1  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum7_1  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum8_1  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum9_1  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum10_1  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum11_1  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum12_1  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum13_1  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum14_1  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum15_1  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum16_1  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum17_1  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum18_1  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum19_1  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum20_1  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum21_1  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum22_1  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum23_1  :   std_logic_vector (23 downto 0):= ( others => '0');

SIGNAL  sum0_2  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum1_2  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum2_2  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum3_2  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum4_2  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum5_2  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum6_2  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum7_2  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum8_2  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum9_2  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum10_2  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum11_2  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum12_2  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum13_2  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum14_2  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum15_2  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum16_2  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum17_2  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum18_2  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum19_2  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum20_2  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum21_2  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum22_2  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum23_2  :   std_logic_vector (23 downto 0):= ( others => '0');

SIGNAL  sum0_3  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum1_3  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum2_3  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum3_3  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum4_3  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum5_3  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum6_3  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum7_3  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum8_3  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum9_3  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum10_3  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum11_3  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum12_3  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum13_3  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum14_3  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum15_3  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum16_3  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum17_3  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum18_3  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum19_3  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum20_3  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum21_3  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum22_3  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum23_3  :   std_logic_vector (23 downto 0):= ( others => '0');

SIGNAL  sum0_4  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum1_4  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum2_4  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum3_4  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum4_4  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum5_4  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum6_4  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum7_4  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum8_4  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum9_4  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum10_4  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum11_4  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum12_4  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum13_4  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum14_4  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum15_4  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum16_4  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum17_4  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum18_4  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum19_4  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum20_4  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum21_4  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum22_4  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum23_4  :   std_logic_vector (23 downto 0):= ( others => '0');

SIGNAL  sum0_5  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum1_5  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum2_5  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum3_5  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum4_5  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum5_5  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum6_5  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum7_5  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum8_5  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum9_5  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum10_5  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum11_5  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum12_5  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum13_5  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum14_5  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum15_5  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum16_5  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum17_5  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum18_5  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum19_5  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum20_5  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum21_5  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum22_5  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum23_5  :   std_logic_vector (23 downto 0):= ( others => '0');

SIGNAL  sum0_6  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum1_6  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum2_6  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum3_6  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum4_6  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum5_6  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum6_6  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum7_6  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum8_6  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum9_6  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum10_6  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum11_6  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum12_6  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum13_6  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum14_6  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum15_6  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum16_6  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum17_6  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum18_6  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum19_6  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum20_6  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum21_6  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum22_6  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum23_6  :   std_logic_vector (23 downto 0):= ( others => '0');


SIGNAL  sum0_7  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum1_7  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum2_7  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum3_7  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum4_7  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum5_7  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum6_7  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum7_7  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum8_7  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum9_7  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum10_7  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum11_7  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum12_7  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum13_7  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum14_7  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum15_7  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum16_7  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum17_7  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum18_7  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum19_7  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum20_7  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum21_7  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum22_7  :   std_logic_vector (23 downto 0):= ( others => '0');
SIGNAL  sum23_7  :   std_logic_vector (23 downto 0):= ( others => '0');

SIGNAL  busy_frame  :   std_logic_vector (3 downto 0):= ( others => '0');

type    state_sum_type  is (s0,s1,s2,s3,s4,s5,s6,s7,s8);
signal  state_sum   :   state_sum_type := s0;

type    state_col_out_type  is (s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16);
signal  state_col_out   :   state_col_out_type := s0;


COMPONENT accum_10_24
  PORT (
    B : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    CLK : IN STD_LOGIC;
    CE : IN STD_LOGIC;
    SCLR : IN STD_LOGIC;
    Q : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
  );
END COMPONENT;

begin

SUM_MP0_0 : accum_10_24--Macropixel 0 col0
PORT MAP (
    B => mp0,
    CLK => CLOCK,
    CE => CE_0,
    SCLR => SCLR,
    Q => sum0_0
);

SUM_MP1_0 : accum_10_24--Macropixel 1 col0
PORT MAP (
    B => mp1,
    CLK => CLOCK,
    CE => CE_0,
    SCLR => SCLR,
    Q => sum1_0
);

SUM_MP2_0 : accum_10_24
PORT MAP (
    B => mp2,
    CLK => CLOCK,
    CE => CE_0,
    SCLR => SCLR,
    Q => sum2_0
);

SUM_MP3_0 : accum_10_24
PORT MAP (
    B => mp3,
    CLK => CLOCK,
    CE => CE_0,
    SCLR => SCLR,
    Q => sum3_0
);

SUM_MP4_0 : accum_10_24
PORT MAP (
    B => mp4,
    CLK => CLOCK,
    CE => CE_0,
    SCLR => SCLR,
    Q => sum4_0
);

SUM_MP5_0 : accum_10_24
PORT MAP (
    B => mp5,
    CLK => CLOCK,
    CE => CE_0,
    SCLR => SCLR,
    Q => sum5_0
);

SUM_MP6_0 : accum_10_24
PORT MAP (
    B => mp6,
    CLK => CLOCK,
    CE => CE_0,
    SCLR => SCLR,
    Q => sum6_0
);

SUM_MP7_0 : accum_10_24
PORT MAP (
    B => mp7,
    CLK => CLOCK,
    CE => CE_0,
    SCLR => SCLR,
    Q => sum7_0
);

SUM_MP8_0 : accum_10_24--Macropixel 8 col0
PORT MAP (
    B => mp8,
    CLK => CLOCK,
    CE => CE_0,
    SCLR => SCLR,
    Q => sum8_0
);

SUM_MP9_0 : accum_10_24
PORT MAP (
    B => mp9,
    CLK => CLOCK,
    CE => CE_0,
    SCLR => SCLR,
    Q => sum9_0
);

SUM_MP10_0 : accum_10_24
PORT MAP (
    B => mp10,
    CLK => CLOCK,
    CE => CE_0,
    SCLR => SCLR,
    Q => sum10_0
);

SUM_MP11_0 : accum_10_24
PORT MAP (
    B => mp11,
    CLK => CLOCK,
    CE => CE_0,
    SCLR => SCLR,
    Q => sum11_0
);

SUM_MP12_0 : accum_10_24
PORT MAP (
    B => mp12,
    CLK => CLOCK,
    CE => CE_0,
    SCLR => SCLR,
    Q => sum12_0
);

SUM_MP13_0 : accum_10_24
PORT MAP (
    B => mp13,
    CLK => CLOCK,
    CE => CE_0,
    SCLR => SCLR,
    Q => sum13_0
);

SUM_MP14_0 : accum_10_24
PORT MAP (
    B => mp14,
    CLK => CLOCK,
    CE => CE_0,
    SCLR => SCLR,
    Q => sum14_0
);

SUM_MP15_0 : accum_10_24
PORT MAP (
    B => mp15,
    CLK => CLOCK,
    CE => CE_0,
    SCLR => SCLR,
    Q => sum15_0
);

SUM_MP16_0 : accum_10_24
PORT MAP (
    B => mp16,
    CLK => CLOCK,
    CE => CE_0,
    SCLR => SCLR,
    Q => sum16_0
);

SUM_MP17_0 : accum_10_24
PORT MAP (
    B => mp17,
    CLK => CLOCK,
    CE => CE_0,
    SCLR => SCLR,
    Q => sum17_0
);

SUM_MP18_0 : accum_10_24
PORT MAP (
    B => mp18,
    CLK => CLOCK,
    CE => CE_0,
    SCLR => SCLR,
    Q => sum18_0
);

SUM_MP19_0 : accum_10_24
PORT MAP (
    B => mp19,
    CLK => CLOCK,
    CE => CE_0,
    SCLR => SCLR,
    Q => sum19_0
);

SUM_MP20_0 : accum_10_24
PORT MAP (
    B => mp20,
    CLK => CLOCK,
    CE => CE_0,
    SCLR => SCLR,
    Q => sum20_0
);

SUM_MP21_0 : accum_10_24
PORT MAP (
    B => mp21,
    CLK => CLOCK,
    CE => CE_0,
    SCLR => SCLR,
    Q => sum21_0
);

SUM_MP22_0 : accum_10_24
PORT MAP (
    B => mp22,
    CLK => CLOCK,
    CE => CE_0,
    SCLR => SCLR,
    Q => sum22_0
);

SUM_MP23_0 : accum_10_24
PORT MAP (
    B => mp23,
    CLK => CLOCK,
    CE => CE_0,
    SCLR => SCLR,
    Q => sum23_0
);

SUM_MP0_1 : accum_10_24
PORT MAP (
    B => mp0,
    CLK => CLOCK,
    CE => CE_1,
    SCLR => SCLR,
    Q => sum0_1
);

SUM_MP1_1 : accum_10_24
PORT MAP (
    B => mp1,
    CLK => CLOCK,
    CE => CE_1,
    SCLR => SCLR,
    Q => sum1_1
);

SUM_MP2_1 : accum_10_24
PORT MAP (
    B => mp2,
    CLK => CLOCK,
    CE => CE_1,
    SCLR => SCLR,
    Q => sum2_1
);

SUM_MP3_1 : accum_10_24
PORT MAP (
    B => mp3,
    CLK => CLOCK,
    CE => CE_1,
    SCLR => SCLR,
    Q => sum3_1
);

SUM_MP4_1 : accum_10_24
PORT MAP (
    B => mp4,
    CLK => CLOCK,
    CE => CE_1,
    SCLR => SCLR,
    Q => sum4_1
);

SUM_MP5_1 : accum_10_24
PORT MAP (
    B => mp5,
    CLK => CLOCK,
    CE => CE_1,
    SCLR => SCLR,
    Q => sum5_1
);

SUM_MP6_1 : accum_10_24
PORT MAP (
    B => mp6,
    CLK => CLOCK,
    CE => CE_1,
    SCLR => SCLR,
    Q => sum6_1
);

SUM_MP7_1 : accum_10_24
PORT MAP (
    B => mp7,
    CLK => CLOCK,
    CE => CE_1,
    SCLR => SCLR,
    Q => sum7_1
);

SUM_MP8_1 : accum_10_24--Macropixel 8 col1
PORT MAP (
    B => mp8,
    CLK => CLOCK,
    CE => CE_1,
    SCLR => SCLR,
    Q => sum8_1
);

SUM_MP9_1 : accum_10_24
PORT MAP (
    B => mp9,
    CLK => CLOCK,
    CE => CE_1,
    SCLR => SCLR,
    Q => sum9_1
);

SUM_MP10_1 : accum_10_24
PORT MAP (
    B => mp10,
    CLK => CLOCK,
    CE => CE_1,
    SCLR => SCLR,
    Q => sum10_1
);

SUM_MP11_1 : accum_10_24
PORT MAP (
    B => mp11,
    CLK => CLOCK,
    CE => CE_1,
    SCLR => SCLR,
    Q => sum11_1
);

SUM_MP12_1 : accum_10_24
PORT MAP (
    B => mp12,
    CLK => CLOCK,
    CE => CE_1,
    SCLR => SCLR,
    Q => sum12_1
);

SUM_MP13_1 : accum_10_24
PORT MAP (
    B => mp13,
    CLK => CLOCK,
    CE => CE_1,
    SCLR => SCLR,
    Q => sum13_1
);

SUM_MP14_1 : accum_10_24
PORT MAP (
    B => mp14,
    CLK => CLOCK,
    CE => CE_1,
    SCLR => SCLR,
    Q => sum14_1
);

SUM_MP15_1 : accum_10_24
PORT MAP (
    B => mp15,
    CLK => CLOCK,
    CE => CE_1,
    SCLR => SCLR,
    Q => sum15_1
);

SUM_MP16_1 : accum_10_24
PORT MAP (
    B => mp16,
    CLK => CLOCK,
    CE => CE_1,
    SCLR => SCLR,
    Q => sum16_1
);

SUM_MP17_1 : accum_10_24
PORT MAP (
    B => mp17,
    CLK => CLOCK,
    CE => CE_1,
    SCLR => SCLR,
    Q => sum17_1
);

SUM_MP18_1 : accum_10_24
PORT MAP (
    B => mp18,
    CLK => CLOCK,
    CE => CE_1,
    SCLR => SCLR,
    Q => sum18_1
);

SUM_MP19_1 : accum_10_24
PORT MAP (
    B => mp19,
    CLK => CLOCK,
    CE => CE_1,
    SCLR => SCLR,
    Q => sum19_1
);

SUM_MP20_1 : accum_10_24
PORT MAP (
    B => mp20,
    CLK => CLOCK,
    CE => CE_1,
    SCLR => SCLR,
    Q => sum20_1
);

SUM_MP21_1 : accum_10_24
PORT MAP (
    B => mp21,
    CLK => CLOCK,
    CE => CE_1,
    SCLR => SCLR,
    Q => sum21_1
);

SUM_MP22_1 : accum_10_24
PORT MAP (
    B => mp22,
    CLK => CLOCK,
    CE => CE_1,
    SCLR => SCLR,
    Q => sum22_1
);

SUM_MP23_1 : accum_10_24
PORT MAP (
    B => mp23,
    CLK => CLOCK,
    CE => CE_1,
    SCLR => SCLR,
    Q => sum23_1
);

SUM_MP0_2 : accum_10_24
PORT MAP (
    B => mp0,
    CLK => CLOCK,
    CE => CE_2,
    SCLR => SCLR,
    Q => sum0_2
);

SUM_MP1_2 : accum_10_24
PORT MAP (
    B => mp1,
    CLK => CLOCK,
    CE => CE_2,
    SCLR => SCLR,
    Q => sum1_2
);

SUM_MP2_2 : accum_10_24
PORT MAP (
    B => mp2,
    CLK => CLOCK,
    CE => CE_2,
    SCLR => SCLR,
    Q => sum2_2
);

SUM_MP3_2 : accum_10_24
PORT MAP (
    B => mp3,
    CLK => CLOCK,
    CE => CE_2,
    SCLR => SCLR,
    Q => sum3_2
);

SUM_MP4_2 : accum_10_24
PORT MAP (
    B => mp4,
    CLK => CLOCK,
    CE => CE_2,
    SCLR => SCLR,
    Q => sum4_2
);

SUM_MP5_2 : accum_10_24
PORT MAP (
    B => mp5,
    CLK => CLOCK,
    CE => CE_2,
    SCLR => SCLR,
    Q => sum5_2
);

SUM_MP6_2 : accum_10_24
PORT MAP (
    B => mp6,
    CLK => CLOCK,
    CE => CE_2,
    SCLR => SCLR,
    Q => sum6_2
);

SUM_MP7_2 : accum_10_24
PORT MAP (
    B => mp7,
    CLK => CLOCK,
    CE => CE_2,
    SCLR => SCLR,
    Q => sum7_2
);

SUM_MP8_2 : accum_10_24--Macropixel 8 col2
PORT MAP (
    B => mp8,
    CLK => CLOCK,
    CE => CE_2,
    SCLR => SCLR,
    Q => sum8_2
);

SUM_MP9_2 : accum_10_24
PORT MAP (
    B => mp9,
    CLK => CLOCK,
    CE => CE_2,
    SCLR => SCLR,
    Q => sum9_2
);

SUM_MP10_2 : accum_10_24
PORT MAP (
    B => mp10,
    CLK => CLOCK,
    CE => CE_2,
    SCLR => SCLR,
    Q => sum10_2
);

SUM_MP11_2 : accum_10_24
PORT MAP (
    B => mp11,
    CLK => CLOCK,
    CE => CE_2,
    SCLR => SCLR,
    Q => sum11_2
);

SUM_MP12_2 : accum_10_24
PORT MAP (
    B => mp12,
    CLK => CLOCK,
    CE => CE_2,
    SCLR => SCLR,
    Q => sum12_2
);

SUM_MP13_2 : accum_10_24
PORT MAP (
    B => mp13,
    CLK => CLOCK,
    CE => CE_2,
    SCLR => SCLR,
    Q => sum13_2
);

SUM_MP14_2 : accum_10_24
PORT MAP (
    B => mp14,
    CLK => CLOCK,
    CE => CE_2,
    SCLR => SCLR,
    Q => sum14_2
);

SUM_MP15_2 : accum_10_24
PORT MAP (
    B => mp15,
    CLK => CLOCK,
    CE => CE_2,
    SCLR => SCLR,
    Q => sum15_2
);

SUM_MP16_2 : accum_10_24
PORT MAP (
    B => mp16,
    CLK => CLOCK,
    CE => CE_2,
    SCLR => SCLR,
    Q => sum16_2
);

SUM_MP17_2 : accum_10_24
PORT MAP (
    B => mp17,
    CLK => CLOCK,
    CE => CE_2,
    SCLR => SCLR,
    Q => sum17_2
);

SUM_MP18_2 : accum_10_24
PORT MAP (
    B => mp18,
    CLK => CLOCK,
    CE => CE_2,
    SCLR => SCLR,
    Q => sum18_2
);

SUM_MP19_2 : accum_10_24
PORT MAP (
    B => mp19,
    CLK => CLOCK,
    CE => CE_2,
    SCLR => SCLR,
    Q => sum19_2
);

SUM_MP20_2 : accum_10_24
PORT MAP (
    B => mp20,
    CLK => CLOCK,
    CE => CE_2,
    SCLR => SCLR,
    Q => sum20_2
);

SUM_MP21_2 : accum_10_24
PORT MAP (
    B => mp21,
    CLK => CLOCK,
    CE => CE_2,
    SCLR => SCLR,
    Q => sum21_2
);

SUM_MP22_2 : accum_10_24
PORT MAP (
    B => mp22,
    CLK => CLOCK,
    CE => CE_2,
    SCLR => SCLR,
    Q => sum22_2
);

SUM_MP23_2 : accum_10_24
PORT MAP (
    B => mp23,
    CLK => CLOCK,
    CE => CE_2,
    SCLR => SCLR,
    Q => sum23_2
);

SUM_MP0_3 : accum_10_24
PORT MAP (
    B => mp0,
    CLK => CLOCK,
    CE => CE_3,
    SCLR => SCLR,
    Q => sum0_3
);

SUM_MP1_3 : accum_10_24
PORT MAP (
    B => mp1,
    CLK => CLOCK,
    CE => CE_3,
    SCLR => SCLR,
    Q => sum1_3
);

SUM_MP2_3 : accum_10_24
PORT MAP (
    B => mp2,
    CLK => CLOCK,
    CE => CE_3,
    SCLR => SCLR,
    Q => sum2_3
);

SUM_MP3_3 : accum_10_24
PORT MAP (
    B => mp3,
    CLK => CLOCK,
    CE => CE_3,
    SCLR => SCLR,
    Q => sum3_3
);

SUM_MP4_3 : accum_10_24
PORT MAP (
    B => mp4,
    CLK => CLOCK,
    CE => CE_3,
    SCLR => SCLR,
    Q => sum4_3
);

SUM_MP5_3 : accum_10_24
PORT MAP (
    B => mp5,
    CLK => CLOCK,
    CE => CE_3,
    SCLR => SCLR,
    Q => sum5_3
);

SUM_MP6_3 : accum_10_24
PORT MAP (
    B => mp6,
    CLK => CLOCK,
    CE => CE_3,
    SCLR => SCLR,
    Q => sum6_3
);

SUM_MP7_3 : accum_10_24
PORT MAP (
    B => mp7,
    CLK => CLOCK,
    CE => CE_3,
    SCLR => SCLR,
    Q => sum7_3
);

SUM_MP8_3 : accum_10_24--Macropixel 8 col3
PORT MAP (
    B => mp8,
    CLK => CLOCK,
    CE => CE_3,
    SCLR => SCLR,
    Q => sum8_3
);

SUM_MP9_3 : accum_10_24
PORT MAP (
    B => mp9,
    CLK => CLOCK,
    CE => CE_3,
    SCLR => SCLR,
    Q => sum9_3
);

SUM_MP10_3 : accum_10_24
PORT MAP (
    B => mp10,
    CLK => CLOCK,
    CE => CE_3,
    SCLR => SCLR,
    Q => sum10_3
);

SUM_MP11_3 : accum_10_24
PORT MAP (
    B => mp11,
    CLK => CLOCK,
    CE => CE_3,
    SCLR => SCLR,
    Q => sum11_3
);

SUM_MP12_3 : accum_10_24
PORT MAP (
    B => mp12,
    CLK => CLOCK,
    CE => CE_3,
    SCLR => SCLR,
    Q => sum12_3
);

SUM_MP13_3 : accum_10_24
PORT MAP (
    B => mp13,
    CLK => CLOCK,
    CE => CE_3,
    SCLR => SCLR,
    Q => sum13_3
);

SUM_MP14_3 : accum_10_24
PORT MAP (
    B => mp14,
    CLK => CLOCK,
    CE => CE_3,
    SCLR => SCLR,
    Q => sum14_3
);

SUM_MP15_3 : accum_10_24
PORT MAP (
    B => mp15,
    CLK => CLOCK,
    CE => CE_3,
    SCLR => SCLR,
    Q => sum15_3
);

SUM_MP16_3 : accum_10_24
PORT MAP (
    B => mp16,
    CLK => CLOCK,
    CE => CE_3,
    SCLR => SCLR,
    Q => sum16_3
);

SUM_MP17_3 : accum_10_24
PORT MAP (
    B => mp17,
    CLK => CLOCK,
    CE => CE_3,
    SCLR => SCLR,
    Q => sum17_3
);

SUM_MP18_3 : accum_10_24
PORT MAP (
    B => mp18,
    CLK => CLOCK,
    CE => CE_3,
    SCLR => SCLR,
    Q => sum18_3
);

SUM_MP19_3 : accum_10_24
PORT MAP (
    B => mp19,
    CLK => CLOCK,
    CE => CE_3,
    SCLR => SCLR,
    Q => sum19_3
);

SUM_MP20_3 : accum_10_24
PORT MAP (
    B => mp20,
    CLK => CLOCK,
    CE => CE_3,
    SCLR => SCLR,
    Q => sum20_3
);

SUM_MP21_3 : accum_10_24
PORT MAP (
    B => mp21,
    CLK => CLOCK,
    CE => CE_3,
    SCLR => SCLR,
    Q => sum21_3
);

SUM_MP22_3 : accum_10_24
PORT MAP (
    B => mp22,
    CLK => CLOCK,
    CE => CE_3,
    SCLR => SCLR,
    Q => sum22_3
);

SUM_MP23_3 : accum_10_24
PORT MAP (
    B => mp23,
    CLK => CLOCK,
    CE => CE_3,
    SCLR => SCLR,
    Q => sum23_3
);

SUM_MP0_4 : accum_10_24
PORT MAP (
    B => mp0,
    CLK => CLOCK,
    CE => CE_4,
    SCLR => SCLR,
    Q => sum0_4
);

SUM_MP1_4 : accum_10_24
PORT MAP (
    B => mp1,
    CLK => CLOCK,
    CE => CE_4,
    SCLR => SCLR,
    Q => sum1_4
);

SUM_MP2_4 : accum_10_24
PORT MAP (
    B => mp2,
    CLK => CLOCK,
    CE => CE_4,
    SCLR => SCLR,
    Q => sum2_4
);

SUM_MP3_4 : accum_10_24
PORT MAP (
    B => mp3,
    CLK => CLOCK,
    CE => CE_4,
    SCLR => SCLR,
    Q => sum3_4
);

SUM_MP4_4 : accum_10_24
PORT MAP (
    B => mp4,
    CLK => CLOCK,
    CE => CE_4,
    SCLR => SCLR,
    Q => sum4_4
);

SUM_MP5_4 : accum_10_24
PORT MAP (
    B => mp5,
    CLK => CLOCK,
    CE => CE_4,
    SCLR => SCLR,
    Q => sum5_4
);

SUM_MP6_4 : accum_10_24
PORT MAP (
    B => mp6,
    CLK => CLOCK,
    CE => CE_4,
    SCLR => SCLR,
    Q => sum6_4
);

SUM_MP7_4 : accum_10_24
PORT MAP (
    B => mp7,
    CLK => CLOCK,
    CE => CE_4,
    SCLR => SCLR,
    Q => sum7_4
);

SUM_MP8_4 : accum_10_24--Macropixel 8 col.4
PORT MAP (
    B => mp8,
    CLK => CLOCK,
    CE => CE_4,
    SCLR => SCLR,
    Q => sum8_4
);

SUM_MP9_4 : accum_10_24
PORT MAP (
    B => mp9,
    CLK => CLOCK,
    CE => CE_4,
    SCLR => SCLR,
    Q => sum9_4
);

SUM_MP10_4 : accum_10_24
PORT MAP (
    B => mp10,
    CLK => CLOCK,
    CE => CE_4,
    SCLR => SCLR,
    Q => sum10_4
);

SUM_MP11_4 : accum_10_24
PORT MAP (
    B => mp11,
    CLK => CLOCK,
    CE => CE_4,
    SCLR => SCLR,
    Q => sum11_4
);

SUM_MP12_4 : accum_10_24
PORT MAP (
    B => mp12,
    CLK => CLOCK,
    CE => CE_4,
    SCLR => SCLR,
    Q => sum12_4
);

SUM_MP13_4 : accum_10_24
PORT MAP (
    B => mp13,
    CLK => CLOCK,
    CE => CE_4,
    SCLR => SCLR,
    Q => sum13_4
);

SUM_MP14_4 : accum_10_24
PORT MAP (
    B => mp14,
    CLK => CLOCK,
    CE => CE_4,
    SCLR => SCLR,
    Q => sum14_4
);

SUM_MP15_4 : accum_10_24
PORT MAP (
    B => mp15,
    CLK => CLOCK,
    CE => CE_4,
    SCLR => SCLR,
    Q => sum15_4
);

SUM_MP16_4 : accum_10_24
PORT MAP (
    B => mp16,
    CLK => CLOCK,
    CE => CE_4,
    SCLR => SCLR,
    Q => sum16_4
);

SUM_MP17_4 : accum_10_24
PORT MAP (
    B => mp17,
    CLK => CLOCK,
    CE => CE_4,
    SCLR => SCLR,
    Q => sum17_4
);

SUM_MP18_4 : accum_10_24
PORT MAP (
    B => mp18,
    CLK => CLOCK,
    CE => CE_4,
    SCLR => SCLR,
    Q => sum18_4
);

SUM_MP19_4 : accum_10_24
PORT MAP (
    B => mp19,
    CLK => CLOCK,
    CE => CE_4,
    SCLR => SCLR,
    Q => sum19_4
);

SUM_MP20_4 : accum_10_24
PORT MAP (
    B => mp20,
    CLK => CLOCK,
    CE => CE_4,
    SCLR => SCLR,
    Q => sum20_4
);

SUM_MP21_4 : accum_10_24
PORT MAP (
    B => mp21,
    CLK => CLOCK,
    CE => CE_4,
    SCLR => SCLR,
    Q => sum21_4
);

SUM_MP22_4 : accum_10_24
PORT MAP (
    B => mp22,
    CLK => CLOCK,
    CE => CE_4,
    SCLR => SCLR,
    Q => sum22_4
);

SUM_MP23_4 : accum_10_24
PORT MAP (
    B => mp23,
    CLK => CLOCK,
    CE => CE_4,
    SCLR => SCLR,
    Q => sum23_4
);

SUM_MP0_5 : accum_10_24
PORT MAP (
    B => mp0,
    CLK => CLOCK,
    CE => CE_5,
    SCLR => SCLR,
    Q => sum0_5
);

SUM_MP1_5 : accum_10_24
PORT MAP (
    B => mp1,
    CLK => CLOCK,
    CE => CE_5,
    SCLR => SCLR,
    Q => sum1_5
);

SUM_MP2_5 : accum_10_24
PORT MAP (
    B => mp2,
    CLK => CLOCK,
    CE => CE_5,
    SCLR => SCLR,
    Q => sum2_5
);

SUM_MP3_5 : accum_10_24
PORT MAP (
    B => mp3,
    CLK => CLOCK,
    CE => CE_5,
    SCLR => SCLR,
    Q => sum3_5
);

SUM_MP4_5 : accum_10_24
PORT MAP (
    B => mp4,
    CLK => CLOCK,
    CE => CE_5,
    SCLR => SCLR,
    Q => sum4_5
);

SUM_MP5_5 : accum_10_24
PORT MAP (
    B => mp5,
    CLK => CLOCK,
    CE => CE_5,
    SCLR => SCLR,
    Q => sum5_5
);

SUM_MP6_5 : accum_10_24
PORT MAP (
    B => mp6,
    CLK => CLOCK,
    CE => CE_5,
    SCLR => SCLR,
    Q => sum6_5
);

SUM_MP7_5 : accum_10_24
PORT MAP (
    B => mp7,
    CLK => CLOCK,
    CE => CE_5,
    SCLR => SCLR,
    Q => sum7_5
);

SUM_MP8_5 : accum_10_24--Macropixel 8 col.5
PORT MAP (
    B => mp8,
    CLK => CLOCK,
    CE => CE_5,
    SCLR => SCLR,
    Q => sum8_5
);

SUM_MP9_5 : accum_10_24
PORT MAP (
    B => mp9,
    CLK => CLOCK,
    CE => CE_5,
    SCLR => SCLR,
    Q => sum9_5
);

SUM_MP10_5 : accum_10_24
PORT MAP (
    B => mp10,
    CLK => CLOCK,
    CE => CE_5,
    SCLR => SCLR,
    Q => sum10_5
);

SUM_MP11_5 : accum_10_24
PORT MAP (
    B => mp11,
    CLK => CLOCK,
    CE => CE_5,
    SCLR => SCLR,
    Q => sum11_5
);

SUM_MP12_5 : accum_10_24
PORT MAP (
    B => mp12,
    CLK => CLOCK,
    CE => CE_5,
    SCLR => SCLR,
    Q => sum12_5
);

SUM_MP13_5 : accum_10_24
PORT MAP (
    B => mp13,
    CLK => CLOCK,
    CE => CE_5,
    SCLR => SCLR,
    Q => sum13_5
);

SUM_MP14_5 : accum_10_24
PORT MAP (
    B => mp14,
    CLK => CLOCK,
    CE => CE_5,
    SCLR => SCLR,
    Q => sum14_5
);

SUM_MP15_5 : accum_10_24
PORT MAP (
    B => mp15,
    CLK => CLOCK,
    CE => CE_5,
    SCLR => SCLR,
    Q => sum15_5
);

SUM_MP16_5 : accum_10_24
PORT MAP (
    B => mp16,
    CLK => CLOCK,
    CE => CE_5,
    SCLR => SCLR,
    Q => sum16_5
);

SUM_MP17_5 : accum_10_24
PORT MAP (
    B => mp17,
    CLK => CLOCK,
    CE => CE_5,
    SCLR => SCLR,
    Q => sum17_5
);

SUM_MP18_5 : accum_10_24
PORT MAP (
    B => mp18,
    CLK => CLOCK,
    CE => CE_5,
    SCLR => SCLR,
    Q => sum18_5
);

SUM_MP19_5 : accum_10_24
PORT MAP (
    B => mp19,
    CLK => CLOCK,
    CE => CE_5,
    SCLR => SCLR,
    Q => sum19_5
);

SUM_MP20_5 : accum_10_24
PORT MAP (
    B => mp20,
    CLK => CLOCK,
    CE => CE_5,
    SCLR => SCLR,
    Q => sum20_5
);

SUM_MP21_5 : accum_10_24
PORT MAP (
    B => mp21,
    CLK => CLOCK,
    CE => CE_5,
    SCLR => SCLR,
    Q => sum21_5
);

SUM_MP22_5 : accum_10_24
PORT MAP (
    B => mp22,
    CLK => CLOCK,
    CE => CE_5,
    SCLR => SCLR,
    Q => sum22_5
);

SUM_MP23_5 : accum_10_24
PORT MAP (
    B => mp23,
    CLK => CLOCK,
    CE => CE_5,
    SCLR => SCLR,
    Q => sum23_5
);

SUM_MP0_6 : accum_10_24
PORT MAP (
    B => mp0,
    CLK => CLOCK,
    CE => CE_6,
    SCLR => SCLR,
    Q => sum0_6
);

SUM_MP1_6 : accum_10_24
PORT MAP (
    B => mp1,
    CLK => CLOCK,
    CE => CE_6,
    SCLR => SCLR,
    Q => sum1_6
);

SUM_MP2_6 : accum_10_24
PORT MAP (
    B => mp2,
    CLK => CLOCK,
    CE => CE_6,
    SCLR => SCLR,
    Q => sum2_6
);

SUM_MP3_6 : accum_10_24
PORT MAP (
    B => mp3,
    CLK => CLOCK,
    CE => CE_6,
    SCLR => SCLR,
    Q => sum3_6
);

SUM_MP4_6 : accum_10_24
PORT MAP (
    B => mp4,
    CLK => CLOCK,
    CE => CE_6,
    SCLR => SCLR,
    Q => sum4_6
);

SUM_MP5_6 : accum_10_24
PORT MAP (
    B => mp5,
    CLK => CLOCK,
    CE => CE_6,
    SCLR => SCLR,
    Q => sum5_6
);

SUM_MP6_6 : accum_10_24
PORT MAP (
    B => mp6,
    CLK => CLOCK,
    CE => CE_6,
    SCLR => SCLR,
    Q => sum6_6
);

SUM_MP7_6 : accum_10_24
PORT MAP (
    B => mp7,
    CLK => CLOCK,
    CE => CE_6,
    SCLR => SCLR,
    Q => sum7_6
);

SUM_MP8_6 : accum_10_24--Macropixel 8 col.6
PORT MAP (
    B => mp8,
    CLK => CLOCK,
    CE => CE_6,
    SCLR => SCLR,
    Q => sum8_6
);

SUM_MP9_6 : accum_10_24
PORT MAP (
    B => mp9,
    CLK => CLOCK,
    CE => CE_6,
    SCLR => SCLR,
    Q => sum9_6
);

SUM_MP10_6 : accum_10_24
PORT MAP (
    B => mp10,
    CLK => CLOCK,
    CE => CE_6,
    SCLR => SCLR,
    Q => sum10_6
);

SUM_MP11_6 : accum_10_24
PORT MAP (
    B => mp11,
    CLK => CLOCK,
    CE => CE_6,
    SCLR => SCLR,
    Q => sum11_6
);

SUM_MP12_6 : accum_10_24
PORT MAP (
    B => mp12,
    CLK => CLOCK,
    CE => CE_6,
    SCLR => SCLR,
    Q => sum12_6
);

SUM_MP13_6 : accum_10_24
PORT MAP (
    B => mp13,
    CLK => CLOCK,
    CE => CE_6,
    SCLR => SCLR,
    Q => sum13_6
);

SUM_MP14_6 : accum_10_24
PORT MAP (
    B => mp14,
    CLK => CLOCK,
    CE => CE_6,
    SCLR => SCLR,
    Q => sum14_6
);

SUM_MP15_6 : accum_10_24
PORT MAP (
    B => mp15,
    CLK => CLOCK,
    CE => CE_6,
    SCLR => SCLR,
    Q => sum15_6
);

SUM_MP16_6 : accum_10_24
PORT MAP (
    B => mp16,
    CLK => CLOCK,
    CE => CE_6,
    SCLR => SCLR,
    Q => sum16_6
);

SUM_MP17_6 : accum_10_24
PORT MAP (
    B => mp17,
    CLK => CLOCK,
    CE => CE_6,
    SCLR => SCLR,
    Q => sum17_6
);

SUM_MP18_6 : accum_10_24
PORT MAP (
    B => mp18,
    CLK => CLOCK,
    CE => CE_6,
    SCLR => SCLR,
    Q => sum18_6
);

SUM_MP19_6 : accum_10_24
PORT MAP (
    B => mp19,
    CLK => CLOCK,
    CE => CE_6,
    SCLR => SCLR,
    Q => sum19_6
);

SUM_MP20_6 : accum_10_24
PORT MAP (
    B => mp20,
    CLK => CLOCK,
    CE => CE_6,
    SCLR => SCLR,
    Q => sum20_6
);

SUM_MP21_6 : accum_10_24
PORT MAP (
    B => mp21,
    CLK => CLOCK,
    CE => CE_6,
    SCLR => SCLR,
    Q => sum21_6
);

SUM_MP22_6 : accum_10_24
PORT MAP (
    B => mp22,
    CLK => CLOCK,
    CE => CE_6,
    SCLR => SCLR,
    Q => sum22_6
);

SUM_MP23_6 : accum_10_24
PORT MAP (
    B => mp23,
    CLK => CLOCK,
    CE => CE_6,
    SCLR => SCLR,
    Q => sum23_6
);

SUM_MP0_7 : accum_10_24
PORT MAP (
    B => mp0,
    CLK => CLOCK,
    CE => CE_7,
    SCLR => SCLR,
    Q => sum0_7
);

SUM_MP1_7 : accum_10_24
PORT MAP (
    B => mp1,
    CLK => CLOCK,
    CE => CE_7,
    SCLR => SCLR,
    Q => sum1_7
);

SUM_MP2_7 : accum_10_24
PORT MAP (
    B => mp2,
    CLK => CLOCK,
    CE => CE_7,
    SCLR => SCLR,
    Q => sum2_7
);

SUM_MP3_7 : accum_10_24
PORT MAP (
    B => mp3,
    CLK => CLOCK,
    CE => CE_7,
    SCLR => SCLR,
    Q => sum3_7
);

SUM_MP4_7 : accum_10_24
PORT MAP (
    B => mp4,
    CLK => CLOCK,
    CE => CE_7,
    SCLR => SCLR,
    Q => sum4_7
);

SUM_MP5_7 : accum_10_24
PORT MAP (
    B => mp5,
    CLK => CLOCK,
    CE => CE_7,
    SCLR => SCLR,
    Q => sum5_7
);

SUM_MP6_7 : accum_10_24
PORT MAP (
    B => mp6,
    CLK => CLOCK,
    CE => CE_7,
    SCLR => SCLR,
    Q => sum6_7
);

SUM_MP7_7 : accum_10_24
PORT MAP (
    B => mp7,
    CLK => CLOCK,
    CE => CE_7,
    SCLR => SCLR,
    Q => sum7_7
);

SUM_MP8_7 : accum_10_24--Macropixel 8 col.7
PORT MAP (
    B => mp8,
    CLK => CLOCK,
    CE => CE_7,
    SCLR => SCLR,
    Q => sum8_7
);

SUM_MP9_7 : accum_10_24
PORT MAP (
    B => mp9,
    CLK => CLOCK,
    CE => CE_7,
    SCLR => SCLR,
    Q => sum9_7
);

SUM_MP10_7 : accum_10_24
PORT MAP (
    B => mp10,
    CLK => CLOCK,
    CE => CE_7,
    SCLR => SCLR,
    Q => sum10_7
);

SUM_MP11_7 : accum_10_24
PORT MAP (
    B => mp11,
    CLK => CLOCK,
    CE => CE_7,
    SCLR => SCLR,
    Q => sum11_7
);

SUM_MP12_7 : accum_10_24
PORT MAP (
    B => mp12,
    CLK => CLOCK,
    CE => CE_7,
    SCLR => SCLR,
    Q => sum12_7
);

SUM_MP13_7 : accum_10_24
PORT MAP (
    B => mp13,
    CLK => CLOCK,
    CE => CE_7,
    SCLR => SCLR,
    Q => sum13_7
);

SUM_MP14_7 : accum_10_24
PORT MAP (
    B => mp14,
    CLK => CLOCK,
    CE => CE_7,
    SCLR => SCLR,
    Q => sum14_7
);

SUM_MP15_7 : accum_10_24
PORT MAP (
    B => mp15,
    CLK => CLOCK,
    CE => CE_7,
    SCLR => SCLR,
    Q => sum15_7
);

SUM_MP16_7 : accum_10_24
PORT MAP (
    B => mp16,
    CLK => CLOCK,
    CE => CE_7,
    SCLR => SCLR,
    Q => sum16_7
);

SUM_MP17_7 : accum_10_24
PORT MAP (
    B => mp17,
    CLK => CLOCK,
    CE => CE_7,
    SCLR => SCLR,
    Q => sum17_7
);

SUM_MP18_7 : accum_10_24
PORT MAP (
    B => mp18,
    CLK => CLOCK,
    CE => CE_7,
    SCLR => SCLR,
    Q => sum18_7
);

SUM_MP19_7 : accum_10_24
PORT MAP (
    B => mp19,
    CLK => CLOCK,
    CE => CE_7,
    SCLR => SCLR,
    Q => sum19_7
);

SUM_MP20_7 : accum_10_24
PORT MAP (
    B => mp20,
    CLK => CLOCK,
    CE => CE_7,
    SCLR => SCLR,
    Q => sum20_7
);

SUM_MP21_7 : accum_10_24
PORT MAP (
    B => mp21,
    CLK => CLOCK,
    CE => CE_7,
    SCLR => SCLR,
    Q => sum21_7
);

SUM_MP22_7 : accum_10_24
PORT MAP (
    B => mp22,
    CLK => CLOCK,
    CE => CE_7,
    SCLR => SCLR,
    Q => sum22_7
);

SUM_MP23_7 : accum_10_24
PORT MAP (
    B => mp23,
    CLK => CLOCK,
    CE => CE_7,
    SCLR => SCLR,
    Q => sum23_7
);

sum_mp : process (CLOCK)
begin 
    if (CLOCK'event and CLOCK = '1') then
        case (state_sum) is
            when s0 =>
                if (frame_count = "0000000000000000000") then
                    if (busy_frame = "1111") then--Time used by the previous frame to calculate the macropixel of the last column
                        state_sum <= s1;
                        busy_frame <= "0000";
                        SCLR <= '0';
                    else
                        busy_frame <= busy_frame + 1;
                        SCLR <= '1';--Clear the accumulators
                    end if;
                else
                    if (frame_count < last_frame_sum) then     --07/2022 IDLE 5 cycles "<=", IDLE 82 cycles "<" 
                        state_sum <= s1;
                    end if;
                end if;
                CE_7 <= '0';
            when s1 =>
                if (mp_ready = '1') then--col0
                    CE_0 <= '1';
                    state_sum <= s2;
                end if;
            when s2 =>
                if (mp_ready = '1') then--col1
                    CE_1 <= '1';
                    state_sum <= s3;
                else
                    CE_0 <= '0';
                end if;
            when s3 =>
                if (mp_ready = '1') then--col2
                    CE_2 <= '1';
                    state_sum <= s4;
                else
                    CE_1 <= '0';
                end if;
            when s4 =>
                if (mp_ready = '1') then--col3
                    CE_3 <= '1';
                    state_sum <= s5;
                else
                    CE_2 <= '0';
                end if;
            when s5 =>
                if (mp_ready = '1') then--col4
                    CE_4 <= '1';
                    state_sum <= s6;
                else
                    CE_3 <= '0';
                end if;
            when s6 =>
                if (mp_ready = '1') then--col5
                    CE_5 <= '1';
                    state_sum <= s7;
                else
                    CE_4 <= '0';
                end if;
            when s7 =>
                if (mp_ready = '1') then--col6
                    CE_6 <= '1';
                    state_sum <= s8;
                else
                    CE_5 <= '0';
                end if;
            when s8 =>
                if (mp_ready = '1') then--col7
                    CE_7 <= '1';
                    state_sum <= s0;
                else
                    CE_6 <= '0';
                end if;

        end case;
    end if;
end process;

col_out : process (CLOCK)
begin 
    if (CLOCK'event and CLOCK = '1') then
        case (state_col_out) is
            when s0 =>
                --if (frame_count = last_frame_sum) then
                if (frame_count = last_frame_sum and state_sum = s1) then --07/2022
                   state_col_out <= s1;
                end if;
                mpsum_ready <= '0';
            when s1 =>
                if (CE_0 = '1') then--Col. 0
                    state_col_out <= s2;
                end if;
            when s2 =>--Accum Delay
                mpsum0  <= sum0_0;
                mpsum1  <= sum1_0;
                mpsum2  <= sum2_0;
                mpsum3  <= sum3_0;
                mpsum4  <= sum4_0;
                mpsum5  <= sum5_0;
                mpsum6  <= sum6_0;
                mpsum7  <= sum7_0;
                mpsum8  <= sum8_0;
                mpsum9  <= sum9_0;
                mpsum10 <= sum10_0;
                mpsum11 <= sum11_0;
                mpsum12 <= sum12_0;
                mpsum13 <= sum13_0;
                mpsum14 <= sum14_0;
                mpsum15 <= sum15_0;
                mpsum16 <= sum16_0;
                mpsum17 <= sum17_0;
                mpsum18 <= sum18_0;
                mpsum19 <= sum19_0;
                mpsum20 <= sum20_0;
                mpsum21 <= sum21_0;
                mpsum22 <= sum22_0;
                mpsum23 <= sum23_0;
                mpsum_ready <= '1';
                state_col_out <= s3;
            when s3 =>
                if (CE_1 = '1') then--Col.1
                    state_col_out <= s4;
                end if;
                mpsum_ready <= '0';
            when s4 =>--Accum Delay
                mpsum0  <= sum0_1;
                mpsum1  <= sum1_1;
                mpsum2  <= sum2_1;
                mpsum3  <= sum3_1;
                mpsum4  <= sum4_1;
                mpsum5  <= sum5_1;
                mpsum6  <= sum6_1;
                mpsum7  <= sum7_1;
                mpsum8  <= sum8_1;
                mpsum9  <= sum9_1;
                mpsum10 <= sum10_1;
                mpsum11 <= sum11_1;
                mpsum12 <= sum12_1;
                mpsum13 <= sum13_1;
                mpsum14 <= sum14_1;
                mpsum15 <= sum15_1;
                mpsum16 <= sum16_1;
                mpsum17 <= sum17_1;
                mpsum18 <= sum18_1;
                mpsum19 <= sum19_1;
                mpsum20 <= sum20_1;
                mpsum21 <= sum21_1;
                mpsum22 <= sum22_1;
                mpsum23 <= sum23_1;
                mpsum_ready <= '1';
                state_col_out <= s5;
            when s5 =>
                if (CE_2 = '1') then--Col.2
                    state_col_out <= s6;
                end if;
                mpsum_ready <= '0';
            when s6 =>--Accum Delay
                mpsum0 <= sum0_2;
                mpsum1 <= sum1_2;
                mpsum2 <= sum2_2;
                mpsum3 <= sum3_2;
                mpsum4 <= sum4_2;
                mpsum5 <= sum5_2;
                mpsum6 <= sum6_2;
                mpsum7 <= sum7_2;
                mpsum8  <= sum8_2;
                mpsum9  <= sum9_2;
                mpsum10 <= sum10_2;
                mpsum11 <= sum11_2;
                mpsum12 <= sum12_2;
                mpsum13 <= sum13_2;
                mpsum14 <= sum14_2;
                mpsum15 <= sum15_2;
                mpsum16 <= sum16_2;
                mpsum17 <= sum17_2;
                mpsum18 <= sum18_2;
                mpsum19 <= sum19_2;
                mpsum20 <= sum20_2;
                mpsum21 <= sum21_2;
                mpsum22 <= sum22_2;
                mpsum23 <= sum23_2;
                mpsum_ready <= '1';
                state_col_out <= s7;
            when s7 =>
                if (CE_3 = '1') then--Col.3
                    state_col_out <= s8;
                end if;
                mpsum_ready <= '0';
            when s8 =>--Accum Delay
                mpsum0 <= sum0_3;
                mpsum1 <= sum1_3;
                mpsum2 <= sum2_3;
                mpsum3 <= sum3_3;
                mpsum4 <= sum4_3;
                mpsum5 <= sum5_3;
                mpsum6 <= sum6_3;
                mpsum7 <= sum7_3;
                mpsum8  <= sum8_3;
                mpsum9  <= sum9_3;
                mpsum10 <= sum10_3;
                mpsum11 <= sum11_3;
                mpsum12 <= sum12_3;
                mpsum13 <= sum13_3;
                mpsum14 <= sum14_3;
                mpsum15 <= sum15_3;
                mpsum16 <= sum16_3;
                mpsum17 <= sum17_3;
                mpsum18 <= sum18_3;
                mpsum19 <= sum19_3;
                mpsum20 <= sum20_3;
                mpsum21 <= sum21_3;
                mpsum22 <= sum22_3;
                mpsum23 <= sum23_3;
                mpsum_ready <= '1';
                state_col_out <= s9;
          when s9 =>
                if (CE_4 = '1') then--Col.4
                    state_col_out <= s10;
                end if;
                mpsum_ready <= '0';
          when s10 =>--Accum Delay
                mpsum0 <= sum0_4;
                mpsum1 <= sum1_4;
                mpsum2 <= sum2_4;
                mpsum3 <= sum3_4;
                mpsum4 <= sum4_4;
                mpsum5 <= sum5_4;
                mpsum6 <= sum6_4;
                mpsum7 <= sum7_4;
                mpsum8  <= sum8_4;
                mpsum9  <= sum9_4;
                mpsum10 <= sum10_4;
                mpsum11 <= sum11_4;
                mpsum12 <= sum12_4;
                mpsum13 <= sum13_4;
                mpsum14 <= sum14_4;
                mpsum15 <= sum15_4;
                mpsum16 <= sum16_4;
                mpsum17 <= sum17_4;
                mpsum18 <= sum18_4;
                mpsum19 <= sum19_4;
                mpsum20 <= sum20_4;
                mpsum21 <= sum21_4;
                mpsum22 <= sum22_4;
                mpsum23 <= sum23_4;
                mpsum_ready <= '1';
                state_col_out <= s11;
          when s11 =>
                if (CE_5 = '1') then--Col.5
                    state_col_out <= s12;
                end if;
                mpsum_ready <= '0';
          when s12 =>--Accum Delay
                mpsum0 <= sum0_5;
                mpsum1 <= sum1_5;
                mpsum2 <= sum2_5;
                mpsum3 <= sum3_5;
                mpsum4 <= sum4_5;
                mpsum5 <= sum5_5;
                mpsum6 <= sum6_5;
                mpsum7 <= sum7_5;
                mpsum8  <= sum8_5;
                mpsum9  <= sum9_5;
                mpsum10 <= sum10_5;
                mpsum11 <= sum11_5;
                mpsum12 <= sum12_5;
                mpsum13 <= sum13_5;
                mpsum14 <= sum14_5;
                mpsum15 <= sum15_5;
                mpsum16 <= sum16_5;
                mpsum17 <= sum17_5;
                mpsum18 <= sum18_5;
                mpsum19 <= sum19_5;
                mpsum20 <= sum20_5;
                mpsum21 <= sum21_5;
                mpsum22 <= sum22_5;
                mpsum23 <= sum23_5;
                mpsum_ready <= '1';
                state_col_out <= s13;
          when s13 =>
                if (CE_6 = '1') then--Col.6
                    state_col_out <= s14;
                end if;
                mpsum_ready <= '0';
          when s14 =>--Accum Delay
                mpsum0 <= sum0_6;
                mpsum1 <= sum1_6;
                mpsum2 <= sum2_6;
                mpsum3 <= sum3_6;
                mpsum4 <= sum4_6;
                mpsum5 <= sum5_6;
                mpsum6 <= sum6_6;
                mpsum7 <= sum7_6;
                mpsum8  <= sum8_6;
                mpsum9  <= sum9_6;
                mpsum10 <= sum10_6;
                mpsum11 <= sum11_6;
                mpsum12 <= sum12_6;
                mpsum13 <= sum13_6;
                mpsum14 <= sum14_6;
                mpsum15 <= sum15_6;
                mpsum16 <= sum16_6;
                mpsum17 <= sum17_6;
                mpsum18 <= sum18_6;
                mpsum19 <= sum19_6;
                mpsum20 <= sum20_6;
                mpsum21 <= sum21_6;
                mpsum22 <= sum22_6;
                mpsum23 <= sum23_6;
                mpsum_ready <= '1';
                state_col_out <= s15;
          when s15 =>
               if (CE_7 = '1') then--Col.7
                   state_col_out <= s16;
               end if;
               mpsum_ready <= '0';
          when s16 =>--Accum Delay
               mpsum0 <= sum0_7;
               mpsum1 <= sum1_7;
               mpsum2 <= sum2_7;
               mpsum3 <= sum3_7;
               mpsum4 <= sum4_7;
               mpsum5 <= sum5_7;
               mpsum6 <= sum6_7;
               mpsum7 <= sum7_7;
               mpsum8  <= sum8_7;
               mpsum9  <= sum9_7;
               mpsum10 <= sum10_7;
               mpsum11 <= sum11_7;
               mpsum12 <= sum12_7;
               mpsum13 <= sum13_7;
               mpsum14 <= sum14_7;
               mpsum15 <= sum15_7;
               mpsum16 <= sum16_7;
               mpsum17 <= sum17_7;
               mpsum18 <= sum18_7;
               mpsum19 <= sum19_7;
               mpsum20 <= sum20_7;
               mpsum21 <= sum21_7;
               mpsum22 <= sum22_7;
               mpsum23 <= sum23_7;
               mpsum_ready <= '1';
               state_col_out <= s0;
          end case;
      end if;
end process;
    
end arch_MACROPIXEL_SUM;
