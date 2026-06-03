#include "UART.h"
#include <stdio.h>

struct _FILE {
  int dummy;
};

FILE __stdout;
FILE __stdin;

// Retarget printf() to USART1/USART2
int fputc(int ch, FILE *f) {
  uint8_t c;
  c = ch & 0x00FF;
  // USART_Write(USART1, (uint8_t *)&c, 1);
  USART_Write(USART2, (uint8_t *)&c, 1);
  return (ch);
}

// Retarget scanf() to USART1/USART2
int fgetc(FILE *f) {
  uint8_t rxByte;
  // rxByte = USART_Read(USART1);
  rxByte = USART_Read(USART2);
  return rxByte;
}

// GCC/newlib retarget for printf()
int _write(int file, char *ptr, int len) {
  (void)file;

  for (int i = 0; i < len; i++) {
    uint8_t c = (uint8_t)ptr[i];
    USART_Write(USART2, &c, 1);
  }

  return len;
}

// GCC/newlib retarget for scanf()/getchar()
int _read(int file, char *ptr, int len) {
  (void)file;
  (void)len;

  *ptr = (char)USART_Read(USART2);

  return 1;
}