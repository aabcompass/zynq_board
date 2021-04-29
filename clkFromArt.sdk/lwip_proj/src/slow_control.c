/*
 * slow_control.c
 *
 *  Created on: Nov 13, 2016
 *      Author: alexander
 */


#include "slow_control.h"
#include "xparameters.h"
#include "common.h"
#include "dma_handling.h"
#include "data_provider.h"

SLOWCTRL_SP3_36CHIPS_REFORMATTED_V1 reformatted;
SLOWCTRL_SP3_ALL_ASIC_V1 sc_sp3_all_asic_test;
SLOWCTRL_SP3_SAME_ASIC_V1 slowctrl_samedata;
SLOWCTRL_SP3_ALL_ASIC_USER_V0 ind_slowctrl_userdata;

u32 current_line=0, current_asic=0, current_pixel=0;
u32 current_common_thr = 0;
u32 scurve_wait_cnt = 0;

void SetDefaultSCParameters()
{
	slowctrl_samedata.misc_reg0 = 0x0FA20007;
	slowctrl_samedata.x2_tst_msk_dac = 0x00C000C0;
	//slowctrl_samedata.x2_tst_msk_dac = 0x00000000;
	slowctrl_samedata.misc_reg1 = 0x00000000;
	slowctrl_samedata.x4_gain = 0x00000000;
	slowctrl_samedata.x4_dac_7b_sub = 0x00000000;
	slowctrl_samedata.misc_reg2 = 0x00000000;
}

void SetDefaultIndSCParameters()
{
	int i,j,k;
	for (i=0;i<N_OF_ECASIC_PER_PDM;i++)
	{
		for(j=0;j<N_OF_PMT_PER_ECASIC;j++)
		{
			ind_slowctrl_userdata.slowctrl_sp3_sgl_asic[j][i].dac10bit = DAC10_NOISY_VALUE;
			for(k=0;k<N_OF_PIXELS_PER_PMT;k++)
			{
				ind_slowctrl_userdata.slowctrl_sp3_sgl_asic[j][i].dac7bit[k] = DAC7_DEFAULT_VALUE;
				ind_slowctrl_userdata.slowctrl_sp3_sgl_asic[j][i].pixel_mask[k] = 1;
			}
		}
	}
}

void PrintReformattedData()
{
	char* p;
	int i;
	p = (char*)&reformatted;
	for(i=0;i<sizeof(reformatted);i++)
	{
		if(!(i%32)) print("\n\r");
		xil_printf("%02x ", p[i]);
	}

}

void SetIndSCCurrentLine(u32 line)
{
	current_line = line;
}

u32 GetIndSCCurrentLine()
{
	return current_line;
}

void SetIndSCCurrentAsic(u32 asic)
{
	current_asic = asic;
}

u32 GetIndSCCurrentAsic()
{
	return current_asic;
}

void SetIndSCCurrentPixel(u32 pixel)
{
	current_pixel = pixel;
}

u32 GetIndSCCurrentPixel()
{
	return current_pixel;
}

void SetIndSCDac10( u32 dac10)
{
	ind_slowctrl_userdata.slowctrl_sp3_sgl_asic[current_asic][current_line].dac10bit = dac10;
}

void SetIndSCDac7(u32 dac7)
{
	ind_slowctrl_userdata.slowctrl_sp3_sgl_asic[current_asic][current_line].dac7bit[current_pixel] = dac7;
}

void SetIndSCPixelMask(u32 pixel_mask)
{
	ind_slowctrl_userdata.slowctrl_sp3_sgl_asic[current_asic][current_line].pixel_mask[current_pixel] = pixel_mask;
}

u32 GetIndSCDac10()
{
	return ind_slowctrl_userdata.slowctrl_sp3_sgl_asic[current_asic][current_line].dac10bit;
}

u32 GetIndSCDac7()
{
	return ind_slowctrl_userdata.slowctrl_sp3_sgl_asic[current_asic][current_line].dac7bit[current_pixel];
}

