/*
 * axis_flowctrl.c
 *
 *  Created on: Jun 5, 2017
 *      Author: alx
 */
#include "axis_flowctrl_d1.h"
#include "xparameters.h"
#include "xbasic_types.h"
#include "pdmdata.h"
#include "pdmdata_hw.h"
#include "own_data_types.h"



int N1=MAX_PACKETS_L1;

void FlowControlTRG()
{
	*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGW_CLR_FLAGS*4) |= BIT_FC_TRIG_IMMEDIATE;
	print("BIT_FC_TRIG_IMMEDIATE\n\r");
	*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGW_CLR_FLAGS*4) &= ~BIT_FC_TRIG_IMMEDIATE;

}


void FlowControlsClr_D1()
{
	*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGW_CLR_FLAGS*4) |= BIT_FC_CLR_ALL;
	*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGW_CLR_FLAGS*4) &= ~BIT_FC_CLR_ALL;
}

void ResetGTUCounter_D1()
{
	*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGW_CLR_FLAGS*4) |= BIT_FC_CLR_GTU_CNT;
	*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGW_CLR_FLAGS*4) &= ~BIT_FC_CLR_GTU_CNT;
}

void ResetTriggerService_D1()
{
	*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGW_CLR_FLAGS*4) |= BIT_FC_CLR_TRIG_SERVICE;
	*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGW_CLR_FLAGS*4) &= ~BIT_FC_CLR_TRIG_SERVICE;
}

//int CheckTrigger_L1()
//{
//	return (*(u32*)(XPAR_AXIS_FLOW_CONTROL_L1_BASEADDR + REGR_FC_SM_STATE*4)) & BIT_FC_IS_TRIGGER;
//}

u32 GetTrigNGTU_L1()
{
	return *(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGR_GTU_TIMESTAMP*4);
}

u32 GetTrigType_L1()
{
	return *(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGR_TRIG_TYPE*4);
}

u32 GetUnixTimestamp_L1()
{
	return *(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGR_UNIX_TIMESTAMP*4);
}

void Set_N1(int value)
{
	*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGW_NUM_OF_TRIGS_FLAGS2*4) &= 0xFFFF0000;
	*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGW_NUM_OF_TRIGS_FLAGS2*4) |= value;
	N1 = value;
}

int Get_N1()
{
	return N1;
}

int Get_N3()
{
	return 1;
}

void SetTime(u32 param0)
{
	*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGW_UNIX_TIME*4) = param0;
	*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGW_EDGE_FLAGS*4) = BIT_FC_SET_UNIX_TIME;
	*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGW_EDGE_FLAGS*4) = 0;

}

void FlowControlInit_D1()
{
	*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGW_TUSER_TLAST*4) = 0x2b;

	*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGW_GTUS_PER_CYCLE*4) = N_FRAMES_PER_LIFECYCLE;
	*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGW_PERIODIC_TRIG_PERIOD*4) = N_FRAMES_PER_LIFECYCLE/128*15;//     /20000; //for testing
	*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGW_D1_N_GTU_AFTER_TRIG*4) = N_OF_FRAMES_D1_V0; // The number of frames in DMA transfer

	*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGW_D1_FIFO_THR*4) = (N_OF_FRAMES_D1_V0/2) * N_OF_PIXEL_PER_PDM/16;/*8 - was in Mini*/

	*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGW_FLAGS*4) = BIT_FC_IS_STARTED;// | BIT_FC_EN_PERIODIC_TRIG; was in Mini.
	//*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGW_TLAST_REMOVER_PHASE*4) = 4;
	*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGW_TRIGGER_RELAX_TIME*4) = 0;//500/*clkper gtu*/*128;


	Set_N1(MAX_PACKETS_L1);

	//reset flow control cores
	FlowControlsClr_D1();
	// reset time to zero
	SetTime(0);
}

void StartEventsLog_L1()
{
	*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGW_NUM_OF_TRIGS_FLAGS2*4) |= BIT_FC_TRIG_EVENTS_LOG_EN;
}

int StopEventsLog_L1() // returns the number of collected events
{
	u32 num = *(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGR_TRIG_ALL_CNT*4);
	*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGW_NUM_OF_TRIGS_FLAGS2*4) &= ~BIT_FC_TRIG_EVENTS_LOG_EN;
	return num;
}

int IsD1Triggered()
{
	//xil_printf("%d %d\n\r", *(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGR_FC_SM_STATE*4), (*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGR_FC_SM_STATE*4)) & 0xF == 5);
	return (((*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGR_FC_SM_STATE*4)) & 0xF) == 7);
}

int IsD1DMA_error()
{
	return (*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGW_CLR_FLAGS*4) & BIT_FC_STATUS_DMA_ERROR);
}

void D1_release()
{
	*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGW_EDGE_FLAGS*4) = BIT_FC_RELEASE;
	*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGW_EDGE_FLAGS*4) = 0;
}
