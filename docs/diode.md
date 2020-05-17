# Diodes

This is **passive** semiconductor device that allows (usually) the flowing of current
only in one direction (this is called a **rectifier**). It doesn't obey Ohm law
(i.e. it's **not linear**) and if you put it in a circuit, it won't have a Thevenin equivalent.

The main parameters for a diode are

 - the forward voltage drop
 - the leaking current

but you can consider also

 - maximum forward current
 - capacitance
 - reverse recovery time

The schematics element is the following

![diode](Images/diode.png)

with the arrow indicating the flow of current; usually there is a drop
of 0.6V between anode and catode.

A diode in a circuit can be used as

 - signal rectifier
 - gates
 - clamps and limiter
 - non-linear element

see [this video](https://www.youtube.com/watch?v=zhrt1y0NP8M) with a couple of examples.

## Zener

A Zener diode behaves differently from a normal diode: has a reverse-breakdown current
pre-determined and can be used as a voltage regulator. In other words, it allows flow
in both directions, it's like having two diodes in parallel with different voltage drops.

 - What is a zener diode? [Video](https://www.youtube.com/watch?v=xSQHfsHTS88)
 - [Video](https://www.youtube.com/watch?v=F9w5r5l0J8Y) about using it with OpAmp

## Schottky

Are another kind of diode with lower forward voltage drop and fast switching speed but
with greater leakage current.

 - [video](https://www.youtube.com/watch?v=bXEyCf1P0UU) by Afrotechmods

## Links

 - [Sparkfun's tutorial](https://learn.sparkfun.com/tutorials/diodes)
 - [The Zener Diode](http://www.electronics-tutorials.ws/diode/diode_7.html) by Electronics Tutorial
