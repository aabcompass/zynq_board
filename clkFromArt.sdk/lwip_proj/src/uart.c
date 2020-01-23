/*
 * uart.c
 *
 *  Created on: Apr 22, 2019
 *      Author: alx
 */
#include "xil_types.h"
#include "xparameters.h"
#include "common.h"
#include "data_provider.h"

void ProcessUartCommands(struct netif *netif, char c)
{
	int i, j, k, occupancy;//, cc_fifo_occupancy0, cc_fifo_occupancy1, cc_fifo_occupancy2;
	u16* reg_data;
	u16* p;
	static int num = 1;
	static int ec = 0;

	if(c == 'd')
	{
		//DmaStart1();
	}
	else if(c == 'r')
	{
		DmaReset();
	}
	else if(c == 'p')
	{
		PrintData_raw();
	}
	else if(c == 'P')
	{
		PrintData_scv(num);
	}
	else if(c == 'T') // artix Gen mode
	{
		*(u32*)(XPAR_AXI_GPIO_0_BASEADDR) = 7;
	}
	else if(c == 't')
	{
		*(u32*)(XPAR_AXI_GPIO_0_BASEADDR) = 0;
	}
	else if(c == 'X') // artix Gen mode
	{
		*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS) |= (1<<BIT_RUN) | (1<<BIT_START_SIG);
		*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS2) |= (1<<BIT_RUN_DATACONV) | (1<<BIT_INFINITE);
		//*(u32*)(XPAR_GPIO_CTRL_BASEADDR) = 0xFFFFFFFF;
	}
	else if(c == 'x')
	{
		*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS2) &= ~(1<<BIT_RUN);
		//*(u32*)(XPAR_GPIO_CTRL_BASEADDR) = 0;
	}
	else if(c == '+')
	{
		num++;
		xil_printf("num=%d\n\r", num);
	}
	else if(c == '-')
	{
		num--;
		xil_printf("num=%d\n\r", num);
	}
	else if(c == 'l')
	{
		LoadArtix(FILENAME_ARTIX_BITSTREAM_1_BOARD);
	}
	else if(c == 'L')
	{
//		LoadArtix(FILENAME_ARTIX_PARAMETERS);
//		ArtixLatch);
	}
	else if(c == 'g')
	{
		*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS2) |= (1<<BIT_GTU_1US);
	}
	else if(c == 'G')
	{
		*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS2) &= ~(1<<BIT_GTU_1US);
	}

}
