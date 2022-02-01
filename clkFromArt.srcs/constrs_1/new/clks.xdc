create_clock -period 2.500 -name CLK_IN_D_0_clk_p -waveform {0.000 1.250} [get_ports CLK_IN_D_0_clk_p]
create_clock -period 2.500 -name diff_clk_in_0_clk_p -waveform {0.000 1.250} [get_ports diff_clk_in_0_clk_p]
create_clock -period 2.500 -name diff_clk_in_1_clk_p -waveform {0.000 1.250} [get_ports diff_clk_in_1_clk_p] 

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets design_1_i/axi_clkb_core_0/U0/i_clkb_core/SPB_CLK_40_i]