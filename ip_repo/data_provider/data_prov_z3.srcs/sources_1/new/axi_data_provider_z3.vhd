----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/03/2019 07:10:00 PM
-- Design Name: 
-- Module Name: axi_data_provider_z3 - Behavioral
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

Library xpm;
use xpm.vcomponents.all;

entity axi_data_provider_z3 is
	generic (
	-- Users to add parameters here

	-- User parameters ends
	-- Do not modify the parameters beyond this line

	-- Width of S_AXI data bus
	C_S_AXI_DATA_WIDTH	: integer	:= 32;
	-- Width of S_AXI address bus
	C_S_AXI_ADDR_WIDTH	: integer	:= 8;
		  SYS_W       : integer := 13;
	C_DATA_WIDTH       : integer := 8;
 	 -- width of the data for the device
	DEV_W       : integer := 104);
	port (
    	-- Users to add ports here
    	
    	art_clk: out std_logic;
    	run_data_conv: out std_logic;
    	
    	s_axis_tdata: in std_logic_vector(127 downto 0);
    	s_axis_tuser: in std_logic_vector(7 downto 0);
    	s_axis_tvalid: in std_logic;
    	s_axis_tready: out std_logic := '1';
    	s_axis_tlast: in std_logic;
    	
     	m_axis_tdata: out std_logic_vector(127 downto 0);
    	m_axis_tuser: out std_logic_vector(7 downto 0);
    	m_axis_tvalid: out std_logic;
    	m_axis_tready: in std_logic;
    	m_axis_tlast: out std_logic;

     	m01_axis_tdata: out std_logic_vector(127 downto 0);
    	m01_axis_tuser: out std_logic_vector(7 downto 0);
    	m01_axis_tvalid: out std_logic;
    	m01_axis_tready: in std_logic;
    	m01_axis_tlast: out std_logic;
    	
    	DATA: out std_logic_vector(143 downto 0);
			FRAME: out std_logic;
    	
    	aux_in: in std_logic_vector(31 downto 0);
    	aux_in2: in std_logic_vector(31 downto 0);
    	bitslip_cnt0: in std_logic_vector(23 downto 0);
    	bitslip_cnt1: in std_logic_vector(23 downto 0);
    	bitslip_cnt2: in std_logic_vector(23 downto 0);
    	reset_data_conv: out std_logic;
    	reset_scurve_adder: out std_logic;
    	zero_pmts: out std_logic_vector(35 downto 0);
   	
    	
    	

    	-- User ports ends
    	-- Do not modify the ports beyond this line

    	-- Global Clock Signal
    	S_AXI_ACLK	: in std_logic;
    	-- Global Reset Signal. This Signal is Active LOW
    	S_AXI_ARESETN	: in std_logic;
    	-- Write address (issued by master, acceped by Slave)
    	S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    	-- Write channel Protection type. This signal indicates the
    		-- privilege and security level of the transaction, and whether
    		-- the transaction is a data access or an instruction access.
    	S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
    	-- Write address valid. This signal indicates that the master signaling
    		-- valid write address and control information.
    	S_AXI_AWVALID	: in std_logic;
    	-- Write address ready. This signal indicates that the slave is ready
    		-- to accept an address and associated control signals.
    	S_AXI_AWREADY	: out std_logic;
    	-- Write data (issued by master, acceped by Slave) 
    	S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    	-- Write strobes. This signal indicates which byte lanes hold
    		-- valid data. There is one write strobe bit for each eight
    		-- bits of the write data bus.    
    	S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
    	-- Write valid. This signal indicates that valid write
    		-- data and strobes are available.
    	S_AXI_WVALID	: in std_logic;
    	-- Write ready. This signal indicates that the slave
    		-- can accept the write data.
    	S_AXI_WREADY	: out std_logic;
    	-- Write response. This signal indicates the status
    		-- of the write transaction.
    	S_AXI_BRESP	: out std_logic_vector(1 downto 0);
    	-- Write response valid. This signal indicates that the channel
    		-- is signaling a valid write response.
    	S_AXI_BVALID	: out std_logic;
    	-- Response ready. This signal indicates that the master
    		-- can accept a write response.
    	S_AXI_BREADY	: in std_logic;
    	-- Read address (issued by master, acceped by Slave)
    	S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    	-- Protection type. This signal indicates the privilege
    		-- and security level of the transaction, and whether the
    		-- transaction is a data access or an instruction access.
    	S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
    	-- Read address valid. This signal indicates that the channel
    		-- is signaling valid read address and control information.
    	S_AXI_ARVALID	: in std_logic;
    	-- Read address ready. This signal indicates that the slave is
    		-- ready to accept an address and associated control signals.
    	S_AXI_ARREADY	: out std_logic;
    	-- Read data (issued by slave)
    	S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    	-- Read response. This signal indicates the status of the
    		-- read transfer.
    	S_AXI_RRESP	: out std_logic_vector(1 downto 0);
    	-- Read valid. This signal indicates that the channel is
    		-- signaling the required read data.
    	S_AXI_RVALID	: out std_logic;
    	-- Read ready. This signal indicates that the master can
    		-- accept the read data and response information.
    	S_AXI_RREADY	: in std_logic
    );
end axi_data_provider_z3;

