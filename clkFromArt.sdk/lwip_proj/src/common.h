/*
 * common.h
 *
 *  Created on: Jan 9, 2020
 *      Author: alx
 */

#ifndef SRC_COMMON_H_
#define SRC_COMMON_H_

#define SWAP_UINT32(x) (((x) >> 24) | (((x) & 0x00FF0000) >> 8) | (((x) & 0x0000FF00) << 8) | ((x) << 24))

//#define FILENAME_ARTIX_BITSTREAM "artix.bin"
#define FILENAME_ARTIX_BITSTREAM_1_BOARD "top_art4.bit"
#define FILENAME_ARTIX_PARAMETERS "artfw.cfg"

enum {DATA_TYPE_L1=1, DATA_TYPE_L3=3};
enum {FIFO_CH_TRIG, FIFO_CH_MAPPING};
enum {FINITE, INFINITE};
enum {NO_FILE_PROCESSING, DO_FILE_PROCESSING};


#define GENERAL_TIMEOUT 10000000

void ScurveAdderReInit();
void SetIntegration(u32 param);
u32 GetIntegration();
void Set_n_d3_per_file(u32 param);

#endif /* SRC_COMMON_H_ */
