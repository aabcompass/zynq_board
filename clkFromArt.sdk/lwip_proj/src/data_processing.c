/*
 * data_processing.c
 *
 *  Created on: Apr 22, 2019
 *      Author: alx
 */
#include "xaxidma.h"
#include "pdmdata.h"
#include "pdmdata_hw.h"
#include "xparameters.h"
#include "xil_types.h"
#include "xscugic.h"
#include "axis_flowctrl_d1.h"
#include "own_data_types.h"
#include "data_provider.h"
#include "stdio.h"
#include "ftp_server.h"

#define SCI_DATA_ARRAY_SIZE 50

XAxiDma dma_d1, dma_d3;//, data_tst_l1;//, dma_tst_l2;
XAxiDma_Config* CfgPtr_d1;

#define N_TRIG_BUFFERS_DMA_D3	1


uint8_t  DataDMA_D1[N_ALT_BUFFERS][N_TRIG_BUFFERS_DMA_D1][N_FRAMES_DMA_D1][N_OF_PIXEL_PER_PDM] __attribute__ ((aligned (64)));

uint32_t  DataDMA_D3[N_ALT_BUFFERS][N_TRIG_BUFFERS_DMA_D3][N_FRAMES_DMA_D3][N_OF_PIXEL_PER_PDM] __attribute__ ((aligned (64)));

DATA_TYPE_SCI_ALLTRG_V2 zynqPacket;

volatile u32 dma_intr_counter_d1 = 0, dma_intr_counter_d2 = 0, dma_intr_counter_d3 = 0;
volatile u32 prev_alt_buffer = 0, current_alt_buffer = 0;
volatile u32 trig_counter__l1 = 0;
volatile u32 buffer_D3_changed, buffer_D3_changed2;

volatile u32 current_trigbuf_d1  = 0;

TriggerInfo triggerInfoD1[2][MAX_TRIGGERS_PER_CYCLE];
TriggerInfo triggerInfoD2[2][MAX_TRIGGERS_PER_CYCLE];
TriggerInfo triggerInfoD3[2][1];

extern InstrumentState instrumentState;

char hvps_log_file_ftp[sizeof(Z_DATA_TYPE_HVPS_LOG_V1)];


static enum  {
	datapath_idle_state = 10,
	datapath_wait4trigger_state=100
	} datapath_sm_state = datapath_idle_state;

static enum  {
	stop_sm_idle = 10,
	wait4data_provider_stop=100,
	wait4interruptD3=110,
	stop_sm_stopping=115,
	stop_sm_stopped=120
	} stop_sm_state = stop_sm_idle;


DATA_TYPE_SCI_ALLTRG_RECORD* sci_data;


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
	CfgPtr_d1 = XAxiDma_LookupConfig(XPAR_AXI_DMA_0_DEVICE_ID);
	if (!CfgPtr_d1) {
		xil_printf("No config found for %d\r\n", XPAR_AXI_DMA_0_DEVICE_ID);
	}
	status = XAxiDma_CfgInitialize(&dma_d1, CfgPtr_d1);
	//xil_printf("dma_raw.RegBase=0x%08x\n\r", dma_raw.RegBase);
	if(status)	print("Error in XAxiDma_CfgInitialize dma_raw !\n\r");
	DmaStartN(1, 0);


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
	if(n_dma == 1)
		DmaStart(&dma_d1, (UINTPTR)&DataDMA_D1[current_alt_buffer][n_trig_buffer][0][0], 1 * N_OF_PIXEL_PER_PDM * N_FRAMES_DMA_D1, 0);
//	else if(n_dma == 2)
//		DmaStart(&dma_d2, (UINTPTR)&DataDMA_D2[n_trig_buffer][0][0], 2 * N_OF_PIXEL_PER_PDM * N_FRAMES_DMA_D2, 1);
	else if(n_dma == 3)
		DmaStart(&dma_d3, (UINTPTR)&DataDMA_D3[current_alt_buffer][n_trig_buffer][0][0], 4 * N_OF_PIXEL_PER_PDM * N_FRAMES_DMA_D3, 1);
}

