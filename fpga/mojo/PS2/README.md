# PS2 controller

Quick and dirty ``Verilog`` code taken from the book "FPGA protopying by Verilog examples",
with the debouncing code (re)moved from the controller.

At first I thought that the debouncing module wasn't necessary but experimenting
with real hardware (probably not well engineered) make me realize the opposite.

## TODO

 - error detection
 - watchdog
 - obtain ASCII code of the pressed key

## Links

 - [Interfacing the AT keyboard](http://retired.beyondlogic.org/keyboard/keybrd.htm)
