--SPB2 TestBench Template M.Mignone 08/2020
--INFN Torino

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.std_logic_arith.ALL;
  USE ieee.std_logic_unsigned.ALL;
  --USE ieee.numeric_std.ALL;
  USE	ieee.std_logic_textio.ALL;
  USE STD.textio.ALL;


    ENTITY DATAGENERATOR_KI is
    generic (file_name: integer;
            period: time;
            period_axi: time;
            delay: time;
            delay_data: time);
    PORT(
        CLOCK_133			:	in	    std_logic;
		DATA_KI			    :	out	    std_logic_vector(5 downto 0);
		FRAME_KI			:	out	    std_logic
		);
    END DATAGENERATOR_KI;
	
architecture arch_DATAGENERATOR_KI of DATAGENERATOR_KI is
	SIGNAL  frame_s         :	std_logic :='0';
	
	SIGNAL	clock_axi_s		:	std_logic :='0';

	SIGNAL	data_s			:	std_logic_vector(5 downto 0) := ( others => '0');
	
	SIGNAL	  d0_pmt1_ect  	:	std_logic_vector(47 downto 0) := ( others => '0');
    
    SIGNAL	  d0_pmt2_ect  	:	std_logic_vector(47 downto 0) := ( others => '0');
    
    SIGNAL	  d0_pmt3_ect  	:	std_logic_vector(47 downto 0) := ( others => '0');
    
    SIGNAL	  d0_pmt4_ect  	:	std_logic_vector(47 downto 0) := ( others => '0');
    
    SIGNAL	  d0_pmt1_ecm  	:	std_logic_vector(47 downto 0) := ( others => '0');
        
    SIGNAL    d0_pmt2_ecm   :   std_logic_vector(47 downto 0) := ( others => '0');
        
    SIGNAL    d0_pmt3_ecm   :   std_logic_vector(47 downto 0) := ( others => '0');
     
    SIGNAL    d0_pmt4_ecm   :   std_logic_vector(47 downto 0) := ( others => '0');
    
    SIGNAL	  d0_pmt1_ecb  	:	std_logic_vector(47 downto 0) := ( others => '0');
            
    SIGNAL    d0_pmt2_ecb   :   std_logic_vector(47 downto 0) := ( others => '0');
          
    SIGNAL    d0_pmt3_ecb   :   std_logic_vector(47 downto 0) := ( others => '0');
         
    SIGNAL    d0_pmt4_ecb   :   std_logic_vector(47 downto 0) := ( others => '0');
        