void RxIntrHandler_L1(XAxiDma *AxiDmaInst)
{
	u32 IrqStatus;
	int i;
	u32 cathode_data;

	if(current_trigbuf_d1 < Get_N1())
	{
		triggerInfoD1[current_alt_buffer][current_trigbuf_d1].is_sent = 0;
		triggerInfoD1[current_alt_buffer][current_trigbuf_d1].is_dma_error = IsD1DMA_error();
		triggerInfoD1[current_alt_buffer][current_trigbuf_d1].n_gtu = GetTrigNGTU_L1();
		triggerInfoD1[current_alt_buffer][current_trigbuf_d1].trigger_type = GetTrigType_L1();
		triggerInfoD1[current_alt_buffer][current_trigbuf_d1].unix_timestamp = GetUnixTimestamp_L1();
		triggerInfoD1[current_alt_buffer][current_trigbuf_d1].n_intr = dma_intr_counter_d1;
		//cathode_data = GetCathodeLevels(); -- no auto switching in SPB-2
		//xil_printf("(%08x)",cathode_data);
		//for(i=0;i<NUM_OF_HV;i++)
		//{
		//	triggerInfoD1[current_alt_buffer][current_trigbuf_d1].hv_data[i] = (cathode_data >> 2*i)  & 0x3;
			//triggerInfoD1[current_alt_buffer][current_trigbuf_d1].hv_data[i] |=
		//}
		// Change current trigger buffer to the next one

	}
	current_trigbuf_d1++;

	xil_printf("=%d", current_trigbuf_d1);

	trig_counter__l1++;

	dma_intr_counter_d1++;

	D1_release();

	DmaStartN(1, current_trigbuf_d1);

	return;
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
		buffer_D3_changed = 1;
		buffer_D3_changed2 = 1;
		return;
	}
}

void PrintTriggerInfo()
{
	int i, j;
	print("Trigger info L1:\n\r");
	for(i=0;i<2;i++)
	{
		for(j=0;j<4;j++)
		{
			xil_printf("%d.%d\t%x\t%08d\t%08d\t%08d\t%06d\t%d\t%s\n\r",
					i,
					j,
					triggerInfoD1[i][j].trigger_type,
					triggerInfoD1[i][j].n_gtu,
					triggerInfoD1[i][j].unix_timestamp,
					triggerInfoD1[i][j].is_dma_error,
					triggerInfoD1[i][j].n_intr,
					triggerInfoD1[i][j].alt_trig_buffer,
					triggerInfoD1[i][j].is_sent ? "sent" : "pending");
		}
	}
	print("Trigger info L2:\n\r");
	for(i=0;i<2;i++)
	{
		for(j=0;j<4;j++)
		{
			xil_printf("%d.%d\t%x\t%08d\t%08d\t%06d\t%d\t%s\n\r",
					i,
					j,
					triggerInfoD2[i][j].trigger_type,
					triggerInfoD2[i][j].n_gtu,
					triggerInfoD2[i][j].unix_timestamp,
					triggerInfoD2[i][j].n_intr,
					triggerInfoD2[i][j].alt_trig_buffer,
					triggerInfoD2[i][j].is_sent ? "sent" : "pending");
		}
	}
	print("Trigger info L3:\n\r");
	for(i=0;i<2;i++)
	{
		for(j=0;j<1;j++)
		{
			xil_printf("%d.%d\t%x\t%08d\t%08d\t%06d\t%d\t%s\n\r",
					i,
					j,
					triggerInfoD3[i][j].trigger_type,
					triggerInfoD3[i][j].n_gtu,
					triggerInfoD3[i][j].unix_timestamp,
					triggerInfoD3[i][j].n_intr,
					triggerInfoD3[i][j].alt_trig_buffer,
					triggerInfoD3[i][j].is_sent ? "sent" : "pending");
		}
	}
	xil_printf("Next current_alt_buffer=%d\n\r", current_alt_buffer);
	xil_printf("XAxiDma_Busy returns %d\n\r", XAxiDma_Busy(&dma_d1, XAXIDMA_DEVICE_TO_DMA));
}

