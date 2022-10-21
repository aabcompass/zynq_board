/*
 * uart.c
 *
 *  Created on: Apr 22, 2019
 *      Author: alx
 */
#include "xil_types.h"
#include "xparameters.h"
#include "common.h"
#include "data_provider.h"
#include "ftp_server.h"
#include "own_data_types.h"
#include "dma_handling.h"
#include "unix_date_time.h"

char tmp_array[10000000];

extern InstrumentState instrumentState;

void ProcessUartCommands(struct netif *netif, char c)
{
	int i, j, k, occupancy;//, cc_fifo_occupancy0, cc_fifo_occupancy1, cc_fifo_occupancy2;
	u16* reg_data;
	u16* p;
	static int num = 8;
	static int ec = 0;
	u32 ReceivedWords;
	u32 clk_cnt0, clk_cnt1, clk_cnt2;
	u32 tvalid_cnt0, tvalid_cnt1, tvalid_cnt2;
	u32 log_data[4];


	if(c == 'd')
	{
		//DmaStart1();
		 //ResetScurveAdder();
		 //InitHLS_peripherals();
		Set_n_d3_per_file(N_D3_PER_FILE);
		SetIntegration(N_INTEGRATION);
		ScurveAdderReInit();
		L3Start(FINITE, N_D3_PER_FILE);
	}
	else if(c == 'A')
	{
		//StartDataProviderFor1D3frame(GetIntegration()*N_D3_PER_FILE);
		TestEC_sig();
		print("TestEC_sig()...\n\r");
	}
	else if(c == '*')
	{
		print("XPAR_AXIS_FLOW_CONTROL_D1_0_BASEADDR:\n\r");
		for(i=0;i<32;i++)
		{
			if(i%4 == 0) print("\n\r");
			xil_printf("%08X ", *(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_0_BASEADDR+4*i));
		}
		print("XPAR_SPACIROC3_SC_0_BASEADDR:\n\r");
		for(i=0;i<32;i++)
		{
			if(i%4 == 0) print("\n\r");
			xil_printf("%08X ", *(u32*)(XPAR_SPACIROC3_SC_0_BASEADDR+4*i));
		}
		print("XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR:\n\r");
		for(i=0;i<64;i++)
		{
			if(i%4 == 0) print("\n\r");
			xil_printf("%08X ", *(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*i));
		}
	}
	else if(c == 's')
	{
		u32 unixtime=1637150895;
		char datetimestr[100];
		convertUnixTimeToDateStr(unixtime, datetimestr);
		xil_printf("datetimestr=%s\n\r", datetimestr);

		xil_printf("GetFTPstate()=%d\n\r", GetFTPstate());
		//xil_printf("GetDataPathSM_state()=%d\n\r", GetDataPathSM_state());
		xil_printf("IsDataProviderPass()=%d\n\r", IsDataProviderPass());
		//xil_printf("GetInstrumentMode()=%d\n\r", GetInstrumentMode());
		xil_printf("instrumentState.file_counter_cc=%d\n\r", instrumentState.file_counter_cc);
		xil_printf("GetIntegration()=%d\n\r", GetIntegration());

		MmgPrintFiles();
		PrintFS();
		DMAStatus();
		//SendMapping();
		ConfTrigger();
		GetAux2Data(&clk_cnt0, &clk_cnt1, &clk_cnt2);
		GetAux3Data(&tvalid_cnt0, &tvalid_cnt1, &tvalid_cnt2);
		xil_printf("clk_cnt0=%d, clk_cnt1=%d, clk_cnt2=%d\n\r", clk_cnt0, clk_cnt1, clk_cnt2);
		xil_printf("tvalid_cnt0=%d, tvalid_cnt1=%d, tvalid_cnt2=%d\n\r", tvalid_cnt0, tvalid_cnt1, tvalid_cnt2);
		xil_printf("Is_D3_received()=%d\n\r", Is_D3_received());
		xil_printf("MPS FIFO occupancy=%d\n\r",  *(u32*)(XPAR_AXI_GPIO_0_BASEADDR+8));
		xil_printf("GetProgramCnt()=%d", GetProgramCnt());
		xil_printf("Get_n_occupied(1)=%d", Get_n_occupied(DATA_TYPE_L1));
	}
	else if(c == 'S')
	{
//		print("DMA reset\n\r");
//		L1Reset();
//		L3Reset();
	}
	else if(c == 'h')
	{
		HV_prnLog();
	}
	else if(c == 'H')
	{
		SendHVPSLogToFTP(0);
	}
	else if(c == 'f')
	{
//		SetArtixFrameOn(1);
	}
	else if(c == 'F')
	{
//		SetArtixFrameOn(0);
	}
	else if(c == '&')
	{
		RebootZynq();
	}
	else if(c == '&')
	{
//		SetArtixAcqOn();
	}
	else if(c == '/')
	{
		ResetSPACIROC3_fifo_rb();
	}
	else if(c == '%')
	{
		//FRB_tlast_on();
		ReceivedWords = 0;
		RxReceiveAll(tmp_array, &ReceivedWords);
		xil_printf("ReceivedWords=%d\n\r", ReceivedWords);
	}
	else if(c == 'i')
	{
		//RB_inject_bit();
		//StartDataProviderInitial();
//		FlowControlTRG();
	}
	else if(c == 'r')
	{
		//SA_restart();
		//ResetScurveAdder(); reinit is required!!
//		StopDataConverter();
//		instrumentState.is_artix_frame_started = 0;
//		ResetDataConverter();
	}
	else if(c == 'p')
	{
		//PrintData_raw();
//		L1_send_Marco_params();
	}
	else if(c == 'P')
	{
//		MmgPrint1stD3();
	}
	else if(c == '+') // artix Gen mode
	{
		num ++;
		xil_printf("num=%d\n\r", num);
	}
	else if(c == '-') // artix Gen mode
	{
		num --;
		xil_printf("num=%d\n\r", num);
	}
	else if(c == 'T') // artix Gen mode
	{
		//SA_set_TestMode(1);
		//SetArtixTestMode(1);
		sntp_request();
	}
	else if(c == 't')
	{
		//SA_set_TestMode(0);
//		SetArtixTestMode(0);
	}
	else if(c == 'W') // artix Gen mode
	{
//		DataProvTestMode(1,  1, 0, 99);
	}
	else if(c == 'w')
	{
//		DataProvTestMode(0, 1, 0, 99);
	}
	else if(c == 'Q') // artix Gen mode
	{
		//SA_set_TestMode(1);
//		SetArtixTestMode2(1);
	}
	else if(c == 'c')
	{
//		SetArtixGTUOn(1);
	}
	else if(c == 'C') // artix Gen mode
	{
//		SetArtixGTUOn(0);
	}
	else if(c == 'q')
	{
		//SA_set_TestMode(0);
//		SetArtixTestMode2(0);
	}
//	else if(c == 'X') // artix Gen mode
//	{
//		StartDataProviderForLive();
//	}
	else if(c == 'x')
	{
//		u32 temp =  ((*(u32*)(XPAR_XADC_WIZ_0_BASEADDR+XSM_TEMP_OFFSET))>>4)*503.975/4096-273;
//		u32 v_int = ((*(u32*)(XPAR_XADC_WIZ_0_BASEADDR+XSM_VCCINT_OFFSET))>>4)*3000/4096;
//		u32 v_aux = ((*(u32*)(XPAR_XADC_WIZ_0_BASEADDR+XSM_VCCAUX_OFFSET))>>4)*3000/4096;
//		u32 v_bram = ((*(u32*)(XPAR_XADC_WIZ_0_BASEADDR+XSM_VBRAM_OFFSET))>>4)*3000/4096;
//		xil_printf("temp=%d, v_int=%d, v_aux=%d, v_bram=%d\n\r", temp, v_int, v_aux, v_bram);
	}
	else if(c == '+')
	{
		num++;
		xil_printf("num=%d\n\r", num);
	}
	else if(c == '-')
	{
		num--;
		xil_printf("num=%d\n\r", num);
	}
	else if(c == 'l')
	{
		GetNextRecordFromFifoLog(log_data);
		xil_printf("0x%08x 0x%08x 0x%08x 0x%08x\n\r", log_data[0], log_data[1], log_data[2], log_data[3]);
	}
	else if(c == 'L')
	{
//		xil_printf("Loading FW to Artixes with FW file %s\n\r", FILENAME_ARTIX_BITSTREAM_1_BOARD);
//		*(u32*)(XPAR_AXI_GPIO_0_BASEADDR) = 3;
//		LoadArtix(FILENAME_ARTIX_BITSTREAM_1_BOARD);
//		LoadArtix(FILENAME_ARTIX_BITSTREAM_1_BOARD);
//		LoadArtix(FILENAME_ARTIX_BITSTREAM_1_BOARD);
	}
	else if(c == 'm')
	{
//		ArtixLatch(0);
	}
	else if(c == 'M')
	{
//		ArtixLatch(7);
	}
	else if(c == 'Y')
	{
//		SetArtixTransmitDelay(num);
	}
	else if(c == 'y')
	{
//		SetArtixFracDelay(num);
	}
	else if(c == 'g')
	{
//		*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS2) |= (1<<BIT_GTU_1US);
	}
	else if(c == 'G')
	{
//		*(u32*)(XPAR_AXI_DATA_PROVIDER_Z3_0_BASEADDR+4*REGW_DATAPROV_FLAGS2) &= ~(1<<BIT_GTU_1US);
	}
}
