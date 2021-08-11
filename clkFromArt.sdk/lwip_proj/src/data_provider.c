/*
 * data_provider.c
 *
 *  Created on: Feb 12, 2020
 *      Author: alx
 */

#include "xparameters.h"
#include "data_provider.h"
#include "xbasic_types.h"
#include "pdmdata.h"

static int is_dp_started = 0;

//void StartDataProviderForNFrames(u32 n_frames)
//{
//	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_N_FRAMES) = n_frames;
//	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS) |= (1<<BIT_RUN) | (1<<BIT_START_SIG);
//	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS) &= ~(1<<BIT_START_SIG);
//	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS2) |= (1<<BIT_RUN_DATACONV);
//	is_dp_started = 1;
//}

void StartDataProvider()
{
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS2) |= (1<<BIT_INFINITE);
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_N_FRAMES) = N_INTEGRATION;
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS) |= (1<<BIT_RUN) | (1<<BIT_START_SIG);
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS) &= ~(1<<BIT_START_SIG);
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS2) |= (1<<BIT_RUN_DATACONV) | (1<<BIT_INFINITE);
	is_dp_started = 1;
}

void StartSerdes()
{
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS2) |= (1<<BIT_RUN_SELECTIO);
}

void StartDataProviderForLive()
{
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS2) |= (1<<BIT_INFINITE);
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_N_FRAMES) = N_INTEGRATION;
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS) |= (1<<BIT_RUN) | (1<<BIT_START_SIG);
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS) &= ~(1<<BIT_START_SIG);
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS2) |= (1<<BIT_RUN_DATACONV) | (1<<BIT_INFINITE);
	is_dp_started = 1;
	print("Data provider for live started\n\r");
}

void StartDataProviderFor1D3frame(u32 n_integration)
{
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS2) &= ~(1<<BIT_INFINITE);
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_N_FRAMES) = n_integration;
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS) |= (1<<BIT_RUN);
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS) |= (1<<BIT_START_SIG);
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS) &= ~(1<<BIT_START_SIG);
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS2) |= (1<<BIT_RUN_DATACONV);
}

void StopDataConverter()
{
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS2) &= ~(1<<BIT_RUN_DATACONV);
}

u32 IsDataProviderPass()
{
	return *(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGR_DATAPROV_STATUS) & (1<<BIT_DP_PASS);
}

void StopDataProvider()
{
	//*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS2) &= ~(1<<BIT_INFINITE);
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS) &= ~(1<<BIT_RUN);
	do {print("%");} while(IsDataProviderPass());
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS2) &= ~(1<<BIT_RUN_DATACONV);
}

void StopDataProviderForLive()
{
	//*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS2) &= ~((1<<BIT_RUN_DATACONV) | (1<<BIT_INFINITE));
	StopDataProvider();
	is_dp_started = 0;
	print("Data provider stopped\n\r");
}

void StartDataProviderInitial()
{
	int i;
	//*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_N_FRAMES) = 0;
	//*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS) |= ((1<<BIT_START_SIG) | (1<<BIT_INFINITE));
	//for(i=0;i<100000000;i++);
	SetArtixFrameOn(1);
	print("Artix Frame started\n\r");
	StartSerdes();
	print("Serdes started\n\r");
	for(i=0;i<1000000;i++);
	xil_printf("Bitslips: %d %d %d\n\r",
			*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGR_DATAPROV_BITSLIP_CNT_0),
			*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGR_DATAPROV_BITSLIP_CNT_1),
			*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGR_DATAPROV_BITSLIP_CNT_2));
	StartDataProviderForLive();
	for(i=0;i<100000000;i++);
	StopDataProviderForLive();
}


void ResetDataConverter()
{
	//*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS2) = 0;
	print("Resetting data converter\n\r");
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATACONV_RESET) = (1<<BIT_DATACONV_RESET);
	print("Resetting data converter DONE\n\r");
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

void ArtixClkEn(u32 en)
{
	if(en)
		*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_CLKEN) |= (1<<BIT_ART_CLKEN);
	else
		*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_CLKEN) &= ~(1<<BIT_ART_CLKEN);
}

void SetGtuFreq1us(u32 is_gtu_1us)
{
	if(is_gtu_1us)
		*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS2) |= (1<<BIT_GTU_1US);
	else
		*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS2) &= ~(1<<BIT_GTU_1US);
}

void RunArtix(u32 is_gtu_1us)
{
	ArtixClkEn(0);
	xil_printf("Artix clock stopped.\n\r");
	SetGtuFreq1us(is_gtu_1us);
	xil_printf("Starting Artix clock...");
	ArtixClkEn(1);
	xil_printf("Ok\n\r");
	xil_printf("SetArtixTransmitDelay...");
	if(is_gtu_1us)
		SetArtixTransmitDelay(2);
	else
		SetArtixTransmitDelay(2);
	printf("RunArtixAcq\n\r");
	SetArtixAcqOn();
}

void DataProvTestMode(int on, u32 period_gtu, u32 patt_init, u32 patt_max)
{
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_INCR_PER) = period_gtu*5*N_OF_PMT_PER_ECASIC*N_OF_ECASIC_PER_PDM;
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_PATT) = ((0xFF & patt_max)<<BIT_PATT_MAX) | ((0xFF & patt_init)<<BIT_PATT_INIT);
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_TEST_MODE) = (on<<BIT_TEST_GEN_ON) | (on << BIT_TEST_MODE_ON);
}

void DataProvEnOutput()
{
	*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS) |=  (1<<BIT_EN_OUTPUT);
}

void GetAux2Data(u32* data0, u32* data1, u32* data2)
{
	*data0 = (*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR + 4*REGR_DATAPROV_AUX2)) >> 0   & 0x3FF;
	*data1 = (*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR + 4*REGR_DATAPROV_AUX2)) >> 10  & 0x3FF;
	*data2 = (*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR + 4*REGR_DATAPROV_AUX2)) >> 20  & 0x3FF;
}

void GetAux3Data(u32* data0, u32* data1, u32* data2)
{
	*data0 = (*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR + 4*REGR_DATAPROV_AUX3)) >> 0   & 0x3FF;
	*data1 = (*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR + 4*REGR_DATAPROV_AUX3)) >> 10  & 0x3FF;
	*data2 = (*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR + 4*REGR_DATAPROV_AUX3)) >> 20  & 0x3FF;
}
