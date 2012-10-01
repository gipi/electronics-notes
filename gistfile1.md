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

and after connect the proper I/O pins following the scheme

| Bus Pirate | ATMEGA28P |
|------------|-----------|
| GND        | 8         |
| VCC        | 7         |
| CS         | 1         |
| MOSI       | 17        |
| MISO       | 18        |
| CLK        | 19        |


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