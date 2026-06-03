#include "LED.h"

void LED_Init(void) {
  // Enable GPIO Clocks
  RCC->AHB2ENR |= RCC_AHB2ENR_GPIOAEN;

  // Initialize Green LED
  GPIOA->MODER &= ~GPIO_MODER_MODE5_1;
  GPIOA->MODER |= GPIO_MODER_MODE5_0;

  GPIOA->PUPDR &= ~GPIO_PUPDR_PUPD5;
  GPIOA->ODR &= ~GPIO_ODR_OD5;
}

void LED_On(void) { GPIOA->ODR |= GPIO_ODR_OD5; }

void LED_Off(void) { GPIOA->ODR &= ~GPIO_ODR_OD5; }

void LED_Toggle(void) { GPIOA->ODR ^= GPIO_ODR_OD5; }
