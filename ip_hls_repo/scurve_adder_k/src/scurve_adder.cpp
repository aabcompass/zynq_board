/*
Scurve adder IP Sept 2019
Francesca Capel
capel.francesca@gmail.com

Version 4
---------
Scurve adder IP for the Mini-EUSO instrument. Used to generate S-curves on chip to reduce file size and data processing.
Takes 6 x 16-bit input stream (2 8-bit pixels) and outputs a 32-bit stream (2 16-bit pixels).
Number of iterations is controlled by the input port N (AXI4Lite slave).
Channels are output sequentially and the number of channels processed can be specified on the input port CH_INFO (AXI4Lite slave)
	//Decision on which channels to process:
	//'111111' -> 0x3F all channels
	//'001111' -> 0x0F on channels #2 to #5 etc.
*/

#include "scurve_adder.h"

void scurve_adder(STREAM_16 &in_stream0 /*two uint8 per transfer*/,
		STREAM_64 &out_stream /*two uint32 per transfer*/, uint16_t N_ADDS/*, uint8_t CH_INFO*/) {

	//Define the interfaces
	#pragma HLS INTERFACE axis port=in_stream0
	#pragma HLS INTERFACE axis port=out_stream
	#pragma HLS INTERFACE s_axilite port=N_ADDS bundle=CTRL_BUS
	#pragma HLS INTERFACE s_axilite port=return bundle=CTRL_BUS

	int i, k, l;
	int N, N_check;
	uint8_t in_pix1_ch0[N_PIXELS/2], in_pix2_ch0[N_PIXELS/2];

	int sum_pix1_ch0[N_PIXELS/2], sum_pix2_ch0[N_PIXELS/2];
	 
	AXI_DATA_16 dub_pix_ch0[N_PIXELS/2];

	AXI_DATA_64 sum_pix_tot;

	//Check last channel to read out
	N = 0;


	//initialise sum_pix
	for (i = 0; i < N_PIXELS/2; i++) {
	#pragma HLS PIPELINE
		sum_pix1_ch0[i] = 0;
		sum_pix2_ch0[i] = 0;
	}

	//Read data and perform addition for N iterations
	for (k = 0; k < N_ADDS; k++) {
	  
	    //Make a loop over all pixels
		for (i = 0; i < N_PIXELS/2; i++) {
		#pragma HLS PIPELINE


			//Select channels to process by checking CH_INFO
			//Read the input pixel values for 1 GTU and add to accumulator
			//Split input into 2 separate pixels
			// pixel2 | pixel1
			//Perform accumulation for each pixel

			dub_pix_ch0[i] = in_stream0.read();
			in_pix1_ch0[i] = (dub_pix_ch0[i].data & 0xFF);
			in_pix2_ch0[i] = dub_pix_ch0[i].data  >> 8;
			sum_pix1_ch0[i] += in_pix1_ch0[i];
			sum_pix2_ch0[i] += in_pix2_ch0[i];
		}
	}
	
	//Populate the output stream for processed channels only
	//TLAST signal is output for channel # = highest set bit in CH_INFO
	N_check = 0;
	for (i = 0; i < N_PIXELS/2; i++) {
	#pragma HLS PIPELINE

		sum_pix_tot.data = (long)sum_pix2_ch0[i]<<32 | sum_pix1_ch0[i];
		sum_pix_tot.keep = 63;
		sum_pix_tot.strb = 63;
		sum_pix_tot.user = dub_pix_ch0[0].user;
		sum_pix_tot.id = dub_pix_ch0[0].id;
		sum_pix_tot.dest = dub_pix_ch0[0].dest;
		if(i == N_PIXELS/2 - 1) {
			sum_pix_tot.last = 1;
		}
		else {
			sum_pix_tot.last = 0;
		}
		out_stream.write(sum_pix_tot);
	}
}
