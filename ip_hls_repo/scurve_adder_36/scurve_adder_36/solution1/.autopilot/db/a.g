#!/bin/sh
lli=${LLVMINTERP-lli}
exec $lli \
    /home/alx/xil_proj/zynq_board/master2/ip_hls_repo/scurve_adder_36/scurve_adder_36/solution1/.autopilot/db/a.g.bc ${1+"$@"}
