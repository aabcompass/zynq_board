/******************************************************************************
*
* Copyright (C) 2009 - 2017 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

#include <stdio.h>

#include "xparameters.h"

#include "netif/xadapter.h"

#include "platform.h"
#include "platform_config.h"
#if defined (__arm__) || defined(__aarch64__)
#include "xil_printf.h"
#endif

#include "lwip/tcp.h"
#include "xil_cache.h"

#if LWIP_IPV6==1
#include "lwip/ip.h"
#else
#if LWIP_DHCP==1
#include "lwip/dhcp.h"
#endif
#endif

#include "xuartps_hw.h"

#include "own_data_types.h"
#include "common.h"
#include "data_provider.h"


/* defined by each RAW mode application */
void print_app_header();
int start_application();
int transfer_data();
void tcp_fasttmr(void);
void tcp_slowtmr(void);

/* missing declaration in lwIP */
void lwip_init();

#if LWIP_IPV6==0
#if LWIP_DHCP==1
extern volatile int dhcp_timoutcntr;
err_t dhcp_start(struct netif *netif);
#endif
#endif

extern volatile int TcpFastTmrFlag;
extern volatile int TcpSlowTmrFlag;
static struct netif server_netif;
struct netif *echo_netif;

extern InstrumentState instrumentState;

#if LWIP_IPV6==1
void print_ip6(char *msg, ip_addr_t *ip)
{
	print(msg);
	xil_printf(" %x:%x:%x:%x:%x:%x:%x:%x\n\r",
			IP6_ADDR_BLOCK1(&ip->u_addr.ip6),
			IP6_ADDR_BLOCK2(&ip->u_addr.ip6),
			IP6_ADDR_BLOCK3(&ip->u_addr.ip6),
			IP6_ADDR_BLOCK4(&ip->u_addr.ip6),
			IP6_ADDR_BLOCK5(&ip->u_addr.ip6),
			IP6_ADDR_BLOCK6(&ip->u_addr.ip6),
			IP6_ADDR_BLOCK7(&ip->u_addr.ip6),
			IP6_ADDR_BLOCK8(&ip->u_addr.ip6));

}
#else
void
print_ip(char *msg, ip_addr_t *ip)
{
	print(msg);
	xil_printf("%d.%d.%d.%d\n\r", ip4_addr1(ip), ip4_addr2(ip), 
			ip4_addr3(ip), ip4_addr4(ip));
}

void
print_ip_settings(ip_addr_t *ip, ip_addr_t *mask, ip_addr_t *gw)
{

	print_ip("Board IP: ", ip);
	print_ip("Netmask : ", mask);
	print_ip("Gateway : ", gw);
}
#endif

#if defined (__arm__) && !defined (ARMR5)
#if XPAR_GIGE_PCS_PMA_SGMII_CORE_PRESENT == 1 || XPAR_GIGE_PCS_PMA_1000BASEX_CORE_PRESENT == 1
int ProgramSi5324(void);
int ProgramSfpPhy(void);
#endif
#endif

#ifdef XPS_BOARD_ZCU102
#ifdef XPAR_XIICPS_0_DEVICE_ID
int IicPhyReset(void);
#endif
#endif




void netifSetDown()
{
	netif_set_down(echo_netif);
}


