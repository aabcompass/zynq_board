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
    COMPONENT KI_Trigger
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
    END COMPONENT;
    
    COMPONENT DATAGENERATOR_KI
    generic (file_name: integer;
            period: time;
            period_axi: time;
            delay: time;
            delay_data: time);
    PORT(
        CLOCK_133           :   in        std_logic;
        --------------------------SPB2-KI-------------------
        DATA_KI                :   out        std_logic_vector(5 downto 0);
        FRAME_KI               :   out        std_logic
    );
    END COMPONENT;
	
	SIGNAL	clock            	:	std_logic :='0';
	SIGNAL	clock_100            	:	std_logic :='0';
	SIGNAL	clock_axi       	:	std_logic :='1';

	SIGNAL  data_spb2_ki        :   std_logic_vector(17 downto 0) := ( others => '0');
	
	SIGNAL	frame_ki_ec0ec3ec6  :	std_logic := '0';
	
    SIGNAL  frame_ki_ec1ec4ec7  :   std_logic := '0';
    
    SIGNAL  frame_ki_ec2ec5ec8  :   std_logic := '0';
    
    SIGNAL  s_aresetn_cmd_ki       :   std_logic := '1';
    SIGNAL  s_axis_tvalid_cmd_ki   :   std_logic := '0';
    SIGNAL  s_axis_tready_cmd_ki   :   std_logic;
    SIGNAL  s_axis_tdata_cmd_ki    :   std_logic_vector(31 downto 0) := ( others => '0');
    SIGNAL  s_axis_tlast_cmd_ki   :   std_logic := '0';
    
    SIGNAL  m_axis_tvalid_trg_ki   :   std_logic;
    SIGNAL  m_axis_tready_trg_ki   :   std_logic := '0';
    SIGNAL  m_axis_tdata_trg_ki    :   std_logic_vector(31 downto 0) := ( others => '0');
    SIGNAL  m_axis_tlast_trg_ki   :   std_logic := '0';
    
	--CONSTANT period			: 	time := 7.5188 ns;
	--CONSTANT period_axi		: 	time := 7.5188 ns;
	CONSTANT period			: 	time := 5 ns; --200MHz Clock 07/2022
    CONSTANT period_axi     :   time := 5 ns;
	CONSTANT delay			:	time := 0 ns;
	CONSTANT delay_data	    :	time := period/2;
	

  BEGIN

    -- Component Instantiation
    uut:KI_Trigger
    PORT MAP(
        clk_200				=>	clock,
        clk_100				=>	clock_100,
        DATA_SPB2_KI       	    => data_spb2_ki,
        FRAME_KI                => frame_ki_ec0ec3ec6,
        --AXI FIFO KI COMMAND
        s_aclk_cmd_ki           => clock_axi,
        s_aresetn_cmd_ki        => s_aresetn_cmd_ki,
        s_axis_tvalid_cmd_ki    => s_axis_tvalid_cmd_ki,
        s_axis_tready_cmd_ki    => s_axis_tready_cmd_ki,
        s_axis_tdata_cmd_ki     => s_axis_tdata_cmd_ki,
        s_axis_tlast_cmd_ki     => s_axis_tlast_cmd_ki,
        --AXI FIFO MACROPIXEL TRIGGER
        m_aclk_trg_ki              => clock_axi,
        m_axis_tvalid_trg_ki       => m_axis_tvalid_trg_ki,
        m_axis_tready_trg_ki       => m_axis_tready_trg_ki,
        m_axis_tdata_trg_ki        => m_axis_tdata_trg_ki,
        m_axis_tlast_trg_ki        => m_axis_tlast_trg_ki
    );
    
    DATAGEN_KI_EC0EC3EC6:DATAGENERATOR_KI
    --period = 5ns CLOCK_200=200MHz
    --If file_name = 0 
    --Read  Data_IN-KI_EC0EC3EC6.txt
    GENERIC MAP(file_name => 0,period => period,period_axi => period_axi,delay => delay,delay_data => delay_data)
    PORT MAP(
        CLOCK_133                => clock,
        -------------------------MINIEUSO---------
        DATA_KI                  => data_spb2_ki(5 downto 0),
        FRAME_KI                 => frame_ki_ec0ec3ec6            
    );
        
    DATAGEN_KI_EC1EC4EC7:DATAGENERATOR_KI
    --period = 5ns CLOCK_200=200MHz
    --If file_name = 1 
    --Read  Data_IN-KI_EC1EC4EC7.txt
    GENERIC MAP(file_name => 1,period => period,period_axi => period_axi,delay => delay,delay_data => delay_data)
    PORT MAP(
        CLOCK_133                => clock,
        -------------------------MINIEUSO---------
        DATA_KI                  => data_spb2_ki(11 downto 6),
        FRAME_KI                 => frame_ki_ec1ec4ec7             
    );
        
    DATAGEN_KI_EC2EC5EC8:DATAGENERATOR_KI
    --period = 5ns CLOCK_200=200MHz
    --If file_name = 2 
    --Read  Data_IN-KI_EC2EC5EC8.txt
    GENERIC MAP(file_name => 2,period => period,period_axi => period_axi,delay => delay,delay_data => delay_data)
    PORT MAP(
        CLOCK_133                => clock,
        -------------------------MINIEUSO---------
        DATA_KI                  => data_spb2_ki(17 downto 12),
        FRAME_KI                 => frame_ki_ec2ec5ec8            
    );
    
    clock	<=	not clock after period/2;
    clock_100	<=	not clock_100 after period;
    clock_axi <= not clock_axi after period_axi/2;
    
