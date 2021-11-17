/*
 * dma_handling.c
 *
 *  Created on: Feb 22, 2021
 *      Author: alx
 */
#include "xaxidma.h"
#include "xscugic.h"

#include "common.h"
#include "axis_flowctrl_d1.h"
#include "mmg.h"

int is_l1_started = 0;
int is_l3_started = 0;

u32 is_D3_received=0;

u32 is_file_processing = DO_FILE_PROCESSING;


XAxiDma dma_d1, dma_d3, dma_mps;
XAxiDma_Config* CfgPtr_d1;

SingleLiveFrameD3 singleLiveFrameD3 __attribute__ ((aligned (64)));

char* DMA_GetP()
{
	//return (char*)(&singleLiveFrameD3.data[0]);
	return (char*)(&singleLiveFrameD3);
}

void DMA_init()
{
	XStatus status = 0;
	XAxiDma_Config *CfgPtr;
	CfgPtr_d1 = XAxiDma_LookupConfig(XPAR_AXI_DMA_0_DEVICE_ID);
	if (!CfgPtr_d1) {
		xil_printf("No config found for %d\r\n", XPAR_AXI_DMA_0_DEVICE_ID);
	}
	status = XAxiDma_CfgInitialize(&dma_d1, CfgPtr_d1);

	CfgPtr = XAxiDma_LookupConfig(XPAR_AXI_DMA_SC36_DEVICE_ID);
	status = XAxiDma_CfgInitialize(&dma_d3, CfgPtr);
	if(status)	print("Error in XAxiDma_CfgInitialize dma_l2!\n\r");

	CfgPtr = XAxiDma_LookupConfig(XPAR_AXI_DMA_MPS_BASEADDR);
	status = XAxiDma_CfgInitialize(&dma_mps, CfgPtr);
	if(status)	print("Error in XAxiDma_CfgInitialize dma_mps!\n\r");
}

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

void DmaStart(XAxiDma* pdma, UINTPTR addr, u32 length, u8 is_intr)
{
	u32 ret;
	if(is_intr) XAxiDma_IntrEnable(pdma, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DEVICE_TO_DMA);
	ret=XAxiDma_SimpleTransfer(pdma, addr, length, XAXIDMA_DEVICE_TO_DMA); // in bytes
	if(ret != XST_SUCCESS)
	{
		//DmaReset(pdma);
		xil_printf("XAxiDma_SimpleTransfer returns %d! Reset DMA\n\r", ret);
	}
}

static void start_dma_l1()
{
	char* p;
	p = (char*)MmgAlloc(DATA_TYPE_L1);
	if(p) {
		DmaStart(&dma_d1, (UINTPTR)p, 1 * N_OF_PIXELS_TOTAL * N_FRAMES_DMA_D1, 0);
	}
	else {
		print("Not enough space for the next D1 DMA buffer\n\r");
	}
}

void start_dma_l3(u32 n_frames)
{
	char* p;
	if(is_file_processing == DO_FILE_PROCESSING)
		p = (char*)MmgAlloc(DATA_TYPE_L3);
	else
		//p = (char*)&singleLiveFrameD3.data[0];
		p = (char*)&singleLiveFrameD3;

	if(p) {
		xil_printf("DmaStart: p=0x%08x, n=%d\n\r", p, 4 * N_OF_PIXELS_TOTAL * n_frames);
		DmaStart(&dma_d3, (UINTPTR)p, 4 * N_OF_PIXELS_TOTAL * n_frames, 1); //was N_FRAMES_DMA_D3
	}
	else {
		print("Not enough space for the next D3 DMA buffer\n\r");
	}
}

void InvalidateRange(u32 data_type)
{
	if(is_file_processing == DO_FILE_PROCESSING) {
		if(data_type == DATA_TYPE_L1)
			Xil_DCacheInvalidateRange(MmgGetP(DATA_TYPE_L1), N_OF_PIXELS_TOTAL*N_OF_FRAMES_D1_V0);
		else if(data_type == DATA_TYPE_L3)
			Xil_DCacheInvalidateRange(MmgGetP(DATA_TYPE_L3), 4*N_OF_PIXELS_TOTAL*N_D3_PER_FILE);
		else
			print("InvalidateRange: No such data_type\n\r");
	}
	else {
		if(data_type == DATA_TYPE_L3) {
			//Xil_DCacheInvalidateRange((INTPTR)&singleLiveFrameD3.data[0], 4*N_OF_PIXELS_TOTAL);
			Xil_DCacheInvalidateRange((INTPTR)&singleLiveFrameD3.data[0], 4*N_OF_PIXELS_TOTAL);
		}
		else {
			print("InvalidateRange: can't invalidate D1 for Live mode\n\r");
		}
	}
}

void DoFileProcessing(u32 param)
{
	is_file_processing = param;
}



