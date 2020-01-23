/*================================ ZYNQBOARD ==================================
*	PROJECT:	ZYNQ3 v1:	 "ZynqBoard software (Xilinx Zynq-7000, Linux) "
*	FILE:		telnet-uapp.c
*	CONTENTS:	User space application. Telnet server.
*				Provides remote control and monitoring of the device
*	VERSION:	01.01  08.11.2019
*	AUTHOR:		Andrey Poroshin
*	UPDATES :
*	1) 01.01   08 November 2019 - Initial version
 ============================================================================== */

#define _GNU_SOURCE

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/tcp.h>

/******************************************************************************
*	Internal definitions
*******************************************************************************/

// Mask of one bit
#define	BIT_MASK(bit)		(1 << (bit))

// TCP server port of this program
#define	TCP_SRV_PORT		55521

// TCP server socket keep-alive parameters
#define TCP_SRV_SOCK_KEEPALIVE		1		// Flag: 1 - use keep-alive, 0 - do not use
#define TCP_SRV_SOCK_KEEPCNT		2		// Number of keep-alive requests before disconnection
#define TCP_SRV_SOCK_KEEPIDLE		20		// Idle time before keep-alive test (sec)
#define TCP_SRV_SOCK_KEEPINTVL		5		// Time interval between keep-alive requests (sec)

// Max number of pending clients in the tcp server queue
// (before connection is accepted)
#define TCP_SRV_PENDING_CLI_MAX		3

// Max number of clients connected simultaneously
#define TCP_SRV_CONN_CLI_MAX		10

// TCP server receive buffer length (b)
#define TCP_SRV_RCBUF_LEN			128

// TCP client command buffer length (b)
#define CLI_CMD_BUF_LEN				128

// TCP client answer buffer length (b)
#define CLI_ANSW_BUF_LEN			128

// Telnet message end marker
#define TELNET_MSG_END_MRK			0x0A

// Max lenth of a command to execute at command prompt (b)
#define FL_CMD_LEN_MAX				128

// HVHK: number of hvhk channels
#define HV_NUM						9

// HVHK: command code to set dac outputs
#define HV_DAC_CMD_SET_OUT			1

// Slow control: max dac values
#define SC_DAC_10BIT_MAX			0x000003FF	// 10-bit dac
#define SC_DAC_7BIT_MAX				0x0000007F	// 7-bit dac

// Slow control: same data for all spacirocs, initial values
#define SC_SAME_INI_MISC_REG0		0x07A20007	// Miscellaneous register 0
#define SC_SAME_INI_X2_TST_MSK_DAC	0x00C000C0	// Test dac7 & mask, 2 pixels
#define SC_SAME_INI_MISC_REG1		0x00000000	// Miscellaneous register 1
#define SC_SAME_INI_X4_GAIN			0x00000000	// Gain, 4 pixels
#define SC_SAME_INI_X4_DAC_7B_SUB	0x00000000	// Dac 7b_sub, 32 pixels
#define SC_SAME_INI_MISC_REG2		0x00000000	// Miscellaneous register 2

// Slow control: individual data for all spacirocs, initial values
#define SC_IND_INI_MISC_REG0		0x0FA20007	// Miscellaneous register 0
#define SC_IND_INI_MISC_REG1		0x00000000	// Miscellaneous register 1
#define SC_IND_INI_MISC_REG2		0x00000000	// Miscellaneous register 2

// Slow control, register MISC_REG0 - 10-bit dac offset
#define SC_REG_MISC_REG0_DAC_OFFS		7

// Slow control, field: test dac7 & mask - 1-bit pixel mask offset
#define SC_REG_TST_MSK_DAC_MSK_OFFS		7

// Slow control: individual data initial values
#define SC_IND_DAC10_NOISY_VALUE	712			// 10-bit dac value for each PMT
#define SC_IND_DAC7_DEFAULT_VALUE	64			// 7-bit dac value for each pixel

// Slow control: minieuso constants
#define SC_N_OF_PIXELS_PER_PMT		64	// Number of pixels on PMT
#define SC_N_OF_PMT_PER_ECASIC		6	// Number of PMT on EC ASIC board
#define SC_N_OF_ECASIC_PER_PDM		6	// Number of EC ASIC boards in PDM

/******************************************************************************
*	Internal structures
*******************************************************************************/
// Types of client request
typedef enum CLI_REQ_TYPE_e {
	CLI_REQ_HV_TURN_ON,			// Client "hvps turnon" request
	CLI_REQ_HV_TURN_OFF,		// Client "hvps turnoff" request
	CLI_REQ_HV_SET_DAC,			// Client "hvps setdac" request
	CLI_REQ_HV_STATUS,			// Client "hvps status" request
	CLI_REQ_SC_ALL_DAC,			// Client "slowctrl all dac" request
	CLI_REQ_SC_LINE,			// Client "slowctrl line" request
	CLI_REQ_SC_ASIC,			// Client "slowctrl asic" request
	CLI_REQ_SC_PIXEL,			// Client "slowctrl pixel" request
	CLI_REQ_SC_DAC10,			// Client "slowctrl dac10" request
	CLI_REQ_SC_DAC7,			// Client "slowctrl dac7" request
	CLI_REQ_SC_APPLY,			// Client "slowctrl apply" request
	CLI_REQ_SC_DAC10_RQ,		// Client "slowctrl dac10?" request
	CLI_REQ_SC_DAC7_RQ			// Client "slowctrl dac7?" request
} CLI_REQ_TYPE_t;
#define CLI_REQ_TYPE_NUM	(CLI_REQ_SC_DAC7_RQ + 1)	// Total number of types

// Types of the answer to the TCP client
typedef enum CLI_ANSW_TYPE_e {
	CLI_ANSW_OK,				// Send "OK" answer message to the client
	CLI_ANSW_ERR,				// Send "Error" answer message to the client
	CLI_ANSW_BUF				// Send answer message to the client from buffer
} CLI_ANSW_TYPE_t;

// Pointer to the function to check and execute client command
typedef int (*PFUN_CMD_CLI_CHKEX_t)(uint8_t *buf);

// Slow control commands
typedef enum SC_CMD_e {
	SC_CMD_SAME_DATA=0,			// Load same data to all spacirocs
	SC_CMD_IND_DATA=1			// Load individual data to all spacirocs
} SC_CMD_t;

// Slow control: same data for all spacirocs
typedef struct SC_SP3_SAME_ASIC_V1_s {
	uint32_t misc_reg0;			// Miscellaneous register 0
	uint32_t x2_tst_msk_dac;	// Test dac7 & mask, 2 pixels
	uint32_t misc_reg1;			// Miscellaneous register 1
	uint32_t x4_gain;			// Gain, 4 pixels
	uint32_t x4_dac_7b_sub;		// Dac 7b_sub, 32 pixels
	uint32_t misc_reg2;			// Miscellaneous register 2
} SC_SP3_SAME_ASIC_V1_t;

// Slow control. User individual data structure for one spaciroc
typedef struct SC_SP3_SGL_ASIC_USER_V0_s {
	uint32_t dac10bit;								// 10-bit dac value
	uint8_t pixel_mask[SC_N_OF_PIXELS_PER_PMT];		// 1-bit mask for each pixel
	uint8_t dac7bit[SC_N_OF_PIXELS_PER_PMT];		// 7-bit dac value for each pixel
} SC_SP3_SGL_ASIC_USER_V0_t;

// Slow control. User individual data for all spacirocs
typedef struct SC_SP3_ALL_ASIC_USER_V0_s {
	SC_SP3_SGL_ASIC_USER_V0_t	sc_sp3_sgl_asic[SC_N_OF_PMT_PER_ECASIC][SC_N_OF_ECASIC_PER_PDM];
} SC_SP3_ALL_ASIC_USER_V0_t;

// Slow control. Individual data for one spaciroc.
typedef struct SC_SP3_SGL_ASIC_V1_s {
	uint32_t misc_reg0;								// Miscellaneous register 0
	uint16_t tst_msk_dac[SC_N_OF_PIXELS_PER_PMT];	// Test dac7 & mask for each pixel
	uint32_t misc_reg1;								// Miscellaneous register 1
	uint8_t gain[SC_N_OF_PIXELS_PER_PMT];			// Gain for each pixel
	uint8_t dac_7b_sub[SC_N_OF_PIXELS_PER_PMT/8];	// Dac 7b_sub, one value for 8 pixels
	uint32_t misc_reg2;								// Miscellaneous register 2
} SC_SP3_SGL_ASIC_V1_t;

// Slow control. Individual data for all spacirocs
typedef struct SC_SP3_ALL_ASIC_V1_s {
	SC_SP3_SGL_ASIC_V1_t sc_sp3_sgl_asic[SC_N_OF_PMT_PER_ECASIC][SC_N_OF_ECASIC_PER_PDM];
} SC_SP3_ALL_ASIC_V1_t;
#define SC_SP3_ALL_ASIC_V1_SZ	sizeof(SC_SP3_ALL_ASIC_V1_t)

// Slow control. Reformatted individual data for 6 spacirocs
// (one column of spacirocs, each spaciroc on a separate EC ASIC board)
typedef struct SC_SP3_6CHIPS_REFORMATTED_V1_s {
	uint32_t misc_reg0[SC_N_OF_ECASIC_PER_PDM];									// Miscellaneous register 0,for each PMT
	uint32_t x2_tst_msk_dac[SC_N_OF_PIXELS_PER_PMT/2][SC_N_OF_ECASIC_PER_PDM];	// Test dac7 & mask, 2 pixels, for each PMT
	uint32_t misc_reg1[SC_N_OF_ECASIC_PER_PDM];									// Miscellaneous register 1,for each PMT
	uint32_t x4_gain[SC_N_OF_PIXELS_PER_PMT/4][SC_N_OF_ECASIC_PER_PDM];			// Gain, 4 pixels, for each PMT
	uint32_t x4_dac_7b_sub[SC_N_OF_PIXELS_PER_PMT/4/8][SC_N_OF_ECASIC_PER_PDM];	// Dac 7b_sub, 32 pixels, for each PMT
	uint32_t misc_reg2[SC_N_OF_ECASIC_PER_PDM];									// Miscellaneous register 2,for each PMT
} __attribute__((__packed__)) SC_SP3_6CHIPS_REFORMATTED_V1_t;

