----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.07.2022 09:22:06
-- Design Name: 
-- Module Name: KI_Trigger - Behavioral
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

entity KI_Trigger is
    Port ( clk_200 : in STD_LOGIC;
           clk_100 : in STD_LOGIC;
           data_spb2_ki : in STD_LOGIC_VECTOR (17 downto 0);
           frame_ki : in STD_LOGIC;
           --AXI FIFO KI COMMAND
           s_aclk_cmd_ki        :   in  std_logic;
           s_aresetn_cmd_ki     :   in  std_logic;
           s_axis_tvalid_cmd_ki :   in  std_logic;
           s_axis_tready_cmd_ki :   out std_logic;
           s_axis_tdata_cmd_ki  :   in  std_logic_vector(31 downto 0);
           s_axis_tlast_cmd_ki  :   in  std_logic;
           --AXI FIFO KI TRIGGER OUT
           m_aclk_trg_ki        :   in  std_logic;
           m_axis_tvalid_trg_ki :   out std_logic;
           m_axis_tready_trg_ki :   in  std_logic;
           m_axis_tdata_trg_ki  :   out std_logic_vector(31 downto 0);
           m_axis_tlast_trg_ki  :   out std_logic);
end KI_Trigger;

architecture arch_KI_Trigger of KI_Trigger is

CONSTANT last_frame      : std_logic_vector (6 downto 0) := "1111111";--127 Last GTU 

SIGNAL  m_axis_tvalid_cmd_ki           :   std_logic := '0';
SIGNAL  m_axis_tready_cmd_ki           :   std_logic := '0';
SIGNAL  m_axis_tdata_cmd_ki            :   std_logic_vector(31 downto 0) := ( others => '0');
SIGNAL  m_axis_tlast_cmd_ki            :   std_logic := '0';

SIGNAL  s_aresetn_trg_ki               :   std_logic := '1';
SIGNAL  s_axis_tvalid_trg_ki           :   std_logic := '0';
SIGNAL  s_axis_tready_trg_ki           :   std_logic := '0';
SIGNAL  s_axis_tdata_trg_ki            :   std_logic_vector(31 downto 0) := ( others => '0');
SIGNAL  s_axis_tlast_trg_ki            :   std_logic := '0';

SIGNAL  frame_cnt                      :   std_logic_vector(6 downto 0) := "1111111";--127

--DEFAULT THR
SIGNAL  pixel_thr_EC0                  :   std_logic_vector(5 downto 0) := "000111";--Pixel_THR=7
SIGNAL  ncounter_thr_EC0               :   std_logic_vector(6 downto 0) := "0000010";--Ncounter_THR=2
SIGNAL  pixel_thr_EC1                  :   std_logic_vector(5 downto 0) := "000111";
SIGNAL  ncounter_thr_EC1               :   std_logic_vector(6 downto 0) := "0000010";
SIGNAL  pixel_thr_EC2                  :   std_logic_vector(5 downto 0) := "000111";
SIGNAL  ncounter_thr_EC2               :   std_logic_vector(6 downto 0) := "0000010";
SIGNAL  pixel_thr_EC3                  :   std_logic_vector(5 downto 0) := "000111";
SIGNAL  ncounter_thr_EC3               :   std_logic_vector(6 downto 0) := "0000010";
SIGNAL  pixel_thr_EC4                  :   std_logic_vector(5 downto 0) := "000111";
SIGNAL  ncounter_thr_EC4               :   std_logic_vector(6 downto 0) := "0000010";
SIGNAL  pixel_thr_EC5                  :   std_logic_vector(5 downto 0) := "000111";
SIGNAL  ncounter_thr_EC5               :   std_logic_vector(6 downto 0) := "0000010";
SIGNAL  pixel_thr_EC6                  :   std_logic_vector(5 downto 0) := "000111";
SIGNAL  ncounter_thr_EC6               :   std_logic_vector(6 downto 0) := "0000010";
SIGNAL  pixel_thr_EC7                  :   std_logic_vector(5 downto 0) := "000111";
SIGNAL  ncounter_thr_EC7               :   std_logic_vector(6 downto 0) := "0000010";
SIGNAL  pixel_thr_EC8                  :   std_logic_vector(5 downto 0) := "000111";
SIGNAL  ncounter_thr_EC8               :   std_logic_vector(6 downto 0) := "0000010";

