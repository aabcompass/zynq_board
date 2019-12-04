#include <stdio.h>
#include "scurve_adder.h"

int main() {

	/* DEFINITIONS */
	STREAM_16 inputStream_SW_0, inputStream_HW_0; 

	STREAM_64 outputStream_SW, outputStream_HW;

	uint16_t N_ADDS = 30;
	uint8_t N_CH = 1;

	uint16_t concat;
	int error_count;

	int i, k;
	uint8_t in_pix1_ch0[N_PIXELS/2], in_pix2_ch0[N_PIXELS/2];

	uint32_t sum_pix1_ch0[N_PIXELS/2], sum_pix2_ch0[N_PIXELS/2];


	AXI_DATA_16 dub_pix_ch0[N_PIXELS/2];

	AXI_DATA_16 A;
	AXI_DATA_64 sum_pix_tot;

	//int CH_INFO = 1;//0x3F;
	//std::bitset<6> channel_info(CH_INFO);


	/* SCURVE ADDER TESTBENCH */
	printf("Starting scurve_adder test...\n");

	//Populate the input streams
	for (i = 0; i < N_PIXELS*N_ADDS; i+=2) {
		concat = ((i & 0xff) << 8) | ((i+1) & 0xff);
		A.data = concat;
		A.keep = 1;
		A.strb = 1;
		A.user = 1;
		A.id = 0;
		A.dest = 0;
		inputStream_SW_0 << A;
		inputStream_HW_0 << A;

	}

	/* SOFTWARE IMPLEMENTATION */
	//initialise sum_pix
	for (i = 0; i < N_PIXELS/2; i++) {
		sum_pix1_ch0[i] = 0;
		sum_pix2_ch0[i] = 0;
	}

	//Read data and perform addition for N_ADDS iterations
	for (k = 0; k < N_ADDS; k++) {

		//Make a loop over 16 different pixels for now
		for (i = 0; i < N_PIXELS/2; i++) {

			//Select channels to process by checking the channel_info bitset
			//Read the input pixel values for 1 GTU and add to accumulator
			//Split input into 2 separate pixels
			//Perform accumulation for each pixel

			dub_pix_ch0[i] = inputStream_SW_0.read();
			in_pix1_ch0[i] = dub_pix_ch0[i].data & 0xFF;
			in_pix2_ch0[i] = (dub_pix_ch0[i].data >> 8);
			sum_pix1_ch0[i] += in_pix1_ch0[i];
			sum_pix2_ch0[i] += in_pix2_ch0[i];
		}
	}

	//Populate the output stream for processed channels only
	//TLAST signal is output for channel # = highest set bit in CH_INFO
	for (i = 0; i < N_PIXELS/2; i++){
		sum_pix_tot.data = (long)sum_pix2_ch0[i]<<32 | sum_pix1_ch0[i];
		sum_pix_tot.keep = dub_pix_ch0[0].keep;
		sum_pix_tot.strb = dub_pix_ch0[0].strb;
		sum_pix_tot.user = dub_pix_ch0[0].user;
		sum_pix_tot.id = dub_pix_ch0[0].id;
		sum_pix_tot.dest = dub_pix_ch0[0].dest;
		outputStream_SW.write(sum_pix_tot);
	}

	/* HARDWARE IMPLEMENTATION */
	scurve_adder(inputStream_HW_0,
			outputStream_HW, N_ADDS);

	//Read the output and test
	for (i = 0; i < (N_PIXELS/2)*N_CH; i++) {
		AXI_DATA_64 B_HW;
		AXI_DATA_64 B_SW;
		outputStream_HW.read(B_HW);
		outputStream_SW.read(B_SW);
		printf("SW: %lu HW: %lu \n", (long)B_SW.data, (long)B_HW.data);

		if (B_HW.data != B_SW.data) {
			error_count++;
		}
		else {

		}
	}

	if (error_count == 0) {
		printf("TEST PASSED!\n");
	}
	else {
		printf("TEST FAILED!\n");
	}

	return error_count;
}
