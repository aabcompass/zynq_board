/*
 * hv_cathode.c
 *
 *  Created on: Aug 1, 2019
 *      Author: alx
 */
#include "xparameters.h"
#include "hv_cathode.h"
#include "xil_types.h"

uint32_t cathode_data;


void TestEC_sig()
{
	*(u32*)(XPAR_AXI_CATHODE_CTRL_0_BASEADDR + 4*REGW_HVCATH_STIM_EC_SIG) = 0x1FF;
	*(u32*)(XPAR_AXI_CATHODE_CTRL_0_BASEADDR + 4*REGW_HVCATH_STIM_EC_SIG) = 0;
}

void CathodeSetAutoMode(int mode) //1 or 0
{
	*(u32*)(XPAR_AXI_CATHODE_CTRL_0_BASEADDR + 4*REGW_HVCATH_OPT) = mode*(1<<BIT_ADCV_EN);
}

void ResetADCV()
{
	*(u32*)(XPAR_AXI_CATHODE_CTRL_0_BASEADDR + 4*REGW_HVCATH_CTRL) = (1<<BIT_ADCV_RESET);
	*(u32*)(XPAR_AXI_CATHODE_CTRL_0_BASEADDR + 4*REGW_HVCATH_CTRL) = 0;
}

void ConfADCV(int len0, int len1, int num)
{
	ResetADCV();
	*(u32*)(XPAR_AXI_CATHODE_CTRL_0_BASEADDR + 4*REGW_HVCATH_EN_EC) = 0x1FF;
	*(u32*)(XPAR_AXI_CATHODE_CTRL_0_BASEADDR + 4*REGW_HVCATH_RELEASE_TIME) = 1000000000;
	*(u32*)(XPAR_AXI_CATHODE_CTRL_0_BASEADDR + 4*REGW_HVCATH_GTU_LEN0) = len0;
	*(u32*)(XPAR_AXI_CATHODE_CTRL_0_BASEADDR + 4*REGW_HVCATH_GTU_LEN1) = len1;
	*(u32*)(XPAR_AXI_CATHODE_CTRL_0_BASEADDR + 4*REGW_HVCATH_BIG_PULSES_NUM) = num;
	*(u32*)(XPAR_AXI_CATHODE_CTRL_0_BASEADDR + 4*REGW_HVCATH_EC_MAPPING_H) = 0x00000000;
	*(u32*)(XPAR_AXI_CATHODE_CTRL_0_BASEADDR + 4*REGW_HVCATH_EC_MAPPING_L) = 0x00000340;
}

void SetReleaseTime(u32 time_ms)
{
	*(u32*)(XPAR_AXI_CATHODE_CTRL_0_BASEADDR + 4*REGW_HVCATH_RELEASE_TIME) = 200000*time_ms;
}
//void SetSwitchingPulsesParams(int len0, int len1, int num)
//{
//	*(u32*)(XPAR_AXI_CATHODE_CTRL_0_BASEADDR + 4*REGW_HVCATH_GTU_LEN0) = len0;
//	*(u32*)(XPAR_AXI_CATHODE_CTRL_0_BASEADDR + 4*REGW_HVCATH_GTU_LEN1) = len1;
//	*(u32*)(XPAR_AXI_CATHODE_CTRL_0_BASEADDR + 4*REGW_HVCATH_BIG_PULSES_NUM) = num;
//}

//conf EC mapping for Mini-EUSO FM
// taken from Marcos presentation
// also the main from 22/10/2019
// and from the picture /mnt/d/EUSO/FM/acq_test_2/screenshot.png
//6 2 1
//8 9 5
//7 4 3

// It means that FS data channel #2 triggers cathode switching in HVPS channel #8.

// Direct mapping
//3 6 9
//2 5 8
//1 4 7
//1 must be subtracted


void SetDefaultECMapping() // For Mini-EUSO FM
{
	u8 ec_mapping[] = {9,9,9, 9,9,9, 9,9,9};
	SetECMapping(ec_mapping);
}

u32 GetADCVEcTimer()
{
	return *(u32*)(XPAR_AXI_CATHODE_CTRL_0_BASEADDR + 4*REGR_HVCATH_GET_EC0_TIMER);
}


void SetECMapping(u8* mapping)
{
	print("Set EC mapping\n\r");
	*(u32*)(XPAR_AXI_CATHODE_CTRL_0_BASEADDR + 4*REGW_HVCATH_EC_MAPPING_L) =
			mapping[0] | mapping[1]<<4 | mapping[2]<<8 | mapping[3]<<12 |
			mapping[4]<<16 | mapping[5]<<20 | mapping[6]<<24 |mapping[7]<<28;
	*(u32*)(XPAR_AXI_CATHODE_CTRL_0_BASEADDR + 4*REGW_HVCATH_EC_MAPPING_H) = mapping[8];
}

void UpdateCathodeLevels(uint32_t data)
{
	cathode_data = data;
}

uint32_t GetCathodeLevels()
{
	return cathode_data;
}

void HVPSSetGTUPeriod(u32 freq)
{
	*(u32*)(XPAR_AXI_CATHODE_CTRL_0_BASEADDR + 4*REGW_HVCATH_AERA_PER)  = 0;
	*(u32*)(XPAR_AXI_CATHODE_CTRL_0_BASEADDR + 4*REGW_HVCATH_AERA_PER)  = freq;
}
