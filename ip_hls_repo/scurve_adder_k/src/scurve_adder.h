#ifndef __SCURVEADDER_H__
#define __SCURVEADDER_H__

#include <stdlib.h>
#include <hls_stream.h>
#include <ap_axi_sdata.h>
#include <inttypes.h>
#include <bitset>

#define HW_COSIM

#define N_PIXELS 64

#define CHECK_BIT(var, pos) ((var) & (1<<(pos)))

typedef ap_axis<16,2,5,6> AXI_DATA_16;
typedef ap_axis<32,2,5,6> AXI_DATA_32;
typedef ap_axis<64,2,5,6> AXI_DATA_64;
typedef ap_axis<128,2,5,6> AXI_DATA_128;
typedef ap_axis<256,2,5,6> AXI_DATA_256;
typedef ap_axis<512,2,5,6> AXI_DATA_512;
typedef hls::stream<AXI_DATA_16> STREAM_16;
typedef hls::stream<AXI_DATA_32> STREAM_32;
typedef hls::stream<AXI_DATA_64> STREAM_64;
typedef hls::stream<AXI_DATA_128> STREAM_128;
typedef hls::stream<AXI_DATA_256> STREAM_256;
typedef hls::stream<AXI_DATA_512> STREAM_512;

void scurve_adder(STREAM_16 &in_stream0,
		STREAM_64 &out_stream, uint16_t N_ADDS);

#endif


