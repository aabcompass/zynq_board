/*
 * slow_control.h
 *
 *  Created on: Nov 13, 2016
 *      Author: alexander
 */

#include "xbasic_types.h"
#include "xil_types.h"
#include "pdmdata.h"

#ifndef SLOW_CONTROL_H_
#define SLOW_CONTROL_H_

//#define XPAR_SPACIROC3_SC_0_BASEADDR

//#define N_PIXELS	64
//#define N_CHIPS		6
//#define N_LINES		6

//int slow_chip[] = {3, 4}


#define BIT_START			0
#define BIT_DONE			0
//REGW_SLOWCTRL_CONFIG
#define BIT_IS_SAME_DATA	0
#define BIT_USER_LED		1
#define BIT_SELECT_DIN		2
#define BIT_EN_SR_RSTB_PC	3

#define BIT_RESET			0

#define REGW_SLOWCTRL_CONTROLREG	0
#define REGW_SLOWCTRL_RESETREG		1
#define REGW_SLOWCTRL_STATUS		2
#define REGW_SLOWCTRL_CONFIG		3
#define REGW_SLOWCTRL_CMD			4
#define REGW_SLOWCTRL_FIFO_CNT		5
#define REGW_SLOWCTRL_SPEED			6
#define REGW_SLOWCTRL_GENERALREG_0	8
#define REGW_SLOWCTRL_GENERALREG_1	9
#define REGW_SLOWCTRL_GENERALREG_2	10
#define REGW_SLOWCTRL_GENERALREG_3	11
#define REGW_SLOWCTRL_GENERALREG_4	12
#define REGW_SLOWCTRL_GENERALREG_5	13

#define REGR_SLOWCTRL_STATUS		16


//REGW_SLOWCTRL_RESETREG
#define BIT_SLOWCTRL_RESET_FIFO_RB	1
//REGW_SLOWCTRL_CMD
#define BIT_SLOWCTRL_INJECT_BIT		0

#define DAC7_DEFAULT_VALUE	64
#define DAC10_NOISY_VALUE	712

typedef struct
{
	uint32_t dac10bit;// bits [31:0]
	uint8_t pixel_mask[N_OF_PIXELS_PER_PMT]; //bits [607:32]
	uint8_t dac7bit[N_OF_PIXELS_PER_PMT]; //bits [607:32]
	uint8_t gain5bit[N_OF_KI_PER_PMT];
} SLOWCTRL_SP3_SGL_ASIC_USER_V0; //

typedef struct
{
	SLOWCTRL_SP3_SGL_ASIC_USER_V0 slowctrl_sp3_sgl_asic[N_OF_PMT_PER_ECASIC][N_OF_ECASIC_PER_PDM];
} SLOWCTRL_SP3_ALL_ASIC_USER_V0;

// Configuration slow control data for one SPACIROC III.
// Fields of this structure are describes in the excel file produces by Silvie Blin
// In order to make possible to represent slow control as arrays, zero padding was inserted
// See the columns G:S of the excel file.
typedef struct
{
	uint32_t misc_reg0;// bits [31:0]
	uint16_t tst_msk_dac[N_OF_PIXELS_PER_PMT]; //bits [607:32]
	uint32_t misc_reg1;//bits[609:608]
	uint8_t gain[N_OF_PIXELS_PER_PMT];//bits [929:610]
	uint8_t dac_7b_sub[N_OF_PIXELS_PER_PMT/8];//bits [985:930]
	uint32_t misc_reg2;//bits [991:986]
} SLOWCTRL_SP3_SGL_ASIC_V1; // 268 bytes

// Slow control data for all 36 SPACIROCs
typedef struct
{
	SLOWCTRL_SP3_SGL_ASIC_V1 slowctrl_sp3_sgl_asic[N_OF_PMT_PER_ECASIC][N_OF_ECASIC_PER_PDM];
} SLOWCTRL_SP3_ALL_ASIC_V1; //268*36=9648 bytes

//// Special structure for a downloading same data to all SPACIROCs
//typedef struct
//{
//	uint32_t misc_reg0;
//	uint32_t x2_tst_msk_dac; /*two  tst_msk_dac uint16_t values*/
//	uint32_t misc_reg1;
//	uint32_t x4_gain;  /*four gain uint8_t values*/
//	uint32_t x4_dac_7b_sub; /*four dac_7b_sub uint8_t values*/
//	uint32_t misc_reg2;
//} SLOWCTRL_SP3_SAME_ASIC_V1;

typedef struct
{
	uint32_t misc_reg0[N_OF_ECASIC_PER_PDM];
	uint32_t x2_tst_msk_dac[N_OF_PIXELS_PER_PMT/2][N_OF_ECASIC_PER_PDM];
	uint32_t misc_reg1[N_OF_ECASIC_PER_PDM];
	uint32_t x4_gain[N_OF_PIXELS_PER_PMT/4][N_OF_ECASIC_PER_PDM];
	uint32_t x4_dac_7b_sub[N_OF_PIXELS_PER_PMT/4/8][N_OF_ECASIC_PER_PDM];
	uint32_t misc_reg2[N_OF_ECASIC_PER_PDM];
} SLOWCTRL_SP3_6CHIPS_REFORMATTED_V1;

typedef struct
{
	SLOWCTRL_SP3_6CHIPS_REFORMATTED_V1 slowctrl_sp3_6chips_reformatted[N_OF_PMT_PER_ECASIC];
} SLOWCTRL_SP3_36CHIPS_REFORMATTED_V1;


//void RB_inject_bit();
u32 StartScurve();
void Set_scurve_step(u32 step);
void SetSCMapping(u8 n_pmt_in_ec, u8 pixelnum, u8 pixelmap);
void SetSC_speed(u32 speed);

u32 GetSCCoreStatus();

#define SC_TIMEOUT_WAIT_FOR_IDLE	1000
u32 SC_WaitForCoreIdle();

#endif /* SLOW_CONTROL_H_ */
