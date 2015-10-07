# Integrated circuit

## Logic levels

In the digital world, where exist only 1 and 0 you have to decide which
voltage is one or the other: these are the logic levels.

During the years, with the improvements of technology, the actual value of the
logic level assigned to the value ``HIGH`` is diminished from 5V to 3.3V, to
2.5V to 1.8V and 1.5V.

It's usually indicated as **TTL** that means Transistor-Transistor Logic.

Connected system with different logic levels must use a logic level converter to
avoid damaging the device al lower voltage (also to avoid missing ``HIGH``
signal from ``LOW`` level device).

 - [Sparkfun's page](https://learn.sparkfun.com/tutorials/logic-levels/ttl-logic-levels)
 - [Cookbook](/cookbook/#logic-level-converter)

## Buffer

A buffer (like all logic gates) is an active device. It requires
additional inputs to power the gate, and provide it voltage and current.

Digital Buffers can be used to isolate other gates or circuit stages
from each other preventing the impedance of one circuit from affecting
the impedance of another. A digital buffer can also be used to drive
high current loads such as transistor switches because their output
drive capability is generally much higher than their input signal
requirements. In other words buffers can be used for power amplification
of a digital signal as they have what is called a high “fan-out”
capability.

 - http://www.electronics-tutorials.ws/logic/logic_9.html

## Circuit Packages

[Slide](http://security.cs.rpi.edu/courses/hwre-spring2014/Lecture2_Packaging.pdf) with some
history and ratio about packages

 - DIP/DIL: Dual In Line, through hole component
 - SOIC: Small Outline IC, surface mount component
 - SOT: Small-outline transistor
 - QFN: Quad Flat No leads
 - QFP: Quad Flat Packages
 - LQFP: Low-profile quad flat packages
 - TQFP: Thin quad flat packages

### Links

 - http://how-to.wikia.com/wiki/Guide_to_IC_packages
 - Sparkfun's [tutorial](https://learn.sparkfun.com/tutorials/integrated-circuits)
