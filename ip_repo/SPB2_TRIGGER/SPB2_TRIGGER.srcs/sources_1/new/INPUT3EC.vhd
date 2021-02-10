----------------------------------------------------------------------------------
-- Company:INFN Torino 
-- Engineer: M.Mignone
-- 
-- Create Date: 08/2020 03:23:11 PM
-- Design Name: 
-- Module Name: INPUT3EC - Behavioral
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

ENTITY IN3EC is port (
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
mp_ready     : out   std_logic   
);
END IN3EC;

architecture arch_IN3EC of IN3EC is
signal  pixel_value0   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value1   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value2   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value3   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value4   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value5   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value6   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value7   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value8   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value9   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value10   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value11   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value12   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value13   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value14   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value15   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value16   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value17   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value18   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value19   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value20   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value21   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value22   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value23   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value24   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value25   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value26   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value27   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value28   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value29   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value30   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value31   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value32   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value33   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value34   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value35   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value36   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value37   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value38   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value39   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value40   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value41   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value42   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value43   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value44   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value45   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value46   :  std_logic_vector(7 downto 0) := ( others => '0');
signal  pixel_value47   :  std_logic_vector(7 downto 0) := ( others => '0');

signal  bitcount    :   std_logic_vector(2 downto 0) := ( others => '0');
signal  pixel_rdy   :   std_logic   :=  '0';

signal  din_3EC     :   std_logic_vector(767 downto 0) := ( others => '0');
signal  wr_en       :   std_logic   :=  '0';
signal  rd_en       :   std_logic   :=  '0';
signal  data_out    :   std_logic_vector(767 downto 0) := ( others => '0');
signal  empty       :   std_logic   :=  '0';

type    state_write_type is  (s0,s1);
signal  state_write  :  state_write_type := s0;
type    state_read_type is  (s0,s1,s2,s3,s4);
signal  state_read  :  state_read_type := s0;

signal  p0_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p1_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p2_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p3_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p4_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p5_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p6_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p7_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p8_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p9_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p10_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p11_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p12_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p13_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p14_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p15_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p16_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p17_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p18_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p19_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p20_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p21_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p22_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p23_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p24_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p25_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p26_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p27_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p28_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p29_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p30_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p31_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p32_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p33_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p34_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p35_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p36_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p37_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p38_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p39_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p40_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p41_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p42_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p43_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p44_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p45_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p46_0        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p47_0        :   std_logic_vector(7 downto 0) := ( others => '0');

signal  p0_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p1_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p2_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p3_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p4_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p5_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p6_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p7_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p8_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p9_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p10_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p11_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p12_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p13_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p14_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p15_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p16_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p17_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p18_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p19_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p20_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p21_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p22_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p23_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p24_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p25_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p26_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p27_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p28_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p29_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p30_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p31_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p32_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p33_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p34_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p35_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p36_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p37_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p38_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p39_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p40_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p41_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p42_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p43_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p44_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p45_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p46_1        :   std_logic_vector(7 downto 0) := ( others => '0');
signal  p47_1        :   std_logic_vector(7 downto 0) := ( others => '0');

signal  p0p1_0      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p0p1_1      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p2p3_0      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p2p3_1      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p4p5_0      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p4p5_1      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p6p7_0      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p6p7_1      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p8p9_0      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p8p9_1      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p10p11_0      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p10p11_1      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p12p13_0      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p12p13_1      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p14p15_0      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p14p15_1      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p16p17_0      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p16p17_1      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p18p19_0      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p18p19_1      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p20p21_0      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p20p21_1      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p22p23_0      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p22p23_1      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p24p25_0      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p24p25_1      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p26p27_0      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p26p27_1      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p28p29_0      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p28p29_1      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p30p31_0      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p30p31_1      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p32p33_0      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p32p33_1      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p34p35_0      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p34p35_1      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p36p37_0      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p36p37_1      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p38p39_0      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p38p39_1      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p40p41_0      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p40p41_1      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p42p43_0      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p42p43_1      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p44p45_0      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p44p45_1      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p46p47_0      :   std_logic_vector(8 downto 0) := ( others => '0');
signal  p46p47_1      :   std_logic_vector(8 downto 0) := ( others => '0');

signal  CE          :   std_logic   :=  '0';

COMPONENT fifo_pixel
  PORT (
    wr_clk  : IN STD_LOGIC;
    rd_clk  : IN STD_LOGIC;
    din     : IN STD_LOGIC_VECTOR(767 DOWNTO 0);
    wr_en   : IN STD_LOGIC;
    rd_en   : IN STD_LOGIC;
    dout    : OUT STD_LOGIC_VECTOR(767 DOWNTO 0);
    full    : OUT STD_LOGIC;
    empty   : OUT STD_LOGIC
  );
