#include "I2C.h"
#include "LED.h"
#include "SPI.h"
#include "SysClock.h"
#include "SysTimer.h"
#include "UART.h"
#include "stm32l476xx.h"
#include <stdio.h>


int main(void) {
  // Switch System Clock = 80 MHz
  System_Clock_Init();
  SysTick_Init();
  LED_Init();

  while (1) {
    // Sample Blinky
    LED_Toggle();
    delay(1000);
  }
}
