/*
 * dma_handling.h
 *
 *  Created on: Feb 24, 2021
 *      Author: alx
 */

#ifndef SRC_DMA_HANDLING_H_
#define SRC_DMA_HANDLING_H_

#include "xscugic.h"

void L1Start();
void L1Stop();
void L3Start(u32 is_infinite, u32 n_frames);
void L3Stop();
void SetupDMAIntrSystem(XScuGic* pIntc);
void DMA_init();
void IsDMAsBusy();
u32 DMAStatus();
u32 Is_D3_received();
void start_dma_l3(u32 n_frames);
void DoFileProcessing(u32 param);
void* DMA_GetP();



#endif /* SRC_DMA_HANDLING_H_ */
