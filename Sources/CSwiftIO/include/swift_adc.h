/*
 * @Copyright (c) 2020, MADMACHINE LIMITED
 * @Author: Andy Liu,Frank Li
 * @SPDX-License-Identifier: MIT
 */


#ifndef _SWIFT_ADC_H_
#define _SWIFT_ADC_H_

/**
 * @brief Structure to receive adc information
 *
 * @param max_raw_value max raw value for adc value
 * @param ref_voltage adc refer volage
 */
struct swift_adc_info {
	int max_raw_value;
	float ref_voltage;
};

typedef struct swift_adc_info swift_adc_info_t;

/**
 * @brief Open adc
 *
 * @param id ADC id
 * @return ADC handle, NULL is fail
 */
void *swifthal_adc_open(int id);

/**
 * @brief Close adc
 *
 * @param adc ADC handle
 *
 * @retval 0 If successful.
 * @retval Negative errno code if failure.
 */
int swifthal_adc_close(void *adc);

/**
 * @brief Read adc value
 *
 * @param adc ADC handle
 * @param sampla_buffer Pointer to storage for read data
 *
 * @retval Positive indicates the adc value.
 * @retval Negative errno code if failure.
 */
int swifthal_adc_read(void *adc, unsigned short *sample_buffer);

/**
 * @brief Get adc infomation
 *
 * @param adc ADC handle
 * @param info adc information, use @ref swift_adc_info
 *
 * @retval 0 If successful.
 * @retval Negative errno code if failure.
 */
int swifthal_adc_info_get(void *adc, swift_adc_info_t *info);

/**
 * @brief Get ADC support device number
 *
 * The maximum number of devices, the id of swifthal_adc_open must be less than this value
 *
 * @return max device number
 */
int swifthal_adc_dev_number_get(void);

#endif /*_SWIFT_ADC_H_*/
