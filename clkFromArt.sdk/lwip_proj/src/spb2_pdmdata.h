/*
 * spb2_pdmdata.h
 *
 *  Created on: Jul 16, 2020
 *      Author: alx
 */

#ifndef SRC_SPB2_PDMDATA_H_
#define SRC_SPB2_PDMDATA_H_

#define N_OF_PIXELS_PER_PMT_Z3			(64+8) /* number of pixel on PMT */
#define N_OF_PMT_PER_ECASIC_Z3	 		6	/* number of PMT on EC ASIC board */
#define N_OF_ECASIC_PER_PDM_Z3			6  /* number of EC ASIC boards in PDM */

#define N_OF_PIXEL_PER_PDM_Z3			(N_OF_PIXELS_PER_PMT_Z3 * N_OF_PMT_PER_ECASIC_Z3 * N_OF_ECASIC_PER_PDM_Z3)


#endif /* SRC_SPB2_PDMDATA_H_ */
