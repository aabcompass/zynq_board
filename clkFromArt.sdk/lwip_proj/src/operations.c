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


#include "minieuso_pdmdata.h"

//XScurve_adder scurve_adder;
XScurve_adder36 scurve_adder36;

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
	xil_printf("XScurve_adder36_Set_N_ADDS\n\r");
	XScurve_adder36_Set_N_ADDS(&scurve_adder36, 16384);
	xil_printf("XScurve_adder36_EnableAutoRestart\n\r");
	XScurve_adder36_EnableAutoRestart(&scurve_adder36);
	xil_printf("XScurve_adder36_Start\n\r");
	XScurve_adder36_Start(&scurve_adder36);
	xil_printf("XScurve_adder36_Initialize rets %d\n\r", status);
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