int main()
{
	u32 tmp;

	print("Starting main program...\n\r");

	#if LWIP_IPV6==0
	ip_addr_t ipaddr, netmask, gw;
	char c_uart[] = {0, 0};
	//u32 ip_addr;

#endif
	/* the mac address of the board. this should be unique per board */
	unsigned char mac_ethernet_address[] =
	{ 0x00, 0x0a, 0x35, 0x00, 0x01, 0x02 };

	echo_netif = &server_netif;
#if defined (__arm__) && !defined (ARMR5)
#if XPAR_GIGE_PCS_PMA_SGMII_CORE_PRESENT == 1 || XPAR_GIGE_PCS_PMA_1000BASEX_CORE_PRESENT == 1
	ProgramSi5324();
	ProgramSfpPhy();
#endif
#endif

/* Define this board specific macro in order perform PHY reset on ZCU102 */
#ifdef XPS_BOARD_ZCU102
	IicPhyReset();
#endif

	init_platform();

#if LWIP_IPV6==0
#if LWIP_DHCP==1
    ipaddr.addr = 0;
	gw.addr = 0;
	netmask.addr = 0;
#else
	print("XADC initialization...\n\r");
	XAdcPolledInit(XPAR_XADCPS_0_DEVICE_ID);
	print("SD card file system initialization...\n\r");
	instrumentState.err_SDcard = FfsSdPolledInit();
	if(instrumentState.err_SDcard)
		xil_printf("err_SDcard = %d\n\r", instrumentState.err_SDcard);
	ReadIPaddr(&instrumentState.ZB_number);


	mac_ethernet_address[5] = instrumentState.ZB_number - 8; // for the compatibility with Mini-EUSO MAC
	/* initliaze IP addresses to be used */
	IP4_ADDR(&ipaddr,  192, 168,   7, instrumentState.ZB_number);
	instrumentState.ZB_number -= 9;
	IP4_ADDR(&netmask, 255, 255, 255,  0);
	IP4_ADDR(&gw,      192, 168,   7,  1);
#endif	
#endif
	lwip_init();

#if (LWIP_IPV6 == 0)
	/* Add network interface to the netif_list, and set it as default */
	if (!xemac_add(echo_netif, &ipaddr, &netmask,
						&gw, mac_ethernet_address,
						PLATFORM_EMAC_BASEADDR)) {
		xil_printf("Error adding N/W interface\n\r");
		return -1;
	}
#else
	/* Add network interface to the netif_list, and set it as default */
	if (!xemac_add(echo_netif, NULL, NULL, NULL, mac_ethernet_address,
						PLATFORM_EMAC_BASEADDR)) {
		xil_printf("Error adding N/W interface\n\r");
		return -1;
	}
	echo_netif->ip6_autoconfig_enabled = 1;

	netif_create_ip6_linklocal_address(echo_netif, 1);
	netif_ip6_addr_set_state(echo_netif, 0, IP6_ADDR_VALID);

	print_ip6("\n\rBoard IPv6 address ", &echo_netif->ip6_addr[0].u_addr.ip6);

#endif
	netif_set_default(echo_netif);

	/* now enable interrupts */
	platform_enable_interrupts();

	/* specify that the network if is up */
	netif_set_up(echo_netif);

#if (LWIP_IPV6 == 0)
#if (LWIP_DHCP==1)
	/* Create a new DHCP client for this interface.
	 * Note: you must call dhcp_fine_tmr() and dhcp_coarse_tmr() at
	 * the predefined regular intervals after starting the client.
	 */
	dhcp_start(echo_netif);
	dhcp_timoutcntr = 24;

	while(((echo_netif->ip_addr.addr) == 0) && (dhcp_timoutcntr > 0))
		xemacif_input(echo_netif);

	if (dhcp_timoutcntr <= 0) {
		if ((echo_netif->ip_addr.addr) == 0) {
			xil_printf("DHCP Timeout\r\n");
			xil_printf("Configuring default IP of 192.168.1.10\r\n");
			IP4_ADDR(&(echo_netif->ip_addr),  192, 168,   7, 10);
			IP4_ADDR(&(echo_netif->netmask), 255, 255, 255,  0);
			IP4_ADDR(&(echo_netif->gw),      192, 168,   7,  1);
		}
	}

	ipaddr.addr = echo_netif->ip_addr.addr;
	gw.addr = echo_netif->gw.addr;
	netmask.addr = echo_netif->netmask.addr;
#endif

	print_ip_settings(&ipaddr, &netmask, &gw);

#endif

	//scanf("%s", &tmp);

	SetDefaultParameters();


	print("HVPS expander initialization...");
	instrumentState.is_HVPS_OK = expIni(); //init hv
	if(!instrumentState.is_HVPS_OK)
		print("HVPS seems not connected or powered\n\r");
	else
		print("Ok\n\r");



	//print("ARTIX SPI initialization...\n\r");
	//init_loadbit_spi();
	print("ARTIX loading...\n\r");
	//PrepareArtixConfiguration();

	print("Starting Artix clock\n\r");
	SetGtuFreq1us(1);
	ArtixClkEn(1);

	xil_printf("Loading FW to Artixes with FW file %s\n\r", FILENAME_ARTIX_BITSTREAM_1_BOARD);
	*(u32*)(XPAR_AXI_GPIO_0_BASEADDR) = 3;
	LoadArtix(FILENAME_ARTIX_BITSTREAM_1_BOARD);
	LoadArtix(FILENAME_ARTIX_BITSTREAM_1_BOARD);
	LoadArtix(FILENAME_ARTIX_BITSTREAM_1_BOARD);

	SetArtixTransmitDelay(2);

	//print("SetPMTZero ...\n\r");
	//SetPMTZero();

	print("SPACIROC FIFO initialization...\n\r");
	XLlFifoPollingInit();

	print("Reset SPACIROCs...\n\r");
	ResetSPACIROC3();

	print("Setting slow control speed...\n\r");
	SetSC_speed(512);


	print("HLS peripherals initialization...\n\r");
	ResetScurveAdder();
	ResetDataConverter();
	InitHLS_peripherals(1, N_INTEGRATION);

	print("Starting TCP client Telnet server on port 23 ...\n\r");
	start_telnet_cmd();

	print("MmgInit ...\n\r");
	MmgInit();
	print("Memory file system init ...\n\r");
	FileSystemInit();

	print("Starting FTP server ...\n\r");
	start_ftp_server_cmd();

	print("Send default mapping ...\n\r");
	SendDefaultMapping();

	print("Flow control initialization...\n\r");
	FlowControlInit_D1();

	print("Trigger initial configuration...\n\r");
	L1_send_Marco_params();

	print("Set periodic trigger by default...\n\r");
	SetModeD1(BIT_FC_EN_PERIODIC_TRIG);

	/* start the application (web server, rxtest, txtest, etc..) */
	//start_application();
	print("DMA_init()\n\r");
	DMA_init();

	PrintDataSizes();
	/* receive and process packets */
	while (1) {
		if (TcpFastTmrFlag) {
			tcp_fasttmr();
			TcpFastTmrFlag = 0;
		}
		if (TcpSlowTmrFlag) {
			tcp_slowtmr();
			TcpSlowTmrFlag = 0;
		}
		xemacif_input(echo_netif);
		send_data_sm();
		scurve_sm();
		pixelscan_sm();
		L1_trigger_service();
		MPS_service();

		if(XUartPs_IsReceiveData(XPAR_PS7_UART_0_BASEADDR/*STDOUT_BASEADDRESS*/))
		{
			c_uart[0] = XUartPs_RecvByte(XPAR_PS7_UART_0_BASEADDR/*STDOUT_BASEADDRESS*/);
			print(c_uart);
			ProcessUartCommands(echo_netif, c_uart[0]);
			//print("*");
		}
		//HVInterruptService(); // leads to FTP server stalls after few seconds
		//print(".");
	}
  
	/* never reached */
	cleanup_platform();

	return 0;
}
