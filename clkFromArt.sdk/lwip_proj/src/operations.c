/*
 * operations.c
 *
 *  Created on: Apr 29, 2019
 *      Author: alx
 */

//#include "xscurve_adder.h"
//#include "xscurve_adder_hw.h"

#include "xscurve_adder36.h"
#include "xscurve_adder36_hw.h"

#include "common.h"
#include "pdmdata.h"

//XScurve_adder scurve_adder;
XScurve_adder36 scurve_adder36;
u32 n_d3_per_file = 1;

u32 integration = N_INTEGRATION;

void Set_n_d3_per_file(u32 param)
{
	n_d3_per_file = param;
}

void SetIntegration(u32 param)
{
	integration = param;
}

u32 GetIntegration()
{
	return integration;
}


void InitHLS_peripherals()
{
	int status;
//	status = XScurve_adder_Initialize(&scurve_adder, XPAR_SCURVE_ADDER_0_DEVICE_ID);
//	xil_printf("XScurve_adder_Initialize rets %d\n\r", status);
//	XScurve_adder_Set_N_ADDS(&scurve_adder, 16384);
//	XScurve_adder_EnableAutoRestart(&scurve_adder);
//	XScurve_adder_Start(&scurve_adder);

	//xil_printf("XScurve_adder36_Initialize rets %d\n\r", status);
	status = XScurve_adder36_Initialize(&scurve_adder36, XPAR_SCURVE_ADDER36_0_DEVICE_ID);
	//xil_printf("XScurve_adder36_Set_n_pixels\n\r");
	//XScurve_adder36_Set_n_pixels(&scurve_adder36, N_OF_PIXELS_TOTAL);
	xil_printf("XScurve_adder36_Set_N_ADDS\n\r");
	XScurve_adder36_Set_N_ADDS(&scurve_adder36, integration); //N_INTEGRATION
	xil_printf("XScurve_adder36_Set_K_TLAST\n\r");
	XScurve_adder36_Set_K_TLAST(&scurve_adder36, n_d3_per_file);//N_D3_PER_FILE
	xil_printf("XScurve_adder36_EnableAutoRestart\n\r");
	XScurve_adder36_EnableAutoRestart(&scurve_adder36);
	xil_printf("XScurve_adder36_Start\n\r");
	XScurve_adder36_Start(&scurve_adder36);
	xil_printf("XScurve_adder36_Initialize rets %d\n\r", status);
}

void ScurveAdderReInit()
{
	ResetScurveAdder();
	xil_printf("XScurve_adder36_Set_K_TLAST\n\r");
	InitHLS_peripherals();
}

void SA_set_TestMode(u32 mode)
{
	XScurve_adder36_Set_TEST_MODE(&scurve_adder36, mode);
}

void SA_restart()
{
	*(u32*)(scurve_adder36.Ctrl_bus_BaseAddress) = 0;
	XScurve_adder36_Start(&scurve_adder36);
}


void SendMapping()
{
	int i;
	char def_mapping[N_OF_PIXELS_PER_PMT];
	for(i=0; i<N_OF_PIXELS_PER_PMT; i++)
	{
		def_mapping[i]=i;
	}
	TxFIFOSendMain(def_mapping, N_OF_PIXELS_PER_PMT/4, FIFO_CH_MAPPING);
}

void ConfTrigger()
{
	u32 trg_conf_tst_word = 0x12345678;
	TxFIFOSendMain(&trg_conf_tst_word, 1, FIFO_CH_TRIG);

}
