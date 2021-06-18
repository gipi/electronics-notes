# Protocols&Interfaces

Electronics is about voltage and stuffs but as humans we use it for
connect devices and devices connected need ways to communicate.

![](Images/connectors.jpg)

## PWM

The acronym means **Pulse Width Modulation** and it's the simplest
way to digitally encode a signal using a single wire; it's defined
by the **duty cycle**, i.e. the percentage of the cycle that the
signal is on (0% is always off, 100% is always on) and its **switching frequency**,
that identify how many seconds each raising edge appears.

Its fourier transformed form is given by this coefficients ($p$ is the duty cycle
$0\leq p\leq 1$)

$$
A_0 = K\cdot p
$$
$$
A_n = K\cdot {1\over n\pi}\left(\sin(n\pi p) - \sin\left(2n\pi (1 - p/2)\right)\right)
$$

 - [PWM Distortion Analysis](http://www.openmusiclabs.com/learning/digital/pwm-dac/pwm-distortion-analysis/index.html)

## UART and Serial

The simplest of protocols without needing a clock line, usually it's exposed
as a 4 pins header but it's also possible to be exposed via already used IO
port (like [headphone socket](http://www.pabr.org/consolejack/consolejack.en.html) or
USB port via [USB port multimedia switch](https://www.fairchildsemi.com/datasheets/FS/FSA9280A.pdf)).

 - http://wiki.openwrt.org/doc/hardware/port.serial
 - http://www.devttys0.com/2012/11/reverse-engineering-serial-ports/
 - [Chapter](http://users.ece.utexas.edu/~valvano/Volume1/E-Book/C11_SerialInterface.htm) about design of a USART interface

## I2C

It uses only two wires, and allows to connect up to 1008 slave devices.

 - [I2C in a Nutshell](https://interrupt.memfault.com/blog/i2c-in-a-nutshell)

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
 - [Reference](https://web.archive.org/web/20131205014133/https://www.sdcard.org/downloads/pls/simplified_specs/archive/part1_301.pdf) for SD card protocol
 - [SD Card Protocol](http://wiki.seabright.co.nz/wiki/SdCardProtocol.html)
 - [Interfacing Microcontrollers with SD Card](https://openlabpro.com/guide/interfacing-microcontrollers-with-sd-card/)
 - [Interfacing Micro SD Card Module with Arduino](https://lastminuteengineers.com/arduino-micro-sd-card-module-tutorial/)
 - [SPI and SD cards](http://www.dejazzer.com/ee379/lecture_notes/lec12_sd_card.pdf)

## PS/2

 - [Protocol description](http://www.computer-engineering.org/ps2protocol/)

## JTAG


It's a protocol used to _debug hardware_ and uses the following pins that constitute the **TAP**,
the Test Access Port:

 - **TMS:** Test Mode Select. This pin is used to cycle through the TAP-state machine.
 - **TCK:** Test Clock.
 - **TDI:** Test Data In. Serial input data to be shifted in to the Instruction Register or Data Register.
 - **TDO:** Test Data Out.  Serial output data from Instruction Register or Data Register.

There are also some optional pins:

 - ``TRST``: ``TAP`` reset, optional because is always possible to out the state machine to a start state
 - ``SRST``: system reset, allows to reset the system

Usually on reference is indicated also the **VTRef** pin that indicates what is the voltage reference
for the signals.

![](Images/jtag-stack.png)

 - [JTAG explained](http://blog.senr.io/blog/jtag-explained)
 - [How JTAG works](http://www.fpga4fun.com/JTAG2.html)
 - [Debugging with JTAG](http://elinux.org/images/5/56/DebuggingWithJtagCelf2009.pdf)
 - https://hackingbtbusinesshub.wordpress.com/2012/01/26/discovering-jtag-pinouts/
 - http://sun.hasenbraten.de/~frank/docs/mpc824x_JTAG.html
 - Header per SOC da [farnell](http://uk.farnell.com/fci/20021121-00010c4lf/connector-header-smt-r-a-1-27mm/dp/1865279?ost=609-3695-1-ND)
 - [Slide](http://elinux.org/images/d/d6/Jtag.pdf) of a talk about finding JTAG's pinout
 - [JTAGEnum](https://github.com/cyphunk/JTAGenum/) Given an Arduino compatible microcontroller JTAGenum scans pins for basic JTAG functionality.
 - http://www.sodnpoo.com/posts.xml/pace4000_jtag.xml
 - https://www.youtube.com/watch?v=TlWlLeC5BUs
 - http://electronics.stackexchange.com/questions/53311/why-jtag-connectors-are-available-in-10pins-14pins-20pins-when-jtag-is-of-5pins
 - https://github.com/syncsrc/jtagsploitation
 - [Video](https://www.youtube.com/watch?v=Up0697E5DGc) Blackbox JTAG Reverse Engineering [26C3]
 - [Preparing Raspberry PI for JTAG Debugging](http://sysprogs.com/VisualKernel/tutorials/raspberry/jtagsetup/)
 - [Black Magic Probe V2](http://1bitsquared.de/products/black-magic-probe) is a JTAG and SWD Adapter used for programming and debugging ARM Cortex MCUs.
 - [Using a JTAG in Linux Driver Debugging](http://elinux.org/images/f/ff/JTAG_In_Linux_Driver_Debug_Anderson.pdf)
 - [Can I use JTAG to debug my program on top of embedded Linux?](https://stackoverflow.com/questions/8755594/can-i-use-jtag-to-debug-my-program-on-top-of-embedded-linux)
 - [The JTAG Interface: AN ATTACKER’S PERSPECTIVE](https://optivstorage.blob.core.windows.net/web/file/55e86eae3f04450d9bafcbb3a94559ca/JTAG.Whitepaper.pdf)
 - [Re-enabling JTAG and Debugging the WRT120N](http://www.devttys0.com/2014/02/re-enabling-jtag-and-debugging-the-wrt120n/)
 - [Locating JTAG pins automatically](http://elinux.org/images/d/d6/Jtag.pdf)
 - The [jrev](http://nsa.unaligned.org/jrev.php) tool tries to automate the process of reverse-engineering the board connectivity. It probes all pairs of JTAG-scannable pins on the board.
 - [Practical JTAG: From 0 to 1](https://cansecwest.com/slides/2018/Practical%20JTAGfrom%200%20to%201%20-%20hyperchem,%20Tencent's%20XuanwulLab.pdf)
 - [SWD – ARM’S ALTERNATIVE TO JTAG](https://research.kudelskisecurity.com/2019/05/16/swd-arms-alternative-to-jtag/)

### OpenOCD

 - [OpenOCD Configuration for Ethernut 5](http://www.ethernut.de/en/hardware/enut5/openocd.html)
 - [Seagate Dockstar JTAG Interface](https://www.rudiswiki.de/wiki/DockStarJTAG) example of Bus Pirate + OpenOCD configuration and use

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
 - [USB cables: shielding matters as well...](https://www.yoctopuce.com/EN/article/usb-cables-shielding-matters-as-well)
 - [High-Speed Interface Layout Guidelines](https://www.ti.com/lit/an/spraar7h/spraar7h.pdf)
 - [TS3USB211 datasheet](https://www.ti.com/lit/ds/symlink/ts3usb221.pdf)

## VGA

 - [VGA On The Arduino With No External Parts Or CPU!](http://dpeckett.com/vga-on-the-arduino-with-no-external-parts)
 - [VGA (Video Graphics Array) Interface and video signal documents](http://martin.hinner.info/vga/)
 - [VGA Controller (VHDL)](https://eewiki.net/pages/viewpage.action?pageId=15925278)
 - [CS/EE 3710 - Computer Design Lab - Lab 3 – VGA](http://www.eng.utah.edu/~cs3710/labs/VGA.pdf)
 - [VGA Text-mode](http://www.flingos.co.uk/docs/reference/VGA-Text-Mode/)
 - [Hardware Level VGA and SVGA Video Programming Information Page](http://www.osdever.net/FreeVGA/vga/vgatext.htm)

## GPS

 - [Homemade GPS Receiver](http://www.aholme.co.uk/GPS/Main.htm)
 
## Dialup

Below the image of the handshake, for more explanation, refer to this [post](https://www.windytan.com/2012/11/the-sound-of-dialup-pictured.html)

![](https://oona.windytan.com/posters/dialup-final.png)

## Eink display

 - [Driving E-ink display](http://essentialscrap.com/eink/index.html)
 - [Wifi E-ink display](http://spritesmods.com/?art=einkdisplay)

## Floppy driver

 - [Floppy Disk Notes](https://www.wdj-consulting.com/blog/floppy-lit/)
 - [Preserving a floppy disk with a logic analyzer and a serial cable](https://www.chzsoft.de/site/hardware/preserving-a-floppy-disk-with-a-logic-analyzer/)
 - [Recovering "lost" treasure-filled floppy discs with an oscilloscope](https://scarybeastsecurity.blogspot.com/2021/05/recovering-lost-treasure-filled-floppy.html)
 - [keirf/Greaseweazle](https://github.com/keirf/Greaseweazle): Tools and USB interface for accessing a floppy drive at the raw flux level

## TLS

 - [The Illustrated TLS Connection](https://tls.ulfheim.net/)
