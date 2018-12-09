# Keyboard matrix recovery

This Arduino sketch tries to recovery the matrix of a keyboard.

In the ``pins`` array there is the list of the pins used to look
for connections: the original program runs in an ``Arduino Mega``,
should be easily portable in other arduinos or microcontrollers, given
that you have enough pins available (in my original setup I needed like
24 pins).

## TODO

 - [x] POC of key matrix recovery
 - [x] binary protocol
 - [ ] PC side application that speaks with this sketch and generate a configuration file of the matrix
   - [x] parse binary input
   - [x] build matrix asking the user to press one key a time
   - [x] dump matrix
   - [ ] load matrix
