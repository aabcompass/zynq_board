/*
 * data_provider.h
 *
 *  Created on: Jan 16, 2020
 *      Author: alx
 */

#ifndef SRC_DATA_PROVIDER_H_
#define SRC_DATA_PROVIDER_H_

#include "xbasic_types.h"

#define REGW_DATAPROV_FLAGS		0
#define REGW_DATACONV_RESET		1
#define REGW_DATAPROV_N_FRAMES	3
#define REGW_DATAPROV_TEST_MODE	4
#define REGW_DATAPROV_INCR_PER	5
#define REGW_DATAPROV_PATT	6 /*7:0 MAX, 15:8 INIT*/
#define REGW_DATAPROV_GTU_PERIOD	7
#define REGW_DATAPROV_USE_ALT_FRAME	8

#define REGW_DATAPROV_FLAGS2			10
#define REGW_DATAPROV_PMTZERO_01		11
#define REGW_DATAPROV_PMTZERO_2			12
#define REGW_DATAPROV_CLKEN				13
#define REGR_DATAPROV_STATUS			16
#define REGR_DATAPROV_AUX1				17
#define REGR_DATAPROV_AUX2				18
#define REGR_DATAPROV_FRAMES_IN_CNT		19
#define REGR_DATAPROV_BITSLIP_CNT_0		20
#define REGR_DATAPROV_BITSLIP_CNT_1		21
#define REGR_DATAPROV_BITSLIP_CNT_2		22
#define REGR_DATAPROV_AUX3				23

//REGW_DATAPROV_FLAGS
#define BIT_START_SIG			0 /*Start Data Provider*/
#define BIT_RUN					1 /*Start/stop in case of infinite mode. Must be asserted  in finite mode*/
#define BIT_RESET_DOZER			2
#define BIT_EN_OUTPUT			3

//REGW_DATACONV_RESET
#define BIT_DATACONV_RESET		0
#define BIT_SCURVE_ADDER_RESET	1
#define BIT_DATACONV4TRIG_RESET	2

//REGW_DATAPROV_TEST_MODE
#define BIT_TEST_GEN_ON			0
#define BIT_TEST_MODE_ON		1
//REGW_DATAPROV_PATT
#define BIT_PATT_MAX			0
#define BIT_PATT_INIT			8
//REGW_DATAPROV_FLAGS2
#define BIT_INFINITE			0 /*Provide data infinitely regardless of REGW_DATAPROV_N_FRAMES*/
#define BIT_GTU_1US				1 /*GTU clk mode - 1 or 2.5.  Must be setup prior to starts*/
#define BIT_RUN_DATACONV		2 /*Run data converter which is BEFORE the data_provider*/
#define BIT_RUN_SELECTIO		3 /* Run selectio */
//REGW_DATAPROV_CLKEN
#define BIT_ART_CLKEN			0 /*Clock enable for artix clk. Set GTU time before to run artix clock*/
#define BIT_ART_GTUEN			1  /*GTU enable for  GTU signal to Artix.*/
//REGR_DATAPROV_STATUS
#define BIT_DP_PASS				0


int IsDataProviderStarted();
void RunArtix(u32 is_gtu_1us);
void ArtixClkEn(u32 en);
void PauseArtixClk();
void ResumeArtixClk();
void SetGtuFreq1us(u32 is_gtu_1us);
void StartDataProvider();
void StartDataProviderForLive();
void StopDataProviderForLive();
void StartDataProviderForNFrames(u32 n_frames);
void StartDataProviderFor1D3frame(u32 n_integration);
void ContinueDataProviderFor1D3frame();
void DataProvTestMode(int on, u32 period_gtu, u32 patt_init, u32 patt_max);
void DataProvEnOutput();
void ArtixClkEn(u32 en);
void ResetTriggerService_D1();
u32 IsDataProviderPass();
void GetAux2Data(u32* data0, u32* data1, u32* data2);
void GetAux3Data(u32* data0, u32* data1, u32* data2);
void StopDataConverter();

#endif /* SRC_DATA_PROVIDER_H_ */
