# Toolchain
CC = arm-none-eabi-gcc
AS = arm-none-eabi-as
LD = arm-none-eabi-ld
OBJCOPY = arm-none-eabi-objcopy
OBJDUMP = arm-none-eabi-objdump
SIZE = arm-none-eabi-size

# File names
TARGET = program
STARTUP_FILE = startup.c
LINKER_SCRIPT = linker.ld
MAIN_FILE = main.s

# Build rules
all: $(TARGET).elf

$(TARGET).elf: $(MAIN_FILE) $(STARTUP_FILE) $(LINKER_SCRIPT)
	$(CC) -mcpu=cortex-m4 -mthumb -nostdlib -T$(LINKER_SCRIPT) -o $(TARGET).elf $(MAIN_FILE) $(STARTUP_FILE) -lgcc

# Convert ELF to BIN (optional)
$(TARGET).bin: $(TARGET).elf
	$(OBJCOPY) -O binary $(TARGET).elf $(TARGET).bin

# Convert ELF to HEX (optional)
$(TARGET).hex: $(TARGET).elf
	$(OBJCOPY) -O ihex $(TARGET).elf $(TARGET).hex

# Display size information
size: $(TARGET).elf
	$(SIZE) $(TARGET).elf

# Clean up
clean:
	rm -f $(TARGET).elf $(TARGET).bin $(TARGET).hex

.PHONY: all clean size
