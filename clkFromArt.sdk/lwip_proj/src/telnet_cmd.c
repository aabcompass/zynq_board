#include "lwip/err.h"
#include "lwip/tcp.h"
//#include "spectral_err.h"
//#include "axi_spectral_core.h"
#include <string.h>
#include "hv.h"
#include "pdmdp_err.h"
//#include "axis_flowctrl_d1.h"
//#include "axis_flowctrl_d2.h"
#include "own_data_types.h"
#include "pdmdata.h"
#include "unix_date_time.h"
#include "dma_handling.h"
#include "common.h"
#include "data_provider.h"
#include "ftp_server.h"
#include "axis_flowctrl_d1.h"
#include "mmg.h"
#include "pdmdata_hw.h"
#include "dma_handling.h"



//SCurveStruct sCurveStruct;
InstrumentState instrumentState;
SystemSettings systemSettings;
//DebugSettings debugSettings;

//u32 live_sent = 0;
//u32* ptr4live;

char err_str[20];

void SendErrorCommand(struct tcp_pcb *tpcb,  int err_code)
{
	sprintf(err_str, "Error %d\n\r", err_code);
	tcp_write(tpcb, err_str, strlen(err_str), 1);
}

//void sent_callback(void *arg, struct tcp_pcb *tpcb, u16_t len)
//{
//	err_t err;
//	if(live_sent == 0) {
//		err = tcp_write(tpcb, (DMA_GetP() + (4 * N_OF_PIXELS_TOTAL / 2)), 4 * N_OF_PIXELS_TOTAL / 2, 1);
//		//xil_printf("!err_t=%d\n\r", err);
//		live_sent = 1;
//	}
//}

int ProcessInstrumentModeCommand(struct tcp_pcb *tpcb, char* param, u32 param2)
{
	if(strcasecmp(param, "d1") == 0) {
		instrumentState.mode = MODE_D1;
		DoFileProcessing(DO_FILE_PROCESSING);
		Set_n_d3_per_file(N_D3_PER_FILE);
		ScurveAdderReInit();
	}
	else if(strcasecmp(param, "d1d3") == 0) {
		instrumentState.mode = MODE_D1D3;
		DoFileProcessing(DO_FILE_PROCESSING);
		Set_n_d3_per_file(N_D3_PER_FILE);
		ScurveAdderReInit();
	}
	else if(strcasecmp(param, "d3") == 0) {
		instrumentState.mode = MODE_D3;
		DoFileProcessing(DO_FILE_PROCESSING);
		Set_n_d3_per_file(N_D3_PER_FILE);
		ScurveAdderReInit();
	}
	else if(strcasecmp(param, "live") == 0) {
		instrumentState.mode = MODE_LIVE;
		DoFileProcessing(NO_FILE_PROCESSING);
		Set_n_d3_per_file(1);
		ScurveAdderReInit();
	}
	else if(strcasecmp(param, "scurve") == 0) {
		instrumentState.mode = MODE_SCURVE;
		DoFileProcessing(DO_FILE_PROCESSING);
		Set_n_d3_per_file(N_D3_PER_FILE);
		ScurveAdderReInit();
	}
	else if(strcasecmp(param, "pixelscan") == 0) {
		instrumentState.mode = MODE_PIXELSCAN;
		DoFileProcessing(DO_FILE_PROCESSING);
		Set_n_d3_per_file(N_D3_PER_FILE);
		ScurveAdderReInit();
	}
	else {
		instrumentState.mode = MODE_NONE;
		char ok_eomess_str[] = "No such mode\n\r";
		tcp_write(tpcb, ok_eomess_str, sizeof(ok_eomess_str), 1);
		return -1;
	}
	if(instrumentState.err_SDcard)
	{
		print("Artix board is absent or bad or artix.bin on SD-card was generated for another Artix type\n\r");
		SendErrorCommand(tpcb, ERR_ARTIX_BOARD + instrumentState.err_SDcard);
	}
	else if(instrumentState.err_artix_bin)
	{
		print("Problems with loading Artix board\n\r");
		SendErrorCommand(tpcb, ERR_ARTIX_BOARD + instrumentState.err_artix_bin);
	}
	else if(instrumentState.artix_locked == 0)
	{
		print("Artix does not give clock\n\r");
		SendErrorCommand(tpcb, ERR_ARTIX_NOT_LOCKED);
	}
	else
	{
		//if(param == 0)
		//	SendHVPSLogToFTP(1);
		//else
		if(instrumentState.mode != MODE_LIVE)
			xil_printf("Removed  all sci data files from FTP server: %d files\n\r", RemoveAllSciDataFilesFromFTP());
		if(instrumentState.mode == MODE_D1 || instrumentState.mode == MODE_D1D3)
			SetModeD1(2);
		SetTime(param2);
		DateTime dateTime;
		convertUnixTimeToDate(param2, &dateTime);
		xil_printf("%s\n\r", formatDate(&dateTime, 0));
		char ok_eomess_str[] = "Ok\n\r";
		tcp_write(tpcb, ok_eomess_str, sizeof(ok_eomess_str), 1);
	}
	return 0;
}