void RxIntrHandler_L1(XAxiDma *AxiDmaInst)
{
	u32 n_glob_cycles = Get_n_glob_cycles();
	InvalidateRange(DATA_TYPE_L1);
	if(is_file_processing == DO_FILE_PROCESSING)
		MmgFinish(DATA_TYPE_L1, GetTrigNGTU_L1(), GetUnixTimestamp_L1(), GetTrigType_L1(), n_glob_cycles);
	if(is_l1_started == 1) {
		start_dma_l1();
	}
	D1_release();
	xil_printf("y(%d)", n_glob_cycles);
	return;
}

static void RxIntrHandler_dma_d3(void *Callback)
{
	//print("Rx:");
	u32 IrqStatus;
	//int TimeOut;
	XAxiDma *AxiDmaInst = (XAxiDma *)Callback;

	is_D3_received = 1;

	/* Read pending interrupts */
	IrqStatus = XAxiDma_IntrGetIrq(AxiDmaInst, XAXIDMA_DEVICE_TO_DMA);

	/* Acknowledge pending interrupts */
	XAxiDma_IntrAckIrq(AxiDmaInst, IrqStatus, XAXIDMA_DEVICE_TO_DMA);

	print("Z");

	if ((IrqStatus & XAXIDMA_IRQ_ERROR_MASK) || (IrqStatus & XAXIDMA_IRQ_IOC_MASK)) //error because DMA is ended in advance (?)
	{
		InvalidateRange(DATA_TYPE_L3);
		if(is_file_processing == DO_FILE_PROCESSING)
			MmgFinish(DATA_TYPE_L3, GetNGTU(),  GetUnixTime(), TRIG_PERIODIC, Get_n_glob_cycles());
		if(is_l3_started) { // Restart DMA D3
			start_dma_l3(N_FRAMES_DMA_D3);
		}
		ResetTriggerService_D1(); //?
		print("z");
		return;
	}
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

void L1_trigger_service()
{
	if(IsD1Triggered())
		RxIntrHandler_L1(&dma_d1);
}


void L1Start()
{
	start_dma_l1();
	is_l1_started = 1;
}

void L1Stop()
{
	is_l1_started = 0;
	XAxiDma_Reset(&dma_d1);
	//TODO// Abandon current transfer. What if it is in progress?
}

void L3Start(u32 is_infinite, u32 n_frames) //N_FRAMES_DMA_D3
{
	start_dma_l3(n_frames);
	is_D3_received = 0;
	is_l3_started = is_infinite;
}

u32 Is_D3_received()
{
	return is_D3_received;
}

void L3Stop()
{
	is_l3_started = 0;
	XAxiDma_Reset(&dma_d3);
	//TODO// Abandon current transfer. What if it is in progress?
}

void PrintDataSizes()
{
	xil_printf("sizeof(Z_DATA_TYPE_SCI_L1_V4)=0x%08x\n\r", sizeof(Z_DATA_TYPE_SCI_L1_V5));
	xil_printf("sizeof(Z_DATA_TYPE_SCI_L3_V3)=0x%08x\n\r", sizeof(Z_DATA_TYPE_SCI_L3_V3));
	xil_printf("sizeof(Z_DATA_TYPE_SCI_MPS_V1)=0x%08x\n\r", sizeof(Z_DATA_TYPE_SCI_MPS_V1));
	xil_printf("sizeof(MainBuffer)=0x%08x\n\r", sizeof(MainBuffer));
}

void IsDMAsBusy()
{
	xil_printf("XAxiDma_Busy(&dma_d1)=0x%08x\n\r", XAxiDma_Busy(&dma_d1, XAXIDMA_DEVICE_TO_DMA));
	xil_printf("XAxiDma_Busy(&dma_d3)=0x%08x\n\r", XAxiDma_Busy(&dma_d3, XAXIDMA_DEVICE_TO_DMA));
	xil_printf("XAxiDma_Busy(&dma_mps)=0x%08x\n\r", XAxiDma_Busy(&dma_mps, XAXIDMA_DEVICE_TO_DMA));
}

u32 GetDMAStatus(XAxiDma *InstancePtr, int Direction)
{
	return XAxiDma_ReadReg(InstancePtr->RegBase +
					(XAXIDMA_RX_OFFSET * Direction),
					XAXIDMA_SR_OFFSET);
}

void DMAStatus()
{
	xil_printf("GetDMAStatus(&dma_d1)=0x%08x\n\r", GetDMAStatus(&dma_d1, XAXIDMA_DEVICE_TO_DMA));
	xil_printf("GetDMAStatus(&dma_d3)=0x%08x\n\r", GetDMAStatus(&dma_d3, XAXIDMA_DEVICE_TO_DMA));
	xil_printf("GetDMAStatus(&dma_mps)=0x%08x\n\r", GetDMAStatus(&dma_mps, XAXIDMA_DEVICE_TO_DMA));
}
