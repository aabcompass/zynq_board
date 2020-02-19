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

//REGW_DATAPROV_FLAGS
#define BIT_START_SIG			0
#define BIT_RUN					1
//REGW_DATACONV_RESET
#define BIT_DATACONV_RESET		0
//REGW_DATAPROV_FLAGS2
#define BIT_INFINITE			0
#define BIT_GTU_1US				1
#define BIT_RUN_DATACONV		2

#endif /* SRC_DATA_PROVIDER_H_ */
