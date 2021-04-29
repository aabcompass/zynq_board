/*
*/

#include "scurve_adder.h"

void scurve_adder36(STREAM_128 &in_stream0 /*16 uint8 per transfer*/,
		STREAM_512 &out_stream /*two uint32 per transfer*/,
		uint16_t N_ADDS/*, uint8_t CH_INFO*/,
		uint32_t TEST_MODE,
		uint16_t K_TLAST,
		uint16_t n_pixels) {

	//Define the interfaces
	#pragma HLS INTERFACE axis port=in_stream0
	#pragma HLS INTERFACE axis port=out_stream
	#pragma HLS INTERFACE s_axilite port=N_ADDS bundle=CTRL_BUS
	#pragma HLS INTERFACE s_axilite port=TEST_MODE bundle=CTRL_BUS
	#pragma HLS INTERFACE s_axilite port=K_TLAST bundle=CTRL_BUS
	#pragma HLS INTERFACE s_axilite port=n_pixels bundle=CTRL_BUS
	#pragma HLS INTERFACE s_axilite port=return bundle=CTRL_BUS

	int i, j, k, l;
	int N;
	uint8_t in_pix_ch0[K_PAR][N_PIXELS/K_PAR];

	uint32_t sum_pix_ch0[K_PAR][N_PIXELS/K_PAR];

	AXI_DATA_128 dub_pix_ch0[N_PIXELS/K_PAR];

	AXI_DATA_512 sum_pix_tot;

	uint16_t k_tlast_cnt = 0;

	//Check last channel to read out
	N = 0;

	for(k_tlast_cnt=0; k_tlast_cnt<K_TLAST; k_tlast_cnt++)
	{
		//initialise sum_pix
		for (i = 0; i < n_pixels/K_PAR; i++) {
		#pragma HLS PIPELINE
			for(j = 0; j < K_PAR; j++) {
				sum_pix_ch0[j][i] = 0;
			}
		}
	
		//Read data and perform addition for N iterations
		for (k = 0; k < N_ADDS; k++) {

			//Make a loop over all pixels
			for (i = 0; i < n_pixels/K_PAR; i++) {
			#pragma HLS PIPELINE


				//Select channels to process by checking CH_INFO
				//Read the input pixel values for 1 GTU and add to accumulator
				//Split input into 2 separate pixels
				// pixel2 | pixel1
				//Perform accumulation for each pixel
				dub_pix_ch0[i] = in_stream0.read();
				for(j = 0; j < K_PAR; j++) {
					in_pix_ch0[j][i] = ((dub_pix_ch0[i].data >> (8*j)) & 0xFF);
					sum_pix_ch0[j][i] += in_pix_ch0[j][i];
				}
				//in_pix1_ch0[i] = (dub_pix_ch0[i].data & 0xFF);
				//in_pix2_ch0[i] = dub_pix_ch0[i].data  >> 8;
				//sum_pix1_ch0[i] += in_pix1_ch0[i];
				//sum_pix2_ch0[i] += in_pix2_ch0[i];
			}
		}

		//Populate the output stream for processed channels only
		//TLAST signal is output for channel # = highest set bit in CH_INFO
		for (i = 0; i < n_pixels/K_PAR; i++) {
		#pragma HLS PIPELINE

			//sum_pix_tot.data = (long)sum_pix2_ch0[i]<<32 | sum_pix1_ch0[i];
			sum_pix_tot.keep = -1;
			sum_pix_tot.strb = -1;
			sum_pix_tot.user = 0;//dub_pix_ch0[0].user;
			sum_pix_tot.id = 0;//dub_pix_ch0[0].id;
			sum_pix_tot.dest = 0;//dub_pix_ch0[0].dest;
			if(i == n_pixels/K_PAR - 1) {
				if(k_tlast_cnt == K_TLAST - 1) {
					sum_pix_tot.last = 1;
				} else {
					sum_pix_tot.last = 0;
				}
			}
			else {
				sum_pix_tot.last = 0;
			}

			sum_pix_tot.data = 0;
			if(!TEST_MODE)
			{
				for(j = 0; j < K_PAR; j++) {
					sum_pix_tot.data |= ((uint512_t)sum_pix_ch0[j][i] << (32*j));
				}
			}
			else
			{
				for(j = 0; j < K_PAR; j++) {
					sum_pix_tot.data |= ((uint512_t)(i*K_PAR+j) << (32*j));
				}
			}


			out_stream.write(sum_pix_tot);
		}
	}
}
