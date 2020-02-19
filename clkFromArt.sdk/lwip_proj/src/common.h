/*
 * common.h
 *
 *  Created on: Jan 9, 2020
 *      Author: alx
 */

#ifndef SRC_COMMON_H_
#define SRC_COMMON_H_

#define SWAP_UINT32(x) (((x) >> 24) | (((x) & 0x00FF0000) >> 8) | (((x) & 0x0000FF00) << 8) | ((x) << 24))

#define FILENAME_ARTIX_BITSTREAM "artix.bin"
#define FILENAME_ARTIX_BITSTREAM_1_BOARD "top_art1.bit"
#define FILENAME_ARTIX_PARAMETERS "artfw.cfg"


#endif /* SRC_COMMON_H_ */