architecture Behavioral of axi_data_provider_z3 is

	-- AXI4LITE signals
	signal axi_awaddr	: std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
	signal axi_awready	: std_logic;
	signal axi_wready	: std_logic;
	signal axi_bresp	: std_logic_vector(1 downto 0);
	signal axi_bvalid	: std_logic;
	signal axi_araddr	: std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
	signal axi_arready	: std_logic;
	signal axi_rdata	: std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal axi_rresp	: std_logic_vector(1 downto 0);
	signal axi_rvalid	: std_logic;

	-- Example-specific design signals
	-- local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
	-- ADDR_LSB is used for addressing 32/64 bit registers/memories
	-- ADDR_LSB = 2 for 32 bits (n downto 2)
	-- ADDR_LSB = 3 for 64 bits (n downto 3)
	constant ADDR_LSB  : integer := (C_S_AXI_DATA_WIDTH/32)+ 1;
	constant OPT_MEM_ADDR_BITS : integer := 5;
	------------------------------------------------
	---- Signals for user logic register space example
	--------------------------------------------------
	---- Number of Slave Registers 64
	signal slv_reg0	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg1	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg2	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg3	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg4	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg5	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg6	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg7	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg8	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg9	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg10	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg11	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg12	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg13	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg14	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg15	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg16	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg17	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg18	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg19	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg20	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg21	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg22	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg23	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg24	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg25	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg26	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg27	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg28	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg29	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg30	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg31	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg32	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg33	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg34	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg35	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg36	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg37	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg38	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg39	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg40	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg41	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg42	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg43	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg44	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg45	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg46	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg47	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg48	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg49	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg50	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg51	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg52	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg53	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg54	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg55	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg56	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg57	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg58	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg59	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg60	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg61	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg62	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg63	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg_rden	: std_logic;
	signal slv_reg_wren	: std_logic;
	signal reg_data_out	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal byte_index	: integer;
	signal aw_en	: std_logic;
	
	signal art_clk_en: std_logic := '0';
	signal art_clk_i: std_logic := '0';
	signal gtu_1us: std_logic := '0';
	signal run: std_logic := '0';
	signal pass: std_logic := '0';
	signal start_sig: std_logic := '0';
	signal prog_reset: std_logic := '0';
	signal infinite: std_logic := '0';
	
	signal num_of_frames, cnt: std_logic_vector(31 downto 0) := (0 => '1', others => '0');
	signal sm_state: std_logic_vector(3 downto 0) := "0000";
	signal s_axis_tvalid_4trig: std_logic;
	
	component data_provider_4trig is
	    Port ( clk : in STD_LOGIC;
	           aresetn : in STD_LOGIC;
	           s_axis_tdata : in STD_LOGIC_VECTOR (127 downto 0);
	           s_axis_tvalid : in STD_LOGIC;
	           s_axis_tlast : in STD_LOGIC;
	           s_axis_tuser : in std_logic_vector(7 downto 0);
	           DATA : out STD_LOGIC_VECTOR (143 downto 0);
	           FRAME : out STD_LOGIC);
	end component;

	component test_data_provider is
    Port ( 
    clk : in STD_LOGIC;
    aresetn: in std_logic;
    started: in std_logic;
    status : out std_logic_vector(7 downto 0);
    incr_period: in std_logic_vector(31 downto 0);
    patt_init: in std_logic_vector(7 downto 0);
    patt_max: in std_logic_vector(7 downto 0);
    s_axis_tvalid: in std_logic;
    s_axis_tlast: in std_logic;
    m_axis_tvalid: out std_logic;
    m_axis_tlast: out std_logic;
    m_axis_tdata: out std_logic_vector(127 downto 0)
    );
	end component;
	
	signal m_axis_tdata_test: std_logic_vector(127 downto 0) := (others => '0');
	signal m_axis_tuser_test: std_logic_vector(7 downto 0) := (others => '0');
	signal incr_period: std_logic_vector(31 downto 0) := (others => '0');
	signal patt_max, patt_init: std_logic_vector(7 downto 0) := (others => '0');
	signal status_test_dp: std_logic_vector(7 downto 0) := (others => '0');
	signal m_axis_tvalid_test: std_logic := '0';
	signal m_axis_tlast_test: std_logic := '0'; 
	signal test_mode: std_logic := '0';
	signal en_output: std_logic := '0';
	signal test_data_provider_started: std_logic := '0';
	
	signal s_axis_tvalid_cnt: std_logic_vector(31 downto 0) := (others => '0');
	signal s_axis_tvalid_d1: std_logic := '0';

