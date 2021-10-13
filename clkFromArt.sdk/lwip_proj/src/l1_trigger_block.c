/*
 * l1_trigger_block.c
 *
 *  Created on: 13 сент. 2021 г.
 *      Author: alx
 */


#include "l1_trigger_block.h"
#include "xbasic_types.h"
#include "common.h"
#include "pdmdp_err.h"

u32 MPSthr;
u32 nSigma_u32 = 704;
u32 nHot = 2;
u32 nLength = 20;
u32 nActive = 34;



int Set_L1_MPSthr(u32 param)
{
	if(param>=65536) return ERR_VALUE_OUT_OF_RANGE;
	MPSthr = param | (1<<BIT_L1_SW);
	TxFIFOSendMain(&MPSthr, 1, FIFO_CH_TRIG);
	return 0;
}

int Set_L1_nSigma(float param)
{
	if(param>=8.0 || param<2.0) return ERR_VALUE_OUT_OF_RANGE;
	nSigma_u32 = 128*param;
	L1_send_rest_params();
	return 0;
}

int Set_L1_nHot(u32 param)
{
	if(param>=32) return ERR_VALUE_OUT_OF_RANGE;
	nHot = param;
	L1_send_rest_params();
	return 0;
}

int Set_L1_nLength(u32 param)
{
	if(param>=32) return ERR_VALUE_OUT_OF_RANGE;
	nLength = param;
	L1_send_rest_params();
	return 0;
}

int Set_L1_nActive(u32 param)
{
	if(param>=2048) return ERR_VALUE_OUT_OF_RANGE;
	nActive = param;
	L1_send_rest_params();
	return 0;
}

void L1_send_rest_params()
{
	u32 word_rest = nSigma_u32 | (nHot<<BIT_L1_NHOT) | (nLength<<BIT_L1_NLEN) | (nActive<<BIT_L1_NACTIVE);
	TxFIFOSendMain(&word_rest, 1, FIFO_CH_TRIG);
}

void L1_send_default_params()
{
	Set_L1_MPSthr(32768);
	L1_send_rest_params();
}
