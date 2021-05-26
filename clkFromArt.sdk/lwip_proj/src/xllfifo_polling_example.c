/******************************************************************************
*
* Copyright (C) 2013 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/
/*****************************************************************************/
/**
 *
 * @file XLlFifo_polling_example.c
 * This file demonstrates how to use the Streaming fifo driver on the xilinx AXI
 * Streaming FIFO IP.The AXI4-Stream FIFO core allows memory mapped access to a
 * AXI-Stream interface. The core can be used to interface to AXI Streaming IPs
 * similar to the LogiCORE IP AXI Ethernet core, without having to use full DMA
 * solution.
 *
 * This is the polling example for the FIFO it assumes that at the
 * h/w level FIFO is connected in loopback.In these we write known amount of
 * data to the FIFO and Receive the data and compare with the data transmitted.
 *
 * Note: The TDEST Must be enabled in the H/W design inorder to
 * get correct RDR value.
 *
 * <pre>
 * MODIFICATION HISTORY:
 *
 * Ver   Who  Date     Changes
 * ----- ---- -------- -------------------------------------------------------
 * 3.00a adk 08/10/2013 initial release CR:727787
 *
 * </pre>
 *
 * ***************************************************************************
 */

/***************************** Include Files *********************************/
#include "xparameters.h"
#include "xil_exception.h"
#include "xstreamer.h"
#include "xil_cache.h"
#include "xllfifo.h"
#include "xstatus.h"

#define  SC_FIFO_DEVICE_ID XPAR_AXI_FIFO_MM_S_0_DEVICE_ID
#define  MAIN_FIFO_DEVICE_ID	XPAR_AXI_FIFO_MM_S_1_DEVICE_ID

XLlFifo FifoInstanceSC;
XLlFifo FifoInstanceMain;



int XLlFifoPollingInitSC()
{
	XLlFifo_Config *Config;
	int Status;
	int i;
	int Error;
	Status = XST_SUCCESS;

	/* Initialize the Device Configuration Interface driver */
	Config = XLlFfio_LookupConfig(SC_FIFO_DEVICE_ID);
	if (!Config) {
		xil_printf("No config found for %d\r\n", SC_FIFO_DEVICE_ID);
		return XST_FAILURE;
	}

	/*
	 * This is where the virtual address would be used, this example
	 * uses physical address.
	 */
	Status = XLlFifo_CfgInitialize(&FifoInstanceSC, Config, Config->BaseAddress);
	if (Status != XST_SUCCESS) {
		xil_printf("Initialization failed\n\r");
		return Status;
	}

	/* Check for the Reset value */
	Status = XLlFifo_Status(&FifoInstanceSC);
	XLlFifo_IntClear(&FifoInstanceSC,0xffffffff);
	Status = XLlFifo_Status(&FifoInstanceSC);
	if(Status != 0x0) {
		xil_printf("\n ERROR : Reset value of ISR0 : 0x%x\t"
			    "Expected : 0x0\n\r",
			    XLlFifo_Status(&FifoInstanceSC));
		return XST_FAILURE;
	}

	return Status;
}

int XLlFifoPollingInitMain()
{
	XLlFifo_Config *Config;
	int Status;
	int i;
	int Error;
	Status = XST_SUCCESS;

	/* Initialize the Device Configuration Interface driver */
	Config = XLlFfio_LookupConfig(MAIN_FIFO_DEVICE_ID);
	if (!Config) {
		xil_printf("No config found for %d\r\n", MAIN_FIFO_DEVICE_ID);
		return XST_FAILURE;
	}

	/*
	 * This is where the virtual address would be used, this example
	 * uses physical address.
	 */
	Status = XLlFifo_CfgInitialize(&FifoInstanceMain, Config, Config->BaseAddress);
	if (Status != XST_SUCCESS) {
		xil_printf("Initialization failed\n\r");
		return Status;
	}

	/* Check for the Reset value */
	Status = XLlFifo_Status(&FifoInstanceMain);
	XLlFifo_IntClear(&FifoInstanceMain,0xffffffff);
	Status = XLlFifo_Status(&FifoInstanceMain);
	if(Status != 0x0) {
		xil_printf("\n ERROR : Reset value of ISR0 : 0x%x\t"
			    "Expected : 0x0\n\r",
			    XLlFifo_Status(&FifoInstanceMain));
		return XST_FAILURE;
	}

	return Status;
}


