/*
 * mmg.h
 *
 *  Created on: Feb 21, 2021
 *      Author: alx
 */

#ifndef SRC_MMG_H_
#define SRC_MMG_H_

#include "pdmdata.h"
#include "xbasic_types.h"
#include "xil_types.h"

#define N_D1_IN_MEM	250
#define N_D3_IN_MEM	15
#define N_MPS_IN_MEM	120

#define N_SCI_FILES		(N_D1_IN_MEM + N_D3_IN_MEM + N_MPS_IN_MEM)

typedef struct
{
	char alignment[0x40-sizeof(ZynqBoardHeader)-sizeof(TimeStamp_dual)-4*sizeof(uint32_t)];
	Z_DATA_TYPE_SCI_L1_V7 sci_data_l1[N_D1_IN_MEM];
	char alignment2[68];
	Z_DATA_TYPE_SCI_L3_V3 sci_data_l3[N_D3_IN_MEM];
	char alignment3[64];
	Z_DATA_TYPE_SCI_MPS_V1 sci_data_mps[N_MPS_IN_MEM];
} MainBuffer;

typedef struct
{
	u8 is_occupied;
	u8 is_finalized;
	u16 global_cycle;
} L1_DESCR;

typedef struct
{
	u8 is_occupied;
	u8 is_finalized;
	u16 global_cycle;
} L3_DESCR;

typedef struct
{
	u8 is_occupied;
	u8 is_finalized;
	u16 global_cycle;
} MPS_DESCR;

typedef struct
{
	L1_DESCR sci_data_l1[N_D1_IN_MEM];
	L3_DESCR sci_data_l3[N_D3_IN_MEM];
	MPS_DESCR sci_data_mps[N_MPS_IN_MEM];
} MainBufferDescr;

#define N_MAX_RECORDS_PER_FILE	25

typedef struct
{
	u8 is_occupied;
	u8 data_type; /*1 or 3 or 4*/
	u32 global_cycle;
	//u16 first_record;
	u16 records[N_MAX_RECORDS_PER_FILE];
	u16 n_records;
	void* p;
} SciFiles;

char* MmgAlloc(int data_type /*1 or 3*/); // return NULL if not allocated
u32 MmgCreateSciFile(int data_type, u32 global_cycle, void* p, u16 first_record);
void MmgDeleteSciFile(u32 file_descriptor);
void MmgFinish(int data_type, u32 n_gtu, u32 unix_time, u32 trig_type, u32 glob_cycle, u32 n_internal_l1);
u16 MmgIncr_n_records(u32 file_descriptor, u16 record);
INTPTR MmgGetP(int data_type);
u32 Get_n_occupied(int data_type);
void SetScurveAdditionalData(u16 start, u16 step, u16 end);
void MmgPrint1stD3();
int isD3Files();

#endif /* SRC_MMG_H_ */
