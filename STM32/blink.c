/*
 * We want to act on the PC13 (blue pill) or PB12 (black pill) GPIO pin
 *
 * There are two steps
 * 
 *  1. activate the clock for the GPIO bank you need
 *  2. set output mode with push pull CNFx = b00
 *  3. set mode different than 00, e.g. MODEx = b01
 *
 */

#include <stdint.h>

// register address
#define RCC_BASE      0x40021000
#define GPIOB_BASE    0x40010C00
#define GPIOC_BASE    0x40011000

#define RCC_APB2ENR   *(volatile uint32_t *)(RCC_BASE   + 0x18)

#define GPIO_CRL(gpio) *(volatile uint32_t *)(gpio##_BASE + 0x00)
#define GPIO_CRH(gpio) *(volatile uint32_t *)(gpio##_BASE + 0x04)
#define GPIO_ODR(gpio) *(volatile uint32_t *)(gpio##_BASE + 0x0C)

// bit fields
#define RCC_IOPCEN   (1UL << 4)
#define RCC_IOPBEN   (1UL << 3)

#define GPIOC13      (1UL << 13)
#define GPIOB12      (1UL << 12)


#define DELAY 500000 /* TODO: pass F_CPU like in ATMEL and calculate the right number */


int main(void) {
    // GPIO PortC clock enable
    RCC_APB2ENR |= RCC_IOPBEN;

    // output mode push-pull with mode=01
    GPIO_CRH(GPIOB) |= (1UL << 16);

    while(1) {
        GPIO_ODR(GPIOB) |=  GPIOB12;
        for (int i = 0; i < DELAY; i++)
            __asm__("nop"); // arbitrary delay
        GPIO_ODR(GPIOB) &= ~GPIOB12;
        for (int i = 0; i < DELAY; i++)
            __asm__("nop"); // arbitrary delay
    }
}
