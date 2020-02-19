/*
 * data_provider.c
 *
 *  Created on: Feb 12, 2020
 *      Author: alx
 */

#include "xparameters.h"
#include "data_provider.h"
#include "xbasic_types.h"

void StartDataProviderForLive()
{
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_N_FRAMES) = 16384;
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS) |= (1<<BIT_RUN) | (1<<BIT_START_SIG);
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS) &= ~(1<<BIT_START_SIG);
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS2) |= (1<<BIT_RUN_DATACONV) | (1<<BIT_INFINITE);
}

void StopDataProviderForLive()
{
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS2) = 0;
}

void ResetDataConverter()
{
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS2) = 0;
	print("Switching off SERDES\n\r");
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATACONV_RESET) = (1<<BIT_DATACONV_RESET);
	print("Resetting data converter\n\r");
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATACONV_RESET) = 0;
}