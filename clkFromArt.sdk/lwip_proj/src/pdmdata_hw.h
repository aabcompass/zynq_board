/*
 * pdmdata_hw.h
 *
 *  Created on: Jan 30, 2017
 *      Author: alx
 */
#include "xil_types.h"


#ifndef SRC_PDMDATA_HW_H_
#define SRC_PDMDATA_HW_H_

#include "pdmdata.h"
#include "hv.h"

#define N_FRAMES_DMA_D1			 N_OF_FRAMES_D1_V0
#define N_FRAMES_DMA_D3			(N_OF_FRAMES_D3_V0*1)

#define TRIGGER_DATA_OFFSET			64 /*in GTU*/

#define N_ALT_BUFFERS				2

#define N_TRIG_BUFFERS_DMA_D1		MAX_PACKETS_L1
#define N_TRIG_BUFFERS_DMA_D3		1

#define N_ALT_TRIG_BUFFERS			2


int IsBufferL2Changed();

typedef struct
{
	u32 trigger_type;
	u32 n_gtu;
	u32 unix_timestamp;
	u8 is_sent;
	u8 is_dma_error;
	u32 n_intr;
	u32 alt_trig_buffer;
	u8 hv_data[NUM_OF_HV];
} TriggerInfo;

#define MAX_TRIGGERS_PER_CYCLE		MAX_PACKETS_L1 /*Was 4 in Mini*/

#endif /* SRC_PDMDATA_HW_H_ */
