EXAMPLE ?= blinky
TARGET  := $(EXAMPLE)

BUILD_DIR     := build/$(EXAMPLE)
SRC_DIR       := src
INC_DIR       := include
EXAMPLE_DIR   := examples
STM32L476_DIR := stm32l476

EXAMPLE_SRC := $(EXAMPLE_DIR)/$(EXAMPLE).c

PREFIX ?= arm-none-eabi-

CC      := $(PREFIX)gcc
AS      := $(PREFIX)gcc -x assembler-with-cpp
OBJCOPY := $(PREFIX)objcopy
SIZE    := $(PREFIX)size
OBJDUMP := $(PREFIX)objdump

OPENOCD ?= openocd

MCU := \
	-mcpu=cortex-m4 \
	-mthumb \
	-mfpu=fpv4-sp-d16 \
	-mfloat-abi=hard

C_SOURCES := \
	$(wildcard $(SRC_DIR)/*.c) \
	$(EXAMPLE_SRC)

ASM_SOURCES := \
	$(STM32L476_DIR)/startup_stm32l476xx.s

ifeq ($(wildcard $(EXAMPLE_SRC)),)
$(error Example '$(EXAMPLE)' does not exist. Expected $(EXAMPLE_SRC))
endif

CPPFLAGS := \
	-DSTM32L476xx \
	-I$(INC_DIR) \
	-I$(STM32L476_DIR) \
	-IDrivers/CMSIS/Core/Include \
	-IDrivers/CMSIS/Device/ST/STM32L4xx/Include

CFLAGS := \
	$(MCU) \
	-O0 \
	-g3 \
	-Wall \
	-Wextra \
	-Wpedantic \
	-std=gnu11 \
	-ffunction-sections \
	-fdata-sections \
	-fno-common \
	-MMD \
	-MP

ASFLAGS := \
	$(MCU) \
	-g3

LDSCRIPT := $(STM32L476_DIR)/STM32L476XX_FLASH.ld

LDFLAGS := \
	$(MCU) \
	-T$(LDSCRIPT) \
	-specs=nano.specs \
	-specs=nosys.specs \
	-Wl,-Map=$(BUILD_DIR)/$(TARGET).map \
	-Wl,--gc-sections

LDLIBS := \
	-Wl,--start-group \
	-lc \
	-lm \
	-lnosys \
	-Wl,--end-group

ELF := $(BUILD_DIR)/$(TARGET).elf
HEX := $(BUILD_DIR)/$(TARGET).hex
BIN := $(BUILD_DIR)/$(TARGET).bin
LST := $(BUILD_DIR)/$(TARGET).lst

OBJECTS := \
	$(patsubst %.c,$(BUILD_DIR)/%.o,$(C_SOURCES)) \
	$(patsubst %.s,$(BUILD_DIR)/%.o,$(ASM_SOURCES))

DEPS := $(OBJECTS:.o=.d)

all: $(ELF) $(HEX) $(BIN)

$(BUILD_DIR)/%.o: %.c Makefile
	@mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/%.o: %.s Makefile
	@mkdir -p $(dir $@)
	$(AS) $(CPPFLAGS) $(ASFLAGS) -c $< -o $@

$(ELF): $(OBJECTS) $(LDSCRIPT)
	@mkdir -p $(dir $@)
	$(CC) $(OBJECTS) $(LDFLAGS) $(LDLIBS) -o $@
	$(SIZE) $@

$(HEX): $(ELF)
	$(OBJCOPY) -O ihex $< $@

$(BIN): $(ELF)
	$(OBJCOPY) -O binary -S $< $@

$(LST): $(ELF)
	$(OBJDUMP) -h -S $< > $@

flash: all
	$(OPENOCD) -f board/st_nucleo_l4.cfg \
		-c "program $(ELF) verify reset exit"

run: flash

list: $(LST)

size: $(ELF)
	$(SIZE) $(ELF)

clean:
	rm -rf build

-include $(DEPS)

.PHONY: all flash run list size clean