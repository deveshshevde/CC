CC = /opt/homebrew/bin/arm-none-eabi-gcc
MACH = cortex-m4

# Compiler flags
CFLAGS= -c -mcpu=$(MACH) -mthumb -mfloat-abi=soft -std=gnu11 -Wall -O0
LDFLAGS= -mcpu=$(MACH) -mthumb -mfloat-abi=soft --specs=nano.specs -T linker.ld -Wl,-Map=final.map
LDFLAGS_SH= -mcpu=$(MACH) -mthumb -mfloat-abi=soft --specs=rdimon.specs -T linker.ld -Wl,-Map=final.map

# Targets
all: final.elf

semi: final_sh.elf

# Assembly file compilation
main.o: main.s
	$(CC) $(CFLAGS) -o $@ $^

startup.o: startup.s
	$(CC) $(CFLAGS) -o $@ $^

# Linking final binary
final.elf: main.o startup.o 
	$(CC) $(LDFLAGS) -o $@ $^

# Linking semihosting binary
final_sh.elf: main.o startup.o 
	$(CC) $(LDFLAGS_SH) -o $@ $^

# Clean generated files
clean:
	rm -rf *.o *.elf final.map

# Load target to flash the binary
load: final.elf
	/opt/local/bin/st-flash write final.elf 0x8000000
