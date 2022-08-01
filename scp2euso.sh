#!/bin/bash
scp -o 'ProxyJump belov@134.158.184.46, euso-spb2@138.67.37.114:2022'   clkFromArt.runs/impl_1/design_1_wrapper.bit clkFromArt.sdk/lwip_proj/Debug/lwip_proj.elf  root@192.168.1.4:/home/spb2/Alexander
