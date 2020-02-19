#create_clock -period 6.2500 -name CLK_IN_D_0_clk_p -waveform {0.000 3.125} [get_ports CLK_IN_D_0_clk_p]


create_clock -period 2.500 -name CLK_IN_D_0_clk_p -waveform {0.000 1.250} [get_ports CLK_IN_D_0_clk_p]
create_clock -period 2.500 -name diff_clk_in_0_clk_p -waveform {0.000 1.250} [get_ports diff_clk_in_0_clk_p]
create_clock -period 2.500 -name diff_clk_in_1_clk_p -waveform {0.000 1.250} [get_ports diff_clk_in_1_clk_p] 
