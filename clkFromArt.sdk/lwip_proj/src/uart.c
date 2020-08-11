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
#include "ftp_server.h"

char tmp_array[10000000];

void ProcessUartCommands(struct netif *netif, char c)
{
	int i, j, k, occupancy;//, cc_fifo_occupancy0, cc_fifo_occupancy1, cc_fifo_occupancy2;
	u16* reg_data;
	u16* p;
	static int num = 8;
	static int ec = 0;


	if(c == 'd')
	{
		//DmaStart1();
		 ResetScurveAdder();
		 InitHLS_peripherals();
	}
	else if(c == 's')
	{
		//DmaStart1();
		xil_printf("ART slv_reg=0x%08x\n\r", *(u32*)(XPAR_AXI_ARTIX_CONF_V1_0_0_BASEADDR));
	}
	else if(c == 'r')
	{
		//SA_restart();
		ResetDataConverter();
	}
	else if(c == 'p')
	{
		PrintData_raw();
	}
	else if(c == 'P')
	{
		PrintData_scv(num);
	}
	else if(c == '+') // artix Gen mode
	{
		num ++;
		xil_printf("num=%d\n\r", num);
	}
	else if(c == '-') // artix Gen mode
	{
		num --;
		xil_printf("num=%d\n\r", num);
	}
	else if(c == 'T') // artix Gen mode
	{
		//SA_set_TestMode(1);
		SetArtixTestMode(1);
	}
	else if(c == 't')
	{
		//SA_set_TestMode(0);
		SetArtixTestMode(0);
	}
	else if(c == 'Q') // artix Gen mode
	{
		//SA_set_TestMode(1);
		SetArtixTestMode2(1);
	}
	else if(c == 'q')
	{
		//SA_set_TestMode(0);
		SetArtixTestMode2(0);
	}
	else if(c == 'X') // artix Gen mode
	{
		StartDataProviderForLive();
//		*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_N_FRAMES) = 16384;
//		*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS) |= (1<<BIT_RUN) | (1<<BIT_START_SIG);
//		*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS) &= ~(1<<BIT_START_SIG);
//		*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS2) |= (1<<BIT_RUN_DATACONV) | (1<<BIT_INFINITE);

		//*(u32*)(XPAR_GPIO_CTRL_BASEADDR) = 0xFFFFFFFF;
	}
	else if(c == 'x')
	{
		StopDataProviderForLive();
		*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS2) = 0;
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
		*(u32*)(XPAR_AXI_GPIO_0_BASEADDR) = num;
		LoadArtix(FILENAME_ARTIX_BITSTREAM_1_BOARD);
	}
	else if(c == 'L')
	{
		LoadArtix(FILENAME_ARTIX_PARAMETERS);
	}
	else if(c == 'm')
	{
		ArtixLatch(0);
	}
	else if(c == 'M')
	{
		ArtixLatch(1);
	}
	else if(c == 'Y')
	{
		SetArtixTransmitDelay(num);
	}
	else if(c == 'y')
	{
		SetArtixFracDelay(num);
	}
	else if(c == 'g')
	{
		*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS2) |= (1<<BIT_GTU_1US);
	}
	else if(c == 'G')
	{
		*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS2) &= ~(1<<BIT_GTU_1US);
	}
	else if(c == 'f')
	{
		CreateFile("testfile.bin", tmp_array, 10000000, 0, file_scidata);
	}

}
