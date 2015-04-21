[ATMEL](#file-atmel-md) | [PCB](#file-pcb-md) | [Sensors](#file-sensors-md)

http://www.slideshare.net/balgan/hardware-hacking-101
 - Site with pinout, tools etc: http://www.pighixxx.com/

BASIC
-----

 - [Capacitor decoupling](http://www.vagrearg.org/content/decoupling): The act of (partially) separating the logic chip's power supply from the main power supply. In this [video](https://www.youtube.com/watch?v=jz1IHapsrdk) more explanation
 - https://circuithub.com/
 - http://blog.thelifeofkenneth.com/2013/02/diy-usb-power-strip.html
 - http://www.ladyada.net/make/mintyboost/process.html
 - http://123d.circuits.io/
 - [How do I read a datasheet?](http://www.youtube.com/watch?v=DZIFlV6wAZA)
 - [H Bridge Motor Speed Controller Tutorial](https://www.youtube.com/watch?v=iYafyPZ15g8)
 - Led [1](http://www.resistorguide.com/resistor-for-led/) [2](https://learn.sparkfun.com/tutorials/light-emitting-diodes-leds)

## Voltage regulators

 - http://www.slideshare.net/niiraz/voltage-regulator-29002693
 - http://datasheet.octopart.com/L7805CV-STMicroelectronics-datasheet-7264666.pdf

## Resistors

 - [Resistor Sizes and Packages](http://www.resistorguide.com/resistor-sizes-and-packages/)
 - http://www.resistorguide.com/pull-up-resistor_pull-down-resistor/
 - How to solder SMT 0805 resistors capacitors: [video](https://www.youtube.com/watch?v=PU7wLcuqc-I)

## UART and Serial

 - http://wiki.openwrt.org/doc/hardware/port.serial
 - http://www.devttys0.com/2012/11/reverse-engineering-serial-ports/

JTAG
----

 - https://hackingbtbusinesshub.wordpress.com/2012/01/26/discovering-jtag-pinouts/
 - http://sun.hasenbraten.de/~frank/docs/mpc824x_JTAG.html
 - Header per SOC da [farnell](http://uk.farnell.com/fci/20021121-00010c4lf/connector-header-smt-r-a-1-27mm/dp/1865279?ost=609-3695-1-ND)
 - [Slide](http://elinux.org/images/d/d6/Jtag.pdf) of a talk about finding JTAG's pinout
 - https://github.com/cyphunk/JTAGenum/
 - http://www.sodnpoo.com/posts.xml/pace4000_jtag.xml
 - https://www.youtube.com/watch?v=TlWlLeC5BUs
 - http://electronics.stackexchange.com/questions/53311/why-jtag-connectors-are-available-in-10pins-14pins-20pins-when-jtag-is-of-5pins

HACK
----

 - https://sites.google.com/site/seagatefix/

SOLDERING
---------
 - [Basic instruments](https://www.youtube.com/watch?v=Kv7Y8nAOoFE)
 - http://wiki.openwrt.org/doc/hardware/soldering
 - http://tronixstuff.wordpress.com/2012/09/05/adventures-with-smt-and-a-pov-smt-kit/
 - [Video](http://www.youtube.com/watch?feature=player_embedded&v=kROaQZOYNIw) about solder proto board.
 - [Cleaning](http://www.instructables.com/id/Proper-Soldering-Iron-cleaning-%26-maintenance/?ALLSTEPS)
 - [Adafruit](http://learn.adafruit.com/adafruit-guide-excellent-soldering/) guide to soldering
 - https://learn.sparkfun.com/tutorials/how-to-solder---through-hole-soldering/advanced-techniques-and-troubleshooting con [video](https://www.youtube.com/watch?v=t9LOtOBOTb0)
 - [SMD](http://www.enetsystems.com/~lorenzo/smd/)


555
---
It's one of the most common IC available.

![555 internals](http://www.electronics-tutorials.ws/waveforms/tim37.gif)

| PIN	| DESCRIPTION	| PURPOSE
|-----|-------------|---------
| 1	| Ground	| DC Ground
|2	 | Trigger	| The trigger pin triggers the beginning of the timing sequence. When it goes LOW, it causes the output pin to go HIGH. The trigger is activated when the voltage falls below 1/3 of +V on pin 8.
| 3	| Output	| The output pin is used to drive external circuitry. It has a "totem pole" configuration, which means that it can source or sink current. The HIGH output is usually about 1.7 volts lower than +V when sourcing current. The output pin can sink up to 200mA of current. The output pin is driven HIGH when the trigger pin is taken LOW. The output pin is driven LOW when the threshold pin is taken HIGH, or the reset pin is taken LOW.
| 4	| Reset	| The reset pin is used to drive the output LOW, regardless of the state of the circuit. When not used, the reset pin should be tied to +V.
| 5	| Control Voltage	| The threshold and trigger levels are controlled using this pin. The pulse width of the output waveform  is determined by connecting a POT or bringing in an external voltage to this pin.  The external voltage applied to this pin can also be used to modulate the output waveform. Thus, the amount of voltage applied in this terminal will decide when the comparator is to be switched, and thus changes the pulse width of the output. When this pin is not used, it should be bypassed to ground through a 0.01 micro Farad to avoid any noise problem.
| 6	| Threshold	| The threshold pin causes the output to be driven LOW when its voltage rises above 2/3 of +V.
| 7	| Discharge	| The discharge pin shorts to ground when the output pin goes HIGH. This is normally used to discharge the timing capacitor during oscillation.
| 8	| +V	| DC Power - Apply +3 to +18VDC here.

### Monostable

![monostable](Images/555-monostable.png)

### Astable

![astable](Images/555-astable.png)

 - http://www.electronics-tutorials.ws/waveforms/555_timer.html
 - http://www.sparkfun.com/products/9273
 - http://tronixstuff.wordpress.com/2011/01/27/the-555-precision-timer-ic/
 - http://lateblt.tripod.com/proj2.htm
 - http://www.robotroom.com/Infrared555.html
 - [PWM](http://www.dprg.org/tutorials/2005-11a/index.html) with 555

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



VARIOUS
-------
 - http://provideyourown.com/2011/analogwrite-convert-pwm-to-voltage/
 - http://www.ifixit.com
 - http://bildr.org/2012/03/rfp30n06le-arduino/
 - http://www.instructables.com/id/Attiny254585-PWM-generator-and-Servo-tester/
 - [Hardware Random Number Generator](http://iank.org/trng.html)


BUS PIRATE
----------

 - [AVR programming](http://dangerousprototypes.com/docs/Bus_Pirate_AVR_Programming)
 - http://dangerousprototypes.com/docs/Bus_Pirate_I/O_Pin_Descriptions

STORE&BLOGS
-----------

 - http://www.radioshack.com
 - http://www.digikey.com
 - http://www.sparkfun.com
 - http://littlebirdelectronics.com
 - http://www.seeedstudio.com
 - http://shop.moderndevice.com/
 - http://www.beavisaudio.com/techpages/
 - http://dx.com
 - http://bildr.org/
 - http://it.rs-online.com
