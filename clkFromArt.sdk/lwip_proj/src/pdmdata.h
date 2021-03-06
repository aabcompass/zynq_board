/*
 * pdmdata.h
 *
 *  Created on: Dec 3, 2016
 *      Author: alexander
 *
 *      This file describes the data structures and text commands as
 *      communication protocol between ZynqBoard and CPU connected by Ethernet.
 *
 *      Data transfer is based on TCP/IP protocol.
 *
 *      ZynqBoard is controller by text commands listed in this file in the section "Text commands".
 *      A command can be sent from  a Telnet terninal like Linux telnet utility, Putty, Teraterm, etc. Also
 *      TCP massage can be sent from a script using netcat.
 *      TCP control port = 23.
 *
 *      ZynqBoard sends obtained data through FTP protocol. FTP server is implemented on Zynq side.
 *      FTP-server is light-weight, so not every client can be used to download files.
 *      FTP was tested with wget utility.
 *      An example of using wget is present.
 *
 * 		3 types of data files are present: scientific data, s-curve data and HVPS logs. Filenames are
 * 		listed in  the section Filenames of this document. Data structures are specified in this document
 * 		in corresponding sections.
 *
 * 		Single frames can also be sent as a direct answer on the text message "acq live" (i.e. not
 * 		via FTP). This is useful for EC-units preparing/troubleshooting.
 *
 *
 */

#ifndef SRC_PDMDATA_H_
#define SRC_PDMDATA_H_

#include <stdint.h>

#define ZYNQ3_VER_STRING "v3.20.01"

//========================================
// Constants
//========================================

#define N_OF_PIXELS_PER_PMT			64 /* number of pixel on PMT */
#define N_OF_KI_PER_PMT				8 /* number of KI on PMT */
#define N_OF_SPARE_PER_PMT			8 /* number of spares on PMT */
#define N_OF_COMMON_PIXELS			(N_OF_PIXELS_PER_PMT+N_OF_KI_PER_PMT+N_OF_SPARE_PER_PMT)

#define N_OF_PMT_PER_ECASIC 		6	/* number of PMT on EC ASIC board */
#define N_OF_ECASIC_PER_PDM			6  /* number of EC ASIC boards in PDM */


#define N_OF_PIXEL_PER_PDM			(N_OF_PIXELS_PER_PMT * N_OF_PMT_PER_ECASIC * N_OF_ECASIC_PER_PDM) /*Number of pixels per PDM*/
#define N_OF_KI_PER_PDM				(N_OF_KI_PER_PMT * N_OF_PMT_PER_ECASIC * N_OF_ECASIC_PER_PDM) /*Number of KI channels per PDM*/
#define N_OF_SPARES_PER_PDM			(N_OF_SPARE_PER_PMT * N_OF_PMT_PER_ECASIC * N_OF_ECASIC_PER_PDM) /*Number of KI channels per PDM*/

#define N_OF_PIXELS_TOTAL			(N_OF_PIXEL_PER_PDM+N_OF_KI_PER_PDM+N_OF_SPARES_PER_PDM)

#define NMAX_OF_THESHOLDS	1100/*1024*/ /*Number of ASIC DAC thresholds (needed for s-curves generated by ZynqB)*/


#define SIZE_TRIG_INFO	4 /*additional trigger information passed with every frame*/

#define N_INTEGRATION	50000

#define N_D3_PER_FILE	100 /*New files will be created every 5 sec*/

#pragma pack(push, 1) /* force no padding in structs */
// But anyway we try to keep all data multiple of 4

//========================================
// Header format
//========================================

// Common Zynq board header
// for all packets from ZynqB with scientific and configuration data
typedef struct
{
	uint32_t header; // 'Z'(31:24) | instrument_id(23:16) | data_type(15:8) | packet_ver(7:0)
	uint32_t payload_size;
} ZynqBoardHeader; //

// Instrument identifier to distinguish from Mini-EUSO(1) and future missions
#define INSTRUMENT_ME_PDM		1 	/* Instrument Mini-EUSO PDM*/
#define INSTRUMENT_SPB2_PDM		22 	/* Instrument SPB-2 PDM*/

// Macros for a header building
#define BuildHeader(data_type, packet_ver) \
	(('Z'<<24) | (INSTRUMENT_SPB2_PDM<<16) | ((data_type)<<8) | (packet_ver))

//========================================
// Sci data format
//========================================

