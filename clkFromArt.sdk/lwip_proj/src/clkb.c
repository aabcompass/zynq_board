/*
 * clkb.c
 *
 *  Created on: 10 февр. 2022 г.
 *      Author: alx
 */

#include "xparameters.h"
#include "xbasic_types.h"
#include "clkb.h"

u32 force_reg = 0;


u32 ClkbGetStatus()
{
	return *(u32*)(XPAR_AXI_CLKB_CORE_0_BASEADDR + 4*REGR_CLKB_STATUS);
}

u32 ClkbIsLocked()
{
	return (ClkbGetStatus() & (1<<BIT_CLKB_STATUS_LOCKED)) ? TRUE : FALSE;
}

u32 ClkbLineGTU()
{
	return (ClkbGetStatus() & (1<<BIT_CLKB_STATUS_GTU_CLK)) ? TRUE : FALSE;
}

u32 ClkbLine1PPS()
{
	return (ClkbGetStatus() & (1<<BIT_CLKB_STATUS_1PPS)) ? TRUE : FALSE;
}

u32 ClkbLineBUSY()
{
	return (ClkbGetStatus() & (1<<BIT_CLKB_STATUS_BUSY)) ? TRUE : FALSE;
}

u32 ClkbLineExtTrig()
{
	return (ClkbGetStatus() & (1<<BIT_CLKB_STATUS_EXT_TRG)) ? TRUE : FALSE;
}

u32 ClkbGetFreq40MHz()
{
	return *(u32*)(XPAR_AXI_CLKB_CORE_0_BASEADDR + 4*REGR_CLKB_FREQ_40MHz);
}

u32 ClkbGetFreqGTUClk()
{
	return *(u32*)(XPAR_AXI_CLKB_CORE_0_BASEADDR + 4*REGR_CLKB_FREQ_GTU_CLK);
}


u32 ClkbGetCnt1PPS()
{
	return *(u32*)(XPAR_AXI_CLKB_CORE_0_BASEADDR + 4*REGR_CLKB_CNT_1PPS);
}

u32 ClkbGetCntExtTrig()
{
	return *(u32*)(XPAR_AXI_CLKB_CORE_0_BASEADDR + 4*REGR_CLKB_CNT_EXT_TRG);
}

u32 ClkbGetCntGTU()
{
	return *(u32*)(XPAR_AXI_CLKB_CORE_0_BASEADDR + 4*REGR_CLKB_CNT_GTU);
}

void ClkbResetCounters()
{
	*(u32*)(XPAR_AXI_CLKB_CORE_0_BASEADDR + 4*REGW_CLKB_RESET_CNT) = (1<<BIT_CLKB_RESET_CNT);
	print("CLKB counters are reset");
	*(u32*)(XPAR_AXI_CLKB_CORE_0_BASEADDR + 4*REGW_CLKB_RESET_CNT) = 0;
}

void ClkbForceTrgTo0(u32 param)
{
	if(param)
		force_reg |= (1<<BIT_CLKB_FORCE_TRG_TO_0);
	else
		force_reg &= ~(1<<BIT_CLKB_FORCE_TRG_TO_0);

	*(u32*)(XPAR_AXI_CLKB_CORE_0_BASEADDR + 4*REGW_CLKB_FORCE_TRG) = force_reg;
}

void ClkbForceTrgTo1(u32 param)
{
	if(param)
		force_reg |= (1<<BIT_CLKB_FORCE_TRG_TO_1);
	else
		force_reg &= ~(1<<BIT_CLKB_FORCE_TRG_TO_1);

	*(u32*)(XPAR_AXI_CLKB_CORE_0_BASEADDR + 4*REGW_CLKB_FORCE_TRG) = force_reg;
}
