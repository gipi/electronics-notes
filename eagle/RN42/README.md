Simple breakout board to use with the RN42 bluetooth module.

This breakout exposes only the ``UART`` signals; can be used
with a voltage level different from the original 3.3V at which
is operating the RN42 module since this breakout contains a
voltage regulator and some components that do the conversion
for you from one logic level to another.

For more informations read the original [datasheet](0900766b811a8f51.pdf).

## Connect to

After a factory reset you need to enter (via ``UART``) the following

```
SA,0
R,1
```

otherwise it doesn't allow connection to it.

In order to find the address you can use ``hcitool`` and then connect

```
$ hcitool scan
Scanning ...
        00:06:66:7B:8B:4A       n/a
$ sudo rfcomm connect rfcomm0 00:06:66:7B:8B:4A
Connected /dev/rfcomm0 to 00:06:66:7B:8B:4A on channel 1
Press CTRL-C for hangup
```

From another terminal finally you can access the wireless ``UART``

```
$ sudo screen /dev/rfcomm0 115200 8N1
```

## Links

 - [wiki](https://eewiki.net/display/Wireless/Getting+Started+with+RN42+Bluetooth+Module)

## TODO

 - add tolerance values on the back
 - add pin for ``FACTORY_RESET`` or a button
 - add logic level shifter for ``CTS`` and ``RTS`` (**do not use them, the board is broken, you must solder the jumper SJ5**)
