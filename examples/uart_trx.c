#include "LED.h"
#include "SysClock.h"
#include "UART.h"
#include "stm32l476xx.h"
#include <stdio.h>
#include <string.h>

int main(void) {
  System_Clock_Init();
  LED_Init();
  
  UART_Init(2, 9600);
  UART2_GPIO_Init();
  USART_Init(USART2);

  char rxByte;
  printf("\r\nUART Part A ready.\r\n");
  while (1) {
    printf("Enter command: Y/y = LED on, N/n = LED off\r\n");
    scanf(" %c", &rxByte);
    if (rxByte == 'Y' || rxByte == 'y') {
      LED_On();
      printf("Green LED turned ON\r\n");
    } else if (rxByte == 'N' || rxByte == 'n') {
      LED_Off();
      printf("Green LED turned OFF\r\n");
    } else if (rxByte == 'Q' || rxByte == 'q') {
      printf("Quit.\r\n");
      break;
    } else {
      printf("Invalid command. Please enter Y/y or N/n.\r\n");
    }
  }
}
