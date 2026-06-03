#ifndef ERROR_H
#define ERROR_H

typedef void (*fault_handler_t)(const char *message);
typedef void (*panic_handler_t)(const char *message);

void set_fault_handler(fault_handler_t handler);
void fault(const char *message);

void set_panic_handler(panic_handler_t handler);
_Noreturn void panic(const char *message);

#endif /* ERROR_H */