void ClearTriggerInfo(int half)
{
	int j;
	for(j=0;j<MAX_TRIGGERS_PER_CYCLE;j++)
	{
		triggerInfoD1[half][j].trigger_type = 0;
		triggerInfoD1[half][j].is_sent = 0;
		triggerInfoD2[half][j].trigger_type = 0;
		triggerInfoD2[half][j].is_sent = 0;
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


void L1_trigger_service()
{
	if(IsD1Triggered())
		RxIntrHandler_L1(&dma_d1);
}

int IsBufferD3Changed()
{
	if(buffer_D3_changed)
	{
		buffer_D3_changed = 0;
		return 1;
	}
	else
	{
		return 0;
	}
}

int IsBufferD3Changed2()
{
	if(buffer_D3_changed2)
	{
		buffer_D3_changed2 = 0;
		return 1;
	}
	else
	{
		return 0;
	}
}

// returns 1 is all zeros, 0 otherwise
u32 CheckZeros(u8* p, u32 len_bytes)
{
	int i; u32 ret;
	for(i=0;i<len_bytes;i++)
		ret |= !(p[i] == 0);
	return !ret;
}


void memcpy_invalidate(void* p_dst, void* p_src, u32 len_bytes)
{
	Xil_DCacheInvalidateRange(p_src, len_bytes);
	memcpy(p_dst, p_src, len_bytes);
}


void CopyEventData_trig()
{
	int i;
	u32 gtu_addr, gtu_addr_cross, gtu_n_cross_l, gtu_n_cross_r;
	u32 alt_trig_buffer;
	print("c");
	//xil_printf("CopyEventData_trig: prev_alt_buffer=%d", prev_alt_buffer);
	//copy D1
	for(i=0;i<Get_N1();i++)
	{
		// copy the metadata to zynqPacket
		zynqPacket.level1_data[i].payload.trig_type = triggerInfoD1[prev_alt_buffer][i].trigger_type;
		zynqPacket.level1_data[i].payload.ts.n_gtu = triggerInfoD1[prev_alt_buffer][i].n_gtu;
		zynqPacket.level1_data[i].payload.ts.unix_time = triggerInfoD1[prev_alt_buffer][i].unix_timestamp;
		//memcpy(&zynqPacket.level1_data[i].payload.cathode_status[0],  &triggerInfoD1[prev_alt_buffer][i].hv_data[0], NUM_OF_HV);

		/*
		 * If the data around trigger is not edge crossed by DMA page. In this case one pass copy is used.
		 */

		memcpy_invalidate(&zynqPacket.level1_data[i].payload.frames[0].raw_data[0],
				&DataDMA_D1[prev_alt_buffer%2][i][0][0],
				N_OF_PIXEL_PER_PDM * N_OF_FRAMES_D1_V0);

		if(CheckZeros(&DataDMA_D1[prev_alt_buffer%2][i][0][0], N_OF_PIXEL_PER_PDM * N_OF_FRAMES_D1_V0))
			print("All zeros!\n\r");


		//xil_printf("--- i=%d gtu_addr=%d prev_alt_buffer=%d\n\r", i, gtu_addr, prev_alt_buffer);
		// Mark the trigger as copied (sent)
		triggerInfoD1[prev_alt_buffer][i].is_sent = 1;
	}
//	//copy D3
//	for(i=0;i<Get_N3();i++)
//	{
//		zynqPacket.level3_data[i].payload.trig_type = triggerInfoD3[prev_alt_buffer][i].trigger_type;
//		zynqPacket.level3_data[i].payload.ts.n_gtu = triggerInfoD3[prev_alt_buffer][i].n_gtu;
//		zynqPacket.level3_data[i].payload.ts.unix_time = triggerInfoD3[prev_alt_buffer][i].unix_timestamp;
//		memcpy(&zynqPacket.level3_data[i].payload.cathode_status[0],  &triggerInfoD3[prev_alt_buffer][i].hv_data[0], NUM_OF_HV);
//		memcpy_invalidate(&zynqPacket.level3_data[i].payload.int32_data[0][0],
//				&DataDMA_D3[prev_alt_buffer%2][0][0],
//				N_OF_PIXEL_PER_PDM * N_OF_FRAMES_D1_V0*sizeof(uint32_t));
//		// Mark the trigger as copied (sent)
//		triggerInfoD3[prev_alt_buffer][i].is_sent = 1;
//	}
}

void* Get_ZYNQ_PACKET()
{
	return &zynqPacket;
}

void SendHVPSLogToFTP(int mode) //0 - numerical,  1 - HVPS.log
{
	u32 size = HV_getLogFileSize();
	char filename_str[20];
	int ret;
	memset(hvps_log_file_ftp, 0, sizeof(Z_DATA_TYPE_HVPS_LOG_V1));
	memcpy(hvps_log_file_ftp, HV_getLogPtr(), size);
	//DeleteFile("HVPS.log");
	sprintf(filename_str, FILENAME_HVLOG, instrumentState.file_counter_hv++);
	if(mode == 0)
		ret = CreateFile(/*"HVPS.log"*/filename_str, hvps_log_file_ftp, size, 0, file_regular);
	else
		ret = CreateFile("HVPS.log", hvps_log_file_ftp, size, 0, file_regular);

	xil_printf("CreateFile rets %d\n\r", ret);
	HV_clean_log();
	xil_printf("%d HVPS size\n\r", size);
}


void DataPathSM()
{
	int i, offset, ret;
	char* ptr;
	int current_scidata_record;
	static u32 prev_mode = 0;

	char filename_str[20];
	static int what_trigger_armed = 0; // 1- L1, 2 - L2, 3 - L3
	//if(systemSettings.isPrinting) xil_printf("#%d", datapath_sm_state);

	//u32 timer_value = 0;
	switch(datapath_sm_state)
	{
	case datapath_idle_state:
		if(instrumentState.mode != 0)
		{
			*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGW_FLAGS*4) = instrumentState.mode | BIT_FC_IS_STARTED;
			*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGW_INT_TRIG_GTU_TIME*4) = 2048*1000+20;
			StartDataProviderForLive();//*(u32*)(XPAR_AXI_DATA_PROVIDER_0_BASEADDR + 4*REGW_INFINITE) = 1;
			datapath_sm_state = datapath_wait4trigger_state;
		}
		else if((instrumentState.mode == 0) && (prev_mode != 0))
		{
			// stop command was received
			datapath_sm_state = datapath_wait4trigger_state;
			StopDataProviderForLive();//*(u32*)(XPAR_AXI_DATA_PROVIDER_0_BASEADDR + 4*REGW_INFINITE) = 0;
		}
		else
		{
			// do nothing
		}

		prev_mode = instrumentState.mode;

		break;
	case datapath_wait4trigger_state:
		if(IsBufferD3Changed())
		{
			print("*");
			// collect data parts from DMA memory
			CopyEventData_trig();
			// compose the filename
			sprintf(filename_str, FILENAME_CONCATED, instrumentState.file_counter_cc++);
			// copy to main sci data storage. Look for free space there
			for(i=0;i<SCI_DATA_ARRAY_SIZE;i++)
			{
				if(!sci_data[i].is_occupied)
				{
					current_scidata_record = i;
					xil_printf("[%d]\n\r", current_scidata_record);
					memcpy((char*)&sci_data[current_scidata_record].sci_data, (char*)Get_ZYNQ_PACKET(), sizeof(DATA_TYPE_SCI_ALLTRG_V2));
					sci_data[current_scidata_record].is_occupied = 1;
					//xil_printf("link addr %08X occupied\n\r", &sci_data[current_scidata_record]);
					// create file
					if((instrumentState.file_counter_cc+1)%25 == 0) SendHVPSLogToFTP(0);


					ret = CreateFile(filename_str, &sci_data[current_scidata_record].sci_data, sizeof(DATA_TYPE_SCI_ALLTRG_V2), 0, file_scidata);
					if(ret<0) xil_printf("CreateFile returns error %d\n\r", ret);

					break;
				}
			}
			datapath_sm_state = datapath_idle_state;
			what_trigger_armed = 3;
		}
		break;
	}
}

int mem_alloc()
{
	char var_addr;
	xil_printf("Top addr = 0x%08x\n\r", &var_addr);
	sci_data = 0x10000000; // To be defined after the situation with memory will be clear for me.
}

void StopSM()
{
	switch(stop_sm_state)
	{
	case stop_sm_idle:
		break;
	case wait4data_provider_stop:
		if(!IsDataProviderPass())
			stop_sm_state = wait4interruptD3;
		break;
	case wait4interruptD3:
		if(IsBufferD3Changed2())
			stop_sm_state = stop_sm_stopped;
		break;
//	case stop_sm_stopping: // was in Mini
//		if(IsFTP_bin_idle())
//		{
//			// release trigger
//			datapath_sm_state = stop_sm_stopped;
//		}
//		break;
	case stop_sm_stopped:
		//SendLogToFTP();
		//SetDataProviderTestMode(0);
		//PrnAllRegs();
		stop_sm_state = stop_sm_idle;
		break;
	}
}
