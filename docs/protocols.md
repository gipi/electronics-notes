# Protocols

Electronics is about voltage and stuffs but as humans we use it for
connect devices and devices connected need ways to communicate.

## UART and Serial

 - http://wiki.openwrt.org/doc/hardware/port.serial
 - http://www.devttys0.com/2012/11/reverse-engineering-serial-ports/

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