SIGNAL  pixel_value0                   :   std_logic_vector(5 downto 0) := ( others => '0');
SIGNAL  pixel_value1                   :   std_logic_vector(5 downto 0) := ( others => '0');
SIGNAL  pixel_value2                   :   std_logic_vector(5 downto 0) := ( others => '0');
SIGNAL  pixel_value3                   :   std_logic_vector(5 downto 0) := ( others => '0');
SIGNAL  pixel_value4                   :   std_logic_vector(5 downto 0) := ( others => '0');
SIGNAL  pixel_value5                   :   std_logic_vector(5 downto 0) := ( others => '0');
SIGNAL  pixel_value6                   :   std_logic_vector(5 downto 0) := ( others => '0');
SIGNAL  pixel_value7                   :   std_logic_vector(5 downto 0) := ( others => '0');
SIGNAL  pixel_value8                   :   std_logic_vector(5 downto 0) := ( others => '0');
SIGNAL  pixel_value9                   :   std_logic_vector(5 downto 0) := ( others => '0');
SIGNAL  pixel_value10                  :   std_logic_vector(5 downto 0) := ( others => '0');
SIGNAL  pixel_value11                  :   std_logic_vector(5 downto 0) := ( others => '0');
SIGNAL  pixel_value12                  :   std_logic_vector(5 downto 0) := ( others => '0');
SIGNAL  pixel_value13                  :   std_logic_vector(5 downto 0) := ( others => '0');
SIGNAL  pixel_value14                  :   std_logic_vector(5 downto 0) := ( others => '0');
SIGNAL  pixel_value15                  :   std_logic_vector(5 downto 0) := ( others => '0');
SIGNAL  pixel_value16                  :   std_logic_vector(5 downto 0) := ( others => '0');
SIGNAL  pixel_value17                  :   std_logic_vector(5 downto 0) := ( others => '0');

SIGNAL  pixel_rdy                      :   std_logic := '0';
SIGNAL  bitcount                       :   std_logic_vector(2 downto 0) := ( others => '0');

SIGNAL  din_3EC_ki                     :   std_logic_vector(107 downto 0) := ( others => '0');
SIGNAL  wr_en                          :   std_logic   :=  '0';
SIGNAL  rd_en                          :   std_logic   :=  '0';
SIGNAL  data_out_ki                    :   std_logic_vector(107 downto 0) := ( others => '0');
SIGNAL  empty                          :   std_logic   :=  '0';

SIGNAL  reg_EC0                        :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  reg_EC1                        :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  reg_EC2                        :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  reg_EC3                        :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  reg_EC4                        :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  reg_EC5                        :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  reg_EC6                        :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  reg_EC7                        :   std_logic_vector(1 downto 0) := ( others => '0');
SIGNAL  reg_EC8                        :   std_logic_vector(1 downto 0) := ( others => '0');

SIGNAL  col_count                      :   std_logic_vector(3 downto 0) := ( others => '0');

SIGNAL  Ncounter_EC0                   :   std_logic_vector(6 downto 0) := ( others => '0');
SIGNAL  Ncounter_EC1                   :   std_logic_vector(6 downto 0) := ( others => '0');
SIGNAL  Ncounter_EC2                   :   std_logic_vector(6 downto 0) := ( others => '0');
SIGNAL  Ncounter_EC3                   :   std_logic_vector(6 downto 0) := ( others => '0');
SIGNAL  Ncounter_EC4                   :   std_logic_vector(6 downto 0) := ( others => '0');
SIGNAL  Ncounter_EC5                   :   std_logic_vector(6 downto 0) := ( others => '0');
SIGNAL  Ncounter_EC6                   :   std_logic_vector(6 downto 0) := ( others => '0');
SIGNAL  Ncounter_EC7                   :   std_logic_vector(6 downto 0) := ( others => '0');
SIGNAL  Ncounter_EC8                   :   std_logic_vector(6 downto 0) := ( others => '0');

SIGNAL  EC_trigger_reg                 :   std_logic_vector(8 downto 0) := ( others => '0');

