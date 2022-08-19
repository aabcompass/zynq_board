library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

Library xpm;
use xpm.vcomponents.all;

entity flow_control_d1 is
	generic (
		C_AXIS_DWIDTH : integer := 64;
		C_CNT_DWIDTH : integer := 32;
		C_FREQ : integer := 200000000
	);
  Port ( 
  		-- in
			s_axis_aclk : IN STD_LOGIC;
  		s_axis_aresetn : IN STD_LOGIC;
  		
  		s_axis_tvalid : IN STD_LOGIC;
  		s_axis_tready : OUT STD_LOGIC;
  		s_axis_tdata : IN STD_LOGIC_VECTOR(C_AXIS_DWIDTH-1 DOWNTO 0);
  		s_axis_tuser : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
  		s_axis_tlast : IN STD_LOGIC;

  		s_axis_trg_tvalid : IN STD_LOGIC;
  		s_axis_trg_tready : OUT STD_LOGIC := '1';
  		s_axis_trg_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
  		s_axis_trg_tlast : IN STD_LOGIC;
  		
  		s_axis_mps_tvalid: IN STD_LOGIC; 
			s_axis_mps_tready: OUT STD_LOGIC := '1'; 
			s_axis_mps_tdata: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			s_axis_mps_tlast: in std_logic;	
  		
  		-- out data
			m_axis_tvalid : OUT STD_LOGIC;
  		m_axis_tready : IN STD_LOGIC;
  		m_axis_tdata : OUT STD_LOGIC_VECTOR(C_AXIS_DWIDTH/2-1 DOWNTO 0);
  		m_axis_tkeep : OUT STD_LOGIC_VECTOR(C_AXIS_DWIDTH/8-1 DOWNTO 0) := (others => '1');
  		m_axis_tlast : OUT STD_LOGIC := '0';
 		  
 		  -- out events
			m_axis_events_tvalid : OUT STD_LOGIC;
  		m_axis_events_tready : IN STD_LOGIC;
  		m_axis_events_tdata : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
  		 		
  		trig_ext_in: in std_logic;
  		trig_out: out std_logic;
  		busy: out std_logic;
  		pps: in std_logic;

  		trig_ext_in_lab: in std_logic;
  		
  		mps_tvalid, mps_tready, mps_tlast: in std_logic;
  		
  		--gtu_sig: in std_logic; was in Mini
  		--regs
  		flags: IN STD_LOGIC_VECTOR(31 downto 0); --0 
  		clr_flags: IN STD_LOGIC_VECTOR(31 downto 0); --1 
  		trig_delay: IN STD_LOGIC_VECTOR(C_CNT_DWIDTH-1 downto 0); --2 UNUSED
  		flags2: IN STD_LOGIC_VECTOR(31 downto 0);	     --3
  		fifo_thr: IN STD_LOGIC_VECTOR(15 downto 0); --4
  		set_gtu_counter_value: IN STD_LOGIC_VECTOR(31 downto 0);  --5
  		n_gtus_per_cycle: IN STD_LOGIC_VECTOR(31 downto 0);  --6 
  		periodic_trig_gtu_period: IN STD_LOGIC_VECTOR(31 downto 0);  --7 
  		num_of_gtus_after_trig: IN STD_LOGIC_VECTOR(15 downto 0);  --8
  		trig_flags2: IN STD_LOGIC_VECTOR(31 downto 0);  --9
  		unix_time_reg: IN STD_LOGIC_VECTOR(31 downto 0);  --10
  		tlast_remover_phase: IN std_logic_vector(2 downto 0) := "000"; --11
  		trigger_relax_time: IN std_logic_vector(23 downto 0) := X"000000"; --12
  		
  		tuser_tlast: in std_logic_vector(5 downto 0) := "000000";--13


  		
  		status: OUT STD_LOGIC_VECTOR(31 downto 0);  --14
  		gtu_sig_counter: OUT STD_LOGIC_VECTOR(31 downto 0);  --15
  		unix_time: OUT STD_LOGIC_VECTOR(31 downto 0);  --17
  		trans_counter: OUT STD_LOGIC_VECTOR(C_CNT_DWIDTH-1 downto 0); --18
  		m_axis_fifo_error: OUT STD_LOGIC_VECTOR(31 downto 0); --19
  		gtu_timestamp: OUT STD_LOGIC_VECTOR(31 downto 0); --20
  		trig_type: OUT STD_LOGIC_VECTOR(31 downto 0); --21
  		unix_timestamp: OUT STD_LOGIC_VECTOR(31 downto 0); --22
  		maxis_trans_cnt: OUT STD_LOGIC_VECTOR(31 downto 0); --23
  		maxis_accepted_cnt: OUT STD_LOGIC_VECTOR(31 downto 0); --24
  		trig_all_cnt: OUT STD_LOGIC_VECTOR(31 downto 0); --25
  		n_glob_cycles: OUT STD_LOGIC_VECTOR(31 downto 0); --26
  		gtu_mps_timestamp: OUT STD_LOGIC_VECTOR(31 downto 0); --27 <= gtu_sig_counter_i;
  		unix_mps_timestamp: OUT STD_LOGIC_VECTOR(31 downto 0); --28 <= unix_time_i;		
  		trig_cnt_glob: out std_logic_vector(15 downto 0);	--29 (15 downto 0)
  		self_trig_cnt: out std_logic_vector(15 downto 0);	--29 (31 downto 16)
  		s_axis_trg_tdata_d1_latch: out std_logic_vector(31 downto 0) --30
  );
