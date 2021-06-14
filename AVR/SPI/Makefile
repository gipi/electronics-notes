
NAME := spi
HEX := $(NAME).hex
OUT := $(NAME).out
MAP := $(NAME).map
SOURCES := $(wildcard *.c)
HEADERS := $(wildcard *.h)
OBJECTS := $(patsubst %.c,%.o,$(SOURCES))

HEADERS_EXTRA :=  ../sd-reader_source_20120612/
OBJECTS_EXTRA := ../sd-reader_source_20120612/uart.o

MCU := atmega32u4
MCU_AVRDUDE := m32u4
PROGRAMMER := avr109
PORT := /dev/ttyACM0
MCU_FREQ := 16000000UL

CC := avr-gcc
OBJCOPY := avr-objcopy
SIZE := avr-size -A

CFLAGS := -Wall -pedantic -mmcu=$(MCU) -std=c99 -g -Os -DF_CPU=$(MCU_FREQ)

all: $(HEX)

clean:
	rm -f $(HEX) $(OUT) $(MAP) $(OBJECTS)

flash: $(HEX)
	avrdude -y -c $(PROGRAMMER) -p $(MCU_AVRDUDE) -P $(PORT) -U flash:w:$(HEX)

$(HEX): $(OUT)
	$(OBJCOPY) -R .eeprom -O ihex $< $@

$(OUT): $(OBJECTS) $(OBJECTS_EXTRA)
	$(CC) $(CFLAGS) -o $@ -Wl,-Map,$(MAP) $^
	@echo
	@$(SIZE) $@
	@echo

%.o: %.c $(HEADERS)
	$(CC) $(CFLAGS) -I $(HEADERS_EXTRA) -c -o $@ $<

%.pp: %.c
	$(CC) $(CFLAGS) -E -o $@ $<

%.ppo: %.c
	$(CC) $(CFLAGS) -E $<

.PHONY: all clean flash

