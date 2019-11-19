/*
 * operations.c
 *
 *  Created on: Apr 29, 2019
 *      Author: alx
 */

#include "xscurve_adder.h"
#include "minieuso_pdmdata.h"

XScurve_adder scurve_adder;

void InitHLS_peripherals()
{
	int status;
	status = XScurve_adder_Initialize(&scurve_adder, XPAR_SCURVE_ADDER_0_DEVICE_ID);
	xil_printf("XScurve_adder_Initialize rets %d\n\r", status);
	XScurve_adder_Set_N_ADDS(&scurve_adder, 128);
	XScurve_adder_EnableAutoRestart(&scurve_adder);
	XScurve_adder_Start(&scurve_adder);
}
