--SPB2 TestBench Template M.Mignone 08/2020
--INFN Torino

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.std_logic_arith.ALL;
  USE ieee.std_logic_unsigned.ALL;
  --USE ieee.numeric_std.ALL;
  USE	ieee.std_logic_textio.ALL;
  use STD.textio.ALL;

  ENTITY testbench_SPB2 IS
  END testbench_SPB2;

  ARCHITECTURE behavior OF testbench_SPB2 IS 

  -- Component Declaration
    COMPONENT SPB2
    PORT(
        CLOCK_133               :	in	    std_logic;
	--------------------------SPB2-DATA-------------------
        DATA_SPB2               :	in	    std_logic_vector(143 downto 0);
        FRAME                   :	in	    std_logic;
       ----------------------STHR DEBUG------------------------------------------------------------------------
--       sthr_debug_ec0ec3ec6 :       out STD_LOGIC_VECTOR (263 downto 0);
--       sthr_ready_debug_ec0ec3ec6 : out STD_LOGIC;
--       sthr_debug_ec1ec4ec7 :       out STD_LOGIC_VECTOR (263 downto 0);
--       sthr_ready_debug_ec1ec4ec7 : out STD_LOGIC;
--       sthr_debug_ec2ec5ec8 :       out STD_LOGIC_VECTOR (263 downto 0);
--       sthr_ready_debug_ec2ec5ec8 : out STD_LOGIC;
       --------------------------------------------------------------------------------------------------------
        --AXI FIFO MACROPIXEL SUM
       m_aclk_sum           :   in  std_logic;
       m_axis_tvalid_sum    :   out std_logic;
       m_axis_tready_sum    :   in  std_logic;
       m_axis_tdata_sum     :   out std_logic_vector (31 downto 0);
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
    END COMPONENT;
    
    COMPONENT DATAGENERATOR
    generic (file_name: integer;
            period: time;
            period_axi: time;
            delay: time;
            delay_data: time);
    PORT(
        CLOCK_133           :   in        std_logic;
        --------------------------SPB2-------------------
        DATA                :   out        std_logic_vector(47 downto 0);
        FRAME               :   out        std_logic
        );
    END COMPONENT;
	
	SIGNAL	clock            	:	std_logic :='0';
	SIGNAL	clock_axi       	:	std_logic :='1';

	SIGNAL  data_spb2           :   std_logic_vector(143 downto 0) := ( others => '0');
	
	SIGNAL	frame_ec0ec3ec6     :	std_logic := '0';
	
    SIGNAL  frame_ec1ec4ec7     :   std_logic := '0';
    
    SIGNAL  frame_ec2ec5ec8     :   std_logic := '0';
    
    SIGNAL  m_axis_tvalid_sum   :   std_logic;
    SIGNAL  m_axis_tready_sum   :   std_logic := '0';
    SIGNAL  m_axis_tdata_sum    :   std_logic_vector(31 downto 0) := ( others => '0');
    SIGNAL  m_axis_tlast_sum   :   std_logic := '0';
    
    SIGNAL  s_aresetn_cmd       :   std_logic := '1';
    SIGNAL  s_axis_tvalid_cmd   :   std_logic := '0';
    SIGNAL  s_axis_tready_cmd   :   std_logic;
    SIGNAL  s_axis_tdata_cmd    :   std_logic_vector(31 downto 0) := ( others => '0');
    SIGNAL  s_axis_tlast_cmd   :   std_logic := '0';
    
    SIGNAL  m_axis_tvalid_trg   :   std_logic;
    SIGNAL  m_axis_tready_trg   :   std_logic := '0';
    SIGNAL  m_axis_tdata_trg    :   std_logic_vector(31 downto 0) := ( others => '0');
    SIGNAL  m_axis_tlast_trg   :   std_logic := '0';
    
    ----------------------STHR DEBUG------------------------------------------------------------------------
--    SIGNAL  sthr_debug_ec0ec3ec6 :          STD_LOGIC_VECTOR (263 downto 0) := ( others => '0');
--    SIGNAL  sthr_ready_debug_ec0ec3ec6 :    STD_LOGIC := '0';
--    SIGNAL  sthr_debug_ec1ec4ec7 :          STD_LOGIC_VECTOR (263 downto 0) := ( others => '0');
--    SIGNAL  sthr_ready_debug_ec1ec4ec7 :    STD_LOGIC := '0';
--    SIGNAL  sthr_debug_ec2ec5ec8 :          STD_LOGIC_VECTOR (263 downto 0) := ( others => '0');
--    SIGNAL  sthr_ready_debug_ec2ec5ec8 :    STD_LOGIC := '0';
   --------------------------------------------------------------------------------------------------------
    
	CONSTANT period			: 	time := 7.5188 ns; --7.5188 ns;
	CONSTANT period_axi		: 	time := 7.5188 ns;
	CONSTANT delay			:	time := 0 ns;
	CONSTANT delay_data	    :	time := period/2;
	

  BEGIN

    -- Component Instantiation
    uut:SPB2
    PORT MAP(
        CLOCK_133				=>	clock,
        DATA_SPB2         	    => data_spb2,
        FRAME				    => frame_ec0ec3ec6,
        ----------------------STHR DEBUG------------------------------------------------------------------------
--        sthr_debug_ec0ec3ec6        => sthr_debug_ec0ec3ec6,
--        sthr_ready_debug_ec0ec3ec6  => sthr_ready_debug_ec0ec3ec6,
--        sthr_debug_ec1ec4ec7        => sthr_debug_ec1ec4ec7,
--        sthr_ready_debug_ec1ec4ec7  => sthr_ready_debug_ec1ec4ec7,
--        sthr_debug_ec2ec5ec8        => sthr_debug_ec2ec5ec8,
--        sthr_ready_debug_ec2ec5ec8  => sthr_ready_debug_ec2ec5ec8,
       --------------------------------------------------------------------------------------------------------
        --AXI FIFO MACROPIXEL SUM
        m_aclk_sum              => clock_axi,
        m_axis_tvalid_sum       => m_axis_tvalid_sum,
        m_axis_tready_sum       => m_axis_tready_sum,
        m_axis_tdata_sum        => m_axis_tdata_sum,
        m_axis_tlast_sum        => m_axis_tlast_sum,
        --AXI FIFO COMMAND
        s_aclk_cmd              => clock_axi,
        s_aresetn_cmd           => s_aresetn_cmd,
        s_axis_tvalid_cmd       => s_axis_tvalid_cmd,
        s_axis_tready_cmd       => s_axis_tready_cmd,
        s_axis_tdata_cmd        => s_axis_tdata_cmd,
        s_axis_tdest_cmd => (others => '0'),
        s_axis_tlast_cmd        => s_axis_tlast_cmd,
        --AXI FIFO MACROPIXEL TRIGGER
        m_aclk_trg              => clock_axi,
        m_axis_tvalid_trg       => m_axis_tvalid_trg,
        m_axis_tready_trg       => m_axis_tready_trg,
        m_axis_tdata_trg        => m_axis_tdata_trg,
        m_axis_tlast_trg        => m_axis_tlast_trg  
    );
    
    DATAGEN_EC0EC3EC6:DATAGENERATOR
    --period = 5ns CLOCK_200=200MHz
    --If file_name = 0 
    --Read  Data_IN_EC0EC3EC6.txt
    GENERIC MAP(file_name => 0,period => period,period_axi => period_axi,delay => delay,delay_data => delay_data)
    PORT MAP(
        CLOCK_133                => clock,
        -------------------------MINIEUSO---------
        DATA                     => data_spb2(47 downto 0),
        FRAME                    => frame_ec0ec3ec6            
    );
    
    DATAGEN_EC1EC4EC7:DATAGENERATOR
    --period = 5ns CLOCK_200=200MHz
    --If file_name = 1 
    --Read  Data_IN_EC1EC4EC7.txt
    GENERIC MAP(file_name => 1,period => period,period_axi => period_axi,delay => delay,delay_data => delay_data)
    PORT MAP(
        CLOCK_133                => clock,
        -------------------------MINIEUSO---------
        DATA                     => data_spb2(95 downto 48),
        FRAME                    => frame_ec1ec4ec7             
    );
    
    DATAGEN_EC2EC5EC8:DATAGENERATOR
    --period = 5ns CLOCK_200=200MHz
    --If file_name = 2 
    --Read  Data_IN_EC2EC5EC8.txt
    GENERIC MAP(file_name => 2,period => period,period_axi => period_axi,delay => delay,delay_data => delay_data)
    PORT MAP(
        CLOCK_133                => clock,
        -------------------------MINIEUSO---------
        DATA                     => data_spb2(143 downto 96),
        FRAME                    => frame_ec2ec5ec8            
    );
    
    clock	<=	not clock after period/2;
    clock_axi <= not clock_axi after period_axi/2;
    
    s_aresetn_cmd <=	transport '1',
    '0' after 10*period_axi,
    '1' after 20*period_axi;

--MACROPIXEL_SUM : process--Read AXI FIFO SUM
--        variable    mpsum_value :    integer;
--        variable    line_out    :    line;
--        FILE        file_out    :    text;
--    begin
--        FILE_OPEN(file_out,"Data_MP_SUM.txt",WRITE_MODE);
--        loop
--            wait for period_axi;
--            if (m_axis_tvalid_sum = '1') then
--                mpsum_value:= conv_integer(m_axis_tdata_sum);--line0
--                write(line_out,mpsum_value,right,9);
--                m_axis_tready_sum    <=    '1';
--                wait for period_axi;
--                m_axis_tready_sum    <=    '0';
--                wait for period_axi;
--                mpsum_value:= conv_integer(m_axis_tdata_sum);--line1
--                write(line_out,mpsum_value,right,9);
--                m_axis_tready_sum    <=    '1';
--                wait for period_axi;
--                m_axis_tready_sum    <=    '0';
--                wait for period_axi;
--                mpsum_value:= conv_integer(m_axis_tdata_sum);--line2
--                write(line_out,mpsum_value,right,9);
--                m_axis_tready_sum    <=    '1';
--                wait for period_axi;
--                m_axis_tready_sum    <=    '0';
--                wait for period_axi;
--                mpsum_value:= conv_integer(m_axis_tdata_sum);--line3
--                write(line_out,mpsum_value,right,9);
--                m_axis_tready_sum    <=    '1';
--                wait for period_axi;
--                m_axis_tready_sum    <=    '0';
--                wait for period_axi;
--                mpsum_value:= conv_integer(m_axis_tdata_sum);--line4
--                write(line_out,mpsum_value,right,9);
--                m_axis_tready_sum    <=    '1';
--                wait for period_axi;
--                m_axis_tready_sum    <=    '0';
--                wait for period_axi;
--                mpsum_value:= conv_integer(m_axis_tdata_sum);--line5
--                write(line_out,mpsum_value,right,9);
--                m_axis_tready_sum    <=    '1';
--                wait for period_axi;
--                m_axis_tready_sum    <=    '0';
--                wait for period_axi;
--                mpsum_value:= conv_integer(m_axis_tdata_sum);--line6
--                write(line_out,mpsum_value,right,9);
--                m_axis_tready_sum    <=    '1';
--                wait for period_axi;
--                m_axis_tready_sum    <=    '0';
--                wait for period_axi;
--                mpsum_value:= conv_integer(m_axis_tdata_sum);--line7
--                write(line_out,mpsum_value,right,9);
--                m_axis_tready_sum    <=    '1';
--                wait for period_axi;
--                m_axis_tready_sum    <=    '0';
--                wait for period_axi;
--                mpsum_value:= conv_integer(m_axis_tdata_sum);--line8
--                write(line_out,mpsum_value,right,9);
--                m_axis_tready_sum    <=    '1';
--                wait for period_axi;
--                m_axis_tready_sum    <=    '0';
--                wait for period_axi;
--                mpsum_value:= conv_integer(m_axis_tdata_sum);--line9
--                write(line_out,mpsum_value,right,9);
--                m_axis_tready_sum    <=    '1';
--                wait for period_axi;
--                m_axis_tready_sum    <=    '0';
--                wait for period_axi;
--                mpsum_value:= conv_integer(m_axis_tdata_sum);--line10
--                write(line_out,mpsum_value,right,9);
--                m_axis_tready_sum    <=    '1';
--                wait for period_axi;
--                m_axis_tready_sum    <=    '0';
--                wait for period_axi;
--                mpsum_value:= conv_integer(m_axis_tdata_sum);--line11
--                write(line_out,mpsum_value,right,9);
--                m_axis_tready_sum    <=    '1';
--                wait for period_axi;
--                m_axis_tready_sum    <=    '0';
--                wait for period_axi;
--                mpsum_value:= conv_integer(m_axis_tdata_sum);--line12
--                write(line_out,mpsum_value,right,9);
--                m_axis_tready_sum    <=    '1';
--                wait for period_axi;
--                m_axis_tready_sum    <=    '0';
--                wait for period_axi;
--                mpsum_value:= conv_integer(m_axis_tdata_sum);--line13
--                write(line_out,mpsum_value,right,9);
--                m_axis_tready_sum    <=    '1';
--                wait for period_axi;
--                m_axis_tready_sum    <=    '0';
--                wait for period_axi;
--                mpsum_value:= conv_integer(m_axis_tdata_sum);--line14
--                write(line_out,mpsum_value,right,9);
--                m_axis_tready_sum    <=    '1';
--                wait for period_axi;
--                m_axis_tready_sum    <=    '0';
--                wait for period_axi;
--                mpsum_value:= conv_integer(m_axis_tdata_sum);--line15
--                write(line_out,mpsum_value,right,9);
--                m_axis_tready_sum    <=    '1';
--                wait for period_axi;
--                m_axis_tready_sum    <=    '0';
--                wait for period_axi;
--                mpsum_value:= conv_integer(m_axis_tdata_sum);--line16
--                write(line_out,mpsum_value,right,9);
--                m_axis_tready_sum    <=    '1';
--                wait for period_axi;
--                m_axis_tready_sum    <=    '0';
--                wait for period_axi;
--                mpsum_value:= conv_integer(m_axis_tdata_sum);--line17
--                write(line_out,mpsum_value,right,9);
--                m_axis_tready_sum    <=    '1';
--                wait for period_axi;
--                m_axis_tready_sum    <=    '0';
--                wait for period_axi;
--                mpsum_value:= conv_integer(m_axis_tdata_sum);--line18
--                write(line_out,mpsum_value,right,9);
--                m_axis_tready_sum    <=    '1';
--                wait for period_axi;
--                m_axis_tready_sum    <=    '0';
--                wait for period_axi;
--                mpsum_value:= conv_integer(m_axis_tdata_sum);--line19
--                write(line_out,mpsum_value,right,9);
--                m_axis_tready_sum    <=    '1';
--                wait for period_axi;
--                m_axis_tready_sum    <=    '0';
--                wait for period_axi;
--                mpsum_value:= conv_integer(m_axis_tdata_sum);--line20
--                write(line_out,mpsum_value,right,9);
--                m_axis_tready_sum    <=    '1';
--                wait for period_axi;
--                m_axis_tready_sum    <=    '0';
--                wait for period_axi;
--                mpsum_value:= conv_integer(m_axis_tdata_sum);--line21
--                write(line_out,mpsum_value,right,9);
--                m_axis_tready_sum    <=    '1';
--                wait for period_axi;
--                m_axis_tready_sum    <=    '0';
--                wait for period_axi;
--                mpsum_value:= conv_integer(m_axis_tdata_sum);--line22
--                write(line_out,mpsum_value,right,9);
--                m_axis_tready_sum    <=    '1';
--                wait for period_axi;
--                m_axis_tready_sum    <=    '0';
--                wait for period_axi;
--                mpsum_value:= conv_integer(m_axis_tdata_sum);--line23
--                write(line_out,mpsum_value,right,9);
--                writeline(file_out,line_out);
                
--                if (m_axis_tlast_sum = '1') then
--                    writeline(file_out,line_out);
--                end if;
--                m_axis_tready_sum    <=    '1';
--                wait for period_axi;
--                m_axis_tready_sum    <=    '0';
----                wait for period_axi;
--            end if;
--        end loop;
--        FILE_CLOSE(file_out);
--    end process;
m_axis_tready_sum    <=    '1';
    
TRIGGER_DATA : process--Read AXI FIFO TRIGGER DATA
    variable    mc_active   :   integer;
    variable    gtu_trg     :   integer;
    variable    line_trg    :   line;
    variable    mark        :   character := '#';
    FILE        file_trg    :   text;
begin
    FILE_OPEN(file_trg,"Data_TRIGGER.txt",WRITE_MODE);
    loop
        wait for period_axi;
        if (m_axis_tvalid_trg = '1') then
            mc_active   := conv_integer(m_axis_tdata_trg(8 downto 0));
            gtu_trg     := conv_integer(m_axis_tdata_trg(27 downto 9));
            if (m_axis_tlast_trg = '1') then--Read a TRIGGER Packet
                write(line_trg,gtu_trg,right,7);--GTU Number
                write(line_trg,mc_active,right,4);--Active MacroCell in GTU
                write(line_trg,mark,right,2);--Mark line as TRIGGER LINE
                writeline(file_trg,line_trg);
            else--Read a "NORMAL" Packet
                write(line_trg,gtu_trg,right,7);--GTU Number
                write(line_trg,mc_active,right,4);--Actice MacroCell in GTU
                writeline(file_trg,line_trg);
            end if;
            m_axis_tready_trg    <=    '1';
            wait for period_axi;
            m_axis_tready_trg    <=    '0';
        end if;
    end loop;
    FILE_CLOSE(file_trg);
end process;

-----------------------------------------STHR DEBUG------------------------------------------------------------------
--STHR_EC0EC3EC6 : process--Write STHR for DEBUG
--    variable    sthr0       :   integer;
--    variable    sthr1       :   integer;
--    variable    sthr2       :   integer;
--    variable    sthr3       :   integer;
--    variable    sthr4       :   integer;
--    variable    sthr5       :   integer;
--    variable    sthr6       :   integer;
--    variable    sthr7       :   integer;
--    variable    sthr8       :   integer;
--    variable    sthr9       :   integer;
--    variable    sthr10       :   integer;
--    variable    sthr11       :   integer;
--    variable    sthr12       :   integer;
--    variable    sthr13       :   integer;
--    variable    sthr14       :   integer;
--    variable    sthr15       :   integer;
--    variable    sthr16       :   integer;
--    variable    sthr17       :   integer;
--    variable    sthr18       :   integer;
--    variable    sthr19       :   integer;
--    variable    sthr20       :   integer;
--    variable    sthr21       :   integer;
--    variable    sthr22       :   integer;
--    variable    sthr23       :   integer;
--    variable    line_sthr    :   line;
--    FILE        file_sthr    :   text;
--begin
--    FILE_OPEN(file_sthr,"STHR_EC0EC3EC6.txt",WRITE_MODE);
--    loop
--        wait for 2*period;
--        if (sthr_ready_debug_ec0ec3ec6 = '1') then
--            sthr0   := conv_integer(sthr_debug_ec0ec3ec6(10 downto 0));
--            sthr1   := conv_integer(sthr_debug_ec0ec3ec6(21 downto 11));
--            sthr2   := conv_integer(sthr_debug_ec0ec3ec6(32 downto 22));
--            sthr3   := conv_integer(sthr_debug_ec0ec3ec6(43 downto 33));
--            sthr4   := conv_integer(sthr_debug_ec0ec3ec6(54 downto 44));
--            sthr5   := conv_integer(sthr_debug_ec0ec3ec6(65 downto 55));
--            sthr6   := conv_integer(sthr_debug_ec0ec3ec6(76 downto 66));
--            sthr7   := conv_integer(sthr_debug_ec0ec3ec6(87 downto 77));
--            sthr8   := conv_integer(sthr_debug_ec0ec3ec6(98 downto 88));
--            sthr9   := conv_integer(sthr_debug_ec0ec3ec6(109 downto 99));
--            sthr10   := conv_integer(sthr_debug_ec0ec3ec6(120 downto 110));
--            sthr11   := conv_integer(sthr_debug_ec0ec3ec6(131 downto 121));
--            sthr12   := conv_integer(sthr_debug_ec0ec3ec6(142 downto 132));
--            sthr13   := conv_integer(sthr_debug_ec0ec3ec6(153 downto 143));
--            sthr14   := conv_integer(sthr_debug_ec0ec3ec6(164 downto 154));
--            sthr15   := conv_integer(sthr_debug_ec0ec3ec6(175 downto 165));
--            sthr16   := conv_integer(sthr_debug_ec0ec3ec6(186 downto 176));
--            sthr17   := conv_integer(sthr_debug_ec0ec3ec6(197 downto 187));
--            sthr18   := conv_integer(sthr_debug_ec0ec3ec6(208 downto 198));
--            sthr19   := conv_integer(sthr_debug_ec0ec3ec6(219 downto 209));
--            sthr20   := conv_integer(sthr_debug_ec0ec3ec6(230 downto 220));
--            sthr21   := conv_integer(sthr_debug_ec0ec3ec6(241 downto 231));
--            sthr22   := conv_integer(sthr_debug_ec0ec3ec6(252 downto 242));
--            sthr23   := conv_integer(sthr_debug_ec0ec3ec6(263 downto 253));
            
--            write(line_sthr,sthr0,right,5);
--            write(line_sthr,sthr1,right,5);
--            write(line_sthr,sthr2,right,5);
--            write(line_sthr,sthr3,right,5);
--            write(line_sthr,sthr4,right,5);
--            write(line_sthr,sthr5,right,5);
--            write(line_sthr,sthr6,right,5);
--            write(line_sthr,sthr7,right,5);
--            write(line_sthr,sthr8,right,5);
--            write(line_sthr,sthr9,right,5);
--            write(line_sthr,sthr10,right,5);
--            write(line_sthr,sthr11,right,5);
--            write(line_sthr,sthr12,right,5);
--            write(line_sthr,sthr13,right,5);
--            write(line_sthr,sthr14,right,5);
--            write(line_sthr,sthr15,right,5);
--            write(line_sthr,sthr16,right,5);
--            write(line_sthr,sthr17,right,5);
--            write(line_sthr,sthr18,right,5);
--            write(line_sthr,sthr19,right,5);
--            write(line_sthr,sthr20,right,5);
--            write(line_sthr,sthr21,right,5);
--            write(line_sthr,sthr22,right,5);
--            write(line_sthr,sthr23,right,5);
            
--            writeline(file_sthr,line_sthr);
--        end if;
--    end loop;
--    FILE_CLOSE(file_sthr);
--end process;

--STHR_EC1EC4EC7 : process--Write STHR for DEBUG
--    variable    sthr0       :   integer;
--    variable    sthr1       :   integer;
--    variable    sthr2       :   integer;
--    variable    sthr3       :   integer;
--    variable    sthr4       :   integer;
--    variable    sthr5       :   integer;
--    variable    sthr6       :   integer;
--    variable    sthr7       :   integer;
--    variable    sthr8       :   integer;
--    variable    sthr9       :   integer;
--    variable    sthr10       :   integer;
--    variable    sthr11       :   integer;
--    variable    sthr12       :   integer;
--    variable    sthr13       :   integer;
--    variable    sthr14       :   integer;
--    variable    sthr15       :   integer;
--    variable    sthr16       :   integer;
--    variable    sthr17       :   integer;
--    variable    sthr18       :   integer;
--    variable    sthr19       :   integer;
--    variable    sthr20       :   integer;
--    variable    sthr21       :   integer;
--    variable    sthr22       :   integer;
--    variable    sthr23       :   integer;
--    variable    line_sthr    :   line;
--    FILE        file_sthr    :   text;
--begin
--    FILE_OPEN(file_sthr,"STHR_EC1EC4EC7.txt",WRITE_MODE);
--    loop
--        wait for 2*period;
--        if (sthr_ready_debug_ec1ec4ec7 = '1') then
--            sthr0   := conv_integer(sthr_debug_ec1ec4ec7(10 downto 0));
--            sthr1   := conv_integer(sthr_debug_ec1ec4ec7(21 downto 11));
--            sthr2   := conv_integer(sthr_debug_ec1ec4ec7(32 downto 22));
--            sthr3   := conv_integer(sthr_debug_ec1ec4ec7(43 downto 33));
--            sthr4   := conv_integer(sthr_debug_ec1ec4ec7(54 downto 44));
--            sthr5   := conv_integer(sthr_debug_ec1ec4ec7(65 downto 55));
--            sthr6   := conv_integer(sthr_debug_ec1ec4ec7(76 downto 66));
--            sthr7   := conv_integer(sthr_debug_ec1ec4ec7(87 downto 77));
--            sthr8   := conv_integer(sthr_debug_ec1ec4ec7(98 downto 88));
--            sthr9   := conv_integer(sthr_debug_ec1ec4ec7(109 downto 99));
--            sthr10   := conv_integer(sthr_debug_ec1ec4ec7(120 downto 110));
--            sthr11   := conv_integer(sthr_debug_ec1ec4ec7(131 downto 121));
--            sthr12   := conv_integer(sthr_debug_ec1ec4ec7(142 downto 132));
--            sthr13   := conv_integer(sthr_debug_ec1ec4ec7(153 downto 143));
--            sthr14   := conv_integer(sthr_debug_ec1ec4ec7(164 downto 154));
--            sthr15   := conv_integer(sthr_debug_ec1ec4ec7(175 downto 165));
--            sthr16   := conv_integer(sthr_debug_ec1ec4ec7(186 downto 176));
--            sthr17   := conv_integer(sthr_debug_ec1ec4ec7(197 downto 187));
--            sthr18   := conv_integer(sthr_debug_ec1ec4ec7(208 downto 198));
--            sthr19   := conv_integer(sthr_debug_ec1ec4ec7(219 downto 209));
--            sthr20   := conv_integer(sthr_debug_ec1ec4ec7(230 downto 220));
--            sthr21   := conv_integer(sthr_debug_ec1ec4ec7(241 downto 231));
--            sthr22   := conv_integer(sthr_debug_ec1ec4ec7(252 downto 242));
--            sthr23   := conv_integer(sthr_debug_ec1ec4ec7(263 downto 253));
            
--            write(line_sthr,sthr0,right,5);
--            write(line_sthr,sthr1,right,5);
--            write(line_sthr,sthr2,right,5);
--            write(line_sthr,sthr3,right,5);
--            write(line_sthr,sthr4,right,5);
--            write(line_sthr,sthr5,right,5);
--            write(line_sthr,sthr6,right,5);
--            write(line_sthr,sthr7,right,5);
--            write(line_sthr,sthr8,right,5);
--            write(line_sthr,sthr9,right,5);
--            write(line_sthr,sthr10,right,5);
--            write(line_sthr,sthr11,right,5);
--            write(line_sthr,sthr12,right,5);
--            write(line_sthr,sthr13,right,5);
--            write(line_sthr,sthr14,right,5);
--            write(line_sthr,sthr15,right,5);
--            write(line_sthr,sthr16,right,5);
--            write(line_sthr,sthr17,right,5);
--            write(line_sthr,sthr18,right,5);
--            write(line_sthr,sthr19,right,5);
--            write(line_sthr,sthr20,right,5);
--            write(line_sthr,sthr21,right,5);
--            write(line_sthr,sthr22,right,5);
--            write(line_sthr,sthr23,right,5);
            
--            writeline(file_sthr,line_sthr);
--        end if;
--    end loop;
--    FILE_CLOSE(file_sthr);
--end process;

--STHR_EC2EC5EC8 : process--Write STHR for DEBUG
--    variable    sthr0       :   integer;
--    variable    sthr1       :   integer;
--    variable    sthr2       :   integer;
--    variable    sthr3       :   integer;
--    variable    sthr4       :   integer;
--    variable    sthr5       :   integer;
--    variable    sthr6       :   integer;
--    variable    sthr7       :   integer;
--    variable    sthr8       :   integer;
--    variable    sthr9       :   integer;
--    variable    sthr10       :   integer;
--    variable    sthr11       :   integer;
--    variable    sthr12       :   integer;
--    variable    sthr13       :   integer;
--    variable    sthr14       :   integer;
--    variable    sthr15       :   integer;
--    variable    sthr16       :   integer;
--    variable    sthr17       :   integer;
--    variable    sthr18       :   integer;
--    variable    sthr19       :   integer;
--    variable    sthr20       :   integer;
--    variable    sthr21       :   integer;
--    variable    sthr22       :   integer;
--    variable    sthr23       :   integer;
--    variable    line_sthr    :   line;
--    FILE        file_sthr    :   text;
--begin
--    FILE_OPEN(file_sthr,"STHR_EC2EC5EC8.txt",WRITE_MODE);
--    loop
--        wait for 2*period;
--        if (sthr_ready_debug_ec2ec5ec8 = '1') then
--            sthr0   := conv_integer(sthr_debug_ec2ec5ec8(10 downto 0));
--            sthr1   := conv_integer(sthr_debug_ec2ec5ec8(21 downto 11));
--            sthr2   := conv_integer(sthr_debug_ec2ec5ec8(32 downto 22));
--            sthr3   := conv_integer(sthr_debug_ec2ec5ec8(43 downto 33));
--            sthr4   := conv_integer(sthr_debug_ec2ec5ec8(54 downto 44));
--            sthr5   := conv_integer(sthr_debug_ec2ec5ec8(65 downto 55));
--            sthr6   := conv_integer(sthr_debug_ec2ec5ec8(76 downto 66));
--            sthr7   := conv_integer(sthr_debug_ec2ec5ec8(87 downto 77));
--            sthr8   := conv_integer(sthr_debug_ec2ec5ec8(98 downto 88));
--            sthr9   := conv_integer(sthr_debug_ec2ec5ec8(109 downto 99));
--            sthr10   := conv_integer(sthr_debug_ec2ec5ec8(120 downto 110));
--            sthr11   := conv_integer(sthr_debug_ec2ec5ec8(131 downto 121));
--            sthr12   := conv_integer(sthr_debug_ec2ec5ec8(142 downto 132));
--            sthr13   := conv_integer(sthr_debug_ec2ec5ec8(153 downto 143));
--            sthr14   := conv_integer(sthr_debug_ec2ec5ec8(164 downto 154));
--            sthr15   := conv_integer(sthr_debug_ec2ec5ec8(175 downto 165));
--            sthr16   := conv_integer(sthr_debug_ec2ec5ec8(186 downto 176));
--            sthr17   := conv_integer(sthr_debug_ec2ec5ec8(197 downto 187));
--            sthr18   := conv_integer(sthr_debug_ec2ec5ec8(208 downto 198));
--            sthr19   := conv_integer(sthr_debug_ec2ec5ec8(219 downto 209));
--            sthr20   := conv_integer(sthr_debug_ec2ec5ec8(230 downto 220));
--            sthr21   := conv_integer(sthr_debug_ec2ec5ec8(241 downto 231));
--            sthr22   := conv_integer(sthr_debug_ec2ec5ec8(252 downto 242));
--            sthr23   := conv_integer(sthr_debug_ec2ec5ec8(263 downto 253));
            
--            write(line_sthr,sthr0,right,5);
--            write(line_sthr,sthr1,right,5);
--            write(line_sthr,sthr2,right,5);
--            write(line_sthr,sthr3,right,5);
--            write(line_sthr,sthr4,right,5);
--            write(line_sthr,sthr5,right,5);
--            write(line_sthr,sthr6,right,5);
--            write(line_sthr,sthr7,right,5);
--            write(line_sthr,sthr8,right,5);
--            write(line_sthr,sthr9,right,5);
--            write(line_sthr,sthr10,right,5);
--            write(line_sthr,sthr11,right,5);
--            write(line_sthr,sthr12,right,5);
--            write(line_sthr,sthr13,right,5);
--            write(line_sthr,sthr14,right,5);
--            write(line_sthr,sthr15,right,5);
--            write(line_sthr,sthr16,right,5);
--            write(line_sthr,sthr17,right,5);
--            write(line_sthr,sthr18,right,5);
--            write(line_sthr,sthr19,right,5);
--            write(line_sthr,sthr20,right,5);
--            write(line_sthr,sthr21,right,5);
--            write(line_sthr,sthr22,right,5);
--            write(line_sthr,sthr23,right,5);
            
--            writeline(file_sthr,line_sthr);
--        end if;
--    end loop;
--    FILE_CLOSE(file_sthr);
--end process;
---------------------------------------------------------------------------------------------------------------------

write_cmd:process
    begin
       wait for 60*period_axi;
       s_axis_tdata_cmd(9 downto 0)   <= conv_std_logic_vector(640,10);--nSigma=5 (nSigma x 128)
       s_axis_tdata_cmd(14 downto 10) <= conv_std_logic_vector(2,5);--nHot--2
       s_axis_tdata_cmd(19 downto 15) <= conv_std_logic_vector(20,5);--nLenght--20 (min value 5,MAX value 31)
       s_axis_tdata_cmd(30 downto 20) <= conv_std_logic_vector(34,11);--nActive--34 (MAX value 2047)
       s_axis_tdata_cmd(31) <= '0';--Switch for nSigma,nHot,nLenght,nActive
       
       wait for period_axi;
       s_axis_tvalid_cmd <= '1';
       wait for period_axi;
       s_axis_tvalid_cmd <= '0';
       
       wait for period_axi;
       s_axis_tdata_cmd(15 downto 0) <= conv_std_logic_vector(32768,16);--MPSthr
       s_axis_tdata_cmd(31) <= '1';--Switch for MPSthr
       
       wait for period_axi;
       s_axis_tvalid_cmd <= '1';
       wait for period_axi;
       s_axis_tvalid_cmd <= '0';
       
--       wait for 300*period_axi;--fake--------------
--       s_axis_tdata_cmd(14 downto 10) <= "11111";--nHot
--       s_axis_tdata_cmd(19 downto 15) <= "10000";--nLenght (from 5,MAX value 31->)
--       s_axis_tdata_cmd(31 downto 20) <= "000000000011";--nActive (MAX value 4095)
--       wait for period_axi;
--       s_axis_tvalid_cmd <= '1';
--       wait for period_axi;
--       s_axis_tvalid_cmd <= '0';--fake-----------------
       wait;
    end process;
    
  --  End Test Bench 
  END behavior;