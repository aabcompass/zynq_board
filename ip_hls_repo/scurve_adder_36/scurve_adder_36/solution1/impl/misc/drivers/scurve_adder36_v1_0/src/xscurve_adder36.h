// ==============================================================
// File generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
// Version: 2018.1
// Copyright (C) 1986-2018 Xilinx, Inc. All Rights Reserved.
// 
// ==============================================================

#ifndef XSCURVE_ADDER36_H
#define XSCURVE_ADDER36_H

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files *********************************/
#ifndef __linux__
#include "xil_types.h"
#include "xil_assert.h"
#include "xstatus.h"
#include "xil_io.h"
#else
#include <stdint.h>
#include <assert.h>
#include <dirent.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stddef.h>
#endif
#include "xscurve_adder36_hw.h"

/**************************** Type Definitions ******************************/
#ifdef __linux__
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
#else
typedef struct {
    u16 DeviceId;
    u32 Ctrl_bus_BaseAddress;
} XScurve_adder36_Config;
#endif

typedef struct {
    u32 Ctrl_bus_BaseAddress;
    u32 IsReady;
} XScurve_adder36;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XScurve_adder36_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XScurve_adder36_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XScurve_adder36_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XScurve_adder36_ReadReg(BaseAddress, RegOffset) \
    *(volatile u32*)((BaseAddress) + (RegOffset))

#define Xil_AssertVoid(expr)    assert(expr)
#define Xil_AssertNonvoid(expr) assert(expr)

#define XST_SUCCESS             0
#define XST_DEVICE_NOT_FOUND    2
#define XST_OPEN_DEVICE_FAILED  3
#define XIL_COMPONENT_IS_READY  1
#endif

/************************** Function Prototypes *****************************/
#ifndef __linux__
int XScurve_adder36_Initialize(XScurve_adder36 *InstancePtr, u16 DeviceId);
XScurve_adder36_Config* XScurve_adder36_LookupConfig(u16 DeviceId);
int XScurve_adder36_CfgInitialize(XScurve_adder36 *InstancePtr, XScurve_adder36_Config *ConfigPtr);
#else
int XScurve_adder36_Initialize(XScurve_adder36 *InstancePtr, const char* InstanceName);
int XScurve_adder36_Release(XScurve_adder36 *InstancePtr);
#endif

void XScurve_adder36_Start(XScurve_adder36 *InstancePtr);
u32 XScurve_adder36_IsDone(XScurve_adder36 *InstancePtr);
u32 XScurve_adder36_IsIdle(XScurve_adder36 *InstancePtr);
u32 XScurve_adder36_IsReady(XScurve_adder36 *InstancePtr);
void XScurve_adder36_EnableAutoRestart(XScurve_adder36 *InstancePtr);
void XScurve_adder36_DisableAutoRestart(XScurve_adder36 *InstancePtr);

void XScurve_adder36_Set_N_ADDS(XScurve_adder36 *InstancePtr, u32 Data);
u32 XScurve_adder36_Get_N_ADDS(XScurve_adder36 *InstancePtr);
void XScurve_adder36_Set_TEST_MODE(XScurve_adder36 *InstancePtr, u32 Data);
u32 XScurve_adder36_Get_TEST_MODE(XScurve_adder36 *InstancePtr);

void XScurve_adder36_InterruptGlobalEnable(XScurve_adder36 *InstancePtr);
void XScurve_adder36_InterruptGlobalDisable(XScurve_adder36 *InstancePtr);
void XScurve_adder36_InterruptEnable(XScurve_adder36 *InstancePtr, u32 Mask);
void XScurve_adder36_InterruptDisable(XScurve_adder36 *InstancePtr, u32 Mask);
void XScurve_adder36_InterruptClear(XScurve_adder36 *InstancePtr, u32 Mask);
u32 XScurve_adder36_InterruptGetEnabled(XScurve_adder36 *InstancePtr);
u32 XScurve_adder36_InterruptGetStatus(XScurve_adder36 *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
