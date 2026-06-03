# STM32l476 Nucleo LL Driver

Macro functions for the STM32L476 Peripherals. This repository contains custom bare-metal register-level drivers for the STM32L476. It does not use the STM32Cube HAL or the official STM32Cube LL API. Peripheral registers are configured directly using CMSIS device definitions.

The project is tested on the NUCLEO-L476RG development board.

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

## Configurable Fault Handler

Drivers report errors through a common `fault()` function.The application can define where fault messages are sent by registering a callback:
```c
void set_fault_handler(fault_handler_t handler);
void fault(const char *message);
```
The callback can be configured to send messages to UART, store them in memory, display them on a screen, or halt execution.

### Panic
A panic macro is also configurable similar to fault. Unlike fault, panic cannot return.
```c
void set_panic_handler(panic_handler_t handler);
_Noreturn void panic(const char *message);
```

## Prerequisites

Install the following tools:

- GNU Arm Embedded Toolchain
- OpenOCD

The Makefile expects the Arm compiler binaries to use the arm-none-eabi- prefix.

## Build
Compile with Make. Flash using:
```bash
make flash
```

This will use the STLink (On-board for the Nucleo Dev board)

Build a specific example by setting EXAMPLE to the file name without the .c extension:
```bash
make EXAMPLE=uart_trx
make EXAMPLE=adc_poll
```