void ProcessTelnetCommands(struct tcp_pcb *tpcb, struct pbuf* p, err_t err)
{
	u8 str_len=0; char reply[128];
	u32 get_len, param, param2, i;
	//u32 param0, param1, param2, param3, param4;
	u64 long_param;
	u8 array_param[15];
	char ans_str[64]; u8 ans_pos;
	char buf[10];
	double double_param, double_param2, double_param3;
	int ret;
	int turn[NUM_OF_HV];
	char mapping[N_OF_PIXELS_PER_PMT];

	u32 clk_cnt0, clk_cnt1, clk_cnt2;

	u32 pmt_trig1,  pmt_trig2,  ec_trig1,  ec_trig2,  pdm_trig1,  pdm_trig2;
	// print command
	print("TCP: ");
	//for(i=0; i<p->len; i++)
	//	xil_printf("%c", *(char*)(p->payload+i));
	print("\r\n");
	if(strncmp(p->payload, "help", 4) == 0)
	{
		char ok_eomess_str[] = "K-EUSO PDM DP console\n\r";
		tcp_write(tpcb, ok_eomess_str, sizeof(ok_eomess_str), 1);
	}
	else if(strncmp(p->payload, TCP_CMD_TEST_CONNECT, 12) == 0)
	{
		char ok_eomess_str[] = "Ok\n\r";
		tcp_write(tpcb, ok_eomess_str, sizeof(ok_eomess_str), 1);
	}
	else if(strncmp(p->payload, TCP_CMD_REBOOT, strlen(TCP_CMD_REBOOT)) == 0)
	{
		//netifSetDown();
		RebootZynq();
		char ok_eomess_str[] = "Ok\n\r";
		tcp_write(tpcb, ok_eomess_str, sizeof(ok_eomess_str), 1);
	}
	else if(strncmp(p->payload, TCP_CMD_INSTR_STATUS, 17) == 0)
	{
		sprintf(reply, "%d %d\n\r", /*GetFTP_bin_State()*/40, instrumentState.mode);
		tcp_write(tpcb, reply, sizeof(reply), 1);
	}
	else if(strncmp(p->payload, TCP_CMD_GET_VER, 14) == 0)
	{
		//char ok_eomess_str[] = "Ok\n\r";
		strcpy(ans_str, __DATE__);
		strcat(ans_str, " ");
		strcat(ans_str, __TIME__);
		strcat(ans_str, " ");
		strcat(ans_str, ZYNQ3_VER_STRING);
		strcat(ans_str, "\r\n");
		tcp_write(tpcb, ans_str, strlen(ans_str), 1);
	}
	else if(strncmp(p->payload, TCP_CMD_ACQ_STOP, 8) == 0)
	{
		StopDataProviderForLive();
		//ResetDataConverter();
		//ResetScurveAdder();
		//InitHLS_peripherals();
		char str[] = "Ok\n\r";
		tcp_write(tpcb, str, sizeof(str), 1);
	}
	else if(strncmp(p->payload, TCP_CMD_ACQ_LIVE, 8) == 0)
	{
		err_t err;
		char * p;
		L3Start(FINITE, 1);
		StartDataProviderFor1D3frame(GetIntegration());
		for(i=0;i<GENERAL_LIVE_TIMEOUT;i++) {
			print("*");
			if(Is_D3_received())
				break;
		}
		p=DMA_GetP();
		xil_printf("p=0x%08x", p);
		err = tcp_write(tpcb, p, 4 * N_OF_PIXELS_TOTAL/8, 1);
		if(err) xil_printf("tcp_write: err = %d\n\r", err);
		err = tcp_output(tpcb);
		if(err) xil_printf("tcp_write: err = %d\n\r", err);
	}
	else if(sscanf(p->payload, TCP_CMD_ACQ_NEXT, &param) == 1)
	{
		err = tcp_write(tpcb, DMA_GetP() + param*(4 * N_OF_PIXELS_TOTAL/8), 4 * N_OF_PIXELS_TOTAL/8, 1);
		if(err) xil_printf("tcp_write: err = %d\n\r", err);
		err = tcp_output(tpcb);
		if(err) xil_printf("tcp_write: err = %d\n\r", err);
	}
	else if(sscanf(p->payload, TCP_CMD_INSTR_SET_INTEGR, &param) == 1)
	{
		xil_printf("Integration set %d\n\r", param);
		if((param == 0) || (param > 65535)) {
			char str[] = "Parameter is out of range. Must be 1..65535\n\r";
			tcp_write(tpcb, str, sizeof(str), 1);
		}
		else {
			SetIntegration(param);
			ScurveAdderReInit();
			char str[] = "Ok\n\r";
			tcp_write(tpcb, str, sizeof(str), 1);
		}
	}
	else if(sscanf(p->payload, TCP_CMD_INSTR_MODE_1PAR, ans_str) == 1)
	{
		if(!instrumentState.is_artix_frame_started) {
			StartDataProviderInitial();
			DataProvEnOutput();
			instrumentState.is_artix_frame_started = 1;
		}
		ProcessInstrumentModeCommand(tpcb, ans_str, 0);
	}
	else if(strncmp(p->payload, TCP_CMD_INSTR_MODE_START, strlen(TCP_CMD_INSTR_MODE_START)) == 0)
	{
		FlowControlStart_D1(1);
		if(instrumentState.mode == MODE_D1) {
			L1Start();
			StartDataProvider();
		}
		else if(instrumentState.mode == MODE_D3) {
			L3Start(INFINITE, N_FRAMES_DMA_D3);
			StartDataProvider();
		}
		else if(instrumentState.mode == MODE_D1D3) {
			L1Start();
			L3Start(INFINITE, N_FRAMES_DMA_D3);
			StartDataProvider();
		}
		else if(instrumentState.mode == MODE_LIVE) {
			char str[] = "The instrument cannot be started in the current mode.\n\r";
			tcp_write(tpcb, str, sizeof(str), 1);
			return;
		}
		else if(instrumentState.mode == MODE_SCURVE) {
			if(Get_n_occupied(DATA_TYPE_L3)==11)
			{
				char str[] = "Not enough memory for two scurves. Retrieve previous, then start new one\n\r";
				tcp_write(tpcb, str, sizeof(str), 1);
				return;
			}
			ret = StartScurve();
			if(ret == -1) {
				char str[] = "Scurve is being gathered\n\r";
				tcp_write(tpcb, str, sizeof(str), 1);
				return;
			}
		}
		else if(instrumentState.mode == MODE_PIXELSCAN) {
			ret = pixelscan_start();
			if(ret == -1) {
				char str[] = "Pixelscan is in progress\n\r";
				tcp_write(tpcb, str, sizeof(str), 1);
				return;
			}

		}
		else {
			char str[] = "Instrument mode is not set\n\r";
			tcp_write(tpcb, str, sizeof(str), 1);
			return;
		}

		char str[] = "Ok\n\r";
		tcp_write(tpcb, str, sizeof(str), 1);
	}
	else if(strncmp(p->payload, TCP_CMD_INSTR_MODE_STOP, strlen(TCP_CMD_INSTR_MODE_STOP)) == 0)
	{
		FlowControlStart_D1(0);
		L1Stop();
		L3Stop();
		char str[] = "Ok\n\r";
		tcp_write(tpcb, str, sizeof(str), 1);
	}
	else if(sscanf(p->payload, TCP_CMD_SLOWCTRL_DAC7_10, &param, &param2) == 2)
	{
		//debugSettings.current_thr = param;
		instrumentState.curr_dac7 = param;
		instrumentState.curr_dac10 = param2;
		xil_printf("curr_dac7=%d, curr_dac10=%d\n\r", instrumentState.curr_dac7, instrumentState.curr_dac10);
		//LoadSameDataToSlowControl3(param, param2);
		PropagateDac7toIndSC(param);
		PropagateDac10toIndSC(param2);
		SendUserIndSCSettingsToSp3();
		char str[] = "Ok\n\r";
		tcp_write(tpcb, str, sizeof(str), 1);
	}
	else if(sscanf(p->payload, TCP_CMD_SLOWCTRL_ALL_DAC, &param) == 1)
	{
		//debugSettings.current_thr = param;
		instrumentState.curr_dac10 = param;
		PropagateDac10toIndSC(param);
		SendUserIndSCSettingsToSp3();
		//LoadSameDataToSlowControl2(param);
		xil_printf("curr_dac10=%d\n\r", instrumentState.curr_dac10);
		char str[] = "Ok\n\r";
		tcp_write(tpcb, str, sizeof(str), 1);
	}
	else if(strncmp(p->payload, TCP_CMD_SLOWCTRL_SC_DAC10, strlen(TCP_CMD_SLOWCTRL_SC_DAC10)) == 0)
	{
		instrumentState.scurve_scan = SCURVE_SCAN_DAC10;
		char str[] = "Ok\n\r";
		tcp_write(tpcb, str, sizeof(str), 1);
	}
	else if(strncmp(p->payload, TCP_CMD_SLOWCTRL_SC_DAC7, strlen(TCP_CMD_SLOWCTRL_SC_DAC7)) == 0)
	{
		instrumentState.scurve_scan = SCURVE_SCAN_DAC7;
		char str[] = "Ok\n\r";
		tcp_write(tpcb, str, sizeof(str), 1);
	}
	else if(sscanf(p->payload, TCP_CMD_SLOWCTRL_LINE, &param) == 1)
	{
		SetIndSCCurrentLine(param);
		char str[] = "Ok\n\r";
		tcp_write(tpcb, str, sizeof(str), 1);
	}
	else if(sscanf(p->payload, TCP_CMD_SLOWCTRL_ASIC, &param) == 1)
	{
		SetIndSCCurrentAsic(param);
		char str[] = "Ok\n\r";
		tcp_write(tpcb, str, sizeof(str), 1);
	}
	else if(sscanf(p->payload, TCP_CMD_SLOWCTRL_PIX, &param) == 1)
	{
		SetIndSCCurrentPixel(param);
		char str[] = "Ok\n\r";
		tcp_write(tpcb, str, sizeof(str), 1);
	}
	else if(sscanf(p->payload, TCP_CMD_SLOWCTRL_DAC10, &param) == 1)
	{
		SetIndSCDac10(param);
		char str[] = "Ok\n\r";
		tcp_write(tpcb, str, sizeof(str), 1);
	}
	else if(sscanf(p->payload, TCP_CMD_SLOWCTRL_DAC7, &param) == 1)
	{
		SetIndSCDac7(param);
		char str[] = "Ok\n\r";
		tcp_write(tpcb, str, sizeof(str), 1);
	}
//	else if(sscanf(p->payload, "slowctrl mask %d", &param) == 1)
//	{
//		//SetIndSCPixelMask(param);
//		u32 pixel = GetIndSCCurrentPixel() + N_OF_PIXELS_PER_PMT*GetIndSCCurrentAsic();
//		u32 line = GetIndSCCurrentLine();
//		LoadPixMaskTst(pixel, line, param);
//		char str[] = "Ok\n\r";
//		tcp_write(tpcb, str, sizeof(str), 1);
//	}
	else if(strncmp(p->payload, TCP_CMD_SLOWCTRL_APPLY, 14) == 0)
	{
		SendUserIndSCSettingsToSp3();
		char str[] = "Ok\n\r";
		tcp_write(tpcb, str, sizeof(str), 1);
	}
	else if(strncmp(p->payload, TCP_CMD_SLOWCTRL_GET_DAC10, 15) == 0)
	{
		sprintf(reply, "%d\n\r", GetIndSCDac10());
		tcp_write(tpcb, reply, strlen(reply), 1);
	}
	else if(strncmp(p->payload, TCP_CMD_SLOWCTRL_GET_DAC7, 14) == 0)
	{
		sprintf(reply, "%d\n\r", GetIndSCDac7());
		tcp_write(tpcb, reply, strlen(reply), 1);
	}
	else if(sscanf(p->payload, TCP_CMD_SLOWCTRL_SET_PAUSE, &param) == 1)
	{
		systemSettings.scurve_delay = param;
		char str[] = "Ok\n\r";
		tcp_write(tpcb, str, sizeof(str), 1);
	}
	else if(strncmp(p->payload, TCP_CMD_SLOWCTRL_G_CUR_TRH, strlen(TCP_CMD_SLOWCTRL_G_CUR_TRH)) == 0)
	{
		param=GetCurrentTheshold();
		sprintf(reply, "%d\n\r", param);
		tcp_write(tpcb, reply, strlen(reply), 1);
	}
	else if(sscanf(p->payload, TCP_CMD_SLOWCTRL_SET_STEP, &param) == 1)
	{
		if(param == 1 || param == 11)	{
			Set_scurve_step(param);
			char str[] = "Ok\n\r";
			tcp_write(tpcb, str, sizeof(str), 1);
			return;
		}
		else {
			char str[] = "Step must be either 1 or 11\n\r";
			tcp_write(tpcb, str, sizeof(str), 1);
			return;
		}
	}
	else if(strncmp(p->payload, TCP_CMD_PIXELSCAN_GET_N, strlen(TCP_CMD_PIXELSCAN_GET_N)) == 0)
	{
		param=pixelscan_get_curr_pixel();
		sprintf(reply, "%d\n\r", param);
		tcp_write(tpcb, reply, strlen(reply), 1);

	}
	else if(sscanf(p->payload, TCP_CMD_PIXELSCAN_SET_N, &param) == 1)
	{
		set_n_of_pixels_scanned(param);
		char str[] = "Ok\n\r";
		tcp_write(tpcb, str, sizeof(str), 1);
	}
	else if(strncmp(p->payload, TCP_CMD_PIXELSCAN_TRG, strlen(TCP_CMD_PIXELSCAN_TRG)) == 0)
	{
		pixelscan_trg();
		char str[] = "Ok\n\r";
		tcp_write(tpcb, str, sizeof(str), 1);
	}
	else if(strncmp(p->payload, TCP_CMD_GTU_1US, 7) == 0)
	{
		RunArtix(1);
		char str[] = "Ok\n\r";
		tcp_write(tpcb, str, sizeof(str), 1);
	}
	else if(strncmp(p->payload, TCP_CMD_GTU_2_5US, 9) == 0)
	{
		RunArtix(0);
		char str[] = "Ok\n\r";
		tcp_write(tpcb, str, sizeof(str), 1);
	}
	else if(strncmp(p->payload, TCP_CMD_HVPS_STATUS_INTR, 21) == 0)
	{
		sprintf(reply, "%d\n\r", GetIntrState());
		tcp_write(tpcb, reply, strlen(reply), 1);
	}
	else if(sscanf(p->payload, TCP_CMD_HVPS_TURNON,
			&turn[0], &turn[1], &turn[2], &turn[3], &turn[4], &turn[5], &turn[6], &turn[7], &turn[8]) == 9)
	{
		if(!instrumentState.is_HVPS_OK)
		{
			print("Additional try to initialize HVPS\n\r");
			instrumentState.is_HVPS_OK = expIni(); //init hv
			if(!instrumentState.is_HVPS_OK)
			{
				print("HVPS seems not connected or powered\n\r");
				SendErrorCommand(tpcb, ERR_HVPS_DISCONN_OR_POWERED);
				return;
			}
		}
		HV_turnON_list(turn);
		//TODO SetupHVPSIntrSystem(getIntcPtr()); This spoil FTP server by unknown reason
		char str[] = "Ok\n\r";
		tcp_write(tpcb, str, sizeof(str), 1);
	}
	else if(sscanf(p->payload, TCP_CMD_HVPS_TURNOFF,
			&turn[0], &turn[1], &turn[2], &turn[3], &turn[4], &turn[5], &turn[6], &turn[7], &turn[8]) == 9)
	{
		char str[] = "Ok\n\r";
		HV_turnOFF_list(turn);
		tcp_write(tpcb, str, sizeof(str), 1);
	}
	else if(sscanf(p->payload, TCP_CMD_HVPS_SETDAC,
			&turn[0], &turn[1], &turn[2], &turn[3], &turn[4], &turn[5], &turn[6], &turn[7], &turn[8]) == 9)
	{
		char str[] = "Ok\n\r";
		setDacValue_list(turn);
		tcp_write(tpcb, str, sizeof(str), 1);
	}
	else if(sscanf(p->payload, TCP_CMD_HVPS_CATHODE,
			&turn[0], &turn[1], &turn[2], &turn[3], &turn[4], &turn[5], &turn[6], &turn[7], &turn[8]) == 9)
	{
		HV_setCathodeVoltage(turn);
		char str[] = "Ok\n\r";
		tcp_write(tpcb, str, sizeof(str), 1);
	}
	else if(strncmp(p->payload, TCP_CMD_HVPS_STATUS_GPIO, 16) == 0)
	{
		HV_getStatus(turn);
		sprintf(reply, "%x %x %x %x %x %x %x %x %x\n\r",
				turn[0], turn[1], turn[2], turn[3], turn[4], turn[5], turn[6], turn[7], turn[8]);
		tcp_write(tpcb, reply, strlen(reply), 1);
	}
	else if(strncmp(p->payload, TCP_CMD_PIXELMAP_TST_ECS, strlen(TCP_CMD_PIXELMAP_TST_ECS)) == 0)
	{
		SetArtixTestMode2(1);
		SetArtixTestMode(0);
		char str[] = "Ok\n\r";
		tcp_write(tpcb, str, sizeof(str), 1);
	}
	else if(strncmp(p->payload, TCP_CMD_PIXELMAP_TST_PIX, strlen(TCP_CMD_PIXELMAP_TST_PIX)) == 0)
	{
		SetArtixTestMode2(0);
		SetArtixTestMode(1);
		char str[] = "Ok\n\r";
		tcp_write(tpcb, str, sizeof(str), 1);
	}
	else if(strncmp(p->payload, TCP_CMD_PIXELMAP_TST_off, strlen(TCP_CMD_PIXELMAP_TST_off)) == 0)
	{
		SetArtixTestMode2(0);
		SetArtixTestMode(0);
		char str[] = "Ok\n\r";
		tcp_write(tpcb, str, sizeof(str), 1);
	}
	else if(sscanf(p->payload, TCP_CMD_ARTIX_LOAD, array_param) == 1)
	{
		ret = 0;
		print("Resetting Artixes...\n\r");
		*(u32*)(XPAR_AXI_GPIO_0_BASEADDR) = 0;
		xil_printf("Loading FW to Artixes with FW file %s\n\r", array_param);
		*(u32*)(XPAR_AXI_GPIO_0_BASEADDR) = 3;
		ret=LoadArtix(array_param);
		ret+=LoadArtix(array_param);
		ret+=LoadArtix(array_param);
		if(ret == 0)
			strcpy(ans_str, "Ok\n\r");
		else
			strcpy(ans_str, "Failed\n\r");
		tcp_write(tpcb, ans_str, strlen(ans_str), 1);
	}
	else if(strncmp(p->payload, TCP_CMD_GET_ARTIX_FILENAME, strlen(TCP_CMD_GET_ARTIX_FILENAME)) == 0)
	{
		tcp_write(tpcb, GetArtixFileName(), strlen(GetArtixFileName()), 1);
	}
	else if(sscanf(p->payload, TCP_CMD_DBG_ARTTRDELAY, &param) == 1)
	{
		SetArtixTransmitDelay(param);
		char str[] = "Ok\n\r";
		tcp_write(tpcb, str, sizeof(str), 1);
	}
	else if(sscanf(p->payload, TCP_CMD_DBG_ARTFRDELAY, &param) == 1)
	{
		SetArtixFracDelay(param);
		char str[] = "Ok\n\r";
		tcp_write(tpcb, str, sizeof(str), 1);
	}
	else if(sscanf(p->payload, TCP_CMD_PIXELMAP_LOAD,
			&mapping[0], &mapping[1], &mapping[2], &mapping[3], &mapping[4], &mapping[5], &mapping[6], &mapping[7],
			&mapping[8], &mapping[9], &mapping[10], &mapping[11], &mapping[12], &mapping[13], &mapping[14], &mapping[15],
			&mapping[16], &mapping[17], &mapping[18], &mapping[19], &mapping[20], &mapping[21], &mapping[22], &mapping[23],
			&mapping[24], &mapping[25], &mapping[26], &mapping[27], &mapping[28], &mapping[29], &mapping[30], &mapping[31],
			&mapping[32], &mapping[33], &mapping[34], &mapping[35], &mapping[36], &mapping[37], &mapping[38], &mapping[39],
			&mapping[40], &mapping[41], &mapping[42], &mapping[43], &mapping[44], &mapping[45], &mapping[46], &mapping[47],
			&mapping[48], &mapping[49], &mapping[50], &mapping[51], &mapping[52], &mapping[53], &mapping[54], &mapping[55],
			&mapping[56], &mapping[57], &mapping[58], &mapping[59], &mapping[60], &mapping[61], &mapping[62], &mapping[63]) == N_OF_PIXELS_PER_PMT)
	{
		SendMapping(mapping);
		char str[] = "Ok\n\r";
		tcp_write(tpcb, str, sizeof(str), 1);
	}
	else if(strncmp(p->payload, TCP_CMD_HVPS_EXIT, 4) == 0 || strncmp(p->payload, "quit", 4) == 0)
	{
		tcp_close(tpcb);
	}
	else if(strncmp(p->payload, TCP_CMD_DBG_ARTCLK_CNT, strlen(TCP_CMD_DBG_ARTCLK_CNT)) == 0)
	{
		GetAux2Data(&clk_cnt0, &clk_cnt1, &clk_cnt2);
		sprintf(reply, "%d %d %d\n\r",
				clk_cnt0, clk_cnt1, clk_cnt2);
		tcp_write(tpcb, reply, strlen(reply), 1);
	}
//
//	{
//		static int called = 0;
//		strcpy(ans_str, "Error 1\n\r");
//		tcp_write(tpcb, ans_str, strlen(ans_str), 1);
//		called = 1;
//	}
}