write_cmd_ki:process--KI TRIGGER THRESHOLDS
begin
   wait for 60*period_axi;--Write EC0 THR
   s_axis_tdata_cmd_ki(5 downto 0)   <= conv_std_logic_vector(5,6);--Pixel_THR=5
   s_axis_tdata_cmd_ki(12 downto 6) <= conv_std_logic_vector(3,7);--Ncounter_THR=3
   
   s_axis_tdata_cmd_ki(16 downto 13) <= conv_std_logic_vector(0,4);--ECnumber0
   s_axis_tdata_cmd_ki(31 downto 17) <= "000000000000000";
   
   wait for period_axi;
   s_axis_tvalid_cmd_ki <= '1';
   
   wait for period_axi;
   s_axis_tvalid_cmd_ki <= '0';
   
   wait for period_axi;--Write EC1 THR
   s_axis_tdata_cmd_ki(5 downto 0)   <= conv_std_logic_vector(5,6);--Pixel_THR=5
   s_axis_tdata_cmd_ki(12 downto 6) <= conv_std_logic_vector(3,7);--Ncounter_THR=3
   
   s_axis_tdata_cmd_ki(16 downto 13) <= conv_std_logic_vector(1,4);--ECnumber1
   s_axis_tdata_cmd_ki(31 downto 17) <= "000000000000000";
   
   wait for period_axi;
   s_axis_tvalid_cmd_ki <= '1';
   
   wait for period_axi;
   s_axis_tvalid_cmd_ki <= '0';
   
   wait for period_axi;--Write EC2 THR
   s_axis_tdata_cmd_ki(5 downto 0)   <= conv_std_logic_vector(5,6);--Pixel_THR=5
   s_axis_tdata_cmd_ki(12 downto 6) <= conv_std_logic_vector(3,7);--Ncounter_THR=3
   
   s_axis_tdata_cmd_ki(16 downto 13) <= conv_std_logic_vector(2,4);--ECnumber2
   s_axis_tdata_cmd_ki(31 downto 17) <= "000000000000000";
      
   wait for period_axi;
   s_axis_tvalid_cmd_ki <= '1';
      
   wait for period_axi;
   s_axis_tvalid_cmd_ki <= '0';
   
   wait for period_axi;--Write EC3 THR
   s_axis_tdata_cmd_ki(5 downto 0)   <= conv_std_logic_vector(5,6);--Pixel_THR=5
   s_axis_tdata_cmd_ki(12 downto 6) <= conv_std_logic_vector(3,7);--Ncounter_THR=3
   
   s_axis_tdata_cmd_ki(16 downto 13) <= conv_std_logic_vector(3,4);--ECnumber3
   s_axis_tdata_cmd_ki(31 downto 17) <= "000000000000000";
      
   wait for period_axi;
   s_axis_tvalid_cmd_ki <= '1';
      
   wait for period_axi;
   s_axis_tvalid_cmd_ki <= '0';
   
   wait for period_axi;--Write EC4 THR
   s_axis_tdata_cmd_ki(5 downto 0)   <= conv_std_logic_vector(5,6);--Pixel_THR=5
   s_axis_tdata_cmd_ki(12 downto 6) <= conv_std_logic_vector(3,7);--Ncounter_THR=3
   
   s_axis_tdata_cmd_ki(16 downto 13) <= conv_std_logic_vector(4,4);--ECnumber4
   s_axis_tdata_cmd_ki(31 downto 17) <= "000000000000000";
      
   wait for period_axi;
   s_axis_tvalid_cmd_ki <= '1';
      
   wait for period_axi;
   s_axis_tvalid_cmd_ki <= '0';
      
   wait for period_axi;--Write EC5 THR
   s_axis_tdata_cmd_ki(5 downto 0)   <= conv_std_logic_vector(5,6);--Pixel_THR=5
   s_axis_tdata_cmd_ki(12 downto 6) <= conv_std_logic_vector(3,7);--Ncounter_THR=3
   
   s_axis_tdata_cmd_ki(16 downto 13) <= conv_std_logic_vector(5,4);--ECnumber5
   s_axis_tdata_cmd_ki(31 downto 17) <= "000000000000000";
      
   wait for period_axi;
   s_axis_tvalid_cmd_ki <= '1';
      
   wait for period_axi;
   s_axis_tvalid_cmd_ki <= '0';
   
   wait for period_axi;--Write EC6 THR
   s_axis_tdata_cmd_ki(5 downto 0)   <= conv_std_logic_vector(5,6);--Pixel_THR=5
   s_axis_tdata_cmd_ki(12 downto 6) <= conv_std_logic_vector(3,7);--Ncounter_THR=3
   
   s_axis_tdata_cmd_ki(16 downto 13) <= conv_std_logic_vector(6,4);--ECnumber6
   s_axis_tdata_cmd_ki(31 downto 17) <= "000000000000000";
      
   wait for period_axi;
   s_axis_tvalid_cmd_ki <= '1';
      
   wait for period_axi;
   s_axis_tvalid_cmd_ki <= '0';
   
   wait for period_axi;--Write EC7 THR
   s_axis_tdata_cmd_ki(5 downto 0)   <= conv_std_logic_vector(5,6);--Pixel_THR=5
   s_axis_tdata_cmd_ki(12 downto 6) <= conv_std_logic_vector(3,7);--Ncounter_THR=3
   
   s_axis_tdata_cmd_ki(16 downto 13) <= conv_std_logic_vector(7,4);--ECnumber7
   s_axis_tdata_cmd_ki(31 downto 17) <= "000000000000000";
      
   wait for period_axi;
   s_axis_tvalid_cmd_ki <= '1';
      
   wait for period_axi;
   s_axis_tvalid_cmd_ki <= '0';
   
   wait for period_axi;--Write EC8 THR
   s_axis_tdata_cmd_ki(5 downto 0)   <= conv_std_logic_vector(5,6);--Pixel_THR=5
   s_axis_tdata_cmd_ki(12 downto 6) <= conv_std_logic_vector(3,7);--Ncounter_THR=3
   
   s_axis_tdata_cmd_ki(16 downto 13) <= conv_std_logic_vector(8,4);--ECnumber8
   s_axis_tdata_cmd_ki(31 downto 17) <= "000000000000000";
      
   wait for period_axi;
   s_axis_tvalid_cmd_ki <= '1';
      
   wait for period_axi;
   s_axis_tvalid_cmd_ki <= '0';
   
   wait;
