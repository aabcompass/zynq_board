/*
 * mmg.c
 *
 *  Created on: Feb 21, 2021
 *      Author: alx
 */

#include "mmg.h"
#include "string.h"
#include "xil_cache.h"
#include "xil_printf.h"
#include "common.h"
#include "ftp_server.h"
#include "own_data_types.h"
#include "dma_handling.h"
#include "crc32.h"
#include "clkb.h"
#include "l1_trigger_block.h"

MainBuffer mainBuffer __attribute__ ((aligned (64)));
MainBufferDescr mainBufferDescr;
extern InstrumentState instrumentState;

u32 last_l1_occupied=0xFFFFFFFF, last_l3_occupied, last_mps_occupied;
int last_file_closed = 0;
u32 n_l1_occupied=0, n_l3_occupied=0, n_mps_occupied=0;
int last_file_descriptor = -1, last_mmg_file_descriptor = -1, last_global_cycle=-1;
SciFiles sciFiles[N_SCI_FILES];

int is_file_opened = 0;

u32 is_d3_files = WITH_D3_FILES;

u32 fw_version_int;

void DoD3Files(u32 param)
{
	is_d3_files = param;
}

int isD3Files()
{
	return is_d3_files;
}

u32 Mmg_Get_last_global_cycle()
{
	return last_global_cycle;
}

void MmgInit()
{
	u32 v1,v2,v3;
	memset((char*)&mainBuffer, 0, sizeof(MainBuffer));
	memset((char*)&mainBufferDescr, 0, sizeof(MainBufferDescr));
	memset((char*)&sciFiles, 0, sizeof(SciFiles));
	sscanf(ZYNQ3_VER_STRING, "v%d.%d.%d", &v1, &v2, &v3);
	xil_printf("MmgInit: fw_version_int: v%d.%d.%d\n\r", v1, v2, v3);
	fw_version_int = v1<<16 | v2<<8 | v3;
}

u32 GetFW_version_int()
{
	return fw_version_int;
}

u32 MmgCreateSciFile(int data_type, u32 global_cycle, void* p, u16 first_record) //returns file descriptor
{
	u32 i;
	for(i=0;i<N_SCI_FILES;i++)
	{
		if(!sciFiles[i].is_occupied) {
			sciFiles[i].is_occupied = 1;
			sciFiles[i].global_cycle = global_cycle;
			sciFiles[i].data_type = data_type;
			//sciFiles[i].first_record = first_record;
			sciFiles[i].records[0] = first_record;
			sciFiles[i].n_records = 1;
			sciFiles[i].p = p;
			return i;
		}
	}
	return -1;
}

void MmgDeleteSciFile(u32 file_descriptor)
{
	u16 i, ref;
	if(file_descriptor < 0 || file_descriptor >= N_SCI_FILES) {
		print("MmgDeleteSciFile: bad file_descriptor\n\r");
		return;
	}
	//Free DMA buffers behind the file
	for(i=0;i<sciFiles[file_descriptor].n_records;i++) {
		ref = sciFiles[file_descriptor].records[i];
		//xil_printf("%d,", ref);
		if(sciFiles[file_descriptor].data_type == DATA_TYPE_L1) {
			mainBufferDescr.sci_data_l1[ref].is_occupied = 0;
			n_l1_occupied--;
			if(n_l1_occupied < (N_D1_IN_MEM - 100))
				SetPauseForFTP(0);
		}
		else if(sciFiles[file_descriptor].data_type == DATA_TYPE_L3) {
			mainBufferDescr.sci_data_l3[ref].is_occupied = 0;
			n_l3_occupied--;
		}
		else if(sciFiles[file_descriptor].data_type == DATA_TYPE_MPS) {
			mainBufferDescr.sci_data_mps[ref].is_occupied = 0;
			n_mps_occupied--;
		}
	}
	//Delete the file under file_descriptor
	sciFiles[file_descriptor].is_occupied = 0;
	sciFiles[file_descriptor].n_records = 0;

	//print("\n\r");
}

u16 MmgIncr_n_records(u32 file_descriptor, u16 record)
{
	if(file_descriptor < 0 || file_descriptor >= N_SCI_FILES) {
		print("MmgIncr_n_records: bad file_descriptor\n\r");
		return 0;
		//TODO:
	}

	sciFiles[file_descriptor].records[sciFiles[file_descriptor].n_records] = record;
	sciFiles[file_descriptor].n_records++;
	return sciFiles[file_descriptor].n_records;
}

