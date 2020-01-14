----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/07/2019 01:19:08 PM
-- Design Name: 
-- Module Name: data_converter - Behavioral
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

Library xpm;
use xpm.vcomponents.all;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity data_converter is
    Generic (
   	 	N_ART: integer := 3;
   	 	N_PMT: integer := 12
    );
    Port ( 
    	areset_art: in std_logic;
    	clk_art0 : in STD_LOGIC;
    	clk_art1 : in STD_LOGIC;
    	clk_art2 : in STD_LOGIC;
    	tvalid_art0 : in STD_LOGIC;
    	tvalid_art1 : in STD_LOGIC;
    	tvalid_art2 : in STD_LOGIC;
    	tlast_art0 : in STD_LOGIC;
    	tlast_art1 : in STD_LOGIC;
    	tlast_art2 : in STD_LOGIC;
    	tdata_art0 : in STD_LOGIC_VECTOR(8*12-1 downto 0);
    	tdata_art1 : in STD_LOGIC_VECTOR(8*12-1 downto 0);
    	tdata_art2 : in STD_LOGIC_VECTOR(8*12-1 downto 0);
    	m_axis_aclk: in std_logic;
    	m_axis_aresetn : in STD_LOGIC;
    	m_axis_tdata : out STD_LOGIC_VECTOR(127 downto 0);
    	m_axis_tuser : out STD_LOGIC_VECTOR(5 downto 0);
    	m_axis_tvalid : out STD_LOGIC;
    	m_axis_tlast : out STD_LOGIC;
    	m_axis_tready : in STD_LOGIC    	
    	);
end data_converter;

