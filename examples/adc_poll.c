#include "ADC.h"
#include "LED.h"
#include "SysClock.h"
#include "UART.h"
#include "stm32l476xx.h"
#include <stdio.h>
#include <string.h>

int main(void) {
  // Enable FPU
  SCB->CPACR |= (0xF << 20);
  __DSB();
  __ISB();

  System_Clock_Init();
  UART_Init(2, 9600);
  UART2_GPIO_Init();
  USART_Init(USART2);

  ADC_Init();
  LED_Init();

  while (1) {
    ADC1->CR |= ADC_CR_ADSTART;
    while (!(ADC1->ISR & ADC_ISR_EOC));
    uint16_t measurement = ADC1->DR;
    volatile float voltage = 3.3f * measurement / 4096;
    printf("Value: %0.2f, Thresh: %0.2f\r\n", voltage, 2.0f);
  }
}