u32 GetIndSCPixelMask()
{
	return ind_slowctrl_userdata.slowctrl_sp3_sgl_asic[current_asic][current_line].pixel_mask[current_pixel];
}

void SendUserIndSCSettingsToSp3()
{
	int i, j, k;
	u32 s_value, dac10_value, dac7_value, c_pixel;
	memset((char*)&sc_sp3_all_asic_test, 0, sizeof(sc_sp3_all_asic_test));
	for(i=0;i<N_OF_ECASIC_PER_PDM;i++)
	{
		for(j=0;j<N_OF_PMT_PER_ECASIC;j++)
		{
			//dac_value = 512;//100*chip;//(25*(j+i*6));
			s_value = 0;
			dac10_value = ind_slowctrl_userdata.slowctrl_sp3_sgl_asic[j][i].dac10bit;
			sc_sp3_all_asic_test.slowctrl_sp3_sgl_asic[j][i].misc_reg0 = 0x0FA20007 | dac10_value<<7 | s_value<<3;
			sc_sp3_all_asic_test.slowctrl_sp3_sgl_asic[j][i].misc_reg1 = 0x00000000;
			sc_sp3_all_asic_test.slowctrl_sp3_sgl_asic[j][i].misc_reg2 = 0x00000000;
			xil_printf("chip=%d, line=%d, dac10_value=%d\n\r", j, i, dac10_value);
			for(k=0;k<N_OF_PIXELS_PER_PMT;k++)
			{
				c_pixel = ind_slowctrl_userdata.slowctrl_sp3_sgl_asic[j][i].pixel_mask[k];
				dac7_value = ind_slowctrl_userdata.slowctrl_sp3_sgl_asic[j][i].dac7bit[k];
				sc_sp3_all_asic_test.slowctrl_sp3_sgl_asic[j][i].tst_msk_dac[k] = dac7_value | (c_pixel<<7);
				//xil_printf("\t pixel=%d, dac7_value=%d\n\r", k, dac7_value);
			}
		}
	}
	ReformatSlowControlData(&sc_sp3_all_asic_test);
	//PrintReformattedData();
	LoadIndividualDataToSlowControl();
}

void SendTestSettingsToSp3(u32 dac_value, u32 c_pixel)
{
	int chip, line, pixel;
	u32 s_value;
	memset((char*)&sc_sp3_all_asic_test, 0, sizeof(sc_sp3_all_asic_test));
	for(chip=0;chip<6;chip++)
	{
		for(line=0;line<6;line++)
		{
			//dac_value = 512;//100*chip;//(25*(j+i*6));
			s_value = 0;
			sc_sp3_all_asic_test.slowctrl_sp3_sgl_asic[chip][line].misc_reg0 = 0x0FA20007 | dac_value<<7 | s_value<<3;
			sc_sp3_all_asic_test.slowctrl_sp3_sgl_asic[chip][line].misc_reg1 = 0x00000000;
			sc_sp3_all_asic_test.slowctrl_sp3_sgl_asic[chip][line].misc_reg2 = 0x00000000;
			for(pixel=0;pixel<64;pixel++)
				sc_sp3_all_asic_test.slowctrl_sp3_sgl_asic[chip][line].tst_msk_dac[pixel] = 0x0040 | ((pixel!=c_pixel)<<7);
				//sc_sp3_all_asic_test.slowctrl_sp3_sgl_asic[chip][line].tst_msk_dac[pixel] = 0x0040 | ((1)<<7);
			xil_printf("chip=%d, line=%d, dac_value=%d\n\r", chip, line, dac_value);
		}
		sc_sp3_all_asic_test.slowctrl_sp3_sgl_asic[chip][line].tst_msk_dac[10] = 0x01C0;
	}
	ReformatSlowControlData(&sc_sp3_all_asic_test);
	//PrintReformattedData();
	LoadIndividualDataToSlowControl();
}


