AVR&ATMEGA328P
--------------

 - [AVR selector](http://www.atmel.com/v2pfresults.aspx#(actives:!(),data:(area:'',category:'34864',pm:!(),view:list),sc:1))
 - [Write bootloader for AVR](http://www.engineersgarage.com/embedded/avr-microcontroller-projects/How-To-Write-a-Simple-Bootloader-For-AVR-In-C-language)
 - [Atmel AVR Dragon (ATAVRDRAGON)](http://store.atmel.com/PartDetail.aspx?q=p:10500053#tc:description) and how [use](http://www.larsen-b.com/Article/315.html) it on linux
 - Getting [started](http://www.evilmadscientist.com/2007/resources-for-getting-started-with-avrs/) with AVR.
 - Simple [AVR guide](https://sites.google.com/site/qeewiki/books/avr-guide)
 - Some indications on [AVR programming](http://hlt.media.mit.edu/wiki/pmwiki.php?n=Main.AVRProgrammingAdvanced)
 - ATMega328 [datasheet](http://www.atmel.com/Images/doc8161.pdf)
 - http://forums.trossenrobotics.com/tutorials/introduction-129/avr-basics-3261/
 - http://www.nongnu.org/avr-libc/
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


You can also program the core of Arduino directly by using the BusPirate

```
$ avrdude  -c buspirate 2>&1 | grep 328
m328p = ATMEGA328P      [/etc/avrdude.conf:8547]
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

ATTINY85
--------

 - [Datasheet](http://www.atmel.com/Images/doc2586.pdf)

|BusPirate    |ATtiny85  |
|-------------|----------|
|CS (white)   |RESET (1) |
|GND (brown)  |GND (4)   |
|MOSI (grey)  |MOSI (5)  |
|MISO (black) |MISO (6)  |
|CLK (purple) |SCK (7)   |
|+5V (orange) |Vcc (8)   |

ARDUINO
-------

 - [http://hlt.media.mit.edu/?p=1695](Programming an ATtiny w/ Arduino 1.0.1)