static err_t recv_callback(void *arg, struct tcp_pcb *tpcb,
                               struct pbuf *p, err_t err)
{
	/* do not read the packet if we are not in ESTABLISHED state */
	//print("b");
	if (!p) {
		tcp_close(tpcb);
		tcp_recv(tpcb, NULL);
		return ERR_OK;
	}

	/* indicate that the packet has been received */
	tcp_recved(tpcb, p->len);

	if(p->len > 2)
		ProcessTelnetCommands(tpcb, p, err);

	/* echo back the payload */
	/* in this case, we assume that the payload is < TCP_SND_BUF */

	/* free the received pbuf */
	pbuf_free(p);

	return ERR_OK;
}

static err_t accept_callback(void *arg, struct tcp_pcb *newpcb, err_t err)
{
	static int connection = 1;
	print("a");

	/* set the receive callback for this connection */
	tcp_recv(newpcb, recv_callback);

	/* just use an integer number indicating the connection id as the
	   callback argument */
	tcp_arg(newpcb, (void*)connection);

	/* increment for subsequent accepted connections */
	connection++;

	//char ok_eomess_str[] = "Mini-EUSO PDM DP console\n\r";
	//tcp_write(newpcb, ok_eomess_str, sizeof(ok_eomess_str), 1);

	return ERR_OK;
}