void XLlFifoPollingInit()
{
	XLlFifoPollingInitSC();
	XLlFifoPollingInitMain();
}


int TxFIFOSendSC(u32 *data, u32 numOfWords)
{

	int i;
	//xil_printf("numOfWords=%d\r\n", numOfWords);


	XLlFifo_iWrite_Aligned(&FifoInstanceSC, data, numOfWords);
	/* Start Transmission by writing transmission length into the TLR */
	XLlFifo_iTxSetLen(&FifoInstanceSC, numOfWords*4);

//	/* Check for Transmission completion */
//	while( !(XLlFifo_IsTxDone(&FifoInstance)) )
//	{
//		xil_printf("xll_isr_reg=0x%08x\n\r", XLlFifo_ReadReg(FifoInstance.BaseAddress, XLLF_ISR_OFFSET));
//	}

	/* Transmission Complete */
	return XST_SUCCESS;
}

void TxFIFOSetTDR(u32 tdest)
{
	XLlFifo_WriteReg(FifoInstanceMain.BaseAddress, XLLF_TDR_OFFSET, tdest);
}

int TxFIFOSendMain(u32 *data, u32 numOfWords, u32 tdest)
{

	int i;
	xil_printf("numOfWords=%d\r\n", numOfWords);

	TxFIFOSetTDR(tdest);

	XLlFifo_iWrite_Aligned(&FifoInstanceMain, data, numOfWords);
	/* Start Transmission by writing transmission length into the TLR */
	XLlFifo_iTxSetLen(&FifoInstanceMain, numOfWords*4);

//	/* Check for Transmission completion */
//	while( !(XLlFifo_IsTxDone(&FifoInstance)) )
//	{
//		xil_printf("xll_isr_reg=0x%08x\n\r", XLlFifo_ReadReg(FifoInstance.BaseAddress, XLLF_ISR_OFFSET));
//	}

	/* Transmission Complete */
	return XST_SUCCESS;
}

u32 GetSC3FifoVacancy()
{
	return XLlFifo_iTxVacancy(&FifoInstanceSC);
}


int RxReceiveAll(u32* DestinationAddr, u32* ReceivedWords)
{
	u32 ReceivedWordsLocal=0;
	*ReceivedWords=0;
	do
	{
		RxReceive(DestinationAddr + (*ReceivedWords), &ReceivedWordsLocal);
		*ReceivedWords += ReceivedWordsLocal;
		xil_printf("%d %d\n\r", ReceivedWordsLocal, *ReceivedWords);
	}
	while(ReceivedWordsLocal !=0 );
}

/*****************************************************************************/
/*
*
* RxReceive routine.It will receive the data from the FIFO.
*
* @param	InstancePtr is a pointer to the instance of the
*		XLlFifo instance.
*
* @param	DestinationAddr is the address where to copy the received data.
*
* @return	-XST_SUCCESS to indicate success
*		-XST_FAILURE to indicate failure
*
* @note		None
*
******************************************************************************/
int RxReceive (u32* DestinationAddr, u32* ReceivedWords)
{

	int i=0, WORD_SIZE=4;
	int Status;
	u32 RxWord;
	static u32 ReceiveLength;

	*ReceivedWords = 0;

	if(XLlFifo_iRxOccupancy(&FifoInstanceSC))
	{
		xil_printf(" Receiving data ....\n\r");
		/* Read Recieve Length */
		ReceiveLength = (XLlFifo_iRxGetLen(&FifoInstanceSC))/WORD_SIZE;
		xil_printf("ReceiveLength(words)=%d\n\r", ReceiveLength);
		/* Start Receiving */
		//for ( i=0; i < ReceiveLength; i++){
			RxWord = 0;
			RxWord = XLlFifo_RxGetWord(&FifoInstanceSC);

			//if(XLlFifo_iRxOccupancy(&FifoInstance)){
			//	print("?");
			//	RxWord = XLlFifo_RxGetWord(&FifoInstance);
			//}
			*(DestinationAddr+i) = RxWord;
			xil_printf(" RxWord=%08x\n\r", RxWord);
		//}

		*ReceivedWords = 1;//i;

		Status = XLlFifo_IsRxDone(&FifoInstanceSC);
		if(Status != TRUE){
			xil_printf("Failing in receive complete ... \r\n");
			return XST_FAILURE;
		}
	}
	else
	{
		print("RX fifo empty\n\r");
	}

	return XST_SUCCESS;
}