void ReformatSlowControlData(SLOWCTRL_SP3_ALL_ASIC_V1* slowctrl_sp3_all_asic_v1)
{
	int i, i_remap, j, k;
	int chips_remap_table[] = {4, 2, 0, 1, 3, 5};
	for(i=0;i<N_OF_PMT_PER_ECASIC;i++)
	{
		i_remap = chips_remap_table[i];
		for(j=0;j<N_OF_ECASIC_PER_PDM;j++)
		{
			reformatted.slowctrl_sp3_6chips_reformatted[i].misc_reg0[j] =
					slowctrl_sp3_all_asic_v1->slowctrl_sp3_sgl_asic[i_remap][j].misc_reg0;
		}
		for(j=0;j<N_OF_ECASIC_PER_PDM;j++)
		{
			for(k=0;k<N_OF_PIXELS_PER_PMT/2;k++)
			{
				reformatted.slowctrl_sp3_6chips_reformatted[i].x2_tst_msk_dac[k][j] =
					slowctrl_sp3_all_asic_v1->slowctrl_sp3_sgl_asic[i_remap][j].tst_msk_dac[63 - (2*k+0)] << 16 |
					slowctrl_sp3_all_asic_v1->slowctrl_sp3_sgl_asic[i_remap][j].tst_msk_dac[63 - (2*k+1)];
			}
		}
		for(j=0;j<N_OF_ECASIC_PER_PDM;j++)
		{
			reformatted.slowctrl_sp3_6chips_reformatted[i].misc_reg1[j] =
					slowctrl_sp3_all_asic_v1->slowctrl_sp3_sgl_asic[i_remap][j].misc_reg1;
		}
		for(j=0;j<N_OF_ECASIC_PER_PDM;j++)
		{
			for(k=0;k<N_OF_PIXELS_PER_PMT/4;k++)
			{
				reformatted.slowctrl_sp3_6chips_reformatted[i].x4_gain[k][j] =
					slowctrl_sp3_all_asic_v1->slowctrl_sp3_sgl_asic[i_remap][j].gain[63 - (4*k+0)] << 24 |
					slowctrl_sp3_all_asic_v1->slowctrl_sp3_sgl_asic[i_remap][j].gain[63 - (4*k+1)] << 16 |
					slowctrl_sp3_all_asic_v1->slowctrl_sp3_sgl_asic[i_remap][j].gain[63 - (4*k+2)] << 8 |
					slowctrl_sp3_all_asic_v1->slowctrl_sp3_sgl_asic[i_remap][j].gain[63 - (4*k+3)];
			}
		}
		for(j=0;j<N_OF_ECASIC_PER_PDM;j++)
		{
			for(k=0;k<N_OF_PIXELS_PER_PMT/4/8;k++)
			{
				reformatted.slowctrl_sp3_6chips_reformatted[i].x4_dac_7b_sub[k][j] =
					slowctrl_sp3_all_asic_v1->slowctrl_sp3_sgl_asic[i_remap][j].dac_7b_sub[8 - (4*k+0)] << 24 |
					slowctrl_sp3_all_asic_v1->slowctrl_sp3_sgl_asic[i_remap][j].dac_7b_sub[8 - (4*k+1)] << 16 |
					slowctrl_sp3_all_asic_v1->slowctrl_sp3_sgl_asic[i_remap][j].dac_7b_sub[8 - (4*k+2)] << 8 |
					slowctrl_sp3_all_asic_v1->slowctrl_sp3_sgl_asic[i_remap][j].dac_7b_sub[8 - (4*k+3)];
			}
		}
		for(j=0;j<N_OF_ECASIC_PER_PDM;j++)
		{
			reformatted.slowctrl_sp3_6chips_reformatted[i].misc_reg2[j] =
					slowctrl_sp3_all_asic_v1->slowctrl_sp3_sgl_asic[i_remap][j].misc_reg2;
		}
	}
}

