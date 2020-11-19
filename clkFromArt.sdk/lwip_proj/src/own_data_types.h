/*
 * own_data_types.h
 *
 *  Created on: Apr 29, 2019
 *      Author: alx
 */

#include "minieuso_pdmdata.h"

#ifndef SRC_OWN_DATA_TYPES_H_
#define SRC_OWN_DATA_TYPES_H_

typedef struct
{
	u32 current_thr;
	u32 current_pixel;
} DebugSettings;

typedef struct
{
	u32 start_dac_value;
	u32 stop_dac_value;
	u32 step_dac_value;
	u32 accumulation;
	u32 current_dac_value;
	u32 is_scurve_being_gathered;
	u32 scurve_counter;
} SCurveStruct;

typedef struct
{
	u32 mode;
	u32 ftp_files_mode;
	//u32 is_started;
	int file_counter_l1;
	int file_counter_l2;
	int file_counter_l3;
	int file_counter_cc;
	int file_counter_hv;
	u32 artix_locked;
	int is_simple_packets;
	int is_HVPS_OK;
	int err_SDcard; //SD-card error during mount. 0 - OK
	int err_artix_bin; // Error during artix.bin load. 0 - Ok
	int is_artix_loaded;
} InstrumentState;

typedef struct
{
	DATA_TYPE_SCI_ALLTRG_V1 sci_data;
	u32 is_occupied;
} DATA_TYPE_SCI_ALLTRG_RECORD;

typedef struct
{
	u8 flash_state;
	u32 corever;
	u32 toBeReset;
	u32 access_denied;
	u8 severity; // 0 - max;  ... then low
	char device_modelname[12];
	u8 isPrinting;
	u8 no_files;
} SystemSettings;


#endif /* SRC_OWN_DATA_TYPES_H_ */
