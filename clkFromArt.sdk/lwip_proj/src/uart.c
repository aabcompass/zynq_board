/*
 * uart.c
 *
 *  Created on: Apr 22, 2019
 *      Author: alx
 */
#include "xil_types.h"
#include "xparameters.h"

void ProcessUartCommands(struct netif *netif, char c)
{
	int i, j, k, occupancy;//, cc_fifo_occupancy0, cc_fifo_occupancy1, cc_fifo_occupancy2;
	u16* reg_data;
	u16* p;
	static int num = 0;
	static int ec = 0;

	if(c == 'd')
	{
		DmaStart1();
	}
	else if(c == 'r')
	{
		DmaReset();
	}
	else if(c == 'p')
	{
		PrintData();
	}
	else if(c == 'T') // artix Gen mode
	{
		*(u32*)(XPAR_AXI_GPIO_0_BASEADDR) = 7;
	}
	else if(c == 't')
	{
		*(u32*)(XPAR_AXI_GPIO_0_BASEADDR) = 0;
	}
}
