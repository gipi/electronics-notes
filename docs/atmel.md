
**AVR** is a modified Harvard 8-bit RISC single chip microcontroller.

The advice is to read the datasheets that contain a lot of info and working examples, for example
the [ATMEGA32U4](https://www.pjrc.com/teensy/atmega32u4.pdf) one.

## Memory

This kind of microcontrollers have three types of (linear) memory

 - flash: contains the code
 - SRAM: contains the running data (registers, I/O, RAM)
 - EEPROM: contains the static data (not present in all the chips)

## Clocks

Each subsystem of an AVR chip has its own clock that is possible to deactivate in order to reduce power consumption.

## Fuses

## Sleep modes

## Interrupts

## I/O

Three I/O memory address locations are allocated for each port

* the Data Register – PORTx
* Data Direction Register – DDRx
* Port Input Pins – PINx.

The Port Input Pins I/O location is read only, while the Data Register and the Data Direction Register are read/write.

The ports are bi-directional I/O ports with optional internal pull-ups

Each port pin consists of three register bits: DDxn, PORTxn, and PINxn. As shown in “Register Description” on
page 64, the DDxn bits are accessed at the DDRx I/O address, the PORTxn bits at the PORTx I/O address, and
the PINxn bits at the PINx I/O address.
The DDxn bit in the DDRx Register selects the direction of this pin. If DDxn is written logic one, Pxn is configured
as an output pin. If DDxn is written logic zero, Pxn is configured as an input pin.
If PORTxn is written logic one when the pin is configured as an input pin, the pull-up resistor is activated. To switch
the pull-up resistor off, PORTxn has to be written logic zero or the pin has to be configured as an output pin. The
port pins are tri-stated when reset condition becomes active, even if no clocks are running.
If PORTxn is written logic one when the pin is configured as an output pin, the port pin is driven high (one). If
PORTxn is written logic zero when the pin is configured as an output pin, the port pin is driven low (zero).

If some pins are unused, it is recommended to ensure that these pins have a defined level. Even though most of
the digital inputs are disabled in the deep sleep modes as described above, floating inputs should be avoided to
reduce current consumption in all other modes where the digital inputs are enabled (Reset, Active mode and Idle
mode).
The simplest method to ensure a defined level of an unused pin, is to enable the internal pull-up. In this case, the
pull-up will be disabled during reset. If low power consumption during reset is important, it is recommended to use
an external pull-up or pulldown. Connecting unused pins directly to VCC or GND is not recommended, since this
may cause excessive currents if the pin is accidentally configured as an output.

Links
-----

 - [AVR Beginners](http://www.avrbeginners.net/)
 - http://www.build-electronic-circuits.com/microcontroller-tutorial-part1/
 - [AVR selector](http://www.atmel.com/v2pfresults.aspx#(actives:!(),data:(area:'',category:'34864',pm:!(),view:list),sc:1))
 - [Write bootloader for AVR](http://www.engineersgarage.com/embedded/avr-microcontroller-projects/How-To-Write-a-Simple-Bootloader-For-AVR-In-C-language)
 - http://blog.schicks.net/wp-content/uploads/2009/09/bootloader_faq.pdf
 - http://www.fischl.de/avrusbboot/
 - [Atmel AVR Dragon (ATAVRDRAGON)](http://store.atmel.com/PartDetail.aspx?q=p:10500053#tc:description) and how [use](http://www.larsen-b.com/Article/315.html) it on linux
 - [A Quickstart Tutorial for ATMEL AVR Microcontrollers](http://imakeprojects.com/Projects/avr-tutorial/)
 - Getting [started](http://www.evilmadscientist.com/2007/resources-for-getting-started-with-avrs/) with AVR.
 - Simple [AVR guide](https://sites.google.com/site/qeewiki/books/avr-guide)
 - Some indications on [AVR programming](http://hlt.media.mit.edu/wiki/pmwiki.php?n=Main.AVRProgrammingAdvanced)
 - ATMega328 [datasheet](http://www.atmel.com/Images/doc8161.pdf)
 - http://forums.trossenrobotics.com/tutorials/introduction-129/avr-basics-3261/
 - http://www.nongnu.org/avr-libc/
 - [SPI](http://maxembedded.com/2013/11/the-spi-of-the-avr/)
 - AVR [instruction set](http://www.atmel.com/Images/doc0856.pdf)
 - Some indication about [FUSE settings](http://coding.zencoffee.org/2011/08/aeroquad-251-code-upload-via-icsp.html): in particular

    What's notable is that the default fuse setup for an Arduino (here)
    will set the high fuse to 0xD6.  This sets up the Arduino so on boot
    it will boot the bootloader.  In other words, code execution will not
    begin at address 0x0000.  This won't work if you have no bootloader.
    The fuses need to be changed so that the BOOTRST flag is unprogrammed.
    In AVR-speak, this means it's set to a value of 1 (0 means "programmed).
    So, this means that the high fuse needs to be set to 0xD7.  No other
    fuses need to be changed.

 - [Fuse calculator](http://www.frank-zhao.com/fusecalc/fusecalc.php?chip=atmega328p)
 - [RIFF-WAVE format files in LPCM player using attiny85](http://elm-chan.org/works/sd8p/report.html)
 - [Using Arduino as ISP programmer](http://hlt.media.mit.edu/?p=1706) (also from [arduino](http://arduino.cc/en/Tutorial/ArduinoISP) site)
 - AVR [fuse](http://www.ladyada.net/learn/avr/fuses.html) by ladyada
 - Type of [memory](http://www.arduino.cc/playground/Learning/Memory) available.
 - [Example](http://www.scienceprog.com/atmega-eeprom-memory-writing/) of EEPROM code.
 - [PROGMEM](http://www.arduino.cc/en/Reference/PROGMEM), [EEMEM](http://tinkerlog.com/2007/06/16/using-progmem-and-eemem-with-avrs/) variable modifier.
 - [VGa](http://tinyvga.com/avr-vga) with the AVR.
 - I2C with [avr](http://www.embedds.com/programming-avr-i2c-interface/)
 - I2C for [attiny85](http://www.arduino.cc/playground/Code/USIi2c)
 - Simple project for [POV](http://voltsandbytes.com/tinypov-yet-another-avr-pov-project/) with AVR
 - USB to serial communication with [AVR](http://www.evilmadscientist.com/2009/basics-serial-communication-with-avr-microcontrollers/)
 - [USART](https://sites.google.com/site/qeewiki/books/avr-guide/usart)
 - Tutorial from [Sparkfun](http://www.sparkfun.com/tutorials/104) about Serial communication, RS232, etc...
 - http://learn.adafruit.com/memories-of-an-arduino/you-know-you-have-a-memory-problem-when-dot-dot-dot
 - [Getting Extra Pins on ATtiny](http://www.technoblogy.com/show?LSE)
 - http://codeandlife.com/2012/01/22/avr-attiny-usb-tutorial-part-1/
 - [V-USB](http://www.obdev.at/products/vusb/index.html) simple library to implements USB devices with AVR chips
 - [USB PCB Business Card](http://www.instructables.com/id/USB-PCB-Business-Card/?ALLSTEPS)
You can also program the core of Arduino directly by using the BusPirate and the ``avrdude`` program (package with the same name)

```
$ avrdude -c buspirate
avrdude: No AVR part has been specified, use "-p Part"

Valid parts are:
  uc3a0512 = AT32UC3A0512
  c128     = AT90CAN128
  c32      = AT90CAN32
  c64      = AT90CAN64
  pwm2     = AT90PWM2
  pwm2b    = AT90PWM2B
  pwm3     = AT90PWM3
...
  m328     = ATmega328
  m328p    = ATmega328P
...
  x64a4    = ATxmega64A4
  x64a4u   = ATxmega64A4U
  x64b1    = ATxmega64B1
  x64b3    = ATxmega64B3
  x64c3    = ATxmega64C3
  x64d3    = ATxmega64D3
  x64d4    = ATxmega64D4
  x8e5     = ATxmega8E5
  ucr2     = deprecated, use 'uc3a0512'
$ avrdude -c arduino -p m328p -P /dev/ttyACM0 -v -b 19200
```

and after connect the proper I/O pins following the scheme (taken from here)[http://ilikepepper.wordpress.com/2011/09/15/buspirate-arduino/]

| Bus Pirate | ATMEGA28P |
|------------|-----------|
| GND        | 8         |
| VCC        | 7         |
| CS         | 1         |
| MOSI       | 17        |
| MISO       | 18        |
| CLK        | 19        |


    $ avrdude -c buspirate -p m328p -v -P /dev/ttyUSB0
    
    avrdude: Version 5.10, compiled on Jun 27 2010 at 00:21:42
    Copyright (c) 2000-2005 Brian Dean, http://www.bdmicro.com/.com/
    Copyright (c) 2007-2009 Joerg Wunschunsch
    
    System wide configuration file is "/etc/avrdude.conf"conf"
    User configuration file is "/home/gipi/.avrduderc"derc"
    User configuration file does not exist or is not a regular file, skippingpping
    
    Using Port                    : /dev/ttyUSB0yUSB0
    Using Programmer              : buspirateirate
    AVR Part                      : ATMEGA328PA328P
    Chip Erase delay              : 9000 us00 us
    PAGEL                         : PD7: PD7
    BS2                           : PC2: PC2
    RESET disposition             : dedicatedcated
    RETRY pulse                   : SCK: SCK
    serial program mode           : yes: yes
    parallel program mode         : yes: yes
    Timeout                       : 200: 200
    StabDelay                     : 100: 100
    CmdexeDelay                   : 25 : 25
    SyncLoops                     : 32 : 32
    ByteDelay                     : 0  : 0
    PollIndex                     : 3  : 3
    PollValue                     : 0x53 0x53
    Memory Detail                 :    :
    
    Block Poll               Page                       Pollede                       Polled
    Memory Type Mode Delay Size  Indx Paged  Size   Size #Pages MinW  MaxW   ReadBackeadBack
    ----------- ---- ----- ----- ---- ------ ------ ---- ------ ----- ----- ----------------
    eeprom        65     5     4    0 no       1024    4      0  3600  3600 0xff 0xffff 0xff
    flash         65     6   128    0 yes     32768  128    256  4500  4500 0xff 0xffff 0xff
    lfuse          0     0     0    0 no          1    0      0  4500  4500 0x00 0x0000 0x00
    hfuse          0     0     0    0 no          1    0      0  4500  4500 0x00 0x0000 0x00
    efuse          0     0     0    0 no          1    0      0  4500  4500 0x00 0x0000 0x00
    lock           0     0     0    0 no          1    0      0  4500  4500 0x00 0x0000 0x00
    calibration    0     0     0    0 no          1    0      0     0     0 0x00 0x0000 0x00
    signature      0     0     0    0 no          3    0      0     0     0 0x00 0x0000 0x00
    
    Programmer Type : BusPirateirate
    Description     : The Bus Pirateirate
    
    Detecting BusPirate...
    avrdude: buspirate_readline(): #
    avrdude: buspirate_readline(): RESET
    avrdude: buspirate_readline():
    **
    avrdude: buspirate_readline(): Bus Pirate v3a
    **  Bus Pirate v3a
    avrdude: buspirate_readline(): Firmware v5.10 (r559)  Bootloader v4.4
    **  Firmware v5.10 (r559)  Bootloader v4.4
    avrdude: buspirate_readline(): DEVID:0x0447 REVID:0x3046 (24FJ64GA002 B8)
    **  DEVID:0x0447 REVID:0x3046 (24FJ64GA002 B8)
    avrdude: buspirate_readline(): http://dangerousprototypes.com
    **  http://dangerousprototypes.com
    avrdude: buspirate_readline(): HiZ>
    **
    BusPirate: using BINARY mode
    BusPirate binmode version: 1
    BusPirate SPI version: 1
    avrdude: AVR device initialized and ready to accept instructions0.02s
    
    Reading | ################################################## | 100% 0.02s
    
    avrdude: Device signature = 0x1e950f
    avrdude: safemode: lfuse reads as 62
    avrdude: safemode: hfuse reads as D9
    avrdude: safemode: efuse reads as 7
    
    avrdude: safemode: lfuse reads as 62
    avrdude: safemode: hfuse reads as D9
    avrdude: safemode: efuse reads as 7
    avrdude: safemode: Fuses OK
    BusPirate is back in the text mode
    
    avrdude done.  Thank you.

otherwise is possible to use a [FTDI cable](http://doswa.com/2010/08/24/avrdude-5-10-with-ftdi-bitbang.html) to program it con avrdude.
ATTINY85
--------

 - [Datasheet](http://www.atmel.com/Images/Atmel-2586-AVR-8-bit-Microcontroller-ATtiny25-ATtiny45-ATtiny85_Datasheet.pdf)

|BusPirate    |ATtiny85  |
|-------------|----------|
|CS (white)   |RESET (1) |
|GND (brown)  |GND (4)   |
|MOSI (grey)  |MOSI (5)  |
|MISO (black) |MISO (6)  |
|CLK (purple) |SCK (7)   |
|+5V (orange) |Vcc (8)   |

PINOUTS
-------

![Arduino to ATMega328 pinout](http://arduino.cc/en/uploads/Hacking/Atmega168PinMap2.png)
![PINOUT](http://circuits.datasheetdir.com/18/ATTINY25-pinout.jpg)
![PIN SCHEME](http://dangerousprototypes.com/docs/images/1/1b/Bp-pin-cable-color.png)

![Basic ATMega328 wiring](http://www.gammon.com.au/images/Arduino/Minimal_Arduino1.jpg)

![ATMega328 with FTDI](https://perhof.files.wordpress.com/2011/11/arduino_breadboard_ftdi_basic.jpg)

ARDUINO
-------

 - [http://hlt.media.mit.edu/?p=1695](Programming an ATtiny w/ Arduino 1.0.1)