begin

	-- I/O Connections assignments

	S_AXI_AWREADY	<= axi_awready;
	S_AXI_WREADY	<= axi_wready;
	S_AXI_BRESP	<= axi_bresp;
	S_AXI_BVALID	<= axi_bvalid;
	S_AXI_ARREADY	<= axi_arready;
	S_AXI_RDATA	<= axi_rdata;
	S_AXI_RRESP	<= axi_rresp;
	S_AXI_RVALID	<= axi_rvalid;
	-- Implement axi_awready generation
	-- axi_awready is asserted for one S_AXI_ACLK clock cycle when both
	-- S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
	-- de-asserted when reset is low.

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_awready <= '0';
	      aw_en <= '1';
	    else
	      if (axi_awready = '0' and S_AXI_AWVALID = '1' and S_AXI_WVALID = '1' and aw_en = '1') then
	        -- slave is ready to accept write address when
	        -- there is a valid write address and write data
	        -- on the write address and data bus. This design 
	        -- expects no outstanding transactions. 
	        axi_awready <= '1';
	        elsif (S_AXI_BREADY = '1' and axi_bvalid = '1') then
	            aw_en <= '1';
	        	axi_awready <= '0';
	      else
	        axi_awready <= '0';
	      end if;
	    end if;
	  end if;
	end process;

	-- Implement axi_awaddr latching
	-- This process is used to latch the address when both 
	-- S_AXI_AWVALID and S_AXI_WVALID are valid. 

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_awaddr <= (others => '0');
	    else
	      if (axi_awready = '0' and S_AXI_AWVALID = '1' and S_AXI_WVALID = '1' and aw_en = '1') then
	        -- Write Address latching
	        axi_awaddr <= S_AXI_AWADDR;
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement axi_wready generation
	-- axi_wready is asserted for one S_AXI_ACLK clock cycle when both
	-- S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
	-- de-asserted when reset is low. 

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_wready <= '0';
	    else
	      if (axi_wready = '0' and S_AXI_WVALID = '1' and S_AXI_AWVALID = '1' and aw_en = '1') then
	          -- slave is ready to accept write data when 
	          -- there is a valid write address and write data
	          -- on the write address and data bus. This design 
	          -- expects no outstanding transactions.           
	          axi_wready <= '1';
	      else
	        axi_wready <= '0';
	      end if;
	    end if;
	  end if;
	end process; 

	-- Implement memory mapped register select and write logic generation
	-- The write data is accepted and written to memory mapped registers when
	-- axi_awready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted. Write strobes are used to
	-- select byte enables of slave registers while writing.
	-- These registers are cleared when reset (active low) is applied.
	-- Slave register write enable is asserted when valid address and data are available
	-- and the slave is ready to accept the write address and write data.
	slv_reg_wren <= axi_wready and S_AXI_WVALID and axi_awready and S_AXI_AWVALID ;

	process (S_AXI_ACLK)
	variable loc_addr :std_logic_vector(OPT_MEM_ADDR_BITS downto 0); 
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      slv_reg0 <= (others => '0');
	      slv_reg1 <= (others => '0');
	      slv_reg2 <= (others => '0');
	      slv_reg3 <= (others => '0');
	      slv_reg4 <= (others => '0');
	      slv_reg5 <= (others => '0');
	      slv_reg6 <= (others => '0');
	      slv_reg7 <= (others => '0');
	      slv_reg8 <= (others => '0');
	      slv_reg9 <= (others => '0');
	      slv_reg10 <= (others => '0');
	      slv_reg11 <= (others => '0');
	      slv_reg12 <= (others => '0');
	      slv_reg13 <= (others => '0');
	      slv_reg14 <= (others => '0');
	      slv_reg15 <= (others => '0');
