/*
 * pixel_scan.c
 *
 *  Created on: 3 июн. 2021 г.
 *      Author: alx
 */

#include "xbasic_types.h"
#include "common.h"
#include "dma_handling.h"
#include "pdmdata.h"
#include "data_provider.h"

u32 n_of_pixels_scanned = 100;
u32 current_pixel_scanned;
u32 trg_sig = 0;

static enum  {
	no_state,
	start_pixelscan,
	wait_trg,
	start_dma1,
	start_dma2,
	pass_data,
	wait_pass_state1,
	wait_pass_state2,
	condition_state,
	end_state
} pixelscan_sm_state = no_state;

void set_n_of_pixels_scanned(u32 n_scans)
{
	n_of_pixels_scanned = n_scans;
}

int pixelscan_start()
{
	if(pixelscan_sm_state != no_state)
		return -1;
	pixelscan_sm_state = start_pixelscan;
	return 0;
}


void pixelscan_trg()
{
	trg_sig = 1;
}

u32 pixelscan_get_curr_pixel()
{
	return current_pixel_scanned;
}

void pixelscan_sm()
{
	u32 ret;
	static int i=0;
	switch(pixelscan_sm_state)
	{
		case no_state:
			break;
		case start_pixelscan:
			current_pixel_scanned = 0;
			//Set_n_d3_per_file(N_D3_PER_FILE);
			pixelscan_sm_state = wait_trg;
			break;
		case wait_trg:
			if(trg_sig == 1) {
				trg_sig = 0;
				pixelscan_sm_state = start_dma1;
				if(current_pixel_scanned%N_D3_PER_FILE == 0) {
					pixelscan_sm_state = start_dma1;
				}
				else {
					pixelscan_sm_state = pass_data;
				}
			}
			break;
		case start_dma1:
			if(current_pixel_scanned>0) {
				ret = Is_D3_received();
				//xil_printf("i=%d ", i++);
				if(ret != 0) {
					pixelscan_sm_state = start_dma2;
				}
				else {
					i++;
					if((i%1000000) == 0)
						print("?");
				}
			}
			else {
				pixelscan_sm_state = start_dma2;
			}
			break;
		case start_dma2:
			if(current_pixel_scanned%N_D3_PER_FILE == 0) {
				L3Start(FINITE, N_D3_PER_FILE);
			}
			pixelscan_sm_state = pass_data;
			break;
		case pass_data:
			StartDataProviderFor1D3frame(GetIntegration());
			pixelscan_sm_state = wait_pass_state1;
			break;
		case wait_pass_state1:
			print("!");
			if(IsDataProviderPass())
				pixelscan_sm_state = wait_pass_state2;
			break;
		case wait_pass_state2:
			print("\0");
			if(!IsDataProviderPass())
				pixelscan_sm_state = condition_state;
			break;
		case condition_state:
			//if(current_common_thr == NMAX_OF_THESHOLDS-1) {
			if(current_pixel_scanned == n_of_pixels_scanned-1) {
				pixelscan_sm_state = end_state;
			}
			else {
				pixelscan_sm_state = wait_trg;
				current_pixel_scanned++;
			}
			break;
		case end_state:
			pixelscan_sm_state = no_state;
			break;
	}
}
