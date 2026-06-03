#include "error.h"

static void default_fault_handler(const char *message) { (void)message; }

static void default_panic_handler(const char *message) {
  (void)message;
  while (1);
}

static fault_handler_t fault_handler = default_fault_handler;
static fault_handler_t panic_handler = default_panic_handler;

void set_fault_handler(fault_handler_t handler) {
  if (!handler) {
    fault_handler = default_fault_handler;
    return;
  }
  fault_handler = handler;
}

void set_panic_handler(fault_handler_t handler) {
  if (!handler) {
    panic_handler = default_panic_handler;
    return;
  }
  panic_handler = handler;
}

void fault(const char *message) { fault_handler(message); }
void panic(const char *message) { panic_handler(message); }