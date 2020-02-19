/*
 * loadbit.c
 *
 *  Created on: 13 ��� 2016 �.
 *      Author: XILINX
 */


#include "xparameters.h"
#include "xspi.h"
#include "common.h"



XSpi spi;
u8 * bitstream;
int bitsize;

#define REG_OUTDATA 	0
#define REG_TRIDATA		1
#define REG_INDATA		3

#define BIT_PROGRAMB	0
#define BIT_INITB		1
#define BIT_DONE		2

#define LINE_ACTIVE		1

//ATRIX CONF WORD BITS
//#define BIT_ART_CONF_TEST		3
//#define BIT_ART_CONF_TDELAY	4
//#define BIT_ART_CONF_TEST2	8
#define BIT_ART_CONF_FRACDELAY	1
#define BIT_ART_CONF_TEST		4
#define BIT_ART_CONF_TDELAY		5
#define BIT_ART_CONF_TEST2		9

u32 artix_conf_word = 0;

//void PrepareArtixConfiguration()
//{
//	*(u32*)(XPAR_AXI_ARTIX_CONF_V1_0_0_BASEADDR + 4*REG_OUTDATA) = (1<<BIT_PROGRAMB) | (1<<BIT_INITB);
//	*(u32*)(XPAR_AXI_ARTIX_CONF_V1_0_0_BASEADDR + 4*REG_TRIDATA) = (1<<BIT_PROGRAMB) | (1<<BIT_INITB);
//}

void init_loadbit_spi()
{
	XStatus Status;
	XSpi_Initialize(&spi, XPAR_AXI_QUAD_SPI_0_DEVICE_ID);

	Status = XSpi_SetOptions(&spi, XSP_MASTER_OPTION);
	if (Status != XST_SUCCESS) {
		xil_printf("XSpi_SetOptions returns %d\n\r", Status);
		return;
	}
	XSpi_SetSlaveSelect(&spi, 1);
	XSpi_Start(&spi);
	XSpi_IntrGlobalDisable(&spi);
}

void upload_bit()
{
	int ret;
	print("Start transfer...\n\r");
	ret = XSpi_Transfer(&spi, bitstream, NULL, bitsize);
	xil_printf("XSpi_Transfer returns %d\n\r", ret);
}


u8* SetBitstreamPtr(char* ptr, int size)
{
	bitstream = ptr;
	bitsize = size;
}

u32 GetArtixLoadState()
{
	return *(u32*)(XPAR_AXI_ARTIX_CONF_V1_0_0_BASEADDR + 4*REG_INDATA);
}

void ArtixLatch(u32 param)
{
	if(param)
		*(u32*)(XPAR_AXI_ARTIX_CONF_V1_0_0_BASEADDR + 4*REG_OUTDATA) = 0xFFFFFFFF;//param*(1<<BIT_DONE);
	else
		*(u32*)(XPAR_AXI_ARTIX_CONF_V1_0_0_BASEADDR + 4*REG_OUTDATA) = 0;
}

void LoadArtix_u32(u32 value)
{
	print("Loading uint32_t paralelly to the all cross boards\n\r");
	u32 value_swapped = SWAP_UINT32(value);

	SetBitstreamPtr(&value_swapped, 4);
	init_loadbit_spi();
	upload_bit();
	ArtixLatch(1);
	ArtixLatch(0);

	print("Value has been sent\n\r");
}


void SetArtixTestMode(u32 mode)
{
	if(mode == 1)
		artix_conf_word |= (1<<BIT_ART_CONF_TEST);
	else
		artix_conf_word &= ~(1<<BIT_ART_CONF_TEST);

	LoadArtix_u32(artix_conf_word);
}

void SetArtixTestMode2(u32 mode)
{
	if(mode == 1)
		artix_conf_word |= (1<<BIT_ART_CONF_TEST2);
	else
		artix_conf_word &= ~(1<<BIT_ART_CONF_TEST2);

	LoadArtix_u32(artix_conf_word);
}


void SetArtixTransmitDelay(u32 delay) // 0...15
{
	artix_conf_word &= ~(0xF<<BIT_ART_CONF_TDELAY);
	artix_conf_word |= (delay<<BIT_ART_CONF_TDELAY);
	LoadArtix_u32(artix_conf_word);
}

void SetArtixFracDelay(u32 delay) // 0...15
{
	artix_conf_word &= ~(0xF<<BIT_ART_CONF_FRACDELAY);
	artix_conf_word |= (delay<<BIT_ART_CONF_FRACDELAY);
	LoadArtix_u32(artix_conf_word);
}