// Slow control. Reformatted individual data for all spacirocs
typedef struct SC_SP3_36CHIPS_REFORMATTED_V1_s {
	SC_SP3_6CHIPS_REFORMATTED_V1_t	sc_sp3_6chips_reformatted[SC_N_OF_PMT_PER_ECASIC];
} __attribute__((__packed__)) SC_SP3_36CHIPS_REFORMATTED_V1_t;
#define SC_SP3_36CHIPS_REFORMATTED_V1_SZ	sizeof(SC_SP3_36CHIPS_REFORMATTED_V1_t)

/******************************************************************************
*	Internal functions
*******************************************************************************/
static int init(void);
static void initLocalVars(void);
static void initLocalTcpSrvFd(void);
static void initLocalScSameDat(void);
static void initLocalScIndUsrDat(void);
static int initTcpSrvSocket(void);
static int initTcpSrvSocketOpts(void);
static int initTcpSrvSocketOpt(int level, int optname, int val);
static int initTcpCreateSocket(int *fd);
static int initTcpSocketParams(int fd, uint16_t port);
static void initInetAddr(struct sockaddr_in *inetaddr, uint32_t ipaddr, uint16_t port);
static void initFdSet(void);
static void initFdSetCli(void);
static void initFdSetMaxNum(void);
static void prcActiveDescs(void);
static void prcCliConReq(void);
static void prcCliDisDat(uint32_t idx);
static void taskFinalize(void);
static int tcpSrvAddCli(int fd_cli_new);
static void tcpSrvRcProcess(void);
static void tcpSrvTrAnswer(uint8_t *buf);
static void tcpSrvCloseCli(void);
static void tcpSrvCloseCliAll(void);
static void tcpSrvCloseSocket(void);
static void fdClose(int *fd);
static void cmdCliPrcByte(uint8_t data_byte);
static void cmdCliChkExec(uint8_t *buf);
static int cmdCliChkExHvTurnOn(uint8_t *buf);
static int cmdCliChkExHvTurnOff(uint8_t *buf);
static int cmdCliChkExHvSetDac(uint8_t *buf);
static int cmdCliChkExHvStatus(uint8_t *buf);
static int cmdCliChkExScAllDac(uint8_t *buf);
static int cmdCliChkExScLine(uint8_t *buf);
static int cmdCliChkExScAsic(uint8_t *buf);
static int cmdCliChkExScPixel(uint8_t *buf);
static int cmdCliChkExScDac10(uint8_t *buf);
static int cmdCliChkExScDac7(uint8_t *buf);
static int cmdCliChkExScApply(uint8_t *buf);
static int cmdCliChkExScDac10RQ(uint8_t *buf);
static int cmdCliChkExScDac7RQ(uint8_t *buf);
static void cmdCliExHvTurnOn(int *clipar);
static void cmdCliExHvTurnOff(int *clipar);
static void cmdCliExHvTurnOnOff(int *clipar, const char *fname);
static void cmdCliExHvSetDac(int *clipar);
static void cmdCliExHvSetDacVal(int *clipar);
static void cmdCliExHvSetDacCmd(void);
static void cmdCliExHvStatus(void);
static void cmdCliExScAllDac(uint32_t clipar);
static void cmdCliExScLine(uint32_t clipar);
static void cmdCliExScAsic(uint32_t clipar);
static void cmdCliExScPixel(uint32_t clipar);
static void cmdCliExScDac10(uint32_t clipar);
static void cmdCliExScDac7(uint32_t clipar);
static void cmdCliExScApply(void);
static void cmdCliExScDac10RQ(void);
static void cmdCliExScDac7RQ(void);
static void cmdCliToBufDec(uint32_t val);
static void cmdCliAnswerSend(void);
static void scSameLoadData(void);
static void scIndUsrDataToTst(void);
static void scIndUsrDataToTstPmt(SC_SP3_SGL_ASIC_USER_V0_t *udata_pmt, SC_SP3_SGL_ASIC_V1_t *tdata_pmt);
static void scIndTstToRef(void);
static void scIndTstToRefPmt(SC_SP3_SGL_ASIC_V1_t *tdata_pmt,
	SC_SP3_6CHIPS_REFORMATTED_V1_t *rdata_col6, uint32_t j);
static void scIndRefToFifo(void);
static void scIndLoadData(void);
static int fileReadStr(const char *fname, char *buf, uint32_t buflen);
static int fileWriteBuf(const char *fname, char *buf, uint32_t len);
static void fileWriteDec(const char *fname, uint32_t val);
static void fileWriteDecIdx(const char *fname_base, uint32_t idx, uint32_t val);
static void fileWriteHex(const char *fname, uint32_t val);

/******************************************************************************
*	Internal data
*******************************************************************************/
static int fd_tcpsrv_sock = -1;					// File descriptor of the TCP server socket

// File desctiptors of the TCP server accepted clients
static int fd_tcpsrv_cli[TCP_SRV_CONN_CLI_MAX];

static fd_set read_fd_set;						// The set of file descriptors to read in "select" function
static int select_n;							// Max fd number + 1 (it is used in "select" function)
static uint8_t tcpsrv_rcbuf[TCP_SRV_RCBUF_LEN];	// Receive buffer of the TCP server
static int tcpsrv_rcvlen;						// Length of received data in the receive buffer

// Client index in the TCP server accepted clients array
static uint32_t cli_idx;

// Command buffers for each TCP server client
static uint8_t cli_cmd_bufs[TCP_SRV_CONN_CLI_MAX][CLI_CMD_BUF_LEN + 1];	// +1 for zero at the end of string

// Indexes in the command buffers
static uint32_t cli_cmd_buf_idx[TCP_SRV_CONN_CLI_MAX];

// Type of the answer to the TCP client
static CLI_ANSW_TYPE_t cli_answ_type;

// TCP client answer buffer 
static uint8_t cli_answ_buf[CLI_ANSW_BUF_LEN + 1];		// +1 for zero at the end of string

// HVHK: command/status file names in the  /sys/class/hvhk-cls folder
static const char *fname_hv_cmddacsnd =	"/sys/class/hvhk-cls/cmddacsnd";
static const char *fname_hv_dacval_base="/sys/class/hvhk-cls/dacval";
static const char *fname_hv_cmdchanon  ="/sys/class/hvhk-cls/cmdchanon";
static const char *fname_hv_cmdchanoff ="/sys/class/hvhk-cls/cmdchanoff";
static const char *fname_hv_chanstatus ="/sys/class/hvhk-cls/chanstatus";

// Slow control: file names in the /sys/class/spaciroc-cls folder
static const char *fname_sc_cmd_load_data  = "/sys/class/spaciroc-cls/cmd_load_data";
static const char *fname_sc_same_misc_reg0 = "/sys/class/spaciroc-cls/same_misc_reg0";
static const char *fname_sc_same_x2_tst_msk_dac = "/sys/class/spaciroc-cls/same_x2_tst_msk_dac";
static const char *fname_sc_same_misc_reg1 = "/sys/class/spaciroc-cls/same_misc_reg1";
static const char *fname_sc_same_x4_gain = "/sys/class/spaciroc-cls/same_x4_gain";
static const char *fname_sc_same_x4_dac_7b_sub = "/sys/class/spaciroc-cls/same_x4_dac_7b_sub";
static const char *fname_sc_same_misc_reg2 = "/sys/class/spaciroc-cls/same_misc_reg2";

// Slow control: character device file name (to send data to hardware fifo)
static const char *fname_sc_fifo_cdev = "/dev/axis_fifo_0x43c10000";

// Functions to check and execute client command
static const PFUN_CMD_CLI_CHKEX_t pfun_cmd_cli_chkex[CLI_REQ_TYPE_NUM] = {
	cmdCliChkExHvTurnOn,		// Index - CLI_REQ_HV_TURN_ON
	cmdCliChkExHvTurnOff,		// Index - CLI_REQ_HV_TURN_OFF
	cmdCliChkExHvSetDac,		// Index - CLI_REQ_HV_SET_DAC
	cmdCliChkExHvStatus,		// Index - CLI_REQ_HV_STATUS
	cmdCliChkExScAllDac,		// Index - CLI_REQ_SC_ALL_DAC
	cmdCliChkExScLine,			// Index - CLI_REQ_SC_LINE
	cmdCliChkExScAsic,			// Index - CLI_REQ_SC_ASIC
	cmdCliChkExScPixel,			// Index - CLI_REQ_SC_PIXEL
	cmdCliChkExScDac10,			// Index - CLI_REQ_SC_DAC10
	cmdCliChkExScDac7,			// Index - CLI_REQ_SC_DAC7
	cmdCliChkExScApply,			// Index - CLI_REQ_SC_APPLY
	cmdCliChkExScDac10RQ,		// Index - CLI_REQ_SC_DAC10_RQ
	cmdCliChkExScDac7RQ			// Index - CLI_REQ_SC_DAC7_RQ
};

// Slow control: same data for all spacirocs
static SC_SP3_SAME_ASIC_V1_t sc_same_data;

// Slow control: individual user data for all spacirocs
static SC_SP3_ALL_ASIC_USER_V0_t sc_ind_userdata;

// Slow control: individual user data apply controls
static uint32_t sc_current_line;			// Current EC ASIC board
static uint32_t sc_current_asic;			// Current PMT on EC ASIC board
static uint32_t sc_current_pixel;			// Current pixel on PMT

// Slow control: individual data for all spacirocs
static SC_SP3_ALL_ASIC_V1_t sc_ind_all_asic_test;

// Slow control: reformatted individual data for all spacirocs
static SC_SP3_36CHIPS_REFORMATTED_V1_t sc_reformatted;

/******************************* main(argc,argv) ******************************
* Main function of the program
* Parameters:
*	(i)argc - Number of arguments. Not Used
*	(i)argv - Argument list. Not Used
* Return value:
*	always 0
*******************************************************************************/
int main(int argc, char *argv[])
{
	// Init the program
	if(init() < 0) goto FIN;

	// Main Cycle of the task
	for(;;){
		// Init the set of file descriptors to be processed by "select" function
		initFdSet();

		// Block and wait for client connect, client disconnect and client data
		if(select(select_n,&read_fd_set,NULL,NULL,NULL) > 0)
			// Process received TCP events: client connect, client disconnect, client data
			prcActiveDescs();
	}

FIN:
	printf("telnet-uapp: FINISHING \n");

	// Free task resources, close opened file descriptors
	taskFinalize();
	
	return 0;
}

/*********************************** init() ***********************************
* Initilization of the program
* Creates TCP server socket for telnet server
* Return value:
*	-1	Initialization error
*	0	Ininitialization done
*******************************************************************************/
static int init(void)
{
	// Initialize local variables
	initLocalVars();

	// Create TCP server socket for telnet server
	return initTcpSrvSocket();
}

