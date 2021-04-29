PROJECT = blink

SOURCES = blink.c
OBJECTS = $(SOURCES:.c=.o) crt.o

CC       := arm-none-eabi-gcc
OBJCOPY  := arm-none-eabi-objcopy
STFLASH  := st-flash
CPFLAGS  := -Wall -Wextra -mcpu=cortex-m3 -mthumb -std=gnu11 -Wall -g3 -O0
LDFLAGS  := -T stm32_ls.ld -nostdlib -Wl,-Map=$(PROJECT).map

all: $(PROJECT).elf


%.o: %.c
	$(CC) $(CPFLAGS) -c $^

$(PROJECT).elf: $(OBJECTS)
	$(CC) $(CPFLAGS) $(LDFLAGS) $^ -o $@

$(PROJECT).bin: $(PROJECT).elf
	$(OBJCOPY) -O binary $^ $@

flash: $(PROJECT).bin
	$(STFLASH) --reset write $^ 0x8000000

clean: $(OBJECTS) $(PROJECT).bin $(PROJECT).elf
	rm $^