char* MmgAlloc(int data_type /*1 or 3*/) // return NULL if not allocated
{
	int i;
	char * p;
	//
	if(data_type == DATA_TYPE_L1) {
		//for(i=0;i<N_D1_IN_MEM;i++) {
			//if(!mainBufferDescr.sci_data_l1[i].is_occupied) {
				i = (last_l1_occupied + 1) % N_D1_IN_MEM;
				mainBufferDescr.sci_data_l1[i].is_occupied = 1;
				n_l1_occupied++;
				mainBufferDescr.sci_data_l1[i].is_finalized = 0;
				last_l1_occupied = i;
				p = (char*)&mainBuffer.sci_data_l1[i].payload.frames[0].pmt[0].raw_data[0];
				//xil_printf("Given for L1 0x%08x(%d) \n\r", p, i);
				return p;
			//}
		//}
	}
	else if(data_type == DATA_TYPE_L3) {
		for(i=0;i<N_D3_IN_MEM;i++) {
			if(!mainBufferDescr.sci_data_l3[i].is_occupied) {
				mainBufferDescr.sci_data_l3[i].is_occupied = 1;
				n_l3_occupied++;
				mainBufferDescr.sci_data_l3[i].is_finalized = 0;
				last_l3_occupied = i;
				p = (char*)&mainBuffer.sci_data_l3[i].payload.frames[0].pmt[0].data[0];
				//p = (char*)&mainBuffer.sci_data_l3[i].payload.int32_data[0][0];
				//xil_printf("Given for L3 0x%08x(%d) \n\r", p, i);
				return p;
			}
		}
	}
	else if(data_type == DATA_TYPE_MPS) {
		for(i=0;i<N_MPS_IN_MEM;i++) {
			if(!mainBufferDescr.sci_data_mps[i].is_occupied) {
				mainBufferDescr.sci_data_mps[i].is_occupied = 1;
				n_mps_occupied++;
				mainBufferDescr.sci_data_mps[i].is_finalized = 0;
				last_mps_occupied = i;
				p = (char*)&mainBuffer.sci_data_mps[i].payload.data[0];
				//xil_printf("Given for MPS 0x%08x(%d) \n\r", p, i);
				return p;
			}
		}
	}
	//}
	print("Wrong data type\n\r");
	return NULL;
}

u32 MmgGetFileSize(int mmg_file_descriptor)
{
	if(sciFiles[mmg_file_descriptor].data_type == DATA_TYPE_L1) {
		return sciFiles[mmg_file_descriptor].n_records * sizeof(Z_DATA_TYPE_SCI_L1_V7);
	}
	else if(sciFiles[mmg_file_descriptor].data_type == DATA_TYPE_L3) {
		return sciFiles[mmg_file_descriptor].n_records * sizeof(Z_DATA_TYPE_SCI_L3_V3);
	}
	else if(sciFiles[mmg_file_descriptor].data_type == DATA_TYPE_MPS) {
		return sciFiles[mmg_file_descriptor].n_records * sizeof(Z_DATA_TYPE_SCI_MPS_V1);
	}
	print("Wrong data type\n\r");
	return -1;
}

INTPTR MmgGetP(int data_type)
{
	if(data_type == DATA_TYPE_L1)
		return (INTPTR)&mainBuffer.sci_data_l1[last_l1_occupied].payload.frames[0].pmt[0].raw_data[0];
	else if(data_type == DATA_TYPE_L3)
		//return (INTPTR)&mainBuffer.sci_data_l3[last_l3_occupied].payload.int32_data[0][0];
		return (INTPTR)&mainBuffer.sci_data_l3[last_l3_occupied].payload.frames[0].pmt[0].data[0];
	else if(data_type == DATA_TYPE_MPS)
		//return (INTPTR)&mainBuffer.sci_data_l3[last_l3_occupied].payload.int32_data[0][0];
		return (INTPTR)&mainBuffer.sci_data_mps[last_mps_occupied].payload.data[0];
	else {
		print("MmgGetP: No such data_type\n\r");
		return (INTPTR)NULL;
	}
}