architecture Behavioral of data_converter is

	COMPONENT axis_dataconv_fifo_0b
		PORT (
			wr_rst_busy : OUT STD_LOGIC;
			rd_rst_busy : OUT STD_LOGIC;
			s_aclk : IN STD_LOGIC;
			s_aresetn : IN STD_LOGIC;
			s_axis_tvalid : IN STD_LOGIC;
			s_axis_tready : OUT STD_LOGIC;
			s_axis_tdata : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			s_axis_tlast : IN STD_LOGIC;
			m_axis_tvalid : OUT STD_LOGIC;
			m_axis_tready : IN STD_LOGIC;
			m_axis_tdata : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			m_axis_tlast : OUT STD_LOGIC
		);
	END COMPONENT;	
	
	COMPONENT axis_dataconv_cc
	  PORT (
	    s_axis_aresetn : IN STD_LOGIC;
	    m_axis_aresetn : IN STD_LOGIC;
	    s_axis_aclk : IN STD_LOGIC;
	    s_axis_tvalid : IN STD_LOGIC;
	    s_axis_tready : OUT STD_LOGIC;
	    s_axis_tdata : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	    s_axis_tlast : IN STD_LOGIC;
	    m_axis_aclk : IN STD_LOGIC;
	    m_axis_tvalid : OUT STD_LOGIC;
	    m_axis_tready : IN STD_LOGIC;
	    m_axis_tdata : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	    m_axis_tlast : OUT STD_LOGIC
	  );
	END COMPONENT;
	
	COMPONENT axis_dataconv_dwc
	  PORT (
	    aclk : IN STD_LOGIC;
	    aresetn : IN STD_LOGIC;
	    s_axis_tvalid : IN STD_LOGIC;
	    s_axis_tready : OUT STD_LOGIC;
	    s_axis_tdata : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	    s_axis_tlast : IN STD_LOGIC;
	    m_axis_tvalid : OUT STD_LOGIC;
	    m_axis_tready : IN STD_LOGIC;
	    m_axis_tdata : OUT STD_LOGIC_VECTOR(127 DOWNTO 0);
	    m_axis_tkeep : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	    m_axis_tlast : OUT STD_LOGIC
	  );
	END COMPONENT;
	
	COMPONENT axis_dataconv_switch_0
	  PORT (
	    aclk : IN STD_LOGIC;
	    aresetn : IN STD_LOGIC;
	    s_axis_tvalid : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
	    s_axis_tready : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
	    s_axis_tdata : IN STD_LOGIC_VECTOR(1535 DOWNTO 0);
	    s_axis_tlast : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
	    s_axis_tuser : IN STD_LOGIC_VECTOR(71 DOWNTO 0);
	    m_axis_tvalid : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
	    m_axis_tready : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
	    m_axis_tdata : OUT STD_LOGIC_VECTOR(127 DOWNTO 0);
	    m_axis_tlast : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
	    m_axis_tuser : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
	    s_req_suppress : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
	    s_decode_err : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
	  );
	END COMPONENT;
	
	COMPONENT axis_dataconv_fifo_1
	  PORT (
	    s_axis_aresetn : IN STD_LOGIC;
	    s_axis_aclk : IN STD_LOGIC;
	    s_axis_tvalid : IN STD_LOGIC;
	    s_axis_tready : OUT STD_LOGIC;
	    s_axis_tdata : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
	    s_axis_tlast : IN STD_LOGIC;
	    s_axis_tuser : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
	    m_axis_tvalid : OUT STD_LOGIC;
	    m_axis_tready : IN STD_LOGIC;
	    m_axis_tdata : OUT STD_LOGIC_VECTOR(127 DOWNTO 0);
	    m_axis_tlast : OUT STD_LOGIC;
	    m_axis_tuser : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
	    axis_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	    axis_wr_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	    axis_rd_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	  );
	END COMPONENT;
	
	COMPONENT axis_dataconv_switch_1
		PORT (
			aclk : IN STD_LOGIC;
			aresetn : IN STD_LOGIC;
			s_axis_tvalid : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			s_axis_tready : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			s_axis_tdata : IN STD_LOGIC_VECTOR(383 DOWNTO 0);
			s_axis_tlast : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			s_axis_tuser : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
			m_axis_tvalid : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
			m_axis_tready : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
			m_axis_tdata : OUT STD_LOGIC_VECTOR(127 DOWNTO 0);
			m_axis_tlast : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
			m_axis_tuser : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
			s_req_suppress : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			s_decode_err : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT axis_dataconv_slice_0
		PORT (
			aclk : IN STD_LOGIC;
			aresetn : IN STD_LOGIC;
			s_axis_tvalid : IN STD_LOGIC;
			s_axis_tready : OUT STD_LOGIC;
			s_axis_tdata : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
			s_axis_tlast : IN STD_LOGIC;
			m_axis_tvalid : OUT STD_LOGIC;
			m_axis_tready : IN STD_LOGIC;
			m_axis_tdata : OUT STD_LOGIC_VECTOR(127 DOWNTO 0);
			m_axis_tlast : OUT STD_LOGIC
		);
	END COMPONENT;

	
	signal tdata_art: std_logic_vector(3*12*8-1 downto 0);
	signal clk_art, tvalid_art, tlast_art: std_logic_vector(2 downto 0);
	signal m_axis_tdata_fifo1: std_logic_vector(16*8*N_ART-1 downto 0);
	signal m_axis_tuser_fifo1: std_logic_vector(6*N_ART-1 downto 0);
	signal m_axis_tvalid_fifo1, m_axis_tready_fifo1, m_axis_tlast_fifo1: std_logic_vector(N_ART-1 downto 0);
	
	signal m_axis_tvalid_sw1, m_axis_tready_sw1, m_axis_tlast_sw1: std_logic_vector(0 downto 0);
	signal s_req_suppress_sw1, s_decode_err_sw1: std_logic_vector(2 downto 0);
	signal m_axis_tdata_sw1: std_logic_vector(127 downto 0);
	signal m_axis_tuser_sw1: std_logic_vector(5 downto 0);
	
	signal s_axis_tvalid_sw1: std_logic_vector(N_ART-1 downto 0) := (others => '0');
	signal s_axis_tready_sw1: std_logic_vector(N_ART-1 downto 0) := (others => '0');
	signal last_transfer_sw1: std_logic_vector(N_ART-1 downto 0) := (others => '0');
	signal start_sw1: std_logic_vector(N_ART-1 downto 0) := (others => '0');

begin

	tdata_art <= tdata_art2 & tdata_art1 & tdata_art0;
	clk_art <= clk_art2 & clk_art1 & clk_art0;
	tvalid_art <= tvalid_art2 & tvalid_art1 & tvalid_art0;
	tlast_art <= tlast_art2 & tlast_art1 & tlast_art0;
	

	art_gen: for i in 0 to N_ART-1 generate
		signal s_axis_aresetn: std_logic := '0';
		signal m_axis_tvalid_sw0, m_axis_tready_sw0, m_axis_tlast_sw0: std_logic_vector(0 downto 0) := "0";
		signal m_axis_tdata_sw0: std_logic_vector(127 downto 0) := (others => '0');
		signal m_axis_tuser_sw0: std_logic_vector(5 downto 0) := (others => '0');

		signal m_axis_tdata_slice: std_logic_vector(8*16*N_PMT-1 downto 0) := (others => '0');
		
				
		signal m_axis_tready_slice: std_logic_vector(N_PMT-1 downto 0) := (others => '0');
		signal m_axis_tvalid_slice: std_logic_vector(N_PMT-1 downto 0) := (others => '0');
		signal m_axis_tlast_slice: std_logic_vector(N_PMT-1 downto 0) := (others => '0');
		signal last_transfer: std_logic_vector(N_PMT-1 downto 0) := (others => '0');
		signal tuser: std_logic_vector(6*N_PMT-1 downto 0) := (others => '0');
		signal s_axis_tlast_fifo1: std_logic := '0';
		
		signal s_req_suppress: std_logic_vector(N_PMT-1 downto 0) := (others => '0');
		signal s_decode_err: std_logic_vector(N_PMT-1 downto 0) := (others => '0');
		
		signal start: std_logic_vector(N_PMT-1 downto 0) := (others => '0');
		signal pass_sw1: std_logic := '0';
		
	begin

 xpm_cdc_async_rst_inst : xpm_cdc_async_rst
   generic map (
      DEST_SYNC_FF => 4,    -- DECIMAL; range: 2-10
      INIT_SYNC_FF => 0,    -- DECIMAL; 0=disable simulation init values, 1=enable simulation init values
      RST_ACTIVE_HIGH => 0  -- DECIMAL; 0=active low reset, 1=active high reset
   )
   port map (
      dest_arst => s_axis_aresetn, -- 1-bit output: src_arst asynchronous reset signal synchronized to destination
                              -- clock domain. This output is registered. NOTE: Signal asserts asynchronously
                              -- but deasserts synchronously to dest_clk. Width of the reset signal is at least
                              -- (DEST_SYNC_FF*dest_clk) period.

      dest_clk => clk_art(i),   -- 1-bit input: Destination clock.
      src_arst => areset_art    -- 1-bit input: Source asynchronous reset signal.
   );
	


		pmt_gen: for j in 0 to N_PMT-1 generate
		
			signal m_axis_tvalid_slice0, m_axis_tready_slice0, m_axis_tlast_slice0: std_logic := '0';
			signal m_axis_tvalid_slice0p, m_axis_tready_slice0p, m_axis_tlast_slice0p: std_logic := '0';
			signal m_axis_tvalid_cc, m_axis_tready_cc, m_axis_tlast_cc: std_logic := '0';
			signal m_axis_tready_dwc, m_axis_tvalid_dwc, m_axis_tlast_dwc: std_logic := '0';
			signal m_axis_tdata_cc: std_logic_vector(7 downto 0) := X"00";
			signal m_axis_tdata_dwc: std_logic_vector(8*16-1 downto 0) := (others => '0');
			signal m_axis_tdata_slice0p: std_logic_vector(8*16-1 downto 0) := (others => '0');
			signal m_axis_tready_fifo0b, m_axis_tvalid_fifo0b, m_axis_tlast_fifo0b: std_logic := '0';
			signal m_axis_tdata_fifo0b: std_logic_vector(7 downto 0) := X"00";
			
			signal pass: std_logic := '0';
			
		begin
			i_cc : axis_dataconv_cc
				PORT MAP (
					s_axis_aresetn => s_axis_aresetn,
					m_axis_aresetn => m_axis_aresetn,
					s_axis_aclk => clk_art(i),
					s_axis_tvalid => tvalid_art(i),
					s_axis_tready => open,
					s_axis_tdata => tdata_art(12*8*i+8*j+7 downto 12*8*i+8*j),
					s_axis_tlast => tlast_art(i),
					m_axis_aclk => m_axis_aclk,
					m_axis_tvalid => m_axis_tvalid_cc,
					m_axis_tready => m_axis_tready_cc,
					m_axis_tdata => m_axis_tdata_cc,
					m_axis_tlast => m_axis_tlast_cc
				);	

				i_fifo0b : axis_dataconv_fifo_0b
				PORT MAP (
					wr_rst_busy => open,
					rd_rst_busy => open,
					s_aclk => m_axis_aclk,
					s_aresetn => m_axis_aresetn,
					s_axis_tvalid => m_axis_tvalid_cc,
					s_axis_tready => m_axis_tready_cc,
					s_axis_tdata => m_axis_tdata_cc,
					s_axis_tlast => m_axis_tlast_cc,
					m_axis_tvalid => m_axis_tvalid_fifo0b,
					m_axis_tready => m_axis_tready_fifo0b,
					m_axis_tdata => m_axis_tdata_fifo0b,
					m_axis_tlast => m_axis_tlast_fifo0b
				);		
			
	 
				i_dwc : axis_dataconv_dwc
				PORT MAP (
					aclk => m_axis_aclk,
					aresetn => m_axis_aresetn,
					s_axis_tvalid => m_axis_tvalid_fifo0b,
					s_axis_tready => m_axis_tready_fifo0b,
					s_axis_tdata => m_axis_tdata_fifo0b,
					s_axis_tlast => m_axis_tlast_fifo0b,
					m_axis_tvalid => m_axis_tvalid_dwc,
					m_axis_tready => m_axis_tready_dwc,
					m_axis_tdata => m_axis_tdata_dwc,
					m_axis_tkeep => open,
					m_axis_tlast => m_axis_tlast_dwc
				);		

			i_slice1: axis_dataconv_slice_0
				PORT MAP (
					aclk => m_axis_aclk,
					aresetn => m_axis_aresetn,
					s_axis_tvalid => m_axis_tvalid_dwc,
					s_axis_tready => m_axis_tready_dwc,
					s_axis_tdata => m_axis_tdata_dwc,
					s_axis_tlast => m_axis_tlast_dwc,
					m_axis_tvalid => m_axis_tvalid_slice0p,
					m_axis_tready => m_axis_tready_slice0p,
					m_axis_tdata => m_axis_tdata_slice0p,
					m_axis_tlast => m_axis_tlast_slice0p
				);


			i_slice0 : axis_dataconv_slice_0
				PORT MAP (
					aclk => m_axis_aclk,
					aresetn => m_axis_aresetn,
					s_axis_tvalid => m_axis_tvalid_slice0p,
					s_axis_tready => m_axis_tready_slice0p,
					s_axis_tdata => m_axis_tdata_slice0p,
					s_axis_tlast => m_axis_tlast_slice0p,
					m_axis_tvalid => m_axis_tvalid_slice0,
					m_axis_tready => m_axis_tready_slice0,
					m_axis_tdata => m_axis_tdata_slice((j+1)*8*16-1 downto j*8*16),
					m_axis_tlast => m_axis_tlast_slice0
				);

			
			m_axis_tvalid_slice(j) <= m_axis_tvalid_slice0 and pass;
			m_axis_tready_slice0 <= m_axis_tready_slice(j) and pass;
			m_axis_tlast_slice(j) <= m_axis_tlast_slice0;
			
			tuser((j+1)*6-1 downto j*6) <= conv_std_logic_vector(i*16+j, 6);
			
			throttler: process(m_axis_aclk)
				variable state : integer range 0 to 2 := 0;
			begin
				if(rising_edge(m_axis_aclk)) then
					if(m_axis_aresetn = '0') then
						state := 0;
					else
						case state is
							when 0 => if(start(j) = '1') then
													state := state + 1;
													pass <= '1';
												end if;
							when 1 => if((m_axis_tvalid_slice0 and m_axis_tready_slice(j) and m_axis_tlast_slice0) = '1') then
													pass <= '0';
													state := state + 1;
												end if;
							when 2 => if(start(j) = '0') then
													state := 0;
												end if;						
						end case;				
					end if;
				end if;
			end process;
			
		end generate pmt_gen;

	last_transfer <= m_axis_tvalid_slice and m_axis_tready_slice and m_axis_tlast_slice;

	start_seq: process(m_axis_aclk)
	begin
		if(rising_edge(m_axis_aclk)) then
			if(m_axis_aresetn = '0') then
				start <= (0 => '1', others => '0');
			elsif(last_transfer = start) then
				start <= start(10 downto 0) & start(11);
			end if;
		end if;
		
	end process;

	i_sw_0 : axis_dataconv_switch_0
  PORT MAP (
    aclk => m_axis_aclk,
    aresetn => m_axis_aresetn,
    s_axis_tvalid => m_axis_tvalid_slice,
    s_axis_tready => m_axis_tready_slice,
    s_axis_tdata => m_axis_tdata_slice,
    s_axis_tlast => m_axis_tlast_slice,
    s_axis_tuser => tuser,
    m_axis_tvalid => m_axis_tvalid_sw0,
    m_axis_tready => m_axis_tready_sw0,
    m_axis_tdata => m_axis_tdata_sw0,
    m_axis_tlast => m_axis_tlast_sw0,
    m_axis_tuser => m_axis_tuser_sw0,
    s_req_suppress => (others => '0'),
    s_decode_err => s_decode_err
  );
  
  	s_axis_tlast_fifo1 <= m_axis_tlast_sw0(0)  -- Generate TLast only with the last PMT data
  										and m_axis_tuser_sw0(3) 
  										and (not m_axis_tuser_sw0(2)) 
  										and m_axis_tuser_sw0(1)
  										and m_axis_tuser_sw0(0);

		i_fifo1 : axis_dataconv_fifo_1
		PORT MAP (
			s_axis_aresetn => s_axis_aresetn,
			s_axis_aclk => m_axis_aclk,
			s_axis_tvalid => m_axis_tvalid_sw0(0),
			s_axis_tready => m_axis_tready_sw0(0),
			s_axis_tdata => m_axis_tdata_sw0,
			s_axis_tlast => s_axis_tlast_fifo1,--m_axis_tlast_sw0(0),
			s_axis_tuser => m_axis_tuser_sw0,
			m_axis_tvalid => m_axis_tvalid_fifo1(i),
			m_axis_tready => m_axis_tready_fifo1(i),
			m_axis_tdata => m_axis_tdata_fifo1((i+1)*16*8-1 downto 16*8*i),
			m_axis_tlast => m_axis_tlast_fifo1(i),
			m_axis_tuser => m_axis_tuser_fifo1((i+1)*6-1 downto i*6),
			axis_data_count => open,
			axis_wr_data_count => open,
			axis_rd_data_count => open
		);

		s_axis_tvalid_sw1(i) <= m_axis_tvalid_fifo1(i) and pass_sw1;
		m_axis_tready_fifo1(i) <= s_axis_tready_sw1(i) and pass_sw1;
		
			throttler_sw1: process(m_axis_aclk)
				variable state : integer range 0 to 2 := 0;
			begin
				if(rising_edge(m_axis_aclk)) then
					if(m_axis_aresetn = '0') then
						state := 0;
					else
						case state is
							when 0 => if(start_sw1(i) = '1') then
													state := state + 1;
													pass_sw1 <= '1';
												end if;
							when 1 => if((m_axis_tvalid_fifo1(i) and m_axis_tready_fifo1(i) and m_axis_tlast_fifo1(i)) = '1') then
													pass_sw1 <= '0';
													state := state + 1;
												end if;
							when 2 => if(start_sw1(i) = '0') then
													state := 0;
												end if;						
						end case;				
					end if;
				end if;
			end process;


  end generate art_gen;

	last_transfer_sw1 <= m_axis_tvalid_fifo1 and m_axis_tready_fifo1 and m_axis_tlast_fifo1;


		start_seq_sw1: process(m_axis_aclk)
		begin
			if(rising_edge(m_axis_aclk)) then
				if(m_axis_aresetn = '0') then
					start_sw1 <= (0 => '1', others => '0');
				elsif(last_transfer_sw1 = start_sw1) then
					start_sw1 <= start_sw1(1 downto 0) & start_sw1(2);
				end if;
			end if;
		end process;

  
	i_sw1 : axis_dataconv_switch_1
    PORT MAP (
      aclk => m_axis_aclk,
      aresetn => m_axis_aresetn,
      s_axis_tvalid => s_axis_tvalid_sw1,
      s_axis_tready => s_axis_tready_sw1,
      s_axis_tdata => m_axis_tdata_fifo1,
      s_axis_tlast => m_axis_tlast_fifo1,
      s_axis_tuser => m_axis_tuser_fifo1,
      m_axis_tvalid => m_axis_tvalid_sw1,
      m_axis_tready => m_axis_tready_sw1,
      m_axis_tdata => m_axis_tdata_sw1,
      m_axis_tlast => m_axis_tlast_sw1,
      m_axis_tuser => m_axis_tuser_sw1,
      s_req_suppress => (others => '0'),
      s_decode_err => s_decode_err_sw1
    );



	m_axis_tvalid <= m_axis_tvalid_sw1(0);
	m_axis_tready_sw1(0) <= m_axis_tready;
	m_axis_tlast <= m_axis_tlast_sw1(0)  -- Generate TLast only with the last PMT data
										and m_axis_tuser_sw1(5) 
										and (not m_axis_tuser_sw1(4));
	m_axis_tdata <= m_axis_tdata_sw1;
	m_axis_tuser <= m_axis_tuser_sw1;
	
	

end Behavioral;