END COMPONENT;

COMPONENT adder_8bit
  PORT (
    A : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    B : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    CLK : IN STD_LOGIC;
    CE : IN STD_LOGIC;
    S : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
  );
END COMPONENT;

COMPONENT adder_9bit
  PORT (
    A : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    B : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    CLK : IN STD_LOGIC;
    CE : IN STD_LOGIC;
    S : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
  );
END COMPONENT;

begin

FIFO_3EC : fifo_pixel
PORT MAP (
    wr_clk => CLOCK_WR,
    rd_clk => CLOCK_RD,
    din => din_3EC,
    wr_en => wr_en,
    rd_en => rd_en,
    dout => data_out,
    full => open,
    empty => empty
);
  
add_p0p1_0 : adder_8bit
PORT MAP (
  A => p0_0,
  B => p1_0,
  CLK => CLOCK_rd,
  CE => CE,
  S => p0p1_0
);

add_p0p1_1 : adder_8bit
PORT MAP (
  A => p0_1,
  B => p1_1,
  CLK => CLOCK_rd,
  CE => CE,
  S => p0p1_1
);

add_p2p3_0 : adder_8bit
PORT MAP (
  A => p2_0,
  B => p3_0,
  CLK => CLOCK_rd,
  CE => CE,
  S => p2p3_0
);

add_p2p3_1 : adder_8bit
PORT MAP (
  A => p2_1,
  B => p3_1,
  CLK => CLOCK_rd,
  CE => CE,
  S => p2p3_1
);

add_p4p5_0 : adder_8bit
PORT MAP (
  A => p4_0,
  B => p5_0,
  CLK => CLOCK_rd,
  CE => CE,
  S => p4p5_0
);

add_p4p5_1 : adder_8bit
PORT MAP (
  A => p4_1,
  B => p5_1,
  CLK => CLOCK_rd,
  CE => CE,
  S => p4p5_1
);

add_p6p7_0 : adder_8bit
PORT MAP (
  A => p6_0,
  B => p7_0,
  CLK => CLOCK_rd,
  CE => CE,
  S => p6p7_0
);

add_p6p7_1 : adder_8bit
PORT MAP (
  A => p6_1,
  B => p7_1,
  CLK => CLOCK_rd,
  CE => CE,
  S => p6p7_1
);

add_p8p9_0 : adder_8bit
PORT MAP (
  A => p8_0,
  B => p9_0,
  CLK => CLOCK_rd,
  CE => CE,
  S => p8p9_0
);

add_p8p9_1 : adder_8bit
PORT MAP (
  A => p8_1,
  B => p9_1,
  CLK => CLOCK_rd,
  CE => CE,
  S => p8p9_1
);

add_p10p11_0 : adder_8bit
PORT MAP (
  A => p10_0,
  B => p11_0,
  CLK => CLOCK_rd,
  CE => CE,
  S => p10p11_0
);

add_p10p11_1 : adder_8bit
PORT MAP (
  A => p10_1,
  B => p11_1,
  CLK => CLOCK_rd,
  CE => CE,
  S => p10p11_1
);

add_p12p13_0 : adder_8bit
PORT MAP (
  A => p12_0,
  B => p13_0,
  CLK => CLOCK_rd,
  CE => CE,
  S => p12p13_0
);

add_p12p13_1 : adder_8bit
PORT MAP (
  A => p12_1,
  B => p13_1,
  CLK => CLOCK_rd,
  CE => CE,
  S => p12p13_1
);

add_p14p15_0 : adder_8bit
PORT MAP (
  A => p14_0,
  B => p15_0,
  CLK => CLOCK_rd,
  CE => CE,
  S => p14p15_0
);

add_p14p15_1 : adder_8bit
PORT MAP (
  A => p14_1,
  B => p15_1,
  CLK => CLOCK_rd,
  CE => CE,
  S => p14p15_1
);

add_p16p17_0 : adder_8bit
PORT MAP (
  A => p16_0,
  B => p17_0,
  CLK => CLOCK_rd,
  CE => CE,
  S => p16p17_0
);

add_p16p17_1 : adder_8bit
PORT MAP (
  A => p16_1,
  B => p17_1,
  CLK => CLOCK_rd,
  CE => CE,
  S => p16p17_1
);

add_p18p19_0 : adder_8bit
PORT MAP (
  A => p18_0,
  B => p19_0,
  CLK => CLOCK_rd,
  CE => CE,
  S => p18p19_0
);