void MmgFinish(int data_type, u32 n_gtu, u32 unix_time, u32 trig_type, u32 glob_cycle, u32 n_internal_l1)
{
	//u32 run_cycle = n_gtu / N_FRAMES_PER_LIFECYCLE;
	//static last_run_cycle = 0;
	u16 n_records;
	//print("=");
	char* p;
	u32 l3_mmg_sci_file_id, l3_sci_file_id, file_size;
	if(data_type == DATA_TYPE_L1) {

		if((last_l1_occupied < 0) | (last_l1_occupied >= N_D1_IN_MEM)) {
			print("MmgFinish: bad last_l1_occupied\n\r");
			return;
		}
		mainBuffer.sci_data_l1[last_l1_occupied].payload.ZB_number = instrumentState.ZB_number;
		mainBuffer.sci_data_l1[last_l1_occupied].payload.trig_type = trig_type;
		mainBuffer.sci_data_l1[last_l1_occupied].payload.ts.n_gtu = n_gtu;
		mainBuffer.sci_data_l1[last_l1_occupied].payload.ts.unix_time = unix_time;
		mainBuffer.sci_data_l1[last_l1_occupied].payload.internal_event_counter = n_internal_l1;
		mainBuffer.sci_data_l1[last_l1_occupied].payload.event_counter = ClkbGetCntExtTrig();
		mainBuffer.sci_data_l1[last_l1_occupied].nActive = (u16)(Get_L1_nActive());
		mainBuffer.sci_data_l1[last_l1_occupied].fw_version_int = GetFW_version_int();

		//xil_printf("last_l1_occupied=%d unix_time=%d\n\r", last_l1_occupied, unix_time);
		mainBuffer.sci_data_l1[last_l1_occupied].zbh.header = BuildHeader(DATA_TYPE_SCI_L1, VER_Z_DATA_TYPE_SCI_L1);
		mainBuffer.sci_data_l1[last_l1_occupied].zbh.payload_size = sizeof(DATA_TYPE_SCI_L1_V6);
		//mainBuffer.sci_data_l1[last_l1_occupied].crc32 = crc_32((unsigned char*)&mainBuffer.sci_data_l1[last_l1_occupied].zbh.header, sizeof(DATA_TYPE_SCI_L1_V6)-4, 0xFFFFFFFF);
		mainBufferDescr.sci_data_l1[last_l1_occupied].is_finalized = 1;
		Xil_DCacheInvalidateRange((INTPTR)&mainBuffer.sci_data_l1[last_l1_occupied].payload.frames[0].pmt[0].raw_data[0], N_OF_PIXELS_TOTAL*N_OF_FRAMES_D1_V0);
		p = (char*)&mainBuffer.sci_data_l1[last_l1_occupied];

		//if(/*(glob_cycle != last_global_cycle) ||  */(last_l1_occupied == 0) || (last_file_closed == 1)) {
		if((last_l1_occupied % MAX_PACKETS_L1 == 0) ||  (last_l1_occupied == 0) || (last_file_closed == 1)) {
			last_file_closed = 0;
			file_size=MmgGetFileSize(last_mmg_file_descriptor);
			CloseFile(last_file_descriptor, file_size);
			//xil_printf("File closed (size=%d)\n\r", file_size);
			last_mmg_file_descriptor = MmgCreateSciFile(data_type, glob_cycle, p, last_l1_occupied);
			if(last_mmg_file_descriptor != -1) {
				last_file_descriptor = CreateSciFile(p, 0, unix_time, data_type, last_mmg_file_descriptor);
				//print("New file created\n\r");
			}
		}
		else {
			MmgIncr_n_records(last_mmg_file_descriptor, last_l1_occupied);
		}
		last_global_cycle = glob_cycle;
	}
	else if(data_type == DATA_TYPE_L3) {
		if((last_l3_occupied < 0) | (last_l3_occupied >= N_D3_IN_MEM)) {
			print("MmgFinish: bad last_l3_occupied\n\r");
			return;
		}
		mainBuffer.sci_data_l3[last_l3_occupied].payload.ZB_number = instrumentState.ZB_number;
		mainBuffer.sci_data_l3[last_l3_occupied].payload.trig_type = trig_type;
		mainBuffer.sci_data_l3[last_l3_occupied].payload.ts.n_gtu = n_gtu;
		mainBuffer.sci_data_l3[last_l3_occupied].payload.ts.unix_time = unix_time;
		mainBuffer.sci_data_l3[last_l3_occupied].zbh.header = BuildHeader(DATA_TYPE_SCI_L3, VER_Z_DATA_TYPE_SCI_L3);
		mainBuffer.sci_data_l3[last_l3_occupied].zbh.payload_size = sizeof(DATA_TYPE_SCI_L3_V3);
		mainBufferDescr.sci_data_l3[last_l3_occupied].is_finalized = 1;
		//Xil_DCacheInvalidateRange((INTPTR)&mainBuffer.sci_data_l3[last_l3_occupied].payload.int32_data[0][0], 4*N_OF_PIXELS_TOTAL*N_D3_PER_FILE);
		Xil_DCacheInvalidateRange((INTPTR)&mainBuffer.sci_data_l3[last_l3_occupied].payload.frames[0].pmt[0].data[0], 4*N_OF_PIXELS_TOTAL*N_D3_PER_FILE);
		p=(char*)&mainBuffer.sci_data_l3[last_l3_occupied];//.payload.frames[0];
		if(is_d3_files == WITH_D3_FILES)
		{
			l3_mmg_sci_file_id = MmgCreateSciFile(data_type, glob_cycle, p, last_l3_occupied);
			if(l3_mmg_sci_file_id != -1) {
				l3_sci_file_id=CreateSciFile(p, MmgGetFileSize(l3_mmg_sci_file_id), unix_time, data_type, l3_mmg_sci_file_id);
				CloseFile(l3_sci_file_id, MmgGetFileSize(l3_mmg_sci_file_id));
			}
		}
	}
	else if(data_type == DATA_TYPE_MPS) {
		if((last_mps_occupied < 0) | (last_mps_occupied >= N_MPS_IN_MEM)) {
			print("MmgFinish: bad last_mps_occupied\n\r");
			return;
		}
		mainBuffer.sci_data_mps[last_mps_occupied].payload.ZB_number = instrumentState.ZB_number;
		mainBuffer.sci_data_mps[last_mps_occupied].payload.ts.n_gtu = n_gtu;
		mainBuffer.sci_data_mps[last_mps_occupied].payload.ts.unix_time = unix_time;
		mainBuffer.sci_data_mps[last_mps_occupied].zbh.header = BuildHeader(DATA_TYPE_SCI_MPS, VER_Z_DATA_TYPE_SCI_MPS_V1);
		mainBuffer.sci_data_mps[last_mps_occupied].zbh.payload_size = sizeof(DATA_TYPE_SCI_L1_V6);
		mainBufferDescr.sci_data_l1[last_mps_occupied].is_finalized = 1;
		Xil_DCacheInvalidateRange((INTPTR)&mainBuffer.sci_data_mps[last_mps_occupied].payload.data[0], 4*N_OF_PIXEL_PER_PDM/4);
		p = (char*)&mainBuffer.sci_data_mps[last_mps_occupied];
		if(glob_cycle != last_global_cycle) {
			file_size=MmgGetFileSize(last_mmg_file_descriptor);
			CloseFile(last_file_descriptor, file_size);
			//xil_printf("File closed (size=%d)\n\r", file_size);
			last_mmg_file_descriptor = MmgCreateSciFile(data_type, glob_cycle, p, last_mps_occupied);
			if(last_mmg_file_descriptor != -1) {
				last_file_descriptor = CreateSciFile(p, 0, unix_time, data_type, last_mmg_file_descriptor);
				//print("New file created\n\r");
			}
		}
		else {
			MmgIncr_n_records(last_mmg_file_descriptor, last_mps_occupied);
		}
		last_global_cycle = glob_cycle;
	}
}

