# BUS PIRATE


[Home](http://dangerousprototypes.com/docs/Bus_Pirate)

In order to use bus pirate you have to connect to it with a serial terminal; I will use the terminal
included with the PySerial (``# pip install pyserial``)

    $ python -m serial.tools.miniterm /dev/ttyUSB0 --baud=115200 --lf

(if you want is possible to use screen: ``screen /dev/ttyUSB0 115200 8N1``).

Follow the [cable pinout](http://dangerousprototypes.com/docs/Common_Bus_Pirate_cable_pinouts)

```
    UART>i
    Bus Pirate v3a
    Firmware v5.10 (r559)  Bootloader v4.4
    DEVID:0x0447 REVID:0x3046 (24FJ64GA002 B8)
    http://dangerousprototypes.com
    CFG1:0xFFDF CFG2:0xFF7F
    *----------*
    Pinstates:
    1.(BR)	2.(RD)	3.(OR)	4.(YW)	5.(GN)	6.(BL)	7.(PU)	8.(GR)	9.(WT)	0.(Blk)
    GND	        3.3V	5.0V	ADC	VPU	AUX	-	TxD	-	RxD
    P	        P	P	I	I	I	I	I	I	I	
    GND	        0.00V	0.00V	0.00V	0.00V	L	L	H	L	L	
    Power supplies OFF, Pull-up resistors OFF, Normal outputs (H=3.3v, L=GND)
    MSB set: MOST sig bit first, Number of bits read/write: 8
    a/A/@ controls AUX pin
    UART (spd brg dbp sb rxp hiz)=( 8 34 0 0 0 0 )
    *----------*
```

In order to connect to the an UART port

```
$ python -m serial.tools.miniterm /dev/ttyUSB0 --baud=115200 --lf
--- Miniterm on /dev/ttyUSB0: 115200,8,N,1 ---
--- Quit: Ctrl+]  |  Menu: Ctrl+T | Help: Ctrl+T followed by Ctrl+H ---

HiZ>m
1. HiZ
2. 1-WIRE
3. UART
4. I2C
5. SPI
6. 2WIRE
7. 3WIRE
8. LCD
9. DIO
x. exit(without change)

(1)>3
```



## Links

 - http://dangerousprototypes.com/docs/Practical_guide_to_Bus_Pirate_pull-up_resistors
 - http://nada-labs.net/2010/using-the-buspirate-with-a-sd-card/
 - http://wiki.yobi.be/wiki/Bus_Pirate
 
## Logic Analyzer
 
 - http://www.hobbytronics.co.uk/bus-pirate-logic-sniffer
 - http://codeandlife.com/2012/05/05/logic-analysis-with-bus-pirate/
 - https://github.com/syntelos/jlac
 - http://www.lxtreme.nl/ols/

| channel | input | color |
|---------|-------|-------|
| 0 | CS | red|
| 1 | MISO | brown |
| 2 | CLK  | yellow |
| 3     | MOSI | orange |
| 4     | AUX  | green |
|  |GND  | black |

## Oscilloscope

 - https://github.com/tgvaughan/PirateScope
