# STM32l476 Nucleo LL Driver

Macro functions for the STM32L476 Peripherals. This repository contains custom bare-metal register-level drivers for the STM32L476. It does not use the STM32Cube HAL or the official STM32Cube LL API.

## Features
- ADC
- UART
- Delay
- I2C
- SPI

## Template
The following is a sample LED blinky program.
```c
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
```

## Build
Compile with Make. Flash using:
```
make flash
```

This will use the STLink (On-board for the Nucleo Dev board)