add_p18p19_1 : adder_8bit
PORT MAP (
  A => p18_1,
  B => p19_1,
  CLK => CLOCK_rd,
  CE => CE,
  S => p18p19_1
);

add_p20p21_0 : adder_8bit
PORT MAP (
  A => p20_0,
  B => p21_0,
  CLK => CLOCK_rd,
  CE => CE,
  S => p20p21_0
);

add_p20p21_1 : adder_8bit
PORT MAP (
  A => p20_1,
  B => p21_1,
  CLK => CLOCK_rd,
  CE => CE,
  S => p20p21_1
);

add_p22p23_0 : adder_8bit
PORT MAP (
  A => p22_0,
  B => p23_0,
  CLK => CLOCK_rd,
  CE => CE,
  S => p22p23_0
);

add_p22p23_1 : adder_8bit
PORT MAP (
  A => p22_1,
  B => p23_1,
  CLK => CLOCK_rd,
  CE => CE,
  S => p22p23_1
);

add_p24p25_0 : adder_8bit
PORT MAP (
  A => p24_0,
  B => p25_0,
  CLK => CLOCK_rd,
  CE => CE,
  S => p24p25_0
);

add_p24p25_1 : adder_8bit
PORT MAP (
  A => p24_1,
  B => p25_1,
  CLK => CLOCK_rd,
  CE => CE,
  S => p24p25_1
);

add_p26p27_0 : adder_8bit
PORT MAP (
  A => p26_0,
  B => p27_0,
  CLK => CLOCK_rd,
  CE => CE,
  S => p26p27_0
);

add_p26p27_1 : adder_8bit
PORT MAP (
  A => p26_1,
  B => p27_1,
  CLK => CLOCK_rd,
  CE => CE,
  S => p26p27_1
);

add_p28p29_0 : adder_8bit
PORT MAP (
  A => p28_0,
  B => p29_0,
  CLK => CLOCK_rd,
  CE => CE,
  S => p28p29_0
);

add_p28p29_1 : adder_8bit
PORT MAP (
  A => p28_1,
  B => p29_1,
  CLK => CLOCK_rd,
  CE => CE,
  S => p28p29_1
);

add_p30p31_0 : adder_8bit
PORT MAP (
  A => p30_0,
  B => p31_0,
  CLK => CLOCK_rd,
  CE => CE,
  S => p30p31_0
);

add_p30p31_1 : adder_8bit
PORT MAP (
  A => p30_1,
  B => p31_1,
  CLK => CLOCK_rd,
  CE => CE,
  S => p30p31_1
);

add_p32p33_0 : adder_8bit
PORT MAP (
  A => p32_0,
  B => p33_0,
  CLK => CLOCK_rd,
  CE => CE,
  S => p32p33_0
);

add_p32p33_1 : adder_8bit
PORT MAP (
  A => p32_1,
  B => p33_1,
  CLK => CLOCK_rd,
  CE => CE,
  S => p32p33_1
);

add_p34p35_0 : adder_8bit
PORT MAP (
  A => p34_0,
  B => p35_0,
  CLK => CLOCK_rd,
  CE => CE,
  S => p34p35_0
);

add_p34p35_1 : adder_8bit
PORT MAP (
  A => p34_1,
  B => p35_1,
  CLK => CLOCK_rd,
  CE => CE,
  S => p34p35_1
);

add_p36p37_0 : adder_8bit
PORT MAP (
  A => p36_0,
  B => p37_0,
  CLK => CLOCK_rd,
  CE => CE,
  S => p36p37_0
);

add_p36p37_1 : adder_8bit
PORT MAP (
  A => p36_1,
  B => p37_1,
  CLK => CLOCK_rd,
  CE => CE,
  S => p36p37_1
);

add_p38p39_0 : adder_8bit
PORT MAP (
  A => p38_0,
  B => p39_0,
  CLK => CLOCK_rd,
  CE => CE,
  S => p38p39_0
);

add_p38p39_1 : adder_8bit
PORT MAP (
  A => p38_1,
  B => p39_1,
  CLK => CLOCK_rd,
  CE => CE,
  S => p38p39_1
);

add_p40p41_0 : adder_8bit
PORT MAP (
  A => p40_0,
  B => p41_0,
  CLK => CLOCK_rd,
  CE => CE,
  S => p40p41_0
);

add_p40p41_1 : adder_8bit
PORT MAP (
  A => p40_1,
  B => p41_1,
  CLK => CLOCK_rd,
  CE => CE,
  S => p40p41_1
);

add_p42p43_0 : adder_8bit
PORT MAP (
  A => p42_0,
  B => p43_0,
  CLK => CLOCK_rd,
  CE => CE,
  S => p42p43_0
);

