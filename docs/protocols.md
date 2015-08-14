# Protocols

Electronics is about voltage and stuffs but as humans we use it for
connect devices and devices connected need ways to communicate.

## UART and Serial

 - http://wiki.openwrt.org/doc/hardware/port.serial
 - http://www.devttys0.com/2012/11/reverse-engineering-serial-ports/

## SPI

It's a protocol with a clock line and a differentiation between devices that can be
**master** (that provides clock) or **slave**. Although may there be only one master
there is a signal (**SS**) that indicates which one of the (possible) multiple slaves
must respond.

It has the disadvantage that the communication must be well defined in advance since the
master must know how many clock cycle need to listen from the slaves.

### SD Card

For example an SD Card use this protocol (see a link in the Bus Pirate page) how you can
read [here](http://elm-chan.org/docs/mmc/mmc_e.html) and [here](http://www.dejazzer.com/ee379/lecture_notes/lec12_sd_card.pdf).

The pin ``CD`` stand for **card detection**: when is low the card is inserted into its socket.

### Links

 - https://learn.sparkfun.com/tutorials/serial-peripheral-interface-spi
 - [Reference](https://www.sdcard.org/downloads/pls/part1_410.pdf) for SD card protocol

## JTAG


It's a protocol used to _debug hardware_ and uses the following pins that constitute the **TAP**,
the Test Access Port:

 - **TMS:** Test Mode Select. This pin is used to cycle through the TAP-state machine.
 - **TCK:** Test Clock.
 - **TDI:** Test Data In. Serial input data to be shifted in to the Instruction Register or Data Register.
 - **TDO:** Test Data Out.  Serial output data from Instruction Register or Data Register.

Usually on reference is indicated also the **VTRef** pin that indicates what is the voltage reference
for the 

 - https://hackingbtbusinesshub.wordpress.com/2012/01/26/discovering-jtag-pinouts/
 - http://sun.hasenbraten.de/~frank/docs/mpc824x_JTAG.html
 - Header per SOC da [farnell](http://uk.farnell.com/fci/20021121-00010c4lf/connector-header-smt-r-a-1-27mm/dp/1865279?ost=609-3695-1-ND)
 - [Slide](http://elinux.org/images/d/d6/Jtag.pdf) of a talk about finding JTAG's pinout
 - https://github.com/cyphunk/JTAGenum/
 - http://www.sodnpoo.com/posts.xml/pace4000_jtag.xml
 - https://www.youtube.com/watch?v=TlWlLeC5BUs
 - http://electronics.stackexchange.com/questions/53311/why-jtag-connectors-are-available-in-10pins-14pins-20pins-when-jtag-is-of-5pins

## USB

This is a well known protocol, used everywhere in electronics devices, the acronym means **Universal Serial Bus**.

This protocol can work at three defined speeds

|Name | Speed |
|-----|-----------|
|Low  | 1.5Mbit/s |
|Full | 12Mbit/s  |
|High | 480Mbit/s |

The architecture of this protocol is *tiered star topology*, there can be no communication directly between USB devices.

 - [USB Central](http://janaxelson.com/usb.htm)
 - http://www.usbmadesimple.co.uk/ums_2.htm
