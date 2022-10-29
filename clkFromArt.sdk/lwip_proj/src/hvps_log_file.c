/*
 * hvps_log_file.c
 *
 *  Created on: 17 окт. 2022 г.
 *      Author: alx
 */
#include "hv.h"
#include "pdmdata.h"
#include "own_data_types.h"
#include "ftp_server.h"

char hvps_log_file_ftp[sizeof(Z_DATA_TYPE_HVPS_LOG_V1)];
extern InstrumentState instrumentState;
char filename_str[50], datetimestr[50];


void SendHVPSLogToFTP(int mode) //0 - numerical,  1 - HVPS.log
{
	u32 size = HV_getLogFileSize();
	char filename_str[20];
	int ret;
	memset(hvps_log_file_ftp, 0, sizeof(Z_DATA_TYPE_HVPS_LOG_V1));
	memcpy(hvps_log_file_ftp, HV_getLogPtr(), size);
	//DeleteFile("HVPS.log");

	convertUnixTimeToDateStr(GetUnixTime(), datetimestr);
	sprintf(filename_str, FILENAME_HVLOG_FLIGHT, instrumentState.ZB_number,  datetimestr, instrumentState.file_counter_hv++);

	if(mode == 0)
		ret = CreateFile(/*"HVPS.log"*/filename_str, hvps_log_file_ftp, size, 0, file_regular);
	else
		ret = CreateFile("HVPS.log", hvps_log_file_ftp, size, 0, file_regular);

	xil_printf("CreateFile rets %d\n\r", ret);
	HV_clean_log();
	xil_printf("%d HVPS size\n\r", size);
}