int start_telnet_cmd()
{
	struct tcp_pcb *pcb;
	err_t err;

	unsigned port = 23; //

	/* create new TCP PCB structure */
	pcb = tcp_new();
	if (!pcb) {
		xil_printf("Error creating PCB. Out of Memory\n\r");
		return -1;
	}

	/* bind to specified @port */
	err = tcp_bind(pcb, IP_ADDR_ANY, port);
	if (err != ERR_OK) {
		xil_printf("Unable to bind to port %d: err = %d\n\r", port, err);
		return -2;
	}

	/* we do not need any arguments to callback functions */
	tcp_arg(pcb, NULL);

	/* listen for connections */
	pcb = tcp_listen(pcb);
	if (!pcb) {
		xil_printf("Out of memory while tcp_listen\n\r");
		return -3;
	}

	/* specify callback to use for incoming connections */
	tcp_accept(pcb, accept_callback);

	xil_printf("TCP commands server started @ port %d\n\r", port);

	return 0;
}

void SetDefaultParameters()
{
	//FillExperimentalData();
	//systemSettings.isPrinting = 0;

//	sCurveStruct.start_dac_value = 0;
//	sCurveStruct.step_dac_value = 5;
//	sCurveStruct.stop_dac_value = 1000;
//	sCurveStruct.accumulation = 10;
//	SetDefaultSCParameters();
	SetDefaultIndSCParameters();

	//instrumentState.mode = INSTRUMENT_MODE_NONE;
	//instrumentState.ftp_files_mode = INSTRUMENT_FTPFILES_CONCAT;
	instrumentState.file_counter_l1 = 0;
	instrumentState.file_counter_l2 = 0;
	instrumentState.file_counter_l3 = 0;
	instrumentState.is_simple_packets = 0;
	instrumentState.mode = MODE_NONE;
	systemSettings.scurve_delay = 10;
	instrumentState.scurve_scan = SCURVE_SCAN_DAC10; //dac10
	//memset(sci_data, 0, sizeof(sci_data)); //moved to mem_alloc()
	instrumentState.is_artix_frame_started = 0;
}

