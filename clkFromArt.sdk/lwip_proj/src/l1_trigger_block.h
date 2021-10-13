/*
 * l1_trigger_block.h

 *
 *  Created on: 13 сент. 2021 г.
 *      Author: alx
 */

#ifndef SRC_L1_TRIGGER_BLOCK_H_
#define SRC_L1_TRIGGER_BLOCK_H_

#include "xbasic_types.h"

int Set_L1_MPSthr(u32 param);
int Set_L1_nSigma(float param);
int Set_L1_nHot(u32 param);
int Set_L1_nLength(u32 param);
int Set_L1_nActive(u32 param);
void L1_send_rest_params();
void L1_send_default_params();

#define BIT_L1_MPSTHR	0
#define BIT_L1_NSIGMA	0
#define BIT_L1_NHOT		10
#define BIT_L1_NLEN		15
#define BIT_L1_NACTIVE	20

#define BIT_L1_SW		31


#endif /* SRC_L1_TRIGGER_BLOCK_H_ */