// Data types mentioned in headers
#define DATA_TYPE_SCI_RAW		1 	/* Scientific raw data */
#define DATA_TYPE_SCI_INT32		3 	/* Scientific integrated data with 32 bit pixels (after integration) */
#define DATA_TYPE_SCI_POLY		4   /* Scientific polytypic data*/
#define DATA_TYPE_SCI_L1		10	/* Scientific data attached with L1 event*/
#define DATA_TYPE_SCI_L3		12	/* Scientific data attached with L3 event*/
#define DATA_TYPE_SCURVE		20  /* S-curve data */
#define DATA_TYPE_HVPS_LOG		60  /* HVPS log file */


// Every data packet is marked with timestamp
typedef struct
{
	uint32_t n_gtu; /*Number of GTUs from the last reset*/
	uint32_t unix_time; /*Number of seconds from power-on. This time can be adjusted to a battery time*/
} TimeStamp_dual;


// Number of small GTU frames recorded with L1 event
#define N_OF_FRAMES_D1_V0	128 /*Number of frames in D1 packet*/
// Number of huge GTU frames recorded with L3 event
#define N_OF_FRAMES_D3_V0	N_D3_PER_FILE  /*Number of frames in D3 packet. D3 packets are needed only for FS characterization */

#define N_FRAMES_PER_LIFECYCLE	(N_INTEGRATION*N_D3_PER_FILE) /*(128*128*128)*//*5000000*/ /* is a number of frames per lifecycle. */
/*Lifecycle is a period of time while zynq gathers one file to FTP server. */

//--
// D1 data format
//--

//One frame to be send to CPU

typedef struct
{
	uint8_t raw_data[N_OF_PIXELS_PER_PMT];
	uint8_t raw_ki[N_OF_KI_PER_PMT];
	uint8_t spare[N_OF_SPARE_PER_PMT];
} PMT_3rd_GEN;

typedef struct
{
	PMT_3rd_GEN pmt[N_OF_PMT_PER_ECASIC * N_OF_ECASIC_PER_PDM];
} FRAME_SPB_2_L1_V0;

// D1 timestamped packet
typedef struct
{
	// Unix timestamp
	TimeStamp_dual ts;
	// Flags
	uint32_t trig_type;
	//ZB_number
	uint32_t ZB_number; // 1 or 2 or 3
	// raw data (1 us GTU)
	FRAME_SPB_2_L1_V0 frames[N_OF_FRAMES_D1_V0];
} DATA_TYPE_SCI_L1_V4;

// D1 timestamped packet with header
typedef struct
{
	ZynqBoardHeader zbh;
	DATA_TYPE_SCI_L1_V4 payload;
	char alignment[0x28];
} Z_DATA_TYPE_SCI_L1_V4;

#define VER_Z_DATA_TYPE_SCI_L1	4

//--
// D3 data format
//--

typedef struct
{
	uint32_t data[N_OF_PIXELS_PER_PMT];
	uint32_t ki[N_OF_KI_PER_PMT];
	uint32_t spare[N_OF_SPARE_PER_PMT];
} PMT_3rd_L3_GEN;

typedef struct
{
	PMT_3rd_L3_GEN pmt[N_OF_PMT_PER_ECASIC * N_OF_ECASIC_PER_PDM];
} FRAME_SPB_2_L3_V0;

// D3 timestamped packet
typedef struct
{
	// Unix timestamp
	TimeStamp_dual ts;
	// Flags
	uint32_t trig_type;
	// HVPS status
	uint32_t hv_status;
	// ZB_number
	uint32_t ZB_number; // 1 or 2 or 3
	// integrated data
	FRAME_SPB_2_L3_V0 frames[N_OF_FRAMES_D3_V0];
	// additional information for s-curves
	uint16_t dac10_start;
	uint16_t dac10_step;
	uint16_t dac10_end;
} DATA_TYPE_SCI_L3_V3;

// D3 timestamped packet with header
typedef struct
{
	ZynqBoardHeader zbh;
	DATA_TYPE_SCI_L3_V3 payload;
	char alignment[0x1E];
} Z_DATA_TYPE_SCI_L3_V3;

#define VER_Z_DATA_TYPE_SCI_L3 3

/* zynqB is capable to send maximum MAX_PACKETS_L1 to CPU every N_FRAMES_PER_LIFECYCLE mus (Lifecycle)*/
#define MAX_PACKETS_L1 25 /*per 5 sec lifecycle */


//--
// Single D3 frame for live mode
//--


// Single live frame
typedef struct
{
	uint32_t data[N_OF_PIXELS_TOTAL];
} SingleLiveFrameD3;