add_p42p43_1 : adder_8bit
PORT MAP (
  A => p42_1,
  B => p43_1,
  CLK => CLOCK_rd,
  CE => CE,
  S => p42p43_1
);

add_p44p45_0 : adder_8bit
PORT MAP (
  A => p44_0,
  B => p45_0,
  CLK => CLOCK_rd,
  CE => CE,
  S => p44p45_0
);

add_p44p45_1 : adder_8bit
PORT MAP (
  A => p44_1,
  B => p45_1,
  CLK => CLOCK_rd,
  CE => CE,
  S => p44p45_1
);

add_p46p47_0 : adder_8bit
PORT MAP (
  A => p46_0,
  B => p47_0,
  CLK => CLOCK_rd,
  CE => CE,
  S => p46p47_0
);

add_p46p47_1 : adder_8bit
PORT MAP (
  A => p46_1,
  B => p47_1,
  CLK => CLOCK_rd,
  CE => CE,
  S => p46p47_1
);
--------------------------------
add_p0p1_0_p0p1_1 : adder_9bit
PORT MAP (
    A => p0p1_0,
    B => p0p1_1,
    CLK => CLOCK_rd,
    CE => CE,
    S => mp0
);

add_p2p3_0_p2p3_1 : adder_9bit
PORT MAP (
    A => p2p3_0,
    B => p2p3_1,
    CLK => CLOCK_rd,
    CE => CE,
    S => mp1
);

add_p4p5_0_p4p5_1 : adder_9bit
PORT MAP (
    A => p4p5_0,
    B => p4p5_1,
    CLK => CLOCK_rd,
    CE => CE,
    S => mp2
);

add_p6p7_0_p6p7_1 : adder_9bit
PORT MAP (
    A => p6p7_0,
    B => p6p7_1,
    CLK => CLOCK_rd,
    CE => CE,
    S => mp3
);

add_p8p9_0_p8p9_1 : adder_9bit
PORT MAP (
    A => p8p9_0,
    B => p8p9_1,
    CLK => CLOCK_rd,
    CE => CE,
    S => mp4
);

add_p10p11_0_p10p11_1 : adder_9bit
PORT MAP (
    A => p10p11_0,
    B => p10p11_1,
    CLK => CLOCK_rd,
    CE => CE,
    S => mp5
);

add_p12p13_0_p12p13_1 : adder_9bit
PORT MAP (
    A => p12p13_0,
    B => p12p13_1,
    CLK => CLOCK_rd,
    CE => CE,
    S => mp6
);

add_p14p15_0_p14p15_1 : adder_9bit
PORT MAP (
    A => p14p15_0,
    B => p14p15_1,
    CLK => CLOCK_rd,
    CE => CE,
    S => mp7
);

add_p16p17_0_p16p17_1 : adder_9bit
PORT MAP (
    A => p16p17_0,
    B => p16p17_1,
    CLK => CLOCK_rd,
    CE => CE,
    S => mp8
);

add_p18p19_0_p18p19_1 : adder_9bit
PORT MAP (
    A => p18p19_0,
    B => p18p19_1,
    CLK => CLOCK_rd,
    CE => CE,
    S => mp9
);

add_p20p21_0_p20p21_1 : adder_9bit
PORT MAP (
    A => p20p21_0,
    B => p20p21_1,
    CLK => CLOCK_rd,
    CE => CE,
    S => mp10
);

add_p22p23_0_p22p23_1 : adder_9bit
PORT MAP (
    A => p22p23_0,
    B => p22p23_1,
    CLK => CLOCK_rd,
    CE => CE,
    S => mp11
); 

add_p24p25_0_p24p25_1 : adder_9bit
PORT MAP (
    A => p24p25_0,
    B => p24p25_1,
    CLK => CLOCK_rd,
    CE => CE,
    S => mp12
);

add_p26p27_0_p26p27_1 : adder_9bit
PORT MAP (
    A => p26p27_0,
    B => p26p27_1,
    CLK => CLOCK_rd,
    CE => CE,
    S => mp13
);

add_p28p29_0_p28p29_1 : adder_9bit
PORT MAP (
    A => p28p29_0,
    B => p28p29_1,
    CLK => CLOCK_rd,
    CE => CE,
    S => mp14
);

add_p30p31_0_p30p31_1 : adder_9bit
PORT MAP (
    A => p30p31_0,
    B => p30p31_1,
    CLK => CLOCK_rd,
    CE => CE,
    S => mp15
);

add_p32p33_0_p32p33_1 : adder_9bit
PORT MAP (
    A => p32p33_0,
    B => p32p33_1,
    CLK => CLOCK_rd,
    CE => CE,
    S => mp16
);

