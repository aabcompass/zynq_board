----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/22/2020 02:19:15 PM
-- Design Name: 
-- Module Name: MACROCELL_3x1 - MACROCELL_3X1
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

entity MACROCELL_3x1 is
    Port ( clock : in STD_LOGIC;
           bmp_c : in STD_LOGIC_VECTOR (23 downto 0);
           bmp_ready : in STD_LOGIC;
           mc3x1_0 : out STD_LOGIC_VECTOR (1 downto 0);--Macrocell line0
           mc3x1_1 : out STD_LOGIC_VECTOR (1 downto 0);
           mc3x1_2 : out STD_LOGIC_VECTOR (1 downto 0);
           mc3x1_3 : out STD_LOGIC_VECTOR (1 downto 0);
           mc3x1_4 : out STD_LOGIC_VECTOR (1 downto 0);
           mc3x1_5 : out STD_LOGIC_VECTOR (1 downto 0);
           mc3x1_6 : out STD_LOGIC_VECTOR (1 downto 0);
           mc3x1_7 : out STD_LOGIC_VECTOR (1 downto 0);
           mc3x1_8 : out STD_LOGIC_VECTOR (1 downto 0);
           mc3x1_9 : out STD_LOGIC_VECTOR (1 downto 0);
           mc3x1_10 : out STD_LOGIC_VECTOR (1 downto 0);
           mc3x1_11 : out STD_LOGIC_VECTOR (1 downto 0);
           mc3x1_12 : out STD_LOGIC_VECTOR (1 downto 0);
           mc3x1_13 : out STD_LOGIC_VECTOR (1 downto 0);
           mc3x1_14 : out STD_LOGIC_VECTOR (1 downto 0);
           mc3x1_15 : out STD_LOGIC_VECTOR (1 downto 0);
           mc3x1_16 : out STD_LOGIC_VECTOR (1 downto 0);
           mc3x1_17 : out STD_LOGIC_VECTOR (1 downto 0);
           mc3x1_18 : out STD_LOGIC_VECTOR (1 downto 0);
           mc3x1_19 : out STD_LOGIC_VECTOR (1 downto 0);
           mc3x1_20 : out STD_LOGIC_VECTOR (1 downto 0);
           mc3x1_21 : out STD_LOGIC_VECTOR (1 downto 0);
           mc3x1_ready : out STD_LOGIC);
end MACROCELL_3x1;

architecture MACROCELL_3X1 of MACROCELL_3x1 is
SIGNAL mc3x1tmp_0   :   std_logic_vector(2 downto 0) := ( others => '0');
SIGNAL mc3x1tmp_1   :   std_logic_vector(2 downto 0) := ( others => '0');
SIGNAL mc3x1tmp_2   :   std_logic_vector(2 downto 0) := ( others => '0');
SIGNAL mc3x1tmp_3   :   std_logic_vector(2 downto 0) := ( others => '0');
SIGNAL mc3x1tmp_4   :   std_logic_vector(2 downto 0) := ( others => '0');
SIGNAL mc3x1tmp_5   :   std_logic_vector(2 downto 0) := ( others => '0');
SIGNAL mc3x1tmp_6   :   std_logic_vector(2 downto 0) := ( others => '0');
SIGNAL mc3x1tmp_7   :   std_logic_vector(2 downto 0) := ( others => '0');
SIGNAL mc3x1tmp_8   :   std_logic_vector(2 downto 0) := ( others => '0');
SIGNAL mc3x1tmp_9   :   std_logic_vector(2 downto 0) := ( others => '0');
SIGNAL mc3x1tmp_10   :   std_logic_vector(2 downto 0) := ( others => '0');
SIGNAL mc3x1tmp_11   :   std_logic_vector(2 downto 0) := ( others => '0');
SIGNAL mc3x1tmp_12   :   std_logic_vector(2 downto 0) := ( others => '0');
SIGNAL mc3x1tmp_13   :   std_logic_vector(2 downto 0) := ( others => '0');
SIGNAL mc3x1tmp_14   :   std_logic_vector(2 downto 0) := ( others => '0');
SIGNAL mc3x1tmp_15   :   std_logic_vector(2 downto 0) := ( others => '0');
SIGNAL mc3x1tmp_16   :   std_logic_vector(2 downto 0) := ( others => '0');
SIGNAL mc3x1tmp_17   :   std_logic_vector(2 downto 0) := ( others => '0');
SIGNAL mc3x1tmp_18   :   std_logic_vector(2 downto 0) := ( others => '0');
SIGNAL mc3x1tmp_19   :   std_logic_vector(2 downto 0) := ( others => '0');
SIGNAL mc3x1tmp_20   :   std_logic_vector(2 downto 0) := ( others => '0');
SIGNAL mc3x1tmp_21   :   std_logic_vector(2 downto 0) := ( others => '0');
SIGNAL mc3x1cnt_0   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL mc3x1cnt_1   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL mc3x1cnt_2   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL mc3x1cnt_3   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL mc3x1cnt_4   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL mc3x1cnt_5   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL mc3x1cnt_6   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL mc3x1cnt_7   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL mc3x1cnt_8   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL mc3x1cnt_9   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL mc3x1cnt_10   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL mc3x1cnt_11   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL mc3x1cnt_12   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL mc3x1cnt_13   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL mc3x1cnt_14   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL mc3x1cnt_15   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL mc3x1cnt_16   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL mc3x1cnt_17   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL mc3x1cnt_18   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL mc3x1cnt_19   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL mc3x1cnt_20   :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL mc3x1cnt_21   :   std_logic_vector(1 downto 0) := ( others => '0');

