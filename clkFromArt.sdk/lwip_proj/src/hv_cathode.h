/*
 * hv_cathode.h
 *
 *  Created on: May 29, 2019
 *      Author: alx
 */

#ifndef SRC_HV_CATHODE_H_
#define SRC_HV_CATHODE_H_

#include "stdint.h"
#include "xbasic_types.h"

// HV CATHODE regs
#define REGW_HVCATH_SW				0 /*17:0=aera_command*/
#define REGW_HVCATH_OPT				1 /*0=adcv_en*/
#define REGW_HVCATH_CTRL			2 /*0=BIT_TRANSMIT  1=reset*/
#define REGW_HVCATH_EN_EC			4 /*8:0=en_ec_units*/
#define REGW_HVCATH_RELEASE_TIME	5 /*31:0=release_time (in CLKs)*/
#define REGW_HVCATH_GTU_LEN0		6 /*4:0=gtu_pulse_len_param0*/
#define REGW_HVCATH_GTU_LEN1		7 /*4:0=gtu_pulse_len_param1*/
#define REGW_HVCATH_BIG_PULSES_NUM	8 /*15:0=gtu_big_pulses_qty*/
#define REGW_HVCATH_EC_MAPPING_H	9 /*ec_mapping <= slv_reg9(3 downto 0) & slv_reg10;*/
#define REGW_HVCATH_EC_MAPPING_L	10 /*ec_mapping <= slv_reg9(3 downto 0) & slv_reg10;*/
#define REGW_HVCATH_STIM_EC_SIG		11 /*ec_sig2 <= ec_sig or slv_reg11(8 downto 0);*/
#define REGW_HVCATH_AERA_PER		12  /**/

#define REGR_HVCATH_GET_EC0_TIMER	20 /*31:0*/

//REGW_HVCATH_OPT
#define BIT_ADCV_EN			0

//REGW_HVCATH_CTRL
#define BIT_TRANSMIT		0
#define BIT_ADCV_RESET		1


void CathodeSetAutoMode(int mode);
void TestEC_sig();
void SetSwitchingPulsesParams(int len0, int len1, int num);
void ConfADCV(int len0, int len1, int num);

void UpdateCathodeLevels(uint32_t data);
uint32_t GetCathodeData();
void CathodeSetAutoMode(int mode);
void SetReleaseTime(u32 time_ms);
void HVPSSetGTUPeriod(u32 freq);

#endif /* SRC_HV_CATHODE_H_ */