add_p34p35_0_p34p35_1 : adder_9bit
PORT MAP (
    A => p34p35_0,
    B => p34p35_1,
    CLK => CLOCK_rd,
    CE => CE,
    S => mp17
);

add_p36p37_0_p36p37_1 : adder_9bit
PORT MAP (
    A => p36p37_0,
    B => p36p37_1,
    CLK => CLOCK_rd,
    CE => CE,
    S => mp18
);

add_p38p39_0_p38p39_1 : adder_9bit
PORT MAP (
    A => p38p39_0,
    B => p38p39_1,
    CLK => CLOCK_rd,
    CE => CE,
    S => mp19
);

add_p40p41_0_p40p41_1 : adder_9bit
PORT MAP (
    A => p40p41_0,
    B => p40p41_1,
    CLK => CLOCK_rd,
    CE => CE,
    S => mp20
);

add_p42p43_0_p42p43_1 : adder_9bit
PORT MAP (
    A => p42p43_0,
    B => p42p43_1,
    CLK => CLOCK_rd,
    CE => CE,
    S => mp21
);

add_p44p45_0_p44p45_1 : adder_9bit
PORT MAP (
    A => p44p45_0,
    B => p44p45_1,
    CLK => CLOCK_rd,
    CE => CE,
    S => mp22
);

add_p46p47_0_p46p47_1 : adder_9bit
PORT MAP (
    A => p46p47_0,
    B => p46p47_1,
    CLK => CLOCK_rd,
    CE => CE,
    S => mp23
);
  
