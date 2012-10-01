SOLDERING
---------

 - http://wiki.openwrt.org/doc/hardware/soldering
 - http://tronixstuff.wordpress.com/2012/09/05/adventures-with-smt-and-a-pov-smt-kit/

555
---

 - http://www.sparkfun.com/products/9273
 - http://tronixstuff.wordpress.com/2011/01/27/the-555-precision-timer-ic/
 - http://lateblt.tripod.com/proj2.htm
 - http://www.robotroom.com/Infrared555.html

SHIFT REGISTER
--------------

 - http://arduino.cc/en/Tutorial/ShiftOut
 - http://bildr.org/2011/02/74hc595/
 - http://www.makeuseof.com/tag/arduino-programming-playing-shift-registers-aka-leds/

CMOY
----

 - http://tangentsoft.net/audio/cmoy-tutorial/

LCD
---

 - http://jormungand.net/projects/devices/avrlcd/

ATMEGA328P
----------

You can also program the core of Arduino directly by using the BusPirate

    $ avrdude  -c buspirate 2>&1 | grep 328
    m328p = ATMEGA328P      [/etc/avrdude.conf:8547]

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

ARDUINO
-------

 - [http://hlt.media.mit.edu/?p=1695](Programming an ATtiny w/ Arduino 1.0.1)

VARIOUS
-------
 - http://provideyourown.com/2011/analogwrite-convert-pwm-to-voltage/
 - http://www.ifixit.com
 - http://bildr.org/2012/03/rfp30n06le-arduino/


BUS PIRATE
----------

 - [AVR programming](http://dangerousprototypes.com/docs/Bus_Pirate_AVR_Programming)

 - http://dangerousprototypes.com/docs/Bus_Pirate_I/O_Pin_Descriptions
 

 ![PIN SCHEME](http://dangerousprototypes.com/docs/File:Bp-pin-cable-color.png)

STORE
-----

 - http://www.radioshack.com
 - http://www.digikey.com
 - http://www.sparkfun.com
 - http://littlebirdelectronics.com
 - http://www.seeedstudio.com
 - http://shop.moderndevice.com/