/*
 * axis_flowctrl.h
 *
 *  Created on: May 22, 2017
 *      Author: alx
 */
#ifndef SRC_AXIS_FLOWCTRL_H_
#define SRC_AXIS_FLOWCTRL_H_

#include "xbasic_types.h"

#define  	XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR XPAR_AXIS_FLOW_CONTROL_D1_0_BASEADDR

#define REGW_FLAGS					0 /* 3=periodic_trig_en 2=en_algo_trig  1=en_int_trig 0=is_started*/
#define REGW_CLR_FLAGS				1 /* 17=cmd_inject_16_events_d0 16=trig_immediate 7=clr_sink_sm 6=clr_tlast_remover 5=clr_trig_service 4=clr_gtu_cnt 3=restart_intr 2=clr_all 1=clear_error 0=clr_trans_counter*/
#define REGW_TRIG_DELAY				2 /* the delay betweenf trigger event and message about it*/ //trig_delay UNUSED
#define REGW_EDGE_FLAGS				3 /* 2=set_unix_time 1=trig_force 0=release */
#define REGW_D1_FIFO_THR			4 /* fifo_thr in HDL*/
#define REGW_INT_TRIG_GTU_TIME		5 /* Time time for the programmable trigger */
#define REGW_GTUS_PER_CYCLE			6 /* the number of GTUs in one cycles (5s in SPB-2)*/
#define REGW_PERIODIC_TRIG_PERIOD	7 /* Period of periodic trigger (in GTUs)*/
#define REGW_D1_N_GTU_AFTER_TRIG	8 /* num_of_gtus_after_trig in HDL */
#define REGW_NUM_OF_TRIGS_FLAGS2	9 /* 15:0 = number of triggers per cycle 5,24s*/
#define REGW_UNIX_TIME				10
#define REGW_TLAST_REMOVER_PHASE	11 /*not needed in K-EUSO / SPB-2*/
#define REGW_TRIGGER_RELAX_TIME		12 /* must be = 0 */
#define REGW_TUSER_TLAST			13 /*TUSER value when tlast must be = 1*/

#define REGR_FC_SM_STATE			14 /*16=trig_flag 4=pass_intr 3:0=sm_state*/
#define REGR_GTU_CNT				15 /*number of GTU after last GTU counter reset*/
#define REGR_UNIX_TIME				17 /*unix_time counter*/
#define REGR_TRANS_COUNTER			18 /* the number of AXIS transactions after last clr_trans_counter or clr_all */
#define REGR_MAXIS_ALARM			19 /* 0=m_axis_fifo_error if started */
#define REGR_GTU_TIMESTAMP			20 /*GTU counter timestamp*/
#define REGR_TRIG_TYPE				21 /*3:0=TRIGGER_TYPES*/
#define REGR_UNIX_TIMESTAMP			22 /*unix_timestamp*/
#define REGR_MAXIS_TRANS_CNT		23
#define REGR_MAXIS_ACCEPTED_CNT		24
#define REGR_TRIG_INTERNAL_CNT		25 /*Number of all processed triggers*/
#define REGR_N_GLOB_CYCLES			26 /*Number of glob cycles for sw on (Global cycles incremented every REGW_GTUS_PER_CYCLE)*/
#define REGR_GTU_MPS_TIMESTAMP		27
#define REGR_UNIX_MPS_TIMESTAMP		28
#define REGR_TRG_GLOB_CNT			29
#define REGR_TRG_OUT				30 /*The last returned by L1 32-bit word*/


#define SM_STATE_IDLE		0
#define SM_STATE_ARMED		3


#define GetCurPosFC1() 		(*(u32*)(XPAR_AXIS_FLOW_CONTROL_D1_BASEADDR + REGR_TRANS_COUNTER*4))
#define GetCurPosFC2() 		(*(u32*)(XPAR_AXIS_FLOW_CONTROL_D2_BASEADDR + REGR_TRANS_COUNTER*4))

#define GetMaxisAlarmL1() 		(*(u32*)(XPAR_AXIS_FLOW_CONTROL_L1_BASEADDR + REGR_MAXIS_ALARM*4))
#define GetMaxisAlarmL2() 		(*(u32*)(XPAR_AXIS_FLOW_CONTROL_L2_BASEADDR + REGR_MAXIS_ALARM*4))

#define GetNlifeCycle() 		(*(u32*)(XPAR_AXIS_FLOW_CONTROL_L2_BASEADDR + REGR_GTU_CNT_L*4))

#define BIT_FC_IS_STARTED		(1<<0)


//REGW_CLR_FLAGS
#define BIT_FC_CLR_TRANS_CNT			(1<<0) /* Just for DBG*/
#define BIT_FC_CLR_ERROR				(1<<1) /* Just for DBG*/
#define BIT_FC_CLR_ALL					(1<<2) /* Just for DBG. Clear all except unix time*/
#define BIT_FC_CLR_INTR					(1<<3) /* Int must be cleared after every interrupt*/
#define BIT_FC_CLR_GTU_CNT				(1<<4) /* GTU cnt must be reset at the beginning of every measurement */
#define BIT_FC_CLR_TRIG_SERVICE			(1<<5) /* trig service must be reset at the beginning of every cycle */
#define BIT_FC_CLR_GLOB_TRG_CNT			(1<<8) /* trigger counter clear bit*/
#define BIT_FC_CLR_SELF_TRG_CNT			(1<<9) /* self trigger counter clear bit*/
#define BIT_FC_TRIG_IMMEDIATE			(1<<16)
#define BIT_FC_INJECT_16_EVENTS_4DMA	(1<<17)

//REGW_EDGE_FLAGS
#define BIT_FC_RELEASE					(1<<0)
//#define BIT_FC_TRIG_FORCE				(1<<1) // OBSOLETE
#define BIT_FC_SET_UNIX_TIME			(1<<2)

#define BIT_FC_IS_TRIGGER				(1<<16)

#define BIT_FC_IS_TRIGGER_LED			(1<<16)
#define BIT_FC_EN_TRIG_OUT				(1<<17)
#define BIT_FC_TRIG_OUT_FORCE			(1<<18)
#define BIT_FC_TRIG_EVENTS_LOG_EN		(1<<19)

#define BIT_FC_STATUS_DMA_ERROR			(1<<18)

#define BIT_FC_FLAGS_CLKB_MODE			(1<<17)

int IsD1DMA_error();
u32 GetTrigNGTU_L1();
u32 GetTrigType_L1();
u32 GetUnixTimestamp_L1();
int Get_N1();
void D1_release();
int IsD1Triggered();
u32 Get_n_glob_cycles();
void FlowControlStart_D1(u32 start);
void SetModeD1(u32 mode);
u32 GetUnixTime();
u32 L1_getNAPM();
u32 L1_getGTUnumber();
u32 L1_getSatisfied();
void SetPeriodOfPeriodicTrigger(u32 clks);
void FC_use_CLKB(int param);
u32 GetTrigN_of_internal_L1();
u32 FC_getSelfTrgCnt();


#endif /* SRC_AXIS_FLOWCTRL_H_ */