type state_macropixel_type is (s0,s1,s2,s3,s4);
signal  state_macropixel    :   state_macropixel_type := s0;

begin

macrocell_3x1_calc : process (clock)
begin
    if (clock'event and clock = '1') then
        case (state_macropixel) is
            when s0 =>
                if (bmp_ready = '1') then
                    mc3x1tmp_0  <= bmp_c(2 downto 0);
                    mc3x1tmp_1  <= bmp_c(3 downto 1);
                    mc3x1tmp_2  <= bmp_c(4 downto 2);
                    mc3x1tmp_3  <= bmp_c(5 downto 3);
                    mc3x1tmp_4  <= bmp_c(6 downto 4);
                    mc3x1tmp_5  <= bmp_c(7 downto 5);
                    mc3x1tmp_6  <= bmp_c(8 downto 6);
                    mc3x1tmp_7  <= bmp_c(9 downto 7);
                    mc3x1tmp_8  <= bmp_c(10 downto 8);
                    mc3x1tmp_9  <= bmp_c(11 downto 9);
                    mc3x1tmp_10 <= bmp_c(12 downto 10);
                    mc3x1tmp_11 <= bmp_c(13 downto 11);
                    mc3x1tmp_12 <= bmp_c(14 downto 12);
                    mc3x1tmp_13 <= bmp_c(15 downto 13);
                    mc3x1tmp_14 <= bmp_c(16 downto 14);
                    mc3x1tmp_15 <= bmp_c(17 downto 15);
                    mc3x1tmp_16 <= bmp_c(18 downto 16);
                    mc3x1tmp_17 <= bmp_c(19 downto 17);
                    mc3x1tmp_18 <= bmp_c(20 downto 18);
                    mc3x1tmp_19 <= bmp_c(21 downto 19);
                    mc3x1tmp_20 <= bmp_c(22 downto 20);
                    mc3x1tmp_21 <= bmp_c(23 downto 21);
                    state_macropixel <= s1;
                end if;
                mc3x1_ready <= '0';
                mc3x1cnt_0 <= "00";
                mc3x1cnt_1 <= "00";
                mc3x1cnt_2 <= "00";
                mc3x1cnt_3 <= "00";
                mc3x1cnt_4 <= "00";
                mc3x1cnt_5 <= "00";
                mc3x1cnt_6 <= "00";
                mc3x1cnt_7 <= "00";
                mc3x1cnt_8 <= "00";
                mc3x1cnt_9 <= "00";
                mc3x1cnt_10 <= "00";
                mc3x1cnt_11 <= "00";
                mc3x1cnt_12 <= "00";
                mc3x1cnt_13 <= "00";
                mc3x1cnt_14 <= "00";
                mc3x1cnt_15 <= "00";
                mc3x1cnt_16 <= "00";
                mc3x1cnt_17 <= "00";
                mc3x1cnt_18 <= "00";
                mc3x1cnt_19 <= "00";
                mc3x1cnt_20 <= "00";
                mc3x1cnt_21 <= "00";
            when s1 =>
                if (mc3x1tmp_0(0) = '1') then
                    mc3x1cnt_0 <= mc3x1cnt_0 + 1;
                end if;
                if (mc3x1tmp_1(0) = '1') then
                    mc3x1cnt_1 <= mc3x1cnt_1 + 1;
                end if;
                if (mc3x1tmp_2(0) = '1') then
                    mc3x1cnt_2 <= mc3x1cnt_2 + 1;
                end if;
                if (mc3x1tmp_2(0) = '1') then
                    mc3x1cnt_2 <= mc3x1cnt_2 + 1;
                end if;
                if (mc3x1tmp_3(0) = '1') then
                    mc3x1cnt_3 <= mc3x1cnt_3 + 1;
                end if;
                if (mc3x1tmp_4(0) = '1') then
                    mc3x1cnt_4 <= mc3x1cnt_4 + 1;
                end if;
                if (mc3x1tmp_5(0) = '1') then
                    mc3x1cnt_5 <= mc3x1cnt_5 + 1;
                end if;
                if (mc3x1tmp_6(0) = '1') then
                    mc3x1cnt_6 <= mc3x1cnt_6 + 1;
                end if;
                if (mc3x1tmp_7(0) = '1') then
                    mc3x1cnt_7 <= mc3x1cnt_7 + 1;
                end if;
                if (mc3x1tmp_8(0) = '1') then
                    mc3x1cnt_8 <= mc3x1cnt_8 + 1;
                end if;
                if (mc3x1tmp_9(0) = '1') then
                    mc3x1cnt_9 <= mc3x1cnt_9 + 1;
                end if;
                if (mc3x1tmp_10(0) = '1') then
                    mc3x1cnt_10 <= mc3x1cnt_10 + 1;
                end if;
                if (mc3x1tmp_11(0) = '1') then
                    mc3x1cnt_11 <= mc3x1cnt_11 + 1;
                end if;
                if (mc3x1tmp_12(0) = '1') then
                    mc3x1cnt_12 <= mc3x1cnt_12 + 1;
                end if;
                if (mc3x1tmp_13(0) = '1') then
                    mc3x1cnt_13 <= mc3x1cnt_13 + 1;
                end if;
                if (mc3x1tmp_14(0) = '1') then
                    mc3x1cnt_14 <= mc3x1cnt_14 + 1;
                end if;
                if (mc3x1tmp_15(0) = '1') then
                    mc3x1cnt_15 <= mc3x1cnt_15 + 1;
                end if;
                if (mc3x1tmp_16(0) = '1') then
                    mc3x1cnt_16 <= mc3x1cnt_16 + 1;
                end if;
                if (mc3x1tmp_17(0) = '1') then
                    mc3x1cnt_17 <= mc3x1cnt_17 + 1;
                end if;
                if (mc3x1tmp_18(0) = '1') then
                    mc3x1cnt_18 <= mc3x1cnt_18 + 1;
                end if;
                if (mc3x1tmp_19(0) = '1') then
                    mc3x1cnt_19 <= mc3x1cnt_19 + 1;
                end if;
                if (mc3x1tmp_20(0) = '1') then
                    mc3x1cnt_20 <= mc3x1cnt_20 + 1;
                end if;
                if (mc3x1tmp_21(0) = '1') then
                    mc3x1cnt_21 <= mc3x1cnt_21 + 1;
                end if;
                
                state_macropixel <= s2;
            when s2 =>
                if (mc3x1tmp_0(1) = '1') then
                    mc3x1cnt_0 <= mc3x1cnt_0 + 1;
                end if;
                if (mc3x1tmp_1(1) = '1') then
                    mc3x1cnt_1 <= mc3x1cnt_1 + 1;
                end if;
                if (mc3x1tmp_2(1) = '1') then
                    mc3x1cnt_2 <= mc3x1cnt_2 + 1;
                end if;
                if (mc3x1tmp_2(1) = '1') then
                    mc3x1cnt_2 <= mc3x1cnt_2 + 1;
                end if;
                if (mc3x1tmp_3(1) = '1') then
                    mc3x1cnt_3 <= mc3x1cnt_3 + 1;
                end if;
                if (mc3x1tmp_4(1) = '1') then
                    mc3x1cnt_4 <= mc3x1cnt_4 + 1;
                end if;
                if (mc3x1tmp_5(1) = '1') then
                    mc3x1cnt_5 <= mc3x1cnt_5 + 1;
                end if;
                if (mc3x1tmp_6(1) = '1') then
                    mc3x1cnt_6 <= mc3x1cnt_6 + 1;
                end if;
                if (mc3x1tmp_7(1) = '1') then
                    mc3x1cnt_7 <= mc3x1cnt_7 + 1;
                end if;
                if (mc3x1tmp_8(1) = '1') then
                    mc3x1cnt_8 <= mc3x1cnt_8 + 1;
                end if;
                if (mc3x1tmp_9(1) = '1') then
                    mc3x1cnt_9 <= mc3x1cnt_9 + 1;
                end if;
                if (mc3x1tmp_10(1) = '1') then
                    mc3x1cnt_10 <= mc3x1cnt_10 + 1;
                end if;
                if (mc3x1tmp_11(1) = '1') then
                    mc3x1cnt_11 <= mc3x1cnt_11 + 1;
                end if;
                if (mc3x1tmp_12(1) = '1') then
                    mc3x1cnt_12 <= mc3x1cnt_12 + 1;
                end if;
                if (mc3x1tmp_13(1) = '1') then
                    mc3x1cnt_13 <= mc3x1cnt_13 + 1;
                end if;
                if (mc3x1tmp_14(1) = '1') then
                    mc3x1cnt_14 <= mc3x1cnt_14 + 1;
                end if;
                if (mc3x1tmp_15(1) = '1') then
                    mc3x1cnt_15 <= mc3x1cnt_15 + 1;
                end if;
                if (mc3x1tmp_16(1) = '1') then
                    mc3x1cnt_16 <= mc3x1cnt_16 + 1;
                end if;
                if (mc3x1tmp_17(1) = '1') then
                    mc3x1cnt_17 <= mc3x1cnt_17 + 1;
                end if;
                if (mc3x1tmp_18(1) = '1') then
                    mc3x1cnt_18 <= mc3x1cnt_18 + 1;
                end if;
                if (mc3x1tmp_19(1) = '1') then
                    mc3x1cnt_19 <= mc3x1cnt_19 + 1;
                end if;
                if (mc3x1tmp_20(1) = '1') then
                    mc3x1cnt_20 <= mc3x1cnt_20 + 1;
                end if;
                if (mc3x1tmp_21(1) = '1') then
                    mc3x1cnt_21 <= mc3x1cnt_21 + 1;
                end if;
            
                state_macropixel <= s3;
            when s3 =>
                if (mc3x1tmp_0(2) = '1') then
                    mc3x1cnt_0 <= mc3x1cnt_0 + 1;
                end if;
                if (mc3x1tmp_1(2) = '1') then
                    mc3x1cnt_1 <= mc3x1cnt_1 + 1;
                end if;
                if (mc3x1tmp_2(2) = '1') then
                    mc3x1cnt_2 <= mc3x1cnt_2 + 1;
                end if;
                if (mc3x1tmp_2(2) = '1') then
                    mc3x1cnt_2 <= mc3x1cnt_2 + 1;
                end if;
                if (mc3x1tmp_3(2) = '1') then
                    mc3x1cnt_3 <= mc3x1cnt_3 + 1;
                end if;
                if (mc3x1tmp_4(2) = '1') then
                    mc3x1cnt_4 <= mc3x1cnt_4 + 1;
                end if;
                if (mc3x1tmp_5(2) = '1') then
                    mc3x1cnt_5 <= mc3x1cnt_5 + 1;
                end if;
                if (mc3x1tmp_6(2) = '1') then
                    mc3x1cnt_6 <= mc3x1cnt_6 + 1;
                end if;
                if (mc3x1tmp_7(2) = '1') then
                    mc3x1cnt_7 <= mc3x1cnt_7 + 1;
                end if;
                if (mc3x1tmp_8(2) = '1') then
                    mc3x1cnt_8 <= mc3x1cnt_8 + 1;
                end if;
                if (mc3x1tmp_9(2) = '1') then
                    mc3x1cnt_9 <= mc3x1cnt_9 + 1;
                end if;
                if (mc3x1tmp_10(2) = '1') then
                    mc3x1cnt_10 <= mc3x1cnt_10 + 1;
                end if;
                if (mc3x1tmp_11(2) = '1') then
                    mc3x1cnt_11 <= mc3x1cnt_11 + 1;
                end if;
                if (mc3x1tmp_12(2) = '1') then
                    mc3x1cnt_12 <= mc3x1cnt_12 + 1;
                end if;
                if (mc3x1tmp_13(2) = '1') then
                    mc3x1cnt_13 <= mc3x1cnt_13 + 1;
                end if;
                if (mc3x1tmp_14(2) = '1') then
                    mc3x1cnt_14 <= mc3x1cnt_14 + 1;
                end if;
                if (mc3x1tmp_15(2) = '1') then
                    mc3x1cnt_15 <= mc3x1cnt_15 + 1;
                end if;
                if (mc3x1tmp_16(2) = '1') then
                    mc3x1cnt_16 <= mc3x1cnt_16 + 1;
                end if;
                if (mc3x1tmp_17(2) = '1') then
                    mc3x1cnt_17 <= mc3x1cnt_17 + 1;
                end if;
                if (mc3x1tmp_18(2) = '1') then
                    mc3x1cnt_18 <= mc3x1cnt_18 + 1;
                end if;
                if (mc3x1tmp_19(2) = '1') then
                    mc3x1cnt_19 <= mc3x1cnt_19 + 1;
                end if;
                if (mc3x1tmp_20(2) = '1') then
                    mc3x1cnt_20 <= mc3x1cnt_20 + 1;
                end if;
                if (mc3x1tmp_21(2) = '1') then
                    mc3x1cnt_21 <= mc3x1cnt_21 + 1;
                end if;
                
                state_macropixel <= s4;
            when s4 =>
                mc3x1_0 <= mc3x1cnt_0;
                mc3x1_1 <= mc3x1cnt_1;
                mc3x1_2 <= mc3x1cnt_2;
                mc3x1_3 <= mc3x1cnt_3;
                mc3x1_4 <= mc3x1cnt_4;
                mc3x1_5 <= mc3x1cnt_5;
                mc3x1_6 <= mc3x1cnt_6;
                mc3x1_7 <= mc3x1cnt_7;
                mc3x1_8 <= mc3x1cnt_8;
                mc3x1_9 <= mc3x1cnt_9;
                mc3x1_10 <= mc3x1cnt_10;
                mc3x1_11 <= mc3x1cnt_11;
                mc3x1_12 <= mc3x1cnt_12;
                mc3x1_13 <= mc3x1cnt_13;
                mc3x1_14 <= mc3x1cnt_14;
                mc3x1_15 <= mc3x1cnt_15;
                mc3x1_16 <= mc3x1cnt_16;
                mc3x1_17 <= mc3x1cnt_17;
                mc3x1_18 <= mc3x1cnt_18;
                mc3x1_19 <= mc3x1cnt_19;
                mc3x1_20 <= mc3x1cnt_20;
                mc3x1_21 <= mc3x1cnt_21;
                mc3x1_ready <= '1';
                state_macropixel <= s0;
            end case;
    end if;
end process;


end MACROCELL_3X1;
