
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity data_provider_4ki is
    Port ( clk : in STD_LOGIC;
           aresetn : in STD_LOGIC;
           s_axis_tdata : in STD_LOGIC_VECTOR (127 downto 0);
           s_axis_tvalid : in STD_LOGIC;
           s_axis_tlast : in STD_LOGIC;
           s_axis_tuser : in std_logic_vector(7 downto 0);
           DATA : out STD_LOGIC_VECTOR (17 downto 0);
           FRAME : out STD_LOGIC);
end data_provider_4ki;

architecture Behavioral of data_provider_4ki is

	attribute KEEP_HIERARCHY : string;
	attribute KEEP_HIERARCHY of Behavioral: architecture is "TRUE";


	COMPONENT byte_reformr_4ki is
    Port ( 
			aclk : IN STD_LOGIC;
			aresetn : IN STD_LOGIC;
			s_axis_tvalid : IN STD_LOGIC;
			s_axis_tdata : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
			s_axis_tuser : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			s_axis_tlast : IN STD_LOGIC;
			m_axis_tvalid : OUT STD_LOGIC;
			m_axis_tready : in STD_LOGIC;
			m_axis_tdata : OUT STD_LOGIC_VECTOR(143 DOWNTO 0);
			m_axis_tlast : OUT STD_LOGIC
    );
	end COMPONENT;

	signal s_axis_tlast_pc: std_logic;
	signal s_axis_tvalid_pc: std_logic;
	signal m_axis_tvalid_dwc: std_logic;
	signal m_axis_tready_dwc: std_logic;
	signal m_axis_tdata_dwc: std_logic_vector(144-1 downto 0);
	signal m_axis_tdata_fifo: std_logic_vector(144-1 downto 0);


	COMPONENT byte_serializer is
    generic(N_CH: integer := 18);
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           tvalid : in STD_LOGIC;
           tlast : in STD_LOGIC;
           tdata : in STD_LOGIC_VECTOR (8*N_CH-1 downto 0);
           tready : out STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR(N_CH-1 downto 0);
           frame : out STD_LOGIC;
           tlast_out: out STD_LOGIC);
	end COMPONENT;

	COMPONENT byte_serializer_6bits is
    generic(N_CH: integer := 18);
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           tvalid : in STD_LOGIC;
           tlast : in STD_LOGIC;
           tdata : in STD_LOGIC_VECTOR (8*N_CH-1 downto 0);
           tready : out STD_LOGIC := '1';
           data_out : out STD_LOGIC_VECTOR(N_CH-1 downto 0);
           frame : out STD_LOGIC;
           tlast_out: out std_logic := '0');
	end COMPONENT;

	signal reset: std_logic := '0';
	signal m_axis_tvalid_fifo: std_logic := '0';
	signal m_axis_tready_fifo: std_logic := '0';
	signal m_axis_tlast_dwc: std_logic := '0';
	signal m_axis_tlast_fifo: std_logic := '0';
	
	signal DATA_cutted: STD_LOGIC_VECTOR(17 downto 0);
	signal FRAME_cutted, TLAST_cutted: std_logic := '0';
	
	COMPONENT axis_data_fifo_4combine
		PORT (
			s_axis_aresetn : IN STD_LOGIC;
			s_axis_aclk : IN STD_LOGIC;
			s_axis_tvalid : IN STD_LOGIC;
			s_axis_tready : OUT STD_LOGIC;
			s_axis_tdata : IN STD_LOGIC_VECTOR(143 DOWNTO 0);
			s_axis_tlast : IN STD_LOGIC;
			m_axis_tvalid : OUT STD_LOGIC;
			m_axis_tready : IN STD_LOGIC;
			m_axis_tdata : OUT STD_LOGIC_VECTOR(143 DOWNTO 0);
			m_axis_tlast : OUT STD_LOGIC;
			axis_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			axis_wr_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			axis_rd_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	END COMPONENT;

begin
	
	s_axis_tlast_pc <= '1' when s_axis_tuser = "01101011" else '0';
	s_axis_tvalid_pc <= s_axis_tvalid and s_axis_tuser(6);
	
  
  i_byte_reformr_4trig : byte_reformr_4ki 
		Port map( 
			aclk => clk,--: IN STD_LOGIC;
			aresetn => aresetn,--: IN STD_LOGIC;
			s_axis_tvalid => s_axis_tvalid_pc,--: IN STD_LOGIC;
			s_axis_tdata => s_axis_tdata,--: IN STD_LOGIC_VECTOR(127 DOWNTO 0);
			s_axis_tuser => s_axis_tuser,--: IN STD_LOGIC_VECTOR(127 DOWNTO 0);
			s_axis_tlast => s_axis_tlast_pc,--: IN STD_LOGIC;
			m_axis_tvalid => m_axis_tvalid_dwc,--: OUT STD_LOGIC;
			m_axis_tready => m_axis_tready_dwc,--: OUT STD_LOGIC;
			m_axis_tdata => m_axis_tdata_dwc,--: OUT STD_LOGIC_VECTOR(1151 DOWNTO 0);
			m_axis_tlast => m_axis_tlast_dwc--: OUT STD_LOGIC
		);

	m_axis_tvalid_fifo <= m_axis_tvalid_dwc;
	m_axis_tlast_fifo <= m_axis_tlast_dwc;
	m_axis_tdata_fifo <= m_axis_tdata_dwc;
	m_axis_tready_dwc <= m_axis_tready_fifo;

	reset <= not aresetn;

	i_byte_serializer : byte_serializer_6bits 
    Port map ( clk => clk,--: in STD_LOGIC;
           reset => reset,--: in STD_LOGIC;
           tvalid => m_axis_tvalid_fifo,--: in STD_LOGIC;
           tlast => m_axis_tlast_fifo,
           tdata => m_axis_tdata_fifo,--: in STD_LOGIC_VECTOR (8*N_CH-1 downto 0);
           tready => m_axis_tready_fifo,--: out STD_LOGIC;
           data_out => DATA_cutted,--: out STD_LOGIC_VECTOR(N_CH-1 downto 0);
           frame => FRAME_cutted,
           tlast_out => TLAST_cutted);--: out STD_LOGIC);
           
		FRAME <= FRAME_cutted;
		DATA <= DATA_cutted;

end Behavioral;
