############################################################
## This file is generated automatically by Vivado HLS.
## Please DO NOT edit it.
## Copyright (C) 1986-2018 Xilinx, Inc. All Rights Reserved.
############################################################
open_project scurve_adder_36
set_top scurve_adder36
add_files scurve_adder.cpp
add_files -tb scurve_adder_test.cpp
open_solution "solution1"
set_part {xc7z035ffg676-2}
create_clock -period 4 -name default
config_rtl -encoding onehot -reset all -reset_level high
#source "./scurve_adder_36/solution1/directives.tcl"
csim_design -compiler gcc
csynth_design
cosim_design -compiler gcc -trace_level all -tool xsim
export_design -rtl verilog -format ip_catalog
