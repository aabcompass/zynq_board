/*
 * loadbit.c
 *
 *  Created on: 13 ��� 2016 �.
 *      Author: XILINX
 */


#include "xparameters.h"
#include "xspi.h"
#include "common.h"
#include "own_data_types.h"



XSpi spi;
u8 * bitstream;
int bitsize;

extern InstrumentState instrumentState;

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

/*!!! THESE VALUES ARE SHIFTED BY 1 !!!*/
#define BIT_ART_CONF_FRACDELAY	1
#define BIT_ART_CONF_TEST		4
#define BIT_ART_CONF_TDELAY		5
#define BIT_ART_CONF_TEST2		9
#define BIT_ART_CONF_FRAMEON	11
#define BIT_ART_CONF_ACQON		12

u32 artix_conf_word = 0;

char artix_file_name[20];

//void PrepareArtixConfiguration()
//{
//	*(u32*)(XPAR_AXI_ARTIX_CONF_V1_0_0_BASEADDR + 4*REG_OUTDATA) = (1<<BIT_PROGRAMB) | (1<<BIT_INITB);
//	*(u32*)(XPAR_AXI_ARTIX_CONF_V1_0_0_BASEADDR + 4*REG_TRIDATA) = (1<<BIT_PROGRAMB) | (1<<BIT_INITB);
//}


void init_loadbit_spi()
{
	XStatus Status;
	XSpi_Initialize(&spi, XPAR_AXI_QUAD_SPI_0_DEVICE_ID);

	//Status = XSpi_SetOptions(&spi, XSP_MASTER_OPTION | /*XSP_CLK_PHASE_1_OPTION | */XSP_CLK_ACTIVE_LOW_OPTION);
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
	xil_printf("Loading 0x%08X paralelly to the all cross boards\n\r", value);
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

void SetArtixFrameOn(u32 param) // 0|1
{
	if(param == 1)
		artix_conf_word |= (1<<BIT_ART_CONF_FRAMEON);
	else
		artix_conf_word &= ~(1<<BIT_ART_CONF_FRAMEON);

	LoadArtix_u32(artix_conf_word);
}

void SetArtixAcqOn()
{
	artix_conf_word |= (1<<BIT_ART_CONF_ACQON);
	LoadArtix_u32(artix_conf_word);
}

void SetArtix0101()
{
	LoadArtix_u32(0x12345678);
}


int LoadArtix(char * filename)
{
	int err;
	char artixBitstream[10000000]; // 10 MBytes
	int artixBitstream_size;
	instrumentState.artix_locked = *(u32*)(XPAR_AXI_GPIO_0_BASEADDR)  & 0x7;
	xil_printf("artix_locked=%d\n\r",  instrumentState.artix_locked);
	strcpy(artix_file_name, filename);
//	if(instrumentState.artix_locked == 7)
//	{
//		print("Artix already loaded.\n\r");
//		return 0;
//	}
//	else
	{
		print("Loading bitstream to the cross board\n\r");
		//PrepareArtixConfiguration();

		err = ReadArtixBitstream(&artixBitstream, &artixBitstream_size, filename);
		if(!err) {
			SetBitstreamPtr(&artixBitstream, artixBitstream_size);
			init_loadbit_spi();
			//print("StartArtixConfiguration()\n\r");
			//StartArtixConfiguration(); //???
			upload_bit();
			print("Cross board has been loaded\n\r");
			instrumentState.artix_locked = *(u32*)(XPAR_AXI_GPIO_0_BASEADDR);
			instrumentState.is_artix_loaded = GetArtixLoadState();
			xil_printf("GetArtixLoadState() returns %d\n\r", instrumentState.is_artix_loaded);
			xil_printf("artix_locked = %x\n\r", instrumentState.artix_locked);
			return 0;
		}
		else
		{
			print("Cross board NOT loaded\n\r");
			return err;
		}
	}
}

char* GetArtixFileName()
{
	return artix_file_name;
}
