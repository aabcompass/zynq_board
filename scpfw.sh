#!/bin/bash
scp -o 'ProxyJump belov@134.158.184.46' clkFromArt.runs/impl_1/design_1_wrapper.bit clkFromArt.sdk/lwip_proj/Debug/lwip_proj.elf  euso@134.158.187.50:/tftp

