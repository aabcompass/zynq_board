
/opt/Xilinx/Vivado/2018.1/bin/xelab xil_defaultlib.apatb_scurve_adder_top glbl -prj scurve_adder.prj -L smartconnect_v1_0 -L axi_protocol_checker_v1_1_12 -L axi_protocol_checker_v1_1_13 -L axis_protocol_checker_v1_1_11 -L axis_protocol_checker_v1_1_12 -L xil_defaultlib -L unisims_ver --initfile "/opt/Xilinx/Vivado/2018.1/data/xsim/ip/xsim_ip.ini" --lib "ieee_proposed=./ieee_proposed" -s scurve_adder 
/opt/Xilinx/Vivado/2018.1/bin/xsim --noieeewarnings scurve_adder -tclbatch scurve_adder.tcl

