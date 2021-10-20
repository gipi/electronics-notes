# Integrated circuit

 - [SMD code book](http://www.marsport.org.uk/smd/mainframe.htm)

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
 - [Designing With Logic](http://www.ti.com/lit/an/sdya009c/sdya009c.pdf)

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
 - [How to Build a Buffer Circuit with a Transistor](http://www.learningaboutelectronics.com/Articles/Transistor-buffer-circuit.php) a little overlong explanation

## Open collector mode

In this mode a pin has two possible state: connected to ``GND`` (probably via a transistor)
or open circuit.

An advantage is that more than one open-collector output can connect to a
single line. If all outputs attached to the line are in the high-impedance
state, the pull-up resistor will hold the wire in a high voltage (logic 1)
state. If one or more device outputs are in the logic 0 (ground) state, they
will sink current and pull the line voltage toward ground.

 - [Open Collector Outputs](http://www.evilmadscientist.com/2012/basics-open-collector-outputs/)
 - [Page of wikipedia](https://en.wikipedia.org/wiki/Open_collector)
 - [Introduction to Wired-OR Outputs and Open-Collector Circuits](http://www.ni.com/white-paper/3544/en/)
 - [Choosing an Appropriate Pull-up/Pull-down Resistor for Open Drain Outputs](http://www.ti.com/lit/an/slva485/slva485.pdf)

## Circuit Packages

[Slide](http://security.cs.rpi.edu/courses/hwre-spring2014/Lecture2_Packaging.pdf) with some
history and ratio about packages

 - DIP/DIL: Dual In Line, through hole component
 - SOIC: Small Outline IC, surface mount component
 - SOT: Small-outline transistor ([wikipedia page](https://en.wikipedia.org/wiki/Small-outline_transistor))
 - QFN: Quad Flat No leads
 - QFP: Quad Flat Packages
 - LQFP: Low-profile quad flat packages
 - TQFP: Thin quad flat packages

### Links

 - http://how-to.wikia.com/wiki/Guide_to_IC_packages
 - Sparkfun's [tutorial](https://learn.sparkfun.com/tutorials/integrated-circuits)
 - [TI's application note about packaging](ti.com/lit/sl/sszb138a/sszb138a.pdf)

## SHIFT REGISTER

It's an integrated circuit that allows to multiplex from one input, multiple outputs.

The *shift* term in its name refers to the fact that data is entered serially from
a unique pin and the existing data is shifted by one place at times.
Tipically they work with a minimum of three input pins:

 - ``SRCLK``: the serial clock that decides (by its raising edge) when shift the register
 - ``SER``: serial pin that decides what value must be inserted in the new register
 - ``RCLK``: register clock that decides (by its raising edge) what value store in the new register

In practice you usually present the value with which you want to configure the output pins
alternating a raising edge with ``SRCLK`` and using the ``SER`` pin for each value; during
this operation the ``RCLK`` must be tied ``LOW`` to avoid the updating of the output pins,
only when you are happy with the values ``RCLK`` must be tied ``HIGH``.

 - http://arduino.cc/en/Tutorial/ShiftOut
 - http://bildr.org/2011/02/74hc595/
 - http://www.makeuseof.com/tag/arduino-programming-playing-shift-registers-aka-leds/
