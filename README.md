# STM32l476 Nucleo LL Driver

Macro functions for the STM32L476 Peripherals. This repository contains custom bare-metal register-level drivers for the STM32L476. It does not use the STM32Cube HAL or the official STM32Cube LL API.

## Features
- ADC
- UART
- Delay
- I2C
- SPI

## Pin Map
| Module | Peripheral | Pins | Notes |
| --- | --- | --- | --- |
| LED | GPIOA | PA5 | Onboard user LED |
| ADC | ADC1 channel 6 | PA1 | Analog input |
| UART1 | USART1 | PB6 TX, PB7 RX | Conflicts with I2C1 |
| UART2 | USART2 | PA2 TX, PA3 RX | Connected to ST-LINK virtual COM port by default |
| I2C | I2C1 | PB6 SCL, PB7 SDA | Conflicts with UART1 |
| SPI | SPI1 | PA4 NSS, PB3 SCK, PB4 MISO, PB5 MOSI | PB3 may conflict with SWO |
| SysTick | Cortex-M SysTick | — | Blocking millisecond delay |

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