BEGIN
        data_ki                <= data_s;
        frame_ki               <= frame_s;
				
		gen_I_ec:process
		variable p0_s1,p1_s1,p2_s1,p3_s1,p4_s1,p5_s1,p6_s1,p7_s1	: integer;
		variable p0_s2,p1_s2,p2_s2,p3_s2,p4_s2,p5_s2,p6_s2,p7_s2	: integer;
		variable p0_s3,p1_s3,p2_s3,p3_s3,p4_s3,p5_s3,p6_s3,p7_s3	: integer;
		variable p0_s4,p1_s4,p2_s4,p3_s4,p4_s4,p5_s4,p6_s4,p7_s4	: integer;
		variable line_in_ec	:	line;
		FILE	 file_in_ec	:	text;
	begin
	    case (file_name) is
            when 0 =>
                FILE_OPEN(file_in_ec,"Data_IN-KI_EC0EC3EC6.txt",READ_MODE);
            when 1 =>
                FILE_OPEN(file_in_ec,"Data_IN-KI_EC1EC4EC7.txt",READ_MODE);
            when 2 =>
                FILE_OPEN(file_in_ec,"Data_IN-KI_EC2EC5EC8.txt",READ_MODE);    
           when others =>
               null;
        end case;
		
		wait for 100*period;
		wait for delay_data;
		
		while not endfile(file_in_ec) loop
			--Line1
			readline(file_in_ec,line_in_ec);
			read(line_in_ec,p7_s1);
			read(line_in_ec,p6_s1);
			read(line_in_ec,p5_s1);
			read(line_in_ec,p4_s1);
			read(line_in_ec,p3_s1);
			read(line_in_ec,p2_s1);
			read(line_in_ec,p1_s1);
			read(line_in_ec,p0_s1);
			
			d0_pmt1_ect(47 downto 42)	<= conv_std_logic_vector(p0_s1,6);
			d0_pmt1_ect(41 downto 36)	<= conv_std_logic_vector(p1_s1,6);
			d0_pmt1_ect(35 downto 30)	<= conv_std_logic_vector(p2_s1,6);
			d0_pmt1_ect(29 downto 24)	<= conv_std_logic_vector(p3_s1,6);
			d0_pmt1_ect(23 downto 18)	<= conv_std_logic_vector(p4_s1,6);
			d0_pmt1_ect(17 downto 12)	<= conv_std_logic_vector(p5_s1,6);
			d0_pmt1_ect(11 downto 6) 	<= conv_std_logic_vector(p6_s1,6);
			d0_pmt1_ect(5 downto 0) 	<= conv_std_logic_vector(p7_s1,6);
			
			--Empty line(2)
            readline(file_in_ec,line_in_ec);
           
			--Line3
			readline(file_in_ec,line_in_ec);
			read(line_in_ec,p7_s2);
			read(line_in_ec,p6_s2);
			read(line_in_ec,p5_s2);
			read(line_in_ec,p4_s2);
			read(line_in_ec,p3_s2);
			read(line_in_ec,p2_s2);
			read(line_in_ec,p1_s2);
			read(line_in_ec,p0_s2);
			
			d0_pmt2_ect(47 downto 42)	<= conv_std_logic_vector(p0_s2,6);
			d0_pmt2_ect(41 downto 36)	<= conv_std_logic_vector(p1_s2,6);
			d0_pmt2_ect(35 downto 30)	<= conv_std_logic_vector(p2_s2,6);
			d0_pmt2_ect(29 downto 24)	<= conv_std_logic_vector(p3_s2,6);
			d0_pmt2_ect(23 downto 18)	<= conv_std_logic_vector(p4_s2,6);
			d0_pmt2_ect(17 downto 12)	<= conv_std_logic_vector(p5_s2,6);
			d0_pmt2_ect(11 downto 6) 	<= conv_std_logic_vector(p6_s2,6);
			d0_pmt2_ect(5 downto 0) 	<= conv_std_logic_vector(p7_s2,6);
			
			--Empty line(4)
            readline(file_in_ec,line_in_ec);
			
			--Line5
			readline(file_in_ec,line_in_ec);
			read(line_in_ec,p7_s3);
			read(line_in_ec,p6_s3);
			read(line_in_ec,p5_s3);
			read(line_in_ec,p4_s3);
			read(line_in_ec,p3_s3);
			read(line_in_ec,p2_s3);
			read(line_in_ec,p1_s3);
			read(line_in_ec,p0_s3);
			
			d0_pmt3_ect(47 downto 42)	<= conv_std_logic_vector(p0_s3,6);
			d0_pmt3_ect(41 downto 36)	<= conv_std_logic_vector(p1_s3,6);
			d0_pmt3_ect(35 downto 30)	<= conv_std_logic_vector(p2_s3,6);
			d0_pmt3_ect(29 downto 24)	<= conv_std_logic_vector(p3_s3,6);
			d0_pmt3_ect(23 downto 18)	<= conv_std_logic_vector(p4_s3,6);
			d0_pmt3_ect(17 downto 12)	<= conv_std_logic_vector(p5_s3,6);
			d0_pmt3_ect(11 downto 6) 	<= conv_std_logic_vector(p6_s3,6);
			d0_pmt3_ect(5 downto 0) 	<= conv_std_logic_vector(p7_s3,6);
			
			--Empty line(6)
            readline(file_in_ec,line_in_ec);
			
			--Line7
			readline(file_in_ec,line_in_ec);
			read(line_in_ec,p7_s4);
			read(line_in_ec,p6_s4);
			read(line_in_ec,p5_s4);
			read(line_in_ec,p4_s4);
			read(line_in_ec,p3_s4);
			read(line_in_ec,p2_s4);
			read(line_in_ec,p1_s4);
			read(line_in_ec,p0_s4);
			
			d0_pmt4_ect(47 downto 42)	<= conv_std_logic_vector(p0_s4,6);
			d0_pmt4_ect(41 downto 36)	<= conv_std_logic_vector(p1_s4,6);
			d0_pmt4_ect(35 downto 30)	<= conv_std_logic_vector(p2_s4,6);
			d0_pmt4_ect(29 downto 24)	<= conv_std_logic_vector(p3_s4,6);
			d0_pmt4_ect(23 downto 18)	<= conv_std_logic_vector(p4_s4,6);
			d0_pmt4_ect(17 downto 12)	<= conv_std_logic_vector(p5_s4,6);
			d0_pmt4_ect(11 downto 6) 	<= conv_std_logic_vector(p6_s4,6);
			d0_pmt4_ect(5 downto 0) 	<= conv_std_logic_vector(p7_s4,6);
			
			--Empty line(8)
            readline(file_in_ec,line_in_ec);
			
			---------------------------------------------
			--ECm
			---------------------------------------------
            --Line9
            readline(file_in_ec,line_in_ec);
            read(line_in_ec,p7_s1);
            read(line_in_ec,p6_s1);
            read(line_in_ec,p5_s1);
            read(line_in_ec,p4_s1);
            read(line_in_ec,p3_s1);
            read(line_in_ec,p2_s1);
            read(line_in_ec,p1_s1);
            read(line_in_ec,p0_s1);
            
            d0_pmt1_ecm(47 downto 42)    <= conv_std_logic_vector(p0_s1,6);
            d0_pmt1_ecm(41 downto 36)    <= conv_std_logic_vector(p1_s1,6);
            d0_pmt1_ecm(35 downto 30)    <= conv_std_logic_vector(p2_s1,6);
            d0_pmt1_ecm(29 downto 24)    <= conv_std_logic_vector(p3_s1,6);
            d0_pmt1_ecm(23 downto 18)    <= conv_std_logic_vector(p4_s1,6);
            d0_pmt1_ecm(17 downto 12)    <= conv_std_logic_vector(p5_s1,6);
            d0_pmt1_ecm(11 downto 6)     <= conv_std_logic_vector(p6_s1,6);
            d0_pmt1_ecm(5 downto 0)     <= conv_std_logic_vector(p7_s1,6);
            
            --Empty line(10)
            readline(file_in_ec,line_in_ec);
            
            --Line11
            readline(file_in_ec,line_in_ec);
            read(line_in_ec,p7_s2);
            read(line_in_ec,p6_s2);
            read(line_in_ec,p5_s2);
            read(line_in_ec,p4_s2);
            read(line_in_ec,p3_s2);
            read(line_in_ec,p2_s2);
            read(line_in_ec,p1_s2);
            read(line_in_ec,p0_s2);
            
            d0_pmt2_ecm(47 downto 42)    <= conv_std_logic_vector(p0_s2,6);
            d0_pmt2_ecm(41 downto 36)    <= conv_std_logic_vector(p1_s2,6);
            d0_pmt2_ecm(35 downto 30)    <= conv_std_logic_vector(p2_s2,6);
            d0_pmt2_ecm(29 downto 24)    <= conv_std_logic_vector(p3_s2,6);
            d0_pmt2_ecm(23 downto 18)    <= conv_std_logic_vector(p4_s2,6);
            d0_pmt2_ecm(17 downto 12)    <= conv_std_logic_vector(p5_s2,6);
            d0_pmt2_ecm(11 downto 6)     <= conv_std_logic_vector(p6_s2,6);
            d0_pmt2_ecm(5 downto 0)     <= conv_std_logic_vector(p7_s2,6);
            
            --Empty line(12)
            readline(file_in_ec,line_in_ec);
            
            --Line13
            readline(file_in_ec,line_in_ec);
            read(line_in_ec,p7_s3);
            read(line_in_ec,p6_s3);
            read(line_in_ec,p5_s3);
            read(line_in_ec,p4_s3);
            read(line_in_ec,p3_s3);
            read(line_in_ec,p2_s3);
            read(line_in_ec,p1_s3);
            read(line_in_ec,p0_s3);
            
            d0_pmt3_ecm(47 downto 42)    <= conv_std_logic_vector(p0_s3,6);
            d0_pmt3_ecm(41 downto 36)    <= conv_std_logic_vector(p1_s3,6);
            d0_pmt3_ecm(35 downto 30)    <= conv_std_logic_vector(p2_s3,6);
            d0_pmt3_ecm(29 downto 24)    <= conv_std_logic_vector(p3_s3,6);
            d0_pmt3_ecm(23 downto 18)    <= conv_std_logic_vector(p4_s3,6);
            d0_pmt3_ecm(17 downto 12)    <= conv_std_logic_vector(p5_s3,6);
            d0_pmt3_ecm(11 downto 6)     <= conv_std_logic_vector(p6_s3,6);
            d0_pmt3_ecm(5 downto 0)     <= conv_std_logic_vector(p7_s3,6);
            
            --Empty line(14)
            readline(file_in_ec,line_in_ec);
            
            --Line15
            readline(file_in_ec,line_in_ec);
            read(line_in_ec,p7_s4);
            read(line_in_ec,p6_s4);
            read(line_in_ec,p5_s4);
            read(line_in_ec,p4_s4);
            read(line_in_ec,p3_s4);
            read(line_in_ec,p2_s4);
            read(line_in_ec,p1_s4);
            read(line_in_ec,p0_s4);
            
            d0_pmt4_ecm(47 downto 42)    <= conv_std_logic_vector(p0_s4,6);
            d0_pmt4_ecm(41 downto 36)    <= conv_std_logic_vector(p1_s4,6);
            d0_pmt4_ecm(35 downto 30)    <= conv_std_logic_vector(p2_s4,6);
            d0_pmt4_ecm(29 downto 24)    <= conv_std_logic_vector(p3_s4,6);
            d0_pmt4_ecm(23 downto 18)    <= conv_std_logic_vector(p4_s4,6);
            d0_pmt4_ecm(17 downto 12)    <= conv_std_logic_vector(p5_s4,6);
            d0_pmt4_ecm(11 downto 6)     <= conv_std_logic_vector(p6_s4,6);
            d0_pmt4_ecm(5 downto 0)     <= conv_std_logic_vector(p7_s4,6);
            
            --Empty line(16)
            readline(file_in_ec,line_in_ec);
            -----------------------------------------------------------
            --ECb
            -----------------------------------------------------------
            --Line17
            readline(file_in_ec,line_in_ec);
            read(line_in_ec,p7_s1);
            read(line_in_ec,p6_s1);
            read(line_in_ec,p5_s1);
            read(line_in_ec,p4_s1);
            read(line_in_ec,p3_s1);
            read(line_in_ec,p2_s1);
            read(line_in_ec,p1_s1);
            read(line_in_ec,p0_s1);
            
            d0_pmt1_ecb(47 downto 42)    <= conv_std_logic_vector(p0_s1,6);
            d0_pmt1_ecb(41 downto 36)    <= conv_std_logic_vector(p1_s1,6);
            d0_pmt1_ecb(35 downto 30)    <= conv_std_logic_vector(p2_s1,6);
            d0_pmt1_ecb(29 downto 24)    <= conv_std_logic_vector(p3_s1,6);
            d0_pmt1_ecb(23 downto 18)    <= conv_std_logic_vector(p4_s1,6);
            d0_pmt1_ecb(17 downto 12)    <= conv_std_logic_vector(p5_s1,6);
            d0_pmt1_ecb(11 downto 6)     <= conv_std_logic_vector(p6_s1,6);
            d0_pmt1_ecb(5 downto 0)     <= conv_std_logic_vector(p7_s1,6);
            
            --Empty line(18)
            readline(file_in_ec,line_in_ec);
            
            --Line19
            readline(file_in_ec,line_in_ec);
            read(line_in_ec,p7_s2);
            read(line_in_ec,p6_s2);
            read(line_in_ec,p5_s2);
            read(line_in_ec,p4_s2);
            read(line_in_ec,p3_s2);
            read(line_in_ec,p2_s2);
            read(line_in_ec,p1_s2);
            read(line_in_ec,p0_s2);
            
            d0_pmt2_ecb(47 downto 42)    <= conv_std_logic_vector(p0_s2,6);
            d0_pmt2_ecb(41 downto 36)    <= conv_std_logic_vector(p1_s2,6);
            d0_pmt2_ecb(35 downto 30)    <= conv_std_logic_vector(p2_s2,6);
            d0_pmt2_ecb(29 downto 24)    <= conv_std_logic_vector(p3_s2,6);
            d0_pmt2_ecb(23 downto 18)    <= conv_std_logic_vector(p4_s2,6);
            d0_pmt2_ecb(17 downto 12)    <= conv_std_logic_vector(p5_s2,6);
            d0_pmt2_ecb(11 downto 6)     <= conv_std_logic_vector(p6_s2,6);
            d0_pmt2_ecb(5 downto 0)     <= conv_std_logic_vector(p7_s2,6);
            
            --Empty line(20)
            readline(file_in_ec,line_in_ec);
            
            --Line21
            readline(file_in_ec,line_in_ec);
            read(line_in_ec,p7_s3);
            read(line_in_ec,p6_s3);
            read(line_in_ec,p5_s3);
            read(line_in_ec,p4_s3);
            read(line_in_ec,p3_s3);
            read(line_in_ec,p2_s3);
            read(line_in_ec,p1_s3);
            read(line_in_ec,p0_s3);
            
            d0_pmt3_ecb(47 downto 42)    <= conv_std_logic_vector(p0_s3,6);
            d0_pmt3_ecb(41 downto 36)    <= conv_std_logic_vector(p1_s3,6);
            d0_pmt3_ecb(35 downto 30)    <= conv_std_logic_vector(p2_s3,6);
            d0_pmt3_ecb(29 downto 24)    <= conv_std_logic_vector(p3_s3,6);
            d0_pmt3_ecb(23 downto 18)    <= conv_std_logic_vector(p4_s3,6);
            d0_pmt3_ecb(17 downto 12)    <= conv_std_logic_vector(p5_s3,6);
            d0_pmt3_ecb(11 downto 6)     <= conv_std_logic_vector(p6_s3,6);
            d0_pmt3_ecb(5 downto 0)     <= conv_std_logic_vector(p7_s3,6);
            
            --Empty line(22)
            readline(file_in_ec,line_in_ec);
            
            --Line23
            readline(file_in_ec,line_in_ec);
            read(line_in_ec,p7_s4);
            read(line_in_ec,p6_s4);
            read(line_in_ec,p5_s4);
            read(line_in_ec,p4_s4);
            read(line_in_ec,p3_s4);
            read(line_in_ec,p2_s4);
            read(line_in_ec,p1_s4);
            read(line_in_ec,p0_s4);
            
            d0_pmt4_ecb(47 downto 42)    <= conv_std_logic_vector(p0_s4,6);
            d0_pmt4_ecb(41 downto 36)    <= conv_std_logic_vector(p1_s4,6);
            d0_pmt4_ecb(35 downto 30)    <= conv_std_logic_vector(p2_s4,6);
            d0_pmt4_ecb(29 downto 24)    <= conv_std_logic_vector(p3_s4,6);
            d0_pmt4_ecb(23 downto 18)    <= conv_std_logic_vector(p4_s4,6);
            d0_pmt4_ecb(17 downto 12)    <= conv_std_logic_vector(p5_s4,6);
            d0_pmt4_ecb(11 downto 6)     <= conv_std_logic_vector(p6_s4,6);
            d0_pmt4_ecb(5 downto 0)     <= conv_std_logic_vector(p7_s4,6);
            
            --Empty line(24)
            readline(file_in_ec,line_in_ec);
            
            wait for period/2;
      			
             ---------------------------------------------
             frame_s <= '1';
             ---------------------------------------------
             data_s(0)   <= d0_pmt1_ect(0);
             data_s(1)   <= d0_pmt3_ect(0);
             data_s(2)   <= d0_pmt1_ecm(0);
             data_s(3)   <= d0_pmt3_ecm(0);
             data_s(4)   <= d0_pmt1_ecb(0);
             data_s(5)   <= d0_pmt3_ecb(0);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(1);
             data_s(1)   <= d0_pmt3_ect(1);
             data_s(2)   <= d0_pmt1_ecm(1);
             data_s(3)   <= d0_pmt3_ecm(1);
             data_s(4)   <= d0_pmt1_ecb(1);
             data_s(5)   <= d0_pmt3_ecb(1);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(2);
             data_s(1)   <= d0_pmt3_ect(2);
             data_s(2)   <= d0_pmt1_ecm(2);
             data_s(3)   <= d0_pmt3_ecm(2);
             data_s(4)   <= d0_pmt1_ecb(2);
             data_s(5)   <= d0_pmt3_ecb(2);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(3);
             data_s(1)   <= d0_pmt3_ect(3);
             data_s(2)   <= d0_pmt1_ecm(3);
             data_s(3)   <= d0_pmt3_ecm(3);
             data_s(4)   <= d0_pmt1_ecb(3);
             data_s(5)   <= d0_pmt3_ecb(3);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(4);
             data_s(1)   <= d0_pmt3_ect(4);
             data_s(2)   <= d0_pmt1_ecm(4);
             data_s(3)   <= d0_pmt3_ecm(4);
             data_s(4)   <= d0_pmt1_ecb(4);
             data_s(5)   <= d0_pmt3_ecb(4);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(5);
             data_s(1)   <= d0_pmt3_ect(5);
             data_s(2)   <= d0_pmt1_ecm(5);
             data_s(3)   <= d0_pmt3_ecm(5);
             data_s(4)   <= d0_pmt1_ecb(5);
             data_s(5)   <= d0_pmt3_ecb(5);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(6);
             data_s(1)   <= d0_pmt3_ect(6);
             data_s(2)   <= d0_pmt1_ecm(6);
             data_s(3)   <= d0_pmt3_ecm(6);
             data_s(4)   <= d0_pmt1_ecb(6);
             data_s(5)   <= d0_pmt3_ecb(6);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(7);
             data_s(1)   <= d0_pmt3_ect(7);
             data_s(2)   <= d0_pmt1_ecm(7);
             data_s(3)   <= d0_pmt3_ecm(7);
             data_s(4)   <= d0_pmt1_ecb(7);
             data_s(5)   <= d0_pmt3_ecb(7);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(8);
             data_s(1)   <= d0_pmt3_ect(8);
             data_s(2)   <= d0_pmt1_ecm(8);
             data_s(3)   <= d0_pmt3_ecm(8);
             data_s(4)   <= d0_pmt1_ecb(8);
             data_s(5)   <= d0_pmt3_ecb(8);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(9);
             data_s(1)   <= d0_pmt3_ect(9);
             data_s(2)   <= d0_pmt1_ecm(9);
             data_s(3)   <= d0_pmt3_ecm(9);
             data_s(4)   <= d0_pmt1_ecb(9);
             data_s(5)   <= d0_pmt3_ecb(9);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(10);
             data_s(1)   <= d0_pmt3_ect(10);
             data_s(2)   <= d0_pmt1_ecm(10);
             data_s(3)   <= d0_pmt3_ecm(10);
             data_s(4)   <= d0_pmt1_ecb(10);
             data_s(5)   <= d0_pmt3_ecb(10);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(11);
             data_s(1)   <= d0_pmt3_ect(11);
             data_s(2)   <= d0_pmt1_ecm(11);
             data_s(3)   <= d0_pmt3_ecm(11);
             data_s(4)   <= d0_pmt1_ecb(11);
             data_s(5)   <= d0_pmt3_ecb(11);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(12);
             data_s(1)   <= d0_pmt3_ect(12);
             data_s(2)   <= d0_pmt1_ecm(12);
             data_s(3)   <= d0_pmt3_ecm(12);
             data_s(4)   <= d0_pmt1_ecb(12);
             data_s(5)   <= d0_pmt3_ecb(12);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(13);
             data_s(1)   <= d0_pmt3_ect(13);
             data_s(2)   <= d0_pmt1_ecm(13);
             data_s(3)   <= d0_pmt3_ecm(13);
             data_s(4)   <= d0_pmt1_ecb(13);
             data_s(5)   <= d0_pmt3_ecb(13);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(14);
             data_s(1)   <= d0_pmt3_ect(14);
             data_s(2)   <= d0_pmt1_ecm(14);
             data_s(3)   <= d0_pmt3_ecm(14);
             data_s(4)   <= d0_pmt1_ecb(14);
             data_s(5)   <= d0_pmt3_ecb(14);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(15);
             data_s(1)   <= d0_pmt3_ect(15);
             data_s(2)   <= d0_pmt1_ecm(15);
             data_s(3)   <= d0_pmt3_ecm(15);
             data_s(4)   <= d0_pmt1_ecb(15);
             data_s(5)   <= d0_pmt3_ecb(15);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(16);
             data_s(1)   <= d0_pmt3_ect(16);
             data_s(2)   <= d0_pmt1_ecm(16);
             data_s(3)   <= d0_pmt3_ecm(16);
             data_s(4)   <= d0_pmt1_ecb(16);
             data_s(5)   <= d0_pmt3_ecb(16);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(17);
             data_s(1)   <= d0_pmt3_ect(17);
             data_s(2)   <= d0_pmt1_ecm(17);
             data_s(3)   <= d0_pmt3_ecm(17);
             data_s(4)   <= d0_pmt1_ecb(17);
             data_s(5)   <= d0_pmt3_ecb(17);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(18);
             data_s(1)   <= d0_pmt3_ect(18);
             data_s(2)   <= d0_pmt1_ecm(18);
             data_s(3)   <= d0_pmt3_ecm(18);
             data_s(4)   <= d0_pmt1_ecb(18);
             data_s(5)   <= d0_pmt3_ecb(18);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(19);
             data_s(1)   <= d0_pmt3_ect(19);
             data_s(2)   <= d0_pmt1_ecm(19);
             data_s(3)   <= d0_pmt3_ecm(19);
             data_s(4)   <= d0_pmt1_ecb(19);
             data_s(5)   <= d0_pmt3_ecb(19);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(20);
             data_s(1)   <= d0_pmt3_ect(20);
             data_s(2)   <= d0_pmt1_ecm(20);
             data_s(3)   <= d0_pmt3_ecm(20);
             data_s(4)   <= d0_pmt1_ecb(20);
             data_s(5)   <= d0_pmt3_ecb(20);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(21);
             data_s(1)   <= d0_pmt3_ect(21);
             data_s(2)   <= d0_pmt1_ecm(21);
             data_s(3)   <= d0_pmt3_ecm(21);
             data_s(4)   <= d0_pmt1_ecb(21);
             data_s(5)   <= d0_pmt3_ecb(21);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(22);
             data_s(1)   <= d0_pmt3_ect(22);
             data_s(2)   <= d0_pmt1_ecm(22);
             data_s(3)   <= d0_pmt3_ecm(22);
             data_s(4)   <= d0_pmt1_ecb(22);
             data_s(5)   <= d0_pmt3_ecb(22);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(23);
             data_s(1)   <= d0_pmt3_ect(23);
             data_s(2)   <= d0_pmt1_ecm(23);
             data_s(3)   <= d0_pmt3_ecm(23);
             data_s(4)   <= d0_pmt1_ecb(23);
             data_s(5)   <= d0_pmt3_ecb(23);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(24);
             data_s(1)   <= d0_pmt3_ect(24);
             data_s(2)   <= d0_pmt1_ecm(24);
             data_s(3)   <= d0_pmt3_ecm(24);
             data_s(4)   <= d0_pmt1_ecb(24);
             data_s(5)   <= d0_pmt3_ecb(24);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(25);
             data_s(1)   <= d0_pmt3_ect(25);
             data_s(2)   <= d0_pmt1_ecm(25);
             data_s(3)   <= d0_pmt3_ecm(25);
             data_s(4)   <= d0_pmt1_ecb(25);
             data_s(5)   <= d0_pmt3_ecb(25);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(26);
             data_s(1)   <= d0_pmt3_ect(26);
             data_s(2)   <= d0_pmt1_ecm(26);
             data_s(3)   <= d0_pmt3_ecm(26);
             data_s(4)   <= d0_pmt1_ecb(26);
             data_s(5)   <= d0_pmt3_ecb(26);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(27);
             data_s(1)   <= d0_pmt3_ect(27);
             data_s(2)   <= d0_pmt1_ecm(27);
             data_s(3)   <= d0_pmt3_ecm(27);
             data_s(4)   <= d0_pmt1_ecb(27);
             data_s(5)   <= d0_pmt3_ecb(27);
            
             wait for period;
             data_s(0)   <= d0_pmt1_ect(28);
             data_s(1)   <= d0_pmt3_ect(28);
             data_s(2)   <= d0_pmt1_ecm(28);
             data_s(3)   <= d0_pmt3_ecm(28);
             data_s(4)   <= d0_pmt1_ecb(28);
             data_s(5)   <= d0_pmt3_ecb(28);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(29);
             data_s(1)   <= d0_pmt3_ect(29);
             data_s(2)   <= d0_pmt1_ecm(29);
             data_s(3)   <= d0_pmt3_ecm(29);
             data_s(4)   <= d0_pmt1_ecb(29);
             data_s(5)   <= d0_pmt3_ecb(29);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(30);
             data_s(1)   <= d0_pmt3_ect(30);
             data_s(2)   <= d0_pmt1_ecm(30);
             data_s(3)   <= d0_pmt3_ecm(30);
             data_s(4)   <= d0_pmt1_ecb(30);
             data_s(5)   <= d0_pmt3_ecb(30);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(31);
             data_s(1)   <= d0_pmt3_ect(31);
             data_s(2)   <= d0_pmt1_ecm(31);
             data_s(3)   <= d0_pmt3_ecm(31);
             data_s(4)   <= d0_pmt1_ecb(31);
             data_s(5)   <= d0_pmt3_ecb(31);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(32);
             data_s(1)   <= d0_pmt3_ect(32);
             data_s(2)   <= d0_pmt1_ecm(32);
             data_s(3)   <= d0_pmt3_ecm(32);
             data_s(4)   <= d0_pmt1_ecb(32);
             data_s(5)   <= d0_pmt3_ecb(32);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(33);
             data_s(1)   <= d0_pmt3_ect(33);
             data_s(2)   <= d0_pmt1_ecm(33);
             data_s(3)   <= d0_pmt3_ecm(33);
             data_s(4)   <= d0_pmt1_ecb(33);
             data_s(5)   <= d0_pmt3_ecb(33);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(34);
             data_s(1)   <= d0_pmt3_ect(34);
             data_s(2)   <= d0_pmt1_ecm(34);
             data_s(3)   <= d0_pmt3_ecm(34);
             data_s(4)   <= d0_pmt1_ecb(34);
             data_s(5)   <= d0_pmt3_ecb(34);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(35);
             data_s(1)   <= d0_pmt3_ect(35);
             data_s(2)   <= d0_pmt1_ecm(35);
             data_s(3)   <= d0_pmt3_ecm(35);
             data_s(4)   <= d0_pmt1_ecb(35);
             data_s(5)   <= d0_pmt3_ecb(35);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(36);
             data_s(1)   <= d0_pmt3_ect(36);
             data_s(2)   <= d0_pmt1_ecm(36);
             data_s(3)   <= d0_pmt3_ecm(36);
             data_s(4)   <= d0_pmt1_ecb(36);
             data_s(5)   <= d0_pmt3_ecb(36);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(37);
             data_s(1)   <= d0_pmt3_ect(37);
             data_s(2)   <= d0_pmt1_ecm(37);
             data_s(3)   <= d0_pmt3_ecm(37);
             data_s(4)   <= d0_pmt1_ecb(37);
             data_s(5)   <= d0_pmt3_ecb(37);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(38);
             data_s(1)   <= d0_pmt3_ect(38);
             data_s(2)   <= d0_pmt1_ecm(38);
             data_s(3)   <= d0_pmt3_ecm(38);
             data_s(4)   <= d0_pmt1_ecb(38);
             data_s(5)   <= d0_pmt3_ecb(38);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(39);
             data_s(1)   <= d0_pmt3_ect(39);
             data_s(2)   <= d0_pmt1_ecm(39);
             data_s(3)   <= d0_pmt3_ecm(39);
             data_s(4)   <= d0_pmt1_ecb(39);
             data_s(5)   <= d0_pmt3_ecb(39);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(40);
             data_s(1)   <= d0_pmt3_ect(40);
             data_s(2)   <= d0_pmt1_ecm(40);
             data_s(3)   <= d0_pmt3_ecm(40);
             data_s(4)   <= d0_pmt1_ecb(40);
             data_s(5)   <= d0_pmt3_ecb(40);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(41);
             data_s(1)   <= d0_pmt3_ect(41);
             data_s(2)   <= d0_pmt1_ecm(41);
             data_s(3)   <= d0_pmt3_ecm(41);
             data_s(4)   <= d0_pmt1_ecb(41);
             data_s(5)   <= d0_pmt3_ecb(41);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(42);
             data_s(1)   <= d0_pmt3_ect(42);
             data_s(2)   <= d0_pmt1_ecm(42);
             data_s(3)   <= d0_pmt3_ecm(42);
             data_s(4)   <= d0_pmt1_ecb(42);
             data_s(5)   <= d0_pmt3_ecb(42);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(43);
             data_s(1)   <= d0_pmt3_ect(43);
             data_s(2)   <= d0_pmt1_ecm(43);
             data_s(3)   <= d0_pmt3_ecm(43);
             data_s(4)   <= d0_pmt1_ecb(43);
             data_s(5)   <= d0_pmt3_ecb(43);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(44);
             data_s(1)   <= d0_pmt3_ect(44);
             data_s(2)   <= d0_pmt1_ecm(44);
             data_s(3)   <= d0_pmt3_ecm(44);
             data_s(4)   <= d0_pmt1_ecb(44);
             data_s(5)   <= d0_pmt3_ecb(44);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(45);
             data_s(1)   <= d0_pmt3_ect(45);
             data_s(2)   <= d0_pmt1_ecm(45);
             data_s(3)   <= d0_pmt3_ecm(45);
             data_s(4)   <= d0_pmt1_ecb(45);
             data_s(5)   <= d0_pmt3_ecb(45);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(46);
             data_s(1)   <= d0_pmt3_ect(46);
             data_s(2)   <= d0_pmt1_ecm(46);
             data_s(3)   <= d0_pmt3_ecm(46);
             data_s(4)   <= d0_pmt1_ecb(46);
             data_s(5)   <= d0_pmt3_ecb(46);
             
             wait for period;
             data_s(0)   <= d0_pmt1_ect(47);
             data_s(1)   <= d0_pmt3_ect(47);
             data_s(2)   <= d0_pmt1_ecm(47);
             data_s(3)   <= d0_pmt3_ecm(47);
             data_s(4)   <= d0_pmt1_ecb(47);
             data_s(5)   <= d0_pmt3_ecb(47);
             
             ---------------------------------------------
             wait for period;
             ---------------------------------------------2-4
             data_s(0)   <= d0_pmt2_ect(0);
             data_s(1)   <= d0_pmt4_ect(0);
             data_s(2)   <= d0_pmt2_ecm(0);
             data_s(3)   <= d0_pmt4_ecm(0);
             data_s(4)   <= d0_pmt2_ecb(0);
             data_s(5)   <= d0_pmt4_ecb(0);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(1);
             data_s(1)   <= d0_pmt4_ect(1);
             data_s(2)   <= d0_pmt2_ecm(1);
             data_s(3)   <= d0_pmt4_ecm(1);
             data_s(4)   <= d0_pmt2_ecb(1);
             data_s(5)   <= d0_pmt4_ecb(1);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(2);
             data_s(1)   <= d0_pmt4_ect(2);
             data_s(2)   <= d0_pmt2_ecm(2);
             data_s(3)   <= d0_pmt4_ecm(2);
             data_s(4)   <= d0_pmt2_ecb(2);
             data_s(5)   <= d0_pmt4_ecb(2);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(3);
             data_s(1)   <= d0_pmt4_ect(3);
             data_s(2)   <= d0_pmt2_ecm(3);
             data_s(3)   <= d0_pmt4_ecm(3);
             data_s(4)   <= d0_pmt2_ecb(3);
             data_s(5)   <= d0_pmt4_ecb(3);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(4);
             data_s(1)   <= d0_pmt4_ect(4);
             data_s(2)   <= d0_pmt2_ecm(4);
             data_s(3)   <= d0_pmt4_ecm(4);
             data_s(4)   <= d0_pmt2_ecb(4);
             data_s(5)   <= d0_pmt4_ecb(4);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(5);
             data_s(1)   <= d0_pmt4_ect(5);
             data_s(2)   <= d0_pmt2_ecm(5);
             data_s(3)   <= d0_pmt4_ecm(5);
             data_s(4)   <= d0_pmt2_ecb(5);
             data_s(5)   <= d0_pmt4_ecb(5);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(6);
             data_s(1)   <= d0_pmt4_ect(6);
             data_s(2)   <= d0_pmt2_ecm(6);
             data_s(3)   <= d0_pmt4_ecm(6);
             data_s(4)   <= d0_pmt2_ecb(6);
             data_s(5)   <= d0_pmt4_ecb(6);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(7);
             data_s(1)   <= d0_pmt4_ect(7);
             data_s(2)   <= d0_pmt2_ecm(7);
             data_s(3)   <= d0_pmt4_ecm(7);
             data_s(4)   <= d0_pmt2_ecb(7);
             data_s(5)   <= d0_pmt4_ecb(7);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(8);
             data_s(1)   <= d0_pmt4_ect(8);
             data_s(2)   <= d0_pmt2_ecm(8);
             data_s(3)   <= d0_pmt4_ecm(8);
             data_s(4)   <= d0_pmt2_ecb(8);
             data_s(5)   <= d0_pmt4_ecb(8);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(9);
             data_s(1)   <= d0_pmt4_ect(9);
             data_s(2)   <= d0_pmt2_ecm(9);
             data_s(3)   <= d0_pmt4_ecm(9);
             data_s(4)   <= d0_pmt2_ecb(9);
             data_s(5)   <= d0_pmt4_ecb(9);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(10);
             data_s(1)   <= d0_pmt4_ect(10);
             data_s(2)   <= d0_pmt2_ecm(10);
             data_s(3)   <= d0_pmt4_ecm(10);
             data_s(4)   <= d0_pmt2_ecb(10);
             data_s(5)   <= d0_pmt4_ecb(10);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(11);
             data_s(1)   <= d0_pmt4_ect(11);
             data_s(2)   <= d0_pmt2_ecm(11);
             data_s(3)   <= d0_pmt4_ecm(11);
             data_s(4)   <= d0_pmt2_ecb(11);
             data_s(5)   <= d0_pmt4_ecb(11);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(12);
             data_s(1)   <= d0_pmt4_ect(12);
             data_s(2)   <= d0_pmt2_ecm(12);
             data_s(3)   <= d0_pmt4_ecm(12);
             data_s(4)   <= d0_pmt2_ecb(12);
             data_s(5)   <= d0_pmt4_ecb(12);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(13);
             data_s(1)   <= d0_pmt4_ect(13);
             data_s(2)   <= d0_pmt2_ecm(13);
             data_s(3)   <= d0_pmt4_ecm(13);
             data_s(4)   <= d0_pmt2_ecb(13);
             data_s(5)   <= d0_pmt4_ecb(13);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(14);
             data_s(1)   <= d0_pmt4_ect(14);
             data_s(2)   <= d0_pmt2_ecm(14);
             data_s(3)   <= d0_pmt4_ecm(14);
             data_s(4)   <= d0_pmt2_ecb(14);
             data_s(5)   <= d0_pmt4_ecb(14);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(15);
             data_s(1)   <= d0_pmt4_ect(15);
             data_s(2)   <= d0_pmt2_ecm(15);
             data_s(3)   <= d0_pmt4_ecm(15);
             data_s(4)   <= d0_pmt2_ecb(15);
             data_s(5)   <= d0_pmt4_ecb(15);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(16);
             data_s(1)   <= d0_pmt4_ect(16);
             data_s(2)   <= d0_pmt2_ecm(16);
             data_s(3)   <= d0_pmt4_ecm(16);
             data_s(4)   <= d0_pmt2_ecb(16);
             data_s(5)   <= d0_pmt4_ecb(16);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(17);
             data_s(1)   <= d0_pmt4_ect(17);
             data_s(2)   <= d0_pmt2_ecm(17);
             data_s(3)   <= d0_pmt4_ecm(17);
             data_s(4)   <= d0_pmt2_ecb(17);
             data_s(5)   <= d0_pmt4_ecb(17);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(18);
             data_s(1)   <= d0_pmt4_ect(18);
             data_s(2)   <= d0_pmt2_ecm(18);
             data_s(3)   <= d0_pmt4_ecm(18);
             data_s(4)   <= d0_pmt2_ecb(18);
             data_s(5)   <= d0_pmt4_ecb(18);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(19);
             data_s(1)   <= d0_pmt4_ect(19);
             data_s(2)   <= d0_pmt2_ecm(19);
             data_s(3)   <= d0_pmt4_ecm(19);
             data_s(4)   <= d0_pmt2_ecb(19);
             data_s(5)   <= d0_pmt4_ecb(19);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(20);
             data_s(1)   <= d0_pmt4_ect(20);
             data_s(2)   <= d0_pmt2_ecm(20);
             data_s(3)   <= d0_pmt4_ecm(20);
             data_s(4)   <= d0_pmt2_ecb(20);
             data_s(5)   <= d0_pmt4_ecb(20);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(21);
             data_s(1)   <= d0_pmt4_ect(21);
             data_s(2)   <= d0_pmt2_ecm(21);
             data_s(3)   <= d0_pmt4_ecm(21);
             data_s(4)   <= d0_pmt2_ecb(21);
             data_s(5)   <= d0_pmt4_ecb(21);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(22);
             data_s(1)   <= d0_pmt4_ect(22);
             data_s(2)   <= d0_pmt2_ecm(22);
             data_s(3)   <= d0_pmt4_ecm(22);
             data_s(4)   <= d0_pmt2_ecb(22);
             data_s(5)   <= d0_pmt4_ecb(22);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(23);
             data_s(1)   <= d0_pmt4_ect(23);
             data_s(2)   <= d0_pmt2_ecm(23);
             data_s(3)   <= d0_pmt4_ecm(23);
             data_s(4)   <= d0_pmt2_ecb(23);
             data_s(5)   <= d0_pmt4_ecb(23);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(24);
             data_s(1)   <= d0_pmt4_ect(24);
             data_s(2)   <= d0_pmt2_ecm(24);
             data_s(3)   <= d0_pmt4_ecm(24);
             data_s(4)   <= d0_pmt2_ecb(24);
             data_s(5)   <= d0_pmt4_ecb(24);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(25);
             data_s(1)   <= d0_pmt4_ect(25);
             data_s(2)   <= d0_pmt2_ecm(25);
             data_s(3)   <= d0_pmt4_ecm(25);
             data_s(4)   <= d0_pmt2_ecb(25);
             data_s(5)   <= d0_pmt4_ecb(25);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(26);
             data_s(1)   <= d0_pmt4_ect(26);
             data_s(2)   <= d0_pmt2_ecm(26);
             data_s(3)   <= d0_pmt4_ecm(26);
             data_s(4)   <= d0_pmt2_ecb(26);
             data_s(5)   <= d0_pmt4_ecb(26);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(27);
             data_s(1)   <= d0_pmt4_ect(27);
             data_s(2)   <= d0_pmt2_ecm(27);
             data_s(3)   <= d0_pmt4_ecm(27);
             data_s(4)   <= d0_pmt2_ecb(27);
             data_s(5)   <= d0_pmt4_ecb(27);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(28);
             data_s(1)   <= d0_pmt4_ect(28);
             data_s(2)   <= d0_pmt2_ecm(28);
             data_s(3)   <= d0_pmt4_ecm(28);
             data_s(4)   <= d0_pmt2_ecb(28);
             data_s(5)   <= d0_pmt4_ecb(28);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(29);
             data_s(1)   <= d0_pmt4_ect(29);
             data_s(2)   <= d0_pmt2_ecm(29);
             data_s(3)   <= d0_pmt4_ecm(29);
             data_s(4)   <= d0_pmt2_ecb(29);
             data_s(5)   <= d0_pmt4_ecb(29);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(30);
             data_s(1)   <= d0_pmt4_ect(30);
             data_s(2)   <= d0_pmt2_ecm(30);
             data_s(3)   <= d0_pmt4_ecm(30);
             data_s(4)   <= d0_pmt2_ecb(30);
             data_s(5)   <= d0_pmt4_ecb(30);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(31);
             data_s(1)   <= d0_pmt4_ect(31);
             data_s(2)   <= d0_pmt2_ecm(31);
             data_s(3)   <= d0_pmt4_ecm(31);
             data_s(4)   <= d0_pmt2_ecb(31);
             data_s(5)   <= d0_pmt4_ecb(31);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(32);
             data_s(1)   <= d0_pmt4_ect(32);
             data_s(2)   <= d0_pmt2_ecm(32);
             data_s(3)   <= d0_pmt4_ecm(32);
             data_s(4)   <= d0_pmt2_ecb(32);
             data_s(5)   <= d0_pmt4_ecb(32);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(33);
             data_s(1)   <= d0_pmt4_ect(33);
             data_s(2)   <= d0_pmt2_ecm(33);
             data_s(3)   <= d0_pmt4_ecm(33);
             data_s(4)   <= d0_pmt2_ecb(33);
             data_s(5)   <= d0_pmt4_ecb(33);
            
             wait for period;
             data_s(0)   <= d0_pmt2_ect(34);
             data_s(1)   <= d0_pmt4_ect(34);
             data_s(2)   <= d0_pmt2_ecm(34);
             data_s(3)   <= d0_pmt4_ecm(34);
             data_s(4)   <= d0_pmt2_ecb(34);
             data_s(5)   <= d0_pmt4_ecb(34);
            
             wait for period;
             data_s(0)   <= d0_pmt2_ect(35);
             data_s(1)   <= d0_pmt4_ect(35);
             data_s(2)   <= d0_pmt2_ecm(35);
             data_s(3)   <= d0_pmt4_ecm(35);
             data_s(4)   <= d0_pmt2_ecb(35);
             data_s(5)   <= d0_pmt4_ecb(35);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(36);
             data_s(1)   <= d0_pmt4_ect(36);
             data_s(2)   <= d0_pmt2_ecm(36);
             data_s(3)   <= d0_pmt4_ecm(36);
             data_s(4)   <= d0_pmt2_ecb(36);
             data_s(5)   <= d0_pmt4_ecb(36);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(37);
             data_s(1)   <= d0_pmt4_ect(37);
             data_s(2)   <= d0_pmt2_ecm(37);
             data_s(3)   <= d0_pmt4_ecm(37);
             data_s(4)   <= d0_pmt2_ecb(37);
             data_s(5)   <= d0_pmt4_ecb(37);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(38);
             data_s(1)   <= d0_pmt4_ect(38);
             data_s(2)   <= d0_pmt2_ecm(38);
             data_s(3)   <= d0_pmt4_ecm(38);
             data_s(4)   <= d0_pmt2_ecb(38);
             data_s(5)   <= d0_pmt4_ecb(38);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(39);
             data_s(1)   <= d0_pmt4_ect(39);
             data_s(2)   <= d0_pmt2_ecm(39);
             data_s(3)   <= d0_pmt4_ecm(39);
             data_s(4)   <= d0_pmt2_ecb(39);
             data_s(5)   <= d0_pmt4_ecb(39);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(40);
             data_s(1)   <= d0_pmt4_ect(40);
             data_s(2)   <= d0_pmt2_ecm(40);
             data_s(3)   <= d0_pmt4_ecm(40);
             data_s(4)   <= d0_pmt2_ecb(40);
             data_s(5)   <= d0_pmt4_ecb(40);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(41);
             data_s(1)   <= d0_pmt4_ect(41);
             data_s(2)   <= d0_pmt2_ecm(41);
             data_s(3)   <= d0_pmt4_ecm(41);
             data_s(4)   <= d0_pmt2_ecb(41);
             data_s(5)   <= d0_pmt4_ecb(41);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(42);
             data_s(1)   <= d0_pmt4_ect(42);
             data_s(2)   <= d0_pmt2_ecm(42);
             data_s(3)   <= d0_pmt4_ecm(42);
             data_s(4)   <= d0_pmt2_ecb(42);
             data_s(5)   <= d0_pmt4_ecb(42);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(43);
             data_s(1)   <= d0_pmt4_ect(43);
             data_s(2)   <= d0_pmt2_ecm(43);
             data_s(3)   <= d0_pmt4_ecm(43);
             data_s(4)   <= d0_pmt2_ecb(43);
             data_s(5)   <= d0_pmt4_ecb(43);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(44);
             data_s(1)   <= d0_pmt4_ect(44);
             data_s(2)   <= d0_pmt2_ecm(44);
             data_s(3)   <= d0_pmt4_ecm(44);
             data_s(4)   <= d0_pmt2_ecb(44);
             data_s(5)   <= d0_pmt4_ecb(44);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(45);
             data_s(1)   <= d0_pmt4_ect(45);
             data_s(2)   <= d0_pmt2_ecm(45);
             data_s(3)   <= d0_pmt4_ecm(45);
             data_s(4)   <= d0_pmt2_ecb(45);
             data_s(5)   <= d0_pmt4_ecb(45);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(46);
             data_s(1)   <= d0_pmt4_ect(46);
             data_s(2)   <= d0_pmt2_ecm(46);
             data_s(3)   <= d0_pmt4_ecm(46);
             data_s(4)   <= d0_pmt2_ecb(46);
             data_s(5)   <= d0_pmt4_ecb(46);
             
             wait for period;
             data_s(0)   <= d0_pmt2_ect(47);
             data_s(1)   <= d0_pmt4_ect(47);
             data_s(2)   <= d0_pmt2_ecm(47);
             data_s(3)   <= d0_pmt4_ecm(47);
             data_s(4)   <= d0_pmt2_ecb(47);
             data_s(5)   <= d0_pmt4_ecb(47);
             
             
             wait for period;
             ---------------------------------------------------
             frame_s        <= '0';
             ------------------------------------------------------------
             wait for 113.5*period;   --Standard FRAME IDLE TIME 07/2022
             ------------------------------------------------------------
		
		end loop;
				
		wait for 100000*period;
		FILE_CLOSE(file_in_ec);
		
	end process;

  --  End Test Bench 
  END arch_DATAGENERATOR_KI;