--Serial PIXEL BIT IN to BYTE PIXEL (SIPO)
sipo_s : process (CLOCK_wr)
begin 
    if (CLOCK_wr'event and CLOCK_wr = '1') then
        if (frame = '1') then
            --Shift register
            pixel_value0  <= data_in(0) & pixel_value0(7 downto 1);
            pixel_value1  <= data_in(1) & pixel_value1(7 downto 1);
            pixel_value2  <= data_in(2) & pixel_value2(7 downto 1);
            pixel_value3  <= data_in(3) & pixel_value3(7 downto 1);
            pixel_value4  <= data_in(4) & pixel_value4(7 downto 1);
            pixel_value5  <= data_in(5) & pixel_value5(7 downto 1);
            pixel_value6  <= data_in(6) & pixel_value6(7 downto 1);
            pixel_value7  <= data_in(7) & pixel_value7(7 downto 1);
            pixel_value8  <= data_in(8) & pixel_value8(7 downto 1);
            pixel_value9  <= data_in(9) & pixel_value9(7 downto 1);
            pixel_value10 <= data_in(10) & pixel_value10(7 downto 1);
            pixel_value11 <= data_in(11) & pixel_value11(7 downto 1);
            pixel_value12 <= data_in(12) & pixel_value12(7 downto 1);
            pixel_value13 <= data_in(13) & pixel_value13(7 downto 1);
            pixel_value14 <= data_in(14) & pixel_value14(7 downto 1);
            pixel_value15 <= data_in(15) & pixel_value15(7 downto 1);
            pixel_value16 <= data_in(16) & pixel_value16(7 downto 1);
            pixel_value17 <= data_in(17) & pixel_value17(7 downto 1);
            pixel_value18 <= data_in(18) & pixel_value18(7 downto 1);
            pixel_value19 <= data_in(19) & pixel_value19(7 downto 1);
            pixel_value20 <= data_in(20) & pixel_value20(7 downto 1);
            pixel_value21 <= data_in(21) & pixel_value21(7 downto 1);
            pixel_value22 <= data_in(22) & pixel_value22(7 downto 1);
            pixel_value23 <= data_in(23) & pixel_value23(7 downto 1);
            pixel_value24 <= data_in(24) & pixel_value24(7 downto 1);
            pixel_value25 <= data_in(25) & pixel_value25(7 downto 1);
            pixel_value26 <= data_in(26) & pixel_value26(7 downto 1);
            pixel_value27 <= data_in(27) & pixel_value27(7 downto 1);
            pixel_value28 <= data_in(28) & pixel_value28(7 downto 1);
            pixel_value29 <= data_in(29) & pixel_value29(7 downto 1);
            pixel_value30 <= data_in(30) & pixel_value30(7 downto 1);
            pixel_value31 <= data_in(31) & pixel_value31(7 downto 1);
            pixel_value32 <= data_in(32) & pixel_value32(7 downto 1);
            pixel_value33 <= data_in(33) & pixel_value33(7 downto 1);
            pixel_value34 <= data_in(34) & pixel_value34(7 downto 1);
            pixel_value35 <= data_in(35) & pixel_value35(7 downto 1);
            pixel_value36 <= data_in(36) & pixel_value36(7 downto 1);
            pixel_value37 <= data_in(37) & pixel_value37(7 downto 1);
            pixel_value38 <= data_in(38) & pixel_value38(7 downto 1);
            pixel_value39 <= data_in(39) & pixel_value39(7 downto 1);
            pixel_value40 <= data_in(40) & pixel_value40(7 downto 1);
            pixel_value41 <= data_in(41) & pixel_value41(7 downto 1);
            pixel_value42 <= data_in(42) & pixel_value42(7 downto 1);
            pixel_value43 <= data_in(43) & pixel_value43(7 downto 1);
            pixel_value44 <= data_in(44) & pixel_value44(7 downto 1);
            pixel_value45 <= data_in(45) & pixel_value45(7 downto 1);
            pixel_value46 <= data_in(46) & pixel_value46(7 downto 1);
            pixel_value47 <= data_in(47) & pixel_value47(7 downto 1);
            
            if (bitcount = "111") then  --Now we have 8 bits ready in "pixel_value"
                pixel_rdy    <= '1';     --Pixel ready,enable the reading
                bitcount    <= "000";
            else
                pixel_rdy <= '0';
                bitcount <= bitcount + 1;
            end if;
        else
            pixel_rdy        <= '0';
        end if;
    end if;
end process;

fifopixel_write : process (CLOCK_wr)
--Write pixel column in FIFO (2 columns)
begin 
if (CLOCK_wr'event and CLOCK_wr = '1') then
    case (state_write) is
        when s0 =>
            if (pixel_rdy = '1') then
                --Copy even column
                din_3EC(7 downto 0) <= pixel_value0;
                din_3EC(15 downto 8) <= pixel_value1;
                din_3EC(23 downto 16) <= pixel_value2;
                din_3EC(31 downto 24) <= pixel_value3;
                din_3EC(39 downto 32) <= pixel_value4;
                din_3EC(47 downto 40) <= pixel_value5;
                din_3EC(55 downto 48) <= pixel_value6;
                din_3EC(63 downto 56) <= pixel_value7;
                din_3EC(71 downto 64) <= pixel_value8;
                din_3EC(79 downto 72) <= pixel_value9;
                din_3EC(87 downto 80) <= pixel_value10;
                din_3EC(95 downto 88) <= pixel_value11;
                din_3EC(103 downto 96) <= pixel_value12;
                din_3EC(111 downto 104) <= pixel_value13;
                din_3EC(119 downto 112) <= pixel_value14;
                din_3EC(127 downto 120) <= pixel_value15;
                din_3EC(135 downto 128) <= pixel_value16;
                din_3EC(143 downto 136) <= pixel_value17;
                din_3EC(151 downto 144) <= pixel_value18;
                din_3EC(159 downto 152) <= pixel_value19;
                din_3EC(167 downto 160) <= pixel_value20;
                din_3EC(175 downto 168) <= pixel_value21;
                din_3EC(183 downto 176) <= pixel_value22;
                din_3EC(191 downto 184) <= pixel_value23;
                din_3EC(199 downto 192) <= pixel_value24;
                din_3EC(207 downto 200) <= pixel_value25;
                din_3EC(215 downto 208) <= pixel_value26;
                din_3EC(223 downto 216) <= pixel_value27;
                din_3EC(231 downto 224) <= pixel_value28;
                din_3EC(239 downto 232) <= pixel_value29;
                din_3EC(247 downto 240) <= pixel_value30;
                din_3EC(255 downto 248) <= pixel_value31;
                din_3EC(263 downto 256) <= pixel_value32;
                din_3EC(271 downto 264) <= pixel_value33;
                din_3EC(279 downto 272) <= pixel_value34;
                din_3EC(287 downto 280) <= pixel_value35;
                din_3EC(295 downto 288) <= pixel_value36;
                din_3EC(303 downto 296) <= pixel_value37;
                din_3EC(311 downto 304) <= pixel_value38;
                din_3EC(319 downto 312) <= pixel_value39;
                din_3EC(327 downto 320) <= pixel_value40;
                din_3EC(335 downto 328) <= pixel_value41;
                din_3EC(343 downto 336) <= pixel_value42;
                din_3EC(351 downto 344) <= pixel_value43;
                din_3EC(359 downto 352) <= pixel_value44;
                din_3EC(367 downto 360) <= pixel_value45;
                din_3EC(375 downto 368) <= pixel_value46;
                din_3EC(383 downto 376) <= pixel_value47;
                state_write <= s1;
            else
                wr_en <= '0';
            end if;
        when s1 =>
            if (pixel_rdy = '1') then
                --Copy odd column
                din_3EC(391 downto 384) <= pixel_value0;
                din_3EC(399 downto 392) <= pixel_value1;
                din_3EC(407 downto 400) <= pixel_value2;
                din_3EC(415 downto 408) <= pixel_value3;
                din_3EC(423 downto 416) <= pixel_value4;
                din_3EC(431 downto 424) <= pixel_value5;
                din_3EC(439 downto 432) <= pixel_value6;
                din_3EC(447 downto 440) <= pixel_value7;
                din_3EC(455 downto 448) <= pixel_value8;
                din_3EC(463 downto 456) <= pixel_value9;
                din_3EC(471 downto 464) <= pixel_value10;
                din_3EC(479 downto 472) <= pixel_value11;
                din_3EC(487 downto 480) <= pixel_value12;
                din_3EC(495 downto 488) <= pixel_value13;
                din_3EC(503 downto 496) <= pixel_value14;
                din_3EC(511 downto 504) <= pixel_value15;
                din_3EC(519 downto 512) <= pixel_value16;
                din_3EC(527 downto 520) <= pixel_value17;
                din_3EC(535 downto 528) <= pixel_value18;
                din_3EC(543 downto 536) <= pixel_value19;
                din_3EC(551 downto 544) <= pixel_value20;
                din_3EC(559 downto 552) <= pixel_value21;
                din_3EC(567 downto 560) <= pixel_value22;
                din_3EC(575 downto 568) <= pixel_value23;
                din_3EC(583 downto 576) <= pixel_value24;
                din_3EC(591 downto 584) <= pixel_value25;
                din_3EC(599 downto 592) <= pixel_value26;
                din_3EC(607 downto 600) <= pixel_value27;
                din_3EC(615 downto 608) <= pixel_value28;
                din_3EC(623 downto 616) <= pixel_value29;
                din_3EC(631 downto 624) <= pixel_value30;
                din_3EC(639 downto 632) <= pixel_value31;
                din_3EC(647 downto 640) <= pixel_value32;
                din_3EC(655 downto 648) <= pixel_value33;
                din_3EC(663 downto 656) <= pixel_value34;
                din_3EC(671 downto 664) <= pixel_value35;
                din_3EC(679 downto 672) <= pixel_value36;
                din_3EC(687 downto 680) <= pixel_value37;
                din_3EC(695 downto 688) <= pixel_value38;
                din_3EC(703 downto 696) <= pixel_value39;
                din_3EC(711 downto 704) <= pixel_value40;
                din_3EC(719 downto 712) <= pixel_value41;
                din_3EC(727 downto 720) <= pixel_value42;
                din_3EC(735 downto 728) <= pixel_value43;
                din_3EC(743 downto 736) <= pixel_value44;
                din_3EC(751 downto 744) <= pixel_value45;
                din_3EC(759 downto 752) <= pixel_value46;
                din_3EC(767 downto 760) <= pixel_value47;
                wr_en <= '1';--Write 2 columns in FIFO
                state_write <= s0;
            end if;
        end case;
end if;
end process;

fifopixel_read : process (CLOCK_rd)
--Read pixel column in FIFO (2 columns)
begin 
    if (CLOCK_rd'event and CLOCK_rd = '1') then
        case (state_read) is
            when s0 =>
                if (empty = '0') then
                    rd_en <= '1';--Read FIFO
                    state_read <= s1;
                end if;
                CE <= '0';
                mp_ready <= '0';
            when s1 =>--FIFO Latency
                rd_en <= '0';
                state_read <= s2;
            when s2 =>
                    CE <= '1';--SUM Enable
                    --SUM Pixel0Col0-Pixel1Col0
                    p0_0 <= data_out(7 downto 0);
                    p1_0 <= data_out(15 downto 8);
                    -----------------------------
                    p2_0 <= data_out(23 downto 16);
                    p3_0 <= data_out(31 downto 24);
                    p4_0 <= data_out(39 downto 32);
                    p5_0 <= data_out(47 downto 40);
                    p6_0 <= data_out(55 downto 48);
                    p7_0 <= data_out(63 downto 56);
                    p8_0 <= data_out(71 downto 64);
                    p9_0 <= data_out(79 downto 72);
                    p10_0 <= data_out(87 downto 80);
                    p11_0 <= data_out(95 downto 88);
                    p12_0 <= data_out(103 downto 96);
                    p13_0 <= data_out(111 downto 104);
                    p14_0 <= data_out(119 downto 112);
                    p15_0 <= data_out(127 downto 120);
                    p16_0 <= data_out(135 downto 128);
                    p17_0 <= data_out(143 downto 136);
                    p18_0 <= data_out(151 downto 144);
                    p19_0 <= data_out(159 downto 152);
                    p20_0 <= data_out(167 downto 160);
                    p21_0 <= data_out(175 downto 168);
                    p22_0 <= data_out(183 downto 176);
                    p23_0 <= data_out(191 downto 184);
                    p24_0 <= data_out(199 downto 192);
                    p25_0 <= data_out(207 downto 200);
                    p26_0 <= data_out(215 downto 208);
                    p27_0 <= data_out(223 downto 216);
                    p28_0 <= data_out(231 downto 224);
                    p29_0 <= data_out(239 downto 232);
                    p30_0 <= data_out(247 downto 240);
                    p31_0 <= data_out(255 downto 248);
                    p32_0 <= data_out(263 downto 256);
                    p33_0 <= data_out(271 downto 264);
                    p34_0 <= data_out(279 downto 272);
                    p35_0 <= data_out(287 downto 280);
                    p36_0 <= data_out(295 downto 288);
                    p37_0 <= data_out(303 downto 296);
                    p38_0 <= data_out(311 downto 304);
                    p39_0 <= data_out(319 downto 312);
                    p40_0 <= data_out(327 downto 320);
                    p41_0 <= data_out(335 downto 328);
                    p42_0 <= data_out(343 downto 336);
                    p43_0 <= data_out(351 downto 344);
                    p44_0 <= data_out(359 downto 352);
                    p45_0 <= data_out(367 downto 360);
                    p46_0 <= data_out(375 downto 368);
                    p47_0 <= data_out(383 downto 376);
                                        
                    --SUM Pixel0Col1-Pixel1Col1
                    p0_1 <= data_out(391 downto 384);
                    p1_1 <= data_out(399 downto 392);
                    --------------------------------
                    p2_1 <= data_out(407 downto 400);
                    p3_1 <= data_out(415 downto 408);
                    p4_1 <= data_out(423 downto 416);
                    p5_1 <= data_out(431 downto 424);
                    p6_1 <= data_out(439 downto 432);
                    p7_1 <= data_out(447 downto 440);
                    p8_1 <= data_out(455 downto 448);
                    p9_1 <= data_out(463 downto 456);
                    p10_1 <= data_out(471 downto 464);
                    p11_1 <= data_out(479 downto 472);
                    p12_1 <= data_out(487 downto 480);
                    p13_1 <= data_out(495 downto 488);
                    p14_1 <= data_out(503 downto 496);
                    p15_1 <= data_out(511 downto 504);
                    p16_1 <= data_out(519 downto 512);
                    p17_1 <= data_out(527 downto 520);
                    p18_1 <= data_out(535 downto 528);
                    p19_1 <= data_out(543 downto 536);
                    p20_1 <= data_out(551 downto 544);
                    p21_1 <= data_out(559 downto 552);
                    p22_1 <= data_out(567 downto 560);
                    p23_1 <= data_out(575 downto 568);
                    p24_1 <= data_out(583 downto 576);
                    p25_1 <= data_out(591 downto 584);
                    p26_1 <= data_out(599 downto 592);
                    p27_1 <= data_out(607 downto 600);
                    p28_1 <= data_out(615 downto 608);
                    p29_1 <= data_out(623 downto 616);
                    p30_1 <= data_out(631 downto 624);
                    p31_1 <= data_out(639 downto 632);
                    p32_1 <= data_out(647 downto 640);
                    p33_1 <= data_out(655 downto 648);
                    p34_1 <= data_out(663 downto 656);
                    p35_1 <= data_out(671 downto 664);
                    p36_1 <= data_out(679 downto 672);
                    p37_1 <= data_out(687 downto 680);
                    p38_1 <= data_out(695 downto 688);
                    p39_1 <= data_out(703 downto 696);
                    p40_1 <= data_out(711 downto 704);
                    p41_1 <= data_out(719 downto 712);
                    p42_1 <= data_out(727 downto 720);
                    p43_1 <= data_out(735 downto 728);
                    p44_1 <= data_out(743 downto 736);
                    p45_1 <= data_out(751 downto 744);
                    p46_1 <= data_out(759 downto 752);
                    p47_1 <= data_out(767 downto 760);
                    
                    state_read <= s3;
            when s3 =>--ADDER Latency
                    state_read <= s4;
            when s4 =>
                    state_read <= s0;
                    mp_ready <= '1';
        end case;
    end if;
end process;

end arch_IN3EC;