void MmgCloseLastD1File()
{
	u32 file_size;
	if(sciFiles[last_mmg_file_descriptor].n_records > 0) {
		file_size=MmgGetFileSize(last_mmg_file_descriptor);
		CloseFile(last_file_descriptor, file_size);
		//xil_printf("File closed (size=%d)\n\r", file_size);
	}
	else {
		print("No records in the opened file. Nothing to close.\n\r");
	}
	mainBufferDescr.sci_data_l1[last_l1_occupied].is_occupied = 0;
	last_l1_occupied--;
	last_file_closed = 1;
}

void MmgPrintFiles()
{
	int i;
	print("sciFiles:\n\r");
	for(i=0;i<N_SCI_FILES;i++) {
		if(sciFiles[i].is_occupied)
			xil_printf("%d. p=0x%x, type=%d, global_cycle=%d, n_record=%d\n\r",
					i, sciFiles[i].p, sciFiles[i].data_type, sciFiles[i].global_cycle, sciFiles[i].n_records);
	}

}

u32 Get_n_occupied(int data_type)
{
	if(data_type == DATA_TYPE_L1)
		return n_l1_occupied;
	else if(data_type == DATA_TYPE_L3)
		return n_l3_occupied;
	else if(data_type == DATA_TYPE_MPS)
		return n_mps_occupied;
	else
		print("Get_n_occupied: No such data_type\n\r");
	return 0;
}

void SetScurveAdditionalData(u16 start, u16 step, u16 end)
{
	mainBuffer.sci_data_l3[last_l3_occupied].payload.dac10_start = start;
	mainBuffer.sci_data_l3[last_l3_occupied].payload.dac10_step = step;
	mainBuffer.sci_data_l3[last_l3_occupied].payload.dac10_end = end;
}

void MmgPrint1stD3()
{
	int i,j;
	for(i=0;i<N_OF_PMT_PER_ECASIC * N_OF_ECASIC_PER_PDM;i++) {
		for(j=0;j<N_OF_COMMON_PIXELS;j++) {
			xil_printf("%d ", (*(u32*)(DMA_GetP()+4*(i*N_OF_COMMON_PIXELS+j)))/50000);
		}
		//print("\n\r");
	}
	Xil_DCacheInvalidateRange(DMA_GetP(), 2880*4);
}