/****************************** initLocalVars() *******************************
* Initialize local variables
* Used variables:
*	(o)fd_tcpsrv_cli - file desctiptors of the TCP server accepted clients
*	(o)sc_same_data - slow control, same data for all spacirocs
*	(o)sc_ind_userdata - slow control, individual user data for all spacirocs
*******************************************************************************/
static void initLocalVars(void)
{
	// Init file desctiptors of the TCP server accepted clients
	initLocalTcpSrvFd();

	// Init slow control same data structure
	initLocalScSameDat();

	// Init slow control individual user data structure
	initLocalScIndUsrDat();
}

/**************************** initLocalTcpSrvFd() *****************************
* Initialize local variables:
*	init file desctiptors of the TCP server accepted clients
* Used variable:
*	(o)fd_tcpsrv_cli - file desctiptors of the TCP server accepted clients
*******************************************************************************/
static void initLocalTcpSrvFd(void)
{
	uint32_t i;

	// Set initial values for accepted tcp clients array
	for(i = 0; i < TCP_SRV_CONN_CLI_MAX; i++) fd_tcpsrv_cli[i] = -1;
}

/**************************** initLocalScSameDat() ****************************
* Initialize local variables:
*	init slow control same data structure
* Used variable:
*	(o)sc_same_data - slow control, same data for all spacirocs
*******************************************************************************/
static void initLocalScSameDat(void)
{
	// Write initial values to all fields of the structure	
	sc_same_data.misc_reg0 = SC_SAME_INI_MISC_REG0;
	sc_same_data.x2_tst_msk_dac = SC_SAME_INI_X2_TST_MSK_DAC;
	sc_same_data.misc_reg1 = SC_SAME_INI_MISC_REG1;
	sc_same_data.x4_gain = SC_SAME_INI_X4_GAIN;
	sc_same_data.x4_dac_7b_sub = SC_SAME_INI_X4_DAC_7B_SUB;
	sc_same_data.misc_reg2 = SC_SAME_INI_MISC_REG2;
}

/*************************** initLocalScIndUsrDat() ***************************
* Initialize local variables:
*	init slow control individual user data structure
* Used variable:
*	(o)sc_ind_userdata - slow control, individual user data for all spacirocs
*******************************************************************************/
static void initLocalScIndUsrDat(void)
{
	uint32_t i,j,k;
	SC_SP3_SGL_ASIC_USER_V0_t (*udata_array)[SC_N_OF_ECASIC_PER_PDM];
	SC_SP3_SGL_ASIC_USER_V0_t *udata_pmt;

	// Set the pointer to the PMT userdata array
	udata_array = sc_ind_userdata.sc_sp3_sgl_asic;

	// Init data for each EC ASIC board cycle
	for(i = 0; i < SC_N_OF_ECASIC_PER_PDM; i++) {
		// Init data for each PMT on EC ASIC board cycle
		for(j = 0; j < SC_N_OF_PMT_PER_ECASIC; j++) {
			// Set the pointer to the current PMT user data
			udata_pmt = &udata_array[j][i];
	
			// Set default 10-bit dac value for PMT
			udata_pmt -> dac10bit = SC_IND_DAC10_NOISY_VALUE;

			// Init data for each pixel cycle
			for(k = 0; k < SC_N_OF_PIXELS_PER_PMT; k++){
				// Set initial 7-bit dac value for the pixel
				udata_pmt -> dac7bit[k] = SC_IND_DAC7_DEFAULT_VALUE;

				// Set initial 1-bit pixel mask
				udata_pmt -> pixel_mask[k] = 1;
			}
		}
	}
}

/**************************** initTcpSrvSocket() ******************************
* Create TCP server socket for telnet server
* Set the parameters of the socket.
* Start listening for the connections on the socket
* Used variable:
*	(o)fd_tcpsrv_sock - file descriptor of the TCP server socket
* Return value:
*	-1 Create socket error 
*	0  The socket was created successfully
*******************************************************************************/
static int initTcpSrvSocket(void)
{
	// Create TCP server socket
	if(initTcpCreateSocket(&fd_tcpsrv_sock) < 0) return -1;

	// Set options for created TCP server socket
	if(initTcpSrvSocketOpts() < 0) {
		printf("telnet-uapp: ER set sock options \n");
		return -1;
	}

	// Set the parameters of communication for TCP server socket
	if(initTcpSocketParams(fd_tcpsrv_sock,TCP_SRV_PORT) < 0)
		return -1;											// Set socket parameters error

	// Listen for connections on a server socket.
	if(listen(fd_tcpsrv_sock, TCP_SRV_PENDING_CLI_MAX) < 0){
		printf("telnet-uapp: ER listen: \n");
		return -1;
	}

	// The socket was initialized successfully
	return 0;
}

/************************** initTcpSrvSocketOpts() ****************************
* Set options for created TCP server socket.
* Flag "reuseable address" is set
* Socket keep-alive parameters are set
* Used variable:
*	(i)fd_tcpsrv_sock - file descriptor of the TCP server socket
* Return value:
*	-1 Can not set socket options
*	0  Socket options were set successfully
*******************************************************************************/
static int initTcpSrvSocketOpts(void)
{
	// Local address must be reusable after TCP socket is closed
	if(initTcpSrvSocketOpt(SOL_SOCKET,SO_REUSEADDR,1) < 0) return -1;

	// Set keep-alive parameters
	if(initTcpSrvSocketOpt(SOL_SOCKET,SO_KEEPALIVE,TCP_SRV_SOCK_KEEPALIVE) < 0)
		return -1;
	if(initTcpSrvSocketOpt(SOL_TCP,TCP_KEEPCNT,TCP_SRV_SOCK_KEEPCNT) < 0)
		return -1;
	if(initTcpSrvSocketOpt(SOL_TCP,TCP_KEEPIDLE,TCP_SRV_SOCK_KEEPIDLE) < 0)
		return -1;
	if(initTcpSrvSocketOpt(SOL_TCP,TCP_KEEPINTVL,TCP_SRV_SOCK_KEEPINTVL) < 0)
		return -1;

	// Socket options were set successfully
	return 0;
}

/******************* initTcpSrvSocketOpt(level,optname,val) *******************
* Set an option for created TCP server socket.
* Used variable:
*	(i)fd_tcpsrv_sock - file descriptor of the TCP server socket
* Parameters:
*	(i)level - level at which the option resides
*	(i)optname - option name
*	(i)val - value to set for the option
* Return value:
*	-1 Can not set socket option
*	0  Socket option was set successfully
*******************************************************************************/
static int initTcpSrvSocketOpt(int level, int optname, int val)
{
	int val_tmp;

	// Set the value to write
	val_tmp = val;

	// Set socket option
	if(setsockopt(fd_tcpsrv_sock,level,optname,&val_tmp,sizeof(int)) < 0)
		return -1;				// Can not set option

	// Socket option was set successfully
	return 0;
}

