/*
 * data_processing.c
 *
 *  Created on: Apr 22, 2019
 *      Author: alx
 */
#include "xaxidma.h"
#include "minieuso_pdmdata.h"
#include "pdmdata_hw.h"
#include "xparameters.h"
#include "xil_types.h"


XAxiDma dma_raw;
XAxiDma_Config* CfgPtr_raw;

uint8_t  DataDMA__RawPMT[N_FRAMES_DMA_RAW][N_OF_PIXELS_PER_PMT] __attribute__ ((aligned (64)));

void DmaReset()
{
	XAxiDma_Reset(&dma_raw);
}

void DmaStart(XAxiDma* pdma, UINTPTR addr, u32 length, u8 is_dma)
{
	u32 ret;
	if(is_dma) XAxiDma_IntrEnable(pdma, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DEVICE_TO_DMA);
	ret=XAxiDma_SimpleTransfer(pdma, addr, length, XAXIDMA_DEVICE_TO_DMA); // in bytes
	if(ret != XST_SUCCESS)
	{
		//DmaReset(pdma);
		xil_printf("XAxiDma_SimpleTransfer returns %d! Reset DMA\n\r", ret);
	}
}

void DmaStart1()
{
	DmaStart(&dma_raw, &DataDMA__RawPMT[0][0], sizeof(DataDMA__RawPMT), 0);
}


void DMA_init()
{
	int i;
	memset(&DataDMA__RawPMT[0][0], 0, sizeof(DataDMA__RawPMT));
	xil_printf("sizeof(DataDMA__RawPMT)=%d\n\r", sizeof(DataDMA__RawPMT));

	XStatus status = 0;
	XAxiDma_Config *CfgPtr;
	CfgPtr_raw = XAxiDma_LookupConfig(XPAR_AXI_DMA_0_DEVICE_ID);
	if (!CfgPtr_raw) {
		xil_printf("No config found for %d\r\n", XPAR_AXI_DMA_0_DEVICE_ID);
	}
	status = XAxiDma_CfgInitialize(&dma_raw, CfgPtr_raw);
	//xil_printf("dma_raw.RegBase=0x%08x\n\r", dma_raw.RegBase);
	if(status)	print("Error in XAxiDma_CfgInitialize dma_raw !\n\r");
}

void PrintData()
{
	int i,j=0;
	Xil_DCacheInvalidateRange((INTPTR)&DataDMA__RawPMT[0][0], sizeof(DataDMA__RawPMT));
	for(i=0;i<N_OF_PIXELS_PER_PMT;i++)
	{
		xil_printf("%d. %02x\n\r", i, DataDMA__RawPMT[j][i]);
	}
}
