#!/bin/sh
lli=${LLVMINTERP-lli}
exec $lli \
    /home/alx/xil_proj/zynq_board/current/ip_hls_repo/scurve_adder_1/scurve_adder_1/solution1/.autopilot/db/a.g.bc ${1+"$@"}
