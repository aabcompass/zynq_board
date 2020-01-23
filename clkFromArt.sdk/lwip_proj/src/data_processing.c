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
#include "xscugic.h"


XAxiDma dma_d1, dma_d3;//, data_tst_l1;//, dma_tst_l2;
XAxiDma_Config* CfgPtr_d1;

#define N_TRIG_BUFFERS_DMA_D3	1


//uint8_t  DataDMA_D1[N_ALT_BUFFERS][N_TRIG_BUFFERS_DMA_D1][N_FRAMES_DMA_D1][N_OF_PIXEL_PER_PDM] __attribute__ ((aligned (64)));

uint32_t  DataDMA_D3[N_ALT_BUFFERS][N_TRIG_BUFFERS_DMA_D3][N_FRAMES_DMA_D3][N_OF_PIXEL_PER_PDM] __attribute__ ((aligned (64)));

DATA_TYPE_SCI_ALLTRG_V1 zynqPacket;

volatile u32 dma_intr_counter_d1 = 0, dma_intr_counter_d2 = 0, dma_intr_counter_d3 = 0;
volatile u32 prev_alt_buffer = 0, current_alt_buffer = 0;


void DmaReset(XAxiDma* pdma)
{
	XAxiDma_Reset(pdma);
	while(1)
	{
		if(XAxiDma_ResetIsDone(pdma))
			return;
		else
			print("*");
	}
}

