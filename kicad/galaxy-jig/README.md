# Galaxy JIG

This is a board to easily develop on Samsung's smartphones that have the serial
port activated using a particular resistor value between the ``ID`` and ``GND``
of the ``USB`` connection.

To multiplex between the two possible routes I'm using the
[ADG723](https://www.analog.com/media/en/technical-documentation/data-sheets/adg721_722_723.pdf),
a STSP switch. and the ``mode`` signal as input for the mux.

![](pcb.jpg)