//typedef struct
//{
//	// Unix timestamp
//	TimeStamp_dual ts;
//	// Flags
//	uint32_t trig_type;
//	// HVPS status
//	uint32_t hv_status;
//	// integrated data
//	uint32_t int32_data[NMAX_OF_THESHOLDS][N_OF_PIXELS_TOTAL];
//} DATA_TYPE_SCURVE_V2;
//
//
//// D3 timestamped packet with header
//typedef struct
//{
//	ZynqBoardHeader zbh;
//	DATA_TYPE_SCURVE_V2 payload;
//} Z_DATA_TYPE_SCURVE_V2;

//========================================
// Trigger types
//========================================

//Every D1 packet is marked with trid_type.
//Trigger types in data out files :
#define TRIG_NONE		0 /* No trigger occurred. The data in the packet has no sense*/
#define TRIG_PERIODIC	1 /* Periodic data. ZynqB give data periodically. For debugging*/
#define TRIG_SELF		2 /* Data triggered on trigger algorithm. For operation without CLKB*/
#define TRIG_IMMEDIATE	3 /* Data triggered on UART or TCP command. For debugging*/
#define TRIG_EXT		4 /* Data triggered on external signal. Standard operation */
#define TRIG_OTHERS		8 /* Other trigger types (for future)*/

//Enables trigger types in the FlowControl block
#define BIT_FC_EN_PERIODIC_TRIG	(1<<TRIG_PERIODIC)
#define BIT_FC_EN_SELF_TRIG		(1<<TRIG_SELF)
#define BIT_FC_EN_IMM_TRIG		(1<<TRIG_IMMEDIATE)
#define BIT_FC_EN_EXT_TRIG		(1<<TRIG_EXT)

//========================================
// Filenames for data on FTP server
//========================================

#define FILENAME_D1				"frm_z%d_d1_%08d.dat"
#define FILENAME_D3				"frm_z%d_d3_%08d.dat"
//#define FILENAME_HVLOG			"hv_%08d.dat"
//#define FILENAME_SCURVE	 		"scurve_%08d.dat"




//========================================
//  HVPS log structure
//========================================


// The maximum number of records in the log array
#define HVPS_LOG_SIZE_NRECORDS	100000

typedef struct
{
	TimeStamp_dual ts; //
	uint32_t record_type;
	uint32_t channels; // bit0,1 - ch0, bit2,3 - ch1, ..., bit16,17 - ch8
} DATA_TYPE_HVPS_LOG_V1;

typedef struct
{
	ZynqBoardHeader zbh;
	DATA_TYPE_HVPS_LOG_V1 payload[HVPS_LOG_SIZE_NRECORDS];
} Z_DATA_TYPE_HVPS_LOG_V1;

typedef struct
{
	uint8_t trig_type; // TRIG_PERIODIC=1,TRIG_SELF=2,TRIG_IMMEDIATE=3,TRIG_EXT=4
	uint8_t reserv_0;
	uint8_t trig_level; //L1=1, L2=2
	uint8_t reserv_1;
	uint32_t timestamp_gtu;
} DATA_TYPE_EVENTS_LOG;

//==========================================
// TCP Text commands
// Used for ZynqB control from CPU
//==========================================