void DmaResetN(int n) // 1 - D1, 2 - D2, 3 - D3
{
	if(n == 1)
		XAxiDma_Reset(&dma_d1);
//	else if(n == 2)
//		XAxiDma_Reset(&dma_d2);
	else if(n == 3)
		XAxiDma_Reset(&dma_d3);
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



void DMA_init()
{
	int i;
//	memset(DataDMA_D1, 0, sizeof(DataDMA_D1));
	//memset(DataDMA_D2, 0, sizeof(DataDMA_D2));
	memset(DataDMA_D3, 0, sizeof(DataDMA_D3));
//	xil_printf("sizeof(DataDMA_D1)=%d\n\r", sizeof(DataDMA_D1));
	//xil_printf("sizeof(DataDMA_D2)=%d\n\r", sizeof(DataDMA_D2));
	xil_printf("sizeof(DataDMA_D3)=%d\n\r", sizeof(DataDMA_D3));




	XStatus status = 0;
	XAxiDma_Config *CfgPtr;
//	CfgPtr_d1 = XAxiDma_LookupConfig(XPAR_AXI_DMA_0_DEVICE_ID);
//	if (!CfgPtr_d1) {
//		xil_printf("No config found for %d\r\n", XPAR_AXI_DMA_0_DEVICE_ID);
//	}
//	status = XAxiDma_CfgInitialize(&dma_d1, CfgPtr_d1);
//	//xil_printf("dma_raw.RegBase=0x%08x\n\r", dma_raw.RegBase);
//	if(status)	print("Error in XAxiDma_CfgInitialize dma_raw !\n\r");
//	DmaStartN(1, 0);


	CfgPtr = XAxiDma_LookupConfig(XPAR_AXI_DMA_SC36_DEVICE_ID);
	status = XAxiDma_CfgInitialize(&dma_d3, CfgPtr);
	if(status)	print("Error in XAxiDma_CfgInitialize dma_l2!\n\r");
	DmaStartN(3, 0);



}


void PrintData_raw()
{
//	int i,j=0;
//	Xil_DCacheInvalidateRange((INTPTR)&DataDMA_D1[0][0][0][0], sizeof(DataDMA_D1));
//	for(j=0;j<N_FRAMES_DMA_D1;j++)
//	{
//		xil_printf("%d: ", j);
//		for(i=0;i<N_OF_PIXELS_PER_PMT;i++)
//		{
//			xil_printf("%02x ", DataDMA__RawPMT[j][i]);
//		}
//		print("\n\r");
//	}
}

void PrintData_scv(int num)
{
	int i,j=0;
	Xil_DCacheInvalidateRange((INTPTR)&DataDMA_D3[0][0][0][0], sizeof(DataDMA_D3));
	for(j=0;j<num;j++)
	{
		xil_printf("%d: ", j);
		for(i=0;i<N_OF_PIXELS_PER_PMT;i++)
		{
			xil_printf("%08x ", DataDMA_D3[0][0][j][i]);
		}
		print("\n\r");
	}
}

void DmaStartN(int n_dma, int n_trig_buffer) //1 - D1,  3 - scv
{
	//if(n_dma == 1)
//		DmaStart(&dma_d1, (UINTPTR)&DataDMA_D1[current_alt_buffer][n_trig_buffer][0][0], 1 * N_OF_PIXEL_PER_PDM * N_FRAMES_DMA_D1, 0);
//	else if(n_dma == 2)
//		DmaStart(&dma_d2, (UINTPTR)&DataDMA_D2[n_trig_buffer][0][0], 2 * N_OF_PIXEL_PER_PDM * N_FRAMES_DMA_D2, 1);
//	else if(n_dma == 3)
		DmaStart(&dma_d3, (UINTPTR)&DataDMA_D3[current_alt_buffer][n_trig_buffer][0][0], 4 * N_OF_PIXEL_PER_PDM * N_FRAMES_DMA_D3, 1);
}


static void RxIntrHandler_dma_d3(void *Callback)
{
	//print("Rx:");
	u32 IrqStatus;
	//int TimeOut;
	XAxiDma *AxiDmaInst = (XAxiDma *)Callback;

	/* Read pending interrupts */
	IrqStatus = XAxiDma_IntrGetIrq(AxiDmaInst, XAXIDMA_DEVICE_TO_DMA);

	/* Acknowledge pending interrupts */
	XAxiDma_IntrAckIrq(AxiDmaInst, IrqStatus, XAXIDMA_DEVICE_TO_DMA);

	if ((IrqStatus & XAXIDMA_IRQ_ERROR_MASK) || (IrqStatus & XAXIDMA_IRQ_IOC_MASK))
	{
		dma_intr_counter_d3++;

		//triggerInfoD3[current_alt_buffer][0].is_sent = 0;
		//triggerInfoD3[current_alt_buffer][0].n_gtu = GetNGTU();
		//triggerInfoD3[current_alt_buffer][0].unix_timestamp = GetUnixTime();
		//triggerInfoD3[current_alt_buffer][0].trigger_type = TRIG_PERIODIC;
		// change current_alt_buffer & prev_alt_buffer
		//prev_alt_buffer = current_alt_buffer;
		current_alt_buffer = dma_intr_counter_d3%2;
		// Change DMA D1 pointer to zero
		//DmaReset(&dma_scv);
		//DmaStartN(1, 0);
		// Restart DMA D3
		DmaReset(AxiDmaInst);
		DmaStartN(3, 0);
		//current_trigbuf_d1 = 0; trig_counter__l2 = 0;
		//ClearTriggerInfo(current_alt_buffer);
		//ResetTriggerService_D1(); // added in v1.8.1
		//ResetTriggerService_D2();
		print("z");
		//buffer_D3_changed = 1;
		//buffer_D3_changed2 = 1;
		return;
	}
}


void GetPtrForLive(char**  p)
{
	Xil_DCacheInvalidateRange((INTPTR)&DataDMA_D3[!current_alt_buffer][0][0][0],  4 * N_OF_PIXEL_PER_PDM * N_FRAMES_DMA_D3);
	*p = (char*)&DataDMA_D3[!current_alt_buffer][0][0][0], 4 * N_OF_PIXEL_PER_PDM * N_FRAMES_DMA_D3;
}

void SetupDMAIntrSystem(XScuGic* pIntc)
{
	int Result;


	XScuGic_SetPriorityTriggerType(pIntc, XPAR_FABRIC_AXI_DMA_SC36_S2MM_INTROUT_INTR,
					0x98, 0x3);

	Result = XScuGic_Connect(pIntc, XPAR_FABRIC_AXI_DMA_SC36_S2MM_INTROUT_INTR,
				 (Xil_ExceptionHandler)RxIntrHandler_dma_d3, &dma_d3);
	if (Result != XST_SUCCESS) {
		print("Error XScuGic_Connect\n\r");
	}

	XScuGic_Enable(pIntc, XPAR_FABRIC_AXI_DMA_SC36_S2MM_INTROUT_INTR);


	Xil_ExceptionInit();

	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
			 (Xil_ExceptionHandler)XScuGic_InterruptHandler, pIntc);

	/* Enable non-critical exceptions */
	Xil_ExceptionEnable();

	return;

}