/************************** initTcpCreateSocket(fd) ***************************
* Create TCP socket. 
* The connection based byte stream socket is created
* Parameter:
*	(o)fd - file descriptor of the created socket
* Return value:
*	-1 Create socket error 
*	0  The socket was created successfully
*******************************************************************************/
static int initTcpCreateSocket(int *fd)
{
	// Create the socket
	if((*fd = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
		printf("telnet-uapp: ER socket: %s %d \n",strerror(errno),errno);
		return -1;
	}

	// The socket was created successfully
	return 0;
}

/************************ initTcpSocketParams(fd,port) ************************
* Set the parameters of communication for a TCP socket.
* The socket must be created before calling this function.
* Paremeters:
*	(i)fd - file descriptor of the socket.
*	(i)port - TCP port to bind to the socket
* Return value:
*	-1 - Can not bind socket to the parameters
*	0  - Socket parameters were set successfully
*******************************************************************************/
static int initTcpSocketParams(int fd, uint16_t port)
{
	struct sockaddr_in myaddr; 	// IP address and port for the service

	// Initialize "internet address" structure
	// Address 0.0.0.0 - all IP addresses of the board are connected to this socket
	initInetAddr(&myaddr,INADDR_ANY,port);

	// Bind socket with parameters
	if(bind(fd, (struct sockaddr *)&myaddr, sizeof(myaddr)) < 0) {
		printf("telnet-uapp: ER bind: \n");
		return -1;
	}

	// Socket parameters were set successfully
	return 0;
}

/******************** initInetAddr(inetaddr,ipaddr,port) **********************
* Initialize "internet address" structure with user values.
* Parameters:
*	(o)inetaddr - pointer to the "internet address" structure
*	(i)ipaddr - IP address to set
*	(i)port - port number to set
*******************************************************************************/
static void initInetAddr(struct sockaddr_in *inetaddr, uint32_t ipaddr, uint16_t port)
{
	// Clear "internet address" structure
	memset((char *)inetaddr, 0, sizeof(struct sockaddr_in));

	// Set "internet address" parameters
	inetaddr -> sin_family = AF_INET;				// IPv4 Address Type
	inetaddr -> sin_addr.s_addr = htonl(ipaddr);	// IP address
	inetaddr -> sin_port = htons(port);				// Port
}

/******************************** initFdSet() *********************************
* Initialize the set of file descriptors to be processed by "select" function.
* "select" function unblocks when the data is received on the correspondent
*	socket or on TCP client connect/disconnect.
* TCP server socket is added to the set to control client connect
* TCP server accepted clients sockets are added:
*	to control data received from clinet
*	to control client disconnect 
* Used variables:
*	(i)fd_tcpsrv_sock - file descriptor of the TCP server socket
*	(i)fd_tcpsrv_cli -  file desctiptors of the TCP server accepted clients
*	(o)read_fd_set - the set of file descriptors to read in "select" function
*	(o)select_n - max fd number + 1 (it is used in "select" function)
*******************************************************************************/
static void initFdSet(void)
{
	// Clear the set of active descriptors
	FD_ZERO(&read_fd_set);

	// Add TCP server socket to the set
	FD_SET(fd_tcpsrv_sock,&read_fd_set);

	// Add file desctiptors of the TCP server accepted clients to the set
	initFdSetCli();

	// Calculate max fd number + 1 value for the descriptors in the set
	initFdSetMaxNum();
}

/******************************* initFdSetCli() *******************************
* Add file desctiptors of the TCP server accepted clients to the set.
* (the set of file descriptors to be processed by "select" function)
* Used variables:
*	(i)fd_tcpsrv_cli -  file desctiptors of the TCP server accepted clients
*	(io)read_fd_set - the set of file descriptors to read in "select" function
*******************************************************************************/
static void initFdSetCli(void)
{
	uint32_t i;
	int fd_cli;

	// Process TCP server accepted clients array in a cycle
	for(i = 0; i < TCP_SRV_CONN_CLI_MAX; i++) {
		// Read file descriptor of the socket
		fd_cli = fd_tcpsrv_cli[i];

		// Check that the client is connected on the socket
		if(fd_cli >= 0)
			// Add the socket to the set
			FD_SET(fd_cli, &read_fd_set);
	}
}

/***************************** initFdSetMaxNum() ******************************
* Calculate max fd number + 1 value
* This value is used in the "select" function
* Used variables:
*	(i)fd_tcpsrv_sock - file descriptor of the TCP server socket
*	(i)fd_tcpsrv_cli -  file desctiptors of the TCP server accepted clients
*	(o)select_n - max fd number + 1 (it is used in "select" function)
*******************************************************************************/
static void initFdSetMaxNum(void)
{
	uint32_t i;
	int fd_cli;

	// Set initial value for max file descriptor number
	select_n = fd_tcpsrv_sock;

	// Process TCP server accepted clients array in a cycle
	for(i = 0; i < TCP_SRV_CONN_CLI_MAX; i++) {
		// Read file descriptor of the socket
		fd_cli = fd_tcpsrv_cli[i];

		// Check the value of the file descriptor
		if(select_n < fd_cli) select_n = fd_cli;
	}

	// Increment the result
	select_n++;
}

/****************************** prcActiveDescs() ******************************
* Process received TCP events:
*	- client connet
*	- client data
*	- client disconnect
* The function is called when one (or more) of these events happened
* Used variables:
*	(i)read_fd_set -the set of triggered file descriptors
*	(i)fd_tcpsrv_sock - file descriptor of the TCP server socket
*	(io)fd_tcpsrv_cli -  file desctiptors of the TCP server accepted clients
*******************************************************************************/
static void prcActiveDescs(void)
{
	uint32_t i;
	int fd_cli;

	// Check for "client data" or "client disconnect" for each client
	for(i = 0; i < TCP_SRV_CONN_CLI_MAX; i++) {
		// Read file descriptor of the socket
		fd_cli = fd_tcpsrv_cli[i];

		// Check that the client is connected on the socket
		if(fd_cli >= 0) {
			// The client is connected. Check for events on the socket
			if(FD_ISSET(fd_cli, &read_fd_set)){
				// Process client events: disconnect event or data received event
				prcCliDisDat(i);
			}
		}
	}

	// Check if a client connect request was received
	if(FD_ISSET(fd_tcpsrv_sock, &read_fd_set))
		// Process client connect request
		prcCliConReq();
}

/******************************* prcCliConReq() *******************************
* Process client connection request.
* Accepts client connection request, 
* Adds new client socket descriptor to the TCP server accepted clients array
* If the array is full, the client is disconnected.
* Used variables:
*	(i)fd_tcpsrv_sock - file descriptor of the TCP server socket
*	(io)fd_tcpsrv_cli -  file desctiptors of the TCP server accepted clients
*******************************************************************************/
static void prcCliConReq(void)
{
	uint32_t i;
	int fd_cli_new;

	// Accept client connection request (the function does not block)
	fd_cli_new = accept(fd_tcpsrv_sock,NULL,0);

	// Add client socket to the TCP server accepted clients array
	//	only if the connection was established
	if(fd_cli_new >= 0)
		// The connection was established
		// Add new client socket descriptor to the TCP server accepted clients array
		if(tcpSrvAddCli(fd_cli_new) < 0){
			// Error. No place for the new descriptor in the array.
			// Client socket was not added. Disconnect
			fdClose(&fd_cli_new);
		}
}

/***************************** prcCliDisDat(idx) ******************************
* Process client events: disconnect event or data received event
* If client is disconnected, it is removed from accepted clients array
* If data was received from client, it is processed
* Used variables:
*	(io)fd_tcpsrv_cli - file desctiptors of the TCP server accepted clients
*	(o)tcpsrv_rcbuf - receive buffer of the TCP server
*	(o)tcpsrv_rcvlen - length of received data in the receive buffer
*	(o)cli_idx - client index in the TCP server accepted clients array
* Parameter:
*	(i)idx - client index in the TCP server accepted clients array
*******************************************************************************/
static void prcCliDisDat(uint32_t idx)
{
	int fd_cli;

	// Read file descriptor of the client socket
	fd_cli = fd_tcpsrv_cli[idx];

	// Store tcp client index
	cli_idx = idx;

	// Read client data into the local buffer (the function does not block)
	tcpsrv_rcvlen = read(fd_cli, tcpsrv_rcbuf, TCP_SRV_RCBUF_LEN);

	// Check if the data was really received
	if(tcpsrv_rcvlen > 0){
		// Process received data
		tcpSrvRcProcess();
	}
	else {
		// Client was disconnected.
		// Disconnect with the client, remove it from server accepted clients array
		tcpSrvCloseCli();
	}
}

/******************************* taskFinalize() *******************************
* Free task resources, close opened file descriptors
* The descriptors are closed only if they were opened before
* Used variables:
*	(io)fd_tcpsrv_cli - file desctiptors of the TCP server accepted clients
*	(io)fd_tcpsrv_sock - file descriptor of the TCP server socket
*******************************************************************************/
static void taskFinalize(void)
{
	// Close connection to all connected TCP clients
	tcpSrvCloseCliAll();

	// Close TCP server socket opened by this task
	tcpSrvCloseSocket();
}

/************************** tcpSrvAddCli(fd_cli_new) **************************
* Add new client socket descriptor to the TCP server accepted clients array
* Used variable:
*	(io)fd_tcpsrv_cli -  file desctiptors of the TCP server accepted clients
* Parameter:
*	(i)fd_cli_new - file desctiptor of the new accepted client
*						(not checked here)
* Return value:
*	-1 Error. No place for the new descriptor in the array
*	0  Success. New descriptor was added to the array
*******************************************************************************/
static int tcpSrvAddCli(int fd_cli_new)
{
	uint32_t i;
	int fd_arr;

	// Find the place in the array in a cycle
	for(i = 0; i < TCP_SRV_CONN_CLI_MAX; i++) {
		// Read file descriptor of the socket from array
		fd_arr = fd_tcpsrv_cli[i];

		// Check that the position is empty
		if(fd_arr == -1) {
			// The position is empty, add new client into the array
			fd_tcpsrv_cli[i] = fd_cli_new;

			// New descriptor was added to the array successfully
			return 0;
		}
	}

	// No place for the new descriptor in the array
	return -1;
}

/***************************** tcpSrvRcProcess() ******************************
* Process data received from the connected client
* Data from each client is stored in a separate buffer.
* If complete command was received, it is executed.
* Used variables:
*	(i)tcpsrv_rcbuf - receive buffer of the TCP server
*	(i)tcpsrv_rcvlen - length of received data in the receive buffer
*	(i)cli_idx - client index in the TCP server accepted clients array
*	(o)cli_cmd_bufs - command buffers for each TCP server client
*	(io)cli_cmd_buf_idx - indexes in the command buffers
*******************************************************************************/
static void tcpSrvRcProcess(void)
{
	uint32_t data_idx;
	uint8_t	data_byte;

	// Print received data
	/*printf("telnet-uapp: client index   = %d ",cli_idx);
	printf("telnet-uapp: received bytes = %d ", tcpsrv_rcvlen);
	for(data_idx = 0; data_idx < tcpsrv_rcvlen; data_idx++){
		if(data_idx%0x10 == 0) printf("\n");
		printf("%.2x ", tcpsrv_rcbuf[data_idx]);	
	}
	printf("\n telnet-uapp: received bytes END \n");*/

	// Process received bytes cycle
	for(data_idx = 0; data_idx < tcpsrv_rcvlen; data_idx++){
		// Read received byte
		data_byte = tcpsrv_rcbuf[data_idx];

		// Process received byte for the current client
		cmdCliPrcByte(data_byte);
	}
}

/**************************** tcpSrvTrAnswer(buf) *****************************
* Transmit a message to the tcp client
* Used variables:
*	(i)cli_idx - client index in the TCP server accepted clients array
*	(i)fd_tcpsrv_cli - file desctiptors of the TCP server accepted clients
* Parameter:
*	(i)buf - buffer with the text message to transmit.
*		The message must contain zero character at the end
*		Zero character is not transmitted to tcp client
*******************************************************************************/
static void tcpSrvTrAnswer(uint8_t *buf)
{
	int fd_cli;
	uint32_t len;

	// Read file descriptor of the client socket
	fd_cli = fd_tcpsrv_cli[cli_idx];

	// Calculate the length of the data to send
	len = strlen(buf);

	// Print transmitted data
	/*printf("telnet-uapp: client index   = %d ",cli_idx);
	printf("telnet-uapp: transmitted bytes = %d ", len);
	for(i = 0; i < len; i++){
		if(i%0x10 == 0) printf("\n");
		printf("%.2x ", buf[i]);
	}
	printf("\n telnet-uapp: transmitted bytes END \n");	*/

	// Transmit the data
	write(fd_cli,buf,len);
}

/****************************** tcpSrvCloseCli() ******************************
* Close connection to the TCP client on the TCP server socket
* The connection is closed only if it was already opened (accepted)
* Used variables:
*	(i)cli_idx - client index in the TCP server accepted clients array
*	(io)fd_tcpsrv_cli - file desctiptors of the TCP server accepted clients
*******************************************************************************/
static void tcpSrvCloseCli(void)
{
	// Close file descriptor, clear value in server accepted clients array 
	fdClose(&fd_tcpsrv_cli[cli_idx]);
}

/**************************** tcpSrvCloseCliAll() *****************************
* Close connection to all connected TCP clients
* Used variable:
*	(io)fd_tcpsrv_cli - file desctiptors of the TCP server accepted clients
*******************************************************************************/
static void tcpSrvCloseCliAll(void)
{
	uint32_t i;

	// Close accepted connections in a cycle
	for(i = 0; i < TCP_SRV_CONN_CLI_MAX; i++)
		// Set the index of the TCP client to close
		cli_idx = i;

		// Close connection to the TCP client
		// The connection is closed only if it was accepted
		tcpSrvCloseCli();
}

/**************************** tcpSrvCloseSocket() *****************************
* Close TCP server socket opened by this task
* Socket is closed only if it was opened.
* Used variable:
*	(io)fd_tcpsrv_sock - file descriptor of the TCP server socket
*******************************************************************************/
static void tcpSrvCloseSocket(void)
{
	fdClose(&fd_tcpsrv_sock);
}

/******************************** fdClose(fd) *********************************
* Close file descriptor that was opened by this task
* File descriptor is closed only if it was opened
* Parameter:
*	(io)fd - file descriptor
*******************************************************************************/
static void fdClose(int *fd)
{
	// If the file was opened - close it
	if(*fd >= 0) close(*fd);

	// Set file descriptor value: file is closed
	*fd = -1;
}

/************************** cmdCliPrcByte(data_byte) **************************
* Process received byte from the TCP client
* Data from each client is stored in a separate buffer.
* If complete command was received, it is executed.
* Used variables:
*	(i)cli_idx - client index in the TCP server accepted clients array
*	(io)cli_cmd_bufs - command buffers for each TCP server client
*	(io)cli_cmd_buf_idx - indexes in the command buffers
* Parameter:
*	(i)data_byte - next byte received from TCP client
*******************************************************************************/
static void cmdCliPrcByte(uint8_t data_byte)
{
	uint8_t *buf;
	uint32_t *pidx;
	
	// Set pointers to the client buffer and to the index in the buffer
	buf = cli_cmd_bufs[cli_idx];
	pidx = &cli_cmd_buf_idx[cli_idx];

	// Check for a space for received character in the buffer
	if(*pidx >= CLI_CMD_BUF_LEN) {
		// The buffer is full. Reset the buffer
		*pidx = 0;
	}
	
	// Add new character to the buffer
	buf[*pidx] = data_byte;
	(*pidx)++;

	// Check for message end marker
	if(data_byte  == TELNET_MSG_END_MRK) {
		// Add zero byte to the end of the message
		buf[*pidx] = 0;

		// Full message was received. Execute received command if it is valid
		cmdCliChkExec(buf);

		// Reset the buffer. It will be used for the next command
		*pidx = 0;
	}
}

/***************************** cmdCliChkExec(buf) *****************************
* Execute received command.
* Only valid commands are executed. The answer is transmitted to client
* Used variable:
*	(o)cli_answ_type - type of the answer to the TCP client
* Parameter:
*	(i)buf - buffer where received command is stored
*******************************************************************************/
static void cmdCliChkExec(uint8_t *buf)
{
	uint32_t req_type;
	int rc;

	// Set initial value for the answer type
	cli_answ_type = CLI_ANSW_ERR;

	// Check client request type cycle
	for(req_type = 0; req_type < CLI_REQ_TYPE_NUM; req_type++){
		// Check, execute client command
		rc = pfun_cmd_cli_chkex[req_type](buf);
		if(rc == 0) break;			// The command was found. It was executed
	}

	// Create and send the answer to the tcp client
	cmdCliAnswerSend();
}

/************************** cmdCliChkExHvTurnOn(buf) **************************
* Check client command buffer:
*	If "hvps turnon" command was received - execute it
* Parameter:
*	(i)buf - buffer where received command is stored
* Return value:
*	-1 Buffer does not contain valid command 
*	0  The command was executed
*******************************************************************************/
static int cmdCliChkExHvTurnOn(uint8_t *buf)
{
	int clipar[HV_NUM];

	// Check if "hvps turnon" command was received
	if(sscanf(buf, "hvps turnon %d %d %d %d %d %d %d %d %d",
		&clipar[0], &clipar[1], &clipar[2], &clipar[3], &clipar[4],
		&clipar[5], &clipar[6], &clipar[7], &clipar[8]) == HV_NUM){
			// Execute "hvps turnon" command
			cmdCliExHvTurnOn(clipar);

			// The command was executed
			return 0;
	}

	// Buffer does not contain valid command
	return -1;
}

/************************* cmdCliChkExHvTurnOff(buf) **************************
* Check client command buffer:
*	If "hvps turnoff" command was received - execute it
* Parameter:
*	(i)buf - buffer where received command is stored
* Return value:
*	-1 Buffer does not contain valid command 
*	0  The command was executed
*******************************************************************************/
static int cmdCliChkExHvTurnOff(uint8_t *buf)
{
	int clipar[HV_NUM];

	// Check if "hvps turnoff" command was received
	if(sscanf(buf, "hvps turnoff %d %d %d %d %d %d %d %d %d",
		&clipar[0], &clipar[1], &clipar[2], &clipar[3], &clipar[4],
		&clipar[5], &clipar[6], &clipar[7], &clipar[8]) == HV_NUM){
			// Execute "hvps turnoff" command
			cmdCliExHvTurnOff(clipar);

			// The command was executed
			return 0;
	}

	// Buffer does not contain valid command
	return -1;
}

/************************** cmdCliChkExHvSetDac(buf) **************************
* Check client command buffer:
*	If "hvps setdac" command was received - execute it
* Parameter:
*	(i)buf - buffer where received command is stored
* Return value:
*	-1 Buffer does not contain valid command 
*	0  The command was executed
*******************************************************************************/
static int cmdCliChkExHvSetDac(uint8_t *buf)
{
	int clipar[HV_NUM];

	// Check if "hvps setdac" command was received
	if(sscanf(buf, "hvps setdac %d %d %d %d %d %d %d %d %d",
		&clipar[0], &clipar[1], &clipar[2], &clipar[3], &clipar[4],
		&clipar[5], &clipar[6], &clipar[7], &clipar[8]) == HV_NUM){
			// Execute "hvps setdac" command
			cmdCliExHvSetDac(clipar);

			// The command was executed
			return 0;
	}

	// Buffer does not contain valid command
	return -1;
}

/************************** cmdCliChkExHvStatus(buf) **************************
* Check client command buffer:
*	If "hvps status" command was received - execute it
* Parameter:
*	(i)buf - buffer where received command is stored
* Return value:
*	-1 Buffer does not contain valid command 
*	0  The command was executed
*******************************************************************************/
static int cmdCliChkExHvStatus(uint8_t *buf)
{
	// Check if "hvps status" command was received
	if(strcmp(buf, "hvps status\r\n") == 0){
		// Execute "hvps status" command
		cmdCliExHvStatus();

		// The command was executed
		return 0;
	}

	// Buffer does not contain valid command
	return -1;
}

/************************** cmdCliChkExScAllDac(buf) **************************
* Check client command buffer:
*	If "slowctrl all dac" command was received - execute it
* Parameter:
*	(i)buf - buffer where received command is stored
* Return value:
*	-1 Buffer does not contain valid command
*	0  The command was executed
*******************************************************************************/
static int cmdCliChkExScAllDac(uint8_t *buf)
{
	uint32_t clipar;

	// Check if "slowctrl all dac" command was received
	if(sscanf(buf, "slowctrl all dac %d", &clipar) == 1){
		// Execute "slowctrl all dac" command
		cmdCliExScAllDac(clipar);

		// The command was executed
		return 0;
	}

	// Buffer does not contain valid command
	return -1;
}

/*************************** cmdCliChkExScLine(buf) ***************************
* Check client command buffer:
*	If "slowctrl line" command was received - execute it
* Parameter:
*	(i)buf - buffer where received command is stored
* Return value:
*	-1 Buffer does not contain valid command
*	0  The command was executed
*******************************************************************************/
static int cmdCliChkExScLine(uint8_t *buf)
{
	uint32_t clipar;

	// Check if "slowctrl line" command was received
	if(sscanf(buf, "slowctrl line %d", &clipar) == 1){
		// Execute "slowctrl line" command
		cmdCliExScLine(clipar);

		// The command was executed
		return 0;
	}

	// Buffer does not contain valid command
	return -1;
}

/*************************** cmdCliChkExScAsic(buf) ***************************
* Check client command buffer:
*	If "slowctrl asic" command was received - execute it
* Parameter:
*	(i)buf - buffer where received command is stored
* Return value:
*	-1 Buffer does not contain valid command
*	0  The command was executed
*******************************************************************************/
static int cmdCliChkExScAsic(uint8_t *buf)
{
	uint32_t clipar;

	// Check if "slowctrl asic" command was received
	if(sscanf(buf, "slowctrl asic %d", &clipar) == 1){
		// Execute "slowctrl asic" command
		cmdCliExScAsic(clipar);

		// The command was executed
		return 0;
	}

	// Buffer does not contain valid command
	return -1;
}

/************************** cmdCliChkExScPixel(buf) ***************************
* Check client command buffer:
*	If "slowctrl pixel" command was received - execute it
* Parameter:
*	(i)buf - buffer where received command is stored
* Return value:
*	-1 Buffer does not contain valid command
*	0  The command was executed
*******************************************************************************/
static int cmdCliChkExScPixel(uint8_t *buf)
{
	uint32_t clipar;

	// Check if "slowctrl pixel" command was received
	if(sscanf(buf, "slowctrl pixel %d", &clipar) == 1){
		// Execute "slowctrl pixel" command
		cmdCliExScPixel(clipar);

		// The command was executed
		return 0;
	}
	
	// Buffer does not contain valid command
	return -1;
}

/************************** cmdCliChkExScDac10(buf) ***************************
* Check client command buffer:
*	If "slowctrl dac10" command was received - execute it
* Parameter:
*	(i)buf - buffer where received command is stored
* Return value:
*	-1 Buffer does not contain valid command
*	0  The command was executed
*******************************************************************************/
static int cmdCliChkExScDac10(uint8_t *buf)
{
	uint32_t clipar;
	
	// Check if "slowctrl dac10" command was received
	if(sscanf(buf, "slowctrl dac10 %d", &clipar) == 1){
		// Execute "slowctrl dac10" command
		cmdCliExScDac10(clipar);

		// The command was executed
		return 0;
	}

	// Buffer does not contain valid command
	return -1;
}

/*************************** cmdCliChkExScDac7(buf) ***************************
* Check client command buffer:
*	If "slowctrl dac7" command was received - execute it
* Parameter:
*	(i)buf - buffer where received command is stored
* Return value:
*	-1 Buffer does not contain valid command
*	0  The command was executed
*******************************************************************************/
static int cmdCliChkExScDac7(uint8_t *buf)
{
	uint32_t clipar;

	// Check if "slowctrl dac7" command was received
	if(sscanf(buf, "slowctrl dac7 %d", &clipar) == 1){
		// Execute "slowctrl dac7" command
		cmdCliExScDac7(clipar);

		// The command was executed
		return 0;
	}

	// Buffer does not contain valid command
	return -1;
}

/************************** cmdCliChkExScApply(buf) ***************************
* Check client command buffer:
*	If "slowctrl apply" command was received - execute it
* Parameter:
*	(i)buf - buffer where received command is stored
* Return value:
*	-1 Buffer does not contain valid command
*	0  The command was executed
*******************************************************************************/
static int cmdCliChkExScApply(uint8_t *buf)
{
	// Check if "slowctrl apply" command was received
	if(strcmp(buf, "slowctrl apply\r\n") == 0){
		// Execute "slowctrl apply" command
		cmdCliExScApply();

		// The command was executed
		return 0;
	}

	// Buffer does not contain valid command
	return -1;
}

/************************* cmdCliChkExScDac10RQ(buf) **************************
* Check client command buffer:
*	If "slowctrl dac10?" command was received - execute it
* Parameter:
*	(i)buf - buffer where received command is stored
* Return value:
*	-1 Buffer does not contain valid command
*	0  The command was executed
*******************************************************************************/
static int cmdCliChkExScDac10RQ(uint8_t *buf)
{
	// Check if "slowctrl dac10?" command was received
	if(strcmp(buf, "slowctrl dac10?\r\n") == 0){
		// Execute "slowctrl dac10?" command
		cmdCliExScDac10RQ();

		// The command was executed
		return 0;
	}

	// Buffer does not contain valid command
	return -1;
}

/************************** cmdCliChkExScDac7RQ(buf) **************************
* Check client command buffer:
*	If "slowctrl dac7?" command was received - execute it
* Parameter:
*	(i)buf - buffer where received command is stored
* Return value:
*	-1 Buffer does not contain valid command
*	0  The command was executed
*******************************************************************************/
static int cmdCliChkExScDac7RQ(uint8_t *buf)
{
	// Check if "slowctrl dac7?" command was received
	if(strcmp(buf, "slowctrl dac7?\r\n") == 0) {
		// Execute "slowctrl dac7?" command
		cmdCliExScDac7RQ();

		// The command was executed
		return 0;
	}

	// Buffer does not contain valid command
	return -1;
}

/************************** cmdCliExHvTurnOn(clipar) **************************
* Execute "hvps turnon" command
* Used variable:
*	(i)fname_hv_cmdchanon - file name (hvhk): "command channel on"
* Parameter:
*	(i)clipar - array with values for each channel
*		clipar[X] == 0 -- do not turn on channel X
*		clipar[X] == 1 -- turn on channel X
*******************************************************************************/
static void cmdCliExHvTurnOn(int *clipar)
{
	cmdCliExHvTurnOnOff(clipar, fname_hv_cmdchanon);
}

/************************* cmdCliExHvTurnOff(clipar) **************************
* Execute "hvps turnoff" command
* Used variable:
*	(i)fname_hv_cmdchanoff - file name (hvhk): "command channel off"
* Parameter:
*	(i)clipar - array with values for each channel
*		clipar[X] == 0 -- do not turn off channel X
*		clipar[X] == 1 -- turn off channel X
*******************************************************************************/
static void cmdCliExHvTurnOff(int *clipar)
{
	cmdCliExHvTurnOnOff(clipar, fname_hv_cmdchanoff);
}

/********************* cmdCliExHvTurnOnOff(clipar,fname) **********************
* Execute "hvps turnon" or "hvps turnoff" command
* Used variable:
*	(o)cli_answ_type - type of the answer to the TCP client
* Parameters:
*	(i)clipar - array with values for each channel
*		clipar[X] == 0 -- do not turn on/off channel X
*		clipar[X] == 1 -- turn on/off channel X
*	(i)fname - file name: "command channel on" or "command channel off"
*******************************************************************************/
static void cmdCliExHvTurnOnOff(int *clipar, const char *fname)
{
	uint32_t i;
	uint32_t bitmsk;

	// Initial value for a bitmask to write to the file in /sys file subsystem
	bitmsk = 0;

	// Process parameters, create a bitmask
	for(i = 0; i < HV_NUM; i++)
		// If the channel has to be turned on/off,
		//	set correspondent bit in the bitmask
		if(clipar[i]) bitmsk |= BIT_MASK(i);

	// Write bitmask value to the file
	fileWriteHex(fname, bitmsk);

	// Transmit "OK" answer message to tcp client
	cli_answ_type = CLI_ANSW_OK;
}

/************************** cmdCliExHvSetDac(clipar) **************************
* Execute "hvps setdac" command
* Used variables:
*	(i)fname_hv_cmddacsnd - file name (hvhk): "commands to send to dac"
*	(i)fname_hv_dacval_base - base file name (hvhk) for all "dac value" files
*	(o)cli_answ_type - type of the answer to the TCP client
* Parameter:
*	(i)clipar - array with values to set for each dac
*******************************************************************************/
static void cmdCliExHvSetDac(int *clipar)
{
	// Write all "dac value" files
	cmdCliExHvSetDacVal(clipar);

	// Send data from "dac value" files to dac
	cmdCliExHvSetDacCmd();

	// Transmit "OK" answer message to tcp client
	cli_answ_type = CLI_ANSW_OK;
}

/************************ cmdCliExHvSetDacVal(clipar) *************************
* "hvps setdac" command execution: write dac values files
* Used variables:
*	(i)fname_hv_dacval_base - base file name (hvhk) for all "dac value" files
* Parameter:
*	(i)clipar - array with values to set for each dac
*******************************************************************************/
static void cmdCliExHvSetDacVal(int *clipar)
{
	uint32_t i;
	int val_dac;

	// Write dac values cycle
	for(i = 0; i < HV_NUM; i++) {
		// Read the value to write to the file
		val_dac = clipar[i];

		// Write the value to the correspondent file
		fileWriteDecIdx(fname_hv_dacval_base,i,val_dac);
	}
}

/*************************** cmdCliExHvSetDacCmd() ****************************
* "hvps setdac" command execution: send data from "dac value" files to dac
* Used variables:
*	(i)fname_hv_cmddacsnd - file name (hvhk): "commands to send to dac"
*******************************************************************************/
static void cmdCliExHvSetDacCmd(void)
{
	// Write command value to the file
	// This operation initiates command execution
	fileWriteDec(fname_hv_cmddacsnd, HV_DAC_CMD_SET_OUT);
}

/***************************** cmdCliExHvStatus() *****************************
* Execute "hvps status" command
* Used variables:
*	(i)fname_hv_chanstatus - file name (hvhk): "channel status"
*	(o)cli_answ_type - type of the answer to the TCP client
*	(o)cli_answ_buf - tcp client answer buffer (status data is stored here)
*******************************************************************************/
static void cmdCliExHvStatus(void)
{
	int rc;

	// Read one string from a file "hvps status"
	rc = fileReadStr(fname_hv_chanstatus,cli_answ_buf,CLI_ANSW_BUF_LEN);
	if(rc == 0)
		// The file was read successfully.
		// Received data will be transmitted to tcp client.
		cli_answ_type = CLI_ANSW_BUF;
	else 
		// Can not read data from a file.
		// Transmit "Error" answer message to tcp client.
		cli_answ_type = CLI_ANSW_ERR;
}

/************************** cmdCliExScAllDac(clipar) **************************
* Execute "slowctrl all dac" command
* Used variables:
*	(io)sc_same_data - slow control, same data for all spacirocs
*	(o)cli_answ_type - type of the answer to the TCP client
* Parameter:
*	(i)clipar - 10-bit setvalue for dac
*******************************************************************************/
static void cmdCliExScAllDac(uint32_t clipar)
{
	// Check the user value
	if(clipar <= SC_DAC_10BIT_MAX) {
		// Put dac setvalue into the slow control data structure
		sc_same_data.misc_reg0 =
			SC_SAME_INI_MISC_REG0 | (clipar << SC_REG_MISC_REG0_DAC_OFFS);

		// Load same data parameters to all spacirocs
		scSameLoadData();

		// Transmit "OK" answer message to tcp client
		cli_answ_type = CLI_ANSW_OK;
	}
}

/*************************** cmdCliExScLine(clipar) ***************************
* Execute "slowctrl line" command
* Used variables:
*	(o)sc_current_line - current EC ASIC board number (i.e. current line)
*	(o)cli_answ_type - type of the answer to the TCP client
* Parameter:
*	(i)clipar - new value for "current line" parameter
*******************************************************************************/
static void cmdCliExScLine(uint32_t clipar)
{
	// Check the user value
	if(clipar < SC_N_OF_ECASIC_PER_PDM) {
		// The value is valid. Set current EC ASIC board number
		sc_current_line = clipar;

		// Transmit "OK" answer message to tcp client
		cli_answ_type = CLI_ANSW_OK;
	}
}

/*************************** cmdCliExScAsic(clipar) ***************************
* Execute "slowctrl asic" command
* Used variables:
*	(o)sc_current_asic - current PMT number on EC ASIC board
*	(o)cli_answ_type - type of the answer to the TCP client
* Parameter:
*	(i)clipar - new value for "current asic" parameter
*******************************************************************************/
static void cmdCliExScAsic(uint32_t clipar)
{
	// Check the user value
	if(clipar < SC_N_OF_PMT_PER_ECASIC) {
		// The value is valid. Set current PMT number
		sc_current_asic = clipar;

		// Transmit "OK" answer message to tcp client
		cli_answ_type = CLI_ANSW_OK;
	}
}

/************************** cmdCliExScPixel(clipar) ***************************
* Execute "slowctrl pixel" command
* Used variables:
*	(o)sc_current_pixel - current pixel number
*	(o)cli_answ_type - type of the answer to the TCP client
* Parameter:
*	(i)clipar - new value for "current pixel" parameter
*******************************************************************************/
static void cmdCliExScPixel(uint32_t clipar)
{
	// Check the user value
	if(clipar < SC_N_OF_PIXELS_PER_PMT) {
		// The value is valid. Set current pixel number
		sc_current_pixel = clipar;

		// Transmit "OK" answer message to tcp client
		cli_answ_type = CLI_ANSW_OK;
	}
}

/************************** cmdCliExScDac10(clipar) ***************************
* Execute "slowctrl dac10" command
* Used variables:
*	(i)sc_current_asic - current PMT number on EC ASIC board
*	(i)sc_current_line - current EC ASIC board number (i.e. current line)
*	(o)sc_ind_userdata - slow control, individual user data for all spacirocs
*	(o)cli_answ_type - type of the answer to the TCP client
* Parameter:
*	(i)clipar - new dac10 setvalue
*******************************************************************************/
static void cmdCliExScDac10(uint32_t clipar)
{
	// Check the user value
	if(clipar <= SC_DAC_10BIT_MAX) {
		// The value is valid. Set dac10-bit value for the current PMT
		sc_ind_userdata.sc_sp3_sgl_asic[sc_current_asic][sc_current_line].dac10bit =
			clipar;

		// Transmit "OK" answer message to tcp client
		cli_answ_type = CLI_ANSW_OK;
	}
}

/*************************** cmdCliExScDac7(clipar) ***************************
* Execute "slowctrl dac7" command
* Used variables:
*	(i)sc_current_asic - current PMT number on EC ASIC board
*	(i)sc_current_line - current EC ASIC board number (i.e. current line)
*	(i)sc_current_pixel - current pixel number
*	(o)sc_ind_userdata - slow control, individual user data for all spacirocs
*	(o)cli_answ_type - type of the answer to the TCP client
* Parameter:
*	(i)clipar - new dac7 setvalue
*******************************************************************************/
static void cmdCliExScDac7(uint32_t clipar)
{
	// Check the user value
	if(clipar <= SC_DAC_7BIT_MAX) {
		// The value is valid. Set dac7-bit value for the current pixel
		sc_ind_userdata.sc_sp3_sgl_asic[sc_current_asic][sc_current_line].dac7bit[sc_current_pixel] = 
			clipar;

		// Transmit "OK" answer message to tcp client
		cli_answ_type = CLI_ANSW_OK;
	}
}

/***************************** cmdCliExScApply() ******************************
* Execute "slowctrl apply" command
* Creates structures (each structure is for all spacirocs):
*	individual user data structure -> individual data structure
*	individual data structure -> individual reformatted data structure
* Individual reformatted data structure is stored in the hardware fifo
* Individual data loading from hardware fifo to spacirocs is initiated
* Used variables:
*	(i)sc_ind_userdata - individual user data for all spacirocs
*	(o)sc_ind_all_asic_test - individual data for all spacirocs
*	(o)sc_reformatted - reformatted individual data for all spacirocs
*******************************************************************************/
static void cmdCliExScApply(void)
{
	// Init individual data structure
	scIndUsrDataToTst();

	// Init reformatted data structure
	scIndTstToRef();

	// Store reformatted data structure in the hardware fifo
	scIndRefToFifo();

	// DEBUG!!
	sleep(1);

	// Load individual data from fifo to all spacirocs
	scIndLoadData();
}

/**************************** cmdCliExScDac10RQ() *****************************
* Execute "slowctrl dac10?" command
* Reads dac10-bit value for the current PMT on the current line.
* The string representation of the value in written to tcp client answer buffer
* Used variables:
*	(i)sc_ind_userdata - slow control, individual user data for all spacirocs
*	(i)sc_current_asic - current PMT number on EC ASIC board
*	(i)sc_current_line - current EC ASIC board number (i.e. current line)
*	(o)cli_answ_buf - tcp client answer buffer (dac10-bit value is stored here)
*	(o)cli_answ_type - type of the answer to the TCP client
*******************************************************************************/
static void cmdCliExScDac10RQ(void)
{
	// Write dac10-bit value to the tcp client answer buffer
	cmdCliToBufDec(
		sc_ind_userdata.sc_sp3_sgl_asic[sc_current_asic][sc_current_line].dac10bit
	);
}

/***************************** cmdCliExScDac7RQ() *****************************
* Execute "slowctrl dac7?" command
* Reads dac7-bit value for the current pixel, current PMT on the current line.
* The string representation of the value in written to tcp client answer buffer
* Used variables:
*	(i)sc_ind_userdata - slow control, individual user data for all spacirocs
*	(i)sc_current_asic - current PMT number on EC ASIC board
*	(i)sc_current_line - current EC ASIC board number (i.e. current line)
*	(i)sc_current_pixel - current pixel number
*	(o)cli_answ_buf - tcp client answer buffer (dac7-bit value is stored here)
*	(o)cli_answ_type - type of the answer to the TCP client
*******************************************************************************/
static void cmdCliExScDac7RQ(void)
{
	// Write dac7-bit value to the tcp client answer buffer
	cmdCliToBufDec(
		sc_ind_userdata.sc_sp3_sgl_asic[sc_current_asic][sc_current_line].dac7bit[sc_current_pixel]
	);
}

/**************************** cmdCliToBufDec(val) *****************************
* Write the value to the tcp client answer buffer
* The value is converted to the string (decimal format)
* Client answer type is set to "answer from buffer"
* Used variables:
*	(o)cli_answ_buf - tcp client answer buffer
*	(o)cli_answ_type - type of the answer to the TCP client
*******************************************************************************/
static void cmdCliToBufDec(uint32_t val)
{
	// Write string representation of the value into the buffer
	snprintf(cli_answ_buf, CLI_ANSW_BUF_LEN,"%d",val);

	// Set the type of the answer message: "answer from buffer"
	cli_answ_type = CLI_ANSW_BUF;
}

/***************************** cmdCliAnswerSend() *****************************
* Create and send the answer to the tcp client
* Used variables:
*	(i)cli_idx - client index in the TCP server accepted clients array
*	(i)cli_answ_type - type of the answer to the TCP client
*	(i)cli_answ_buf - tcp client answer buffer
*******************************************************************************/
static void cmdCliAnswerSend(void)
{
	uint8_t buf[CLI_ANSW_BUF_LEN];

	// The data transmitted to client depends on the answer type
	switch(cli_answ_type){
		case CLI_ANSW_OK:
			// Create "OK" answer message to the client
			snprintf(buf, CLI_ANSW_BUF_LEN, "OK\n\n"); 
			break;

		case CLI_ANSW_BUF:
			// Create answer message to the client from buffer
			snprintf(buf, CLI_ANSW_BUF_LEN,"%s\n\n",cli_answ_buf);
			break;

		default:
			// Create "Error" answer message to the client
			snprintf(buf, CLI_ANSW_BUF_LEN, "Error\n\n");
	}

	// Transmit created message to tcp client
	tcpSrvTrAnswer(buf);
}

/****************************** scSameLoadData() ******************************
* Slow control: load same data parameters to all spacirocs
* Used variable:
*	(i)sc_same_data - slow control, same data for all spacirocs
*******************************************************************************/
static void scSameLoadData(void)
{
	uint32_t misc_reg0;
	uint32_t x2_tst_msk_dac;
	uint32_t misc_reg1;
	uint32_t x4_gain;
	uint32_t x4_dac_7b_sub;
	uint32_t misc_reg2;

	// Read same data parameters
	misc_reg0 = sc_same_data.misc_reg0;
	x2_tst_msk_dac = sc_same_data.x2_tst_msk_dac;
	misc_reg1 = sc_same_data.misc_reg1;
	x4_gain = sc_same_data.x4_gain;
	x4_dac_7b_sub = sc_same_data.x4_dac_7b_sub;
	misc_reg2 = sc_same_data.misc_reg2;

	// Write same data parameters to the correspondent files
	fileWriteHex(fname_sc_same_misc_reg0, misc_reg0);
	fileWriteHex(fname_sc_same_x2_tst_msk_dac, x2_tst_msk_dac);
	fileWriteHex(fname_sc_same_misc_reg1, misc_reg1);
	fileWriteHex(fname_sc_same_x4_gain, x4_gain);
	fileWriteHex(fname_sc_same_x4_dac_7b_sub, x4_dac_7b_sub);
	fileWriteHex(fname_sc_same_misc_reg2, misc_reg2);

	// Write command to load same data to the file
	fileWriteHex(fname_sc_cmd_load_data, SC_CMD_SAME_DATA);
}

/**************************** scIndUsrDataToTst() *****************************
* Slow control: initialize individual data structure
* The data values for initialization are taken from individual
*	user data structure.
* Used variables:
*	(i)sc_ind_userdata - individual user data for all spacirocs
*	(o)sc_ind_all_asic_test - individual data for all spacirocs
*******************************************************************************/
static void scIndUsrDataToTst(void)
{
	uint32_t i,j;
	SC_SP3_SGL_ASIC_USER_V0_t (*udata_array)[SC_N_OF_ECASIC_PER_PDM];
	SC_SP3_SGL_ASIC_USER_V0_t *udata_pmt;
	SC_SP3_SGL_ASIC_V1_t (*tdata_array)[SC_N_OF_ECASIC_PER_PDM];
	SC_SP3_SGL_ASIC_V1_t *tdata_pmt;
	
	// Clear the structure to initialize
	memset((char*)&sc_ind_all_asic_test, 0, SC_SP3_ALL_ASIC_V1_SZ);

	// Set the pointer to the PMT user data array
	udata_array = sc_ind_userdata.sc_sp3_sgl_asic;

	// Set the pointer to the PMT test data array
	tdata_array = sc_ind_all_asic_test.sc_sp3_sgl_asic;

	// Init data for each EC ASIC board cycle
	for(i = 0; i < SC_N_OF_ECASIC_PER_PDM; i++) {
		// Init data for each PMT on EC ASIC board cycle
		for(j = 0; j < SC_N_OF_PMT_PER_ECASIC; j++) {
			// Set the pointer to the current PMT user data
			udata_pmt = &udata_array[j][i];

			// Set the pointer to the current PMT test data
			tdata_pmt = &tdata_array[j][i];

			// Init individual data for one spaciroc
			scIndUsrDataToTstPmt(udata_pmt, tdata_pmt);	
		}
	}
}

/***************** scIndUsrDataToTstPmt(udata_pmt,tdata_pmt) ******************
* Slow control: initialize individual data for one spaciroc
* The data values for initialization are taken from individual
*	user data structure
* Parameters:
*	(i)udata_pmt - individual user data for one spaciroc
*	(o)tdata_pmt - individual data for one spaciroc
*******************************************************************************/
static void scIndUsrDataToTstPmt(SC_SP3_SGL_ASIC_USER_V0_t *udata_pmt, SC_SP3_SGL_ASIC_V1_t *tdata_pmt)
{
	uint32_t k;
	uint32_t dac10_value;
	uint32_t dac7_value;
	uint32_t c_pixel;

	// Read dac10-bit value for this PMT
	dac10_value = udata_pmt -> dac10bit;

	// Init miscellaneous registers in the target structure
	tdata_pmt -> misc_reg0 = SC_IND_INI_MISC_REG0 | dac10_value << SC_REG_MISC_REG0_DAC_OFFS;
	tdata_pmt -> misc_reg1 = SC_IND_INI_MISC_REG1;
	tdata_pmt -> misc_reg2 = SC_IND_INI_MISC_REG2;

	// Init data for each pixel cycle
	for(k = 0; k < SC_N_OF_PIXELS_PER_PMT; k++){
		// Read 1-bit pixel mask for this pixel
		c_pixel = udata_pmt -> pixel_mask[k];

		// Read dac7-bit value for this pixel
		dac7_value = udata_pmt -> dac7bit[k];

		// Init pixel mask and dac7-bit value in the target structure
		tdata_pmt -> tst_msk_dac[k] = dac7_value | (c_pixel<< SC_REG_TST_MSK_DAC_MSK_OFFS);
	}
}

/****************************** scIndTstToRef() *******************************
* Slow control: initialize reformatted data structure
* The data values for initialization are taken from individual data structure
* Used variables:
*	(i)sc_ind_all_asic_test - individual data for all spacirocs
*	(o)sc_reformatted - reformatted individual data for all spacirocs
*******************************************************************************/
static void scIndTstToRef(void)
{
	uint32_t i, i_remap, j;
	uint32_t chips_remap_table[] = {4, 2, 0, 1, 3, 5};
	SC_SP3_SGL_ASIC_V1_t (*tdata_array)[SC_N_OF_ECASIC_PER_PDM];
	SC_SP3_SGL_ASIC_V1_t *tdata_pmt;
	SC_SP3_6CHIPS_REFORMATTED_V1_t *rdata_col6_array;
	SC_SP3_6CHIPS_REFORMATTED_V1_t *rdata_col6_curr;

	// Set the pointer to the PMT test data array
	tdata_array = sc_ind_all_asic_test.sc_sp3_sgl_asic;

	// Set the pointer to the reformatted PMT columns array
	rdata_col6_array = sc_reformatted.sc_sp3_6chips_reformatted;

	// Init reformatted data: for each column of PMT cycle
	for(i = 0; i < SC_N_OF_PMT_PER_ECASIC; i++) {
		// Calculate EC ASIC board remap index for this column of PMT
		i_remap = chips_remap_table[i];

		// Set the pointer to the current column of PMT in reformatted structure
		rdata_col6_curr = &rdata_col6_array[i];

		// For each PMT in the current column cycle
		// (index of the cycle is EC ASIC board number for the column)
		for(j = 0; j < SC_N_OF_ECASIC_PER_PDM; j++) {
			// Set the pointer to the current PMT test data
			tdata_pmt = &tdata_array[i_remap][j];

			// Init reformatted data for one spaciroc
			scIndTstToRefPmt(tdata_pmt, rdata_col6_curr, j);
		}
	}
}

/****************** scIndTstToRefPmt(tdata_pmt,rdata_col6,j) ******************
* Slow control: initialize reformatted data for one spaciroc
* The data values for initialization are taken from individual data structure
* Parameters:
*	(i)tdata_pmt - individual data for one spaciroc
*	(o)rdata_col6 - reformatted data for one column - 6 spacirocs
*	(i)j - EC ASIC board number, identifies spaciroc in the column
*******************************************************************************/
static void scIndTstToRefPmt(SC_SP3_SGL_ASIC_V1_t *tdata_pmt,
	SC_SP3_6CHIPS_REFORMATTED_V1_t *rdata_col6, uint32_t j)
{
	uint32_t k;

	// Write miscellaneous registers to reformatted structure
	rdata_col6 -> misc_reg0[j] = tdata_pmt -> misc_reg0;
	rdata_col6 -> misc_reg1[j] = tdata_pmt -> misc_reg1;
	rdata_col6 -> misc_reg2[j] = tdata_pmt -> misc_reg2;

	// Write dac7 & mask. For each 2 pixels cycle
	for(k = 0; k < SC_N_OF_PIXELS_PER_PMT/2; k++)
		// Pack dac7 & mask for 2 pixels in one 32-bit value
		rdata_col6 -> x2_tst_msk_dac[k][j] = 
			tdata_pmt -> tst_msk_dac[63 - (2*k+0)] << 16 |
			tdata_pmt -> tst_msk_dac[63 - (2*k+1)];

	// Write gain. For each 4 pixels cycle
	for(k = 0; k < SC_N_OF_PIXELS_PER_PMT/4; k++)
		// Pack gain for 4 pixels in one 32-bit value
		rdata_col6 -> x4_gain[k][j] =
			tdata_pmt -> gain[63 - (4*k+0)] << 24 |
			tdata_pmt -> gain[63 - (4*k+1)] << 16 |
			tdata_pmt -> gain[63 - (4*k+2)] << 8 |
			tdata_pmt -> gain[63 - (4*k+3)];

	// Write dac 7b_sub. For each 32 pixels cycle
	for(k = 0; k < SC_N_OF_PIXELS_PER_PMT/4/8; k++)
		// Pack 4 one-byte values, each for 8 pixels in one 32-bit value
		rdata_col6 -> x4_dac_7b_sub[k][j] =
			tdata_pmt -> dac_7b_sub[7 - (4*k+0)] << 24 |
			tdata_pmt -> dac_7b_sub[7 - (4*k+1)] << 16 |
			tdata_pmt -> dac_7b_sub[7 - (4*k+2)] << 8 |
			tdata_pmt -> dac_7b_sub[7 - (4*k+3)];
}

/****************************** scIndRefToFifo() ******************************
* Slow control: store reformatted data structure in the hardware fifo
* Used variables:
*	(i)sc_reformatted - reformatted individual data for all spacirocs
*	(i)fname_sc_fifo_cdev - character device file name
*							(to send data to hardware fifo)
*******************************************************************************/
static void scIndRefToFifo(void)
{
	uint32_t data_idx;

	printf("telnet-uapp: transmitting data to hardware fifo, length=%d",
			SC_SP3_36CHIPS_REFORMATTED_V1_SZ);
	for(data_idx = 0; data_idx < SC_SP3_36CHIPS_REFORMATTED_V1_SZ; data_idx++){
		if(data_idx%0x20 == 0) printf("\n");
		printf("%.2X ", ((uint8_t *)(&sc_reformatted))[data_idx]);
	}
	printf("\n telnet-uapp: data END \n");

	// Write reformatted data structure to the file
	fileWriteBuf(fname_sc_fifo_cdev,
		(char *)(&sc_reformatted), SC_SP3_36CHIPS_REFORMATTED_V1_SZ);
}

/****************************** scIndLoadData() *******************************
* Slow control: load individual data parameters to all spacirocs
* The data must be stored in hardware fifo before calling this function
*******************************************************************************/
static void scIndLoadData(void)
{
	//  Write command to load individual data to the file
	fileWriteHex(fname_sc_cmd_load_data, SC_CMD_IND_DATA);
}

/*********************** fileReadStr(fname,buf,buflen) ************************
* Read one string from a file
* The final zero at the end of a string is added to the user buffer
* Parameters:
*	(i)fname - file name
*	(o)buf - user buffer to store the data
*	(i)buflen - length of user buffer
* Return value:
*	-1 Error: can not read string from a file
*	0  Success: the string was read successfully
*******************************************************************************/
static int fileReadStr(const char *fname, char *buf, uint32_t buflen)
{
	FILE *file;
	char *s;
	int rc;
	
	// Open the file for reading
	file = fopen(fname, "r");
	if(file == NULL) return -1;			// Can not open the file

	// Read the string from a file
	s = fgets(buf,buflen,file);
	if(s == NULL) rc = -1;				// Can not read string from file
	else rc = 0;						// The string was read successfully

	// Close file 
	fclose(file);

	// Return success/error code
	return rc;
}

/************************ fileWriteBuf(fname,buf,len) *************************
* Write binary data to the file
* Parameters:
*	(i)fname - file name
*	(i)buf - buffer, contains data to store in the file
*	(i)len - length of the data (b)
* Return value:
*	-1 Error: can not write data to the file
*	0  Success: the data was written to the file
*******************************************************************************/
static int fileWriteBuf(const char *fname, char *buf, uint32_t len)
{
	FILE *file;
	int rc;

	printf("telnet-uapp: file: %s -- writing buffer \n",fname);

	// Open the file for writing
	file = fopen(fname, "wb");
	if(file == NULL) return -1;			// Can not open the file

	printf("telnet-uapp: file: %s was opened successfully \n",fname);


	// Write the data from buffer to the file
	if(fwrite(buf,1,len,file) == len)
		rc = 0;			// Success, the data was written to the file
	else
		rc = -1;		// Error, the data was not written to the file

	if(rc == 0) printf("telnet-uapp: file: %s was written successfully \n",fname);
		
	// Close file 
	fclose(file);

	// Return success/error code
	return rc;
}

/************************** fileWriteDec(fname,val) ***************************
* Write text representation (decimal) of a value to the file
* Parameters:
*	(i)fname - file name
*	(i)val - 32-bit value to write to the file
*******************************************************************************/
static void fileWriteDec(const char *fname, uint32_t val)
{
	uint8_t fl_cmd[FL_CMD_LEN_MAX + 1];	// +1 for the zero at the end of string

	// Make a string to write new value to the file
	snprintf(fl_cmd,FL_CMD_LEN_MAX, "echo %d > %s",val,fname);

	// Execute created command
	system(fl_cmd);
}

/******************** fileWriteDecIdx(fname_base,idx,val) *********************
* Write text representation (decimal) of a value to the file
* The file name is generated here. 
* It is made with base file name and the one-digit decimal index:
*	<file name> ::= <base file name><one-digit decimal index>
* Parameters:
*	(i)fname_base - base filename
*	(i)idx - one-digit decimal index
*	(i)val - 32-bit value to write to the file
*******************************************************************************/
static void fileWriteDecIdx(const char *fname_base, uint32_t idx, uint32_t val)
{
	uint8_t fl_cmd[FL_CMD_LEN_MAX + 1];	// +1 for the zero at the end of string

	// Make a string to write new value to the file
	snprintf(fl_cmd,FL_CMD_LEN_MAX, "echo %d > %s%.1d",val,fname_base,idx);

	// Execute created command
	system(fl_cmd);
}

/************************** fileWriteHex(fname,val) ***************************
* Write text representation (hex) of a value to the file
* Parameters:
*	(i)fname - file name
*	(i)val - 32-bit value to write to the file
*******************************************************************************/
static void fileWriteHex(const char *fname, uint32_t val)
{
	uint8_t fl_cmd[FL_CMD_LEN_MAX + 1];	// +1 for the zero at the end of string

	// Make a string to write new value to the file
	snprintf(fl_cmd,FL_CMD_LEN_MAX, "echo %x > %s",val,fname);

	// Execute created command
	system(fl_cmd);
}

