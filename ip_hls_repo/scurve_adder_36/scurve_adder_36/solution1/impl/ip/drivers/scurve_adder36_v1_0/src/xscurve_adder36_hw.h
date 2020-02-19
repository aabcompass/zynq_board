// ==============================================================
// File generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
// Version: 2018.1
// Copyright (C) 1986-2018 Xilinx, Inc. All Rights Reserved.
// 
// ==============================================================

// CTRL_BUS
// 0x00 : Control signals
//        bit 0  - ap_start (Read/Write/COH)
//        bit 1  - ap_done (Read/COR)
//        bit 2  - ap_idle (Read)
//        bit 3  - ap_ready (Read)
//        bit 7  - auto_restart (Read/Write)
//        others - reserved
// 0x04 : Global Interrupt Enable Register
//        bit 0  - Global Interrupt Enable (Read/Write)
//        others - reserved
// 0x08 : IP Interrupt Enable Register (Read/Write)
//        bit 0  - Channel 0 (ap_done)
//        bit 1  - Channel 1 (ap_ready)
//        others - reserved
// 0x0c : IP Interrupt Status Register (Read/TOW)
//        bit 0  - Channel 0 (ap_done)
//        bit 1  - Channel 1 (ap_ready)
//        others - reserved
// 0x10 : Data signal of N_ADDS
//        bit 15~0 - N_ADDS[15:0] (Read/Write)
//        others   - reserved
// 0x14 : reserved
// 0x18 : Data signal of TEST_MODE
//        bit 31~0 - TEST_MODE[31:0] (Read/Write)
// 0x1c : reserved
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

#define XSCURVE_ADDER36_CTRL_BUS_ADDR_AP_CTRL        0x00
#define XSCURVE_ADDER36_CTRL_BUS_ADDR_GIE            0x04
#define XSCURVE_ADDER36_CTRL_BUS_ADDR_IER            0x08
#define XSCURVE_ADDER36_CTRL_BUS_ADDR_ISR            0x0c
#define XSCURVE_ADDER36_CTRL_BUS_ADDR_N_ADDS_DATA    0x10
#define XSCURVE_ADDER36_CTRL_BUS_BITS_N_ADDS_DATA    16
#define XSCURVE_ADDER36_CTRL_BUS_ADDR_TEST_MODE_DATA 0x18
#define XSCURVE_ADDER36_CTRL_BUS_BITS_TEST_MODE_DATA 32

