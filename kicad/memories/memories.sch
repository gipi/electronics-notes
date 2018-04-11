EESchema Schematic File Version 2
LIBS:power
LIBS:device
LIBS:switches
LIBS:relays
LIBS:motors
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
LIBS:memories
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L NAND512 U?
U 1 1 5AC5E350
P 4600 3850
F 0 "U?" H 4600 4450 60  0000 C CNN
F 1 "NAND512" H 4600 3850 60  0000 C CNN
F 2 "" H 4950 3900 60  0001 C CNN
F 3 "" H 4950 3900 60  0001 C CNN
	1    4600 3850
	1    0    0    -1  
$EndComp
$Comp
L Conn_01x08 J?
U 1 1 5AC5E381
P 6650 3300
F 0 "J?" H 6650 3700 50  0000 C CNN
F 1 "Conn_01x08" H 6650 2800 50  0000 C CNN
F 2 "" H 6650 3300 50  0001 C CNN
F 3 "" H 6650 3300 50  0001 C CNN
	1    6650 3300
	1    0    0    -1  
$EndComp
$Comp
L Conn_01x08 J?
U 1 1 5AC5E3E2
P 2700 3500
F 0 "J?" H 2700 3900 50  0000 C CNN
F 1 "Conn_01x08" H 2700 3000 50  0000 C CNN
F 2 "" H 2700 3500 50  0001 C CNN
F 3 "" H 2700 3500 50  0001 C CNN
	1    2700 3500
	-1   0    0    1   
$EndComp
Wire Wire Line
	2900 3100 3000 3100
Wire Wire Line
	2900 3200 3000 3200
Wire Wire Line
	4500 2700 4700 2700
Wire Wire Line
	4600 2700 4600 2600
Connection ~ 4600 2700
Wire Wire Line
	4700 4400 4500 4400
Wire Wire Line
	4600 4400 4600 4550
Connection ~ 4600 4400
Text Label 4600 2600 0    60   ~ 0
VCC
Text Label 4600 4550 0    60   ~ 0
GND
Text Label 3000 3200 0    60   ~ 0
GND
Text Label 3000 3100 0    60   ~ 0
VCC
Wire Wire Line
	2900 3300 3400 3300
Wire Wire Line
	3400 3300 3400 3100
Wire Wire Line
	3400 3100 3950 3100
Wire Wire Line
	2900 3400 3450 3400
Wire Wire Line
	3450 3400 3450 3250
Wire Wire Line
	3450 3250 3950 3250
Wire Wire Line
	2900 3500 3500 3500
Wire Wire Line
	3500 3500 3500 3400
Wire Wire Line
	3500 3400 3950 3400
Wire Wire Line
	2900 3600 3550 3600
Wire Wire Line
	3550 3600 3550 3550
Wire Wire Line
	3550 3550 3950 3550
Wire Wire Line
	2900 3700 3950 3700
Wire Wire Line
	2900 3800 3750 3800
Wire Wire Line
	3750 3800 3750 3850
Wire Wire Line
	3750 3850 3950 3850
Wire Wire Line
	5250 3050 6250 3050
Wire Wire Line
	6250 3050 6250 3000
Wire Wire Line
	6250 3000 6450 3000
Wire Wire Line
	5250 3150 6250 3150
Wire Wire Line
	6250 3150 6250 3100
Wire Wire Line
	6250 3100 6450 3100
Wire Wire Line
	5250 3250 6250 3250
Wire Wire Line
	6250 3250 6250 3200
Wire Wire Line
	6250 3200 6450 3200
Wire Wire Line
	5250 3350 6250 3350
Wire Wire Line
	6250 3350 6250 3300
Wire Wire Line
	6250 3300 6450 3300
Wire Wire Line
	5250 3450 6250 3450
Wire Wire Line
	6250 3450 6250 3400
Wire Wire Line
	6250 3400 6450 3400
Wire Wire Line
	5250 3550 6250 3550
Wire Wire Line
	6250 3550 6250 3500
Wire Wire Line
	6250 3500 6450 3500
Wire Wire Line
	5250 3650 6400 3650
Wire Wire Line
	6400 3650 6400 3600
Wire Wire Line
	6400 3600 6450 3600
Wire Wire Line
	5250 3750 6400 3750
Wire Wire Line
	6400 3750 6400 3700
Wire Wire Line
	6400 3700 6450 3700
$EndSCHEMATC
