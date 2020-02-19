#include <stdio.h>
#include "scurve_adder.h"

int main() {

	/* DEFINITIONS */
	STREAM_128 inputStream_SW_0, inputStream_HW_0;

	STREAM_512 outputStream_SW, outputStream_HW;

	uint16_t N_ADDS = 30;
	uint8_t N_CH = 1;
	uint32_t is_test_mode = 1;

	uint128_t concat;
	int error_count;

	int i, j, k;
	uint8_t in_pix_ch0[K_PAR][N_PIXELS/K_PAR];

	uint32_t sum_pix_ch0[K_PAR][N_PIXELS/K_PAR];


	AXI_DATA_128 dub_pix_ch0[N_PIXELS/K_PAR];

	AXI_DATA_128 A;
	AXI_DATA_512 sum_pix_tot;

	//int CH_INFO = 1;//0x3F;


	/* SCURVE ADDER TESTBENCH */
	printf("Starting scurve_adder test...\n");

	//Populate the input streams
	for (i = 0; i < N_PIXELS*N_ADDS; i += K_PAR) {
		//concat = ((i & 0xff) << 8) | ((i+1) & 0xff);
		concat = 0;
		for(j = 0; j < K_PAR; j++) {
			concat |= ((uint128_t)((i + j) & 0xff) << (8*j));
			printf("A: i=%d j=%d\n", i, j);

		}
		A.data = concat;
		A.keep = 2<<16-1;
		A.strb = 2<<16-1;
		A.user = 1;
		A.id = 0;
		A.dest = 0;
		inputStream_SW_0 << A;
		inputStream_HW_0 << A;

	}

	/* SOFTWARE IMPLEMENTATION */
	//initialise sum_pix
	for (i = 0; i < N_PIXELS/K_PAR; i++) {
		for (j = 0; j < K_PAR; j++) {
			sum_pix_ch0[j][i] = 0;
			printf("B: i=%d j=%d\n", i, j);
		}
	}

	//Read data and perform addition for N_ADDS iterations
	for (k = 0; k < N_ADDS; k++) {

		//Make a loop over 16 different pixels for now
		for (i = 0; i < N_PIXELS/K_PAR; i++) {

			//Select channels to process by checking the channel_info bitset
			//Read the input pixel values for 1 GTU and add to accumulator
			//Split input into 2 separate pixels
			//Perform accumulation for each pixel

			dub_pix_ch0[i] = inputStream_SW_0.read();
			for(j = 0; j < K_PAR; j++)
			{
				in_pix_ch0[j][i] = ((dub_pix_ch0[i].data >> (8*j)) & 0xFF);
				sum_pix_ch0[j][i] += in_pix_ch0[j][i];
				printf("C: i=%d j=%d k=%d\n", i, j, k);
			}
			//in_pix1_ch0[i] = dub_pix_ch0[i].data & 0xFF;
			//in_pix2_ch0[i] = (dub_pix_ch0[i].data >> 8);
			//sum_pix1_ch0[i] += in_pix1_ch0[i];
			//sum_pix2_ch0[i] += in_pix2_ch0[i];
		}
	}

	//Populate the output stream for processed channels only
	//TLAST signal is output for channel # = highest set bit in CH_INFO
	for (i = 0; i < N_PIXELS/K_PAR; i++) {
		sum_pix_tot.data = 0;
		if(!is_test_mode)
		{
			for(j = 0; j < K_PAR; j++) {
				sum_pix_tot.data |= ((uint512_t)sum_pix_ch0[j][i] << (32*j));
				printf("D: i=%d j=%d\n", i, j);
			}
		}
		else
		{
			for(j = 0; j < K_PAR; j++) {
				sum_pix_tot.data |= ((uint512_t)(i*K_PAR+j) << (32*j));
				printf("D: i=%d j=%d\n", i, j);
			}
		}
		sum_pix_tot.keep = dub_pix_ch0[0].keep;
		sum_pix_tot.strb = dub_pix_ch0[0].strb;
		sum_pix_tot.user = dub_pix_ch0[0].user;
		sum_pix_tot.id = dub_pix_ch0[0].id;
		sum_pix_tot.dest = dub_pix_ch0[0].dest;
		outputStream_SW.write(sum_pix_tot);
	}

	/* HARDWARE IMPLEMENTATION */
	printf("\n\rHW started\n\r");
	scurve_adder36(inputStream_HW_0,
			outputStream_HW, N_ADDS, is_test_mode);
	//printf("\n\rHW 2nd started\n\r");
	//scurve_adder(inputStream_HW_0,
	//		outputStream_HW, N_ADDS);
	printf("\n\rHW stopped\n\r");

	//Read the output and test
	for (i = 0; i < (N_PIXELS/K_PAR); i++) {
		AXI_DATA_512 B_HW;
		AXI_DATA_512 B_SW;
		outputStream_HW.read(B_HW);
		outputStream_SW.read(B_SW);
		printf("E: i=%d\n", i);
		//printf("SW: %lu HW: %lu \n", (long)B_SW.data, (long)B_HW.data);

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