void LoadSameDataToSlowControl(SLOWCTRL_SP3_SAME_ASIC_V1* data)
{
	*(u32*)(XPAR_SPACIROC3_SC_0_BASEADDR + 4*REGW_SLOWCTRL_GENERALREG_0) = data->misc_reg0;
	*(u32*)(XPAR_SPACIROC3_SC_0_BASEADDR + 4*REGW_SLOWCTRL_GENERALREG_1) = data->x2_tst_msk_dac;
	*(u32*)(XPAR_SPACIROC3_SC_0_BASEADDR + 4*REGW_SLOWCTRL_GENERALREG_2) = data->misc_reg1;
	*(u32*)(XPAR_SPACIROC3_SC_0_BASEADDR + 4*REGW_SLOWCTRL_GENERALREG_3) = data->x4_gain;
	*(u32*)(XPAR_SPACIROC3_SC_0_BASEADDR + 4*REGW_SLOWCTRL_GENERALREG_4) = data->x4_dac_7b_sub;
	*(u32*)(XPAR_SPACIROC3_SC_0_BASEADDR + 4*REGW_SLOWCTRL_GENERALREG_5) = data->misc_reg2;
	*(u32*)(XPAR_SPACIROC3_SC_0_BASEADDR + 4*REGW_SLOWCTRL_CONFIG) = (1<<BIT_IS_SAME_DATA) | (1<<BIT_USER_LED) | (1<<BIT_SELECT_DIN);// | (1<<BIT_EN_SR_RSTB_PC);
	*(u32*)(XPAR_SPACIROC3_SC_0_BASEADDR + 4*REGW_SLOWCTRL_CONTROLREG) = (1<<BIT_START);
	*(u32*)(XPAR_SPACIROC3_SC_0_BASEADDR + 4*REGW_SLOWCTRL_CONTROLREG) = 0;
}

void LoadSameDataToSlowControl2(u32 current_dac_value)
{
	u32 s_value=0, i;
	slowctrl_samedata.misc_reg0 = (0x0FF20C87 | current_dac_value<<7 | s_value<<3); //0x07A20007 was in Mini
	slowctrl_samedata.x4_gain = 0x10101010;
	slowctrl_samedata.x4_dac_7b_sub = 0x18181818;
	slowctrl_samedata.misc_reg2 = 0x3B;
	LoadSameDataToSlowControl(&slowctrl_samedata);
	for(i=0;i<1000000;i++);
}

void LoadIndividualDataToSlowControl()
{
	TxFIFOSendSC((char*)&reformatted, sizeof(reformatted)/4);
	*(u32*)(XPAR_SPACIROC3_SC_0_BASEADDR + 4*REGW_SLOWCTRL_CONFIG) = (1<<BIT_USER_LED) | (1<<BIT_SELECT_DIN);// | (1<<BIT_EN_SR_RSTB_PC);
	*(u32*)(XPAR_SPACIROC3_SC_0_BASEADDR + 4*REGW_SLOWCTRL_CONTROLREG) = (1<<BIT_START);
	*(u32*)(XPAR_SPACIROC3_SC_0_BASEADDR + 4*REGW_SLOWCTRL_CONTROLREG) = 0;
}

void ResetSPACIROC3()
{
	*(u32*)(XPAR_SPACIROC3_SC_0_BASEADDR + 4*REGW_SLOWCTRL_RESETREG) = (1<<BIT_RESET);
	*(u32*)(XPAR_SPACIROC3_SC_0_BASEADDR + 4*REGW_SLOWCTRL_RESETREG) = 0;
}

void ResetSPACIROC3_fifo_rb()
{
	*(u32*)(XPAR_SPACIROC3_SC_0_BASEADDR + 4*REGW_SLOWCTRL_RESETREG) = (1<<BIT_SLOWCTRL_RESET_FIFO_RB);
	*(u32*)(XPAR_SPACIROC3_SC_0_BASEADDR + 4*REGW_SLOWCTRL_RESETREG) = 0;
}