--	      slv_reg16 <= (others => '0');
--	      slv_reg17 <= (others => '0');
--	      slv_reg18 <= (others => '0');
--	      slv_reg19 <= (others => '0');
--	      slv_reg20 <= (others => '0');
--	      slv_reg21 <= (others => '0');
--	      slv_reg22 <= (others => '0');
--	      slv_reg23 <= (others => '0');
--	      slv_reg24 <= (others => '0');
--	      slv_reg25 <= (others => '0');
--	      slv_reg26 <= (others => '0');
--	      slv_reg27 <= (others => '0');
--	      slv_reg28 <= (others => '0');
--	      slv_reg29 <= (others => '0');
--	      slv_reg30 <= (others => '0');
--	      slv_reg31 <= (others => '0');
--	      slv_reg32 <= (others => '0');
--	      slv_reg33 <= (others => '0');
--	      slv_reg34 <= (others => '0');
--	      slv_reg35 <= (others => '0');
--	      slv_reg36 <= (others => '0');
--	      slv_reg37 <= (others => '0');
--	      slv_reg38 <= (others => '0');
--	      slv_reg39 <= (others => '0');
--	      slv_reg40 <= (others => '0');
--	      slv_reg41 <= (others => '0');
--	      slv_reg42 <= (others => '0');
--	      slv_reg43 <= (others => '0');
--	      slv_reg44 <= (others => '0');
--	      slv_reg45 <= (others => '0');
--	      slv_reg46 <= (others => '0');
--	      slv_reg47 <= (others => '0');
--	      slv_reg48 <= (others => '0');
--	      slv_reg49 <= (others => '0');
--	      slv_reg50 <= (others => '0');
--	      slv_reg51 <= (others => '0');
--	      slv_reg52 <= (others => '0');
--	      slv_reg53 <= (others => '0');
--	      slv_reg54 <= (others => '0');
--	      slv_reg55 <= (others => '0');
--	      slv_reg56 <= (others => '0');
--	      slv_reg57 <= (others => '0');
--	      slv_reg58 <= (others => '0');
--	      slv_reg59 <= (others => '0');
--	      slv_reg60 <= (others => '0');
--	      slv_reg61 <= (others => '0');
--	      slv_reg62 <= (others => '0');
--	      slv_reg63 <= (others => '0');
	    else
	      loc_addr := axi_awaddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);
	      if (slv_reg_wren = '1') then
	        case loc_addr is
	          when b"000000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 0
	                slv_reg0(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"000001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 1
	                slv_reg1(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"000010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 2
	                slv_reg2(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"000011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 3
	                slv_reg3(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"000100" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 4
	                slv_reg4(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"000101" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 5
	                slv_reg5(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"000110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 6
	                slv_reg6(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"000111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 7
	                slv_reg7(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"001000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 8
	                slv_reg8(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"001001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 9
	                slv_reg9(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"001010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 10
	                slv_reg10(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"001011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 11
	                slv_reg11(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"001100" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 12
	                slv_reg12(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"001101" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 13
	                slv_reg13(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"001110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 14
	                slv_reg14(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"001111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 15
	                slv_reg15(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
--	          when b"010000" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 16
--	                slv_reg16(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"010001" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 17
--	                slv_reg17(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"010010" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 18
--	                slv_reg18(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"010011" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 19
--	                slv_reg19(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"010100" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 20
--	                slv_reg20(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"010101" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 21
--	                slv_reg21(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"010110" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 22
--	                slv_reg22(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"010111" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 23
--	                slv_reg23(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"011000" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 24
--	                slv_reg24(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"011001" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 25
--	                slv_reg25(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"011010" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 26
--	                slv_reg26(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"011011" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 27
--	                slv_reg27(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"011100" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 28
--	                slv_reg28(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"011101" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 29
--	                slv_reg29(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"011110" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 30
--	                slv_reg30(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"011111" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 31
--	                slv_reg31(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"100000" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 32
--	                slv_reg32(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"100001" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 33
--	                slv_reg33(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"100010" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 34
--	                slv_reg34(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"100011" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 35
--	                slv_reg35(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"100100" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 36
--	                slv_reg36(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"100101" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 37
--	                slv_reg37(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"100110" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 38
--	                slv_reg38(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"100111" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 39
--	                slv_reg39(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"101000" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 40
--	                slv_reg40(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"101001" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 41
--	                slv_reg41(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"101010" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 42
--	                slv_reg42(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"101011" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 43
--	                slv_reg43(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"101100" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 44
--	                slv_reg44(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"101101" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 45
--	                slv_reg45(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"101110" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 46
--	                slv_reg46(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"101111" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 47
--	                slv_reg47(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"110000" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 48
--	                slv_reg48(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"110001" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 49
--	                slv_reg49(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"110010" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 50
--	                slv_reg50(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"110011" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 51
--	                slv_reg51(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"110100" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 52
--	                slv_reg52(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"110101" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 53
--	                slv_reg53(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"110110" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 54
--	                slv_reg54(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"110111" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 55
--	                slv_reg55(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"111000" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 56
--	                slv_reg56(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"111001" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 57
--	                slv_reg57(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"111010" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 58
--	                slv_reg58(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"111011" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 59
--	                slv_reg59(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"111100" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 60
--	                slv_reg60(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"111101" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 61
--	                slv_reg61(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"111110" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 62
--	                slv_reg62(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
--	          when b"111111" =>
--	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
--	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
--	                -- Respective byte enables are asserted as per write strobes                   
--	                -- slave registor 63
--	                slv_reg63(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
--	              end if;
--	            end loop;
	          when others =>
	            slv_reg0 <= slv_reg0;
	            slv_reg1 <= slv_reg1;
	            slv_reg2 <= slv_reg2;
	            slv_reg3 <= slv_reg3;
	            slv_reg4 <= slv_reg4;
	            slv_reg5 <= slv_reg5;
	            slv_reg6 <= slv_reg6;
	            slv_reg7 <= slv_reg7;
	            slv_reg8 <= slv_reg8;
	            slv_reg9 <= slv_reg9;
	            slv_reg10 <= slv_reg10;
	            slv_reg11 <= slv_reg11;
	            slv_reg12 <= slv_reg12;
	            slv_reg13 <= slv_reg13;
	            slv_reg14 <= slv_reg14;
	            slv_reg15 <= slv_reg15;
--	            slv_reg16 <= slv_reg16;
--	            slv_reg17 <= slv_reg17;
--	            slv_reg18 <= slv_reg18;
--	            slv_reg19 <= slv_reg19;
--	            slv_reg20 <= slv_reg20;
--	            slv_reg21 <= slv_reg21;
--	            slv_reg22 <= slv_reg22;
--	            slv_reg23 <= slv_reg23;
--	            slv_reg24 <= slv_reg24;
--	            slv_reg25 <= slv_reg25;
--	            slv_reg26 <= slv_reg26;
--	            slv_reg27 <= slv_reg27;
--	            slv_reg28 <= slv_reg28;
--	            slv_reg29 <= slv_reg29;
--	            slv_reg30 <= slv_reg30;
--	            slv_reg31 <= slv_reg31;
--	            slv_reg32 <= slv_reg32;
--	            slv_reg33 <= slv_reg33;
--	            slv_reg34 <= slv_reg34;
--	            slv_reg35 <= slv_reg35;
--	            slv_reg36 <= slv_reg36;
--	            slv_reg37 <= slv_reg37;
--	            slv_reg38 <= slv_reg38;
--	            slv_reg39 <= slv_reg39;
--	            slv_reg40 <= slv_reg40;
--	            slv_reg41 <= slv_reg41;
--	            slv_reg42 <= slv_reg42;
--	            slv_reg43 <= slv_reg43;
--	            slv_reg44 <= slv_reg44;
--	            slv_reg45 <= slv_reg45;
--	            slv_reg46 <= slv_reg46;
--	            slv_reg47 <= slv_reg47;
--	            slv_reg48 <= slv_reg48;
--	            slv_reg49 <= slv_reg49;
--	            slv_reg50 <= slv_reg50;
--	            slv_reg51 <= slv_reg51;
--	            slv_reg52 <= slv_reg52;
--	            slv_reg53 <= slv_reg53;
--	            slv_reg54 <= slv_reg54;
--	            slv_reg55 <= slv_reg55;
--	            slv_reg56 <= slv_reg56;
--	            slv_reg57 <= slv_reg57;
--	            slv_reg58 <= slv_reg58;
--	            slv_reg59 <= slv_reg59;
--	            slv_reg60 <= slv_reg60;
--	            slv_reg61 <= slv_reg61;
--	            slv_reg62 <= slv_reg62;
--	            slv_reg63 <= slv_reg63;
	        end case;
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement write response logic generation
	-- The write response and response valid signals are asserted by the slave 
	-- when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.  
	-- This marks the acceptance of address and indicates the status of 
	-- write transaction.

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_bvalid  <= '0';
	      axi_bresp   <= "00"; --need to work more on the responses
	    else
	      if (axi_awready = '1' and S_AXI_AWVALID = '1' and axi_wready = '1' and S_AXI_WVALID = '1' and axi_bvalid = '0'  ) then
	        axi_bvalid <= '1';
	        axi_bresp  <= "00"; 
	      elsif (S_AXI_BREADY = '1' and axi_bvalid = '1') then   --check if bready is asserted while bvalid is high)
	        axi_bvalid <= '0';                                 -- (there is a possibility that bready is always asserted high)
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement axi_arready generation
	-- axi_arready is asserted for one S_AXI_ACLK clock cycle when
	-- S_AXI_ARVALID is asserted. axi_awready is 
	-- de-asserted when reset (active low) is asserted. 
	-- The read address is also latched when S_AXI_ARVALID is 
	-- asserted. axi_araddr is reset to zero on reset assertion.

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_arready <= '0';
	      axi_araddr  <= (others => '1');
	    else
	      if (axi_arready = '0' and S_AXI_ARVALID = '1') then
	        -- indicates that the slave has acceped the valid read address
	        axi_arready <= '1';
	        -- Read Address latching 
	        axi_araddr  <= S_AXI_ARADDR;           
	      else
	        axi_arready <= '0';
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement axi_arvalid generation
	-- axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both 
	-- S_AXI_ARVALID and axi_arready are asserted. The slave registers 
	-- data are available on the axi_rdata bus at this instance. The 
	-- assertion of axi_rvalid marks the validity of read data on the 
	-- bus and axi_rresp indicates the status of read transaction.axi_rvalid 
	-- is deasserted on reset (active low). axi_rresp and axi_rdata are 
	-- cleared to zero on reset (active low).  
	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then
	    if S_AXI_ARESETN = '0' then
	      axi_rvalid <= '0';
	      axi_rresp  <= "00";
	    else
	      if (axi_arready = '1' and S_AXI_ARVALID = '1' and axi_rvalid = '0') then
	        -- Valid read data is available at the read data bus
	        axi_rvalid <= '1';
	        axi_rresp  <= "00"; -- 'OKAY' response
	      elsif (axi_rvalid = '1' and S_AXI_RREADY = '1') then
	        -- Read data is accepted by the master
	        axi_rvalid <= '0';
	      end if;            
	    end if;
	  end if;
	end process;

	-- Implement memory mapped register select and read logic generation
	-- Slave register read enable is asserted when valid address is available
	-- and the slave is ready to accept the read address.
	slv_reg_rden <= axi_arready and S_AXI_ARVALID and (not axi_rvalid) ;

	process (slv_reg0, slv_reg1, slv_reg2, slv_reg3, slv_reg4, slv_reg5, slv_reg6, slv_reg7, slv_reg8, slv_reg9, slv_reg10, slv_reg11, slv_reg12, slv_reg13, slv_reg14, slv_reg15, slv_reg16, slv_reg17, slv_reg18, slv_reg19, slv_reg20, slv_reg21, slv_reg22, slv_reg23, slv_reg24, slv_reg25, slv_reg26, slv_reg27, slv_reg28, slv_reg29, slv_reg30, slv_reg31, slv_reg32, slv_reg33, slv_reg34, slv_reg35, slv_reg36, slv_reg37, slv_reg38, slv_reg39, slv_reg40, slv_reg41, slv_reg42, slv_reg43, slv_reg44, slv_reg45, slv_reg46, slv_reg47, slv_reg48, slv_reg49, slv_reg50, slv_reg51, slv_reg52, slv_reg53, slv_reg54, slv_reg55, slv_reg56, slv_reg57, slv_reg58, slv_reg59, slv_reg60, slv_reg61, slv_reg62, slv_reg63, axi_araddr, S_AXI_ARESETN, slv_reg_rden)
	variable loc_addr :std_logic_vector(OPT_MEM_ADDR_BITS downto 0);
	begin
	    -- Address decoding for reading registers
	    loc_addr := axi_araddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);
	    case loc_addr is
	      when b"000000" =>
	        reg_data_out <= slv_reg0;
	      when b"000001" =>
	        reg_data_out <= slv_reg1;
	      when b"000010" =>
	        reg_data_out <= slv_reg2;
	      when b"000011" =>
	        reg_data_out <= slv_reg3;
	      when b"000100" =>
	        reg_data_out <= slv_reg4;
	      when b"000101" =>
	        reg_data_out <= slv_reg5;
	      when b"000110" =>
	        reg_data_out <= slv_reg6;
	      when b"000111" =>
	        reg_data_out <= slv_reg7;
	      when b"001000" =>
	        reg_data_out <= slv_reg8;
	      when b"001001" =>
	        reg_data_out <= slv_reg9;
	      when b"001010" =>
	        reg_data_out <= slv_reg10;
	      when b"001011" =>
	        reg_data_out <= slv_reg11;
	      when b"001100" =>
	        reg_data_out <= slv_reg12;
	      when b"001101" =>
	        reg_data_out <= slv_reg13;
	      when b"001110" =>
	        reg_data_out <= slv_reg14;
	      when b"001111" =>
	        reg_data_out <= slv_reg15;
	      when b"010000" =>
	        reg_data_out <= slv_reg16;
	      when b"010001" =>
	        reg_data_out <= slv_reg17;
	      when b"010010" =>
	        reg_data_out <= slv_reg18;
	      when b"010011" =>
	        reg_data_out <= slv_reg19;
	      when b"010100" =>
	        reg_data_out <= slv_reg20;
	      when b"010101" =>
	        reg_data_out <= slv_reg21;
	      when b"010110" =>
	        reg_data_out <= slv_reg22;
	      when b"010111" =>
	        reg_data_out <= slv_reg23;
	      when b"011000" =>
	        reg_data_out <= slv_reg24;
	      when b"011001" =>
	        reg_data_out <= slv_reg25;
	      when b"011010" =>
	        reg_data_out <= slv_reg26;
	      when b"011011" =>
	        reg_data_out <= slv_reg27;
	      when b"011100" =>
	        reg_data_out <= slv_reg28;
	      when b"011101" =>
	        reg_data_out <= slv_reg29;
	      when b"011110" =>
	        reg_data_out <= slv_reg30;
	      when b"011111" =>
	        reg_data_out <= slv_reg31;
	      when b"100000" =>
	        reg_data_out <= slv_reg32;
	      when b"100001" =>
	        reg_data_out <= slv_reg33;
	      when b"100010" =>
	        reg_data_out <= slv_reg34;
	      when b"100011" =>
	        reg_data_out <= slv_reg35;
	      when b"100100" =>
	        reg_data_out <= slv_reg36;
	      when b"100101" =>
	        reg_data_out <= slv_reg37;
	      when b"100110" =>
	        reg_data_out <= slv_reg38;
	      when b"100111" =>
	        reg_data_out <= slv_reg39;
	      when b"101000" =>
	        reg_data_out <= slv_reg40;
	      when b"101001" =>
	        reg_data_out <= slv_reg41;
	      when b"101010" =>
	        reg_data_out <= slv_reg42;
	      when b"101011" =>
	        reg_data_out <= slv_reg43;
	      when b"101100" =>
	        reg_data_out <= slv_reg44;
	      when b"101101" =>
	        reg_data_out <= slv_reg45;
	      when b"101110" =>
	        reg_data_out <= slv_reg46;
	      when b"101111" =>
	        reg_data_out <= slv_reg47;
	      when b"110000" =>
	        reg_data_out <= slv_reg48;
	      when b"110001" =>
	        reg_data_out <= slv_reg49;
	      when b"110010" =>
	        reg_data_out <= slv_reg50;
	      when b"110011" =>
	        reg_data_out <= slv_reg51;
	      when b"110100" =>
	        reg_data_out <= slv_reg52;
	      when b"110101" =>
	        reg_data_out <= slv_reg53;
	      when b"110110" =>
	        reg_data_out <= slv_reg54;
	      when b"110111" =>
	        reg_data_out <= slv_reg55;
	      when b"111000" =>
	        reg_data_out <= slv_reg56;
	      when b"111001" =>
	        reg_data_out <= slv_reg57;
	      when b"111010" =>
	        reg_data_out <= slv_reg58;
	      when b"111011" =>
	        reg_data_out <= slv_reg59;
	      when b"111100" =>
	        reg_data_out <= slv_reg60;
	      when b"111101" =>
	        reg_data_out <= slv_reg61;
	      when b"111110" =>
	        reg_data_out <= slv_reg62;
	      when b"111111" =>
	        reg_data_out <= slv_reg63;
	      when others =>
	        reg_data_out  <= (others => '0');
	    end case;
	end process; 

	-- Output register or memory read data
	process( S_AXI_ACLK ) is
	begin
	  if (rising_edge (S_AXI_ACLK)) then
	    if ( S_AXI_ARESETN = '0' ) then
	      axi_rdata  <= (others => '0');
	    else
	      if (slv_reg_rden = '1') then
	        -- When there is a valid read address (S_AXI_ARVALID) with 
	        -- acceptance of read address by the slave (axi_arready), 
	        -- output the read dada 
	        -- Read address mux
	          axi_rdata <= reg_data_out;     -- register read data
	      end if;   
	    end if;
	  end if;
	end process;



----------------------------------------------------------------------------
	gtu_1us <= slv_reg10(1);
	art_clk_en <= slv_reg13(0);

	artix_clk_gen: process(S_AXI_ACLK) -- S_AXI_ACLK = 200 MHz
		variable cnt : integer;
	begin
		if(rising_edge(S_AXI_ACLK)) then
			if(art_clk_en = '1') then
				if(gtu_1us = '1') then -- art_clk_i  = 100 MHz
					art_clk_i <= not art_clk_i; 
				else                   -- art_clk_i  = 40 MHz
					if(cnt = 5) then
						art_clk_i <= not art_clk_i;
						cnt := 1;
					else
						if(cnt = 3) then
							art_clk_i <= not art_clk_i;
						end if;
						cnt := cnt + 1;
					end if;
				end if;
			end if;
		end if;
	end process;
	
	art_clk <= art_clk_i;
	run_data_conv <= slv_reg10(2);
	
	start_sig <= slv_reg0(0);
	run <= slv_reg0(1);
	prog_reset <= slv_reg0(2);
	en_output <= slv_reg0(3);
	reset_data_conv <= slv_reg1(0);
	reset_scurve_adder <= not slv_reg1(1);
	num_of_frames <= slv_reg3;
	
	test_data_provider_started <= slv_reg4(0);
	test_mode <= slv_reg4(1); 
	
	incr_period <= slv_reg5;
	patt_init <= slv_reg6(15 downto 8);
	patt_max <= slv_reg6(7 downto 0);
	
	infinite <= slv_reg10(0);
	slv_reg16(0) <= pass;
	slv_reg16(7 downto 4) <= sm_state;
	slv_reg16(15 downto 8) <= status_test_dp;
	
	slv_reg31 <=  X"20210317";
	
	dozer: process(S_AXI_ACLK)
		variable state : integer range 0 to 2 := 0;
	begin
		if(rising_edge(S_AXI_ACLK)) then
			if(prog_reset = '1') then
				state := 0;
				pass <= '0';
				cnt <= (0 => '1', others => '0');
			else
				case state is
					when 0 => if(start_sig = '1') then
											state := state + 1;
										end if;
										pass <= '0';
										cnt <= (0 => '1', others => '0');
					when 1 => if(s_axis_tvalid = '1' and s_axis_tlast = '1') then
											state := state + 1;
											pass <= en_output;
										end if;
					when 2 => if(s_axis_tvalid = '1' and s_axis_tlast = '0') then		
											state := state + 1;
										end if;
					when 3 => if(s_axis_tvalid = '1' and s_axis_tlast = '1') then
											if(cnt = num_of_frames and infinite = '0') then
												pass <= '0';
												state := state + 1;
											else
												if(run = '1') then
													state := state - 1;
													cnt <= cnt + 1;
												else
													pass <= '0';
													state := state + 1;
												end if;	 
											end if;
										end if;
					when 4 => if(start_sig = '0') then
											state := 0;
										end if;
				end case;
				sm_state <= conv_std_logic_vector(state, 4);		
			end if;
		end if;
	end process;
	
	input_frames_cnt_process: process(S_AXI_ACLK)
	begin
		if(rising_edge(S_AXI_ACLK)) then
			s_axis_tvalid_d1 <= s_axis_tvalid;
			if(s_axis_tvalid = '1' and s_axis_tvalid_d1 = '0') then
				s_axis_tvalid_cnt <= s_axis_tvalid_cnt + 1;
			end if;
		end if;
	end process;
	
	slv_reg19 <= s_axis_tvalid_cnt;

	i_test_data_provider : test_data_provider 
    Port map( 
    clk => S_AXI_ACLK,--: in STD_LOGIC;
    aresetn => S_AXI_ARESETN,--: in std_logic;
    started => test_data_provider_started,--: in std_logic;
    status => status_test_dp,
    incr_period => incr_period,--: in std_logic_vector(31 downto 0);
    patt_init => patt_init,--: in std_logic_vector(7 downto 0);
    patt_max => patt_max,--: in std_logic_vector(7 downto 0);
    s_axis_tvalid => s_axis_tvalid,--: in std_logic;
    s_axis_tlast => s_axis_tlast,--: in std_logic;
    m_axis_tvalid => m_axis_tvalid_test,--: out std_logic;
    m_axis_tlast => m_axis_tlast_test,--: out std_logic;
    m_axis_tdata => m_axis_tdata_test);
	
	m_axis_tuser_test <= s_axis_tuser when rising_edge(S_AXI_ACLK);
	
	
	selector: process(S_AXI_ACLK)
	begin
		if(rising_edge(S_AXI_ACLK)) then
			if(test_mode = '1') then
				m_axis_tdata <= m_axis_tdata_test;--: in std_logic_vector(127 downto 0);
				m_axis_tuser <= m_axis_tuser_test;--: in std_logic_vector(5 downto 0);
				m_axis_tvalid <= m_axis_tvalid_test and pass;--: in std_logic;
				s_axis_tready <= '1';--: out std_logic := '1';
				m_axis_tlast <= m_axis_tlast_test and pass;--: in std_logic;
	
				m01_axis_tdata <= m_axis_tdata_test;--: in std_logic_vector(127 downto 0);
				m01_axis_tuser <= m_axis_tuser_test;--: in std_logic_vector(5 downto 0);
				m01_axis_tvalid <= m_axis_tvalid_test and pass;--: in std_logic;
				m01_axis_tlast <= m_axis_tlast_test and pass;--: in std_logic;
			else
				m_axis_tdata <= s_axis_tdata;--: in std_logic_vector(127 downto 0);
				m_axis_tuser <= s_axis_tuser;--: in std_logic_vector(5 downto 0);
				m_axis_tvalid <= s_axis_tvalid and pass;--: in std_logic;
				s_axis_tready <= '1';--: out std_logic := '1';
				m_axis_tlast <= s_axis_tlast and pass;--: in std_logic;
		
				m01_axis_tdata <= s_axis_tdata;--: in std_logic_vector(127 downto 0);
				m01_axis_tuser <= s_axis_tuser;--: in std_logic_vector(5 downto 0);
				m01_axis_tvalid <= s_axis_tvalid and pass;--: in std_logic;
				m01_axis_tlast <= s_axis_tlast and pass;--: in std_logic;
			end if;
		end if;
	end process;
	


--     	m_axis_tdata: out std_logic_vector(127 downto 0);
--    	m_axis_tuser: out std_logic_vector(5 downto 0); 
--    	m_axis_tvalid: out std_logic;
--    	m_axis_tready: in std_logic;
--    	m_axis_tlast: out std_logic;
	slv_reg17 <= aux_in;
	slv_reg18 <= aux_in2;
	zero_pmts <= slv_reg12(11 downto 0) & slv_reg11(27 downto 16) & slv_reg11(11 downto 0);

	s_axis_tvalid_4trig <= s_axis_tvalid and pass;
	i_data_provider_4trig : data_provider_4trig 
	    Port map( clk => S_AXI_ACLK,--: in STD_LOGIC;
	           aresetn => S_AXI_ARESETN,--: in STD_LOGIC;
	           s_axis_tdata => s_axis_tdata,--: in STD_LOGIC_VECTOR (127 downto 0);
	           s_axis_tvalid => s_axis_tvalid_4trig,--: in STD_LOGIC;
	           s_axis_tlast => s_axis_tlast,--: in STD_LOGIC;
	           s_axis_tuser => s_axis_tuser,--: in std_logic_vector(7 downto 0);
	           DATA => DATA,--: out STD_LOGIC_VECTOR (143 downto 0);
	           FRAME => FRAME);--: out STD_LOGIC);
	           
	
	   xpm_cdc_array_bitslip0 : xpm_cdc_array_single
	           generic map (
	              DEST_SYNC_FF => 4,   -- DECIMAL; range: 2-10
	              INIT_SYNC_FF => 0,   -- DECIMAL; integer; 0=disable simulation init values, 1=enable simulation init
	              SIM_ASSERT_CHK => 0, -- DECIMAL; integer; 0=disable simulation messages, 1=enable simulation messages
	              SRC_INPUT_REG => 0,  -- DECIMAL; 0=do not register input, 1=register input
	              WIDTH => 24           -- DECIMAL; range: 1-1024
	           )
	           port map (
	              dest_out => slv_reg20(23 downto 0), -- WIDTH-bit output: src_in synchronized to the destination clock domain. This
	              dest_clk => S_AXI_ACLK, -- 1-bit input: Clock signal for the destination clock domain.
	              src_clk => '0',   -- 1-bit input: optional; required when SRC_INPUT_REG = 1
	              src_in => bitslip_cnt0      -- WIDTH-bit input: Input single-bit array to be synchronized to destination clock
	           );

	   xpm_cdc_array_bitslip1 : xpm_cdc_array_single
	           generic map (
	              DEST_SYNC_FF => 4,   -- DECIMAL; range: 2-10
	              INIT_SYNC_FF => 0,   -- DECIMAL; integer; 0=disable simulation init values, 1=enable simulation init
	              SIM_ASSERT_CHK => 0, -- DECIMAL; integer; 0=disable simulation messages, 1=enable simulation messages
	              SRC_INPUT_REG => 0,  -- DECIMAL; 0=do not register input, 1=register input
	              WIDTH => 24           -- DECIMAL; range: 1-1024
	           )
	           port map (
	              dest_out => slv_reg21(23 downto 0), -- WIDTH-bit output: src_in synchronized to the destination clock domain. This
	              dest_clk => S_AXI_ACLK, -- 1-bit input: Clock signal for the destination clock domain.
	              src_clk => '0',   -- 1-bit input: optional; required when SRC_INPUT_REG = 1
	              src_in => bitslip_cnt1      -- WIDTH-bit input: Input single-bit array to be synchronized to destination clock
	           );
	
	   xpm_cdc_array_bitslip2 : xpm_cdc_array_single
						 generic map (
								DEST_SYNC_FF => 4,   -- DECIMAL; range: 2-10
								INIT_SYNC_FF => 0,   -- DECIMAL; integer; 0=disable simulation init values, 1=enable simulation init
								SIM_ASSERT_CHK => 0, -- DECIMAL; integer; 0=disable simulation messages, 1=enable simulation messages
								SRC_INPUT_REG => 0,  -- DECIMAL; 0=do not register input, 1=register input
								WIDTH => 24          -- DECIMAL; range: 1-1024
						 )
						 port map (
								dest_out => slv_reg22(23 downto 0), -- WIDTH-bit output: src_in synchronized to the destination clock domain. This
								dest_clk => S_AXI_ACLK, -- 1-bit input: Clock signal for the destination clock domain.
								src_clk => '0',   -- 1-bit input: optional; required when SRC_INPUT_REG = 1
								src_in => bitslip_cnt2      -- WIDTH-bit input: Input single-bit array to be synchronized to destination clock
						 );	 

end Behavioral;
