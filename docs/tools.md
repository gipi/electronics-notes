## Oscilloscope

The main parameter is the bandwidth: as explainded by [Adafruit](https://blog.adafruit.com/2012/01/27/why-oscilloscope-bandwidth-matters/)
*The bandwidth of an oscilloscope actually indicates the point at which
the measured amplitude on an amplitude/frequency chart has decreased by
-3dB (or 70.7%) of the original value*

Also this [SO answer](http://electronics.stackexchange.com/questions/8565/oscilloscope-bandwidth-whats-it-all-about) explain it pretty well.

[Here](Datasheets/Tektronix12_things_to_consider1.pdf) a guide from [Mouser](http://www.mouser.com/pdfdocs/Tektronix12_things_to_consider1.pdf)

 - [Basics of using FFT on an oscilloscope](https://www.youtube.com/watch?v=oRf-IpG6XAw)
 - [Why is 30MHz Clock signal distorted on oscilloscope?](https://electronics.stackexchange.com/questions/334082/why-is-30mhz-clock-signal-distorted-on-oscilloscope)
 - [What can reduce overshoot and ringing on a simple square wave pulse generator?](https://electronics.stackexchange.com/questions/79717/what-can-reduce-overshoot-and-ringing-on-a-simple-square-wave-pulse-generator/)
 - [Understanding Oscilloscope Bandwidth, Rise Time and Signal Fidelity](https://www.ece.ubc.ca/~robertor/Links_files/Files/TEK-Understanding-Scope-BW-tr-Fidelity.pdf)
 - [ABCs of Probes](http://web.mit.edu/6.101/www/reference/ABCprobes_s.pdf)

## Logic analyzer

For example exists one device named ``Saleae logic`` that has 8 channels and 24MHz sampling.
It identifies itself as

```
$ lsusb
 ...
Bus 003 Device 009: ID 0925:3881 Lakeview Research Saleae Logic
 ...
```

It's possible to use it out of the box in a Debian machine installing the
following packages:

```
# apt-get install pulseview sigrok sigrok-cli sigrok-firmware-fx2lafw
```

```
$ sigrok-cli --scan
The following devices were found:
demo - Demo device with 12 channels: D0 D1 D2 D3 D4 D5 D6 D7 A0 A1 A2 A3
fx2lafw - Saleae Logic with 8 channels: 0 1 2 3 4 5 6 7
```

the last one is the device of interest; select from ``pulseview`` the menu ``File > Connect to device``
and then the driver ``fx2lafw`` and select ``Scan for devices``.

It's also possible to use directly the ``saleae`` software downloadable from [here](https://www.saleae.com/downloads).

## Heat gun

 - https://electronics.stackexchange.com/questions/15913/want-to-get-a-heat-gun-for-smt-what-should-i-get
 - Sparkfun's [tutorial](https://www.sparkfun.com/tutorials/391) *How to use Hot-air a Rework Station*
 - Adafruit's [post](https://learn.adafruit.com/smt-manufacturing/hot-air-tools) with an interesting video inside
 - Basic [video](https://www.youtube.com/watch?v=1z0IiuQ35HU) about using solder paste and hot air for SMD soldering
 - Video about reballing a BGA chip with solder paste+hot air+stencil: [BGA soldering P_05 chip reball](https://www.youtube.com/watch?v=aYUf27m3Sbo)

## CNC

 - [linuxCNC](http://linuxcnc.org/)
 - [GRBL](https://github.com/gnea/grbl) An open source, embedded, high performance g-code-parser and 
   CNC milling controller written in optimized C that will run on a straight Arduino. It's possible to
   use it with ``EasyDriver`` (see [wiki](https://github.com/grbl/grbl/wiki/Connecting-Grbl))
