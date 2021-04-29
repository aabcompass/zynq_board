#*******************************************************************************
# Create a project
open_project -reset axis_manager

# Add design files
add_files axis_manager.cpp
# Add test bench & files
add_files -tb axis_manager_test.cpp

# Set the top-level function
set_top axis_manager

# ########################################################
# Create a solution
open_solution -reset solution1
# Define technology and clock rate
set_part  {xc7z035ffg676-2}
create_clock -period 4

# Source x_hls.tcl to determine which steps to execute
source x_hls.tcl
csim_design
# Set any optimization directives
# End of directives

if {$hls_exec == 1} {
	# Run Synthesis and Exit
	csynth_design
	
} elseif {$hls_exec == 2} {
	# Run Synthesis, RTL Simulation and Exit
	csynth_design
	
	cosim_design
} elseif {$hls_exec == 3} { 
	# Run Synthesis, RTL Simulation, RTL implementation and Exit
	csynth_design
	
	cosim_design
	export_design
elseif {$hls_exec == 10} { 
	# Just open design
} else {
	# Default is to exit after setup
	csynth_design
}

exit