#define TCP_CMD_TEST_CONNECT 		"test connect" /*Test connect*/
#define TCP_CMD_INSTR_STATUS		"instrument status" /*for debug*/
#define TCP_CMD_GET_VER				"instrument ver" /*Ask for version*/
#define TCP_CMD_REBOOT				"instrument reboot" /*Ask for version*/
//#define TCP_CMD_INSTR_MODE_2PAR		"instrument mode %d %d" /*Start in specified mode or stop (0)*/
#define TCP_CMD_INSTR_MODE_1PAR		"instrument mode %s" /*Start in specified mode or stop (0)*/
#define TCP_CMD_INSTR_MODE_START	"instrument start" /*Start DMA with trigger*/
#define TCP_CMD_INSTR_MODE_STOP		"instrument stop" /*Stop DMA with trigger*/
#define TCP_CMD_INSTR_SET_INTEGR	"instrument integration %d" /*set integration*/
#define TCP_CMD_ACQ_STOP			"acq stop" /*Stop live mode*/
#define TCP_CMD_ACQ_LIVE			"acq live" /*Get a live frame */
#define TCP_CMD_ACQ_NEXT			"acq next %d" /*Get next live frame (1 - 3)*/
#define TCP_CMD_SLOWCTRL_ALL_DAC	"slowctrl all dac %d" /*Set dac10 value for all ASICs*/
#define TCP_CMD_SLOWCTRL_DAC7_10	"slowctrl all dac7 %d dac10 %d" /*Set dac10 value for all ASICs*/
#define TCP_CMD_SLOWCTRL_LINE		"slowctrl line %d" /*Set current line*/
#define TCP_CMD_SLOWCTRL_ASIC		"slowctrl asic %d" /*Set current ASIC in line*/
#define TCP_CMD_SLOWCTRL_PIX		"slowctrl pixel %d" /*Set current pixel in ASIC*/
#define TCP_CMD_SLOWCTRL_DAC10		"slowctrl dac10 %d" /*Set DAC10 for the current ASIC*/
#define TCP_CMD_SLOWCTRL_DAC7		"slowctrl dac7 %d" /*Set DAC7 for the current pixel*/
#define TCP_CMD_SLOWCTRL_APPLY 		"slowctrl apply" /*Apply individual DAC10/7*/
#define TCP_CMD_SLOWCTRL_GET_DAC10	"slowctrl dac10?"/*Get DAC10 for the current ASIC*/
#define TCP_CMD_SLOWCTRL_GET_DAC7	"slowctrl dac7?"/*Get DAC7 for the current pixel*/
#define TCP_CMD_SLOWCTRL_SET_PAUSE	"slowctrl scurve pause %d"/*Sets pause between setting thresholds during scurve gathering process*/
#define TCP_CMD_SLOWCTRL_G_CUR_TRH	"slowctrl scurve thr?" /*Returns current threshold during scurve gathering process*/
#define TCP_CMD_SLOWCTRL_SET_STEP	"slowctrl scurve step %d" /*Set scurve step 1 or 11*/
#define TCP_CMD_SLOWCTRL_SC_DAC10	"slowctrl scurve scan dac10" /*Set scurve mode with dac10 scan*/
#define TCP_CMD_SLOWCTRL_SC_DAC7	"slowctrl scurve scan dac7" /*Set scurve mode with dac7 scan*/
#define TCP_CMD_PIXELSCAN_SET_N		"pixelscan n_steps %d" /*set number of scan*/
#define TCP_CMD_PIXELSCAN_GET_N		"pixelscan n?"
#define TCP_CMD_PIXELSCAN_TRG		"pixelscan trg"
#define TCP_CMD_GTU_1US				"gtu 1us" /* Set GTU=1us (default) */
#define TCP_CMD_GTU_2_5US			"gtu 2.5us"/* Set GTU=2.5us. This must be done before to start acq. */
#define TCP_CMD_HVPS_STATUS_INTR	"hvps status interrupt"/* for debug */
#define TCP_CMD_HVPS_TURNON			"hvps turnon %d %d %d %d %d %d %d %d %d"/* Switch on spec. HVPS channels */
#define TCP_CMD_HVPS_TURNOFF		"hvps turnoff %d %d %d %d %d %d %d %d %d"/* Switch off spec. HVPS channels */
#define TCP_CMD_HVPS_SETDAC			"hvps setdac %d %d %d %d %d %d %d %d %d"/* Set Dynode voltages (code 4095~1100V) */
#define TCP_CMD_HVPS_CATHODE		"hvps cathode %d %d %d %d %d %d %d %d %d"/* Set cathode voltages */
#define TCP_CMD_HVPS_STATUS_GPIO	"hvps status gpio"/* Get HVPS Polish status */
#define TCP_CMD_DBG_ARTCLK_CNT		"dbg art clk"
#define TCP_CMD_DBG_ARTTRDELAY		"dbg arttrdelay %d"
#define TCP_CMD_DBG_ARTFRDELAY		"dbg artfrdelay %d"

//#define TCP_
#define TCP_CMD_PIXELMAP_TST_ECS	"pixelmap test PMTs"
#define TCP_CMD_PIXELMAP_TST_PIX	"pixelmap test pixels"
#define TCP_CMD_PIXELMAP_TST_off	"pixelmap test off"
#define TCP_CMD_PIXELMAP_LOAD		"pixelmap load %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d"
#define TCP_CMD_HVPS_EXIT			"exit"/* Close TCP control port */
#define TCP_CMD_ARTIX_LOAD			"artix load %s"
#define TCP_CMD_GET_ARTIX_FILENAME	"artix filename?"

#pragma pack(pop) /* return to normal packing */

#endif /* SRC_PDMDATA_H_ */
