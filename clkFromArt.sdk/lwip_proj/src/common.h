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
#define FILENAME_ARTIX_BITSTREAM_1_BOARD "Artix53.bit"
#define FILENAME_ARTIX_PARAMETERS "artfw.cfg"

enum {DATA_TYPE_L1=1, DATA_TYPE_L3=3, DATA_TYPE_MPS=4};
enum {FIFO_CH_TRIG, FIFO_CH_MAPPING};
enum {FINITE, INFINITE};
enum {NO_FILE_PROCESSING, DO_FILE_PROCESSING};
enum {NO_D3_FILES, WITH_D3_FILES};
enum {FILENAMES_LAB, FILENAMES_FLIGHT};


#define GENERAL_LIVE_TIMEOUT 30000

#define CLK_FREQ	200 /*MHz*/

void ScurveAdderReInit();
void SetIntegration(u32 param);
u32 GetIntegration();
void Set_n_d3_per_file(u32 param);

#define N_FRAMES_DMA_D1			 N_OF_FRAMES_D1_V0
#define N_FRAMES_DMA_D3			(N_OF_FRAMES_D3_V0*1)

#endif /* SRC_COMMON_H_ */