TYPE    state_read_cmd_type    is  (s0,s1);
SIGNAL  state_read_cmd :   state_read_cmd_type := s0;

TYPE    state_frame_type    is  (s0,s1);
SIGNAL  state_frame :   state_frame_type := s0;

TYPE    state_write_type is  (s0,s1);
SIGNAL  state_write  :  state_write_type := s0;
TYPE    state_read_type is  (s0,s1,s2,s3,s4,s5);
SIGNAL  state_read  :  state_read_type := s0;

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

COMPONENT fifo_pixel_ki
  PORT (
    wr_clk : IN STD_LOGIC;
    rd_clk : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(107 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(107 DOWNTO 0);
    full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC
  );
END COMPONENT;

	signal clock, clk_133: std_logic;

begin

	clock <= clk_100;
	clk_133 <= clk_200;

AXI_FIFO_CMD : AXI_FIFO
PORT MAP (
  wr_rst_busy => open,
  rd_rst_busy => open,
  m_aclk => CLOCK,
  s_aclk => s_aclk_cmd_ki,-->PROC.
  s_aresetn => s_aresetn_cmd_ki,-->PROC.
  s_axis_tvalid => s_axis_tvalid_cmd_ki,-->PROC.
  s_axis_tready => s_axis_tready_cmd_ki,-->PROC.
  s_axis_tdata => s_axis_tdata_cmd_ki,-->PROC.
  s_axis_tlast => s_axis_tlast_cmd_ki,-->PROC.
  m_axis_tvalid => m_axis_tvalid_cmd_ki,
  m_axis_tready => m_axis_tready_cmd_ki,
  m_axis_tdata => m_axis_tdata_cmd_ki,
  m_axis_tlast => m_axis_tlast_cmd_ki
);

AXI_FIFO_TRIG : AXI_FIFO
    PORT MAP (
      wr_rst_busy => open,
      rd_rst_busy => open,
      m_aclk => m_aclk_trg_ki,-->PROC.
      s_aclk => CLOCK,
      s_aresetn => s_aresetn_trg_ki,
      s_axis_tvalid => s_axis_tvalid_trg_ki,
      s_axis_tready => s_axis_tready_trg_ki,
      s_axis_tdata => s_axis_tdata_trg_ki,
      s_axis_tlast => s_axis_tlast_trg_ki,
      m_axis_tvalid => m_axis_tvalid_trg_ki,-->PROC.
      m_axis_tready => m_axis_tready_trg_ki,-->PROC.
      m_axis_tdata => m_axis_tdata_trg_ki,-->PROC.
      m_axis_tlast => m_axis_tlast_trg_ki-->PROC.
);

FIFO_9EC_KI : fifo_pixel_ki
PORT MAP (
    wr_clk => clk_133,
    rd_clk => clock,
    din => din_3EC_ki,
    wr_en => wr_en,
    rd_en => rd_en,
    dout => data_out_ki,
    full => open,
    empty => empty
);

frame_counter : process (clk_133)
begin 
    if (clk_133'event and clk_133 = '1') then
        case (state_frame) is
            when s0 =>
                if (frame_ki = '1') then
                    if (frame_cnt = last_frame) then
                        frame_cnt <= "0000000";--FIRST GTU
                    else
                        frame_cnt <= frame_cnt + 1;
                    end if;
                    state_frame <= s1;
                end if;
            when s1 =>
                if (frame_ki = '0') then
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
                if ( m_axis_tvalid_cmd_ki = '1' and frame_cnt = "0000000" ) then --Word in Command FIFO and acquisition start
                    m_axis_tready_cmd_ki <= '1';--Read the word
                    state_read_cmd <= s1;
                end if;
            when s1 =>
                m_axis_tready_cmd_ki <= '0';
                case m_axis_tdata_cmd_ki(16 downto 13) is
                    when "0000" => --EC0
                        pixel_thr_EC0       <= m_axis_tdata_cmd_ki(5 downto 0);
                        ncounter_thr_EC0    <= m_axis_tdata_cmd_ki(12 downto 6);
                    when "0001" => --EC1
                        pixel_thr_EC1       <= m_axis_tdata_cmd_ki(5 downto 0);
                        ncounter_thr_EC1    <= m_axis_tdata_cmd_ki(12 downto 6);
                    when "0010" => --EC2
                        pixel_thr_EC2       <= m_axis_tdata_cmd_ki(5 downto 0);
                        ncounter_thr_EC2    <= m_axis_tdata_cmd_ki(12 downto 6);
                    when "0011" => --EC3
                        pixel_thr_EC3       <= m_axis_tdata_cmd_ki(5 downto 0);
                        ncounter_thr_EC3    <= m_axis_tdata_cmd_ki(12 downto 6);
                    when "0100" => --EC4
                        pixel_thr_EC4       <= m_axis_tdata_cmd_ki(5 downto 0);
                        ncounter_thr_EC4    <= m_axis_tdata_cmd_ki(12 downto 6);
                    when "0101" => --EC5
                        pixel_thr_EC5       <= m_axis_tdata_cmd_ki(5 downto 0);
                        ncounter_thr_EC5    <= m_axis_tdata_cmd_ki(12 downto 6);
                    when "0110" => --EC6
                        pixel_thr_EC6       <= m_axis_tdata_cmd_ki(5 downto 0);
                        ncounter_thr_EC6    <= m_axis_tdata_cmd_ki(12 downto 6);
                    when "0111" => --EC7
                        pixel_thr_EC7       <= m_axis_tdata_cmd_ki(5 downto 0);
                        ncounter_thr_EC7    <= m_axis_tdata_cmd_ki(12 downto 6);
                    when "1000" => --EC8
                        pixel_thr_EC8       <= m_axis_tdata_cmd_ki(5 downto 0);
                        ncounter_thr_EC8    <= m_axis_tdata_cmd_ki(12 downto 6);
                    when others =>
                        null;
                end case;
                state_read_cmd <= s0;
        end case;
    end if;
end process;

--Serial PIXEL BIT IN to PIXEL (SIPO)
sipo_s : process (clk_133)
begin 
    if (clk_133'event and clk_133 = '1') then
        if (frame_ki = '1') then
            --Shift register
            pixel_value0  <= data_spb2_ki(0) & pixel_value0(5 downto 1);
            pixel_value1  <= data_spb2_ki(1) & pixel_value1(5 downto 1);
            pixel_value2  <= data_spb2_ki(2) & pixel_value2(5 downto 1);
            pixel_value3  <= data_spb2_ki(3) & pixel_value3(5 downto 1);
            pixel_value4  <= data_spb2_ki(4) & pixel_value4(5 downto 1);
            pixel_value5  <= data_spb2_ki(5) & pixel_value5(5 downto 1);
            pixel_value6  <= data_spb2_ki(6) & pixel_value6(5 downto 1);
            pixel_value7  <= data_spb2_ki(7) & pixel_value7(5 downto 1);
            pixel_value8  <= data_spb2_ki(8) & pixel_value8(5 downto 1);
            pixel_value9  <= data_spb2_ki(9) & pixel_value9(5 downto 1);
            pixel_value10 <= data_spb2_ki(10) & pixel_value10(5 downto 1);
            pixel_value11 <= data_spb2_ki(11) & pixel_value11(5 downto 1);
            pixel_value12 <= data_spb2_ki(12) & pixel_value12(5 downto 1);
            pixel_value13 <= data_spb2_ki(13) & pixel_value13(5 downto 1);
            pixel_value14 <= data_spb2_ki(14) & pixel_value14(5 downto 1);
            pixel_value15 <= data_spb2_ki(15) & pixel_value15(5 downto 1);
            pixel_value16 <= data_spb2_ki(16) & pixel_value16(5 downto 1);
            pixel_value17 <= data_spb2_ki(17) & pixel_value17(5 downto 1);
            
            if (bitcount = "101") then  --Now we have 5 bits ready in "pixel_value"
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

fifopixel_ki_write : process (clk_133)
--Write pixel "column" in FIFO
begin 
if (clk_133'event and clk_133 = '1') then
    case (state_write) is
        when s0 =>
            if (pixel_rdy = '1') then
                din_3EC_ki(5 downto 0) <= pixel_value0;
                din_3EC_ki(11 downto 6) <= pixel_value1;
                din_3EC_ki(17 downto 12) <= pixel_value2;
                din_3EC_ki(23 downto 18) <= pixel_value3;
                din_3EC_ki(29 downto 24) <= pixel_value4;
                din_3EC_ki(35 downto 30) <= pixel_value5;
                din_3EC_ki(41 downto 36) <= pixel_value6;
                din_3EC_ki(47 downto 42) <= pixel_value7;
                din_3EC_ki(53 downto 48) <= pixel_value8;
                din_3EC_ki(59 downto 54) <= pixel_value9;
                din_3EC_ki(65 downto 60) <= pixel_value10;
                din_3EC_ki(71 downto 66) <= pixel_value11;
                din_3EC_ki(77 downto 72) <= pixel_value12;
                din_3EC_ki(83 downto 78) <= pixel_value13;
                din_3EC_ki(89 downto 84) <= pixel_value14;
                din_3EC_ki(95 downto 90) <= pixel_value15;
                din_3EC_ki(101 downto 96) <= pixel_value16;
                din_3EC_ki(107 downto 102) <= pixel_value17;
                
                state_write <= s1;
            else
                wr_en <= '0';
            end if;
        when s1 =>
            wr_en <= '1';--Write
            state_write <= s0;
        end case;
end if;
end process;

fifopixel_ki_read : process (clock)
--Read pixel column in FIFO
begin 
    if (clock'event and clock = '1') then
        case (state_read) is
            when s0 =>
                if (empty = '0') then
                    rd_en <= '1';--Read FIFO
                    state_read <= s1;
                end if;
            when s1 =>--FIFO Latency
                rd_en <= '0';
                state_read <= s2;
            when s2 =>--PIXEL from FIFO is ready, CHECK PIXEL aganist THR
                if ((data_out_ki(5 downto 0) > pixel_thr_EC0) or (data_out_ki(5 downto 0) = "000000")) then
                    reg_EC0(0) <= '1';--Pixel register EC0 0:15
                end if;
                if ((data_out_ki(11 downto 6) > pixel_thr_EC0) or (data_out_ki(11 downto 6) = "000000")) then
                    reg_EC0(1) <= '1';--Pixel register EC0 16:31
                end if;
                
                if ((data_out_ki(17 downto 12) > pixel_thr_EC3) or (data_out_ki(17 downto 12) = "000000")) then
                    reg_EC3(0) <= '1';--Pixel register EC3 0:15
                end if;
                if ((data_out_ki(23 downto 18) > pixel_thr_EC3) or (data_out_ki(23 downto 18) = "000000")) then
                    reg_EC3(1) <= '1';--Pixel register EC3 16:31
                end if;
                
                if ((data_out_ki(29 downto 24) > pixel_thr_EC6) or (data_out_ki(29 downto 24) = "000000")) then
                    reg_EC6(0) <= '1';--Pixel register EC6 0:15
                end if;
                if ((data_out_ki(35 downto 30) > pixel_thr_EC6) or (data_out_ki(35 downto 30) = "000000")) then
                    reg_EC6(1) <= '1';--Pixel register EC6 16:31
                end if;
                
                if ((data_out_ki(41 downto 36) > pixel_thr_EC1) or (data_out_ki(41 downto 36) = "000000")) then
                    reg_EC1(0) <= '1';--Pixel register EC1 0:15
                end if;
                if ((data_out_ki(47 downto 42) > pixel_thr_EC1) or (data_out_ki(47 downto 42) = "000000")) then
                    reg_EC1(1) <= '1';--Pixel register EC1 16:31
                end if;
                
                if ((data_out_ki(53 downto 48) > pixel_thr_EC4) or (data_out_ki(53 downto 48) = "000000")) then
                    reg_EC4(0) <= '1';--Pixel register EC4 0:15
                end if;
                if ((data_out_ki(59 downto 54) > pixel_thr_EC4) or (data_out_ki(59 downto 54) = "000000")) then
                    reg_EC4(1) <= '1';--Pixel register EC4 16:31
                end if;
                
                if ((data_out_ki(65 downto 60) > pixel_thr_EC7) or (data_out_ki(65 downto 60) = "000000")) then
                    reg_EC7(0) <= '1';--Pixel register EC7 0:15
                end if;
                if ((data_out_ki(71 downto 66) > pixel_thr_EC7) or (data_out_ki(71 downto 66) = "000000")) then
                    reg_EC7(1) <= '1';--Pixel register EC7 16:31
                end if;
                
                if ((data_out_ki(77 downto 72) > pixel_thr_EC2) or (data_out_ki(77 downto 72) = "000000")) then
                    reg_EC2(0) <= '1';--Pixel register EC2 0:15
                end if;
                if ((data_out_ki(83 downto 78) > pixel_thr_EC2) or (data_out_ki(83 downto 78) = "000000")) then
                    reg_EC2(1) <= '1';--Pixel register EC2 16:31
                end if;
                
                if ((data_out_ki(89 downto 84) > pixel_thr_EC5) or (data_out_ki(89 downto 84) = "000000")) then
                    reg_EC5(0) <= '1';--Pixel register EC5 0:15
                end if;
                if ((data_out_ki(95 downto 90) > pixel_thr_EC5) or (data_out_ki(95 downto 90) = "000000")) then
                    reg_EC5(1) <= '1';--Pixel register EC5 16:31
                end if;
                
                if ((data_out_ki(101 downto 96) > pixel_thr_EC8) or (data_out_ki(101 downto 96) = "000000")) then
                    reg_EC8(0) <= '1';--Pixel register EC8 0:15
                end if;
                if ((data_out_ki(107 downto 102) > pixel_thr_EC8) or (data_out_ki(107 downto 102) = "000000")) then
                    reg_EC8(1) <= '1';--Pixel register EC8 16:31
                end if;
                
                if (col_count < "1111") then
                    col_count <= col_count + 1;
                    state_read <= s0;
                else--EC END (16 column)
                    col_count <= "0000";
                    state_read <= s3;
                end if;
                    
            when s3 =>--CHECK TRIGGER
                if (reg_EC0 > "00") then--Ncounter EC0 increment
                    if (Ncounter_EC0 = "1111111") then--127
                        Ncounter_EC0 <= "0001000";--8
                    else
                        Ncounter_EC0 <= Ncounter_EC0 + 1;
                    end if;
                    reg_EC0 <= "00";
                else--Check Trigger
                    if ((Ncounter_EC0 <= ncounter_thr_EC0) and (Ncounter_EC0 > "0000000")) then
                        EC_trigger_reg(0) <= '1';--TRIGGER EC0
                    end if;
                    Ncounter_EC0 <= "0000000";
                end if;
                
                if (reg_EC1 > "00") then--Ncounter EC1 increment
                    if (Ncounter_EC1 = "1111111") then--127
                        Ncounter_EC1 <= "0001000";--8
                    else
                        Ncounter_EC1 <= Ncounter_EC1 + 1;
                    end if;
                    reg_EC1 <= "00";
                else--Check Trigger
                    if ((Ncounter_EC1 <= ncounter_thr_EC1) and (Ncounter_EC1 > "0000000")) then
                        EC_trigger_reg(1) <= '1';--TRIGGER EC1
                    end if;
                    Ncounter_EC1 <= "0000000";
                end if;
                
                if (reg_EC2 > "00") then--Ncounter EC2 increment
                    if (Ncounter_EC2 = "1111111") then--127
                        Ncounter_EC2 <= "0001000";--8
                    else
                        Ncounter_EC2 <= Ncounter_EC2 + 1;
                    end if;
                    reg_EC2 <= "00";
                else--Check Trigger
                    if ((Ncounter_EC2 <= ncounter_thr_EC2) and (Ncounter_EC2 > "0000000")) then
                        EC_trigger_reg(2) <= '1';--TRIGGER EC2
                    end if;
                    Ncounter_EC2 <= "0000000";
                end if;
                
                if (reg_EC3 > "00") then--Ncounter EC3 increment
                    if (Ncounter_EC3 = "1111111") then--127
                        Ncounter_EC3 <= "0001000";--8
                    else
                        Ncounter_EC3 <= Ncounter_EC3 + 1;
                    end if;
                    reg_EC3 <= "00";
                else--Check Trigger
                    if ((Ncounter_EC3 <= ncounter_thr_EC3) and (Ncounter_EC3 > "0000000")) then
                        EC_trigger_reg(3) <= '1';--TRIGGER EC3
                    end if;
                    Ncounter_EC3 <= "0000000";
                end if;
                
                if (reg_EC4 > "00") then--Ncounter EC4 increment
                    if (Ncounter_EC4 = "1111111") then--127
                        Ncounter_EC4 <= "0001000";--8
                    else
                        Ncounter_EC4 <= Ncounter_EC4 + 1;
                    end if;
                    reg_EC4 <= "00";
                else--Check Trigger
                    if ((Ncounter_EC4 <= ncounter_thr_EC4) and (Ncounter_EC4 > "0000000")) then
                        EC_trigger_reg(4) <= '1';--TRIGGER EC4
                    end if;
                    Ncounter_EC4 <= "0000000";
                end if;
                
                if (reg_EC5 > "00") then--Ncounter EC5 increment
                    if (Ncounter_EC5 = "1111111") then--127
                        Ncounter_EC5 <= "0001000";--8
                    else
                        Ncounter_EC5 <= Ncounter_EC5 + 1;
                    end if;
                    reg_EC5 <= "00";
                else--Check Trigger
                    if ((Ncounter_EC5 <= ncounter_thr_EC5) and (Ncounter_EC5 > "0000000")) then
                        EC_trigger_reg(5) <= '1';--TRIGGER EC5
                    end if;
                    Ncounter_EC5 <= "0000000";
                end if;
                
                if (reg_EC6 > "00") then--Ncounter EC6 increment
                    if (Ncounter_EC6 = "1111111") then--127
                        Ncounter_EC6 <= "0001000";--8
                    else
                        Ncounter_EC6 <= Ncounter_EC6 + 1;
                    end if;
                    reg_EC6 <= "00";
                else--Check Trigger
                    if ((Ncounter_EC6 <= ncounter_thr_EC6) and (Ncounter_EC6 > "0000000")) then
                        EC_trigger_reg(6) <= '1';--TRIGGER EC6
                    end if;
                    Ncounter_EC6 <= "0000000";
                end if;
                
                if (reg_EC7 > "00") then--Ncounter EC7 increment
                    if (Ncounter_EC7 = "1111111") then--127
                        Ncounter_EC7 <= "0001000";--8
                    else
                        Ncounter_EC7 <= Ncounter_EC7 + 1;
                    end if;
                    reg_EC7 <= "00";
                else--Check Trigger
                    if ((Ncounter_EC7 <= ncounter_thr_EC7) and (Ncounter_EC7 > "0000000")) then
                        EC_trigger_reg(7) <= '1';--TRIGGER EC7
                    end if;
                    Ncounter_EC7 <= "0000000";
                end if;
                
                if (reg_EC8 > "00") then--Ncounter EC8 increment
                    if (Ncounter_EC8 = "1111111") then--127
                        Ncounter_EC8 <= "0001000";--8
                    else
                        Ncounter_EC8 <= Ncounter_EC8 + 1;
                    end if;
                    reg_EC8 <= "00";
                else--Check Trigger
                    if ((Ncounter_EC8 <= ncounter_thr_EC8) and (Ncounter_EC8 > "0000000")) then
                        EC_trigger_reg(8) <= '1';--TRIGGER EC8
                    end if;
                    Ncounter_EC8 <= "0000000";
                end if;
                
                state_read <= s4;
                
            when s4 =>--WRITE FIFO DATAOUT KI
                s_axis_tdata_trg_ki(8 downto 0)     <= EC_trigger_reg;
                s_axis_tdata_trg_ki(15 downto 9)    <= frame_cnt;
                if (EC_trigger_reg > "000000000") then--Trigger on one EC
                    s_axis_tlast_trg_ki <= '1';--Mark Special PACKET as TRIGGER WORD
                end if;
                s_axis_tvalid_trg_ki <= '1';
                state_read <= s5;
            when s5 =>
                s_axis_tvalid_trg_ki <= '0';
                s_axis_tlast_trg_ki <= '0';
                EC_trigger_reg <= "000000000";
                
                state_read <= s0;
        end case;
    end if;
end process;


end arch_KI_Trigger;
