# Cookbook

Some recipes of common used circuits.


## Reverse polarity

Normally you would use a diode to protect your circuit from reverse polarity
but has some problems

 - voltage drop
 - power consumption

A more efficient way is to use P-FETs [(source here)](https://www.youtube.com/watch?v=IrB-FPcv1Dc).
See also this [link from instructables](http://www.instructables.com/id/Reverse-polarity-protection-for-your-circuit-with/).

## Inductive spike

A flyback diode can be used to limit damage when an inductive load uses a
varying current [(source)](https://www.youtube.com/watch?v=LXGtE3X2k7Y).
