/*
 * clkb.h
 *
 *  Created on: 10 февр. 2022 г.
 *      Author: alx
 */

#ifndef SRC_CLKB_H_
#define SRC_CLKB_H_

#define REGW_CLKB_FORCE_TRG		0
#define REGW_CLKB_RESET_CNT		1
#define REGR_CLKB_FREQ_40MHz	4
#define REGR_CLKB_FREQ_GTU_CLK	5
#define REGR_CLKB_CNT_1PPS		6
#define REGR_CLKB_CNT_EXT_TRG	7
#define REGR_CLKB_STATUS		8
#define REGR_CLKB_CNT_GTU		9

//REGW_CLKB_FORCE_TRG
#define BIT_CLKB_FORCE_TRG_TO_0 0
#define BIT_CLKB_FORCE_TRG_TO_1	1

//REGW_CLKB_RESET_CNT
#define BIT_CLKB_RESET_CNT		0


//REGR_CLKB_STATUS
#define BIT_CLKB_STATUS_LOCKED	0
#define BIT_CLKB_STATUS_GTU_CLK	1
#define BIT_CLKB_STATUS_1PPS	2
#define BIT_CLKB_STATUS_BUSY	3
#define BIT_CLKB_STATUS_EXT_TRG	4

u32 ClkbGetStatus();
u32 ClkbIsLocked();
u32 ClkbLineGTU();
u32 ClkbLine1PPS();
u32 ClkbLineBUSY();
u32 ClkbLineExtTrig();
u32 ClkbGetFreq40MHz();
u32 ClkbGetFreqGTUClk();
u32 ClkbGetCnt1PPS();
u32 ClkbGetCntExtTrig();
u32 ClkbGetCntGTU();
void ClkbResetCounters();
void ClkbForceTrgTo0(u32 param);
void ClkbForceTrgTo1(u32 param);




#endif /* SRC_CLKB_H_ */