void Receive_RB(char* ptr)
{
	RxReceive(ptr);
}

u32 RetSCState()
{
	return *(u32*)(XPAR_SPACIROC3_SC_0_BASEADDR + 4*REGW_SLOWCTRL_STATUS);
}

//void RB_inject_bit()
//{
//	*(u32*)(XPAR_SPACIROC3_SC_0_BASEADDR + 4*REGW_SLOWCTRL_CMD) |= (1<<BIT_SLOWCTRL_INJECT_BIT);
//	*(u32*)(XPAR_SPACIROC3_SC_0_BASEADDR + 4*REGW_SLOWCTRL_CMD) &= ~(1<<BIT_SLOWCTRL_INJECT_BIT);
//}

static enum  {
	no_state,
	start_scurve,
	change_thr,
	wait_thr_state,
	start_dma1,
	start_dma2,
	pass_data,
	wait_pass_state1,
	wait_pass_state2,
	condition_state,
	end_state
} scurve_sm_state = no_state;

void scurve_sm()
{
	u32 ret;
	switch(scurve_sm_state)
	{
		case no_state:
			scurve_wait_cnt = 0;
			break;
		case start_scurve:
			current_common_thr = 0;
			Set_n_d3_per_file(N_D3_PER_FILE);
			scurve_sm_state = change_thr;
			break;
		case change_thr:
			LoadSameDataToSlowControl2(current_common_thr);
			xil_printf("\n\rdac=%d ", current_common_thr);
			scurve_sm_state = wait_thr_state;
			break;
		case wait_thr_state:
			if(scurve_wait_cnt > 100) {/*10 ms*/
				if(current_common_thr%N_D3_PER_FILE == 0)
					scurve_sm_state = start_dma1;
				else
					scurve_sm_state = pass_data;
				scurve_wait_cnt = 0;
			}
			else {
				scurve_wait_cnt++;
				print("*");
			}
			break;
		case start_dma1:
			if(current_common_thr>0) {
				ret = Is_D3_received();
				xil_printf("ret=%d ", ret);
				if(ret)
					scurve_sm_state = start_dma2;
			}
			else {
				scurve_sm_state = start_dma2;
			}
			break;
		case start_dma2:
			if(current_common_thr == 1000) {
				Set_n_d3_per_file(24);
				L3Start(FINITE, 24);
			}
			else if(current_common_thr%N_D3_PER_FILE == 0) {
				//xil_printf("Is_D3_received()=%d", Is_D3_received());
				Set_n_d3_per_file(N_D3_PER_FILE);
				L3Start(FINITE, N_D3_PER_FILE);
			}
			ScurveAdderReInit();
			scurve_sm_state = pass_data;
			break;
		case pass_data:
			StartDataProviderFor1D3frame(GetIntegration());
			scurve_sm_state = wait_pass_state1;
			break;
		case wait_pass_state1:
			print("!");
			if(IsDataProviderPass())
				scurve_sm_state = wait_pass_state2;
			break;
		case wait_pass_state2:
			print("\0");
			if(!IsDataProviderPass())
				scurve_sm_state = condition_state;
			break;
		case condition_state:
			if(current_common_thr == NMAX_OF_THESHOLDS) {
				scurve_sm_state = end_state;
			}
			else {
				scurve_sm_state = change_thr;
				current_common_thr++;
			}
			break;
		case end_state:
			scurve_sm_state = no_state;
			break;
	}
}

u32 StartScurve()
{
	if(scurve_sm_state != no_state)
		return -1;
	scurve_sm_state = start_scurve;
	return 0;
}

u32 IsScurveGathering()
{
	if(scurve_sm_state == no_state)
		return 0;
	else
		return 1;
}

u32 GetCurrentTheshold()
{
	return current_common_thr;
}

u32 GetScurveStatus()
{
	return scurve_sm_state;
}
