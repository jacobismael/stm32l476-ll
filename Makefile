######################################
# target
######################################
TARGET = main

######################################
# build settings
######################################
DEBUG = 1
OPT = -O0

######################################
# paths
######################################
BUILD_DIR = build
SRC_DIR = src

######################################
# source files
######################################
C_SOURCES = $(wildcard $(SRC_DIR)/*.c)

ASM_SOURCES =  \
startup_stm32l476xx.s

######################################
# tools
######################################
PREFIX = arm-none-eabi-

ifdef GCC_PATH
CC = $(GCC_PATH)/$(PREFIX)gcc
AS = $(GCC_PATH)/$(PREFIX)gcc -x assembler-with-cpp
CP = $(GCC_PATH)/$(PREFIX)objcopy
SZ = $(GCC_PATH)/$(PREFIX)size
else
CC = $(PREFIX)gcc
AS = $(PREFIX)gcc -x assembler-with-cpp
CP = $(PREFIX)objcopy
SZ = $(PREFIX)size
endif

HEX = $(CP) -O ihex
BIN = $(CP) -O binary -S

######################################
# MCU
######################################
CPU = -mcpu=cortex-m4
FPU = -mfpu=fpv4-sp-d16
FLOAT_ABI = -mfloat-abi=hard

MCU = $(CPU) -mthumb $(FPU) $(FLOAT_ABI)

######################################
# defines
######################################
C_DEFS =  \
-DSTM32L476xx

AS_DEFS =

######################################
# includes
######################################
C_INCLUDES =  \
-I. \
-ICore/Inc \
-IDrivers/CMSIS/Core/Include \
-IDrivers/CMSIS/Device/ST/STM32L4xx/Include

AS_INCLUDES =  \
-I. \
-IDrivers/CMSIS/Core/Include \
-IDrivers/CMSIS/Device/ST/STM32L4xx/Include

######################################
# compiler flags
######################################
CFLAGS = $(MCU) $(C_DEFS) $(C_INCLUDES) $(OPT) \
-Wall \
-Wextra \
-std=gnu11 \
-fdata-sections \
-ffunction-sections \
-MMD -MP -MF"$(@:%.o=%.d)"

ASFLAGS = $(MCU) $(AS_DEFS) $(AS_INCLUDES) $(OPT) \
-Wall \
-fdata-sections \
-ffunction-sections

ifeq ($(DEBUG), 1)
CFLAGS += -g3 -gdwarf-2
ASFLAGS += -g3 -gdwarf-2
endif

######################################
# linker
######################################
LDSCRIPT = STM32L476XX_FLASH.ld

LIBS = -lc -lm -lnosys

LDFLAGS = $(MCU) \
-specs=nano.specs \
-specs=nosys.specs \
-T$(LDSCRIPT) \
-Wl,-Map=$(BUILD_DIR)/$(TARGET).map,--cref \
-Wl,--gc-sections \
-Wl,--print-memory-usage \
-u _printf_float

######################################
# build rules
######################################
all: $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).hex $(BUILD_DIR)/$(TARGET).bin

OBJECTS = $(addprefix $(BUILD_DIR)/,$(notdir $(C_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(C_SOURCES)))

OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(ASM_SOURCES:.s=.o)))
vpath %.s $(sort $(dir $(ASM_SOURCES)))

$(BUILD_DIR)/%.o: %.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/$(notdir $(<:.c=.lst)) $< -o $@

$(BUILD_DIR)/%.o: %.s Makefile | $(BUILD_DIR)
	$(AS) -c $(ASFLAGS) $< -o $@

$(BUILD_DIR)/$(TARGET).elf: $(OBJECTS) Makefile
	$(CC) $(OBJECTS) $(LDFLAGS) $(LIBS) -o $@
	$(SZ) $@

$(BUILD_DIR)/%.hex: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(HEX) $< $@

$(BUILD_DIR)/%.bin: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(BIN) $< $@

$(BUILD_DIR):
	mkdir -p $@

######################################
# flash with OpenOCD
######################################
flash: all
	openocd -f board/st_nucleo_l4.cfg -c "program $(BUILD_DIR)/$(TARGET).elf verify reset exit"

######################################
# clean
######################################
clean:
	-rm -fR $(BUILD_DIR)

######################################
# dependencies
######################################
-include $(wildcard $(BUILD_DIR)/*.d)

.PHONY: all clean flash