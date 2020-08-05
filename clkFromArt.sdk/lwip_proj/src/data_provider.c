/*
 * data_provider.c
 *
 *  Created on: Feb 12, 2020
 *      Author: alx
 */

#include "xparameters.h"
#include "data_provider.h"
#include "xbasic_types.h"

static int is_dp_started = 0;

void StartDataProviderForLive()
{
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS2) |= (1<<BIT_INFINITE);
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_N_FRAMES) = 16384;
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS) |= (1<<BIT_RUN) | (1<<BIT_START_SIG);
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS) &= ~(1<<BIT_START_SIG);
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS2) |= (1<<BIT_RUN_DATACONV) | (1<<BIT_INFINITE);
	is_dp_started = 1;
	print("Data provider started\n\r");
}

void StopDataProviderForLive()
{
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS2) = 0;
	is_dp_started = 0;
	print("Data provider stopped\n\r");
}

void ResetDataConverter()
{
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS2) = 0;
	print("Switching off SERDES\n\r");
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATACONV_RESET) = (1<<BIT_DATACONV_RESET);
	print("Resetting data converter\n\r");
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATACONV_RESET) = 0;
}

void SetPMTZero()
{
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_PMTZERO_01) = 0;
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_PMTZERO_2) = 1;
}

void ResetScurveAdder()
{
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATACONV_RESET) = (1<<BIT_SCURVE_ADDER_RESET);
	print("Resetting scurve adder\n\r");
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATACONV_RESET) = 0;
	print("Ok\n\r");
}

int IsDataProviderStarted()
{
	return is_dp_started;
}
