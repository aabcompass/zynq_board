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

#define N_OF_ARTIXES	3

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
#define BIT_ART_DATA_IDELAY		13 /* to 17, 5 bits */
#define BIT_ART_DATA_LD			18 /* to 29*/

//REG_OUTDATA
#define BIT_ART_LATCH		2

u32 artix_conf_word[N_OF_ARTIXES] = {0, 0, 0};

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
		*(u32*)(XPAR_AXI_ARTIX_CONF_V1_0_0_BASEADDR + 4*REG_OUTDATA) = (param<<BIT_ART_LATCH);
	else
		*(u32*)(XPAR_AXI_ARTIX_CONF_V1_0_0_BASEADDR + 4*REG_OUTDATA) = 0;
}


void LoadAnArtix_u32(u32 value, u32 artix_num) //artix_num=0|1|2
{
	xil_printf("Loading 0x%08X to the cross boards %d\n\r", value, artix_num);
	u32 value_swapped = SWAP_UINT32(value);

	SetBitstreamPtr(&value_swapped, 4);
	init_loadbit_spi();
	upload_bit();
	ArtixLatch(1<<artix_num);
	ArtixLatch(0);

	print("Value has been sent\n\r");
}

void LoadAllArtixes_u32(u32 value)
{
	xil_printf("Loading 0x%08X paralelly to all cross boards\n\r", value);
	u32 value_swapped = SWAP_UINT32(value);

	SetBitstreamPtr(&value_swapped, 4);
	init_loadbit_spi();
	upload_bit();
	ArtixLatch(7);
	ArtixLatch(0);

	print("Values have been sent\n\r");
}

void SetArtixTestMode(u32 mode)
{
	int i;
	for(i=0;i<N_OF_ARTIXES; i++) {
		if(mode == 1)
			artix_conf_word[i] |= (1<<BIT_ART_CONF_TEST);
		else
			artix_conf_word[i] &= ~(1<<BIT_ART_CONF_TEST);

		LoadAnArtix_u32(artix_conf_word[i], i);
	}
}

void SetArtixTestMode2(u32 mode)
{
	int i;
	for(i=0;i<N_OF_ARTIXES; i++) {
		if(mode == 1)
			artix_conf_word[i] |= (1<<BIT_ART_CONF_TEST2);
		else
			artix_conf_word[i] &= ~(1<<BIT_ART_CONF_TEST2);

		LoadAnArtix_u32(artix_conf_word[i], i);
	}
}


void SetArtixTransmitDelay(u32 delay) // 0...15
{
	int i;
	for(i=0;i<N_OF_ARTIXES; i++) {
		artix_conf_word[i] &= ~(0xF<<BIT_ART_CONF_TDELAY);
		artix_conf_word[i] |= (delay<<BIT_ART_CONF_TDELAY);
		LoadAnArtix_u32(artix_conf_word[i], i);
	}
}

void SetArtixFracDelay(u32 delay) // 0...15
{
	int i;
	for(i=0;i<N_OF_ARTIXES; i++) {
		artix_conf_word[i] &= ~(0xF<<BIT_ART_CONF_FRACDELAY);
		artix_conf_word[i] |= (delay<<BIT_ART_CONF_FRACDELAY);
		LoadAnArtix_u32(artix_conf_word[i], i);
	}
}

void SetArtixFrameOn(u32 param) // 0|1
{
	int i;
	for(i=0;i<N_OF_ARTIXES; i++) {
		if(param == 1)
			artix_conf_word[i] |= (1<<BIT_ART_CONF_FRAMEON);
		else
			artix_conf_word[i] &= ~(1<<BIT_ART_CONF_FRAMEON);
	}

	LoadAllArtixes_u32(artix_conf_word[0]);
}

void SetArtixAcqOn()
{
	int i;
	for(i=0;i<N_OF_ARTIXES; i++) {
		artix_conf_word[i] |= (1<<BIT_ART_CONF_ACQON);
	}
	LoadAllArtixes_u32(artix_conf_word[0]);
}

void SetIDelayLD(u32 idelay, u32 ld, u32 art)
{
	artix_conf_word[art] &= ~(((1<<17)-1)<<BIT_ART_DATA_IDELAY);
	artix_conf_word[art] |= (idelay<<BIT_ART_DATA_IDELAY) | (ld<<BIT_ART_DATA_LD);

	//LoadAllArtixes_u32(artix_conf_word[0]);
	LoadAnArtix_u32(artix_conf_word[art], art);
}

void SetIDelay_individual(u32 idelay, u32 PMT_in_artix, u32 n_artix)
{
	artix_conf_word[n_artix] &= ~(((1<<17)-1)<<BIT_ART_DATA_IDELAY);
	artix_conf_word[n_artix] |= (idelay<<BIT_ART_DATA_IDELAY) | (1<<(PMT_in_artix+BIT_ART_DATA_LD));
	LoadAnArtix_u32(artix_conf_word[n_artix], n_artix);
}


//void SetArtix0101()
//{
//	LoadArtix_u32(0x12345678);
//}


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
