#ifndef __SCURVEADDER_H__
#define __SCURVEADDER_H__

#include <stdlib.h>
#include <hls_stream.h>
#include <ap_axi_sdata.h>
#include <inttypes.h>
#include <bitset>

// Where am I?

#define HW_COSIM

#define N_PIXELS 2304
#define K_PAR	16

#define CHECK_BIT(var, pos) ((var) & (1<<(pos)))

typedef ap_axis<16,6,5,6> AXI_DATA_16;
typedef ap_axis<32,6,5,6> AXI_DATA_32;
typedef ap_axis<64,6,5,6> AXI_DATA_64;
typedef ap_axis<128,6,5,6> AXI_DATA_128;
typedef ap_axis<256,6,5,6> AXI_DATA_256;
typedef ap_axis<512,6,5,6> AXI_DATA_512;
typedef hls::stream<AXI_DATA_16> STREAM_16;
typedef hls::stream<AXI_DATA_32> STREAM_32;
typedef hls::stream<AXI_DATA_64> STREAM_64;
typedef hls::stream<AXI_DATA_128> STREAM_128;
typedef hls::stream<AXI_DATA_256> STREAM_256;
typedef hls::stream<AXI_DATA_512> STREAM_512;

void scurve_adder36(STREAM_128 &in_stream0,
		STREAM_512 &out_stream, uint16_t N_ADDS);

//typedef ap_int<128>   int128_t;
typedef ap_uint<128>   uint128_t;
//typedef ap_int<512>   int512_t;
typedef ap_uint<512>   uint512_t;

#endif


