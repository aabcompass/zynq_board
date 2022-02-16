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
#include "own_data_types.h"
#include "common.h"



int N1=MAX_PACKETS_L1;
int is_started = 0;

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
	*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGW_PERIODIC_TRIG_PERIOD*4) = CLK_FREQ*N_FRAMES_PER_LIFECYCLE/(MAX_PACKETS_L1+1);//     /20000; //for testing
	*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGW_D1_N_GTU_AFTER_TRIG*4) = N_OF_FRAMES_D1_V0; // The number of frames in DMA transfer

	*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGW_D1_FIFO_THR*4) = (N_OF_FRAMES_D1_V0/2) * (N_OF_PIXELS_TOTAL)/16;/*8 - was in Mini*/

	//*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGW_FLAGS*4) = BIT_FC_IS_STARTED;// | BIT_FC_EN_PERIODIC_TRIG; was in Mini.

	*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGW_TRIGGER_RELAX_TIME*4) = 500*128;;//500/*clkper gtu*/*128;


	Set_N1(MAX_PACKETS_L1);

	//reset flow control cores
	FlowControlsClr_D1();
	// reset time to zero
	SetTime(0);
}

void SetPeriodOfPeriodicTrigger(u32 clks)
{
	*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGW_PERIODIC_TRIG_PERIOD*4) = clks;//
}


void FlowControlStart_D1(u32 start)
{
	if(start == 1) {
		*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGW_FLAGS*4) |= BIT_FC_IS_STARTED;
		is_started = 1;
	}
	else {
		is_started = 0;
		*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGW_FLAGS*4) &= ~BIT_FC_IS_STARTED;
	}
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

u32 Get_n_glob_cycles()
{
	return *(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGR_N_GLOB_CYCLES*4);
}

u32 GetUnixTime()
{
	return *(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGR_UNIX_TIME*4);
}

u32 GetNGTU()
{
		return *(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGR_GTU_CNT*4);
}

void SetModeD1(u32 mode)
{
	if(mode != 0)
	{
		//ResetGTUCounter_D1();
		*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGW_FLAGS*4) = mode | (is_started*BIT_FC_IS_STARTED);// | BIT_FC_IS_STARTED; Was in Mini
		//*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGW_INT_TRIG_GTU_TIME*4) = 2048*1000+20;
	}
}

u32 L1_getNAPM() // Returns the number of active macropixels from the AXIS L1 output
{
	return (*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGR_TRG_OUT*4)) & 0x1FF;
}

u32 L1_getGTUnumber() //  Returns the GTU number from the AXIS L1 output
{
	return ((*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGR_TRG_OUT*4))>>9) & ((2<<18)-1);
}

u32 L1_getSatisfied() //  Returns the trigger satisfaction status from the AXIS L1 output
{
	return ((*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGR_TRG_OUT*4))>>31) & 1;
}