end flow_control_d1;  
     
architecture Behavioral of flow_control_d1 is

	attribute KEEP_HIERARCHY : string;
	attribute KEEP_HIERARCHY of Behavioral: architecture is "TRUE";


	signal sm_state, sm_state_sink, sm_state_latch: std_logic_vector(3 downto 0) := "0000";

	signal is_started: std_logic := '0';
	signal en_int_trig, en_algo_trig, periodic_trig_en, en_ext_trig, en_ta_trig, ext_trig_latch: std_logic := '0';
	signal release, release_always: std_logic := '0';
	signal ext_trig: std_logic := '0';
	signal use_pps: std_logic := '0';
	signal pps_d1, pps_f: std_logic := '0';
	signal trig, trig_comb: std_logic := '0';
	signal trig_immediate, trig_immediate_latch: std_logic := '0';
	signal periodic_trig, periodic_trig_latch: std_logic := '0'; 
	signal ta_trig_param_latch: std_logic_vector(31 downto 0) := (others => '0');

	signal clear_error: std_logic := '0';
	
	signal trans_counter_latch: std_logic_vector(C_CNT_DWIDTH-1 downto 0) := (others => '0');
	signal trig_delay_cnt: std_logic_vector(C_CNT_DWIDTH-1 downto 0) := (others => '0');
	signal clr_trans_counter : std_logic := '0';
	signal clr_sink_sm : std_logic := '0';
	
	signal gtu_sig_d0, gtu_sig_d1: std_logic := '0';
	
	signal periodic_trig_phase : std_logic_vector(20 downto 0) := (others => '0');
	
	signal led_cnt, trig_out_cnt : std_logic_vector(23 downto 0) := (others => '0');
	signal m_axis_tlast_cnt : std_logic_vector(15 downto 0) := (others => '0');
	
	signal int_trig_d0, int_trig_d1, int_trig, trig_force : std_logic := '0';
	
	signal trig_event: std_logic := '0';
	signal trig_events_log_en: std_logic := '0';
	signal dma_error: std_logic := '0';
	
	signal s_axis_trg_tdata_d1: std_logic_vector(31 downto 0) := (others => '0');
	

	component debounce IS
		GENERIC(
			counter_size  :  INTEGER := 19); --counter size (19 bits gives 10.5ms with 50MHz clock)
		PORT(
			clk     : IN  STD_LOGIC;  --input clock
			button  : IN  STD_LOGIC;  --input signal to be debounced
			result  : OUT STD_LOGIC); --debounced signal
		END component;
		
	signal trig_button_debounced: std_logic := '0';
	signal trig_button_n: std_logic := '0';
	signal clr_all: std_logic := '0';
	signal clr_gtu_cnt: std_logic := '0';
	signal clr_trig_service: std_logic := '0';
	
	COMPONENT axis_data_fifo_extra
		PORT (
			s_axis_aresetn : IN STD_LOGIC;
			s_axis_aclk : IN STD_LOGIC;
			s_axis_tvalid : IN STD_LOGIC;
			s_axis_tready : OUT STD_LOGIC;
			s_axis_tdata : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
			s_axis_tlast : IN STD_LOGIC;
			m_axis_tvalid : OUT STD_LOGIC;
			m_axis_tready : IN STD_LOGIC;
			m_axis_tdata : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
			m_axis_tlast : OUT STD_LOGIC;
			axis_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			axis_wr_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			axis_rd_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT axis_fifo_fc
		PORT (
			s_axis_aresetn : IN STD_LOGIC;
			s_axis_aclk : IN STD_LOGIC;
			s_axis_tvalid : IN STD_LOGIC;
			s_axis_tlast : IN STD_LOGIC;
			s_axis_tready : OUT STD_LOGIC;
			s_axis_tdata : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
			m_axis_tvalid : OUT STD_LOGIC;
			m_axis_tlast : OUT STD_LOGIC;
			m_axis_tready : IN STD_LOGIC;
			m_axis_tdata : OUT STD_LOGIC_VECTOR(127 DOWNTO 0);
			axis_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			axis_wr_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			axis_rd_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT axis_fifo_fc_32
		PORT (
			s_axis_aresetn : IN STD_LOGIC;
			s_axis_aclk : IN STD_LOGIC;
			s_axis_tvalid : IN STD_LOGIC;
			s_axis_tlast : IN STD_LOGIC;
			s_axis_tready : OUT STD_LOGIC;
			s_axis_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			m_axis_tvalid : OUT STD_LOGIC;
			m_axis_tlast : OUT STD_LOGIC;
			m_axis_tready : IN STD_LOGIC;
			m_axis_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			axis_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			axis_wr_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			axis_rd_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT fifo4dma
		PORT (
			s_axis_aresetn : IN STD_LOGIC;
			s_axis_aclk : IN STD_LOGIC;
			s_axis_tvalid : IN STD_LOGIC;
			s_axis_tlast : IN STD_LOGIC;
			s_axis_tready : OUT STD_LOGIC;
			s_axis_tdata : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
			m_axis_tvalid : OUT STD_LOGIC;
			m_axis_tlast : OUT STD_LOGIC;
			m_axis_tready : IN STD_LOGIC;
			m_axis_tdata : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
			axis_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			axis_wr_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			axis_rd_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT axis_dwidth_converter_0
	  PORT (
	    aclk : IN STD_LOGIC;
	    aresetn : IN STD_LOGIC;
	    s_axis_tvalid : IN STD_LOGIC;
	    s_axis_tready : OUT STD_LOGIC;
	    s_axis_tdata : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
	    s_axis_tlast : IN STD_LOGIC;
	    m_axis_tvalid : OUT STD_LOGIC;
	    m_axis_tready : IN STD_LOGIC;
	    m_axis_tdata : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
	    m_axis_tlast : OUT STD_LOGIC
	  );
	END COMPONENT;	
	

	COMPONENT fifo4gtu_events
		PORT (
			s_axis_aresetn : IN STD_LOGIC;
			s_axis_aclk : IN STD_LOGIC;
			s_axis_tvalid : IN STD_LOGIC;
			s_axis_tready : OUT STD_LOGIC;
			s_axis_tdata : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
			m_axis_tvalid : OUT STD_LOGIC;
			m_axis_tready : IN STD_LOGIC;
			m_axis_tdata : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
			axis_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			axis_wr_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			axis_rd_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) 
		);
	END COMPONENT;
	
	signal axis_fifo_fc_count: std_logic_vector(31 downto 0) := (others => '0');
	
	signal m_axis_tlast_key : std_logic := '0';
	signal m_axis_tlast_i : std_logic := '0';

	signal m_axis_tvalid_fc, m_axis_tready_fc, m_axis_tlast_fc: std_logic := '0';
	
	signal m_axis_tvalid_key, m_axis_tready_key: std_logic := '0';
	signal pass: std_logic := '0';
	signal pass_tlast: std_logic := '0';
	signal self_trig, self_trig_d1,  self_trig_latch: std_logic := '0';
	signal one_second_pulse: std_logic := '0';
	signal set_unix_time: std_logic := '0';
	signal trig_latch: std_logic := '0';
	signal trig_latch_clr: std_logic := '0';
	signal trig_cnt_glob_clr: std_logic := '0';
	
	signal number_of_triggers: std_logic_vector(15 downto 0) := (others => '0');
	signal trig_cnt: std_logic_vector(15 downto 0) := (others => '0');
	signal trig_all_cnt_i: std_logic_vector(31 downto 0) := (others => '0');
	signal one_second_cnt: std_logic_vector(31 downto 0) := (others => '0');
	signal periodic_trig_gen_cnt, periodic_trig_gen_cnt2: std_logic_vector(31 downto 0) := (others => '0');
	signal int_trig_gen_cnt: std_logic_vector(31 downto 0) := (others => '0');
	
	
	signal en_trig_led, en_trig_out, trig_out_pulse, trig_out_force : std_logic := '0';
	signal trig_ext_in_sync, trig_ext_in_sync_d1 : std_logic := '0';
	
	signal s_axis_tvalid_d1, s_axis_tlast_d1: std_logic := '0';
	signal s_axis_tdata_d1: std_logic_vector(127 downto 0) := (others => '0');
	--signal m_axis_tdata_buf: std_logic_vector(63 downto 0) := (others => '0');

  signal tlast_remover_cnt: std_logic_vector(2 downto 0) := "000";
	signal clr_tlast_remover: std_logic := '0';
	
	signal m_axis_tready_sink: std_logic := '0';
	signal fifo_half: std_logic := '0';
	signal m_axis_tvalid_i: std_logic := '0';
	
	signal trans_counter_i: std_logic_vector(C_CNT_DWIDTH-1 downto 0) := (others => '0');
	signal gtu_sig_counter_i: std_logic_vector(31 downto 0) := (others => '0');
	signal unix_time_i: std_logic_vector(31 downto 0) := (others => '0');
	signal maxis_trans_cnt_i: std_logic_vector(31 downto 0) := (others => '0');
	signal maxis_accepted_cnt_i: std_logic_vector(31 downto 0) := (others => '0');
	
	signal inject_16_events_cnt: std_logic_vector(3 downto 0) := (others => '0');
	signal trig_type_i: std_logic_vector(31 downto 0) := (others => '0');
	signal s_axis_events_tdata: std_logic_vector(63 downto 0) := (others => '0');
	signal inject_16_events: std_logic := '0';
	signal cmd_inject_16_events, cmd_inject_16_events_d0, cmd_inject_16_events_d1: std_logic := '0';
	
	signal tlast_out_cnt: std_logic_vector(15 downto 0) := (others => '0');
	
	signal trigger_relax_time_cnt: std_logic_vector(23 downto 0) := (others => '0');
	
	signal tuser_tlast_d1: std_logic_vector(5 downto 0) := (others => '0');
	
	signal m_axis_tdata_dwc: std_logic_vector(63 downto 0) := (others => '0');
	signal m_axis_tdata_key: std_logic_vector(127 downto 0) := (others => '0');
	signal m_axis_tvalid_dwc, m_axis_tready_dwc, m_axis_tlast_dwc: std_logic := '0';
	signal m_axis_tlast_dwc2: std_logic := '0';
	
	signal mps_sig: std_logic := '0';
	signal s_axis_trg_tlast_d1: std_logic := '0';
	
	signal clkb_mode: std_logic := '0';

	attribute keep : string; 
	attribute keep of s_axis_tlast_d1: signal is "true";  
	attribute keep of m_axis_tlast_fc: signal is "true";  
	attribute keep of m_axis_tvalid_key: signal is "true";  
	attribute keep of m_axis_tready_key: signal is "true";  
	attribute keep of axis_fifo_fc_count: signal is "true";  
	attribute keep of sm_state: signal is "true";  
	attribute keep of sm_state_sink: signal is "true";  
	attribute keep of trig_type: signal is "true";  
	attribute keep of periodic_trig_gtu_period: signal is "true";  
	attribute keep of periodic_trig_gen_cnt: signal is "true";  
	attribute keep of periodic_trig: signal is "true";  
	attribute keep of m_axis_tready_sink: signal is "true";  
	attribute keep of fifo_half: signal is "true";  
	attribute keep of fifo_thr: signal is "true";  
	attribute keep of trig_latch: signal is "true";  
	attribute keep of tlast_remover_cnt: signal is "true";  
	attribute keep of pass: signal is "true";  
	attribute keep of pass_tlast: signal is "true";  
	attribute keep of trig_latch_clr: signal is "true";  
	attribute keep of m_axis_tlast_cnt: signal is "true";  
	attribute keep of m_axis_tvalid_i: signal is "true";  
	attribute keep of trig_cnt: signal is "true";  
	attribute keep of release: signal is "true";  
	attribute keep of trig_type_i: signal is "true";  

	signal s_axis_ta_event_tdata_d1: std_logic_vector(31 downto 0) := (others => '0');
	
	signal n_glob_cycles_i: std_logic_vector(31 downto 0) := (others => '0');
	signal glob_cycles_gtu_cnt: std_logic_vector(27 downto 0) := X"0000001";
	signal trig_cnt_glob_i: std_logic_vector(15 downto 0) := X"0000";
	
	signal trig_ext_in_d1: std_logic := '0';
	signal trig_ext_in_f: std_logic := '0';
	
	signal trig_ext_in_lab_d1: std_logic := '0';
	signal trig_ext_in_lab_f: std_logic := '0';
	signal en_trig_ext_lab: std_logic := '0';
	signal trig_ext_in_lab_sync: std_logic := '0';
	
	signal self_trig_cnt_clr: std_logic := '0';
	signal pause4ftp: std_logic := '0';
	
	signal self_trig_cnt_i: std_logic_vector(15 downto 0) := (others => '0');
	
	

begin

----------------------- 
	
--xpm_cdc_extsync_inst: xpm_cdc_single
--  generic map (
--     DEST_SYNC_FF   => 4, -- integer; range: 2-10
--     SIM_ASSERT_CHK => 0, -- integer; 0=disable simulation messages, 1=enable simulation messages
--     SRC_INPUT_REG  => 0  -- integer; 0=do not register input, 1=register input
--  )
--  port map (
--     src_clk  => '0',  -- optional; required when SRC_INPUT_REG = 1
--     src_in   => trig_ext_in,
--     dest_clk => s_axis_aclk,
--     dest_out => trig_ext_in_sync
--  );

	is_started <= flags(0);
	periodic_trig_en <= flags(1);
	en_algo_trig <= flags(2);
	--en_int_trig <= flags(3);
	en_trig_ext_lab <= flags(4);
	--en_ta_trig <= flags(5);
	release_always <= flags(6); 
	clkb_mode <= flags(17);
	pause4ftp <= flags(18);
	use_pps <= flags(19);
	
	clr_trans_counter <= clr_flags(0);
	clear_error <= clr_flags(1);
	clr_all <= clr_flags(2);
	clr_gtu_cnt <= clr_flags(4);
	clr_trig_service <= clr_flags(5);
	clr_tlast_remover <= clr_flags(6);
	clr_sink_sm <= clr_flags(7); 
	trig_cnt_glob_clr <= clr_flags(8); 
	self_trig_cnt_clr <= clr_flags(9);
	
	 
	trig_immediate <= clr_flags(16);
	
	
	cmd_inject_16_events_d0 <= clr_flags(17) when rising_edge(s_axis_aclk);
	cmd_inject_16_events_d1 <= cmd_inject_16_events_d0 when rising_edge(s_axis_aclk);
	cmd_inject_16_events <= cmd_inject_16_events_d0 and (not cmd_inject_16_events_d1);

	release <= flags2(0);  
	trig_force <= flags2(1); 
	set_unix_time <= flags2(2); 
	



	number_of_triggers <= trig_flags2(15 downto 0);
	en_trig_led <= trig_flags2(16);
	en_trig_out <= trig_flags2(17);
	trig_out_force <= trig_flags2(18);
	trig_events_log_en <= trig_flags2(19);


	status(3 downto 0) <= sm_state;
	status(7 downto 4) <= sm_state_sink;
	status(11 downto 8) <= sm_state_latch;
	status(16) <= trig_latch;
	status(17) <= trig_ext_in_sync;
	status(18) <= dma_error; -- asserted if fifo overflowed. Cleared by release signal
	status(19) <= pass;
	
	mps_sig <= mps_tvalid and mps_tready and mps_tlast;
	
	pps_d1 <= pps when rising_edge(s_axis_aclk);
	pps_f <= pps and (not pps_d1) when rising_edge(s_axis_aclk);
	
	transation_counter: process(s_axis_aclk)
	begin
		if(rising_edge(s_axis_aclk)) then
			if(clr_trans_counter = '1' or clr_all = '1') then
				trans_counter_i <= (others => '0');
			elsif(s_axis_tvalid = '1') then
				trans_counter_i <= trans_counter_i + 1;
			end if;
		end if;
	end process;
	
	trans_counter <= trans_counter_i;

--	xpm_cdc_single_inst: xpm_cdc_single //was in Mini
--	generic map (
--		 DEST_SYNC_FF   => 4, -- integer; range: 2-10
--		 SIM_ASSERT_CHK => 0, -- integer; 0=disable simulation messages, 1=enable simulation messages
--		 SRC_INPUT_REG  => 0  -- integer; 0=do not register input, 1=register input
--	)
--	port map (
--		 src_clk  => '0',  -- optional; required when SRC_INPUT_REG = 1
--		 src_in   => gtu_sig,
--		 dest_clk => s_axis_aclk,
--		 dest_out => gtu_sig_d0
--	);	

	gtu_sig_d0  <= s_axis_tlast_d1;
	
	gtu_sig_counter_process: process(s_axis_aclk)
	begin
		if(rising_edge(s_axis_aclk)) then
			if(clr_all = '1' or clr_gtu_cnt = '1' or one_second_pulse = '1') then
				gtu_sig_counter_i <= (others => '0');
			elsif(set_unix_time = '1') then
				gtu_sig_counter_i <= set_gtu_counter_value;
			else
				gtu_sig_d1 <= gtu_sig_d0;
				if(gtu_sig_d0 = '1' and gtu_sig_d1 = '0') then
					gtu_sig_counter_i <= gtu_sig_counter_i + 1;
				end if;
			end if;
		end if;
	end process;	
	gtu_sig_counter <= gtu_sig_counter_i;

	one_second_pulse_process: process(s_axis_aclk) 
	begin
		if(rising_edge(s_axis_aclk)) then
			if(use_pps = '1') then
				one_second_pulse <= pps_f;
			else
				if((one_second_cnt = C_FREQ-1) or (clr_all = '1')) then
					one_second_cnt <= (others => '0'); 
					one_second_pulse <= '1';
				else
					one_second_cnt <= one_second_cnt + 1;
					one_second_pulse <= '0';
				end if;			
			end if;
		end if;
	end process;

	unix_time_process: process(s_axis_aclk) 
	begin
		if(rising_edge(s_axis_aclk)) then
			if(set_unix_time = '1') then
				unix_time_i <= unix_time_reg;
			elsif(one_second_pulse = '1') then
				unix_time_i <= unix_time_i + 1;
			end if;
		end if;
	end process;
	unix_time <= unix_time_i;

	periodic_trig_gen_v2: process(s_axis_aclk) 
	begin
		if(rising_edge(s_axis_aclk)) then
			if(clr_all = '1' or clr_trig_service = '1') then
				periodic_trig_gen_cnt <= (others => '0');
				periodic_trig_gen_cnt2 <= (others => '0');
			else
				--if(periodic_trig_gen_cnt2 < n_gtus_per_cycle) then
					--if(gtu_sig_d0 = '1' and gtu_sig_d1 = '0') then
						if(periodic_trig_gen_cnt >= periodic_trig_gtu_period) then
							periodic_trig <= periodic_trig_en;
							periodic_trig_gen_cnt <= (others => '0');
						else
							periodic_trig <= '0';
							periodic_trig_gen_cnt <= periodic_trig_gen_cnt + 1;
						end if;
					--else
					--	periodic_trig <= '0';
					--end if;
				--else
				--	periodic_trig <= '0';
				--end if;
			end if;
		end if;
	end process;
	
	self_trig <= (s_axis_trg_tlast and s_axis_trg_tvalid and en_algo_trig);
	self_trig_d1 <= self_trig when rising_edge(s_axis_aclk);
	
	self_trig_cnt_process: process(s_axis_aclk)
	begin
		if(rising_edge(s_axis_aclk)) then
			if(self_trig_cnt_clr = '1') then
				self_trig_cnt_i <= (others => '0');
			elsif(self_trig = '1' and self_trig_d1 = '0') then
				self_trig_cnt_i <= self_trig_cnt_i + 1;
			end if;
		end if;
	end process;
	
	self_trig_cnt <= self_trig_cnt_i;
	--ext_trig <= (trig_ext_in_sync and en_ext_trig);
	

	
   xpm_cdc_single_inst : xpm_cdc_single
   generic map (
      DEST_SYNC_FF => 4,   -- DECIMAL; range: 2-10
      INIT_SYNC_FF => 0,   -- DECIMAL; integer; 0=disable simulation init values, 1=enable simulation init
                           -- values
      SIM_ASSERT_CHK => 0, -- DECIMAL; integer; 0=disable simulation messages, 1=enable simulation messages
      SRC_INPUT_REG => 0   -- DECIMAL; integer; 0=do not register input, 1=register input
   )
   port map (
      dest_out => trig_ext_in_lab_sync, -- 1-bit output: src_in synchronized to the destination clock domain. This output
                            -- is registered.

      dest_clk => s_axis_aclk, -- 1-bit input: Clock signal for the destination clock domain.
      src_clk => '0',   -- 1-bit input: optional; required when SRC_INPUT_REG = 1
      src_in => trig_ext_in_lab      -- 1-bit input: Input signal to be synchronized to dest_clk domain.
   );

	trig_out <= (self_trig or periodic_trig) when rising_edge(s_axis_aclk);
	
	trig_ext_in_d1 <= trig_ext_in when rising_edge(s_axis_aclk);
	trig_ext_in_f <= trig_ext_in and (not trig_ext_in_d1) when rising_edge(s_axis_aclk);
	
	trig_ext_in_lab_d1 <= trig_ext_in_lab_sync when rising_edge(s_axis_aclk);
	trig_ext_in_lab_f <= (trig_ext_in_lab and (not trig_ext_in_lab_d1)) and en_trig_ext_lab when rising_edge(s_axis_aclk);
	
	
	
	clkb_select: process(s_axis_aclk)
	begin
		if(rising_edge(s_axis_aclk)) then
			if(clkb_mode = '0') then
				trig_comb <= periodic_trig or self_trig or trig_ext_in_lab_f;
			else
				trig_comb <= trig_ext_in_f;
			end if;
		end if;
	end process;
	
	latency_process: process(s_axis_aclk)
		variable state : integer range 0 to 3 := 0;
	begin
		if(rising_edge(s_axis_aclk)) then
			if(is_started = '0' or clr_all = '1' or clr_trig_service = '1') then
				periodic_trig_latch <= '0';
				--ext_trig_latch <= '0';
				trig_immediate_latch <= '0';
				ta_trig_param_latch <= (others => '0');
				trig <= '0';
				trig_all_cnt_i <= (others => '0');
				state := 0;
			else
				sm_state_latch <= conv_std_logic_vector(state, 4);
				case state is
					when 0 => 
						if(is_started = '1' and pause4ftp = '0') then
							if(trig_comb = '1') then
								periodic_trig_latch <= periodic_trig;
								self_trig_latch <= self_trig;
								--ext_trig_latch <= ext_trig;
								trig_immediate_latch <= trig_immediate;
								ta_trig_param_latch <= s_axis_ta_event_tdata_d1;
								state := state + 1;							
							end if;
						end if;	
					when 1 => 
						if(gtu_sig_d0 = '1' and gtu_sig_d1 = '0') then
							trig <= '1';
							state := state + 1;	
						end if;
					when 2 =>
							trig <= '0';
							state := state + 1;
							if(trig_events_log_en = '0') then
								trig_all_cnt_i <= (others => '0');
							else
								trig_all_cnt_i <= trig_all_cnt_i + 1;
							end if;							 	
					when 3 =>
						if(release = '1' or release_always = '1') then
							state := 0;
						end if;	
				end case;
			end if;
		end if;
	end process;
	

	
	trig_all_cnt_process:  process(s_axis_aclk) 
	begin
		if(rising_edge(s_axis_aclk)) then
		end if;
	end process; 
	
	trig_all_cnt <= trig_all_cnt_i;
	
	s_axis_trg_tdata_d1 <= s_axis_trg_tdata when rising_edge(s_axis_aclk);
	s_axis_trg_tlast_d1 <= s_axis_trg_tlast when rising_edge(s_axis_aclk);
	
	L1_data_latcher: process(s_axis_aclk)
	begin
		if(rising_edge(s_axis_aclk)) then
			if(s_axis_trg_tvalid = '1') then
				s_axis_trg_tdata_d1_latch <= s_axis_trg_tlast_d1 & s_axis_trg_tdata_d1(30 downto 0);				
			end if;
		end if;
	end process;
	
	 
	trig_service: process(s_axis_aclk)
		variable state : integer range 0 to 7 := 0;
	begin
		if(rising_edge(s_axis_aclk)) then
			if(clr_all = '1' or clr_trig_service = '1') then
				trig_cnt <= (others => '0');
				trig_type_i <= (others => '0');
				trig_latch <= '0';
				busy <= '1';		
				state := 0;
			else
				sm_state <= conv_std_logic_vector(state, 4);
				case state is
					when 0 => if(is_started = '1' and pause4ftp = '0') then
											if(trig = '1') then 
												state := state + 1;
												busy <= '1';
												trig_type_i <= (others => '0');
											else
												busy <= '0';
											end if;
										else
											busy <= '1';
										end if;
					when 1 => if(periodic_trig_latch = '1') then
											trig_type_i(31 downto 28) <= "1000";
										elsif(self_trig_latch = '1') then
											trig_type_i(31 downto 28) <= "0100";
										--elsif(trig_immediate_latch = '1') then
										--	trig_type_i(3 downto 0) <= X"3"; 
										--elsif(ext_trig_latch = '1') then
										--	trig_type_i(31 downto 28) <= "0010";
										----elsif(ta_trig_latch = '1') then
											--trig_type_i(3 downto 0) <= X"5";
											--trig_type_i(31 downto 11) <= ta_trig_param_latch(20 downto 0);
										--else
										--	trig_type_i(3 downto 0) <= X"8";
										end if;
										trig_type_i(27 downto 0) <= s_axis_trg_tdata_d1(27 downto 0);
										trig_cnt <= trig_cnt + 1;							
										trig_latch <= '1';		
										gtu_timestamp <= gtu_sig_counter_i;
										unix_timestamp <= unix_time_i;
										state := state + 1;										
					when 2 => if(trig = '0') then
											state := state + 1;
										end if;
					when 3 => if(trig_latch_clr = '1') then
											trig_latch <= '0';
											state := state + 1;
										end if;
					when 4 => if(m_axis_tlast_i = '0') then
											state := state + 1;
										end if;
					when 5 => if(m_axis_tlast_i = '1') then
											state := state + 1;
										end if;
					when 6 => if(trigger_relax_time_cnt = trigger_relax_time) then
											state := state + 1;
											trigger_relax_time_cnt <= (others => '0');
										else
											trigger_relax_time_cnt <= trigger_relax_time_cnt + 1;
										end if;
					when 7 => if(release = '1' or release_always = '1') then
											state := 0;
										end if;
				end case; 
			end if;
		end if;
	end process;
	
	glob_trig_cnt: process(s_axis_aclk)
		variable state : integer range 0 to 1 := 0;
	begin
		if(rising_edge(s_axis_aclk)) then
			if(trig_cnt_glob_clr = '1') then
				trig_cnt_glob_i <= (others => '0');
			else
				case state is
					when 0 =>
						if(trig_latch = '1') then
							trig_cnt_glob_i <= trig_cnt_glob_i + 1;
							state := state + 1;
						end if;
					when 1 =>
						if(trig_latch = '0') then
							state := 0;
						end if;
				end case;
			end if;
		end if;
	end process;
	
	trig_cnt_glob <= trig_cnt_glob_i;
	
	trig_type <= trig_type_i;
	
	mps_sig_timestamp_latcher: process(s_axis_aclk)
		variable state : integer range 0 to 1 := 0;
	begin
		if(rising_edge(s_axis_aclk)) then
			case state is
				when 0 =>
					if(s_axis_mps_tlast = '1') then
						gtu_mps_timestamp <= gtu_sig_counter_i;
						unix_mps_timestamp <= unix_time_i;	
						state := state + 1;		
					end if;	
				when 1 => 
					if(s_axis_mps_tlast = '0') then
						state := 0;
					end if;
			end case;
		end if;
	end process;
	

 	tlast_former_process: process(s_axis_aclk)
 	begin
 		if(rising_edge(s_axis_aclk)) then
 			if(s_axis_tuser = tuser_tlast_d1) then
 				pass_tlast <= '1';
 			else
 				pass_tlast <= '0';
 			end if;
 			s_axis_tvalid_d1 <= s_axis_tvalid;
 			s_axis_tdata_d1 <= s_axis_tdata; 
 			s_axis_tlast_d1 <= s_axis_tlast and s_axis_tvalid and pass_tlast;
			s_axis_tready <= '1';
 		end if;
 	end process;
 	

	i_axis_fifo_fc : axis_fifo_fc
	PORT MAP (
		s_axis_aresetn => s_axis_aresetn,
		s_axis_aclk => s_axis_aclk,
		s_axis_tvalid => s_axis_tvalid_d1,
		s_axis_tlast => s_axis_tlast_d1,
		s_axis_tready => open,
		s_axis_tdata => s_axis_tdata_d1,
		m_axis_tvalid => m_axis_tvalid_key,
		m_axis_tlast => m_axis_tlast_key,
		m_axis_tready => m_axis_tready_key,
		m_axis_tdata => m_axis_tdata_key,
		axis_data_count => axis_fifo_fc_count,
		axis_wr_data_count => open,
		axis_rd_data_count => open
	);

	--m_axis_tready_key <= m_axis_tready_buf and (pass or m_axis_tready_sink);
	m_axis_tready_key <= (pass and m_axis_tready_fc) or m_axis_tready_sink;
	m_axis_tvalid_fc <= m_axis_tvalid_key and pass;
	m_axis_tlast_fc <= m_axis_tlast_key and pass;

	dwc : axis_dwidth_converter_0
	  PORT MAP (
	    aclk => s_axis_aclk,
	    aresetn => s_axis_aresetn,
	    s_axis_tvalid => m_axis_tvalid_fc,
	    s_axis_tready => m_axis_tready_fc,
	    s_axis_tdata => m_axis_tdata_key,
	    s_axis_tlast => m_axis_tlast_fc,
	    m_axis_tvalid => m_axis_tvalid_dwc,
	    m_axis_tready => m_axis_tready_dwc,
	    m_axis_tdata => m_axis_tdata_dwc,
	    m_axis_tlast => m_axis_tlast_dwc
	  );

	comparator: process(s_axis_aclk)
	begin
		if(rising_edge(s_axis_aclk)) then
			if(axis_fifo_fc_count > fifo_thr) then
				fifo_half <= '1';
			else
				fifo_half <= '0';
			end if;
		end if;
	end process;

	sink_process: process(s_axis_aclk)
		variable state : integer range 0 to 6 := 0;
	begin
		if(rising_edge(s_axis_aclk)) then
			if(clr_sink_sm = '1') then
				state := 0;
				m_axis_tready_sink <= '0';
				trig_latch_clr <= '0';
				pass <= '0';
				m_axis_tlast_cnt <= conv_std_logic_vector(0, 16);
			else
				sm_state_sink <= conv_std_logic_vector(state, 4);
				case state is
					-- waiting for tlast. Take a decision: sink or not
					when 0 =>	if(fifo_half = '1') then
											m_axis_tready_sink <= '1';
											if(trig_latch = '1') then
												state := state + 1;
											end if;
										else
											m_axis_tready_sink <= '0';
										end if;
										trig_latch_clr <= '0';
					when 1 => if(m_axis_tlast_key = '1' and m_axis_tlast_key = '1' and m_axis_tready_key = '1') then
											m_axis_tready_sink <= '0';
											pass <= '1';
											m_axis_tlast_cnt <= conv_std_logic_vector(1, 16);
											state := state + 1;
										end if;
					when 2 => if(m_axis_tlast_key = '1' and m_axis_tlast_key = '1' and m_axis_tready_key = '1') then
											if(m_axis_tlast_cnt = num_of_gtus_after_trig) then
												pass <= '0';
												trig_latch_clr <= '1';
												state := state + 1;
											else
												m_axis_tlast_cnt <= m_axis_tlast_cnt + 1;
											end if;
										end if;
					when 3 => state := state + 1;
					when 4 => state := state + 1;
					when 5 => state := state + 1;
					when 6 => state := 0;
				end case;
			end if;
		end if;
	end process;

	maxis_trans_cnt_process: process(s_axis_aclk)
		begin
		if(rising_edge(s_axis_aclk)) then
			-- here we count all transfers accepted from DMA
			if(m_axis_tready_dwc = '1' and m_axis_tvalid_dwc = '1') then
				maxis_accepted_cnt_i <= maxis_accepted_cnt_i + 1;
			end if;
			-- here we count all transfers, whether accepted or not
			if(m_axis_tvalid_dwc = '1') then
				maxis_trans_cnt_i <= maxis_trans_cnt_i + 1;
			end if;
		end if; 	
	end process;
	
	maxis_trans_cnt <= maxis_trans_cnt_i;
	maxis_accepted_cnt <= maxis_accepted_cnt_i;
	
	fifo4dma_overflow_control: process(s_axis_aclk)
	begin
		if(rising_edge(s_axis_aclk)) then
			if(clr_all = '1' or release = '1') then
				dma_error <= '0';
			elsif(m_axis_tready_dwc = '0') then
				dma_error <= '1';
			end if;
		end if;
	end process;
		
	tlast_out_former: process(s_axis_aclk)
	begin
		if(rising_edge(s_axis_aclk)) then
			if(clr_all = '1') then
				m_axis_tlast_dwc2 <= '0';
				tlast_out_cnt <= X"0000";
			else
				if(m_axis_tvalid_dwc = '1') then
					if(tlast_out_cnt = X"B3FE") then --8FFE was in Mini
						tlast_out_cnt <= tlast_out_cnt + 1;
						m_axis_tlast_dwc2 <= '1';
					elsif(tlast_out_cnt = X"B3FF") then 
						tlast_out_cnt <= X"0000";
						m_axis_tlast_dwc2 <= '0';
					else
						tlast_out_cnt <= tlast_out_cnt + 1;
						m_axis_tlast_dwc2 <= '0';
					end if;
				end if;
			end if;
		end if;
	end process;
	
	i_fifo4dma : fifo4dma
	  PORT MAP (
	    s_axis_aresetn => s_axis_aresetn,
	    s_axis_aclk => s_axis_aclk,
	    s_axis_tvalid => m_axis_tvalid_dwc,
	    s_axis_tlast => m_axis_tlast_dwc2,
	    s_axis_tready => m_axis_tready_dwc,
	    s_axis_tdata => m_axis_tdata_dwc,
	    m_axis_tvalid => m_axis_tvalid,
	    m_axis_tlast => m_axis_tlast_i,
	    m_axis_tready => m_axis_tready,
	    m_axis_tdata => m_axis_tdata,
	    axis_data_count => open,
	    axis_wr_data_count => open,
	    axis_rd_data_count => open
	  );

	m_axis_tlast <= m_axis_tlast_i;
-----------------------------------------
-- Trigger GTU event logging to M-AXIS --
-----------------------------------------

--	inject_16_events_process: process(s_axis_aclk)
--	begin
--		if(rising_edge(s_axis_aclk)) then
--			if(cmd_inject_16_events = '1') then 
--				inject_16_events_cnt <= "0000"; 
--				inject_16_events <= '1'; 
--			elsif(inject_16_events_cnt = "1111") then 
--				inject_16_events <= '0'; 
--			else
--				inject_16_events_cnt <= inject_16_events_cnt + 1;
--			end if; 
--		end if;
--	end process;

--	trig_event <= (trig_front and trig_events_log_en) or inject_16_events;
--	s_axis_events_tdata <= gtu_sig_counter_i & X"0001000" & trig_type_i(3 downto 0);

--	i_fifo4gtu_events : fifo4gtu_events
--		PORT MAP (
--			s_axis_aresetn => s_axis_aresetn,
--			s_axis_aclk => s_axis_aclk,
--			s_axis_tvalid => trig_event,
--			s_axis_tready => open,
--			s_axis_tdata => s_axis_events_tdata,--gtu_sig_counter_i,
--			m_axis_tvalid => m_axis_events_tvalid,
--			m_axis_tready => m_axis_events_tready,
--			m_axis_tdata => m_axis_events_tdata,
--			axis_data_count => open,
--			axis_wr_data_count => open,
--			axis_rd_data_count => open
--		);



	n_glob_cycles_proc: process(s_axis_aclk) 
		begin
			if(rising_edge(s_axis_aclk)) then
				if(gtu_sig_d0 = '1' and gtu_sig_d1 = '0') then
					if(glob_cycles_gtu_cnt = n_gtus_per_cycle) then
						glob_cycles_gtu_cnt <= X"0000001";
						n_glob_cycles_i <= n_glob_cycles_i + 1;
					else
						glob_cycles_gtu_cnt <= glob_cycles_gtu_cnt + 1;
					end if;	
				end if;
				n_glob_cycles <= n_glob_cycles_i;
			end if;
		end process; 
		
end Behavioral;
