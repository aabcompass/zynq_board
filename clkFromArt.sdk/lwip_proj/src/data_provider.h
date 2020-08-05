/*
 * data_provider.h
 *
 *  Created on: Jan 16, 2020
 *      Author: alx
 */

#ifndef SRC_DATA_PROVIDER_H_
#define SRC_DATA_PROVIDER_H_

#define REGW_DATAPROV_FLAGS		0
#define REGW_DATACONV_RESET		1
#define REGW_DATAPROV_N_FRAMES	3
#define REGW_DATAPROV_FLAGS2	10
#define REGW_DATAPROV_PMTZERO_01	11
#define REGW_DATAPROV_PMTZERO_2	12

//REGW_DATAPROV_FLAGS
#define BIT_START_SIG			0 /*Start Data Provider*/
#define BIT_RUN					1 /*Start/stop in case of infinite mode*/
//REGW_DATACONV_RESET
#define BIT_DATACONV_RESET		0
#define BIT_SCURVE_ADDER_RESET	1
//REGW_DATAPROV_FLAGS2
#define BIT_INFINITE			0 /*Provide data infinitely regardless of REGW_DATAPROV_N_FRAMES*/
#define BIT_GTU_1US				1 /*GTU clk mode - 1 or 2.5.  Must be setup prior to starts*/
#define BIT_RUN_DATACONV		2 /*Run data converter which is BEFORE the data_provider*/


int IsDataProviderStarted();

#endif /* SRC_DATA_PROVIDER_H_ */