end process;

TRIGGER_KI_DATA : process--Read AXI FIFO TRIGGER KI DATA
    variable    frame       :   integer;
    variable    line_trg_ki    :   line;
    variable    mark        :   character := '#';
    variable    ec0         :   character := '0';
    variable    ec1         :   character := '1';
    variable    ec2         :   character := '2';
    variable    ec3         :   character := '3';
    variable    ec4         :   character := '4';
    variable    ec5         :   character := '5';
    variable    ec6         :   character := '6';
    variable    ec7         :   character := '7';
    variable    ec8         :   character := '8';
    FILE        file_trg_ki    :   text;
begin
    FILE_OPEN(file_trg_ki,"Data_TRIGGER-KI.txt",WRITE_MODE);
    loop
        wait for period_axi;
        if (m_axis_tvalid_trg_ki = '1') then
            frame := conv_integer(m_axis_tdata_trg_ki(15 downto 9));
            if (m_axis_tlast_trg_ki = '1') then--Read a TRIGGER Packet
                write(line_trg_ki,frame,right,3);--GTU Number
                if (m_axis_tdata_trg_ki(0) = '1') then
                    write(line_trg_ki,ec0,right,2);--EC0 TRIGGER
                end if;
                
                if (m_axis_tdata_trg_ki(1) = '1') then
                    write(line_trg_ki,ec1,right,2);--EC1 TRIGGER
                end if;
                
                if (m_axis_tdata_trg_ki(2) = '1') then
                    write(line_trg_ki,ec2,right,2);--EC2 TRIGGER
                end if;
                
                if (m_axis_tdata_trg_ki(3) = '1') then
                    write(line_trg_ki,ec3,right,2);--EC3 TRIGGER
                end if;
                
                if (m_axis_tdata_trg_ki(4) = '1') then
                    write(line_trg_ki,ec4,right,2);--EC4 TRIGGER
                end if;
                
                if (m_axis_tdata_trg_ki(5) = '1') then
                    write(line_trg_ki,ec5,right,2);--EC5 TRIGGER
                end if;
                
                if (m_axis_tdata_trg_ki(6) = '1') then
                    write(line_trg_ki,ec6,right,2);--EC6 TRIGGER
                end if;
                
                if (m_axis_tdata_trg_ki(7) = '1') then
                    write(line_trg_ki,ec7,right,2);--EC7 TRIGGER
                end if;
                
                if (m_axis_tdata_trg_ki(8) = '1') then
                    write(line_trg_ki,ec8,right,2);--EC8 TRIGGER
                end if;
                
                write(line_trg_ki,mark,right,2);--Mark line as TRIGGER LINE
                
                writeline(file_trg_ki,line_trg_ki);
                
            else--Read a "NORMAL" Packet
                write(line_trg_ki,frame,right,3);--GTU Number
                writeline(file_trg_ki,line_trg_ki);
            end if;
            m_axis_tready_trg_ki    <=    '1';
            wait for period_axi;
            m_axis_tready_trg_ki    <=    '0';
        end if;
    end loop;
    FILE_CLOSE(file_trg_ki);
end process;

  --  End Test Bench 
  END behavior;