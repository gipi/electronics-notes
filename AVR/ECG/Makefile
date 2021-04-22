BIN=ecg
OBJS=src/ecg.o src/m_usb.o

MCU=atmega32u4

CC=avr-gcc
OBJCOPY=avr-objcopy
CFLAGS=-Os -DF_CPU=16000000UL -mmcu=$(MCU)
LDFLAGS= -Wl,-Map,$(BIN).map
PROGRAMMER=avr109
PORT=/dev/ttyACM0

${BIN}.hex: ${BIN}.elf
	${OBJCOPY} -O ihex -j .text -j .data $< $@

${BIN}.elf: ${OBJS}
	${CC} $(CFLAGS) $(LDFLAGS) -o $@ $^

upload: ${BIN}.hex
	avrdude -F -V -c $(PROGRAMMER) -p $(MCU) -P ${PORT} -b 115200 -U flash:w:$<

clean:
	rm -f ${BIN}.elf ${BIN}.hex ${OBJS}

